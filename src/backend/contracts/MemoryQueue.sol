// SPDX-License-Identifier: MIT
// Reference: https://github.com/bellchenx/Fractional-Copyright-Token/blob/v0.1.0/contracts/Queue.sol

pragma solidity 0.8.15;

contract MemoryQueue {
    mapping(uint256 => uint256) queue;
    
    uint256 first = 1;
    uint256 last = 0;

    bool isEmpty = true;

    function enqueue(uint256 id) public {
        last += 1;
        isEmpty = false;
        queue[last] = id;
    }

    function dequeue() public returns (uint256 id) {
        require(last >= first, "The queue is empty."); 
        id = queue[first];
        if (first == last) isEmpty = true;
        delete queue[first];
        first += 1;
        return id;
    }
}