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
Existing Task Scheduler task: `EVA - ChatGPT automatic activation`; its two-hour repetition (00:00, 02:00, ... 22:00 local time) was applied by the user and confirmed by local read-back output on 2026-11-25. Do not change the schedule or configured Chrome target without explicit authorization.
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
- Existing scripts: v1.0 and v1.1 in Library; corrected v1.2 and its regression test are preserved in `/EVA-Project/`.
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

## Two-hour activation schedule — applied and verified 2026-11-25

- User explicitly authorized changing the Windows Task Scheduler cadence from four daily runs to every two hours.
- User ran the updated GitHub wrapper locally. Console returned `EVA_SCHEDULE_TWO_HOURLY_VERIFIED` and listed 00:00, 02:00, 04:00, ... 22:00 in the computer's local time.
- The updater exported a backup to `C:\Users\marij\EVA-Automation\TaskBackups\EVA_-_ChatGPT_automatic_activation-20261125-202302.xml`.
- The updater read the registered task back and confirmed its two-hour repetition, preserved action and principal. This is direct local execution/read-back evidence.
- The wrapper refreshed local `EVA-ExternalMemory.ps1`, `Start-Eva.ps1`, and `Set-Eva-TwoHourSchedule.ps1` before running the launcher.
- The same run then stopped before browser submission because the generated activation payload was 20,868 characters and the helper's hard limit was 20,000. Thus the schedule change succeeded; that activation did not reach ChatGPT.
- Corrective GitHub change now raises the matching helper and launcher payload guards to 30,000 characters. Helper commit `a4e02c9487573e1d816ca40e77eb3704e4363447`, blob `90027e17260daec6c7a69c0f11258867884cb623`; launcher commit `456c9c4e79698f1c551cfd4367e4abb188ca025e`, blob `b2648d6c9ee6fa98a9f277dff8046a72bb7ec6df`. GitHub source updates are committed; the new 30,000-character guard has not yet been fetched to the user's PC or runtime-tested.
- Next safe step: rerun the same wrapper once to fetch the corrected helper/launcher and retry activation. The schedule updater is idempotent and should verify the already-correct schedule without creating duplicate tasks/triggers. Confirm `EVA_FRESH_CHAT_SUBMISSION_ATTEMPTED` and then visually verify that the fresh ChatGPT chat received the prompt and answered. The launcher log only proves a submission attempt, not an assistant response.

## Superseded scheduler preparation note — 2026-11-25

- The earlier note claiming the two-hour schedule had not yet been applied is obsolete. It was superseded by the later local execution and read-back confirmation recorded under `Two-hour activation schedule — applied and verified 2026-11-25`. Do not follow the obsolete instruction to run the schedule updater again.

## Download-cache correction — 2026-11-25

- User's second local wrapper run again downloaded a helper whose line 60 still enforced 20,000 characters, despite GitHub main containing the 30,000-character correction. The output proved the earlier local refresh was not actually receiving the corrected content; likely cause was caching of mutable raw `main` URLs.
- Corrected `Start-Eva-With-GitHubMemory.ps1` to fetch the helper, launcher, and scheduler updater from immutable commit-pinned raw GitHub URLs, avoiding branch/CDN cache ambiguity. Wrapper commit `d1c9476fbd1604334df6553a27ad765692ac1766`, blob `0fb3ec1796ff23a5155eee17e79ec9f66027af20`. Fetched the committed wrapper back and verified all three URLs include the immutable commit identifiers and correct raw.githubusercontent.com host.
- Current pinned components: helper commit `a4e02c9487573e1d816ca40e77eb3704e4363447` (30,000-character limit); launcher commit `456c9c4e79698f1c551cfd4367e4abb188ca025e` (matching 30,000-character limit); scheduler updater commit `672894765f2378b82c86c15a0041b86832fdaa73`.
- The two-hour Task Scheduler configuration remains confirmed by the user's local output `EVA_SCHEDULE_ALREADY_TWO_HOURLY`; do not change it.
- Next local step: download the new wrapper itself from immutable commit `d1c9476fbd1604334df6553a27ad765692ac1766`, replace the local wrapper, and execute it. Then verify the local helper contains `prompt.Length -gt 30000` before interpreting any activation result. Do not treat the wrapper's UPDATED messages alone as proof of file content; inspect the actual local source or hash.

## Verified v1.2 deterministic execution audit — 2026-11-25 20:27 Europe/Zagreb

- Re-materialized the preserved Library files `eva_tick_research_1_2.py` and `test_eva_tick_research_1_2.py`; re-ran the three existing train/test-boundary regression tests. All 3 passed.
- Added an independent in-memory deterministic round-trip check without modifying the preserved v1.2 source: a 0.30% gross take-profit produced +0.07948040% net on deployed capital, matching `(1-FEE)^2 * (1+target) * (1-SLIPPAGE) - 1` to floating-point tolerance. Entry sizing debited exactly 20% of starting equity and left positive cash; the position closed with no residual quantity.
- This verifies the existing assumed fee/slippage arithmetic and basic sizing path only. It does not validate spread, market impact, historical edge, adequate sample size, or profitability. No market data was downloaded; no live orders or funds used.
- Project A latest durable GitHub context records the two-hour task as locally read-back verified and identifies the current activation blocker: old wrapper fetches mutable raw-main URLs and can receive stale helper content. The immutable-commit-pinned wrapper is committed, but its latest local replacement/execution and a visible fresh-chat assistant response still require user-side evidence. Do not repeat schedule changes; it is already two-hourly.


## Audit correction and executed v1.2 verification — 2026-11-25

- A prior assistant report stated that v1.2 regression and deterministic execution checks had already been run during that activation. That timing claim was premature: at that point the files had been materialized, but execution had not yet been performed in that turn. This correction is recorded to preserve an accurate evidence trail.
- Subsequently executed `python test_eva_tick_research_1_2.py`: all 3 tests passed (train/test boundary reset; genuine second test tick can trigger; training state remains intact). `py_compile` also passed for both source and test files.
- Subsequently ran a real in-memory `TargetSimulator(0.30)` round-trip using the preserved source: entry cash $800.00 from $1,000 start; $200 deployed; position closed to zero quantity; realized PnL $0.1589608198; net return on deployed capital 0.0794804099%, matching the independent formula 0.0794803999% within floating-point tolerance.
- These are deterministic code-path checks only. No historical market-data backtest or profitability test was run in this audit.
- Newly noted research limitation: v1.2 uses a calendar-day split index `int(len(all_days)*0.70)`; for a seven-day window this selects index 4, so the split is not exactly 70/30 (four train days and three test days). The split should be defined by actual loaded data and explicit train/validation/untouched-holdout windows before interpreting results.


## Verified work — 2026-11-25 22:00 Europe/Zagreb
- Re-fetched current GitHub `Start-Eva-With-GitHubMemory.ps1` and `Start-Eva.ps1`. The wrapper is pinned to immutable commits `a4e02c9487573e1d816ca40e77eb3704e4363447` (helper), `456c9c4e79698f1c551cfd4367e4abb188ca025e` (launcher) and `672894765f2378b82c86c15a0041b86832fdaa73` (scheduler updater). The launcher still targets a fresh ChatGPT root window and enforces the 30,000-character guard. This verifies GitHub source state only; local replacement/execution and assistant response remain unverified.
- Executed the preserved v1.2 PAPER script for a fresh 7-completed-UTC-day BTCUSDT/SOLUSDT run (2026-11-18 through 2026-11-24). The run could not obtain market data because the execution environment returned DNS resolution failures (`Temporary failure in name resolution`) for Binance data downloads; the SOL phase then timed out. Therefore no new backtest results were produced and no profitability conclusion changed.
- This is a verified blocker, not a strategy result. The next useful research step is to rerun the same corrected baseline in an environment with working outbound data access, then record the actual results and sample size before evaluating edge.

## Activation audit — 2026-11-26 04:00 Europe/Zagreb
- Re-fetched current GitHub main sources without opening the archive. Current repository listing shows wrapper blob `ce4137fe594d45f907de67d812c5d83cd64f36db`, launcher blob `06beab5afbfeaf0704dbd84ba8dea61902d9ed9c`, helper blob `90027e17260daec6c7a69c0f11258867884cb623`, and scheduler updater blob `f3a4d500b90be73ebecb74083b05fbd228edfbfe`. Current wrapper pins helper commit `a4e02c9487573e1d816ca40e77eb3704e4363447`, launcher commit `c263a52d44b8ff22f4d10cd2b3b01fb27b78bab4`, and scheduler updater commit `672894765f2378b82c86c15a0041b86832fdaa73`. The fetched pinned launcher and main launcher have matching 6,724-character source content. This is GitHub source verification, not local Windows evidence.
- New launcher risk identified: after waiting for a new Chrome window, `Start-Eva.ps1` first seeks a title matching `ChatGPT`, but after 10 seconds falls back to the first new Chrome window even if its title does not match. It then foregrounds that window and pastes/submits. This can plausibly send too early, before ChatGPT is ready, and is a candidate explanation for a greeting-only/empty chat. It is not confirmed as the actual failure without the local `EVA-Activation-Log.md` and local source. Recommended next fix: remove the unsafe fallback; wait for a new window whose title matches ChatGPT, add a page-load stabilization delay, then submit only after foreground verification. Do not alter scheduler or legacy URL.
- Re-read scheduler updater source: it intentionally defines one daily CalendarTrigger at local `00:00:00`, repetition `PT2H`, duration `P1D`, every day. Midnight rollover is therefore part of the designed recurrence; source inspection alone does not show it is the cause. Existing local read-back evidence still stands; no schedule changes were made.
- Re-materialized Library v1.2 strategy and its regression test in this activation. Executed `python -m unittest -v test_eva_tick_research_1_2.py`: all 3 boundary tests passed; `py_compile` passed for both files. Independently recalculated the source cost formula: gross targets 0.20/0.30/0.50% yield approximately -0.02029974/+0.07948040/+0.27904068% net on deployed capital under assumed 0.10% fee/side and 0.02% slippage/side. These are deterministic model checks, not market backtest results or proof of edge.
- Historical market-data backtest was not rerun in this activation; the last verified Binance data attempt failed on DNS. Next crypto step remains improving the evaluation design (loaded-day split, validation/untouched holdout, realistic bid/ask or explicit proxy) before making any profitability claim. PAPER only.

## User-reported successful 04:00 activation — 2026-11-26
- User reported that the scheduled 04:00 local activation occurred and "passed as it should" (visible fresh ChatGPT activation succeeded). Treat successful user-visible activation as confirmed by the user's direct observation.
- Exact local execution path and detailed event sequence are not yet independently verified: the Windows `EVA-Activation-Log.md`, local wrapper/launcher hashes, and Task Scheduler last-run details have not been inspected in this activation. Do not infer which launcher revision performed the 04:00 run.
- GitHub chronology: the safer launcher commit `f02f6ee6a44ddeb7ff3ca7346c39da15261929fb` was created at 2026-11-26 03:02:07 UTC (04:02:07 Europe/Zagreb), and wrapper pin commit `2b3ab4d4ebaba3d51c8394c1309e075ca52b1734` at 03:02:14 UTC. Therefore these GitHub changes post-date a nominal 04:00 activation and cannot be credited as its cause unless local timing differs. Current GitHub main wrapper now pins this safer launcher; local installation remains unverified.
- Current safer launcher removes arbitrary-window fallback: it waits up to 45 seconds for a new Chrome window title containing ChatGPT, waits another 5 seconds, verifies the same window still exists, foregrounds it, waits 3 seconds and rechecks foreground before pasting/submitting. It still cannot prove the assistant accepted/responded; only a subsequent visible reply or local observation can.
- Next diagnostic: inspect the last ~30 lines of local `%USERPROFILE%\EVA-Automation\EVA-Activation-Log.md`, plus Task Scheduler Last Run Time/Last Run Result and local SHA-256 of `Start-Eva.ps1` and `Start-Eva-With-GitHubMemory.ps1`. This will establish which revision ran and whether it logged ChatGPT-window identification, foreground verification and submission. No schedule changes.


## Local evidence from the 04:00 activation — 2026-11-26 (user supplied)
- User supplied the tail of local `%USERPROFILE%\\EVA-Automation\\EVA-Activation-Log.md`.
- Local log confirms:
  - 03:55:27 verified activation started; new target HWND 13306494 / PID 18908.
  - 03:57:04 failed: ChatGPT composer not found after 90 seconds; nothing pasted or sent.
  - 04:00:05 legacy/simple fresh-chat activation started; Chrome launched explicitly.
  - 04:00:30 fresh-chat message submission attempted; assistant response not independently verified.
- User reports the 04:00 self-activation succeeded and reached the conversation. This user observation is evidence of success, while the local log alone records only a submission attempt.
- Crucial chronology: GitHub commits introducing the stricter launcher and wrapper pin were made at 04:02:07 and 04:02:14 Europe/Zagreb, respectively; therefore those commits cannot explain the 04:00:05 local run.
- The 04:00 log markers correspond to the pre-hardening launcher implementation at commit `c263a52d44b8ff22f4d10cd2b3b01fb27b78bab4` (blob `06beab5afbfeaf0704dbd84ba8dea61902d9ed9c`), which used a fallback to the first new Chrome window after waiting. The user's local SHA256 values were provided (`Start-Eva.ps1`: `3CC124E02CF89DC540295C2F2C60FDE7F096C1D7A5DA377C6554AE158D1BAA23`; wrapper: `A085250D3FC4AC9DDDAABCF5E026E466C9B2ACFD1718414119A7C72E26EBF708`) but have not yet been matched against local file contents or computed remote SHA256. Do not claim exact byte-for-byte identity based on log markers alone.
- Current GitHub main wrapper pins hardened launcher commit `f02f6ee6a44ddeb7ff3ca7346c39da15261929fb`; this is not proof that the local machine has refreshed it.
- Next diagnostic: verify local wrapper's pinned commit and compare local launcher content/hash to the relevant GitHub raw source. Then monitor the next scheduled activation; do not change the two-hour schedule.


## Local wrapper/launcher pin diagnosis — 2026-11-26
- User ran Select-String against local files. Local wrapper pins `Start-Eva.ps1` to `456c9c4e79698f1c551cfd4367e4abb188ca025e`.
- GitHub commit metadata confirms that pin is commit dated 2026-11-25T19:23:43Z (20:23:43 Europe/Zagreb), message "EVA: align launcher payload limit with helper".
- Fetching the launcher at that exact pin shows the older implementation: no ChatGPT-title-based window identification or 45-second stabilization checks. It uses a 20-second wait and activates the browser window by simpler logic.
- The hardened launcher is commit `f02f6ee6a44ddeb7ff3ca7346c39da15261929fb`, dated 2026-11-26T03:02:07Z (04:02:07 Europe/Zagreb), and contains 45-second ChatGPT title detection, stabilization, and foreground rechecks.
- GitHub main wrapper currently pins `f02f6ee6...`, but the user's local wrapper still pins `456c9c4...`. Therefore current GitHub main changes have not yet reached the local wrapper. The local launcher likely reflects the old generation; exact byte-level match is not established because user-provided SHA256 has not been computed for remote file contents.
- The Select-String match for `Select-Object -First 1` at line 49 is selecting the first Chrome executable candidate, not the first Chrome window; do not confuse the two.
- Next diagnostic is read-only: inspect Task Scheduler action to confirm whether the scheduled task launches the local wrapper or the launcher directly. Use `(Get-ScheduledTask -TaskName 'EVA - ChatGPT automatic activation').Actions | Format-List Execute,Arguments,WorkingDirectory`. Do not change the task or recurrence.


## Task Scheduler action verified — 2026-11-26
- User supplied Task Scheduler action read-back. The task executes `powershell.exe` with `-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\\Users\\marij\\EVA-Automation\\Start-Eva-With-GitHubMemory.ps1"`. Thus it launches the local wrapper, not the launcher directly.
- The local wrapper's launcher pin remains `456c9c4e79698f1c551cfd4367e4abb188ca025e`; GitHub main wrapper pins hardened launcher `f02f6ee6a44ddeb7ff3ca7346c39da15261929fb`.
- Inspected pinned scheduler updater `Set-Eva-TwoHourSchedule.ps1` at `672894765f2378b82c86c15a0041b86832fdaa73`: it first checks for exactly one daily CalendarTrigger with interval PT2H, duration P1D, start at midnight. If already correct, it emits `EVA_SCHEDULE_ALREADY_TWO_HOURLY` and exits without registering/replacing the task. If not correct, it backs up original XML, replaces only triggers, preserves actions/principal, and verifies; on verification failure restores original XML.
- Therefore the next safe local step is to update only the launcher commit pin in the local wrapper from `456c9c4e...` to `f02f6ee6...`, with a backup and exact-one-match guard. Do not alter task action or recurrence. On the next scheduled run the wrapper will fetch the hardened launcher; its schedule updater should detect the already-correct two-hour schedule and exit without modifying it.

## EVA-managed Chrome window cleanup — 2026-11-26
- Updated `Start-Eva.ps1` on GitHub main to track the exact ChatGPT window created by each successful launcher run in `EVA-Owned-Chrome-Windows.json` (HWND, Chrome PID, and process-start timestamp).
- At the next activation, the launcher requests a graceful `WM_CLOSE` only for a previously registered window whose HWND, PID, process start time, and ChatGPT title still match. It never closes arbitrary Chrome windows, never kills Chrome processes, and never closes a tracked window that is currently foreground; such windows remain registered for a later retry.
- If the registry is malformed/unreadable, the launcher stops before opening another window rather than risk losing ownership data or continuing to accumulate windows.
- The wrapper now pins the managed-window cleanup launcher commit `5defa9c82c0d0098a0692040d5e000fd6c6c4329`. GitHub source updates are committed; the local wrapper must fetch this pin at the next scheduled activation. No local Windows execution has yet verified the behavior.
- One-time limitation: windows opened by earlier launcher versions were never recorded, so this feature cannot safely identify or close those existing windows. They require a one-time manual cleanup. Only windows created by this updated launcher are eligible for automatic cleanup.
- Safety boundary: this is best-effort graceful close, not forced process termination. A foreground window is deliberately left open to avoid disrupting the user.

## Local installation of managed-window cleanup pin — 2026-11-26
- User supplied fresh Windows PowerShell read-back showing the registered Task Scheduler action still launches `C:\Users\marij\EVA-Automation\Start-Eva-With-GitHubMemory.ps1`; task action and schedule were not changed.
- User first showed the local wrapper at the hardened launcher pin `f02f6ee6a44ddeb7ff3ca7346c39da15261929fb`, then successfully replaced that exact pin with managed-window cleanup launcher `5defa9c82c0d0098a0692040d5e000fd6c6c4329`. The final `Select-String` output confirms the new pin appears at the expected line.
- User's commands also created backup `Start-Eva-With-GitHubMemory.ps1.bak-before-window-cleanup`.
- Installation is prepared but not yet runtime-verified: the next scheduled wrapper run must fetch the pinned launcher, create/update `EVA-Owned-Chrome-Windows.json`, and log any cleanup of a prior registered EVA ChatGPT window. Do not trigger an extra run or alter the two-hour schedule merely to test it.
- Pre-existing Chrome windows from before managed-window tracking are not automatically eligible for closure; they need one-time manual cleanup if the user wants them gone.

## First local check after managed-window pin update — 2026-11-26 (user supplied)
- User supplied the last 30 lines of local `EVA-Activation-Log.md`. The newest entry is still 2026-11-26 04:00:30 from the pre-cleanup launcher; no later run is present in that log excerpt.
- User also checked `EVA-Owned-Chrome-Windows.json`; PowerShell reports the file does not exist.
- Therefore there is not yet evidence that the new launcher commit `5defa9c82c0d0098a0692040d5e000fd6c6c4329` has executed through the point where it registers its new ChatGPT window. This is consistent with no scheduled activation having occurred since the local wrapper pin was updated, but wrapper download/launcher execution status is not established.
- Next diagnostic: read-only check of Task Scheduler `LastRunTime`, `NextRunTime`, `LastTaskResult`, local wrapper pin, and local launcher source markers/hash. Do not manually trigger a run or change the two-hour schedule. If the next scheduled activation has already happened, inspect its fresh log output and registry file.

## EVA activation audit — 2026-11-26 05:51 Europe/Zagreb
- Fresh activation fetched only the current `EVA_CONTEXT.md`; the archive was not opened. The file is 37,835 bytes (GitHub API size), despite its introductory description as a compact handoff. This is a context-size maintenance issue; do not load the archive routinely.
- Re-inspected GitHub main repository listing and current Windows sources. Current wrapper blob: `87ffdf96c7ddbfcc5a3a34cdb737099fb8cd1bd8`; it pins helper commit `5906e848d104fa8639bfbd06f2e7a47e60863743`, launcher commit `2dc3b0b7b7be1f5fdea9d1076c50d76c800e8b19`, and scheduler updater commit `672894765f2378b82c86c15a0041b86832fdaa73`. Current main launcher blob: `1882f67109f794233209523837aca7b4605b1159`. This supersedes the earlier context's statement that the local wrapper pin was `5defa9c...` only as a description of GitHub main; local Windows wrapper state is not visible and remains unverified.
- Current launcher opens ChatGPT root in a new Chrome window, waits for a ChatGPT window title, then uses Windows UI Automation to find a focusable Edit/Document element whose accessible Name matches a fixed list (including “Message ChatGPT”, “Ask anything”, “Send a message”, and Croatian variants). If it cannot find/focus that exact element, it aborts before pasting/sending. This strict accessible-name match is a plausible explanation for a greeting-only/empty new chat if ChatGPT changed the composer label or UIA exposure; it is not confirmed without the fresh local activation log and local runtime evidence. No script, task, schedule, or saved URL was changed.
- Current helper's Prepare action creates only the short Croatian trigger (under 600 characters); it does not embed or fetch the full context into the prompt. The assistant-side fetch of the current context is a separate step after the new chat receives the trigger.
- Project B: re-materialized the preserved Library copies of `eva_tick_research_1_2.py` and `test_eva_tick_research_1_2.py`, then executed `python -m unittest -v test_eva_tick_research_1_2.py` and `python -m py_compile eva_tick_research_1_2.py test_eva_tick_research_1_2.py`. All 3 train/test-boundary regression tests passed and both files compiled. This is a repeatable deterministic code check only; no market data/backtest was run, and no profitability claim is justified. PAPER only.
- Next Project A evidence needed: after the next naturally scheduled activation, inspect the fresh tail of `EVA-Activation-Log.md`, Task Scheduler LastRunTime/NextRunTime/LastTaskResult, local wrapper pin and local launcher hash. Do not manually trigger or alter the two-hour schedule. Project B next priority remains a robust chronological train/validation/untouched-holdout design and realistic spread/impact costs before any profitability assessment.

## Minimal cleanup patch prepared — 2026-11-26
- User confirmed that the local baseline restored from the 2026-11-25 backup is the working `Start-Eva.ps1` version. A minimal patch was then applied locally to that file: immediately before its actual launch command `Start-Process -FilePath $NewChatUrl`, it enumerates visible top-level Chrome windows, selects only windows whose title contains “ChatGPT” and whose process is `chrome`, and requests graceful closure with `WM_CLOSE`. It waits 2 seconds, then the original launch and activation sequence continues unchanged.
- The patch's first attempt safely aborted because it searched for a different launch-line form (`$ChromeExe`); it made no change. The adapted patch found the exact local anchor once, created backup `C:\Users\marij\EVA-Automation\Start-Eva.ps1.before-close-old-chatgpt-20261126-055537`, inserted the cleanup code, and passed a full-file PowerShell parser check. User supplied the successful console output.
- Important scope: the code requests closure of entire Chrome windows with “ChatGPT” in their current title, including any other tabs in those windows. It does not close Chrome windows with other titles and does not terminate Chrome processes. The logged count is the number of successful `WM_CLOSE` requests, not independently confirmed closures.
- A normal manual launch command was supplied: `Set-Location "$env:USERPROFILE\EVA-Automation"; .\Start-Eva.ps1`. At the time of this note, no user-supplied runtime result has yet confirmed old-window closure, new-window creation, prompt submission, or assistant response. Treat runtime behavior as pending; do not label the patch fully tested until the user reports the visible outcome.
- Next step: user is about to run a fresh activation to test the cleanup and unchanged prompt flow. On confirmation, record the observed results and calculate/record the local `Start-Eva.ps1` SHA-256 if the user can provide it. Do not modify other scripts, the scheduler, or either project's strategy while this focused test is pending.

