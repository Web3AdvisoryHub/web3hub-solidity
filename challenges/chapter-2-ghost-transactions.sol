// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 2 Solidity Challenge: Ghost Transactions
 *
 * A suspicious contract is moving funds in a way that avoids detection.
 * Your job: Uncover how it's doing it.
 */

contract GhostProxy {
    address public target;
    event Received(address, uint256);
    event Forwarded(address, uint256);

    constructor(address _target) {
        target = _target;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
        (bool success, ) = target.call{value: msg.value}("");
        require(success, "Forwarding failed");
        emit Forwarded(target, msg.value);
    }
}
