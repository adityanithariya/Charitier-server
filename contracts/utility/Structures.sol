// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

struct Date {
    uint8 date;
    uint8 month;
    uint16 year;
}

struct Address {
    string place;
    string city;
    string state;
    uint32 pin_code;
}

struct PhoneNumber {
    uint code;
    uint phone_number;
}

struct Member {
    string name;
    string role;
    string pan_card;
    string aadhar_card;
}

struct RegDetails {
    address id;
    string uid;
    string reg_no;
    Date reg_date;
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
    Date last_modified;
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
    string financial_year;
    uint256 amount;
    string purpose;
    string range;
}

struct NGO {
    RegDetails reg_details;
    string reg_cert;
    string act_name;
    string registered_with;
    string type_of_NGO;
    string name;
    Member[10] members;
    SectorDetails sector;
    FCRADetails FCRA_details;
    string achievements;
    mapping(uint => FundSource) srcs;
    uint totalSources;
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
    Date date;
    bool is_verified;
}

struct Admin {
    address id;
    string uid;
    string name;
    string role;
    bool can_verify;
}
