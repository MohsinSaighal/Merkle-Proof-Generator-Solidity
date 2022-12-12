// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract MerkleProof is Ownable {
    bytes32[] public proof;
    bytes32[] public hashedDataSequence;
    bytes32 roots;
    bytes32 leafs;
    bytes32[] public array;
    bytes32[] public merkleTree;

    function getRootsandleaf()
        public
        view
        onlyOwner
        returns (bytes32, bytes32)
    {
        return (roots, leafs);
    }

    function getleaf() public view onlyOwner returns (bytes32) {
        return leafs;
    }

    function testMerkleVerification(address[] memory dataSequence) public {
        // Hash sequence ABCD
        for (uint256 i = 1; i < dataSequence.length; i++) {
            hashedDataSequence.push(
                keccak256(abi.encodePacked(dataSequence[i]))
            ); // hashing function is keccak256
        }
        merkleTree = buildMerkleTree(hashedDataSequence);
        bytes32 leaf = hashedDataSequence[0]; // h_B
        bytes32 root = merkleTree[merkleTree.length - 1]; // root  
        // Create proof
        proof.push(merkleTree[0]);
        for (uint256 i = 0; i < merkleTree.length; i++) {
                array.push(merkleTree[i]);
        }
        bytes32 hash = keccak256(abi.encodePacked(array));
        proof.push(hash);
        roots = root;
        leafs = leaf;

        // Verify
    }

    function buildMerkleTree(bytes32[] storage hashArray)
        internal
        returns (bytes32[] storage)
    {
        uint256 count = hashArray.length; // number of leaves
        uint256 offset = 0;
        while (count > 0) {
            // Iterate 2 by 2, building the hash pairs
            for (uint256 i = 0; i < count - 1; i += 2) {
                hashArray.push(
                    _hashPair(hashArray[offset + i], hashArray[offset + i + 1])
                );
            }
            offset += count;
            count = count / 2;
        }
        return hashArray;
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return
            a < b
                ? keccak256(abi.encodePacked(a, b))
                : keccak256(abi.encodePacked(b, a));
    }
}
