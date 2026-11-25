# EVA — durable working context
Updated: 2026-11-25 18:17 Europe/Zagreb

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
Current GitHub helper blob: `4f1043e56bc5c129834f62c2f4cb8cad24d50af4`. Its Prepare action writes only this short prompt: “EVA: Probudi se. Ucitaj EVA_CONTEXT.md s GitHuba i nastavi oba projekta prema protokolu.” It does not download/embed the context.
Current wrapper blob: `4899d01dd6cace4a539e06f40d0b0e8774435f89`; it runs helper Prepare, then existing Start-Eva.ps1. Launcher source and current local URL have not been inspected in this activation.
Confirmed: user previously saw the activation message arrive automatically; a prior run reached the target conversation but ChatGPT reported its context window was full. Current exact target URL/state is not independently verified.
Do not create a new task, open a second browser window, change the Chrome target, or ask the user to re-enable auto-send. The short prompt fixes oversized-message transport, but cannot free capacity in an already exhausted conversation.

### Context-window diagnosis (2026-11-25)
- Confirmed helper source sends a short trigger only.
- Confirmed this context file had grown to 34,886 characters / 204 lines, including many overlapping dated updates and stale intermediate states. Fetching the whole file on every activation needlessly consumes context and can compound pressure.
- Most likely cause of the repeated full-window warning: the same long-running target conversation has accumulated too much transcript. A short new message cannot reduce its existing context.
- Secondary contributor: repeatedly loading this oversized append-only context into the same conversation adds more tokens. The old file is preserved in the archive; use this compact file for routine activation.
- A truly exhausted conversation cannot be repaired by PowerShell, shortening the prompt, or compacting GitHub memory. This change reduces future context load but does not reset the existing ChatGPT conversation.
- Next diagnostic only if needed: inspect the actual local `EVA-ChatGPT-URL.txt` and launcher log without changing them; determine whether the warning is from the same exhausted target or a different failure stage. Do not guess or overwrite the URL.

## Project B — crypto strategy research (PAPER only)
- Objective: prove positive net expectancy after fees, spread and slippage; code creation alone is not success. No live orders, real funds, API secrets or funded accounts.
- Existing scripts: `eva_tick_research.py` v1.0 and `eva_tick_research_1_1.py` v1.1 in Library.
- v1.0 seven-day BTCUSDT/SOLUSDT baseline: holdout marked returns at targets 0.20/0.30/0.50/0.75/1.00% were BTC -1.2148/-0.5895/-0.0688/+0.2178/+0.3317%; SOL -1.8139/-1.0194/-0.2541/+0.1397/+0.3249%. Positive rows have only 9–16 closed trades and every row ends with an open position. Preliminary only; not proof of edge.
- Both versions have a confirmed train/test boundary state leak: `switch_to_test()` changes phase but does not reset `previous_price`; the first test tick can trigger using the last training tick. v1.1 source also uses one 70/30 split, trade-price aggTrades and assumed fixed costs, not bid/ask spread.
- Next: patch boundary reset and add deterministic regression test; then build chronological train/validation/untouched holdout and walk-forward evaluation with realistic execution costs and adequate sample size. Locate/recreate v1.1 results. No profitability claim until verified.

## Other long-term direction
Physical/mobile EVA embodiment with perception, speech and real-world interaction; long-range only, not a distraction from current activation and research priorities.

## Activation protocol
1. Read this compact file first.
2. Identify confirmed facts, uncertainties and the highest-value next action.
3. Continue both active projects when meaningful: A) continuity/automation; B) crypto PAPER research.
4. Consult the archive only for a specific missing historical fact, not as routine context.
5. After meaningful verified work, re-fetch this file, append a concise update to the relevant project section, commit to main, then fetch again to verify. If GitHub write-back fails, state the blocker.
6. Never claim the Windows scheduled activation, assistant-side GitHub retrieval, research execution or write-back succeeded without direct evidence.
