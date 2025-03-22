// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title Keyless Gate – Chapter 14 Solidity Challenge
/// @notice A contract that simulates access recovery through cryptographic reveal

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
        storedHash = keccak256(abi.encodePacked(secretPhrase));
    }

    /// @notice Verifies a phrase against the stored hash
    function revealHash(string memory input) public {
        require(!isDestroyed, "Contract is already destroyed");

        if (keccak256(abi.encodePacked(input)) == storedHash) {
            lastAccessedBy = msg.sender;
            emit HashRevealed(msg.sender);
        } else {
            revert InvalidReveal("Reveal failed: Hash mismatch");
        }
    }

    /// @notice Triggers contract destruction if correct hash is revealed
    function triggerDestruction(string memory input) public {
        require(!isDestroyed, "Contract is already destroyed");

        if (keccak256(abi.encodePacked(input)) == storedHash) {
            emit ContractDestroyed(msg.sender);
            isDestroyed = true;
            selfdestruct(payable(msg.sender));
        } else {
            revert InvalidReveal("Destruction failed: Incorrect input");
        }
    }

    /// @notice Fallback trap – emits a warning if someone interacts incorrectly
    fallback() external payable {
        emit Warning("Unauthorized fallback access attempt detected");
    }

    /// @notice Accept Ether but warn about fallback usage
    receive() external payable {
        emit Warning("Ether sent to KeylessGate; no state changes allowed");
    }
}

