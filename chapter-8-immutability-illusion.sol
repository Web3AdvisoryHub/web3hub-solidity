function execute(bytes memory data) public {
    (bool success, ) = logicContract.delegatecall(data);
    require(success, "Execution failed");
}
