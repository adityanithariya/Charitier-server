// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Structures.sol";

interface AdminInter {
    function isAdmin() external;
}

interface NGOInter {
    function createNGO(
        RegDetails memory,
        string memory,
        string memory,
        address,
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

    function removeNGOMember(uint8 id) external;

    function addNGOSource(
        string memory dept_name,
        string memory source_type,
        uint256[2] memory financial_year,
        uint256 amount,
        string memory purpose
    ) external;

    function readNGOSource(
        address ngo_id,
        uint256 src_id
    ) external view returns (FundSource memory src);

    function editNGOSource(
        uint256 id,
        uint256 val_id,
        string memory val
    ) external;

    function editNGOSourceAmt(uint256 id, uint256 amount) external;

    function editNGOSourceFY(uint256 id, uint256[2] memory val) external;

    function removeNGOSource(uint8 id) external;

    function restoreNGOAttrs(uint256 val_id, uint256 id) external;
}
