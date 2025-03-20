// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 1 Solidity Challenge: Immutability in Smart Contracts
 * 
 * Your task:
 * - Create a contract called `ImmutableExample`
 * - Declare an immutable variable `creator` to store the contract deployer's address
 * - Set `creator` in the constructor
 * - Write a function `getCreator` that returns the deployer's address
 */

contract ImmutableExample {
    // Declare immutable variable
    address public immutable creator;

    // Constructor sets the deployer's address
    constructor() {
        creator = msg.sender;
    }

    // Function to return the deployer's address
    function getCreator() public view returns (address) {
        return creator;
    }
}