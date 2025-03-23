// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuantumGateway {
    address public admin;
    mapping(uint => string) private quantumRecords;
    mapping(uint => bool) public isLocked;

    event QuantumRecordUpdated(uint indexed id, string newEntry, address editor);
    event QuantumStabilized(uint indexed id);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }

    function viewRecord(uint id) public view returns (string memory) {
        require(bytes(quantumRecords[id]).length > 0, "No record exists");
        return quantumRecords[id];
    }

    function stabilizeQuantumGateway(uint id, string memory newEntry) public onlyAdmin {
        require(!isLocked[id], "Record is locked");
        quantumRecords[id] = newEntry;
        isLocked[id] = true;
        emit QuantumRecordUpdated(id, newEntry, msg.sender);
        emit QuantumStabilized(id);
    }
}