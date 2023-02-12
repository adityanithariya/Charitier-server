// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

struct Address {
    string place;
    string city;
    string state;
    uint32 pincode;
}

struct PhoneNumber {
    uint256 code;
    uint256 phone_number;
}

struct Member {
    string name;
    string role;
    string pan_card;
    string aadhar_card;
    bool does_exist;
}

struct RegDetails {
    address id;
    string uid;
    string reg_no;
    uint256 reg_date;
    string pan_card;
    Address addr;
    bool is_verified;
    bool is_active;
}

struct ContactDetails {
    Address addr;
    PhoneNumber phone_number;
    PhoneNumber alt_phone_number;
    string email;
    uint256 last_modified;
}

struct SectorDetails {
    string key_issues;
    Address addr;
}

struct FCRADetails {
    bool is_available;
    uint256 reg_no;
}

struct FundSource {
    string dept_name;
    string source_type;
    uint256[2] financial_year;
    uint256 amount;
    string purpose;
    bool does_exist;
}

struct NGO {
    RegDetails reg_details;
    string reg_cert;
    string act_name;
    address registered_with;
    string type_of_NGO;
    string name;
    mapping(uint256 => Member) members;
    SectorDetails sector;
    FCRADetails FCRA_details;
    string achievements;
    mapping(uint256 => FundSource) srcs;
    uint256[2] total_members_sources;
    ContactDetails contact_details;
    string website_url;
}

struct Family {
    RegDetails reg;
    ContactDetails contact;
    Member[4] members;
}

struct Transaction {
    uint256 id;
    string donor_uid;
    address reciever;
    string proofs;
    uint256 date;
    bool is_verified;
}

struct Admin {
    address id;
    string uid;
    string name;
    string role;
    bool can_verify;
}

enum strDetails {
    uid,
    reg_no,
    pan_card,
    reg_cert,
    act_name,
    type_of_NGO,
    name,
    key_issues,
    achievements,
    email,
    website_url
}
