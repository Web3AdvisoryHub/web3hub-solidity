// Chapter 31 - Genesis Protocol Challenge
pragma solidity ^0.8.0;

contract GenesisProtocol {
    address public owner;
    uint256 public genesisBlock;
    bool public isCorrupted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        genesisBlock = 1; // The first block, Genesis Block
        isCorrupted = false;
    }

    // Function to manipulate the Genesis Block (Vulnerable to attack)
    function corruptGenesisBlock(uint256 _newGenesis) public onlyOwner {
        require(!isCorrupted, "Genesis Block has already been corrupted.");
        genesisBlock = _newGenesis;
        isCorrupted = true;
    }

    // Function to restore the Genesis Block
    function restoreGenesisBlock() public onlyOwner {
        require(isCorrupted, "Genesis Block is not corrupted.");
        genesisBlock = 1; // Restoring Genesis Block to its original state
        isCorrupted = false;
    }

    // View function to check Genesis Block status
    function checkGenesisStatus() public view returns (uint256, bool) {
        return (genesisBlock, isCorrupted);
    }
}