// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Chapter 6 Solidity Challenge: Dead Contract Revival
 *
 * A contract was believed to be destroyed using `selfdestruct()`,
 * but it was later discovered to be active again via a proxy contract.
 *
 * Your mission:
 * 1. Identify why the original selfdestruct did not prevent contract revival
 * 2. Track how a proxy might still point to the original logic
 * 3. Patch the logic to ensure contracts cannot be revived via proxy cloning
 */

contract LegacyLogic {
    address public owner;
    bool public active;

    constructor() {
        owner = msg.sender;
        active = true;
    }

    function execute() public view returns (string memory) {
        require(active, "Contract is deactivated.");
        return "Executing legacy contract logic.";
    }

    function deactivate() public {
        require(msg.sender == owner, "Only owner can deactivate.");
        active = false;
    }

    function selfDestruct() public {
        require(msg.sender == owner, "Only owner can destroy.");
        selfdestruct(payable(owner));
    }
}

contract Proxy {
    address public logic;

    constructor(address _logic) {
        logic = _logic;
    }

    fallback() external payable {
        address _impl = logic;
        require(_impl != address(0), "Invalid logic address");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}