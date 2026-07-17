## 🗳️ Blind Voting dApp

A decentralized voting application that ensures voter privacy through **blind voting**.

Users can create polls and vote without revealing their choices or seeing results until the poll ends, ensuring fairness and transparency.

Currently, the active contract is deployed on **Scroll Sepolia Testnet**, as the dApp is still under developemnt and testing

## 🚀 Features

- Create decentralized polls

- Blind voting mechanism (votes remain hidden until poll ends)

- Wallet-based authentication

- Transparent on-chain results after poll completion

- Deployed on Scroll Sepolia Testnet

## 🔗 Live Demo

- 🌐 dApp: https://voting-dapp-ten-sandy.vercel.app/

- 🎥 Demo Video: https://vimeo.com/1089503267?share=copy#t=0

## ⚡ Quick Start

If you just want to run it locally:

```
git clone

cd dapp

npm install

cp .env.example .env

npm run dev
```

Then open: [http://localhost:3000](http://localhost:3000/)

## 🛠️ Getting Started

### Prerequisites

- Node.js

- Foundry

- A wallet (like MetaMask)

### ▶️ Run the dApp

```
cd dapp
```

Rename `.env.example` → `.env`, then add your project ID from:

[https://cloud.reown.com](https://cloud.reown.com/)

```
NEXT_PUBLIC_PROJECT_ID=your_project_id
```

Start the app:

```
npm run dev
```

#### Run in production

While in the `/dapp` directory run:

1. `npm run build`

2. `npm run start

### 🔗 Smart Contract

The main contract lives here:

```
/src/VotingSystem.sol
```

**Compile**

```
forge build
```

Compiling can be useful to check for errors.

**Run tests**

```
forge test
```

**Deployment testing**

[Follow the instructions here](DEPLOYMENT_TESTING.md)

### 🚀 Deploy to Scroll Sepolia

While in the project root:

Rename `.env.example` → `.env` then add your web3 address and private key as values:

```
RPC_URL=https://sepolia-rpc.scroll.io/

PRIVATE_KEY=your_private_key

WEB3_ADDRESS=your_web3_address
```

Then run:

```
make deploy
```

***Please, notice that the new deployed smart contract can be a part of this repo only after checking and approved by the maintainer. You create a new issue to request adding your smart contract deployment address***

### 🔌 Connect contract to frontend

Get the contract ABI:

```
make test_deploy
```

Update:

```
/dapp/app/common/contracts.ts
```

Add:

- Contract address

- ABI

## 📂 Project Structure

```
├── dapp # Frontend (Next.js)

├── src # Smart contracts

├── script # Deployment scripts

├── test # Tests
```

## 🤝 Contributing

Contributions are very welcome 🙌

Whether it’s:

- Fixing a bug

- Improving the UI

- Adding features

- Writing tests

- Improving docs

### How to contribute

1. Fork the repo

2. Create a branch (`feature/your-feature`)

3. Make your changes

4. Open a PR

For bigger changes, feel free to open an issue first so we can discuss it.

## 🗺️ Roadmap (ideas to improve)

- [ ] Improve smart contract structure

- [ ] Handle voting draw

- [ ] Add more tests

- [ ] Enhance UI/UX

- [ ] Add poll categories

- [ ] Optimize gas usage

## 📄 License

MIT

## Tech Stack

### Smart Contracts

- Solidity

- Foundary

### Frontend (dApp)

- Next.js

- TypeScript

- Wagmi + Viem

- Tailwind CSS

## 🔗 Current active contract

 *Contract Address*: 
 **0x66e54F78FbD565b1D0fC2f1FcCF832c8F4529B55***

*Transaction Link*: https://sepolia.scrollscan.com/tx/0x123c29a5f05879b14f33dc4e9b2e75102b3b5f89c21115550d3cbc243c5c1a9f
