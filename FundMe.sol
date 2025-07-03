// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18;
    address[] public funders;
    mapping (address funders => uint256 amountFunded) public addressToAmountFunded;
    address public owner;
    
    constructor() {
        owner  = msg.sender;
    }

    function fund() public payable  {
          require(msg.value.getConversionRate() >= minimumUsd, "didnt send enough eth");
          funders.push(msg.sender);
          addressToAmountFunded[msg.sender] += msg.value;
    }
    

    function withdraw() public onlyOwner{ 
        for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++){
           address funder = funders[fundersIndex];
           addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}(""); 
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the right person to use this");
        _;
    }
}
