// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * CHAPTER 11: Forked Futures
 * This contract simulates a DAO governance system vulnerable to double-voting due to forked registries.
 * Your task is to fix the double-voting logic and secure DAO consensus.
 */

contract ForkedFuturesDAO {
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

    function castVote(uint256 id, bool support) public proposalExists(id) {
        require(block.timestamp < proposals[id].endTime, "Voting closed");

        bytes32 voteKey = keccak256(abi.encodePacked(msg.sender, id));
        require(!hasVoted[voteKey], "Already voted on this proposal");

        hasVoted[voteKey] = true;

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
        // Logic to execute proposal (omitted)
    }

    function getProposalResult(uint256 id) public view returns (string memory result) {
        Proposal storage p = proposals[id];
        if (p.yesVotes > p.noVotes) {
            return "PASSED";
        } else if (p.yesVotes < p.noVotes) {
            return "FAILED";
        } else {
            return "TIE";
     
