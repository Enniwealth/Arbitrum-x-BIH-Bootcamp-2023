
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationContract {
    address public beneficiary;
    uint public totalDonations;

    event DonationReceived(address indexed from, uint value);

    constructor(address _beneficiary) {
        beneficiary = _beneficiary;
    }

    receive() external payable {
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

