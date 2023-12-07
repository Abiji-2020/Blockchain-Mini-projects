// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Blink{
    uint public myData;
    event blinkEvent(uint data);
    function getData() constant returns(uint retData){
        return myData;
    }
    fucntion setData(uint theData){
        myData = theData;
        blinkEvent(myData);
    }
}