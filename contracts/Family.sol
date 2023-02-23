// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./utility/Interfaces.sol";

contract FamilyContract is FamilyInter {
    address[2] public addrs;
    mapping(address => Family) public Families;
    address[] public FamilyList;

    function updateLastModified() internal {
        Families[msg.sender].contact_details.last_modified = block.timestamp;
    }

    modifier isFamily() {
        require(
            Families[msg.sender].reg_details.id == msg.sender,
            "Account doesn't exists"
        );
        _;
    }

    constructor(address admin_contract) {
        addrs[0] = msg.sender;
        addrs[1] = admin_contract;
    }

    function setAdminCtr(address admin_contract) public {
        require(msg.sender == addrs[0]);
        addrs[1] = admin_contract;
    }

    function getFamilyList(uint id) external view returns (address family) {
        family = FamilyList[id];
    }

    function createFamily(
        RegDetails memory reg_details,
        ContactDetails memory contact_details
    ) external {
        Family storage family = Families[msg.sender];
        require(family.reg_details.id == address(0), "Account already exists");
        family.reg_details.id = msg.sender;
        family.reg_details.uid = reg_details.uid;
        family.reg_details.reg_no = reg_details.reg_no;
        family.reg_details.reg_date = block.timestamp;
        family.reg_details.pan_card = reg_details.pan_card;
        family.reg_details.addr = reg_details.addr;
        family.reg_details.is_verified = false;
        family.reg_details.is_active = true;
        family.contact_details.addr = contact_details.addr;
        family.contact_details.phone_number = contact_details.phone_number;
        family.contact_details.alt_phone_number = contact_details
            .alt_phone_number;
        family.contact_details.email = contact_details.email;
        FamilyList.push(msg.sender);
        updateLastModified();
    }

    function editFamilyRegDetails(
        string memory uid,
        string memory reg_no,
        string memory pan_card,
        Address memory addr
    ) external isFamily {
        Family storage family = Families[msg.sender];
        family.reg_details.uid = uid;
        family.reg_details.reg_no = reg_no;
        family.reg_details.pan_card = pan_card;
        family.reg_details.addr = addr;
        updateLastModified();
    }

    function editFamilyContactDetails(
        Address memory addr,
        PhoneNumber memory phone_number,
        PhoneNumber memory alt_phone_number,
        string memory email
    ) external isFamily {
        updateLastModified();
        Family storage family = Families[msg.sender];
        family.contact_details.addr = addr;
        family.contact_details.phone_number = phone_number;
        family.contact_details.alt_phone_number = alt_phone_number;
        family.contact_details.email = email;
    }

    function getFamilyTotalMembers(
        address id
    ) external view returns (uint val) {
        val = Families[id].total_members;
    }

    function addFamilyMember(FamilyMember memory member) external isFamily {
        Family storage family = Families[msg.sender];
        family.members[family.total_members].image = member.image;
        family.members[family.total_members].name = member.name;
        family.members[family.total_members].role = member.role;
        family.members[family.total_members].pan_card = member.pan_card;
        family.members[family.total_members].aadhar_card = member.aadhar_card;
        family.members[family.total_members].does_exist = true;
        family.total_members++;
        updateLastModified();
    }

    function readFamilyMember(
        address family_id,
        uint member_id
    ) external view returns (FamilyMember memory member) {
        member = Families[family_id].members[member_id];
    }

    function editFamilyMember(
        uint id,
        uint val_id,
        string memory val
    ) external isFamily {
        require(
            id < Families[msg.sender].total_members,
            "Member doesn't exists"
        );
        require(val_id < 5, "Index out of range");
        FamilyMember storage member = Families[msg.sender].members[id];
        if (val_id == 0) member.name = val;
        else if (val_id == 1) member.image = val;
        else if (val_id == 2) member.role = val;
        else if (val_id == 3) member.pan_card = val;
        else if (val_id == 4) member.aadhar_card = val;
        updateLastModified();
    }

    function removeFamilyMember(uint id) external isFamily {
        FamilyMember storage member = Families[msg.sender].members[id];
        member.does_exist = false;
        updateLastModified();
    }

    function restoreFamilyMember(uint id) external isFamily {
        FamilyMember storage member = Families[msg.sender].members[id];
        member.does_exist = true;
        updateLastModified();
    }
}
