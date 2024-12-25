// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract KToken is ERC20, Ownable {
    constructor() ERC20("KToken", "KT") Ownable(msg.sender) {

    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}