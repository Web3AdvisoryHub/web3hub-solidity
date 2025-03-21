// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * CHAPTER 9 - Answer Key: DAO Identity Trap
 * This version patches the impersonation vulnerability and adds role-based access.
 */

contract DAOIdentityTrap {
    address public admin;

    enum Role { GUEST, MEMBER, ADMIN }

    mapping(address => bool) public verifiedUsers;
    mapping(address => Role) public userRoles;

    modifier onlySelf(address user) {
        require(msg.sender == user, "You can only verify yourself");
        _;
    }

    modifier onlyAdmin() {
        require(userRoles[msg.sender] == Role.ADMIN, "Admin access only");
        _;
    }

    constructor() {
        admin = msg.sender;
        userRoles[msg.sender] = Role.ADMIN;
    }

    function requestVerification() public {
        // Users request to be verified – pending approval
        userRoles[msg.sender] = Role.MEMBER;
    }

    function approveUser(address user) public onlyAdmin {
        require(userRoles[user] == Role.MEMBER, "User must be a member first");
        verifiedUsers[user] = true;
    }

    function verifyUser(address user) public view returns (bool) {
        return verifiedUsers[user];
    }

    function getMyRole() public view returns (Role) {
        return userRoles[msg.sender];
    }
}
