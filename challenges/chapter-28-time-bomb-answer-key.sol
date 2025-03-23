// Time Bomb Contract Example
pragma solidity ^0.8.0;

contract TimeBomb {
    address public owner;
    bool public bombActivated;
    uint256 public lastActivationTime;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        bombActivated = false;
        lastActivationTime = block.timestamp;
    }

    // Vulnerable function that could be exploited by reentrancy
    function activateBomb() public onlyOwner {
        require(!bombActivated, "Bomb already activated");
        bombActivated = true;
        lastActivationTime = block.timestamp;
    }

    // Reentrancy vulnerable function (can be exploited)
    function deactivateBomb() public onlyOwner {
        require(bombActivated, "Bomb not activated");
        bombActivated = false;
    }

    // A function to check if the bomb is still active
    function checkBombStatus() public view returns (bool) {
        return bombActivated;
    }
}
    bool private lock = false;  // Reentrancy guard

    // Fixed deactivateBomb function to prevent reentrancy
    function deactivateBomb() public onlyOwner {
        require(!lock, "No reentrancy allowed");
        lock = true;

        require(bombActivated, "Bomb not activated");
        bombActivated = false;

        lock = false;  // Reset the lock after the state change
    }
