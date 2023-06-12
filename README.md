# Fund Me

## About
This is a minimal fund raising smart contract which allow users to fund the contract (Minimum $50) and the owner of the contract can withdraw it.
This project is using chainlink AggregatorV3 contract to fetch the ETH/USD price.

## Run Test
To run the test file use,
```bash
forge test
```
The test file is using ```FundMe.s.sol``` script file for deployment.

To run the test file in sepolia network, create a `.env` file and add the `SEPOLIA_RPC_URL=<Rpc-url -from-any-node-provider>`then run
```bash
forge test --fork-url $SEPOLIA_RPC_URL
```






