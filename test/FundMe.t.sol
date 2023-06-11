// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract TestFundMe is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumUSDShouldSetToFive() external {
        assertEq(fundMe.MINIMUM_USD(), 5 * (10 ** 18));
    }

    function testOwnerShouldBeTestFundMeContract() external {
        // Because FundMe contract is deployed by TestFundMe contract, so owner will be TestFundMe.
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceConverterVersionIsFour() external {
        assertEq(fundMe.getVersion(), 4);
    }
}
