# Creating the Solidity Challenge file content for Chapter 15: The Oracle Fork

solidity_chapter_15 = """
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
CHAPTER 15: THE ORACLE FORK
Challenge: Oracle Manipulation Detection

Scenario:
A decentralized oracle provides off-chain data (e.g., temperature, price feed, or event status) to a smart contract. 
However, the oracle data can be manipulated externally, and the contract doesn't verify the source of truth properly.

Goal:
1. Create a simulated oracle that stores a variable.
2. Create a contract that relies on this oracle.
3. Introduce a function to detect if the oracle has been manipulated.
*/

contract Oracle {
    address public admin;
    int256 private data;

    constructor() {
        admin = msg.sender;
    }

    function updateData(int256 _data) external {
        require(msg.sender == admin, "Only admin can update");
        data = _data;
    }

    function getData() external view returns (int256) {
        return data;
    }
}

contract OracleConsumer {
    Oracle public oracle;
    address public owner;

    event OracleAlert(string message, int256 reportedData);

    constructor(address _oracleAddress) {
        oracle = Oracle(_oracleAddress);
        owner = msg.sender;
    }

    function readOracle() public view returns (int256) {
        return oracle.getData();
    }

    function verifyOracle(int256 expectedValue) public {
        int256 oracleValue = oracle.getData();
        if (oracleValue != expectedValue) {
            emit OracleAlert("Oracle mismatch detected", oracleValue);
        }
    }

    // Optional: Allow changing the oracle source (potential vulnerability)
    function updateOracle(address newOracle) public {
        require(msg.sender == owner, "Only owner can update oracle");
        oracle = Oracle(newOracle);
    }
}
"""

# Save the Solidity file
file_path = "/mnt/data/chapter-15-oracle-fork.sol"
with open(file_path, "w") as f:
    f.write(solidity_chapter_15)

file_path
# Re-running the code after environment reset to regenerate the Solidity challenge file

# Recreate the Solidity Challenge file content for Chapter 15: The Oracle Fork
solidity_chapter_15 = """
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
CHAPTER 15: THE ORACLE FORK
Challenge: Oracle Manipulation Detection

Scenario:
A decentralized oracle provides off-chain data (e.g., temperature, price feed, or event status) to a smart contract. 
However, the oracle data can be manipulated externally, and the contract doesn't verify the source of truth properly.

Goal:
1. Create a simulated oracle that stores a variable.
2. Create a contract that relies on this oracle.
3. Introduce a function to detect if the oracle has been manipulated.
*/

contract Oracle {
    address public admin;
    int256 private data;

    constructor() {
        admin = msg.sender;
    }

    function updateData(int256 _data) external {
        require(msg.sender == admin, "Only admin can update");
        data = _data;
    }

    function getData() external view returns (int256) {
        return data;
    }
}

contract OracleConsumer {
    Oracle public oracle;
    address public owner;

    event OracleAlert(string message, int256 reportedData);

    constructor(address _oracleAddress) {
        oracle = Oracle(_oracleAddress);
        owner = msg.sender;
    }

    function readOracle() public view returns (int256) {
        return oracle.getData();
    }

    function verifyOracle(int256 expectedValue) public {
        int256 oracleValue = oracle.getData();
        if (oracleValue != expectedValue) {
            emit OracleAlert("Oracle mismatch detected", oracleValue);
        }
    }

    // Optional: Allow changing the oracle source (potential vulnerability)
    function updateOracle(address newOracle) public {
        require(msg.sender == owner, "Only owner can update oracle");
        oracle = Oracle(newOracle);
    }
}
"""

# Save the Solidity file
file_path = "/mnt/data/chapter-15-oracle-fork.sol"
with open(file_path, "w") as f:
    f.write(solidity_chapter_15)

file_path

