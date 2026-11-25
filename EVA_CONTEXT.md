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


## Dated update — 2026-11-25, Windows activation continuation
- Retrieved the user's durable Library diary `Samostalni AI kontinuitet - dnevnik.md`; its latest visible entry is record 23 dated 2026-11-24. That record confirms the local SQLite continuity store prototype passed four isolated tests, but neither the PowerShell bridge nor the actual Android SSH connection had been tested on the user's devices.
- Confirmed the GitHub repository is `limovmarijo-hash/eva-bridge`, public, default branch `main`, with push/admin permission available through the connected GitHub account.
- Created this portable context file as `EVA_CONTEXT.md` and confirmed it can be read back through GitHub. Its raw URL is used by the Windows launcher so a fresh ChatGPT activation receives project context instead of a generic “continue” prompt.
- Prepared a replacement Windows installer at `Install-EVA-AutoActivation.ps1` in the current ChatGPT conversation's downloadable files. It updates the existing scheduled task (same name and four times daily), writes a launcher that fetches the latest context from GitHub with a local cache fallback, requests one ChatGPT browser opening, pastes the context plus an activation instruction, and logs stages under `%USERPROFILE%\\EVA-Automation\\logs`.
- Important limitation: this installer has not yet been run on the user's Windows PC, and the PowerShell runtime is not available in this execution environment, so syntax/runtime behavior is not independently tested here. Its log deliberately records `SUBMISSION_ATTEMPTED_NOT_VISUALLY_VERIFIED`; sending keystrokes is not proof that ChatGPT accepted the message.
- The previous upgrade produced two visible ChatGPT windows. The replacement removes the second explicit browser launch and does not navigate the active browser window again; it still relies on Windows UI focus and clipboard paste, so the first on-device test must verify whether the prompt actually appears and sends.
- Next step: ask the user for one one-time run of the replacement installer only after this file and the script are verified. Do not ask them to inspect logs or Task Scheduler routinely. If they report a clear successful message in ChatGPT, the next work is to improve durable write-back of each cycle to this GitHub file, then separately resume end-to-end Android SSH bridge validation.
