// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Chapter 11: Forked Futures - Answer Key
 * Solution to the DAO double-voting bug caused by forked registries.
 */

contract ForkedFuturesDAO_Patched {
    address public admin;
    uint256 public proposalId;

    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(bytes32 => bool) public hasVoted;
    mapping(address => uint256) public lastVotedAt;

    uint256 public voteCooldown = 1 minutes;

    event ProposalCreated(uint256 id, string description);
    event VoteCast(address voter, uint256 proposalId, bool support);
    event DuplicateVoteAttempt(address voter, uint256 proposalId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier proposalExists(uint256 id) {
        require(proposals[id].id == id, "Proposal does not exist");
        _;
    }

    modifier cooldownPassed() {
        require(block.timestamp >= lastVotedAt[msg.sender] + voteCooldown, "Vote cooldown active");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createProposal(string memory desc) public onlyAdmin {
        proposalId++;
        proposals[proposalId] = Proposal({
            id: proposalId,
            description: desc,
            yesVotes: 0,
            noVotes: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + 1 days,
            executed: false
        });
        emit ProposalCreated(proposalId, desc);
    }

    function castVote(uint256 id, bool support) public proposalExists(id) cooldownPassed {
        require(block.timestamp < proposals[id].endTime, "Voting closed");

        bytes32 voteKey = keccak256(abi.encodePacked(msg.sender, id));
        require(!hasVoted[voteKey], "Already voted on this proposal");

        hasVoted[voteKey] = true;
        lastVotedAt[msg.sender] = block.timestamp;

        if (support) {
            proposals[id].yesVotes++;
        } else {
            proposals[id].noVotes++;
        }

        emit VoteCast(msg.sender, id, support);
    }

    function simulateDuplicateVoteAttempt(uint256 id) public {
        bytes32 voteKey = keccak256(abi.encodePacked(msg.sender, id));
        if (hasVoted[voteKey]) {
            emit DuplicateVoteAttempt(msg.sender, id);
        }
    }

    function executeProposal(uint256 id) public proposalExists(id) {
        Proposal storage p = proposals[id];
        require(block.timestamp > p.endTime, "Voting not finished");
        require(!p.executed, "Already executed");

        p.executed = true;
        // Execute proposal logic...
    }

    function getProposalResult(uint256 id) public view returns (string memory result) {
        Proposal storage p = proposals[id];
        if (p.yesVotes > p.noVotes) {
            return "PASSED";
        } else if (p.yesVotes < p.noVotes) {
            return "FAILED";
        } else {
            return "TIE";
        }
    }
}
