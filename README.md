# Smart Contracts for MetaBio

# Welcome to MetaBio

> a Web3 application to connect gardeners, farmers to crypto world. We aim to be the leading Web3 application for gardening/farming communities, inspire gardeners/farmers, and connect them and their data to enterprise and biology experts eventually

## Contracts

- [x] NFPlant - NFT Backed by plant

  - [x] Pay to Mint NFT
  - [x] Prevent unauthorized plant data by using Oracle
  - [x] Update NFT Metadata and reward token to users

- [ ] NFPot - Plant Pot

  - [ ] User needs to purchase plant pot to mint plant

- [x] MetaBioToken
- [x] Dashboard
  - [x] View CSPR balance
  - [x] Send/Receive CSPR
  - [x] CSPR price chart

## Development

### Install

Install dependencies

```
npm install
```

Config env

- Create `.env` file in root folder

```
MNEMONIC=<Metamask mnemonic>
```

### Run

Compile contracts

```
npx hardhat compile
```

Test contracts

```
npx hardhat test
```

Run network node

```
npx hardhat node
```

Deploy contract to the local running node

```
npx hardhat run scripts/deploy-script.js --network localhost
```

Verify contract on testnet

```
npx hardhat verify --network testnet <contract address>
```

##### Others commands

```shell
npx hardhat accounts
npx hardhat clean
npx hardhat help
```
