// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import './openzeppelin/contracts/token/ERC20/IERC20.sol';

contract KODATIP{
    address KODA_ADDRESS = 0x56d4F6F82175caca12166d7F1E605a6d6bb69b76;
    mapping(address=>string) public wallets;
    mapping(address=>uint256) public balances;
    address admin;
    constructor(){
        admin = msg.sender;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin,'msg.sender is not Admin');
        _;
    }
    function createTipWallet(uint256 _amount,string calldata _username) external{
        IERC20(KODA_ADDRESS).transferFrom(msg.sender,address(this),_amount);
        wallets[msg.sender]=_username;
        balances[msg.sender]=_amount;
    }
  
    function withdrawFunds(uint256 _amount,address _account) onlyAdmin external{
        IERC20(KODA_ADDRESS).transferFrom(address(this),_account,_amount);
        balances[_account]-=_amount;
    }
    function addTipBalance(uint256 _amount,address _account) onlyAdmin external{
        balances[_account]+=_amount;
    }
}