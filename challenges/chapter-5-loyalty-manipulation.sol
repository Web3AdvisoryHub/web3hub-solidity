// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 5 Solidity Challenge: Loyalty Score Manipulation
 *
 * This contract tracks user behavior and updates loyalty scores based on actions.
 * But there's a hidden flaw that allows malicious actors to reverse scores or drain rewards.
 * Your mission: uncover it, simulate it, and patch it.
 */

contract LoyaltyNetwork {
    mapping(address => uint256) public loyaltyScore;
    mapping(address => bool) public flagged;

    event ScoreUpdated(address user, uint256 score);

    function submitAction(address user, uint256 points, bool reward) public {
        require(!flagged[user], "User is flagged.");

        if (reward) {
            loyaltyScore[user] += points;
        } else {
            loyaltyScore[user] -= points;
        }

        emit ScoreUpdated(user, loyaltyScore[user]);
    }

    function flagUser(address user) public {
        flagged[user] = true;
    }
}
