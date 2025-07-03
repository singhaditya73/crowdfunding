// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

error notOwner();
error InsufficientEth();
error TransferFailed();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant minimumUsd = 5e18;
    address[] public funders;
    mapping (address funders => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;
    
    constructor() {
        i_owner  = msg.sender;
    }

    function fund() public payable  {
          //require(msg.value.getConversionRate() >= minimumUsd, "didnt send enough eth");
          if(msg.value.getConversionRate()< minimumUsd){
            revert InsufficientEth();
          }
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
        if (!callSuccess) {
            revert TransferFailed();
        }
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Not the right person to use this");
        if(msg.sender != i_owner) {revert notOwner();}
        _;
    }
}
