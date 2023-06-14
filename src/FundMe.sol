// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    error FundMe__NotOwner();

    using PriceConverter for uint256;

    mapping(address => uint256) private addressToAmountFunded;
    address[] private funders;

    address public immutable i_owner;
    address public immutable i_priceFeedAddress;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // 5 USD

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        i_priceFeedAddress = _priceFeedAddress;
    }

    function fund() public payable {
        require(msg.value.getConversionRate(i_priceFeedAddress) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(i_priceFeedAddress);
        return priceFeed.version();
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // Resetting the Array by assigning empty array

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Transfer Failed");
    }

    // Getter functions
    function getAddressToAmountFunded(address _address) external view returns (uint256) {
        return addressToAmountFunded[_address];
    }

    function getFunders(uint256 _index) external view returns (address) {
        return funders[_index];
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
