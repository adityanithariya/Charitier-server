// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";
import "./utility/Structures.sol";
import "./utility/Functions.sol";
import "./utility/Interfaces.sol";

contract NGOContract is NGOInter {
    address[2] public addrs;
    mapping(address => NGO) public NGOs;
    address[] public NGOList;

    constructor(address admin_contract) {
        addrs[0] = msg.sender;
        addrs[1] = admin_contract;
    }

    function setAdminCtr(address ctr) public {
        addrs[1] = ctr;
    }

    modifier isNGO() {
        require(
            NGOs[msg.sender].reg_details.id == msg.sender,
            "Account doesn't exist"
        );
        _;
    }

    function updateLastModified() internal {
        NGOs[msg.sender].contact_details.last_modified = block.timestamp;
    }

    function createNGO(
        RegDetails memory reg_details,
        string memory reg_cert,
        string memory act_name,
        address registered_with,
        string memory type_of_NGO,
        string memory name_of_NGO,
        SectorDetails memory sector,
        FCRADetails memory FCRA,
        string memory achievements,
        ContactDetails memory contact_details,
        string memory website_url
    ) external {
        NGO storage ngo = NGOs[msg.sender];
        require(ngo.reg_details.id == address(0), "Account already exists");
        NGOList.push(msg.sender);
        ngo.reg_details = RegDetails(
            msg.sender,
            reg_details.uid,
            reg_details.reg_no,
            block.timestamp,
            reg_details.pan_card,
            reg_details.addr,
            false,
            true
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
        ngo.total_members_sources[0] = 0;
        ngo.total_members_sources[1] = 0;
        updateLastModified();
    }

    function editNGO(
        string memory reg_cert,
        string memory act_name,
        string memory type_of_NGO,
        string memory name_of_NGO,
        SectorDetails memory sector,
        FCRADetails memory FCRA,
        string memory achievements,
        ContactDetails memory contact_details,
        string memory website_url
    ) external isNGO {
        NGO storage ngo = NGOs[msg.sender];
        ngo.reg_cert = reg_cert;
        ngo.act_name = act_name;
        ngo.type_of_NGO = type_of_NGO;
        ngo.name = name_of_NGO;
        ngo.sector = sector;
        ngo.FCRA_details = FCRA;
        ngo.achievements = achievements;
        ngo.contact_details = contact_details;
        ngo.website_url = website_url;
        updateLastModified();
    }

    function editstrNGODetail(
        strDetails detail_code,
        string memory val
    ) external isNGO {
        NGO storage ngo = NGOs[msg.sender];
        bool is_changed = true;
        if (detail_code == strDetails.uid) ngo.reg_details.uid = val;
        else if (detail_code == strDetails.reg_no) ngo.reg_details.reg_no = val;
        else if (detail_code == strDetails.pan_card)
            ngo.reg_details.pan_card = val;
        else if (detail_code == strDetails.reg_cert) ngo.reg_cert = val;
        else if (detail_code == strDetails.act_name) ngo.act_name = val;
        else if (detail_code == strDetails.type_of_NGO) ngo.type_of_NGO = val;
        else if (detail_code == strDetails.name) ngo.name = val;
        else if (detail_code == strDetails.key_issues)
            ngo.sector.key_issues = val;
        else if (detail_code == strDetails.achievements) ngo.achievements = val;
        else if (detail_code == strDetails.email)
            ngo.contact_details.email = val;
        else if (detail_code == strDetails.website_url) ngo.website_url = val;
        else is_changed = false;

        if (is_changed) updateLastModified();
    }

    function verifyNGO(address id) external {
        AdminInter(addrs[1]).isAdmin();
        require(NGOs[id].reg_details.id == id, "NGO doesn't exist!");
        require(NGOs[id].reg_details.is_verified != true, "Already Verified!");
        NGOs[id].reg_details.is_verified = true;
        NGOs[id].registered_with = msg.sender;
    }

    function toggleNGOStatus() external isNGO {
        RegDetails storage reg = NGOs[msg.sender].reg_details;
        if (reg.is_active) reg.is_active = false;
        else reg.is_active = true;
    }

    function editNGOAddress(uint8 addr_id, Address memory addr) external isNGO {
        NGO storage ngo = NGOs[msg.sender];
        if (addr_id == 0) {
            ngo.sector.addr = addr;
        } else if (addr_id == 1) {
            ngo.contact_details.addr = addr;
        }
        updateLastModified();
    }

    function editNGOPhoneNumber(
        uint8 ph_id,
        PhoneNumber memory phone_number
    ) external isNGO {
        NGO storage ngo = NGOs[msg.sender];
        if (ph_id == 0) {
            ngo.contact_details.phone_number = phone_number;
        } else if (ph_id == 1) {
            ngo.contact_details.alt_phone_number = phone_number;
        }
        updateLastModified();
    }

    function editNGOFCRA(bool is_available, uint256 reg_no) external isNGO {
        FCRADetails storage fcra = NGOs[msg.sender].FCRA_details;
        fcra.is_available = is_available;
        fcra.reg_no = reg_no;
        updateLastModified();
    }

    function getNGOTotals(
        address id,
        uint val_id
    ) external view returns (uint val) {
        require(NGOs[id].reg_details.id == id, "NGO doesn't exists");
        val = NGOs[id].total_members_sources[val_id];
    }

    function addNGOMember(
        string memory name,
        string memory role,
        string memory pan_card,
        string memory aadhar_card
    ) external isNGO {
        Member memory member = Member(name, role, pan_card, aadhar_card, true);
        NGO storage ngo = NGOs[msg.sender];
        ngo.members[ngo.total_members_sources[0]] = member;
        ngo.total_members_sources[0]++;
        updateLastModified();
    }

    function readNGOMember(
        address ngo_id,
        uint256 member_id
    ) external view returns (Member memory member) {
        member = NGOs[ngo_id].members[member_id];
    }

    function editNGOMember(
        uint8 id,
        uint8 val_id,
        string memory val
    ) external isNGO {
        Member storage member = NGOs[msg.sender].members[id];
        if (val_id == 0) member.name = val;
        else if (val_id == 1) member.role = val;
        else if (val_id == 2) member.pan_card = val;
        else if (val_id == 3) member.aadhar_card = val;
        updateLastModified();
    }

    function removeNGOMember(uint8 id) external isNGO {
        NGOs[msg.sender].members[id].does_exist = false;
        updateLastModified();
    }

    function addNGOSource(
        string memory dept_name,
        string memory source_type,
        uint256[2] memory financial_year,
        uint256 amount,
        string memory purpose
    ) external isNGO {
        FundSource memory fs = FundSource(
            dept_name,
            source_type,
            financial_year,
            amount,
            purpose,
            true
        );
        NGO storage ngo = NGOs[msg.sender];
        ngo.srcs[ngo.total_members_sources[1]] = fs;
        ngo.total_members_sources[1]++;
        updateLastModified();
    }

    function readNGOSource(
        address ngo_id,
        uint256 src_id
    ) external view returns (FundSource memory src) {
        src = NGOs[ngo_id].srcs[src_id];
    }

    function editNGOSource(
        uint256 id,
        uint256 val_id,
        string memory val
    ) external isNGO {
        FundSource storage src = NGOs[msg.sender].srcs[id];
        if (val_id == 0) src.dept_name = val;
        else if (val_id == 1) src.source_type = val;
        else if (val_id == 2) src.purpose = val;
        updateLastModified();
    }

    function editNGOSourceAmt(uint256 id, uint256 amount) external isNGO {
        FundSource storage src = NGOs[msg.sender].srcs[id];
        src.amount = amount;
        updateLastModified();
    }

    function editNGOSourceFY(uint256 id, uint256[2] memory val) external isNGO {
        FundSource storage src = NGOs[msg.sender].srcs[id];
        src.financial_year = val;
        updateLastModified();
    }

    function removeNGOSource(uint8 id) external isNGO {
        NGO storage ngo = NGOs[msg.sender];
        ngo.srcs[id].does_exist = false;
        updateLastModified();
    }

    function restoreNGOAttrs(uint256 val_id, uint256 id) external isNGO {
        require(val_id <= 1, "Index out of range");
        if (val_id == 0) {
            require(
                id < NGOs[msg.sender].total_members_sources[0],
                "Member not found!"
            );
            NGOs[msg.sender].members[id].does_exist = true;
        } else if (val_id == 1) {
            require(
                id < NGOs[msg.sender].total_members_sources[1],
                "Source not found!"
            );
            NGOs[msg.sender].srcs[id].does_exist = true;
        }
        updateLastModified();
    }
}
