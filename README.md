# Smartcontract for MetaBio


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

##### Others commands
```shell
npx hardhat accounts
npx hardhat clean
npx hardhat help
```
