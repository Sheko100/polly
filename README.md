## Project Description

This is a *decenteralized application* for **blind voting**, which means that the voters won't know who voted for which option and how many votes for each option untill the poll ends

Currently, the active contract is deployed on **Scroll Sepolia Testnet**, as the dApp is still under developemnt and testing

## Tech Stack

### For the Smart Contract:
- [Foundary](https://www.getfoundry.sh/) toolkit as it has everything needed for smart contract development like Solidity compiler and other useful tools
- Solidity (already included)
- [Make](https://www.gnu.org/software/make/) for smooth scripts running - alternatively you can run the scirpts in the MakeFile manually


### For the dApp (Next.js):
- [Node.js](https://nodejs.org/en/download)
- NextJS (already included)
- Wagmi (already included)
- Viem (already included)
- Reown AppKit (already included)
- Taiilwind 4 (already included)
- TypeScript 5 (already included)


## Getiing started
First of all, install all the missing dependencies listed in the [Tech Stack](#tech-stack) based on whether you are looking to interact with the smart contract logic, the dApp, or both, and ignore what is **already included**

Also create a **Cryptocurrency Wallet** account so you get a **web3 address** which is required whether to deploy a new smart contract or to log into the dApp. For exmaple, you can install the [MetaMask](https://metamask.io/download) browser extension

### Running the dApp (Next.js)

#### Prepare .env file

1. Rename ```.env.example``` in the ```/dapp``` directory to ```.env```

2. Create a new project on Reown Cloud at https://cloud.reown.com and obtain a new project ID

3. Add the project ID as a value for ```NEXT_PUBLIC_PROJECT_ID``` in ```.env``` file

#### For Development:
While in the ```/dapp``` directory run:

1. ```npm run dev```
2. Open ```http://localhost:3000``` on your browser

Now the dApp is running in development mode in ```http://localhost:3000```

#### For Production:
While in the ```/dapp``` directory run:

1. ```npm run build```
2.  ```npm run start```
3. Open ```http://localhost:3000``` on your browser

Now the dApp is running in production mode in ```http://localhost:3000```

### The Smart Contract Development

The smart contract is simple so far and it's in the `/src/VotingSystem.sol` file.

#### Build / Compiling

run `forge build`

Compiling can be useful to check for errors.

#### Deployment

Before you deploy, you will have to prepare your ```.env``` file:

1. Rename ```.env.example``` in the root of the project to  ```.env```

2. Add your private key as a value for ```PRIVATE_KEY```

3. Add your web3 address as a value for ```WEB3_ADDRESS```

4. The `RPC_URL` is already written as for Scroll Seploia, but you can change it if you would like

#### Connect the deployed contract with Next.js app:


Copy the ABI and the contract address to the ```wagmiContractConfig``` object in the ```/dapp/app/common/contracts.ts``` file 


To check the ABI and test the deploying, run:


`make test_deploy`

To deploy on Scroll Sepolia and get the contract address, run:

`make deploy`

### Testing

#### Unit/Integration Testing

All the tests in the `tests` directory.

To run the tests run:

`forge test`

#### Smart Contract Deploying Testing

You can use `anvil` command which is included in the foundry toolkit to deploy the smart contract locally.

1. Run `anvil`

You will get 10 pre-funded accounts with 10 private keys for testing.

insert a screenshot here showing the 10  accouunt in the terminal

Now you have like a blockchain simulation listening on 127.0.0.1:8545. It's similar to when you run **http-server** while developing web2 app.

2. Open another terminal tab and run the following command while passing **account one private key** as a value for `--private-key` option:

`forge script script/Deploy.s.sol --broadcast --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`

Now if there is no errors, you deployed the smart contract
locally and you can check some udeful info like the gas used, the block id and some other useful info.



### Directory Structure
```
├── dapp  # Next.js App
│   ├── app
│   │   ├── common
│   │   │   ├── contractOperations.ts
│   │   │   └── contracts.ts
│   │   ├── components
│   │   │   ├── AccountInfo.tsx
│   │   │   ├── Account.tsx
│   │   │   ├── ConfirmModal.tsx
│   │   │   ├── CreatePoll.tsx
│   │   │   ├── Option.tsx
│   │   │   ├── PollBar.tsx
│   │   │   ├── PollsList.tsx
│   │   │   ├── Poll.tsx
│   │   │   └── VotingSystem.tsx
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── config
│   │   └── index.tsx
│   ├── context
│   │   └── index.tsx
│   ├── next.config.ts
│   ├── next-env.d.ts
│   ├── package.json
│   ├── package-lock.json
│   ├── postcss.config.mjs
│   ├── public
│   │   ├── file.svg
│   │   ├── globe.svg
│   │   ├── next.svg
│   │   ├── vercel.svg
│   │   └── window.svg
│   ├── README.md
│   └── tsconfig.json
├── foundry.toml
├── LICENSE
├── Makefile
├── README.md
├── script
├── src # Smart Contract
│   └── VotingSystem.sol
└── test
    └── VotingSystem.t.sol
```

## Contribution

Feel free to contribute however you like starting from fixing a typo to adding a new feature.

**Please, create a new issue first with the change/bug if the update including code change.**

### How to contribute
1. Fork & clone the repo, then run the dApp
2. Find something that you want to improve, then create a branch for it
3. Apply the changes to the new branch
4. Create a pull tequest

## Important Links

### Public URL

https://voting-dapp-ten-sandy.vercel.app/

### Demo Video

https://vimeo.com/1089503267?share=copy#t=0

### Contract Addresses and Transaction links

Old contract: 0x1419fE1CB72920084939bFE02a25D9Eaf6f5a4a2

Transaction link: https://sepolia.scrollscan.com/tx/0xfa47b89b534a2451503ee15d8abbbbd99cdfd328510ceea271d990e7adf8c597

Old contract: 0x565d9CC5c46a5Cd2ddE6524517c059336da79E42

Transaction link: https://sepolia.scrollscan.com/tx/0xcaebe2aa13aa113d0d179ade844a7e57d823d0433d4837c9eace98a75dd96594

**Latest contract**: 0x66e54F78FbD565b1D0fC2f1FcCF832c8F4529B55

Transaction Link: https://sepolia.scrollscan.com/tx/0x123c29a5f05879b14f33dc4e9b2e75102b3b5f89c21115550d3cbc243c5c1a9f

