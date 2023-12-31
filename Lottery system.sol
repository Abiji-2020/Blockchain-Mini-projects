// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Lottery {
    mapping(address => uint) usersBet;
    mapping(uint => address) users;
    uint nbUsers = 0;
    uint totalBets = 0;

    address owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        if (msg.value > 0) {
            if (usersBet[msg.sender] == 0) {
                users[nbUsers] = msg.sender;
                nbUsers += 1;
            }
            usersBet[msg.sender] += msg.value;
            totalBets += msg.value;
        }
    }

    function EndLottery() public {
        if (msg.sender == owner) {
            uint sum = 0;
            uint winningNumber = uint(blockhash(block.number - 1)) % totalBets;
            for (uint i = 0; i < nbUsers; i++) {
                sum += usersBet[users[i]];
                if (sum >= winningNumber) {
                    selfdestruct(address(uint160(users[i])));
                    return;
                }
            }
        }
    }
}
