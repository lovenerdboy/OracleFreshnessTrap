// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal mock of Chainlink/AVS-style V3 aggregator to satisfy:
/// (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
contract MockAggregatorV3 {
    address public owner;

    uint80  public roundId;
    int256  public answer;
    uint256 public startedAt;
    uint256 public updatedAt;
    uint80  public answeredInRound;

    event NewRound(uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(int256 _initialAnswer) {
        owner = msg.sender;
        // initialize a first round
        _setLatest(_initialAnswer);
    }

    /// @notice Chainlink-compatible view
    function latestRoundData()
        external
        view
        returns (
            uint80 _roundId,
            int256 _answer,
            uint256 _startedAt,
            uint256 _updatedAt,
            uint80 _answeredInRound
        )
    {
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }

    /// @notice Quick setter: increments roundId and sets timestamps to block.timestamp
    function setLatestAnswer(int256 _answer) external onlyOwner {
        _setLatest(_answer);
    }

    /// @notice Fully custom setter: lets you set explicit timestamps (useful to simulate stale data)
    function setRoundData(
        uint80 _roundId,
        int256 _answer,
        uint256 _startedAt,
        uint256 _updatedAt,
        uint80 _answeredInRound
    ) external onlyOwner {
        roundId = _roundId;
        answer = _answer;
        startedAt = _startedAt;
        updatedAt = _updatedAt;
        answeredInRound = _answeredInRound;
        emit NewRound(roundId, answer, startedAt, updatedAt);
    }

    /// @notice helper to mark the aggregator zero-address-safe (not strictly necessary)
    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    function _setLatest(int256 _answer) internal {
        roundId = roundId + 1;
        answer = _answer;
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = roundId;
        emit NewRound(roundId, answer, startedAt, updatedAt);
    }
}
