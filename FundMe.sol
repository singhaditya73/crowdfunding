// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18;
    address[] public funders;
    mapping (address funders => uint256 amountFunded) public addressToAmountFunded;
    function fund() public payable  {
          require(msg.value.getConversionRate() >= minimumUsd, "didnt send enough eth");
          funders.push(msg.sender);
          addressToAmountFunded[msg.sender] += msg.value;
    }
    

    function withdraw() public { 
    }

    
}
