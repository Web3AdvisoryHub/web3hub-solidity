// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FracturedConsensusDAO {
    address[] public signers;
    mapping(address => bool) public hasSigned;
    mapping(uint => string) public proposals;
    mapping(uint => uint) public votes;
    uint public currentProposal;

    event ProposalCreated(uint indexed proposalId, string content);
    event Voted(address indexed voter, uint indexed proposalId);
    event ConsensusRecovered(uint indexed proposalId);

    constructor() {
        signers.push(msg.sender);
    }

    modifier onlySigner() {
        require(hasSigned[msg.sender], "Not authorized");
        _;
    }

    function addSigner(address _signer) public {
        require(msg.sender == signers[0], "Only owner can add");
        signers.push(_signer);
        hasSigned[_signer] = true;
    }

    function createProposal(string memory content) public onlySigner {
        currentProposal++;
        proposals[currentProposal] = content;
        emit ProposalCreated(currentProposal, content);
    }

    function vote(uint proposalId) public onlySigner {
        require(proposals[proposalId].bytes.length != 0, "Invalid proposal");
        votes[proposalId]++;
        emit Voted(msg.sender, proposalId);
    }

    function recoverConsensus(uint proposalId) public onlySigner {
        require(votes[proposalId] >= 2, "Not enough approvals");
        emit ConsensusRecovered(proposalId);
    }
}
