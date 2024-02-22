// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract GaslessTokenTransfer {
    IERC20 public token;
    mapping(address => bool) public usedNonces;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function transferTokens(uint256 amount, uint256 nonce, bytes memory signature) public {
        // Vulnerability: No check for signature replay attack
        // Anyone can reuse a valid signature multiple times to replay the transfer
        require(!usedNonces[nonce], "Nonce already used");
        
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, amount, nonce, address(this)));
        address signer = ECDSA.recover(messageHash, signature);
        require(signer == msg.sender, "Invalid signature");

        usedNonces[nonce] = true;
        // Vulnerability: Reentrancy attack
        // Tokens are transferred back to the sender before completing the state changes
        token.transferFrom(msg.sender, address(this), amount);
        token.transfer(msg.sender, amount);
    }

    function withdrawTokens(uint256 amount) public {
        token.transfer(msg.sender, amount);
    }

    function withdrawETH() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
