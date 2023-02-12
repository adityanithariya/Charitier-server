// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

function isEqual(string memory a, string memory b)
    pure
    returns (bool res)
{
    return keccak256(bytes(a)) == keccak256(bytes(b));
}
