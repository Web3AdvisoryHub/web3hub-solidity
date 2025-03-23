// Chapter 30 - Fractured Consensus Challenge
pragma solidity ^0.8.0;

contract FracturedConsensus {
    address public owner;
    uint256 public latestBlock;
    bool public isCorrupted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        latestBlock = 1;
        isCorrupted = false;
    }

    // Function to simulate a corrupted consensus state
    function createNewBlock(uint256 _blockNumber) public onlyOwner {
        require(_blockNumber > latestBlock, "Block number must be greater than the latest block");
        require(!isCorrupted, "Consensus is corrupted, cannot add blocks");

        latestBlock = _blockNumber;
    }

    // Corrupted function where the consensus can split
    function corruptConsensus() public onlyOwner {
        isCorrupted = true;
    }

    // Function to fix the corrupted consensus
    function restoreConsensus() public onlyOwner {
        require(isCorrupted, "No corruption detected");
        isCorrupted = false;
        latestBlock++;
    }

    // View function to check current consensus status
    function checkConsensus() public view returns (uint256, bool) {
        return (latestBlock, isCorrupted);
    }
}
