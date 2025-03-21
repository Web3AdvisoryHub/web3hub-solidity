function resetUserHistory(address user) public {
    delete userActivity[user];
}
