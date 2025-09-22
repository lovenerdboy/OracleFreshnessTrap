// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OracleFreshnessResponder {
    event OracleFreshnessAlert(address aggregator, int256 answer, uint256 updatedAt, uint256 age);

    // No constructor
    function respondWithOracleFreshness(address aggregator, int256 answer, uint256 updatedAt, uint256 age) external {
        // simple on-chain action: emit a structured alert; in a real responder, could call guardian contracts, freeze actions, or notify an operator.
        emit OracleFreshnessAlert(aggregator, answer, updatedAt, age);
    }
}
