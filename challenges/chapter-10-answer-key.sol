// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * CHAPTER 10 - Answer Key: The Memory Reset Mirage
 * This contract fixes the data erasure vulnerability by introducing authorization,
 * audit logging, and a cooldown delay before deletion can be executed.
 */

contract MemoryResetMirage {
    address public owner;

    mapping(address => string[]) public userActivity;

    enum Role { NONE, MODERATOR, OWNER }
    mapping(address => Role) public roles;

    struct ResetRequest {
        address user;
        uint256 timestamp;
        bool approved;
    }

    mapping(address => ResetRequest) public resetRequests;

    event ResetRequested(address indexed user, uint256 timestamp);
    event ResetApproved(address indexed moderator, address indexed user);
    event UserDataReset(address indexed user, uint256 timestamp);

    modifier onlyAuthorized() {
        require(
            roles[msg.sender] == Role.OWNER || roles[msg.sender] == Role.MODERATOR,
            "Not authorized"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
        roles[msg.sender] = Role.OWNER;
    }

    function assignModerator(address moderator) public {
        require(msg.sender == owner, "Only owner can assign roles");
        roles[moderator] = Role.MODERATOR;
    }

    function logActivity(string memory activity) public {
        userActivity[msg.sender].push(activity);
    }

    function requestReset(address user) public onlyAuthorized {
        resetRequests[user] = ResetRequest(user, block.timestamp, false);
        emit ResetRequested(user, block.timestamp);
    }

    function approveReset(address user) public onlyAuthorized {
        require(resetRequests[user].timestamp != 0, "No request found");
        resetRequests[user].approved = true;
        emit ResetApproved(msg.sender, user);
    }

    function finalizeReset(address user) public {
        ResetRequest memory req = resetRequests[user];
        require(req.approved, "Reset not approved");
        require(block.timestamp >= req.timestamp + 1 hours, "Cooldown not met");

        delete userActivity[user];
        delete resetRequests[user];

        emit UserDataReset(user, block.timestamp);
    }

    function getUserActivity(address user) public view returns (string[] memory) {
        return userActivity[user];
    }
}
