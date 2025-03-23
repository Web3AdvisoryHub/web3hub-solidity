// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NexusGatewayFix {
    address public admin;
    mapping(address => bool) public hasAccess;
    mapping(address => uint) public userChoice;
    uint public pathSelectionCount;

    event PathChosen(address indexed user, uint path);
    event AccessRevoked(address indexed user);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function grantAccess(address user) public onlyAdmin {
        hasAccess[user] = true;
    }

    function revokeAccess(address user) public onlyAdmin {
        hasAccess[user] = false;
        emit AccessRevoked(user);
    }

    function choosePath(uint path) public {
        require(hasAccess[msg.sender], "Access denied");
        require(path >= 1 && path <= 3, "Invalid path");
        require(userChoice[msg.sender] == 0, "You have already chosen a path");
        
        userChoice[msg.sender] = path;
        pathSelectionCount++;
        emit PathChosen(msg.sender, path);
    }

    function getUserChoice(address user) public view returns (uint) {
        return userChoice[user];
    }

    function resetPathChoice() public onlyAdmin {
        for (uint i = 1; i <= pathSelectionCount; i++) {
            userChoice[address(i)] = 0; // Reset all paths
        }
        pathSelectionCount = 0;
    }

    // Ensures the user cannot choose again and verifies their chosen path
    function validatePath(address user) public view returns (bool) {
        return userChoice[user] != 0; // Only valid if a path is chosen
    }
}