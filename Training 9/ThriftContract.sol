// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ThriftContract {
    address public immutable owner;
    uint public totalSavings;

    mapping(address => uint) public savings;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        savings[msg.sender] += msg.value;
        totalSavings += msg.value;
    }

    function withdrawSavings(uint amount) public {
        require(savings[msg.sender] >= amount, "Insufficient savings");
        savings[msg.sender] -= amount;
        totalSavings -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
