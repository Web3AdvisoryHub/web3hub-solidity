// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigMayhem {
    address[] public signers;
    uint256 public quorum;

    struct Proposal {
        address recipient;
        uint256 amount;
        uint256 approvals;
        uint256 createdAt;
        bool executed;
        mapping(address => bool) approvedBy;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    modifier onlySigner() {
        bool isSigner = false;
        for (uint i = 0; i < signers.length; i++) {
            if (msg.sender == signers[i]) {
                isSigner = true;
                break;
            }
        }
        require(isSigner, "Not a signer");
        _;
    }

    event ProposalCreated(uint256 proposalId, address recipient, uint256 amount);
    event ProposalApproved(uint256 proposalId, address signer);
    event ProposalExecuted(uint256 proposalId);

    constructor(address[] memory _signers, uint256 _quorum) {
        require(_signers.length >= _quorum, "Not enough signers");
        signers = _signers;
        quorum = _quorum;
    }

    function createProposal(address _recipient, uint256 _amount) public onlySigner returns (uint256) {
        Proposal storage p = proposals[proposalCount];
        p.recipient = _recipient;
        p.amount = _amount;
        p.createdAt = block.timestamp;
        p.executed = false;

        emit ProposalCreated(proposalCount, _recipient, _amount);
        return proposalCount++;
    }

    function approveProposal(uint256 _proposalId) public onlySigner {
        Proposal storage p = proposals[_proposalId];
        require(!p.executed, "Proposal already executed");
        require(!p.approvedBy[msg.sender], "Already approved");

        p.approvedBy[msg.sender] = true;
        p.approvals++;

        emit ProposalApproved(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) public onlySigner {
        Proposal storage p = proposals[_proposalId];
        require(!p.executed, "Already executed");
        require(p.approvals >= quorum, "Not enough approvals");
        require(block.timestamp <= p.createdAt + 5 minutes, "Proposal expired");

        p.executed = true;
        payable(p.recipient).transfer(p.amount);

        emit ProposalExecuted(_proposalId);
    }

    // Receive function for funding the contract
    receive() external payable {}
}
