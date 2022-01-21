// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import './openzeppelin/contracts/token/ERC20/IERC20.sol';

contract KAPEXTransfer{
  address KODA_V1_ADDRESS = address(0x0);
  address KODA_V2_ADDRESS = address(0x0);
  address BURN_ADDRESS = address(0x0);
  mapping(address => bool) public redeemed;
  mapping(address => uint256) public limit;
  
  address admin;
  modifier hasNotRedeemed(){
      require(redeemed[msg.sender]!=true,"You have already redeemed your tokens");
      _;
  }
  modifier onlyAdmin(){
      require(msg.sender==admin,"msg.sender it not admin");
      _;
  }
  modifier ifContractsIntialised(){
      require(KODA_V1_ADDRESS!=address(0x0),"KODA v1 address not set");
      require(KODA_V2_ADDRESS!=address(0x0),"KODA v2 address not set");
      _;
  }
  modifier isBurnAddressInitialised(){
      require(BURN_ADDRESS!=address(0x0),"Burn address not set");
      _;
  }
  constructor() {
      admin = msg.sender;
  }
  function convertKODAtoKAPEX(uint256 _amount) ifContractsIntialised isBurnAddressInitialised external{
      IERC20(KODA_V1_ADDRESS).transferFrom(msg.sender,BURN_ADDRESS,_amount);
      IERC20(KODA_V2_ADDRESS).transfer(msg.sender,_amount*10**9);
  }
  function collectBonusKoda(uint256 _amount) hasNotRedeemed external{
      //require(_amount<limit[msg.sender])  uncomment this to enable check for amount OR just replace amount with limit[msg.sender] in the line below
      IERC20(KODA_V1_ADDRESS).transfer(msg.sender,_amount);
      redeemed[msg.sender] = true;
  }
  function setLimit(address _user,uint256 _limit) onlyAdmin external {
      limit[_user] = _limit;
      redeemed[_user] = false;
  }
  function setKODAv1Address(address _contract) onlyAdmin external {
      KODA_V1_ADDRESS = _contract;
  }
  function setKODAv2Address(address _contract) onlyAdmin external {
      KODA_V2_ADDRESS = _contract;
  }
  function setBurnAddress(address _burnAddress) onlyAdmin external {
      BURN_ADDRESS = _burnAddress;
  }
  function transferOwnership(address _newAdmin) onlyAdmin external {
      admin = _newAdmin;
  }
  function withdrawKODAv1(uint256 _amount) onlyAdmin external {
      IERC20(KODA_V1_ADDRESS).transfer(msg.sender,_amount);
  }
  function withdrawKODAv2(uint256 _amount) onlyAdmin external {
      IERC20(KODA_V2_ADDRESS).transfer(msg.sender,_amount);
  }
}