// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Arithmetic {
    function isOdd(uint256 number) public pure returns (bool) {
        return number % 2 != 0;
    }

    function isEven(uint256 number) public pure returns (bool) {
        return number % 2 == 0;
    }

    function getMostSignificantBit(uint256 number) public pure returns (uint256) {
        if (number == 0) {
            return 0;
        }
        uint256 msb = 0;
        while (number != 0) {
            number = number >> 1;
            msb++;
        }
        return msb;
    }
}
