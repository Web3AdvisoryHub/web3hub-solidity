// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TruthForkFix {
    address public admin;
    mapping(uint => string) private historicalRecord;
    mapping(uint => bool) public isLocked;

    event RecordCreated(uint indexed id, string content, address creator);
    event RecordOverwritten(uint indexed id, string newEntry, address editor);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }

    function createRecord(uint id, string memory entry) public onlyAdmin {
        require(bytes(historicalRecord[id]).length == 0, "Record already exists");
        historicalRecord[id] = entry;
        emit RecordCreated(id, entry, msg.sender);
    }

    function viewRecord(uint id) public view returns (string memory) {
        require(bytes(historicalRecord[id]).length > 0, "No record exists");
        return historicalRecord[id];
    }

    function overwriteRecord(uint id, string memory newEntry) public onlyAdmin {
        require(!isLocked[id], "Record is locked");
        historicalRecord[id] = newEntry;
        isLocked[id] = true;
        emit RecordOverwritten(id, newEntry, msg.sender);
    }
}
