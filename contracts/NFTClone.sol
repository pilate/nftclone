// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFTClone is ERC721Enumerable, Ownable {
    using Strings for uint256;

    mapping(uint256 => NFT) public tokenIdToNFT;

    struct NFT {
        address destContract;
        uint256 tokenId;
    }

    constructor() ERC721("NFTClone", "NCLN") {}

    function mint(address _contract, uint256 _tokenId) public payable {
        // require(bytes(_userText).length <= 30, "String input exceeds limit.");
        uint256 supply = totalSupply();

        NFT memory newNFT = NFT(
            _contract,
            _tokenId
        );

        if (msg.sender != owner()) {
            require(msg.value >= 0.005 ether, "Requires 0.005 eth payment");
        }

        tokenIdToNFT[supply + 1] = newNFT;
        _safeMint(msg.sender, supply + 1);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        NFT memory currentNFT = tokenIdToNFT[_tokenId];
        return ERC721(currentNFT.destContract).tokenURI(_tokenId);
    }

    //only owner
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
