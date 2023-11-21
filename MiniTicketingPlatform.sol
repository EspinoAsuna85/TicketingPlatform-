// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TicketingPlatform is ERC721, Ownable {
    uint256 public nextTicketId;
    uint256 public ticketPrice;

    mapping(uint256 => uint256) public ticketEvent;
    mapping(uint256 => bool) public ticketRedeemed;

    event TicketPurchased(address indexed buyer, uint256 indexed ticketId, uint256 indexed eventId);
    event TicketRedeemed(address indexed redeemer, uint256 indexed ticketId);

    modifier onlyTicketOwner(uint256 _ticketId) {
        require(ownerOf(_ticketId) == msg.sender, "Not the ticket owner");
        _;
    }

    modifier ticketNotRedeemed(uint256 _ticketId) {
        require(!ticketRedeemed[_ticketId], "Ticket already redeemed");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint256 _ticketPrice) ERC721(_name, _symbol) {
        ticketPrice = _ticketPrice;
    }
function purchaseTicket(uint256 _eventId) external payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");

        uint256 ticketId = nextTicketId;
        nextTicketId++;

        _safeMint(msg.sender, ticketId);
        ticketEvent[ticketId] = _eventId;

        emit TicketPurchased(msg.sender, ticketId, _eventId);
    }
function redeemTicket(uint256 _ticketId) external onlyTicketOwner(_ticketId) ticketNotRedeemed(_ticketId) {
        ticketRedeemed[_ticketId] = true;

        // Additional logic for redeeming the ticket, e.g., granting access to an event

        emit TicketRedeemed(msg.sender, _ticketId);
    }
}
