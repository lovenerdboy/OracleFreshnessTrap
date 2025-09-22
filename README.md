# OracleFreshnessTrap
# OracleFreshness PoC — Mock Aggregator + Trap + Responder

## Summary
This repository contains a small proof-of-concept that demonstrates a Drosera-style trap that checks the freshness and jump-size of an aggregator (Chainlink/AVS V3 style). It includes:

- `MockAggregatorV3.sol` — a minimal Chainlink-compatible mock aggregator you can control in tests.
- `OracleFreshnessTrap.sol` — the Drosera trap that `collect()`s the aggregator data and encodes `(aggregator, answer, updatedAt, age)`. (Note: `shouldRespond()` is a dummy/stub here to satisfy the `ITrap` interface.)
- `OracleFreshnessResponder.sol` — a simple responder that emits `OracleFreshnessAlert` events when called.
- `drosera.toml` — example Drosera configuration for the trap (Hoodi testnet).

## Files
- `src/MockAggregatorV3.sol`
- `src/OracleFreshnessTrap.sol`
- `src/OracleFreshnessResponder.sol`
- `drosera.toml`

## Behavior (high-level)
- `MockAggregatorV3` replicates `latestRoundData()` semantics and allows the owner to set answers or full round data (including custom timestamps), which is useful to simulate stale or fresh data.
- `OracleFreshnessTrap.collect()` calls `latestRoundData()` on its configured aggregator and returns `abi.encode(aggregator, answer, updatedAt, age)`.
- `OracleFreshnessTrap` exposes owner-only setters to change `aggregator`, `maxAgeSeconds`, and `maxPctJump` (basis points).
- `OracleFreshnessResponder.respondWithOracleFreshness(address aggregator, int256 answer, uint256 updatedAt, uint256 age)` simply emits `OracleFreshnessAlert` for auditability.

## Addresses (from your drosera.toml / code)
- `drosera.toml` response_contract (example): `0x48590b60d4278f6D92E1C9715A4241806b4d6Ac9`
- Trap `address` in your toml: `0x6e44186125DD209b951931F8DAc7143c360b0B87`
- Default aggregator embedded in trap source: `0x92e44E659F3c7DBd734Ad2046425b55148D65c96`
- RPC: `https://ethereum-hoodi-rpc.publicnode.com`

> If you deploy locally or to another address, update `drosera.toml` and the commands below.

## Quick build / compile (Foundry)
```bash
# from repo root
forge clean
forge build --force
