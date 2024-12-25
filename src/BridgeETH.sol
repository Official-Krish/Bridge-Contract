// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract BridgeETH is Ownable{
    address public tokenAddress;
    mapping(address => uint256) public pendingBalance;
    event Deposit(address indexed user, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function deposit(IERC20 _tokenAddress, uint256 amount) public {
        require(address(_tokenAddress) == tokenAddress, "Invalid token address");
        require(_tokenAddress.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
        require(_tokenAddress.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit Deposit(msg.sender, amount);
    }

    function withdraw(IERC20 _tokenAddress, uint256 amount) public {
        require(address(_tokenAddress) == tokenAddress, "Invalid token address");
        require(pendingBalance[msg.sender] >= amount, "Insufficient balance");
        require(_tokenAddress.transfer(msg.sender, amount), "Transfer failed");
        pendingBalance[msg.sender] -= amount;
    }

    function burnedOnOtherChain(address user, uint256 amount) public onlyOwner {
        pendingBalance[user] += amount;
    }
}