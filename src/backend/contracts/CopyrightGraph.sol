// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/ICopyrightGraph.sol";

contract CopyrightGraphForERC721 is ICopyrightGraph {

    constructor(){}

    function insertToken(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id,
        uint256 weight
    ) public {}

    function insertEdges(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id
    ) public {}

    function changeTokenWeight(uint256 id, uint256 newWeight) external {}

    function blacklistToken(uint256 id, bool isBlacklisted) external {}

    function tokenExists(uint256 id) external view returns (bool exists) {}

    function tokenCount() external view returns (uint256){}

    function returnId(Token memory token) external pure returns (uint256 id) {}

    function returnTokenWeight(uint256 id)
        external
        view
        returns (uint256 weight){}

    function returnTime(uint256 id)
        external
        view
        returns (uint256 timeStamp) {}

    function returnIsBlacklisted(uint256 id)
        external
        view
        returns (bool isBlacklisted) {}
}
