// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/ICopyrightGraph.sol";
import "./ERC721CopyDistribution.sol";
import "./utils/MemoryStack.sol";
import "./utils/MemoryQueue.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CopyrightToken is ICopyrightGraph, ERC721, Ownable {
    uint256 public tokenCount;

    uint256[] private _leafTokenIDs;
    mapping(uint256 => uint256) private _leafTokenIDIndex;

    mapping(uint256 => Token) private _idToTokens;
    mapping(uint256 => bool) private _idToPermissionToDistribute;
    mapping(uint256 => bool) private _idToPermissionToAdapteFrom;

    mapping(uint256 => ERC721CopyDistribution) private _distributions;

    mapping(uint256 => string) private _distributionName;
    mapping(uint256 => string) private _distributionSymbol;
    mapping(uint256 => string) private _distributionURI;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("Test Copyright Token", "TCT") Ownable() {
        _leafTokenIDs.push(0); // placeholder for the 0 index
    }

    /**
     * @dev Insert a new copyright token to the copyright graph.
     */
    function mint(uint256[] memory parentIds, uint256 tokenWeight) external {
        uint256 id = ++tokenCount;
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

        if (parentIds.length > 0) {
            for (uint256 i = 0; i < parentIds.length; i++) {
                uint256 parentID = parentIds[i];
                Edge memory newEdge = Edge(
                    parentID,
                    _idToTokens[parentID].tokenWeight
                );
                _idToTokens[tokenCount].edges.push(newEdge);
                _idToTokens[tokenCount].numberOfTokensBehind++;

                if (_leafTokenIDIndex[parentID] != 0) {
                    uint256 parentIdx = _leafTokenIDIndex[parentID];
                    _leafTokenIDIndex[parentID] = 0;

                    _leafTokenIDIndex[id] = parentIdx;
                    _leafTokenIDs[parentIdx] = id;
                }
            }
        } else {
            _leafTokenIDs.push(id);
            _leafTokenIDIndex[id] = _leafTokenIDs.length - 1;
        }
    }

    function setDistributionInfo(
        uint256 id,
        string memory name,
        string memory symbol,
        string memory uri
    ) external {
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change info."
        );
        _distributionName[id] = name;
        _distributionSymbol[id] = symbol;
        _distributionURI[id] = uri;
    }

    /**
     * @dev Distribute copies with new ERC 721 token.
     */
    function distributeCopies(uint256 id) external returns (address) {
        require(
            _idToPermissionToDistribute[id],
            "The copyright owner does not allow distribution."
        );
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change info."
        );

        ERC721CopyDistribution nftDistribution = new ERC721CopyDistribution(
            _distributionName[id],
            _distributionSymbol[id],
            _distributionURI[id]
        );
        _distributions[id] = nftDistribution;
        return address(nftDistribution);
    }

    /**
     * @dev Deposit revenue to a copyright token and all inheriting copyright owners.
     */
    function deposit(uint256 id) external payable {
        require(_exists(id), "The token you make deposit to does not exist.");

        MemoryQueue queue = new MemoryQueue();
        MemoryStack idStack = new MemoryStack();
        MemoryStack royaltyStack = new MemoryStack();
        
        queue.enqueue(id);

        while (!queue.isEmpty()) {
            uint256 tempID = queue.dequeue();
            idStack.push(tempID);

            Token memory token = _idToTokens[tempID];
            Edge[] memory edges = token.edges;

            for(uint256 i = 0; i < edges.length; i ++) {
                Edge edge
            }
        }
    }

    /**
     * @dev Change the permission of adoption from this copyright
     */
    function changeAdoptionPermission(uint256 id, bool permission) external {
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change permission."
        );
        _idToPermissionToAdapteFrom[id] = permission;
    }

    /**
     * @dev Change the permission of distrubute copies as NFT from this copyright
     */
    function changeDistributionPermission(uint256 id, bool permission)
        external
    {
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change permission."
        );
        _idToPermissionToDistribute[id] = permission;
    }

    // View functions

    function getToken(uint256 id) external view returns (Token memory) {
        return _idToTokens[id];
    }

    function isIndependent(uint256 id) external view returns (bool) {
        return _leafTokenIDIndex[id] > 0;
    }

    function doAllowAdoption(uint256 id) external view returns (bool) {
        return _idToPermissionToAdapteFrom[id];
    }

    function doAllowDistribution(uint256 id) external view returns (bool) {
        return _idToPermissionToDistribute[id];
    }

    function isDistributionOf(uint256 id, address nftAddress)
        external
        view
        returns (bool)
    {
        return address(_distributions[id]) == nftAddress;
    }

    function returnLeafTokenIDs()
        external
        view
        returns (uint256[] memory leafTokenIDs)
    {
        return _leafTokenIDs;
    }

    function getDistributionToken(uint256 id) external view returns (ERC721) {
        return _distributions[id];
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
