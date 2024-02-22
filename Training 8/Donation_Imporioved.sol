// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationContract {
    address public immutable owner;
    address payable public immutable beneficiary;
    uint public totalDonations;

    constructor(address payable _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
    }

    receive() external payable {
        totalDonations += msg.value;
    }

    function withdrawDonations() public {
        require(msg.sender == owner, "Only the contract owner can withdraw donations");
        uint balance = address(this).balance;
        beneficiary.transfer(balance);
        totalDonations = 0;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
