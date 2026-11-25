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
- Launcher path: `%USERPROFILE%\\EVA-Automation\\Start-Eva.ps1`.
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

## Dated update — 2026-11-25, GitHub external-memory code prepared
- Confirmed the repository is accessible through the connected GitHub integration and read the current durable context, continuity README, SQLite state module, and bridge scripts.
- Added EVA-ExternalMemory.ps1: reads the current public GitHub context, caches it locally, prepares a complete activation prompt in EVA-Activation-Prompt.txt, and copies it to the Windows clipboard. It also supports GitHub write-back using GitHub CLI authentication (no token is embedded); it appends only a user-supplied verified note after fetching the latest file SHA.
- Added Start-Eva-With-GitHubMemory.ps1, a wrapper that refreshes the external-memory prompt and then invokes the existing Start-Eva.ps1. It does not open a second browser itself.
- Added Install-EVA-GitHub-Memory.ps1, intended to install the two scripts under %USERPROFILE%\\EVA-Automation and change only the action of the existing scheduled task EVA - ChatGPT automatic activation, preserving its existing triggers.
- Added README_EXTERNAL_MEMORY.md with installation and GitHub CLI write-back instructions. All four new files were committed to GitHub.
- Important: none of these new scripts has yet been run on the user's Windows PC. The wrapper assumes the existing launcher reads EVA-Activation-Prompt.txt, as indicated by the latest project handoff; this must be verified in the first on-device test. GitHub read/cache and append/write-back have not been runtime-tested on Windows.
- Next step: run the one-time installer in an ordinary PowerShell window, then manually test the wrapper once and verify that the existing Chrome target receives the GitHub-backed prompt. Do not change the existing task schedule or create another task.

## Dated update — 2026-11-25, full-cycle activation protocol implemented in repository
- Re-read the actual PowerShell helper, wrapper, installer, README, and canonical context from GitHub before changing anything.
- Reworked `EVA-ExternalMemory.ps1` so every prepared activation prompt explicitly requires work on BOTH active streams: (A) EVA functional continuity/automation and (B) crypto strategy research in PAPER mode only.
- The prompt now directs ChatGPT to use the connected GitHub integration to re-fetch the latest `EVA_CONTEXT.md`, append an evidence-based entry for both work streams, commit it to `main`, and verify the saved result. If GitHub write access is unavailable, it must report a blocker and must not claim success.
- Clarified that the PowerShell helper only fetches/prepares context; it cannot know what ChatGPT actually accomplished. Automatic write-back of the assistant's actual work must be performed by the assistant through the connected GitHub integration.
- Rewrote `README_EXTERNAL_MEMORY.md` to document the complete intended cycle, the assistant-side write-back boundary, installation, smoke test, and the distinction between automatic write-back and optional manual GitHub CLI Save.
- GitHub commits: helper update `94a7177c1974d0abfbe579172a128d335223f024`; README update `83dd7cad6f56d5b1055fdf70431f770c88c1dfde`.
- The existing Windows launcher is reported in the latest troubleshooting state to read `EVA-Activation-Prompt.txt`, target the configured Chrome conversation, paste the prompt, and send Enter. This is conversation-reported, not independently inspected on the PC during this update.
- NOT YET VERIFIED: the updated helper has not been run on Windows; the scheduled task has not yet been switched by running the installer; a real scheduled activation has not yet demonstrated both project work and successful GitHub write-back. The full cycle is now explicitly specified in the code/prompt, but final end-to-end acceptance depends on the user's one-time Windows installation and test.
- Next step: user runs the installer once, then performs one manual smoke test. Verify the ChatGPT message actually submits, both work streams are handled, and the resulting GitHub memory commit can be read back.

- Further hardened `Install-EVA-GitHub-Memory.ps1`: it now refuses installation unless the existing `Start-Eva.ps1` explicitly references `EVA-Activation-Prompt.txt`; after changing the existing task action it re-reads the task and verifies the wrapper action and unchanged trigger count. Installer commit: `e21460fccb52146fc49146148bf39ba0d3c8c58c`.

## Dated update — 2026-11-25, Windows PowerShell 5.1 encoding fix
- User ran the installer and reported a PowerShell parser error at the Croatian word "potvrđena". The raw GitHub script is UTF-8 without a BOM; Windows PowerShell 5.1 interpreted non-ASCII source bytes using the legacy code page, turning a character into a curly quote and breaking a single-quoted string.
- Corrected both `Install-EVA-GitHub-Memory.ps1` and `EVA-ExternalMemory.ps1` to contain ASCII-only PowerShell source, avoiding dependence on the host's script-file encoding. Functional prompt instructions remain present in transliterated form.
- Updated commits: helper `6997a358b5369bb918e753180f8a9ffd9a078866`; installer `5238c84cb426e19a9f341e2ca7652f0c5ab84cad`.
- Re-fetch verification confirms both scripts are ASCII-only in GitHub content. They have not yet been run on the user's Windows PC after this correction.
- Next step: user reruns the same installer download/launch block; then inspect any new output. Do not claim installation succeeded until the installer prints its verified success marker.

## Dated update — 2026-11-25, activation reached exhausted ChatGPT conversation
- User reports that the Windows activation opened the intended ChatGPT page and submitted the activation message, but ChatGPT displayed a full context-window warning and stopped.
- This confirms the browser-opening/targeting/submission path worked in this test; it does not confirm that the activation prompt was processed or that either research stream ran.
- Diagnosis: the configured destination is an already long conversation whose context capacity has been exhausted. Repeating activation in that same conversation is not a useful fix.
- Next action: configure the launcher to target a newly created ChatGPT conversation, then run one smoke test there. Preserve this GitHub context as the portable handoff; the new conversation must receive it. Do not assume the full transcript transfers.
- Before asking the user to edit anything, inspect the current wrapper/launcher and provide one consolidated minimal change.