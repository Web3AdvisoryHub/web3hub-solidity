// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HeartOfArcanumFix {
    address public admin;
    mapping(uint => string) private soulboundRecords;
    mapping(uint => bool) public isLocked;

    event RecordCreated(uint indexed id, string content, address creator);
    event RecordUpdated(uint indexed id, string newEntry, address editor);
    event SystemStabilized(uint indexed id);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }

    // Function to create a new soulbound record
    function createRecord(uint id, string memory entry) public onlyAdmin {
        require(bytes(soulboundRecords[id]).length == 0, "Record already exists");
        soulboundRecords[id] = entry;
        emit RecordCreated(id, entry, msg.sender);
    }

    // Function to view the current soulbound record
    function viewRecord(uint id) public view returns (string memory) {
        require(bytes(soulboundRecords[id]).length > 0, "No record exists");
        return soulboundRecords[id];
    }

    // Function to stabilize the system and lock records
    function stabilizeSystem(uint id, string memory newEntry) public onlyAdmin {
        require(!isLocked[id], "Record is locked");
        soulboundRecords[id] = newEntry;
        isLocked[id] = true;
        emit RecordUpdated(id, newEntry, msg.sender);
        emit SystemStabilized(id);
    }
}