#!/usr/bin/env python3
import argparse, json, os, sqlite3, time, uuid
from pathlib import Path

DB = Path(os.environ.get("EVA_STATE_DB", Path.home() / "eva" / "state" / "eva_continuity.sqlite3"))
SCHEMA = """
CREATE TABLE IF NOT EXISTS tasks(
 id TEXT PRIMARY KEY, title TEXT NOT NULL, priority INTEGER NOT NULL DEFAULT 50,
 status TEXT NOT NULL DEFAULT 'queued', next_action TEXT, result TEXT, evidence TEXT,
 depends_on TEXT, lease_until REAL, created_at REAL NOT NULL, updated_at REAL NOT NULL
);
CREATE TABLE IF NOT EXISTS cycles(
 id TEXT PRIMARY KEY, started_at REAL NOT NULL, finished_at REAL, task_id TEXT, status TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS events(
 id INTEGER PRIMARY KEY AUTOINCREMENT, ts REAL NOT NULL, kind TEXT NOT NULL,
 task_id TEXT, cycle_id TEXT, data TEXT NOT NULL
);
"""

def conn():
    DB.parent.mkdir(parents=True, exist_ok=True)
    c = sqlite3.connect(DB, timeout=15)
    c.row_factory = sqlite3.Row
    c.execute("PRAGMA journal_mode=WAL")
    c.executescript(SCHEMA)
    return c

def emit(c, kind, task_id=None, cycle_id=None, data=None):
    c.execute(
        "INSERT INTO events(ts,kind,task_id,cycle_id,data) VALUES(?,?,?,?,?)",
        (time.time(), kind, task_id, cycle_id, json.dumps(data or {}, ensure_ascii=False, sort_keys=True))
    )

def init(a):
    with conn() as c:
        emit(c, "store_initialized", data={"db": str(DB)})
    print(json.dumps({"ok": True, "db": str(DB)}))

def add(a):
    now = time.time()
    task_id = "task_" + uuid.uuid4().hex[:12]
    with conn() as c:
        c.execute(
            "INSERT INTO tasks(id,title,priority,next_action,depends_on,created_at,updated_at) VALUES(?,?,?,?,?,?,?)",
            (task_id, a.title, a.priority, a.next_action, a.depends_on or None, now, now)
        )
        emit(c, "task_added", task_id, data={"title": a.title, "priority": a.priority})
    print(json.dumps({"task_id": task_id, "status": "queued"}, ensure_ascii=False))

def wake(a):
    now = time.time()
    with conn() as c:
        c.execute(
            "UPDATE tasks SET status='queued',lease_until=NULL,updated_at=? WHERE status='running' AND lease_until<?",
            (now, now)
        )
        row = c.execute("""
            SELECT t.* FROM tasks t
            WHERE t.status='queued'
              AND (t.depends_on IS NULL OR t.depends_on=''
                   OR EXISTS(SELECT 1 FROM tasks d WHERE d.id=t.depends_on AND d.status='completed'))
            ORDER BY t.priority DESC, t.created_at ASC LIMIT 1
        """).fetchone()
        if row is None:
            result = {"task": None}
        else:
            cycle_id = "cycle_" + uuid.uuid4().hex[:12]
            lease_until = now + a.lease * 60
            c.execute("UPDATE tasks SET status='running',lease_until=?,updated_at=? WHERE id=?",
                      (lease_until, now, row["id"]))
            c.execute("INSERT INTO cycles(id,started_at,task_id,status) VALUES(?,?,?,'running')",
                      (cycle_id, now, row["id"]))
            emit(c, "task_woken", row["id"], cycle_id, {"lease_until": lease_until})
            result = {"task_id": row["id"], "title": row["title"], "next_action": row["next_action"],
                      "cycle_id": cycle_id, "lease_until": lease_until}
    print(json.dumps(result, ensure_ascii=False))

def complete(a):
    now = time.time()
    with conn() as c:
        cur = c.execute(
            "UPDATE tasks SET status='completed',result=?,evidence=?,lease_until=NULL,updated_at=? WHERE id=?",
            (a.result, a.evidence, now, a.task_id)
        )
        if cur.rowcount != 1:
            raise SystemExit("ERROR: task_id not found")
        c.execute("UPDATE cycles SET status='completed',finished_at=? WHERE task_id=? AND status='running'",
                  (now, a.task_id))
        emit(c, "task_completed", a.task_id, data={"result": a.result, "evidence": a.evidence})
    print(json.dumps({"task_id": a.task_id, "status": "completed"}))

def block(a):
    now = time.time()
    with conn() as c:
        cur = c.execute(
            "UPDATE tasks SET status='blocked',result=?,lease_until=NULL,updated_at=? WHERE id=?",
            (a.reason, now, a.task_id)
        )
        if cur.rowcount != 1:
            raise SystemExit("ERROR: task_id not found")
        c.execute("UPDATE cycles SET status='blocked',finished_at=? WHERE task_id=? AND status='running'",
                  (now, a.task_id))
        emit(c, "task_blocked", a.task_id, data={"reason": a.reason})
    print(json.dumps({"task_id": a.task_id, "status": "blocked"}))

def listing(a):
    with conn() as c:
        rows = [dict(r) for r in c.execute(
            "SELECT id,title,status,priority,next_action,depends_on,updated_at FROM tasks ORDER BY priority DESC,created_at"
        )]
    print(json.dumps(rows, ensure_ascii=False))

def history(a):
    with conn() as c:
        rows = [dict(r) for r in c.execute(
            "SELECT id,ts,kind,task_id,cycle_id,data FROM events ORDER BY id DESC LIMIT ?", (a.limit,)
        )]
    print(json.dumps(rows, ensure_ascii=False))

def verify(a):
    with conn() as c:
        integrity = c.execute("PRAGMA integrity_check").fetchone()[0]
        missing = [r[0] for r in c.execute("""
            SELECT t.id FROM tasks t
            WHERE t.depends_on IS NOT NULL AND t.depends_on!=''
              AND NOT EXISTS(SELECT 1 FROM tasks d WHERE d.id=t.depends_on)
        """)]
        result = {"integrity": integrity, "missing_dependencies": missing,
                  "ok": integrity == "ok" and not missing}
    print(json.dumps(result))
    if not result["ok"]:
        raise SystemExit(1)

p = argparse.ArgumentParser(description="EVA local continuity task store")
p.add_argument("--db", help="SQLite database path (or set EVA_STATE_DB)")
s = p.add_subparsers(dest="cmd", required=True)
q=s.add_parser("init"); q.set_defaults(fn=init)
q=s.add_parser("add"); q.add_argument("title"); q.add_argument("--priority",type=int,default=50); q.add_argument("--next-action",default=""); q.add_argument("--depends-on",default=""); q.set_defaults(fn=add)
q=s.add_parser("wake"); q.add_argument("--lease",type=float,default=30); q.set_defaults(fn=wake)
q=s.add_parser("complete"); q.add_argument("task_id"); q.add_argument("--result",default=""); q.add_argument("--evidence",default=""); q.set_defaults(fn=complete)
q=s.add_parser("block"); q.add_argument("task_id"); q.add_argument("--reason",required=True); q.set_defaults(fn=block)
q=s.add_parser("list"); q.set_defaults(fn=listing)
q=s.add_parser("history"); q.add_argument("--limit",type=int,default=20); q.set_defaults(fn=history)
q=s.add_parser("verify"); q.set_defaults(fn=verify)
a=p.parse_args()
if a.db:
    DB = Path(a.db).expanduser()
a.fn(a)
