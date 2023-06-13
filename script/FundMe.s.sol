// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundMe;

    function run() external returns (FundMe) {
        // we won't spend gas for deploying HelperConfig because it is outside vm.startBroadcast()
        // This will only simulate
        HelperConfig helperConfig = new HelperConfig();
        // Way used to read struct data, when struct have multiple fileds then seperate it by commas
        // Similar to function returning multiple values.
        (address ethUsdPricefeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        fundMe = new FundMe(ethUsdPricefeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
