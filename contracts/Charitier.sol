// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./utility/Interfaces.sol";

contract Charitier {
    address owner;
    address[3] contracts; // Admin, NGO, Family
    mapping(address => Post) public Posts;

    constructor() {
        owner = msg.sender;
    }

    function setCtrAddress(uint8 id, address contract_address) external {
        require(msg.sender == owner, "Unauthorised Access");
        contracts[id] = contract_address;
    }

    function addPost(string memory uid, AccountType account_type) external {
        if (account_type == AccountType.admin) {
            AdminInter(contracts[0]).isAdmin();
        }
        else if (account_type == AccountType.ngo) {
            NGOInter(contracts[1]).isNGOFunc();
        }
        else if(account_type == AccountType.family) {
            FamilyInter(contracts[2]).isFamilyFunc();
        }
        Posts[msg.sender].account = msg.sender;
        Posts[msg.sender].uid = uid;
        Posts[msg.sender].account_type = account_type;
        Posts[msg.sender].total_transactions = 0;
    }
}
