// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/ICopyrightGraph.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CopyrightToken is ICopyrightGraph, ERC721 {

    uint256 public tokenCount;
    
    uint256[] private _leafTokenIDs;
    mapping(uint256 => Token) private _idToTokens;
    mapping(uint256 => bool) private _idToPermissionToDistribute;
    mapping(uint256 => bool) private _idToPermissionToAdapteFrom;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("Test Copyright Token", "TCT") {}

    /**
     * @dev Insert a new copyright token to the copyright graph.
     */
    function mint(uint256[] memory parentIds, uint256 tokenWeight) external {
        uint256 id = tokenCount++;
        _safeMint(_msgSender(), id);
        _idToTokens[id].tokenWeight = tokenWeight;
        _idToTokens[id].timeStamp = block.timestamp;

        for (uint256 i = 0; i < parentIds.length; i++) {
            require(parentIds[i] != 0, "Parent token ID of a parent is zero.");
            require(_exists(parentIds[i]), "Parent token does not exist.");
            require(
                _idToPermissionToAdapteFrom[parentIds[i]],
                "Parent token does not allow adoption."
            );
        }

        for (uint256 i = 0; i < parentIds.length; i++) {
            Edge memory newEdge = Edge(
                parentIds[i],
                _idToTokens[parentIds[i]].tokenWeight
            );
            _idToTokens[tokenCount].edges.push(newEdge);
            _idToTokens[tokenCount].numberOfTokensBehind++;

            // TODO if parent id is in leaf node array, replace with this node.
        }
    }

    /**
     * @dev Distribute copies with new ERC 721 token.
     */
    function distributeCopies(uint256 id) external returns (address) {
        require(
            _idToPermissionToDistribute[id],
            "The copyright owner does not allow distribution."
        );

        // TODO deploy a new ERC 721 for distribution and return the address
    }

    /**
     * @dev Deposit revenue to a copyright token and all inheriting copyright owners.
     */
    function deposit(uint256 id) external payable {
        require(_exists(id), "The token you make deposit to does not exist.");
        
        // TODO deposit and distribute the revenue. Use BFS and memory queue.
    }

    // For this demo, for simplicity, we don't need the following methods.

    function insertToken(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id,
        uint256 weight
    ) external {
        require(false, "Not implemented yet.");
    }

    function insertEdges(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id
    ) external {
        require(false, "Not implemented yet.");
    }

    function returnTime(uint256 id) external view returns (uint256 timeStamp) {
        require(false, "Not implemented yet.");
    }

    function returnTokenWeight(uint256 id)
        external
        view
        returns (uint256 weight)
    {
        require(false, "Not implemented yet.");
    }

    function returnIsBlacklisted(uint256 id)
        external
        view
        returns (bool isBlacklisted)
    {
        require(false, "Not implemented yet.");
    }

    function returnLeafTokenIDs()
        external
        view
        returns (uint256[] memory leafTokenIDs)
    {
        return _leafTokenIDs;
    }

    function changeTokenWeight(uint256 id, uint256 newWeight) external {
        require(false, "Not implemented yet.");
    }

    function blacklistToken(uint256 id, bool isBlacklisted) external {
        require(false, "Not implemented yet.");
    }

    function tokenExists(uint256 id) external view returns (bool exists) {
        require(false, "Not implemented yet.");
    }

    function returnId(Token memory token) external pure returns (uint256 id) {
        require(false, "Not implemented yet.");
    }
}
