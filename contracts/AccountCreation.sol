// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract AccountCreation {
    struct UserData {
        string username;
        string displayName;
        string imageHash;
        string bio;
    }

    mapping(address => UserData) user;
    mapping(string => bool) existsUser;

    function createAccount(UserData memory userInfo) external {
        require(!validateName(userInfo.username), "Invalid");
        require(existsUser[toLower(userInfo.username)], "username exists");
        existsUser[toLower(userInfo.username)] = true;
        user[msg.sender] = userInfo;
    }

    function updateAccount(UserData memory userInfo) external {
        require(!validateName(userInfo.username), "Invalid");
        require(!existsUser[toLower(userInfo.username)], "username exists");
        existsUser[toLower(userInfo.username)] = true;
        existsUser[toLower(user[msg.sender].username)] = false;

        user[msg.sender] = userInfo;
    }
    function validateName(string memory str) public pure returns (bool) {
        bytes memory b = bytes(str);
        if (b.length < 1) return false;
        if (b.length > 25) return false; // Cannot be longer than 25 characters

        for (uint256 i; i < b.length; i++) {
            bytes1 char = b[i];

            if (
                !(char >= 0x30 && char <= 0x39) && //9-0
                !(char >= 0x41 && char <= 0x5A) && //A-Z
                !(char >= 0x61 && char <= 0x7A) //a-z
            ) return false;
        }

        return true;
    }

    /**
     * @dev Converts the string to lowercase
     */
    function toLower(string memory str) public pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint256 i = 0; i < bStr.length; i++) {
            // Uppercase character
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
}
