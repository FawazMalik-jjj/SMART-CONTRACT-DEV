//SPDX-License-Identifier:MIT
pragma solidity ^0.4.22;

contract VotingRefactored {

    struct CandidateStruct {
        bool isValid;
        uint64 votes;
    }

    mapping(address => CandidateStruct) public candidates;

    constructor(address[] _candidates) public {
        for(uint256 i = 0; i < _candidates.length; i++) {
            candidates[_candidates[i]].isValid = true;
        }
    }

    function voteForCandidate(address _candidate) public {
        candidates[_candidate].votes += 1;
    }
