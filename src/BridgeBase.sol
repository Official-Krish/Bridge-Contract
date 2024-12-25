// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

interface IWKToken {
    function mint (address to, uint256 amount) external;
    function burn(address to, uint256 amount) external;
}

contract BridgeBase is Ownable{
    address public tokenAddress;
    mapping(address => uint256) public pendingBalance;
    event Burn(address indexed user, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function burn(IWKToken _tokenAddress, uint256 amount) public payable {
        require(address(_tokenAddress) == tokenAddress, "Invalid token address");
        _tokenAddress.burn(msg.sender, amount);
        emit Burn(msg.sender, amount);
    }

    function withdraw(IWKToken _tokenAddress, uint256 amount) public {
        require(pendingBalance[msg.sender] >= amount, "Insufficient balance");
        _tokenAddress.mint(msg.sender, amount);
        pendingBalance[msg.sender] -= amount;
    }

    function depositOnOtherChain(address user, uint256 amount) public onlyOwner {
        pendingBalance[user] += amount;
    }
}