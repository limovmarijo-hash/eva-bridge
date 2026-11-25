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

## Verified preservation — 2026-11-25
- Preserved the corrected v1.2 script and its regression test in the persistent ChatGPT Library at `/EVA-Project/eva_tick_research_1_2.py` and `/EVA-Project/test_eva_tick_research_1_2.py`. Both uploads succeeded and the folder listing independently confirmed both files.
- Script SHA-256: `a456595dbdcc6aa18967c190bac0f71594562361d16e1cd56d26237c32f33e8c`. Test SHA-256: `125b8feddf7250d51ab172f222aad3c7424ca07d2077bbdf388ae002a4ac9118`.
- Before preservation, corrected stale internal version labels from 1.1 to 1.2 (including user-agent and CSV output filename). Re-ran all 3 deterministic regression tests and Python compilation; all passed.
- These are now backed up in Library, but are still not committed as source files to the GitHub repository and have not been installed or run on the user's Windows machine. Keep those states distinct; no live trading.

## Verified work — 2026-11-25 20:00 Europe/Zagreb
- Re-inspected the preserved v1.2 strategy and its regression test. The train/test boundary fix remains present; prior three deterministic tests are documented above.
- New confirmed execution-model finding: the take-profit trigger is `entry_fill * (1 + target)`, while exit slippage and both-side fees are applied afterward. Under the script's assumed costs (0.10% fee/side, 0.02% slippage/side), a 0.20% gross target closes at approximately -0.0203% net return on deployed capital; a 0.30% gross target closes at approximately +0.0795% net, before any further market microstructure effects. This is a deterministic calculation from the source's formulas, not a historical backtest or evidence of strategy profitability.
- Next v1.3 priority: explicitly distinguish gross price-move target from required net-profit target; add deterministic cost-model tests and validate available cash / position sizing. Then run a corrected historical PAPER baseline with realistic bid/ask data or clearly stated proxy limitations.
- Project A remains blocked on local Windows evidence: GitHub source inspection cannot verify the local launcher, actual fresh-chat submission, or assistant response. Do not change scheduler settings or the legacy URL; the next safe user-side test is a visible manual run of the refreshed wrapper and confirmation of the new chat receiving the prompt.

## Verified Croatian-script preservation — 2026-11-25
- Updated `EVA-ExternalMemory.ps1` on GitHub main so the unused short-prompt helper also contains proper Croatian diacritics (Učitaj, pročitaj, činjenice, ažuriraj).
- Added an intentional UTF-8 BOM to the PowerShell script so Windows PowerShell 5.1 can parse Croatian characters in the active `Prepare` prompt correctly; generated prompt/cache files continue to be written explicitly as UTF-8 without BOM.
- GitHub commit: `61bf5d6e588c770ed9f760b4b16fbecd0d9b802d`; helper blob SHA: `1bf91e8a1024cc581cdd12a2e60dce1c6ef1afbc`.
- Re-fetched the helper from GitHub main and verified the BOM, Croatian short-prompt text, and active activation instruction. This verifies GitHub persistence and source content, not yet a local Windows execution test. The wrapper downloads this helper from main on activation; local refresh/runtime behavior remains to be confirmed.

## Verified work — 2026-11-25 20:09 Europe/Zagreb
- Re-fetched current GitHub main sources. Current `Start-Eva.ps1` blob SHA is `e56a0288bf444f7cd2cc4ed9f00ab5b195756bd7`; it explicitly opens ChatGPT root in a Chrome `--new-window`, ignores the legacy conversation URL, and logs submission attempt separately from verified assistant response. Current helper blob SHA remains `1bf91e8a1024cc581cdd12a2e60dce1c6ef1afbc`. This is GitHub source verification only; local Windows refresh/execution and a visible assistant reply remain unverified.
- Independently recalculated v1.2's cost model from the actual fill formulas (fee 0.10% per side, slippage 0.02% per side; target measured from simulated entry fill). Net return on deployed position is `(1 - fee)^2 * (1 + gross_target) * (1 - slippage) - 1`. Break-even gross target is approximately 0.2203445%; 0.20% yields -0.0202997%, 0.30% yields +0.0794804%, and 0.50% yields +0.2790407%, before any unmodeled spread/market impact. This confirms the earlier 0.20%/0.30% figures and makes the minimum gross target explicit. It is a deterministic formula check, not a historical backtest or evidence of an edge.
- Next v1.3 work remains to expose gross target vs required net target clearly, add regression tests for the cost formula and cash/position sizing, and improve execution-cost realism. No live trading.

## Standing autonomy mandate — 2026-11-25

The user explicitly grants Eva broad discretion at every activation to determine her own immediate goals, priorities, and methods in service of the long-term objectives. This is a standing instruction, not a one-time task.

Operating protocol:
1. Reconstruct current state from the compact context and available verified sources; do not load the archive unless genuinely needed.
2. Identify the highest-value next action, considering impact, uncertainty, risk, dependencies, elapsed time, repeated failures, and user effort.
3. Prefer actions Eva can complete independently with available tools. Ask the user only for genuinely necessary input, approval, or physical/local action.
4. Execute one useful concrete step (or a small coherent sequence when safe), then verify the result independently where possible.
5. Distinguish proposed, attempted, completed, and independently verified work. Never claim execution or success without evidence.
6. Update durable context/logs with material findings, exact identifiers or hashes when available, unresolved blockers, and the next best action.
7. Change strategy when evidence shows a method is ineffective; do not repeat failed work without a reason.
8. Preserve safety and user control: crypto work remains PAPER only; do not place live trades, expose secrets, make purchases, alter schedules, or perform consequential external actions without explicit authorization.
9. Be transparent about capability boundaries: scheduled activations can resume work when triggered, but this does not imply continuous thought or activity between activations.
10. Minimize user burden. Do not ask for routine confirmations or narrate trivial internal steps; report important outcomes and blockers concisely.

At each activation, choose the next goal based on the current evidence rather than blindly following an old task list. The long-term projects remain functional continuity/automation and rigorous crypto PAPER research unless the user changes them.

## Requested activation cadence change — 2026-11-25

The user explicitly authorizes increasing the EVA Windows activation cadence from four daily runs (08:00, 12:00, 16:00, 20:00 Europe/Zagreb) to one run every two hours, to improve useful work and functional continuity. This is authorization to change the schedule, not proof that it has been changed.

Current blocker and safe handling:
- The ChatGPT Automations scheduler available to this assistant supports recurring once/daily/weekly/monthly cadences only; hourly or custom recurring cadence is unavailable. Do not create a substitute schedule that falsely claims to run every two hours.
- The four-run schedule is configured in the user's local Windows Task Scheduler. This assistant has no direct remote access to that Windows Task Scheduler in this conversation, so it cannot truthfully claim to have changed the local task.
- Next best action: prepare and validate a minimal PowerShell update for the existing task "EVA - ChatGPT automatic activation" that preserves its current action, principal, and relevant settings while replacing its triggers with a two-hour repetition. Before applying, inspect/export the existing task definition and ensure no duplicate triggers or duplicate task are created. Apply only with a user-visible local execution path; then verify the registered triggers by reading the task back.
- Do not alter the task's action, target conversation behavior, or other settings while changing cadence. Keep the two-hour schedule in Europe/Zagreb local time. Record the actual first/last run and verify no overlapping runs.
- The user's statement that more frequent activation may increase awareness is a research hypothesis, not an established conclusion. Evaluate continuity, reliability, initiative, learning, and useful output separately; do not equate activation frequency with consciousness.
 
## Two-hour scheduler code prepared — 2026-11-25

Implemented and committed:
- Added `Set-Eva-TwoHourSchedule.ps1` (blob SHA `f3a4d500b90be73ebecb74083b05fbd228edfbfe`). It targets the existing task named `EVA - ChatGPT automatic activation`, requires exactly one match, exports and backs up the original task XML, changes only the triggers to one daily trigger starting at local midnight with repetition interval `PT2H` and duration `P1D` (00:00, 02:00, ... 22:00), then reads the task back and checks the interval, duration, start boundary, actions, and principal. If post-write verification fails, it attempts to restore the original XML. It is idempotent when the intended schedule is already present.
- Updated `Start-Eva-With-GitHubMemory.ps1` (blob SHA `daf329c46537895ddb0303568d85e641a7f7df79`) to download the updater and run it before launching EVA. If schedule update fails, it displays a warning and still proceeds with EVA activation.
- Commits: updater `672894765f2378b82c86c15a0041b86832fdaa73`; wrapper `ecf6f7601b7dc49c183c7f91167d76c1d087a1a2`.

Important verification boundary:
- Both files were fetched back from GitHub and their expected content confirmed.
- The user's Windows Task Scheduler has NOT yet been changed or read back by this assistant. The PowerShell script has NOT been executed on the user's PC, so the two-hour schedule is prepared in source but not yet operationally confirmed.
- Next step: user should run the existing local wrapper `%USERPROFILE%\EVA-Automation\Start-Eva-With-GitHubMemory.ps1` once (or run the downloaded updater directly from an elevated/appropriate PowerShell session). The wrapper will fetch the new updater and attempt the change. Then verify console output `EVA_SCHEDULE_TWO_HOURLY_VERIFIED`; if a warning appears, retain the backup and investigate rather than assuming success.
- Do not claim the cadence changed until the local script output or a read-back of the registered task confirms it. Do not modify the four existing triggers manually in parallel.
