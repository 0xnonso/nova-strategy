// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NovaRegistry} from "@nova-interfaces/NovaRegistry.sol";
import {IOVM_CTC} from "./IOVM.sol";
import {IStrategy} from "./IStrategy.sol";
import {Auth} from "solmate/auth/Auth.sol";
import {CrossDomainMessenger} from "@nova-interfaces/CrossDomainMessenger.sol";


contract OVMQLength {

    NovaRegistry NOVA_REGISTRY;
    CrossDomainMessenger L2_OVM_CDM;
    IOVM_CTC OVM_CTC;
    IStrategy STRATEGY;
    address public ADMIN;
    address public owner;
    uint256 OVM_QUEUE_LENGTH;
    uint256 CACHE_PERIOD;
    uint256 lastRequestTimestamp = block.timestamp;

    event SetOVMQLength(uint40 qLength, uint256 timestamp);
    event SetCachingPeriod(uint256 _period);


    constructor(
        address _novaRegistry, 
        address _cdm, 
        address _ovmCtc, 
        address _strategy
        ){

        ADMIN = msg.sender;
        owner = address(STRATEGY);
        NOVA_REGISTRY = NovaRegistry(_novaRegistry);
        L2_OVM_CDM = CrossDomainMessenger(_cdm);
        OVM_CTC = IOVM_CTC(_ovmCtc);
        STRATEGY = IStrategy(_strategy);
    }

    function getOVMQLength() external view returns(uint256){
        return OVM_QUEUE_LENGTH;
    }

    function setOVMQLength(bytes memory _data) public onlyOwner() {
        uint40 _qLength = abi.decode(_data, (uint40));
        OVM_QUEUE_LENGTH = uint256(_qLength);
        lastRequestTimestamp = block.timestamp;
        emit SetOVMQLength(_qLength, block.timestamp);
    }

    function setOVMQLength(
        uint256 _novaGasLimit, 
        uint256 _cdmGasLimit_,
        uint256 _gasPrice,
        uint256 _tip, 
        NovaRegistry.InputToken[] memory _inputTokens) public {
        
        require(lastRequestTimestamp + CACHE_PERIOD > block.timestamp, "CACHING_PERIOD");

        bytes memory l1_calldata = abi.encode(
            address(OVM_CTC), 
            address(this), 
            abi.encodeWithSelector(IOVM_CTC.getQueueLength.selector),
            bytes4(keccak256("setOVMQLength(bytes)")),
            _novaGasLimit
        );

        NOVA_REGISTRY.requestExec(
        address(STRATEGY),
        abi.encodeWithSelector(IOVM_CTC.getQueueLength.selector, l1_calldata),
        _cdmGasLimit_,
        _gasPrice,
        _tip,
        _inputTokens
        );

    }
    function setCachingPeriod(uint256 _period) public {
        require(msg.sender == ADMIN, "NOT_ADMIN");
        CACHE_PERIOD = _period;
        emit SetCachingPeriod(_period);
    }



    modifier onlyOwner() {
    require(
        msg.sender == address(L2_OVM_CDM)
        && L2_OVM_CDM.xDomainMessageSender() == owner
    );
    _;
}

}

