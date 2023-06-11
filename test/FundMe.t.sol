// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract TestFundMe is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    function setUp() external {
        // Here first we deploy DeployFundMe contract and then call run() function
        // This allow TestFundMe to use script for deployment.
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumUSDShouldSetToFive() external {
        assertEq(fundMe.MINIMUM_USD(), 5 * (10 ** 18));
    }

    function testOwnerShouldBeTestFundMeContract() external {
        // Because FundMe contract is deployed by TestFundMe contract, so owner will be TestFundMe.
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceConverterVersionIsFour() external {
        assertEq(fundMe.getVersion(), 4);
    }
}
