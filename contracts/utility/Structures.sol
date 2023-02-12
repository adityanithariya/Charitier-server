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

struct RegistrationDetails {
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
    PhoneNumber[2] phone_number;
    string email;
    Date last_modified;
}

struct SectorDetails {
    string KeyIssues;
    Address addr;
}

struct FCRADetails {
    bool is_available;
    uint256 reg_no;
}

struct FundSource {
    string dept_name;
    string source_type;
    uint16[2] financial_year;
    uint256 amount;
    string purpose;
    uint8[2] range;
}

struct NGO {
    RegistrationDetails reg;
    string reg_cert;
    string act_name;
    string registered_with;
    string type_of_NGO;
    string name;
    Member[10] members;
    SectorDetails sector;
    FCRADetails FCRA;
    string achievements;
    mapping(uint => FundSource) src;
    uint totalSources;
    ContactDetails contact;
    string website_url;
}

struct Family {
    RegistrationDetails reg;
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
