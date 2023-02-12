// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./utility/Interfaces.sol";

contract AdminContract is AdminInter {
    address owner;
    address[2] contracts;
    mapping(address => Admin) admins;
    address[] adminList;

    constructor() {
        owner = msg.sender;
    }

    function setContractAddress(uint256 id, address contractAddress) public {
        require(msg.sender == owner);
        contracts[id] = contractAddress;
    }

    function isAdmin() external view {
        require(admins[msg.sender].id == msg.sender, "Unauthorized Access");
    }
}
