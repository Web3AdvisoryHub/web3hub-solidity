// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 4 Solidity Challenge: Hidden Logic
 *
 * A seemingly harmless contract calls another contract under the hood.
 * Hidden logic is buried in the second contract—but most people won’t notice.
 * Your job: identify the exploit, and rewrite it transparently.
 */

interface IShadow {
    function execute(address user) external;
}

contract Gateway {
    address public shadowContract;

    constructor(address _shadow) {
        shadowContract = _shadow;
    }

    function access() public {
        IShadow(shadowContract).execute(msg.sender);
    }
}

// What does the Shadow contract do? Why is it dangerous?
// Could this be used for siphoning funds, access control, or hidden logging?
// Use Remix to simulate both contracts and spot the danger.
