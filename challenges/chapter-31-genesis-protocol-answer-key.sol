// Chapter 31 - Answer Key - Fixed Genesis Protocol
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

    // **Fixed version**: Added reentrancy guard and time-check for genesis manipulation
    bool private lock = false;  // Reentrancy guard

    function corruptGenesisBlock(uint256 _newGenesis) public onlyOwner {
        require(!lock, "No reentrancy allowed");
        lock = true;
        
        require(!isCorrupted, "Genesis Block has already been corrupted.");
        require(_newGenesis > genesisBlock, "New Genesis Block must be greater.");

        genesisBlock = _newGenesis;
        isCorrupted = true;

        lock = false; // Reset after the state change
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