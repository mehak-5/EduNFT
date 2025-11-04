// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EduNFT: Tokenized Learning Certificates for Lifelong Education
 * @dev This contract issues, stores, and manages learning certificates as ERC721 NFTs.
 * Each NFT represents a verified educational achievement.
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EduNFT is ERC721, Ownable {
    uint256 private _tokenIds;

    struct Certificate {
        string studentName;
        string courseName;
        string institution;
        uint256 issueDate;
    }

    mapping(uint256 => Certificate) public certificates;

    constructor() ERC721("EduNFT", "EDU") Ownable(msg.sender) {}

    /**
     * @dev Issue a new learning certificate NFT to a student.
     * @param student The recipient's wallet address.
     * @param studentName Name of the student.
     * @param courseName Name of the completed course or program.
     * @param institution Name of the issuing institution.
     */
    function issueCertificate(
        address student,
        string memory studentName,
        string memory courseName,
        string memory institution
    ) public onlyOwner returns (uint256) {
        require(student != address(0), "Invalid student address");

        _tokenIds++;
        uint256 newTokenId = _tokenIds;

        _safeMint(student, newTokenId);

        certificates[newTokenId] = Certificate({
            studentName: studentName,
            courseName: courseName,
            institution: institution,
            issueDate: block.timestamp
        });

        return newTokenId;
    }

    /**
     * @dev View certificate details by token ID.
     * Reverts if the certificate does not exist.
     */
    function viewCertificate(uint256 tokenId)
        public
        view
        returns (Certificate memory)
    {
        require(_ownerOf(tokenId) != address(0), "Certificate does not exist");
        return certificates[tokenId];
    }

    /**
     * @dev Revoke (burn) a certificate. Only the contract owner can revoke.
     * Once revoked, certificate data is removed from storage.
     */
    function revokeCertificate(uint256 tokenId) public onlyOwner {
        require(_ownerOf(tokenId) != address(0), "Certificate does not exist");
        _burn(tokenId);
        delete certificates[tokenId];
    }
}
