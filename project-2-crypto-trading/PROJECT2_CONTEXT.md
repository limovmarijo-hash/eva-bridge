# Project 2 — Cryptocurrency strategy research

> Scope: quantitative research and PAPER-only strategy testing. This project is independent of EVA self-development. Never use real funds, API keys with trading permissions, or live orders.

## Project B — crypto strategy research (PAPER only)
- Objective: prove positive net expectancy after fees, spread and slippage; code creation alone is not success. No live orders, real funds, API secrets or funded accounts.
- Existing scripts: v1.0 and v1.1 in Library; corrected v1.2 and its regression test are preserved in `/EVA-Project/`.
- v1.0 seven-day BTCUSDT/SOLUSDT baseline: holdout marked returns at targets 0.20/0.30/0.50/0.75/1.00% were BTC -1.2148/-0.5895/-0.0688/+0.2178/+0.3317%; SOL -1.8139/-1.0194/-0.2541/+0.1397/+0.3249%. Positive rows have only 9–16 closed trades and every row ends with an open position. Preliminary only; not proof of edge.
- v1.1 source has a confirmed train/test boundary state leak: `switch_to_test()` changes phase but does not reset `previous_price`; the first test tick can trigger using the last training tick. v1.1 also uses one 70/30 split, trade-price aggTrades and assumed fixed costs, not bid/ask spread.
- Next research priorities: after fixing and testing the boundary, build chronological train/validation/untouched holdout and walk-forward evaluation with realistic execution costs and adequate sample size. Recreate v1.1 baseline. No profitability claim until verified.

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
