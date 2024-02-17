# Staking Smart Contract

The Staking smart contract allows users to stake tokens and earn rewards over a specific duration.

## Features

- Stake Tokens: Users can stake their tokens into the contract.
- Withdraw Tokens: Users can withdraw their staked tokens from the contract.
- Earn Rewards: Users earn rewards for staking tokens.
- Update Reward Parameters: The contract owner can update reward parameters such as duration and reward amount.

## Prerequisites

- Node.js
- Hardhat

## Getting Started

1. Clone the repository:

```
git clone <repository-url>
```

2. Install dependencies:

```
npm install
```

3. Compile the contracts:

```
npx hardhat compile
```

4. Deploy the contract:

```
npx hardhat run scripts/deploy.js --network <network-name>
```

## Usage

1. Deploy the contract using Hardhat or any other Ethereum development environment.
2. Set reward duration using `setRewardDuration` function.
3. Modify reward amount using `modifyRewardAmount` function.
4. Stake tokens using `stake` function.
5. Withdraw tokens using `withdraw` function.
6. Claim rewards using `getReward` function.


## Testing

Tests for this contract can be found in the `test/` directory. To run the tests, execute:

```
npx hardhat test
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

