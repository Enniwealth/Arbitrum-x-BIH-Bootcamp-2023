// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public currentVersion;
    address public owner;

    constructor(address _currentVersion) {
        currentVersion = _currentVersion;
        owner = msg.sender;
    }

    function upgradeToV1(address newVersion) public {
        require(msg.sender == owner, "Only the owner can upgrade");
        currentVersion = newVersion;
    }

    function upgradeToV2(address newVersion) public {
        require(msg.sender == owner, "Only the owner can upgrade");
        currentVersion = newVersion;
    }

    fallback() external payable {
        address implementation = currentVersion;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), implementation, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}
