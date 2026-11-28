# Project 2 — Cryptocurrency strategy research

> Scope: quantitative research and PAPER-only strategy testing. This project is independent of EVA self-development. Never use real funds, API keys with trading permissions, or live orders.

## Project B — crypto strategy research (PAPER only)
- Objective: prove positive net expectancy after fees, spread and slippage; code creation alone is not success. No live orders, real funds, API secrets or funded accounts.
- Existing scripts: v1.0 and v1.1 in Library; corrected v1.2 and its regression test are preserved in /EVA-Project/. A boundary-reset correction derived from the audit is now preserved as `eva_tick_research_1_3_boundary_reset.py`.
- v1.0 seven-day BTCUSDT/SOLUSDT baseline: holdout marked returns at targets 0.20/0.30/0.50/0.75/1.00% were BTC -1.2148/-0.5895/-0.0688/+0.2178/+0.3317%; SOL -1.8139/-1.0194/-0.2541/+0.1397/+0.3249%. Positive rows have only 9–16 closed trades and every row ends with an open position. Preliminary only; not proof of edge.
- v1.1 source has a confirmed train/test boundary state leak: `switch_to_test()` changes phase but does not reset `previous_price`; the first test tick can trigger using the last training tick. v1.1 also uses one 70/30 split, trade-price aggTrades and assumed fixed costs, not bid/ask spread.
- v1.2 fixed the `previous_price` boundary leak and its local regression tests passed, but the audit found a second boundary problem: the boundary method did not explicitly reset the test account state. The corrected artifact now makes the test account reset explicit and a focused regression proves that after a forced train position, the test phase starts with START_CASH, zero quantity, and `previous_price=None`; the first test tick cannot enter solely because of the last train tick.
- Therefore, the earlier v1.2 results are not to be promoted as proof of advantage. Any result generated with an inherited train position is methodologically invalid for final ranking.

## Crypto research checkpoint — 2026-11-26
- Detailed audit and source register: [EVA_CRYPTO_RESEARCH_LOG_2026-11-26.md](./EVA_CRYPTO_RESEARCH_LOG_2026-11-26.md). Distinct tracks preserved: EVA TICK, EVA RISING, EVA MICRO MOVEMENT, Hyperliquid leader-copy, Binance/Kopyon IAmAzy, and Binance Off-Duty Santa portfolio 5310189297466041857.
- Re-ran EVA TICK 1.2 compilation and all three train/test-boundary regression tests; all passed. No new market-data backtest ran because Binance Data Vision and Hyperliquid API hosts failed DNS resolution in this execution environment. No results were fabricated.
- Audited prior models: TICK remains a trade-price-only exploratory baseline with incomplete spread/queue/latency modelling and open-position holdout rows; RISING 0.20 is below cost break-even and has no stop/time exit; MICRO MOVEMENT uses mid-price thresholds rather than OFI and resets paper state on restart; Hyperliquid copy can miss fills and fail to reconcile positions after reconnect.
- Archived Binance Off-Duty Santa AKEUSDT sample: 158 closed positions, reported PnL 10.6952 USDT, 69.0% held under one minute; this is a short single-symbol sample, not verified edge. Reported SOXLUSDT PnL is a separate TradFi-linked leveraged perpetual, not crypto.
- Primary next research candidate: signed aggressive trade flow + order-flow imbalance + microprice with spread/depth filters, pessimistic taker fills and latency stress. Professional disclosures support hedging, inventory control and execution quality as core differences; they do not reveal a directly replicable retail strategy. PAPER only; no bot or copy-trader code changed.

## Research discipline
- Require positive net expectancy after fees, spread, slippage, and latency.
- Use chronological train/validation/untouched holdout and walk-forward testing.
- Prevent look-ahead, leakage, survivorship bias, and test-set optimization.
- Compare against no-signal, time-aligned controls, buy-and-hold, and random-entry baselines.
- Clearly label missing data, failed downloads, unverified claims, and limitations.
- A strategy is not validated until its edge survives out-of-sample testing and realistic execution costs.

## Research run — 2026-11-27
- Re-audited EVA TICK 1.2 before any new ranking. The previously identified boundary fix remains valid: test starts with `previous_price=None`, and the three local boundary tests passed in the 2026-11-26 audit.
- Confirmed again that no historical market backtest was run in this cycle because the required public Binance Data Vision archive host was not reachable from the runtime; no data or results were fabricated.
- The existing 1.2 implementation is not yet sufficient for the requested research standard: no train/validation/walk-forward selection, no locked holdout, no time-aligned/random-entry/buy-hold controls, no signed aggressive-flow features, no explicit spread model, and no forced time exit.
- Current cost anchor: Binance's published Regular User Spot maker/taker rate is 0.100%/0.100%; our research floor remains 0.24% round-trip including the prior fee+slippage assumption, but that must not be described as a complete spread-inclusive model.
- Decision: do not rank or promote the old uptick/fixed-TP results. The next implementation gate is a new event-driven research harness using actual loaded time ranges, quantity + buyer-maker fields, fixed time exits, explicit spread/slippage stress, time-matched controls, and expanding walk-forward selection. No profitability claim until that harness produces reproducible OOS results.

## Research run — 2026-11-28
- Full source audit of `eva_tick_research_1_2.py` found and corrected a concrete boundary-state flaw: resetting `previous_price` alone is not sufficient for an independent holdout; the test account must also be explicitly initialized flat at the boundary. The correction is preserved in `/EVA-Project/eva_tick_research_1_3_boundary_reset.py`.
- Focused regression passed: a forced train position existed before the split; after `switch_to_test()`, test quantity was 0, test cash returned to START_CASH, `previous_price=None`, and the first test tick did not open a position from the last train tick.
- No historical market-data backtest was run this cycle. Direct DNS resolution to `data.binance.vision` failed in the execution environment, so this run produced a methodology/code result, not a market result.
- Fresh official Binance fee check: the current Spot fee table lists Regular User maker/taker at 0.100%/0.100%; this establishes 0.20% fee-only round-trip before spread/slippage. Therefore the research floor of 0.24% remains intentionally conservative but is not a full execution-cost model.
- Method decision: old fixed-TP/uptick results remain exploratory and are excluded from strategy ranking. The next valid candidate must use train-only parameter selection, a validation slice, untouched holdout, expanding walk-forward, time-matched no-signal/random-entry controls, and cost stress above the 0.24% floor. Primary feature hypothesis remains signed aggressive flow + OFI/microprice + volatility/spread filters, with short-horizon mean reversion and high-selectivity momentum tested as competing hypotheses.
