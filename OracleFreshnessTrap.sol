// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IAggregatorV3 {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract OracleFreshnessTrap is ITrap {
    address public owner;
    // <- aggregator pre-set to your Hoodi mock address:
    address public aggregator = 0x92e44E659F3c7DBd734Ad2046425b55148D65c96;
    uint256 public maxAgeSeconds;
    uint256 public maxPctJump; // basis points (e.g., 500 = 5%)

    event OracleStale(address aggregator, uint256 ageSeconds, uint256 blockNum);
    event OracleJump(address aggregator, int256 previous, int256 current, uint256 pctBps, uint256 blockNum);

    constructor() {
        owner = msg.sender;
        maxAgeSeconds = 300; // default 5 minutes
        maxPctJump = 1000;   // default 10% (1000 bps)
    }

    // management
    function setAggregator(address _agg) external {
        require(msg.sender == owner, "only owner");
        aggregator = _agg;
    }

    function setThresholds(uint256 _maxAgeSeconds, uint256 _maxPctBps) external {
        require(msg.sender == owner, "only owner");
        maxAgeSeconds = _maxAgeSeconds;
        maxPctJump = _maxPctBps;
    }

    // --- FIXED SIGNATURES ---

    function collect() external view override returns (bytes memory) {
        (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(aggregator).latestRoundData();
        uint256 age = block.timestamp - updatedAt;
        return abi.encode(aggregator, answer, updatedAt, age);
    }

    mapping(uint256 => int256) public samplePrice;
    uint256 public sampleSlot;

    function writeSample(int256 price) external {
        require(msg.sender == owner, "owner-only");
        samplePrice[sampleSlot] = price;
        sampleSlot++;
    }

    function shouldRespond(bytes[] calldata /* data */) external pure override returns (bool, bytes memory) {
        // dummy implementation just to satisfy interface
        return (false, "");
    }
}
