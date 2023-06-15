-include .env

build:; forge build
fundmetest:; forge test --match-path test/FundMe.t.sol
testFundme:; forge test

deploy-sepolia:
	forge script script/FundMe.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast