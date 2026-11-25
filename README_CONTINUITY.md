# EVA Continuity Store

`eva_state.py` is the first local persistence layer for EVA's task/cycle state.

## Local smoke test

```powershell
python .\eva_state.py init
python .\eva_state.py add "Test continuity" --priority 100 --next-action "Run verify"
python .\eva_state.py wake
python .\eva_state.py list
python .\eva_state.py verify
python .\eva_state.py history
```

The database defaults to `~/eva/state/eva_continuity.sqlite3` (override with `EVA_STATE_DB`).

The store does not call an AI provider and does not execute task text as shell commands. It is only the persistence/queue layer.
