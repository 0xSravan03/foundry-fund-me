// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";

// For funding the contract
contract FundFundMe is Script {

    function fundFundMe(address contractAddress) public {
        vm.startBroadcast();
        FundMe(payable(contractAddress)).fund{value: 1 ether}();
        vm.stopBroadcast();
    }

    function run() external {
        address fundme = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
        fundFundMe(fundme);
    }
}

// For withdrawing fund from the contract
contract WithdrawFundMe is Script {

    function withdrawFundMe(address contractAddress) public {
        vm.startBroadcast();
        FundMe(payable(contractAddress)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address fundme = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
        withdrawFundMe(fundme);
    }
}