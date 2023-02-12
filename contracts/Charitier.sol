// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";

contract NGOContract {
    mapping(address => NGO) public NGOs;
    address[] NGOList;
}

contract FamilyContract {
    mapping(address => Family) public Families;
    address[] FamilyList;
}

contract Charitier is NGOContract, FamilyContract {
    mapping(address => Transaction[]) public Transactions;
}
