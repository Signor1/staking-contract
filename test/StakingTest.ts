import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Staking Contract Testing", function () {
  async function deploySaveContract() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const initialOwner = "0xdF0a689A22B64C455AE212DBc13AF35f1B1dFD55";

    const signorToken = await ethers.getContractFactory("SignorToken");

    const stakingToken = await signorToken.deploy(initialOwner);

    const emmyToken = await ethers.getContractFactory("EmmyToken");

    const rewardToken = await emmyToken.deploy(initialOwner);

    const MyStaking = await ethers.getContractFactory("Staking");

    const myStaking = await MyStaking.deploy(
      stakingToken.target,
      rewardToken.target
    );

    return { myStaking, stakingToken, rewardToken, owner, otherAccount };
  }
});
