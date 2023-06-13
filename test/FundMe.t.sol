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
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceConverterVersionIsFour() external {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailIfNotEnoughEthSent() external {
        vm.expectRevert(bytes("You need to spend more ETH!"));
        // Here 0.001 ether is less than MINIMUM_USD ($50) so this will fail as per contract code
        fundMe.fund{value: 0.001 ether}(); 
    }

    function testShouldUpdateFundersAndAmountDetailsWithEnoughETH() external {
        fundMe.fund{value: 1e18}();
        assertEq(fundMe.getAddressToAmountFunded(address(this)), 1 ether);
        assertEq(fundMe.funders(0), address(this));
    }
}
