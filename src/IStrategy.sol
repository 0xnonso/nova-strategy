// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IStrategy{
    function sendDataToL2(bytes calldata _data) external;
}