// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./NGO.sol";
import "./Family.sol";

contract Charitier is NGOContract, FamilyContract {
    mapping(address => Transaction[]) public Transactions;
}
