//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

struct Description {
    string name;
    string identity;
    string website;
    string securityContact;
    string details;
}

struct CommissionRate {
    string rate;
    string maxRate;
    string maxChangeRate;
}

enum Directive{
        CREATE_VALIDATOR, // unused
        EDIT_VALIDATOR,   // unused
        DELEGATE,
        UNDELEGATE,
        COLLECT_REWARDS
    }

abstract contract StakingPrecompilesSelectors {
  function Delegate(address delegatorAddress,
                    address validatorAddress,
                    uint256 amount) public virtual;
  function Undelegate(address delegatorAddress,
                      address validatorAddress,
                      uint256 amount) public virtual;
  function CollectRewards(address delegatorAddress) public virtual;
}

contract StakingPrecompiles {
    function delegate(address validatorAddress, uint256 amount) public returns (uint256 result) {
        bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.Delegate.selector,
                                        address(this),
                                        validatorAddress,
                                        amount);
        bytes32 sizeOfInput;
        assembly {
            let memPtr := mload(0x40)
            sizeOfInput := add(mload(encodedInput), 32)
            result := call(gas(), 0xfc, 0x0, encodedInput, sizeOfInput, memPtr, 0x20)
        }
    }

    function undelegate(address validatorAddress, uint256 amount) public returns (uint256 result) {
      bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.Undelegate.selector,
                                      address(this),
                                      validatorAddress,
                                      amount);
      bytes32 sizeOfInput;
      assembly {
          let memPtr := mload(0x40)
          sizeOfInput := add(mload(encodedInput), 32)
          result := call(gas(), 0xfc, 0x0, encodedInput, sizeOfInput, memPtr, 0x20)
      }
    }

    function collectRewards() public returns (uint256 result) {
      bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.CollectRewards.selector,
                                      address(this));
      bytes32 sizeOfInput;
      assembly {
          let memPtr := mload(0x40)
          sizeOfInput := add(mload(encodedInput), 32)
          result := call(gas(), 0xfc, 0x0, encodedInput, sizeOfInput, memPtr, 0x20)
      }
    }

}
