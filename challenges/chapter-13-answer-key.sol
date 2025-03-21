// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Vault {
    mapping(address => uint) public balances;
    mapping(address => bool) public isAdmin;

    // ✅ Custom Errors for gas-efficient error handling
    error NotAdmin();
    error InsufficientBalance(uint requested, uint available);
    error UnauthorizedAccess();

    constructor() {
        isAdmin[msg.sender] = true;
        balances[msg.sender] = 1000 ether; // preload example balance
    }

    // ✅ Withdraw function using custom errors instead of require()
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

    // ✅ Optional function to allow others to receive test deposits
    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}
