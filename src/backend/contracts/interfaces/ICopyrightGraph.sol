// SPDX-License-Identifier: MIT
// Reference: https://github.com/bellchenx/Fractional-Copyright-Token/blob/v0.1.0/contracts/CopyrightGraph.sol

pragma solidity 0.8.15;

/**
@dev Required interface for copyright master functions and data structure. 
This code is an interface for a directionally weighted-graph structure. 
It is a graph because it will use vertices and edges. 
It is weighted because it will store a metric (for instance, royalty cap model).
It is directional because no path will include any two vertices that are the same. 
In other words, there will be no graph loops.
For this interface, all vertices all called tokens and the data stored by a 
token is its id, weight, timestamp, and isBlacklisted boolean. All ids
are non-zero positive tntegers. This is because the zero id will act like a null id.
For this interface, all edges have a dynamic array of to destinations and weights so edges can be added to 
the graph.
Note the topology of all tokens is immutable when added to the graph.
This means that tokens and edge connections are immuable after being added to graph. 
Note that the weight of a token is mutable. 
When the owner of a token wants to change its token weight, it can update the number by calling a function.
Note that the isBlacklisted boolean is mutable. The state of being blacklisted can change. 
Token blacklisting is added in this interface instead of token deletion to save gas fees on chain. 
Instead of deleting a token, a token is instead blacklisted for potential features.
Based on reasearch from:
https://ethereum.stackexchange.com/questions/78333/efficient-solidity-storage-pattern-for-a-directional-weighted-graph
@author Elijah Mansur 
@title Interface Copyright Graph
 */
interface ICopyrightGraph {
    /**
    @dev struct to store the edge data 'to' with a 'weight'. An edge points at the next token in the directional graph. 
    This data is immutable unless an edge is removed from the graph. 
     */
    struct Edge {
        uint256 to;
        uint256 weight;
    }

    /**
    @dev struct to store a token object with an 'id', 'weight', 'timeStamp', and 'isBlacklisted'. The 'weight' and 'isBlacklisted' in {Token} are mutable. 
    'edge' is an element of {token} to search quickly for edge connections to {token}.
     */
    struct Token {
        uint256 tokenWeight;
        uint256 timeStamp;
        bool isBlacklisted;
        Edge[] edges;
        uint256 numberOfTokensBehind;
    }

    /**
    @dev Emitted when a new 'token' is added to the graph at a time. The 'token'
    is added to the graph as a new node that holds {edge} connections that represent
    all of the edge connections to 'token'.
     */
    event AddTokenToGraph(Token token);

    /**
    @dev Emitted when the function {changeTokenWeight} is called. 'id' represents 
    the id for which a 'newWeight' was added to {token}.
     */
    event ChangeTokenWeight(uint256 id, uint256 newWeight);

    /**
    @dev Emitted when the function {blacklistToken} is called. A {token} with an 'id' 
    is either blacklisted or unblacklisted. 
     */
    event TokenBlacklisted(uint256 id, bool isBlacklisted);

    /**
    @dev Creates a struct {token} that holds the edge connections to its parents. 
    Requirements: 
    -  'id' and 'parentIds' must not be subsets unless 'parentIds' is the zero ID
    -  'id' must not be zero 
    -   If 'parentIds' is not a set, this function must revert 
    -   If 'parentIds' have not been added to the graph, this function must revert
     */
    function insertToken(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id,
        uint256 weight
    ) external;

    /**
    @dev Makes the edge connections between 'parentIds' and 'id' with an array of 'parentWeights' for each of the
    'parentIds'. 
    Requirements:  
    -   'parentIds' and 'id' cannot be the zero token ID 
    -   'id' and 'parentIds' must not be subsets.
    -    If 'parentIds' is not a set, this function must revert 
    -    If 'parentIds' and 'id' have not been added to the graph, this function must revert
    -    If a potential edge connection that is to be added is redundant, this function must revert that there is redundant edge connection
    -    If an edge connection will create a graph loop, this function must revert
     */
    function insertEdges(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id
    ) external;

    /**
    @dev changes the weight in a 'token' struct to 'newWeight'
    Requirements: 
    -   'token' must allready exist in weighted graph
     */
    function changeTokenWeight(uint256 id, uint256 newWeight) external;

    /**
    @dev blacklists a {token} with 'id' to a boolean 'isBlacklisted'
    Requirements: 
    -   'id' must exist on the weighted graph and not be zero
     */
    function blacklistToken(uint256 id, bool isBlacklisted) external;

    /**
    @dev This function should find all of the 'tokens' in the path behind the chosen 'id' 
    and their 'weights'. How data is saved based on breadth first search is up to the 
    implementer and their application.
    Requirements: 
    -   'id' must exist on the weighted graph and not be zero
     */
   //function bfsTraversal(uint256 id) external;

    // View and Pure Functions

    /**
    @dev returns if a {token} with 'id' is located on the graph.
     */
    function tokenExists(uint256 id) external view returns (bool exists);

    /**
    @dev Returns the amount of tokens in the graph. 
     */
    function tokenCount() external view returns (uint256);

    /**
    @dev Returns the 'id' associated with 'token'. All other functions behave similar with differerent 
    return values. 
    Requirements: 
    -   'token' must exist on graph
     */
    function returnId(Token memory token) external pure returns (uint256 id);

    function returnTokenWeight(uint256 id)
        external
        view
        returns (uint256 weight);

    function returnTime(uint256 id)
        external
        view
        returns (uint256 timeStamp);

    function returnIsBlacklisted(uint256 id)
        external
        view
        returns (bool isBlacklisted);
}