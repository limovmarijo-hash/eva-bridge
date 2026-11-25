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

## Dated update — 2026-11-25, correction: activation currently embeds full memory
- User correctly challenged why the ChatGPT context window filled despite the agreed design of a short wake-up message followed by assistant-side retrieval of external memory.
- Inspection of the committed `Start-Eva-With-GitHubMemory.ps1` and `EVA-ExternalMemory.ps1` confirms the current implementation does NOT follow that design: the wrapper runs `EVA-ExternalMemory.ps1 -Action Prepare`; Prepare downloads the full `EVA_CONTEXT.md`, builds a large prompt containing the entire memory, writes it to `EVA-Activation-Prompt.txt`, copies it to the clipboard, and then invokes `Start-Eva.ps1` to send it.
- Therefore the current message is not just a short wake-up trigger. The implementation regressed from the agreed architecture by transporting the full memory inside the UI message.
- A second possible contributor is that the configured ChatGPT URL may still point to a long-running conversation. The precise URL currently stored on the user's PC has not been inspected in this activation, so this remains unverified.
- Correct target architecture: keep the UI message short; after receiving it, ChatGPT should independently fetch `EVA_CONTEXT.md` through the connected GitHub integration, then continue. If GitHub access is unavailable in a fresh conversation, report that limitation rather than silently pasting the whole memory into the wake-up message.
- Next implementation task: inspect the actual local `EVA-ChatGPT-URL.txt` and `Start-Eva.ps1` only through a minimal user-side diagnostic if necessary; revise the GitHub helper so Prepare does not embed the full context. Preserve the current memory file and scheduled triggers.

## Dated update — 2026-11-25, consolidated review of latest Windows activation troubleshooting
- Reviewed the latest available conversation history and current GitHub scripts to avoid repeating completed steps.
- Confirmed earlier local Windows work: `Start-Eva.ps1` was configured to reuse an existing Chrome window/tab, target the URL in `EVA-ChatGPT-URL.txt`, read `EVA-Activation-Prompt.txt`, paste the activation text, and (after the latest successful change) press Enter automatically. User explicitly confirmed the activation message arrived without manual Enter. Do not ask the user to re-enable auto-send or repeat this test.
- User explicitly requires reuse of the existing target conversation/window; do not open a new browser window or create a new ChatGPT conversation as a workaround. Historical notes contain multiple URL values at different times; the actual current local `EVA-ChatGPT-URL.txt` has not been read in this activation, so do not overwrite it based on a guessed historical URL.
- Earlier URL snapshots include `https://chatgpt.com/c/6b06fe82-1818-83ed-992f-f7a845375fdc`; another earlier note records `https://chatgpt.com/c/6b06fbb7-b6d0-83eb-b46d-6b2f393725bd`. A later description identifies the intended existing Chrome conversation as “nastavak EVA projekta 2” but does not expose its URL. Resolve by reading the actual local URL file only if needed; do not ask the user to retype it.
- The original short wake-up prompt was `EVA, probudi se.` / `EVA, probudi se i nastavi kontinuitet. Prvo učitaj svoju vanjsku memoriju, zatim provjeri posljednje stanje i nastavi od nedovršenog koraka. Ne počinji od nule.` Automatic Enter was subsequently enabled and user-confirmed.
- Current GitHub implementation was inspected: `Start-Eva-With-GitHubMemory.ps1` calls `EVA-ExternalMemory.ps1 -Action Prepare`, then `Start-Eva.ps1`. The helper's Prepare action embeds the entire GitHub `EVA_CONTEXT.md` into the prompt file and clipboard. This definitively violates the short-trigger-only design and must be corrected.
- Two separate context-capacity risks must not be conflated: (1) the current helper sends the entire external memory as a single UI message (confirmed code defect); (2) the existing target conversation itself may already have a large accumulated transcript and may have exhausted its context even if the trigger is short (not yet independently established). A short message cannot shrink an already-full conversation.
- The user has not asked to open a new conversation. Do not suggest that again. Keep the existing Chrome target and existing Task Scheduler task/triggers unchanged.
- Do not repeat setup, re-enable auto-Enter, recreate the scheduled task, or ask for manual Ctrl+V/Enter. The next technical work is to revise the helper/wrapper so the browser sends only the short wake-up message, then the assistant reads `EVA_CONTEXT.md` through GitHub after activation. Verify that fresh-chat GitHub retrieval works without embedding the full memory. Separately establish whether the current target conversation is itself exhausted.

## Dated update — 2026-11-25, short-trigger implementation corrected
- Replaced the regression in `EVA-ExternalMemory.ps1`: `Prepare` no longer calls `Get-EvaMemory`, downloads/caches the full context, or inserts it into the UI prompt. It now writes and copies a short ASCII-only wake-up instruction that directs ChatGPT to retrieve `EVA_CONTEXT.md` through the connected GitHub integration after activation.
- Preserved the existing `Read`, `Status`, and optional manual `Save` actions. The wrapper remains unchanged and still invokes `Prepare` followed by the existing `Start-Eva.ps1`.
- Read-back verification from GitHub: helper blob SHA `40a5d5787e81d18c6971cbd6d5f449edb0d50bdc`; helper source is ASCII-only; Prepare section calls `New-EvaActivationPrompt` without fetching memory. This is source/read-back verification, not a Windows runtime test.
- Updated `README_EXTERNAL_MEMORY.md` to document the correct architecture and a one-time local-helper refresh that does NOT reinstall or modify the scheduled task, wrapper, Chrome target, or triggers.
- Existing local Windows helper has not yet been replaced by this new GitHub version. One consolidated PowerShell update/validation block is documented in the README. It backs up the current helper, downloads the corrected one, checks ASCII-only source, runs Prepare, and verifies that the resulting prompt is short and contains no embedded memory.
- Important distinction: this removes the confirmed oversized-prompt defect, but does not prove the existing ChatGPT conversation has available context capacity. The destination URL and local launcher remain untouched; do not create a new conversation or change the URL without explicit user direction.
- Next step: user executes the single local helper-refresh block once. Then the next scheduled/manual activation will send the short trigger. The assistant must prove GitHub read access in that activated conversation and report a blocker if unavailable. If ChatGPT still reports exhausted context, record that separately as a destination-conversation capacity blocker rather than changing the agreed target automatically.

## Dated update — 2026-11-25 18:03 Europe/Zagreb, dual-stream activation
### A) EVA functional continuity and automation
- **NAPRAVLJENO:** Re-fetched the current `main` version of this file immediately before write-back (blob SHA before this entry: `782b2ff4fce2c816e61bbfdee0d302e5065bac3e`). Verified repository metadata: public repository `limovmarijo-hash/eva-bridge`, default branch `main`, connected integration has pull/push/admin permissions.
- **NAPRAVLJENO:** Re-read the current GitHub sources for `EVA-ExternalMemory.ps1`, `Start-Eva-With-GitHubMemory.ps1`, and `Install-EVA-GitHub-Memory.ps1`. Confirmed helper blob SHA `40a5d5787e81d18c6971cbd6d5f449edb0d50bdc`; its `Prepare` action creates only a short ASCII wake prompt and does not fetch/embed the full context. Confirmed wrapper blob SHA `4899d01dd6cace4a539e06f40d0b0e8774435f89`; it prepares the short prompt and calls the existing launcher. Installer blob SHA `263f06f3a61415910c96ad519d6f3e80a1184b38`.
- **POTVRĐENO:** The GitHub integration exposes a direct `update_file` write action requiring the current blob SHA; this activation uses that action for the durable write-back and will verify by re-reading the committed file. No Windows schedule, triggers, target URL, or local files were changed.
- **NIJE POTVRĐENO / BLOCKER:** The corrected helper and wrapper source are verified on GitHub, but their current versions have not been confirmed installed or runtime-tested on the user's Windows PC in this activation. No claim of end-to-end Windows success.
- **SLJEDEĆI KORAK:** After this verified GitHub write-back, only if a Windows update is still pending, provide one consolidated local helper-refresh/test action; do not alter the existing task schedule or target conversation.

### B) Trading strategy research — PAPER only
- **NAPRAVLJENO:** Read the complete Library copies of `eva_tick_research.py` (v1.0, 283 lines) and `eva_tick_research_1_1.py` (v1.1, 258 lines). Searched Library for the named result CSVs and CSV-format files; no matching CSV result artifact was returned.
- **NAPRAVLJENO:** Audited fee/slippage arithmetic in both versions. With fee `0.10%` per side and slippage `0.02%` per side, and the exit trigger defined as `entry_fill * (1 + target)`, the modeled net return at an exact target fill is `(1 - fee)^2 * (1 + target) * (1 - slippage) - 1`. The target needed merely to break even under these assumptions is approximately `0.22034%`. At an exact `0.20%` target fill, modeled net return is approximately `-0.02030%` of the allocated position; at `0.30%`, approximately `+0.07948%`, before any additional latency/market-impact effects. This is a threshold calculation, not a measured strategy expectancy; overshoot on the observed exit tick can change realized outcomes.
- **POTVRĐENO:** Both versions retain `previous_price` when switching from train to test; v1.0 explicitly comments that the previous market tick is retained. Therefore the first test tick may trigger an entry by comparing against the final training tick. This is a one-tick train/test boundary contamination and should be fixed by resetting the comparison state at the phase boundary, then covered by a deterministic test.
- **NIJE POTVRĐENO / BLOCKER:** No matching historical CSV result artifact was found in Library, and no backtest was executed in this activation. Thus prior BTC/SOL performance observations remain unverified here; no positive net edge is established. The scripts alone do not provide validation/holdout/walk-forward evidence or adequate sample-size proof.
- **SLJEDEĆI KORAK:** Locate the actual generated result CSVs or regenerate them in a controlled PAPER-only run; first patch and unit-test the train/test boundary reset, then run chronological train/validation/holdout and walk-forward with realistic costs. No live orders or real funds.

### Security note
- Library search surfaced a previously pasted OpenAI API credential in a saved troubleshooting transcript. The credential is not reproduced here and was not used. Treat it as exposed: revoke it in the OpenAI account and replace it only if still needed; remove/redact the saved transcript copy where possible. Do not store API secrets in EVA memory or logs.

## Dated update — 2026-11-25 18:04 Europe/Zagreb, short-trigger correction and PAPER strategy audit
### A) EVA functional continuity / automation
- Re-read the latest `EVA_CONTEXT.md` from `main` before work; starting blob SHA: `fb749aa19f20804bacdcceeaec45db26adb058f5`.
- Re-read current `EVA-ExternalMemory.ps1` and `README_EXTERNAL_MEMORY.md` from GitHub. Confirmed the helper's `Prepare` action constructs only a short wake-up instruction; it does not call `Get-EvaMemory`, download/cache the full context, or embed `EVA_CONTEXT.md` in the UI prompt. Helper blob SHA: `40a5d5787e81d18c6971cbd6d5f449edb0d50bdc`; README blob SHA: `0b255bf08581cea3ae7da1a44ab30a242cfbffb0`.
- Recent Windows output supplied in the conversation: `EVA_SHORT_WAKE_PROMPT_READY`, prompt length 1,340 characters, and explicit confirmation that full external memory is NOT embedded. This verifies local `Prepare` ran and produced a short prompt; it does not independently prove that a scheduled run used the same exact helper blob SHA or that ChatGPT completed the GitHub read after submission.
- No Windows schedule, trigger, Chrome target, or task was changed in this activation. Existing short-trigger design is preserved.
- CONFIRMED: short-prompt implementation exists on GitHub and the local Prepare test reported success. NOT YET CONFIRMED: end-to-end scheduled activation → assistant GitHub read → both work streams → GitHub write-back.
- NEXT STEP: keep the current task and Chrome target unchanged; at the next actual activation, verify the assistant-side GitHub read and commit/read-back rather than re-running installation.

### B) Crypto strategy research — PAPER only
- Searched the user's Library and read the full available source files `eva_tick_research.py` (11,333 bytes) and `eva_tick_research_1_1.py` (10,503 bytes). Duplicate copies of both scripts are present.
- Audited version 1.1: fixed targets are 0.20%, 0.30%, 0.50%, 0.75%, and 1.00%; modeled fee is 0.10% per side, slippage 0.02% per side, and position size 20% of equity. It reports closed realized PnL separately from open-position liquidation-marked PnL.
- Concrete code-review finding: `switch_to_test()` changes the phase but does not reset `previous_price`. The first test tick can therefore trigger an entry using the final training tick as its prior-price reference. This is a one-tick train/test boundary state leak; the transition should reset the previous-price state (or explicitly define a clean warm-up rule) before validation/holdout.
- Methodology limitation: current script uses a single chronological 70/30 train/holdout split, not train/validation/untouched holdout or walk-forward. It also uses trade-price aggTrades with fixed assumed slippage rather than observed bid/ask spread; the modeled costs therefore do not establish execution realism.
- Library search did not locate the named result artifacts `eva_tick_research_results.csv` or `eva_tick_research_results_1_1.csv`. No CSV values were inspected and no performance result is claimed in this activation.
- CONFIRMED: source-level audit finding above. NOT CONFIRMED: any positive net edge; no accessible CSV result evidence and no fresh backtest was executed. No live orders or real-money activity.
- NEXT STEP: revise the PAPER research harness to reset boundary state and add a chronological train/validation/holdout plus walk-forward protocol; obtain the actual CSV/data artifacts before evaluating performance.

## Dated update — 2026-11-25 18:00+ Europe/Zagreb, compact activation prompt
### A) EVA functional continuity / automation
- Re-fetched the latest context before editing; starting blob SHA: `0a4343919b7eaad73785ebe789362efab06a33cf`.
- Replaced only the prompt-building function in `EVA-ExternalMemory.ps1` with a compact wake instruction. It asks ChatGPT to read the current GitHub context, process both work streams, write back evidence and verify read-back; it explicitly says not to paste memory into the UI and not to alter the schedule or Chrome target.
- GitHub helper commit: `93aec0c6f510cae41e3ad74dad0fbbee5f81782c`; new helper blob SHA: `719fd882fc8f846c68a122dd5d785d835b466465`. Re-fetch of the helper confirmed the exact new content.
- NOT YET CONFIRMED: local Windows helper has not yet been replaced with this revision; the prompt length and Windows clipboard output have not yet been tested on-device.
- NEXT STEP: run the single local update block supplied to the user. It downloads only the helper, backs up the prior copy, runs `Prepare`, and verifies the generated prompt is short.

### B) Crypto strategy research — PAPER only
- Preserved the previous activation's source audit and its confirmed train/test boundary-state leak in `switch_to_test()`; did not rerun the backtest or duplicate the earlier source review during this code-focused activation.
- No new CSV result artifact or fresh performance evidence was obtained in this activation. Positive net expectancy remains unproven; no live trading or real-money execution.
- BLOCKER: no new accessible result dataset was established for a fresh quantitative test in this activation.
- NEXT STEP: after the context-transfer update, fix the phase-boundary state reset and test with chronological validation/holdout and walk-forward once source data/results are available.
