pragma solidity ^0.6.12;
import "./KODA.sol";
// this file contains methods that should only be triggered by Admin and inherits rest of the method from KODA.sol
contract ProxyKoda is KODA {
  enum Functions {FEE, LIQUIDITY_FEE}
  address admin;
  uint256 private constant _TIMELOCK = 7 days;
  mapping(Functions => uint256) public timelock;
  uint256 private _lockTime;
  modifier notLocked(Functions _fn) {
      require(
          timelock[_fn] != 0 && timelock[_fn] <= block.timestamp,
          "Function is timelocked"
      );
      _;
  }
  constructor() public {
    admin = msg.sender;
  }  
  //unlock timelock
  function unlockFunction(Functions _fn) public onlyOwner {
    timelock[_fn] = block.timestamp + _TIMELOCK;
  }

  //lock timelock
  function lockFunction(Functions _fn) public onlyOwner {
    timelock[_fn] = 0;
  }
  
  function setTaxFeePercent(uint256 taxFee) public onlyOwner notLocked(Functions.FEE) {
    _taxFee = taxFee;
    timelock[Functions.FEE] = 0;
  }

  function setLiquidityFeePercent(uint256 liquidityFee) public onlyOwner notLocked(Functions.LIQUIDITY_FEE) {
    _liquidityFee = liquidityFee;
    timelock[Functions.LIQUIDITY_FEE] = 0;
  }

  function lock(uint256 time) onlyOwner {
    _lockTime = now + time;
    transferOwnership(address(this));
  }

  function unlock() public{
    require(now > _lockTime , "Contract is locked until 7 days");
    transferOwnership(admin);
  }

}
