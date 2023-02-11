// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "hardhat/console.sol";

struct NGO {
    address id;
    string name;
    
}

struct Family {
    address id;
}

struct Transaction {
    uint256 id;
    string donor;
    address reciever;
    bool is_verified;
}

contract Charitier {
    mapping(address => NGO) public NGOs;
    mapping(address => Family) public Families;
    mapping(address => Transaction) Transactions;
}
