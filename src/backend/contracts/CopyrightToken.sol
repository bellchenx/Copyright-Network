// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/ICopyrightGraph.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CopyrightToken is ICopyrightGraph, ERC721 {
    uint256[] private _leafTokenIDs;
    mapping(uint256 => Token) private _idToTokens;

    constructor() ERC721("Test Copyright Token", "TCT") {}

    function insertToken(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id,
        uint256 weight
    ) external {}

    function insertEdges(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id
    ) external {}

    function returnTokenWeight(uint256 id)
        external
        view
        returns (uint256 weight)
    {}

    // For this demo, we don't need the following methods

    function returnTime(uint256 id) external view returns (uint256 timeStamp) {
        require(false, "Not implemented yet");
    }

    function returnIsBlacklisted(uint256 id)
        external
        view
        returns (bool isBlacklisted)
    {
        require(false, "Not implemented yet");
    }

    function returnLeafTokenIDs()
        external
        view
        returns (uint256[] memory leafTokenIDs)
    {
        return _leafTokenIDs;
    }

    function changeTokenWeight(uint256 id, uint256 newWeight) external {
        require(false, "Not implemented yet");
    }

    function blacklistToken(uint256 id, bool isBlacklisted) external {
        require(false, "Not implemented yet");
    }

    function tokenExists(uint256 id) external view returns (bool exists) {
        require(false, "Not implemented yet");
    }

    function tokenCount() external view returns (uint256) {
        require(false, "Not implemented yet");
    }

    function returnId(Token memory token) external pure returns (uint256 id) {
        require(false, "Not implemented yet");
    }
}
