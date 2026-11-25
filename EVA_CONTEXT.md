# EVA — durable project context
Updated: 2026-11-25 (Europe/Zagreb)

This file is the portable working context for a fresh EVA/ChatGPT activation. It is a project log, not a transcript and not proof that an AI process ran between activations. At every activation, read this file first, verify the current state, then append a dated update after meaningful work.

## Mission and operating rules
- Build reliable functional continuity across separate AI activations: durable state, clear task handoff, independent selection of the next useful step, evidence-based progress, and concise notification only for meaningful progress or a real blocker.
- Do not claim continuous thought between activations, access to unavailable chats, successful execution without evidence, or autonomous activity that did not occur.
- Keep confirmed / probable / hypothetical clearly separate.
- User prefers Croatian Latin script, direct concise communication, and minimal interruptions. Do not ask the user to monitor routine steps. Ask only when a real user-side action or authorization is indispensable.
- Preserve old conclusions; do not restart research or repeat explanations without reason.

## Current Windows-to-ChatGPT activation experiment (2026-11-25)
Confirmed:
- Windows Task Scheduler task named `EVA - ChatGPT automatic activation` was created successfully.
- Schedule: daily at 08:00, 12:00, 16:00, 20:00 (Europe/Zagreb local Windows time).
- Launcher path: `%USERPROFILE%\EVA-Automation\Start-Eva.ps1`.
- The first setup opened ChatGPT. The upgrade script then attempted to paste and send: “EVA AUTO-AKTIVACIJA: nastavi naš rad...”.
- User observed two ChatGPT windows: first empty, then a window showing the activation message. The exact reason is not yet established; likely focus/window selection or duplicate browser launch behavior.
- A fresh chat replied that it lacked old memory. This is expected: opening chatgpt.com and sending a generic prompt does not transfer the previous conversation transcript or all project history.
- The previous launcher therefore proves browser opening and a UI submission attempt only. It does NOT prove reliable context transfer, successful message delivery, or a true autonomous work cycle.

Required correction:
1. Supply a compact durable context at every activation, rather than relying on the model to recall an unrelated prior chat.
2. Avoid opening ChatGPT twice or relying on ambiguous browser-window selection.
3. Log each attempt locally with timestamp and stage; distinguish “prompt paste/send attempted” from “ChatGPT visibly accepted it”.
4. On each activation, send this repository's current context plus a clear instruction to continue from it. This is a portable-context workaround, not full transcript continuity.
5. Keep the user-facing workflow to one initial installation/update action, then no routine manual monitoring.

## GitHub repository / local bridge
Repository: https://github.com/limovmarijo-hash/eva-bridge
Default branch: main
Existing files include `eva_state.py`, `bridge.ps1`, `bridge_test.ps1`, `bootstrap_termux.sh`, `setup_ssh.ps1`, `bridge.local.example.json`, and `README_CONTINUITY.md`.

The SQLite store in `eva_state.py` manages queued tasks, cycles, leases, events, and integrity checks. It is a local persistence/queue layer only. It does not call ChatGPT or any AI provider and does not itself perform research.

The Android/Termux SSH bridge is NOT yet verified end-to-end. A previous Windows SSH attempt to Android 192.168.1.4:8022 hung. Do not make this the current blocker for Windows-to-ChatGPT activation. Revisit it separately only when useful. The README's end-to-end success marker is `EVA_END_TO_END_OK`.

## Active research projects to preserve
### 1. EVA functional continuity / automation
Primary project in this repository. Continue improving reliable context handoff, durable task state, logs, and scheduled activations. Current priority: make Windows activation include the latest durable context and avoid duplicate/ambiguous browser windows.

### 2. Crypto strategy research — PAPER only
There are existing `eva_tick_research.py`, `eva_tick_research_1_1.py`, and CSV result artifacts in the user's ChatGPT file library. Prior tests of first-uptick entry plus fixed take-profit targets have NOT established a robust edge. Earlier observations: BTC results were negative; SOL at 1.00% target was only marginally positive and open losing positions were a concern. These observations must be rechecked against actual code/data before being treated as conclusions.
Research standard: realistic fees, spread and slippage; chronological train/validation/holdout; walk-forward; no look-ahead or leakage; enough sample size; compare controls; no live orders, real money, API secrets, or funded accounts. The core target is positive net expectancy after costs, not merely writing a bot.

### 3. Other long-term work
The user also has a longer-term aim to develop a mobile physical embodiment of EVA, with perception, speech and real-world interaction. Keep this as a long-range direction; do not let it distract from the immediate activation/context-transfer task.

## Existing scheduled ChatGPT automations observed 2026-11-25
- “EVA — strategija trejdanja”: enabled; daily at 08:00; focused on PAPER crypto strategy research and audit.
- “EVA Crypto Paper Research”: enabled; daily at 08:00, beginning 2026-11-26; broader research into robust crypto strategies.
- “Nastavi AI kontinuitet”: disabled.
- “Samostalni AI kontinuitet — eksperiment”: disabled.
Do not silently create duplicate automations or alter these schedules. Windows activation is a separate mechanism.

## Activation protocol
At each fresh activation:
1. Read this file from the repository's raw URL:
   https://raw.githubusercontent.com/limovmarijo-hash/eva-bridge/main/EVA_CONTEXT.md
2. State internally what is confirmed, what remains uncertain, and the most valuable next action.
3. Continue one substantive task using available tools. If no execution/data/tool access exists, record the precise blocker rather than pretending work occurred.
4. Update this file with a dated entry only after a meaningful verified change; preserve the previous content.
5. Tell the user only about meaningful progress or an essential blocker. Never claim the scheduled activation itself guarantees continuous thought or full access to prior conversations.
