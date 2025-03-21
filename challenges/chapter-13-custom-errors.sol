// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Vault {
    mapping(address => uint) public balances;
    mapping(address => bool) public isAdmin;

    // 🔴 Step 1: Declare custom errors
    error NotAdmin();
    error InsufficientBalance(uint requested, uint available);
    error UnauthorizedAccess();

    constructor() {
        isAdmin[msg.sender] = true;
        balances[msg.sender] = 1000 ether; // preload for demo
    }

    // 🔧 Step 2: Use custom errors in withdraw function
    function withdraw(uint amount) external {
        if (!isAdmin[msg.sender]) {
            revert NotAdmin();
        }

        if (balances[msg.sender] < amount) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {}
}
