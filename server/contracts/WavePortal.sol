// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;

    // to google event
    event NewWave(address indexed from, uint256 timestamp, string message);

    // a struct is a custom datatype
    struct Wave {
        address waver; //adress of the user who waved
        string message; //the message that the user sent
        uint256 timestamp; //the timestamp when the user waved
    }

    /**** declare a variable called wave to store an array of structs ****/
    Wave[] waves;

    mapping(address=>uint256) public lastWavedAt;

    constructor() payable {
        console.log("Construction done here!");

        // set the initial seed
        seed=(block.timestamp+block.difficulty)%100;
    }

    function wave(string memory _message) public {
        // current timestamp 15mn greater than last stored timestamp
        require(lastWavedAt[msg.sender]+15 minutes<block.timestamp, "wait 15m");

        // update the current timetsamp
        lastWavedAt[msg.sender]=block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // where the wave data is stored in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed for the next user that sends the wave
        seed=(block.difficulty+block.timestamp+seed)%100;


        // give a 50% chance that the waver wins the prize
        if (seed<=50) {
            console.log('%s won!', msg.sender);

        // to send prizemoney to those who waved
        uint256 prizeAmount=0.0001 ether;
        require(
            prizeAmount<=address(this).balance, "Trying to withdraw more money than the contract has."
        );

        (bool success, )=(msg.sender).call{value:prizeAmount}("");
        require(success, 'Failed to withdraw money from contract.');
        }

        // to be googled
        emit NewWave(msg.sender, block.timestamp, _message);

        
    }

    // this function is to return the struct array, waves to us. It'll be easier to retrive the wave from our frontend
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);

        return totalWaves;
    }

    
}