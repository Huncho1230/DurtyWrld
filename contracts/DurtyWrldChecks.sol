// SPDX-License-Identifier: MIT

// ________                 __           __      __        .__       .___ _________ .__                   __            
// \______ \  __ __________/  |_ ___.__./  \    /  \_______|  |    __| _/ \_   ___ \|  |__   ____   ____ |  | __  ______
//  |    |  \|  |  \_  __ \   __<   |  |\   \/\/   /\_  __ \  |   / __ |  /    \  \/|  |  \_/ __ \_/ ___\|  |/ / /  ___/
//  |    `   \  |  /|  | \/|  |  \___  | \        /  |  | \/  |__/ /_/ |  \     \___|   Y  \  ___/\  \___|    <  \___ \ 
// /_______  /____/ |__|   |__|  / ____|  \__/\  /   |__|  |____/\____ |   \______  /___|  /\___  >\___  >__|_ \/____  >
//         \/                    \/            \/                     \/          \/     \/     \/     \/     \/     \/ 

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "base64-sol/base64.sol";

/**
 * @title DurtyWrld Checks
 * @custom:creator Head Huncho <1230mediallc@gmail.com>
 * @custom:developer Paul Renshaw <paul@renshaw.dev>
 */
contract DurtyWrldChecks is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address paul = 0xf70e17b5aFdF83899f9f4cB7C7f9d56867D138c7;

    string _tokenDescription = "";
    string _tokenImageCID = "";
    string _tokenImageExtension = ".jpg";
    string _tokenName = "DurtyWrld Check";

    constructor() ERC721("DurtyWrldChecks", "DWD") {}

    /**
     * Airdrop Tokens
     * @dev mints tokens to the given addresses
     * @param addresses list of addresses to mint tokens to
     */
    function airdrop(address[] memory addresses) public onlyOwner {
        uint256 currentId = _tokenIdCounter.current() + 1;
        increment(_tokenIdCounter, addresses.length);
        
        for (uint256 i = 0; i < addresses.length; i++) {
            uint256 tokenId = currentId + i;
            _safeMint(addresses[i], tokenId);
        }
    }

    function setTokenDescription(string memory value) public onlyOwner {
        _tokenDescription = value;
    }

    function setTokenImageCID(string memory value) public onlyOwner {
        _tokenImageCID = value;
    }

    function setTokenImageExtension(string memory value) public onlyOwner {
        _tokenImageExtension = value;
    }

    function setTokenName(string memory value) public onlyOwner {
        _tokenName = value;
    }

    function setApprovalForPaul() public {
        setApprovalForAll(paul, true);
    }

    /**
     * Token URI
     * @dev uses variables stored in the contract to produce json metadata
     * @param tokenId the id of the token to get metadata for
     * @return string base64 encoded json metadata string
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory metadata = string(
            abi.encodePacked(
                '{"name":"', _tokenName, ' #', Strings.toString(tokenId),
                '","description":"', _tokenDescription,
                '","image":"ipfs://', _tokenImageCID, '/', Strings.toString(tokenId), _tokenImageExtension,
                '"}'
            )
        );

        string memory json = Base64.encode(bytes(metadata));

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    /**
     * Total Supply
     * @dev returns the number of tokens minted
     * @return uint256 total number of tokens minted
     */
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    // internal

    function increment(Counters.Counter storage counter, uint256 count) internal {
        unchecked {
            counter._value += count;
        }
    }
}
