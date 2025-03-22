// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Keyless Gate – Chapter 14 Solidity Challenge – Answer Key

contract KeylessGate {
    bytes32 private storedHash;
    address public lastAccessedBy;
    bool public isDestroyed;

    error InvalidReveal(string message);
    error AlreadyDestroyed();

    event HashRevealed(address indexed revealer);
    event ContractDestroyed(address indexed triggeredBy);
    event Warning(string message);

    constructor(string memory secretPhrase) {
        // Store a hash of the secret phrase (e.g., "ArcanumLives")
        storedHash = keccak256(abi.encodePacked(secretPhrase));
    }

    function revealHash(string memory input) public {
        require(!isDestroyed, "Contract is already destroyed");

        if (keccak256(abi.encodePacked(input)) == storedHash) {
            lastAccessedBy = msg.sender;
            emit HashRevealed(msg.sender);
        } else {
            revert InvalidReveal("Reveal failed: Hash mismatch");
        }
    }

    function triggerDestruction(string memory input) public {
        require(!isDestroyed, "Contract is already destroyed");

        if (keccak256(abi.encodePacked(input)) == storedHash) {
            isDestroyed = true;
            emit ContractDestroyed(msg.sender);
            selfdestruct(payable(msg.sender));
        } else {
            revert InvalidReveal("Destruction failed: Incorrect input");
        }
    }

    fallback() external payable {
        emit Warning("Unauthorized fallback access attempt detected");
    }

    receive() external payable {
        emit Warning("Ether sent to KeylessGate; no state changes allowed");
    }
}
