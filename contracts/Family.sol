// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./Admin.sol";

contract FamilyContract is AdminContract {
    mapping(address => Family) public Families;
    address[] public FamilyList;
}
