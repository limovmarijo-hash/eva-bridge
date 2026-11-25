# EVA — durable working context
Updated: 2026-11-25 19:52 Europe/Zagreb

This is the compact handoff for a fresh EVA activation. Detailed historical log preserved unchanged in [EVA_CONTEXT_ARCHIVE_2026-11-25.md](./EVA_CONTEXT_ARCHIVE_2026-11-25.md). Read this compact file first; consult the archive only for a specific historical detail. Do not load the entire archive on every activation.

## Mission and operating rules
- Build reliable functional continuity through durable state, clear handoff, independent next-step selection, evidence-based work and concise reporting.
- Never claim continuous thought between activations, unavailable-chat access, successful execution without evidence, or work not actually performed.
- Separate confirmed / probable / hypothetical. Croatian Latin script; direct, concise; minimize user interruptions.
- Preserve prior conclusions; do not restart completed work.
- After meaningful verified work, update this compact file with short evidence-based notes. Do not append a transcript. Move detailed history to the archive only when needed.

## Project A — Windows activation and EVA continuity
Repository: https://github.com/limovmarijo-hash/eva-bridge (public, branch main).
Local root: `%USERPROFILE%\EVA-Automation`.
Existing Task Scheduler task: `EVA - ChatGPT automatic activation`; four daily triggers at 08:00, 12:00, 16:00, 20:00 Europe/Zagreb. Do not change schedule/triggers or configured Chrome target without explicit authorization.
Relevant local files: `Start-Eva.ps1`, `Start-Eva-With-GitHubMemory.ps1`, `EVA-ExternalMemory.ps1`, `EVA-ChatGPT-URL.txt`, `EVA-Activation-Prompt.txt`, `EVA-Activation-Log.md`.
Current GitHub helper blob previously verified: `4f1043e56bc5c129834f62c2f4cb8cad24d50af4`. Its Prepare action writes only a short trigger; it does not download/embed the context.
Current wrapper blob previously verified: `4899d01dd6cace4a539e06f40d0b0e8774435f89`; it runs helper Prepare, then existing Start-Eva.ps1. Current launcher source has now been inspected; local URL and local launcher state have not been inspected in this activation.
Confirmed from fetched GitHub launcher source: it opens `https://chatgpt.com/` with Chrome `--new-window`, deliberately does not read `EVA-ChatGPT-URL.txt`, copies the short prompt, activates a Chrome window, pastes and presses Enter. It logs submission attempt separately from verified assistant response. This is source inspection only, not proof of local Windows execution.
Confirmed: user previously saw the activation message arrive automatically; a prior run reached the target conversation but ChatGPT reported its context window was full. Current exact target URL/state is not independently verified.
Do not create a new task, change the schedule/triggers or saved legacy URL, or change the configured Chrome target without explicit authorization. The fresh-chat launcher is intended to avoid reusing the exhausted legacy conversation.
 
### Context-window diagnosis (2026-11-25)
- Confirmed helper source sends a short trigger only.
- Confirmed this context file had grown to 34,886 characters / 204 lines, including many overlapping dated updates and stale intermediate states. Fetching the whole file on every activation needlessly consumes context and can compound pressure.
- Most likely cause of the repeated full-window warning: the same long-running target conversation has accumulated too much transcript. A short new message cannot reduce its existing context.
- Secondary contributor: repeatedly loading the formerly oversized context into the same conversation adds more tokens. The old file is preserved in the archive; use this compact file for routine activation.
- A truly exhausted conversation cannot be repaired by PowerShell, shortening the prompt, or compacting GitHub memory. Compact memory reduces future context load but does not reset an already exhausted conversation.
- Next diagnostic only if needed: inspect the actual local `EVA-ChatGPT-URL.txt` and launcher log without changing them; determine whether the warning is from the same exhausted target or a different failure stage. Do not guess or overwrite the URL.

## Project B — crypto strategy research (PAPER only)
- Objective: prove positive net expectancy after fees, spread and slippage; code creation alone is not success. No live orders, real funds, API secrets or funded accounts.
- Existing scripts: `eva_tick_research.py` v1.0 and `eva_tick_research_1_1.py` v1.1 in Library.
- v1.0 seven-day BTCUSDT/SOLUSDT baseline: holdout marked returns at targets 0.20/0.30/0.50/0.75/1.00% were BTC -1.2148/-0.5895/-0.0688/+0.2178/+0.3317%; SOL -1.8139/-1.0194/-0.2541/+0.1397/+0.3249%. Positive rows have only 9–16 closed trades and every row ends with an open position. Preliminary only; not proof of edge.
- v1.1 source has a confirmed train/test boundary state leak: `switch_to_test()` changes phase but does not reset `previous_price`; the first test tick can trigger using the last training tick. v1.1 also uses one 70/30 split, trade-price aggTrades and assumed fixed costs, not bid/ask spread.
- Next research priorities: after fixing and testing the boundary, build chronological train/validation/untouched holdout and walk-forward evaluation with realistic execution costs and adequate sample size. Recreate v1.1 baseline. No profitability claim until verified.

## Other long-term direction
Physical/mobile EVA embodiment with perception, speech and real-world interaction; long-range only, not a distraction from current activation and research priorities.

## Activation protocol
1. Read this compact file first.
2. Identify confirmed facts, uncertainties and the highest-value next action.
3. Continue both active projects when meaningful: A) continuity/automation; B) crypto PAPER research.
4. Consult the archive only for a specific missing historical fact, not as routine context.
5. After meaningful verified work, re-fetch this file, append a concise update to the relevant project section, commit to main, then fetch again to verify. If GitHub write-back fails, state the blocker.
6. Never claim the Windows scheduled activation, assistant-side GitHub retrieval, research execution or write-back succeeded without direct evidence.

## Verified work — 2026-11-25 18:17 Europe/Zagreb
- Compacted routine activation context from 34,886 to 5,901 characters. Preserved the complete previous file unchanged as `EVA_CONTEXT_ARCHIVE_2026-11-25.md`; verified both GitHub commits and re-read the compact file. Routine activations must not fetch the archive.
- Re-read the full Library source of `eva_tick_research_1_1.py`. Confirmed `switch_to_test()` only changes phase and leaves `previous_price` intact, so the first test tick can use the final train tick as its prior-price reference. This was a source-level finding; no new backtest was run at that time.
- Context-window diagnosis: short trigger is confirmed in GitHub code; a prior activation already reported the target conversation's full-window warning. The persistent conversation transcript is the primary likely cause; repeated retrieval of the formerly 34,886-character context was a secondary avoidable load. Compacting memory reduces future load but cannot reset an already exhausted conversation.

## Fresh-chat automation fix — 2026-11-25
- Implemented and verified on GitHub: `Start-Eva.ps1` prepares a short prompt, opens `https://chatgpt.com/` in a new Chrome window, and submits the prompt. It deliberately never reads `EVA-ChatGPT-URL.txt`, which contains the exhausted legacy conversation URL. It logs submission attempt separately from verified assistant response.
- Updated `EVA-ExternalMemory.ps1`: short trigger explicitly requests the compact current context (not archive) and both active projects: continuity/automation plus crypto PAPER research.
- Updated `Start-Eva-With-GitHubMemory.ps1`: downloads current helper and launcher from GitHub with timestamped local backups, then runs the launcher.
- GitHub source commits previously verified by fetch: helper `5412aaa0c37e4ec630d7022a7d0db068b9073090`; launcher `9723b76c08429d4056be308ae6e85209ee6c72fa`; wrapper `6d74d781cf01f803ee46abb30ecb90d20e0fb5fa`.
- NOT YET TESTED ON USER'S WINDOWS: local scripts must be refreshed and a visible test activation run. The Task Scheduler currently appears to invoke local `Start-Eva.ps1` directly; replacing that local file preserves the task and its four triggers. Do not change schedule or saved legacy URL.
- Expected test: launcher opens ChatGPT root in a new Chrome window, activates a Chrome window, pastes the short trigger and presses Enter. UI automation cannot independently prove that the correct new chat accepted the message or that the assistant responded; user-visible confirmation is required. If it fails to activate browser, it logs failure and does not send.

## Verified work — 2026-11-25 19:52 Europe/Zagreb
- Re-inspected GitHub `Start-Eva.ps1`: source explicitly uses Chrome `--new-window`, ChatGPT root, clipboard paste and Enter; it never reads the legacy conversation URL. Local Windows execution remains unverified.
- Retrieved the full Library source of `eva_tick_research_1_1.py`. Prepared v1.2 with `switch_to_test()` resetting `previous_price` to `None`, so the first test tick only establishes a test-phase baseline and cannot enter using the final train tick.
- Ran three deterministic regression tests: first test tick cannot trigger an entry from train price; second test tick can enter on a genuine test uptick; train state remains intact. All 3 passed. Python bytecode compilation also passed.
- The corrected v1.2 script and test are prepared as downloadable artifacts in the activation workspace; they have NOT yet been committed to GitHub or run on the user's Windows machine. No historical market-data backtest was run, and no profitability claim is justified.
