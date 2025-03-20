// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 1 Solidity Answer Key: Enforcing Immutability
 *
 * Solution:
 * - Use `immutable` or `constant` to ensure the value is locked permanently
 */

contract SecureImmutable {
    address public immutable owner;
    string public immutable secretMessage;

    constructor() {
        owner = msg.sender;
        secretMessage = "Blockchain is immutable"; // Hardcoded on deployment
    }

    function getMessage() public view returns (string memory) {
        return secretMessage;
    }
}