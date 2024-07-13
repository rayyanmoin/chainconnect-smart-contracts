// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract AccountCreation{

    struct UserData{
        string username;
        string displayName;
        string imageHash;
        string bio;
    }

    mapping(address => UserData) user;
    mapping(string => bool) existsUser;

    function createAccount(UserData memory userInfo) external{
        require(existsUser[userInfo.username],"username exists");
        existsUser[userInfo.username] = true;
        user[msg.sender] = userInfo;
    }

    function updateAccount(UserData memory userInfo)external{
        require(!existsUser[userInfo.username],"username exists");
        existsUser[userInfo.username] = true;
        existsUser[user[msg.sender].username] = false;

        user[msg.sender] = userInfo;

            

    }

    

}