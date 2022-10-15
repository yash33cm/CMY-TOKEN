// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

interface IERC20{
     function transfer(address to,uint256 amount) external returns (bool);
     function balanceOf(address account) external view returns (uint256);
     event Transfer(address indexed from,address indexed to,uint256 value);
}

contract CMYFaucet{

    address payable owner;
    uint256 public withdrawAmount=10*(10**18);
    event Deposit(address indexed from,uint256 amount);
    event Withdraw(address indexed to,uint256 amount);
    IERC20 public token;

    uint256 public lockTime=1 minutes;

    mapping (address => uint256) nextLockTime;

    constructor(address tokenAddress) payable{
        token=IERC20(tokenAddress);
        owner=payable(msg.sender);
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value);
    } 

    function requestToken() public {
        require(msg.sender!=address(0),"null address cannot request for token");
        require(withdrawAmount <=token.balanceOf(address(this)),"Insufficient Token!");
        require(block.timestamp >=nextLockTime[msg.sender],"You are time has not been elapsed for requesting token");

        nextLockTime[msg.sender]=block.timestamp+lockTime;
        token.transfer(msg.sender,withdrawAmount);
    }

    function setWithdrawAmount(uint256 amount) public onlyOwner {
        withdrawAmount=amount * (10**18);

    }

    function setLockTime(uint256 time) public onlyOwner {
        withdrawAmount=time * 1 minutes;
    }

    function getBalance() external view returns(uint256){
        return token.balanceOf(address(this));
    }

    function withdraw() external onlyOwner{
        emit Withdraw(msg.sender,token.balanceOf(address(this)));
        token.transfer(msg.sender,token.balanceOf(address(this)));
    }

    modifier onlyOwner{
        require(msg.sender==owner,"only owner has the access to the function");
        _;
    }

}