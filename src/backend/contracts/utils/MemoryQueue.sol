// SPDX-License-Identifier: MIT
// Reference: https://programtheblockchain.com/posts/2018/03/23/storage-patterns-stacks-queues-and-deques/

pragma solidity 0.8.15;

contract MemoryQueue {
    mapping(uint256 => uint256) private queue;
    
    uint256 private first = 1;
    uint256 private last = 0;

    bool private empty = true;

    function isEmpty() public view returns(bool) {
        return empty;
    }
    
    function enqueue(uint256 id) public {
        last += 1;
        empty = false;
        queue[last] = id;
    }

    function dequeue() public returns (uint256 id) {
        require(last >= first, "The queue is empty."); 
        id = queue[first];
        if (first == last) empty = true;
        delete queue[first];
        first += 1;
        return id;
    }
}