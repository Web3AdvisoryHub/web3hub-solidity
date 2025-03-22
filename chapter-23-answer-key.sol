// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FracturedConsensusFix {
    address[] public signers;
    mapping(address => bool) public isSigner;
    mapping(uint => string) public proposals;
    mapping(uint => mapping(address => bool)) public hasVoted;
    mapping(uint => uint) public votes;
    mapping(uint => bool) public finalized;

    uint public currentProposal;

    event ProposalCreated(uint indexed proposalId, string content);
    event Voted(address indexed voter, uint indexed proposalId);
    event ConsensusRecovered(uint indexed proposalId);

    constructor() {
        signers.push(msg.sender);
        isSigner[msg.sender] = true;
    }

    modifier onlySigner() {
        require(isSigner[msg.sender], "Not authorized");
        _;
    }

    function addSigner(address _signer) public onlySigner {
        signers.push(_signer);
        isSigner[_signer] = true;
    }

    function createProposal(string memory content) public onlySigner {
        currentProposal++;
        proposals[currentProposal] = content;
        emit ProposalCreated(currentProposal, content);
    }

    function vote(uint proposalId) public onlySigner {
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        require(!finalized[proposalId], "Already finalized");
        hasVoted[proposalId][msg.sender] = true;
        votes[proposalId]++;
        emit Voted(msg.sender, proposalId);
    }

    function recoverConsensus(uint proposalId) public onlySigner {
        require(votes[proposalId] >= 2, "Not enough votes");
        finalized[proposalId] = true;
        emit ConsensusRecovered(proposalId);
    }
}
