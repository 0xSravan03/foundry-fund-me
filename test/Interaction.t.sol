// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DeployFundMe} from "../script/FundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../script/Interactions.s.sol";
import {Test} from "forge-std/Test.sol";

contract InteractionTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
    }

    function testUserCanFund() external {
        FundFundMe fundFundme = new FundFundMe();
        fundFundme.fundFundMe(address(fundMe));

        assertEq(fundMe.getFunders(0), msg.sender);
    }

    function testOwnerCanWithdraw() external {
        FundFundMe fundFundme = new FundFundMe();
        fundFundme.fundFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 1e18);

        WithdrawFundMe withdrawfundme = new WithdrawFundMe();
        withdrawfundme.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}