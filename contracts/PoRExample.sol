// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MintableTokenWithPoR is Ownable, ERC20 {
    uint256 private _minimumTimePerRound;
    AggregatorV3Interface private _feed;

    constructor(address feed, uint256 minimumTimePerRound) Ownable() ERC20("Example PoR", "EP") {
        _feed = AggregatorV3Interface(feed);
        _minimumTimePerRound = minimumTimePerRound;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        (, int256 answer, , uint256 updatedAt, ) = _feed.latestRoundData();

        require(updatedAt > block.timestamp - _minimumTimePerRound, "PoR Example: Answer outdate");

        uint256 currentSupply = totalSupply();
        uint256 reserves = uint256(answer);
        
        uint8 trueDecimals = decimals();
        uint8 reserveDecimals = _feed.decimals();

        if (trueDecimals < reserveDecimals) {
            currentSupply =
                currentSupply *
                10**uint256(reserveDecimals - trueDecimals);
        } else if (trueDecimals > reserveDecimals) {
            reserves = reserves * 10**uint256(trueDecimals - reserveDecimals);
        }

        require(currentSupply + amount <= reserves, "PoR Example: Invalid reserves");

        _mint(to, amount);
    }

    function getFeed() external view returns (address) {
        return address(_feed);
    }

}
