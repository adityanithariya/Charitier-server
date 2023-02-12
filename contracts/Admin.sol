// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";

contract AdminContract {
    mapping(address => Admin) admins;
    address[] adminList;

    modifier isAdmin() {
        require(admins[msg.sender].id == msg.sender);
        _;
    }
}
