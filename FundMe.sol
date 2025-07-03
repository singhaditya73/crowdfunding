// get funds from user
// withdraw funds
// set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    function fund() public payable  {
          require(msg.value >= 1e18, "didnt send eenough eth");
    }

    function withdraw() public { 
    }

    function getPrice() public view returns (uint256) {
        // address  0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,)= priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }
    function getConversionRate() public {}
}
