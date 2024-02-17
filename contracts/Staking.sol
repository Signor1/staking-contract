// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";

//custom errors
error ONLY_OWNER_ALLOWED();
error REWARD_DURATION_NOT_FINISHED();
error ZERO_REWARD_NOT_ALLOWED();
error REWARD_AMOUNT_GREATER_THAN_REWARD_TOKEN();
error ZERO_VALUE_NOT_ALLOWED();

contract Staking {
    address stakingToken;
    address rewardToken;

    address public owner;

    uint256 public duration;
    uint256 public finishedAt;
    uint256 public updatedAt;
    uint256 public rewardRate;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    constructor(address _stakingToken, address _rewardToken) {
        owner = msg.sender;
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
    }

    function onlyOwner() private view {
        if (msg.sender != owner) {
            revert ONLY_OWNER_ALLOWED();
        }
    }

    function updateReward(address _account) private {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();

        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
    }

    function setRewardDuration(uint256 _duration) external {
        onlyOwner();
        if (finishedAt > block.timestamp) {
            revert REWARD_DURATION_NOT_FINISHED();
        }
        duration = _duration;
    }

    function modifyRewardAmount(uint256 _amount) external {
        onlyOwner();

        updateReward(address(0));

        if (block.timestamp > finishedAt) {
            rewardRate = _amount / duration;
        } else {
            uint256 remainingRewards = rewardRate *
                (finishedAt - block.timestamp);
            rewardRate = (remainingRewards + _amount) / duration;
        }

        if (rewardRate <= 0) {
            revert ZERO_REWARD_NOT_ALLOWED();
        }

        if (
            rewardRate * duration > IERC20(rewardToken).balanceOf(address(this))
        ) {
            revert REWARD_AMOUNT_GREATER_THAN_REWARD_TOKEN();
        }

        finishedAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    function stake(uint256 _amount) external {
        updateReward(msg.sender);

        if (_amount <= 0) {
            revert ZERO_VALUE_NOT_ALLOWED();
        }
        IERC20(stakingToken).transferFrom(msg.sender, address(this), _amount);

        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(uint256 _amount) external {
        updateReward(msg.sender);

        if (_amount <= 0) {
            revert ZERO_VALUE_NOT_ALLOWED();
        }
        IERC20(stakingToken).transfer(msg.sender, _amount);

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
    }

    function lastTimeRewardApplicable() public view returns (uint) {
        return _min(block.timestamp, finishedAt);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            (rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18) /
            totalSupply;
    }

    function earned(address _account) public view returns (uint256) {
        return
            (balanceOf[_account] *
                (rewardPerToken() - userRewardPerTokenPaid[_account])) /
            1e18 +
            rewards[_account];
    }

    function getReward() external {
        updateReward(msg.sender);

        uint reward = rewards[msg.sender];

        if (reward > 0) {
            rewards[msg.sender] = 0;
            IERC20(rewardToken).transfer(msg.sender, reward);
        }
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
}
