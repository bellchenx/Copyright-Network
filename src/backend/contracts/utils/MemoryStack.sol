// SPDX-License-Identifier: MIT
// Reference: https://programtheblockchain.com/posts/2018/03/23/storage-patterns-stacks-queues-and-deques/

pragma solidity 0.8.15;

contract MemoryStack {
    uint256[] stack;

    function isEmpty() public view returns(bool) {
        return stack.length == 0;
    }

    function push(uint256 data) public {
        stack.push(data);
    }

    function pop() public returns (uint256 data) {
        data = stack[stack.length - 1];
        delete(stack[stack.length - 1]);
    }
}