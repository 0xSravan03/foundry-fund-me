// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract TestFundMe is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");

    function setUp() external {
        // Here first we deploy DeployFundMe contract and then call run() function
        // This allow TestFundMe to use script for deployment.
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, 100e18); // Funding USER with 100 ETH
    }

    function testMinimumUSDShouldSetToFive() external {
        assertEq(fundMe.MINIMUM_USD(), 5 * (10 ** 18));
    }

    function testOwnerShouldBeMsgSender() external {
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

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
        _;
    }

    function testShouldUpdateFundersAndAmountDetailsWithEnoughETH() external {
        vm.prank(USER); // Means the next tx is sent by the USER
        fundMe.fund{value: 1 ether}();
        assertEq(fundMe.getAddressToAmountFunded(USER), 1 ether);
        assertEq(fundMe.getFunders(0), USER);
    }

    function testOnlyOwnerCanWithdraw() external funded {
        vm.expectRevert(FundMe.FundMe__NotOwner.selector);
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() external funded {
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() external funded {
        // By using hoax (forge std library) , it will create a new address with fund and use that
        // address as msg.sender for next tx.
        hoax(address(uint160(1)), 10e18); // do vm.prank() and vm.deal()
        fundMe.fund{value : 1e18}();

        hoax(address(uint160(2)), 10e18);
        fundMe.fund{value : 5e18}();

        // fund using contract
        for (uint160 i = 10; i < 12; i++) {
            hoax(address(i), 10e18);
            fundMe.fund{value : 2e18}();
        }

        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.i_owner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }
}
