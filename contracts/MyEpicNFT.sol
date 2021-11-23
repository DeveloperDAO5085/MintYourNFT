// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "base64-sol/base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "POMP",
        "BET-DAVID",
        "KIYOSAKI",
        "BUFFET",
        "MUSK",
        "BEZOS",
        "MEETKEVIN",
        "JIHK",
        "JEREMY",
        "GATES",
        "MEME",
        "KOOPA",
        "WILL",
        "DYLAN",
        "BOY"
    ];
    string[] secondWords = [
        "LOVES",
        "HATES",
        "WORKS",
        "BUILDS",
        "OWNS",
        "LIKES",
        "RUNS",
        "HIKES",
        "THROWS",
        "DESTROYS",
        "INVESTS",
        "WRITES",
        "READS",
        "YIKES",
        "DISLIKES",
        "NINES"
    ];
    string[] thirdWords = [
        "ROCKETS",
        "TAXES",
        "STOCKS",
        "REALSTATE",
        "CRYPTO",
        "BOOKS",
        "CARS",
        "TOWERS",
        "CASIONS",
        "PROPERTIES",
        "ASSETS",
        "LIABILITIES",
        "MONEY",
        "GOLD",
        "SILVEr"
    ];
    uint256 maxNFTs = 10;
    event NewEpicNFTMinted(address sender, uint256 tokenId, uint256 maxTokenId);

    constructor() ERC721("MintYourNFT5085", "MYN5085") {
        console.log("This is my NFT contract. Whoa!");
    }

    function makeAnNFT() public {
        uint256 tokenId = _tokenIds.current();

        require(tokenId < maxNFTs);

        string memory firstWord = pickRandomWord(tokenId, "FIRST", firstWords);
        string memory secondWord = pickRandomWord(
            tokenId,
            "SECOND",
            secondWords
        );
        string memory thirdWord = pickRandomWord(tokenId, "THRIRD", thirdWords);
        string memory combinedWord = string(
            abi.encodePacked(firstWord, secondWord, thirdWord)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, finalTokenUri);
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, tokenId, maxNFTs);
    }

    function pickRandomWord(
        uint256 tokenId,
        string memory seed,
        string[] memory words
    ) public pure returns (string memory) {
        uint256 rand = random(
            string(abi.encodePacked(seed, Strings.toString(tokenId)))
        );
        rand = rand % words.length;
        return words[rand];
    }

    function random(string memory seed) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed)));
    }
}
