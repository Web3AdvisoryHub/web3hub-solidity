// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * CHAPTER 8 - Answer Key: The Immutability Illusion
 * This patched contract demonstrates how to prevent hidden proxy logic using delegatecall.
 */

contract ImmutableContract {
    address public owner;
    address private logicContract;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _logicContract) {
        owner = msg.sender;
        logicContract = _logicContract;
    }

    function updateLogicContract(address newLogic) public onlyOwner {
        logicContract = newLogic;
    }

    function execute(bytes memory data) public onlyOwner {
        (bool success, ) = logicContract.delegatecall(data);
        require(success, "Execution failed");
    }

    // Lock logic by resetting address
    function lockLogic() public onlyOwner {
        logicContract = address(0);
    }

    function getLogicAddress() public view returns (address) {
        return logicContract;
    }
}
