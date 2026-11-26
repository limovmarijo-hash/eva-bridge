# EVA Crypto Research Log — 2026-11-26

## Execution status

**No new market-data backtest was executed in this run.** Attempts to reach Binance Data Vision (`data.binance.vision`) and Hyperliquid's public API host failed at DNS resolution in the available execution container. The Kopyon API endpoint was not accessible through the available web reader, and no Kopyon API key was present in the available context. No prices, fills, or performance figures have been fabricated.

Concrete work completed:
- Inspected the archived EVA RISING 0.20, EVA TICK 1.0/1.1/1.2, EVA MICRO MOVEMENT and Hyperliquid PAPER-copy packages, along with the available Binance trader-analysis console outputs.
- Re-ran `py_compile` and the three EVA TICK 1.2 train/test-boundary regression tests. **All 3 tests passed.** These are code tests, not market backtests.
- Recomputed the archived Off-Duty Santa / AKEUSDT position summary from the saved terminal table.
- Researched verifiable professional market-making disclosures, public trader-data API limitations, and recent microstructure research.

No bot code, exchange account, API secret, or live order was changed or used.

## Experiment registry and audit

### A. EVA TICK RESEARCH 1.0 / 1.1 / 1.2

**Status: exploratory baseline only; no demonstrated edge.**

- Universe: Binance Spot BTCUSDT and SOLUSDT aggregate trades.
- Entry: first trade-price uptick while flat.
- Exit: fixed take-profit from simulated entry fill.
- Assumed costs: 0.10% fee per side and 0.02% slippage per side.
- v1.0 retained `previous_price` across the train/test boundary. The first test tick could therefore trigger an entry using the last training tick as its reference. v1.1/v1.2 reset this state; the three v1.2 regression tests pass.
- v1.2 still reads only price and timestamp from aggTrades. It discards quantity and `isBuyerMaker`, so it cannot test signed aggressive flow. It has no observed spread, order-book depth, queue position, latency, partial-fill model, or funding.
- The split is calculated from requested calendar days before knowing which archives actually loaded. Missing files can distort the true chronological split. There is no train/validation/walk-forward selection or locked final holdout.
- There is no forced time exit. Open positions at the end of the sample are not completed trades.

Archived 7-day v1.0-style CSV:
- BTC holdout returns at 0.20/0.30/0.50/0.75/1.00% targets: -1.2148/-0.5895/-0.0688/+0.2178/+0.3317%.
- SOL: -1.8139/-1.0194/-0.2541/+0.1397/+0.3249%.
- All ten rows ended with an open position; the CSV does not give a complete realized-PnL decomposition or the open-position unrealized-PnL amount. The positive 0.75% and 1.00% rows are therefore not completed-trade proof. Five target levels were exposed on the same short holdout, so selecting the best-looking one after inspection would contaminate that holdout.

Cost arithmetic from the actual v1.2 fill formulas:
- With 0.10% fee/side and 0.02% slippage/side, a 0.20% target measured from entry fill produces about **-0.02030% net on deployed capital**.
- Break-even target is about **+0.22034% from simulated entry fill**, equivalent to about +0.24039% market-price movement from the raw market entry before any separately modelled spread or additional impact.
- A 0.30% target gives about +0.07948% under those assumptions, but this is only a cost calculation. It does not establish predictive edge.

### B. EVA RISING 0.20

**Status: structurally negative at its configured target; not a candidate strategy.**

- Buys on the first uptick and exits only at +0.20% from entry fill.
- Uses 0.10% fee per side and 0.02% slippage per side.
- The configured target is below the model's cost break-even. The strategy also has no stop or time exit, so positions can remain open indefinitely.
- Persisted `last_price` is reused after restart/reconnect. The first post-gap trade can be compared with a stale pre-gap price and trigger a false uptick entry.
- The archived package contains source/state logic but no complete trade log sufficient to validate performance. Do not treat code presence as a completed PAPER experiment.

### C. EVA MICRO MOVEMENT

**Status: live-feed PAPER prototype, not a historical backtest or an order-flow strategy.**

- Hyperliquid public L2 top-of-book feed; thresholds 0.10/0.20/0.30% over a roughly 60-second reference window.
- Entry is based on mid-price movement, not signed trade flow or calculated order-flow imbalance.
- Exit controls: 0.20% hard stop, 0.10% trailing retreat and 30-minute time exit.
- It uses the observed bid/ask for simulated taker fills, plus an extra 0.01% adverse slippage per side and an estimated 0.045% taker fee per side. Fees for HIP-3/tokenized markets are not verified.
- It does not persist portfolio/position state or raw market events for deterministic replay. Restarting resets its virtual equity while CSV output can continue to append, making a combined log unsafe to interpret as one continuous account.
- It subscribes to BTC, ETH, SOL, ZEC, HYPE and HIP-3 markets including GOLD, MU and GOOGL, but the same base fee assumption must not be applied to all without checking their schedules.
- No archived performance log was found in the inspected package.

### D. Hyperliquid PAPER copy experiment

**Keep separate from Binance/Kopyon experiments.**

- Archived configuration: starting balance 1,000 USDC, copy multiplier 0.001, gross exposure cap 20%, estimated fee 0.05% per side.
- The account ledger is a PnL/exposure approximation, not a full exchange-margin simulator. It does not model funding, spread, slippage, queue position or liquidation.
- Confirmed reconnect weakness: `seed_positions()` returns immediately once any paper trade has been recorded or any position exists. After a disconnect, the monitor can receive a fresh clearinghouse snapshot but will not reconcile an already-active paper ledger to it.
- The monitor ignores snapshot fills and drops fills older than 120 seconds; it does not backfill the missed interval. The copied ledger can therefore diverge after downtime.
- The package contains code/configuration, not a complete verified performance history.

### E. Binance / Kopyon copy-trading tracks

**Do not merge these profiles or datasets with the Hyperliquid copy experiment.**

1. **IAmAzy — Binance Smart Money / SOLUSDT track**
   - Earlier code searched Kopyon `traderSearch` for IAmAzy and polled on a five-minute interval.
   - It tracked only newly observed filled/partially-filled orders; it did not import the trader's full prior history or establish a complete starting position.
   - Millisecond/WebSocket execution, delayed-copy slippage, fees/funding and profitability after costs were not validated.
   - Promotional posts and self-reported win rates are not accepted as evidence of a profitable track record.

2. **Off-Duty Santa — Binance Copy Trading portfolio 5310189297466041857**
   - Archived AKEUSDT terminal output spans 13–23 November 2026 and contains 158 closed positions: 118 shorts and 40 longs; 157 positive reported PnLs and one negative; reported PnL totals 10.69515781 USDT.
   - Recalculation from the archived table: estimated entry notional totals 949.6974 USDT (about 6.01 USDT per position); median holding time is 0.414 minutes (about 24.9 seconds); about 69.0% of positions lasted under one minute and 81.6% under five minutes. Eleven lasted at least one hour; the longest lasted about 4.05 days.
   - The sum of simple price-difference PnL reconstructed from average entry/exit and closed volume is 11.4581 USDT, about 0.7630 USDT above the reported PnL. The difference is not reconciled from the available extract; do not assume whether it represents fees, funding or contract-specific accounting.
   - This is one symbol and a short selected period, not the full trader record, not an independent strategy backtest and not proof of repeatable profitability. Open positions and tail risk are absent from the closed-position table.
   - One archived PowerShell overlap analysis has an empty true branch when selecting the earlier close time. Some overlap-duration calculations are therefore wrong; its overlap-duration results must not be reused without correction.

3. **SOXLUSDT concentration**
   - Prior analysis reported 4,029.28792450 USDT PnL attributed to SOXLUSDT, but the raw position export was not available for independent reconciliation in this run.
   - Binance's 15 May 2026 notice confirms SOXLUSDT is a USDT-margined perpetual tracking Direxion Daily Semiconductor Bull 3X ETF, with up to 20x contract leverage and eight-hour funding. It is a leveraged TradFi-linked derivative, not a cryptocurrency. Any strategy depending mainly on this result must be evaluated separately from the crypto objective.

Kopyon itself is a third-party aggregator, not an official exchange API. Its documentation says it reads publicly shared exchange/blockchain activity, offers REST trader/profile/position/history endpoints, and leaves missing or hidden fields explicit. Its site says public-board updates are polled around every ten seconds and can be up to twenty seconds stale because of shared caching; this is the provider's own description, not an independent latency measurement. Its public copy-trading page also says displayed returns are paper simulations with modelled fees, not the user's actual fills, fee tier or funding. Treat Kopyon data as a research input that must be reconciled to exchange records, not as audited proof.

## Professional evidence and research implications

### Verified / high-confidence evidence

- **Flow Traders**, a publicly listed market maker, reported FY2025 net trading income of €485.8m and net profit of €133.6m in its 2025 annual report. The report describes proprietary models, continuous liquidity provision, technology-intensive execution, risk management and hedging; it says the group hedges positions to minimize adverse price exposure rather than operating as a simple long-only or short-only directional book.
- These are group-wide audited results, not a separately disclosed crypto strategy PnL. They prove that the firm is a profitable multi-asset trading/liquidity business, not that its crypto desk alone earned a specific amount.
- Flow Traders' 29 October 2026 unaudited update reported digital-assets net trading income of €13.8m in Q3 2026 and €51.7m year-to-date, down 46% year-on-year. Segment net trading income is not net profit, and the update shows the crypto business remains sensitive to market activity and regime.
- Cont, Kukanov and Stoikov (Journal of Financial Econometrics, 2014) found that short-interval price changes in 50 US equities were strongly related to order-flow imbalance at the best bid/ask, with price impact inversely related to book depth. This is established market-microstructure evidence in equities; applying it to crypto is a testable hypothesis, not direct proof.
- A 2026 arXiv preprint, *Explainable Patterns in Cryptocurrency Microstructure*, studies one-second Binance Futures order-book/trade data across BTC, LTC, ETC, ENJ and ROSE. It identifies order-book imbalance, spread and VWAP-to-mid deviations as important short-horizon features. Its own BTC significance table is cautionary: taker outperformance vs buy-and-hold is not significant (p=0.7474); maker outperformance is also not significant (p=0.1056); only ETC/ENJ/ROSE taker results reach the reported 5% level. The study does not explicitly model latency and should be treated as a preprint, not as a validated deployable strategy.
- A 2025 Bybit LOB preprint comparing models at 100 ms to multi-second intervals reports that simpler models can match or outperform more complex networks when inputs and preprocessing are sound. This supports starting with interpretable features before deep models.

### Self-reported / not independently verified

- Wintermute describes its business as multi-venue algorithmic liquidity provision, short-term delta-neutral arbitrage, low-latency execution, integrated crypto/traditional-finance signals and proprietary-capital trading. These are useful descriptions of a professional operating model, but the public strategy page is not an audited strategy-level PnL record.
- Kopyon leaderboard scores and trader win-rate claims are not treated as audited track records.

### Plausible inference for our research

Professional market making is not simply “place two orders and collect the spread.” Its economics depend on pricing against informed flow, inventory skew/hedging, multi-venue execution, capital and fee access, depth, latency and the ability to stop quoting when adverse selection rises. A small PAPER system should first test whether it can forecast the next few seconds after costs; passive market making should come later, with queue/fill and adverse-selection modelling.

## Next highest-value experiments

1. **Signed aggressive flow + OFI + microprice (primary candidate).**
   - Use BTCUSDT, SOLUSDT and ETHUSDT initially.
   - Join trades with time-aligned L2/top-of-book events. From Binance aggTrades, retain quantity and `isBuyerMaker`: buyer-maker=true indicates aggressive sell volume; buyer-maker=false indicates aggressive buy volume.
   - Build simple, interpretable features: multi-level order-flow imbalance, top-of-book imbalance, microprice-minus-mid, signed aggressive volume, VWAP-to-mid deviations, spread, depth and short-horizon volatility.
   - Predict 1s/3s/5s/10s/30s forward returns, but trade only when expected move exceeds observed spread plus fee, slippage and latency buffer.
   - Compare taker execution at ask/bid with pessimistic inventory marking. Stress 100/250/500/1000 ms latency and higher costs. Use time exits; no indefinite positions.

2. **Extreme-flow exhaustion / short-horizon reversal.**
   - Test only after unusually large signed flow or price displacement followed by a measurable loss/reversal of imbalance and depth replenishment.
   - Compare with a pure momentum continuation rule under identical costs and time-aligned controls.

3. **Market making only after execution modelling.**
   - Require queue priority, partial-fill probability, trade-through assumptions, inventory skew, quote widening and a kill switch for extreme volatility/one-sided flow.
   - Explicitly test the October 2025 liquidation/flash-crash regime and other high-volatility periods. Do not infer maker profitability from spread capture alone.

4. **Copy trading as a separate benchmark.**
   - Preserve IAmAzy, Off-Duty Santa and Hyperliquid leader-copy experiments as separate datasets.
   - Test delayed-copy scenarios (10/20/60/300 seconds), actual source order changes, position reconciliation, fee/funding and missed-fill recovery. Do not modify the existing Kopyon PAPER bot until the user's earlier “do not change anything yet” constraint is superseded.

Before ranking any strategy: validate raw archive checksums, full time coverage, sequence/timestamp monotonicity and missing intervals; use actual loaded periods for chronological train/validation/locked holdout splits; run expanding walk-forward tests; compare buy-and-hold and time-matched random/no-signal controls; report expectancy, profit factor, drawdown, turnover, exposure and holding time. Reject any signal whose advantage disappears after costs or on unseen periods.

## Sources

- Binance Public Data repository: https://github.com/binance/binance-public-data
- Binance Spot fees: https://www.binance.com/en/fee/trading
- Binance SOXLUSDT perpetual announcement (15 May 2026): https://www.binance.com/en/support/announcement/detail/a2bce2686fc64a61b44c4335facafe7f
- Flow Traders Annual Report 2025: https://www.flowtraders.com/media/2s2pdl01/flow-traders-annual-report-2025.pdf
- Flow Traders 3Q 2026 trading update (29 October 2026): https://www.flowtraders.com/news/flow-traders-3q-2026-trading-update/
- Wintermute algorithmic trading disclosure: https://www.wintermute.com/algorithmic-trading
- Kopyon API reference: https://kopyon.com/docs/
- Kopyon product / copy-trading limitations: https://kopyon.com/
- Cont, Kukanov & Stoikov, *The Price Impact of Order Book Events*: https://doi.org/10.1093/jjfinec/nbt003
- Bieganowski & Ślepaczuk, *Explainable Patterns in Cryptocurrency Microstructure* (2026 preprint): https://arxiv.org/abs/2602.00776
- Wang, *Exploring Microstructural Dynamics in Cryptocurrency Limit Order Books* (2025 preprint): https://arxiv.org/abs/2506.05764
