// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CrossDomainMessenger} from "lib/nova-interfaces/src/CrossDomainMessenger.sol";
import {Trust} from "lib/solmate/src/auth/Trust.sol";

contract Strategy is Trust {

    CrossDomainMessenger L1_CDM;

    mapping(address => bool) whitelistedRelayers;

    constructor (address _cdm) Trust(msg.sender){
        L1_CDM = CrossDomainMessenger(_cdm);
    }

    /// @notice whitelists a relayer address
    /// @dev only trusted user can call function  
    /// @param _addr relayer address to be whitelisted 
    function whiteListRelayer(address _addr) public requiresTrust {
        require(!isWhitelistedRelayer(_addr), "ALREADY_WHITELISTED");
        whitelistedRelayers[_addr] = true;
    }

    /// @notice blacklists an already whitelisted relayer address
    /// @dev only trusted user can call function  
    /// @param _addr relayer address to be blacklisted 
    function blackListRelayer(address _addr) public requiresTrust {
        require(isWhitelistedRelayer(_addr), "NOT_WHITELISTED");
        whitelistedRelayers[_addr] = false;
    }

    /// @notice Implements how a strategy is executed with specific calldata.
    /// @notice This call only returns data from non-state changing calls  
    /// @dev _data is encoded with :
    ///     address l1_target - The target contract to interact with on l1
    ///     address l2_target - The target contract to return data from call to l1_target on l2
    ///     bytes l1_calldata - calldata to execute on l1 
    ///     bytes4 l2_funcSelector - function selector to call to return data on l2
    ///     uint32 _gasLimit - gasLimit for returning data to l2 through l1 cross domain messenger 
    function sendDataToL2(bytes calldata _data) public {
        // check caller address 
        require(isWhitelistedRelayer(msg.sender), "RELAYER_NOT_WHITELISTED");

        ( address l1_target, address l2_target, bytes memory l1_callData, bytes4 l2_funcSelector, uint32 _gasLimit) = abi.decode(_data, (address,address,bytes,bytes4,uint32));
        
        // call l1 contract with calldata and get return data
        // recieving contract on l2 should specify how to handle data i.e uint x = abi.decode(returnData, (uint));
        (bool success, bytes memory returnData) = l1_target.staticcall(l1_callData);

        require(success);

        L1_CDM.sendMessage(
            l2_target,
            abi.encodeWithSelector(l2_funcSelector, returnData),
            _gasLimit
        );
    }


    /// @notice checks if an address is currently whitelisted 
    /// @param _addr address to check
    /// @return bool  
    function isWhitelistedRelayer(address _addr) public view returns(bool) {
        return whitelistedRelayers[_addr];
    }

}