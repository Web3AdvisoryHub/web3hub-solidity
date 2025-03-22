// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
CHAPTER 16: The Gaslight Protocol
This contract is disguised as gas-optimized, but a hidden exploit weaponizes unchecked iterations.
Your mission is to identify how gas “efficiency” can be turned against the network.

SCENARIO:
A seemingly optimized storage-saving protocol logs votes in a dynamic array,
but the gas refund and unbounded iteration cause a denial-of-service risk.

Can you spot the trap?
*/

contract GaslightProtocol {
    struct Vote {
        address voter;
        uint8 choice;
    }

    Vote[] private votes;

    mapping(address => bool) public hasVoted;

    function submitVote(uint8 _choice) external {
        require(!hasVoted[msg.sender], "Already voted");
        votes.push(Vote(msg.sender, _choice));
        hasVoted[msg.sender] = true;
    }

    function clearVotes() external {
        // Intentionally unbounded loop that grows linearly with number of voters
        for (uint256 i = 0; i < votes.length; i++) {
            delete hasVoted[votes[i].voter];
        }

        delete votes;
    }

    function totalVotes() external view returns (uint256) {
        return votes.length;
    }
}

/*
CHALLENGE OBJECTIVES:

1. Identify the gas-based vulnerability within `clearVotes()`.
2. Propose a safer pattern for removing large arrays in Solidity (hint: pagination or batching).
3. Explain why using unbounded `for` loops in public functions is dangerous, especially when called by any user.
4. Bonus: Propose a role-based restriction that prevents misuse.

*/

// Happy hacking.