// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TruthForkArchive {
    address public admin;
    mapping(uint => string) private historicalRecord;
    mapping(uint => bool) public isLocked;

    event RecordOverwritten(uint indexed id, string newEntry, address editor);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized");
        _;
    }

    function viewRecord(uint id) public view returns (string memory) {
        require(bytes(historicalRecord[id]).length > 0, "No record exists");
        return historicalRecord[id];
    }

    function overwriteRecord(uint id, string memory newEntry) public onlyAdmin {
        require(!isLocked[id], "Record is immutable");
        historicalRecord[id] = newEntry;
        isLocked[id] = true;
        emit RecordOverwritten(id, newEntry, msg.sender);
    }
}
