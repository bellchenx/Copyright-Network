// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721CopyDistribution is ERC721 {
    string public contractURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory uri
    ) ERC721(name, symbol) {
        contractURI = uri;
    }
}
