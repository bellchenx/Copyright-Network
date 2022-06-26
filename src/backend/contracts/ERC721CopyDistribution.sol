// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721CopyDistribution is ERC721, Ownable {
    string public contractURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory uri
    ) ERC721(name, symbol) Ownable(){
        contractURI = uri;
    }
}
