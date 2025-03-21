function verifyUser(address user) public view returns (bool) {
    return verifiedUsers[user];
}
