// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./Admin.sol";

contract NGOContract is AdminContract {
    mapping(address => NGO) public NGOs;
    address[] public NGOList;

    function createNGO(
        RegDetails memory reg_details,
        string memory reg_cert,
        string memory act_name,
        string memory registered_with,
        string memory type_of_NGO,
        string memory name_of_NGO,
        SectorDetails memory sector,
        FCRADetails memory FCRA,
        string memory achievements,
        ContactDetails memory contact_details,
        string memory website_url
    ) public {
        NGOList.push(msg.sender);
        NGO storage ngo = NGOs[msg.sender];
        ngo.reg_details = RegDetails(
            msg.sender,
            reg_details.uid,
            reg_details.reg_no,
            reg_details.reg_date,
            reg_details.pan_card,
            reg_details.addr,
            reg_details.is_verified,
            reg_details.is_active
        );
        ngo.reg_cert = reg_cert;
        ngo.act_name = act_name;
        ngo.registered_with = registered_with;
        ngo.type_of_NGO = type_of_NGO;
        ngo.name = name_of_NGO;
        ngo.sector = sector;
        ngo.FCRA_details = FCRA;
        ngo.achievements = achievements;
        ngo.contact_details = contact_details;
        ngo.website_url = website_url;
    }

    modifier isVerifiedNGO() {
        require(
            NGOs[msg.sender].reg_details.id == msg.sender,
            "Unverified Account"
        );
        _;
    }

    function editNGO(
        RegDetails memory reg_details,
        string memory reg_cert,
        string memory act_name,
        string memory type_of_NGO,
        string memory name_of_NGO,
        SectorDetails memory sector,
        FCRADetails memory FCRA,
        string memory achievements,
        ContactDetails memory contact_details,
        string memory website_url
    ) public isVerifiedNGO {
        NGO storage ngo = NGOs[msg.sender];
        ngo.reg_details = RegDetails(
            msg.sender,
            reg_details.uid,
            reg_details.reg_no,
            reg_details.reg_date,
            reg_details.pan_card,
            reg_details.addr,
            false,
            true
        );
        ngo.reg_cert = reg_cert;
        ngo.act_name = act_name;
        ngo.type_of_NGO = type_of_NGO;
        ngo.name = name_of_NGO;
        ngo.sector = sector;
        ngo.FCRA_details = FCRA;
        ngo.achievements = achievements;
        ngo.contact_details = contact_details;
        ngo.website_url = website_url;
    }

    function isEqual(string memory a, string memory b)
        private
        pure
        returns (bool res)
    {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function estrNGODetail(string memory detail_code, string memory val)
        public
        isVerifiedNGO
    {
        NGO storage ngo = NGOs[msg.sender];
        if (isEqual(detail_code, "uid")) {
            ngo.reg_details.uid = val;
        } else if (isEqual(detail_code, "reg_no")) {
            ngo.reg_details.reg_no = val;
        } else if (isEqual(detail_code, "pan_card")) {
            ngo.reg_details.pan_card = val;
        } else if (isEqual(detail_code, "reg_cert")) {
            ngo.reg_cert = val;
        } else if (isEqual(detail_code, "act_name")) {
            ngo.act_name = val;
        } else if (isEqual(detail_code, "type_of_NGO")) {
            ngo.type_of_NGO = val;
        } else if (isEqual(detail_code, "name")) {
            ngo.name = val;
        } else if (isEqual(detail_code, "key_issues")) {
            ngo.sector.key_issues = val;
        } else if (isEqual(detail_code, "achievements")) {
            ngo.achievements = val;
        } else if (isEqual(detail_code, "email")) {
            ngo.contact_details.email = val;
        } else if (isEqual(detail_code, "website_url")) {
            ngo.website_url = val;
        }
    }

    function lastModifiedNGO(Date memory last_modified) public isVerifiedNGO {
        NGO storage ngo = NGOs[msg.sender];
        ngo.contact_details.last_modified = last_modified;
    }

    function verifyNGO(address id) public isAdmin {
        NGO storage ngo = NGOs[id];
        RegDetails storage reg = ngo.reg_details;
        require(reg.id == id, "NGO doesn't exist!");
        require(reg.is_verified != true, "Already Verified!");
        reg.is_verified = true;
        ngo.registered_with = admins[msg.sender].uid;
    }

    function getStatus() public view isVerifiedNGO returns (bool) {
        return NGOs[msg.sender].reg_details.is_active;
    }

    function deactivateNGO() public isVerifiedNGO {
        RegDetails storage reg = NGOs[msg.sender].reg_details;
        require(reg.is_active == true, "Already deactivated");
        reg.is_active = false;
    }

    function reactivateNGO() public isVerifiedNGO {
        RegDetails storage reg = NGOs[msg.sender].reg_details;
        require(reg.is_active == false, "Already active");
        reg.is_active = true;
    }

    function editNGOAddress(uint8 event_id, Address memory addr)
        public
        isVerifiedNGO
    {
        NGO storage ngo = NGOs[msg.sender];
        if (event_id == 0) {
            ngo.sector.addr = addr;
        } else if (event_id == 1) {
            ngo.contact_details.addr = addr;
        }
    }
}
