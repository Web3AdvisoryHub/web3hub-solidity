// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Prophecy Override Contract
/// @notice A hidden smart contract that reveals a blockchain prophecy and allows for override under strict conditions.

contract ProphecyOverride {
    address public sourceOracle;
    string private originalProphecy;
    string private rewrittenProphecy;

    uint256 public immutable unlockTimestamp;
    bool public isRewritten = false;

    constructor(string memory _originalProphecy, uint256 _delayInSeconds) {
        sourceOracle = msg.sender;
        originalProphecy = _originalProphecy;
        unlockTimestamp = block.timestamp + _delayInSeconds;
    }

    modifier onlySource() {
        require(msg.sender == sourceOracle, "Only the source oracle can rewrite the prophecy.");
        _;
    }

    modifier onlyAfterUnlock() {
        require(block.timestamp >= unlockTimestamp, "The prophecy cannot be altered yet.");
        _;
    }

    function revealProphecy() public view returns (string memory) {
        if (isRewritten) {
            return rewrittenProphecy;
        } else {
            return originalProphecy;
        }
    }

    function overrideProphecy(string memory _newProphecy) public onlySource onlyAfterUnlock {
        rewrittenProphecy = _newProphecy;
        isRewritten = true;
    }

    function updateSourceOracle(address _newSource) public onlySource {
        sourceOracle = _newSource;
    }
}