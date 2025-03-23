// Chapter 29 - Answer Key - Fixed Time-based Exploit
pragma solidity ^0.8.0;

contract UnknownForce {
    address public owner;
    bool public systemCorrupted;
    uint256 public activationTime;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        systemCorrupted = false;
        activationTime = block.timestamp + 1 hours; // Corruption set to activate in 1 hour
    }

    // Time-based corruption function (Vulnerable to exploit)
    function activateSystem() public onlyOwner {
        require(block.timestamp >= activationTime, "System corruption not yet activated");
        systemCorrupted = true;
    }

    // Fix function - Restore the system (Should be called before activation time)
    function restoreSystem() public onlyOwner {
        require(block.timestamp < activationTime, "Time expired to restore system");
        systemCorrupted = false;
    }

    // Add the reentrancy guard and better time checks here
    bool private lock = false;  // Reentrancy guard

    // Fixed activateSystem function
    function activateSystemFixed() public onlyOwner {
        require(!lock, "No reentrancy allowed");
        lock = true;
        
        require(block.timestamp >= activationTime, "System corruption not yet activated");
        systemCorrupted = true;

        lock = false;  // Reset the lock after the state change
    }

    // View function to check system status
    function checkSystemStatus() public view returns (bool) {
        return systemCorrupted;
    }
}
