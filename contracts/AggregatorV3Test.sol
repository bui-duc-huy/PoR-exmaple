// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract AggregatorV3Test is AggregatorV3Interface {
    int256 _answer;
    uint256 _updatedAt;
        
    function setRoundData(int256 answer) external {
        _answer = answer;
        _updatedAt = block.timestamp;
    }

    function decimals() external override view returns (uint8) {
        return 18;
    }

    function description() external override view returns (string memory) {
        return "Reserves for Example PoR token";
    }

    function version() external view returns (uint256) {
        return 0;
    }

    function getRoundData(uint80 _roundId) external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (
            0,
            _answer,
            0,
            _updatedAt,
            answeredInRound
        );
    }

    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (
            0,
            _answer,
            0,
            _updatedAt,
            answeredInRound
        );
    }
}
