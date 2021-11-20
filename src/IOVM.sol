// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IOVM_CTC{
    function getQueueLength()
        external
        view
        returns (
            uint40
        );
}

