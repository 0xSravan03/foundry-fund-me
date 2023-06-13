// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

// Used for,
// 1. Deploy Mock when we are on local anvil chain
// 2. Determine price feed address if we are on any real network

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed; // eth/usd pricefeed address
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({ priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 });
        return sepoliaNetworkConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {

    }
}