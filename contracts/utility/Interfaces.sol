// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Structures.sol";

interface AdminInter {
    function isAdmin() external;

    function createAdmin(Admin memory admin) external;

    function editAdmin(Admin memory admin) external;

    function getAdminList() external view returns (address[] memory adminList);
}

interface NGOInter {
    function isNGOFunc() external view;

    function getNGOList(uint256 id) external view returns (address ngo);

    function createNGO(
        RegDetails memory,
        string memory,
        string memory,
        string memory,
        string memory,
        SectorDetails memory,
        FCRADetails memory,
        string memory,
        ContactDetails memory,
        string memory
    ) external;

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
    ) external;

    function editstrNGODetail(
        strDetails detail_code,
        string memory val
    ) external;

    function verifyNGO(address id) external;

    function toggleNGOStatus() external;

    function editNGOAddress(uint8 addr_id, Address memory addr) external;

    function editNGOPhoneNumber(
        uint8 ph_id,
        PhoneNumber memory phone_number
    ) external;

    function editNGOFCRA(bool is_available, uint256 reg_no) external;

    function getNGOTotals(
        address id,
        uint val_id
    ) external view returns (uint val);

    function addNGOMember(
        string memory name,
        string memory role,
        string memory pan_card,
        string memory aadhar_card
    ) external;

    function readNGOMember(
        address ngo_id,
        uint256 member_id
    ) external view returns (Member memory member);

    function editNGOMember(uint8 id, uint8 val_id, string memory val) external;

    function addNGOSource(
        string memory dept_name,
        string memory source_type,
        uint256[2] memory financial_year,
        uint256 amount,
        string memory purpose
    ) external;

    function editNGOSource(
        string memory dept_name,
        string memory source_type,
        uint256[2] memory financial_year,
        uint256 amount,
        string memory purpose,
        uint id
    ) external;

    function readNGOSource(
        address ngo_id,
        uint256 src_id
    ) external view returns (FundSource memory src);

    function restoreNGOAttrs(uint256 val_id, uint256 id) external;
}

interface FamilyInter {
    function isFamilyFunc() external view;

    function getFamilyList(uint id) external view returns (address family);

    function createFamily(
        RegDetails memory reg_details,
        ContactDetails memory contact_details
    ) external;

    function editFamilyRegDetails(
        string memory uid,
        string memory reg_no,
        string memory pan_card,
        Address memory addr
    ) external;

    function editFamilyContactDetails(
        Address memory addr,
        PhoneNumber memory phone_number,
        PhoneNumber memory alt_phone_number,
        string memory email
    ) external;

    function getFamilyTotalMembers(address id) external view returns (uint val);

    function addFamilyMember(FamilyMember memory member) external;

    function readFamilyMember(
        address family_id,
        uint member_id
    ) external view returns (FamilyMember memory member);

    function editFamilyMember(uint id, uint val_id, string memory val) external;

    function removeFamilyMember(uint id) external;

    function restoreFamilyMember(uint id) external;
}

interface CharitierInter {
    function addPost() external;
}
