// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CMYToken is ERC20Capped,ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    constructor(uint256 maxcap,uint256 reward) ERC20("CmyashToken","CMY") ERC20Capped(maxcap * (10 ** (decimals())))  {
        owner=payable(msg.sender);
        _mint(owner,7000000 * (10 ** (decimals())));
        blockReward=reward * (10 ** (decimals()));
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward=reward * (10 ** (decimals()));
    }

    function _mintMinerReward() internal{
        _mint(block.coinbase,blockReward);
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20,ERC20Capped) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _beforeTokenTransfer(address from,address to,uint256 value) internal virtual override {
        if(from!=address(0) && to!=address(0) && block.coinbase!=to){
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from,to,value);
    }

    modifier onlyOwner {
        require(msg.sender==owner,"only the contract owner can access this function !");
        _;
    }
}