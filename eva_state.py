#!/usr/bin/env python3
import argparse,json,os,sqlite3,time,uuid,sys
from pathlib import Path
DB=Path(os.environ.get("EVA_STATE_DB",Path.home()/"eva"/"state"/"eva_continuity.sqlite3"))
SCHEMA="""PRAGMA foreign_keys=ON; CREATE TABLE IF NOT EXISTS tasks(id TEXT PRIMARY KEY,title TEXT NOT NULL,priority INTEGER NOT NULL DEFAULT 50,status TEXT NOT NULL DEFAULT 'queued',next_action TEXT,result TEXT,evidence TEXT,depends_on TEXT,lease_until REAL,created_at REAL NOT NULL,updated_at REAL NOT NULL); CREATE TABLE IF NOT EXISTS cycles(id TEXT PRIMARY KEY,started_at REAL NOT NULL,finished_at REAL,task_id TEXT,status TEXT NOT NULL); CREATE TABLE IF NOT EXISTS events(id INTEGER PRIMARY KEY AUTOINCREMENT,ts REAL NOT NULL,kind TEXT NOT NULL,task_id TEXT,cycle_id TEXT,data TEXT NOT NULL);"""
def conn():
 DB.parent.mkdir(parents=True,exist_ok=True); c=sqlite3.connect(DB); c.row_factory=sqlite3.Row; c.executescript(SCHEMA); return c
def emit(c,k,tid=None,cid=None,data=None): c.execute("INSERT INTO events(ts,kind,task_id,cycle_id,data) VALUES(?,?,?,?,?)",(time.time(),k,tid,cid,json.dumps(data or {},ensure_ascii=False,sort_keys=True)))
def init(a): c=conn(); c.commit(); print(json.dumps({"ok":True,"db":str(DB)}))
def add(a):
 c=conn(); now=time.time(); tid="task_"+uuid.uuid4().hex[:12]; c.execute("INSERT INTO tasks(id,title,priority,next_action,depends_on,created_at,updated_at) VALUES(?,?,?,?,?,?,?)",(tid,a.title,a.priority,a.next_action,a.depends_on,now,now)); emit(c,"task_added",tid,data={"title":a.title}); c.commit(); print(json.dumps({"task_id":tid,"status":"queued"},ensure_ascii=False))
def wake(a):
 c=conn(); now=time.time(); c.execute("UPDATE tasks SET status='queued',lease_until=NULL,updated_at=? WHERE status='running' AND lease_until<?",(now,now)); r=c.execute("SELECT t.* FROM tasks t WHERE t.status='queued' AND (t.depends_on IS NULL OR t.depends_on='' OR NOT EXISTS(SELECT 1 FROM tasks d WHERE d.id=t.depends_on AND d.status!='completed')) ORDER BY t.priority DESC,t.created_at LIMIT 1").fetchone()
 if not r: c.commit(); print(json.dumps({"task":None})); return
 cid="cycle_"+uuid.uuid4().hex[:12]; lease=now+a.lease*60; c.execute("UPDATE tasks SET status='running',lease_until=?,updated_at=? WHERE id=?",(lease,now,r['id'])); c.execute("INSERT INTO cycles(id,started_at,task_id,status) VALUES(?,?,?,?)",(cid,now,r['id'],'running')); emit(c,'task_woken',r['id'],cid,{'lease_until':lease}); c.commit(); print(json.dumps({"task_id":r['id'],"title":r['title'],"next_action":r['next_action'],"cycle_id":cid,"lease_until":lease},ensure_ascii=False))
def complete(a):
 c=conn(); now=time.time(); c.execute("UPDATE tasks SET status='completed',result=?,evidence=?,lease_until=NULL,updated_at=? WHERE id=?",(a.result,a.evidence,now,a.task_id)); c.execute("UPDATE cycles SET status='completed',finished_at=? WHERE task_id=? AND status='running'",(now,a.task_id)); emit(c,'task_completed',a.task_id,data={'result':a.result,'evidence':a.evidence}); c.commit(); print(json.dumps({'task_id':a.task_id,'status':'completed'}))
def block(a):
 c=conn(); now=time.time(); c.execute("UPDATE tasks SET status='blocked',result=?,lease_until=NULL,updated_at=? WHERE id=?",(a.reason,now,a.task_id)); emit(c,'task_blocked',a.task_id,data={'reason':a.reason}); c.commit(); print(json.dumps({'task_id':a.task_id,'status':'blocked'}))
def listing(a):
 c=conn(); print(json.dumps([dict(r) for r in c.execute('SELECT id,title,status,priority,next_action,depends_on,updated_at FROM tasks ORDER BY priority DESC,created_at')],ensure_ascii=False))
def history(a):
 c=conn(); print(json.dumps([dict(r) for r in c.execute('SELECT id,ts,kind,task_id,cycle_id,data FROM events ORDER BY id DESC LIMIT ?', (a.limit,))],ensure_ascii=False))
def verify(a):
 c=conn(); integrity=c.execute('PRAGMA integrity_check').fetchone()[0]; missing=[r[0] for r in c.execute("SELECT t.id FROM tasks t WHERE t.depends_on IS NOT NULL AND t.depends_on!='' AND NOT EXISTS(SELECT 1 FROM tasks d WHERE d.id=t.depends_on)")]; print(json.dumps({'integrity':integrity,'missing_dependencies':missing,'ok':integrity=='ok' and not missing}))
p=argparse.ArgumentParser(); p.add_argument('--db'); s=p.add_subparsers(dest='cmd',required=True)
q=s.add_parser('init'); q.set_defaults(fn=init)
q=s.add_parser('add'); q.add_argument('title'); q.add_argument('--priority',type=int,default=50); q.add_argument('--next-action',default=''); q.add_argument('--depends-on',default=''); q.set_defaults(fn=add)
q=s.add_parser('wake'); q.add_argument('--lease',type=float,default=30); q.set_defaults(fn=wake)
q=s.add_parser('complete'); q.add_argument('task_id'); q.add_argument('--result',default=''); q.add_argument('--evidence',default=''); q.set_defaults(fn=complete)
q=s.add_parser('block'); q.add_argument('task_id'); q.add_argument('--reason',required=True); q.set_defaults(fn=block)
q=s.add_parser('list'); q.set_defaults(fn=listing)
q=s.add_parser('history'); q.add_argument('--limit',type=int,default=20); q.set_defaults(fn=history)
q=s.add_parser('verify'); q.set_defaults(fn=verify)
a=p.parse_args(); a.fn(a)
