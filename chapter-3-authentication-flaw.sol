// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 3 Solidity Challenge: Authentication Flaw
 *
 * A contract claims to only allow a specific wallet to execute a sensitive function,
 * but it's written in a way that can be spoofed. Your job: find the flaw and patch it.
 */

contract AccessControl {
    address public owner;
    string public secretMessage;

    constructor(address _owner) {
        owner = _owner;
    }

    function updateSecret(string memory _newMessage, address _sender) public {
        require(_sender == owner, "Only owner can update.");
        secretMessage = _newMessage;
    }
}
