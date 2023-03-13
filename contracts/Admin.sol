// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./utility/Interfaces.sol";

contract AdminContract is AdminInter {
    address public owner;
    address[2] public contracts;
    mapping(address => Admin) public Admins;
    address[] AdminList;

    constructor() {
        owner = msg.sender;
    }

    function setContractAddress(uint256 id, address contractAddress) public {
        require(msg.sender == owner);
        contracts[id] = contractAddress;
    }

    function isAdmin() external view {
        require(Admins[msg.sender].id == msg.sender, "Unauthorized Access");
        require(Admins[msg.sender].can_verify == true, "Cannot Verify");
    }

    modifier isOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    modifier isAdminMod() {
        require(Admins[msg.sender].id == msg.sender, "Unauthorized Access");
        _;
    }

    function createAdmin(Admin memory admin) external isOwner {
        Admins[admin.id] = admin;
        AdminList.push(admin.id);
    }

    function editAdmin(Admin memory admin) external isAdminMod {
        Admins[msg.sender].uid = admin.uid;
        Admins[msg.sender].name = admin.name;
        Admins[msg.sender].role = admin.role;
    }

    function getAdminList()
        external
        view
        returns (address[] memory adminList)
    {
        adminList = AdminList;
    }
}
