// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Election {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint voteIndex;
        uint weight;
    }

    address public owner;
    string public name;
    mapping (address => Voter) public voters;
    Candidate[] public candidates;
    uint public auctionEnd;

    event ElectionResult(string name, uint voteCount);

    constructor(string memory _name, uint durationMinutes, string memory candidate1, string memory candidate2) {
        owner = msg.sender;
        name = _name;
        auctionEnd = block.timestamp + (durationMinutes * 1 minutes);
        candidates.push(Candidate(candidate1, 0));
        candidates.push(Candidate(candidate2, 0));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function authorize(address voter) public onlyOwner {
        require(!voters[voter].voted, "Voter has already voted");
        voters[voter].weight = 1;
    }

    function vote(uint voteIndex) public {
        require(block.timestamp < auctionEnd, "Election has ended");
        require(!voters[msg.sender].voted, "You have already voted");

        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = voteIndex;
        candidates[voteIndex].voteCount += voters[msg.sender].weight;
    }

    function end() public onlyOwner {
        for (uint i = 0; i < candidates.length; i++) {
            emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        }
    }
}
