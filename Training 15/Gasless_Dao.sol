// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO {
    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    function createProposal(string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0);
    }

    function vote(uint256 proposalId) public {
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.voted[msg.sender], "Already voted");

        proposal.voted[msg.sender] = true;
        proposal.yesVotes++;
    }

    function getProposal(uint256 proposalId) public view returns (uint256 id, string memory description, uint256 yesVotes, uint256 noVotes) {
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        return (proposal.id, proposal.description, proposal.yesVotes, proposal.noVotes);
    }
}
