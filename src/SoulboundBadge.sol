// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SoulboundBadge {
    address public issuer;
    uint256 public totalBadges;

    struct Badge {
        address holder;
        string name;
        string uri;
        uint256 issuedAt;
    }
    mapping(uint256 => Badge) public badges;
    mapping(address => uint256[]) public holderBadges;

    event BadgeIssued(uint256 indexed id, address indexed holder, string name);
    event BadgeRevoked(uint256 indexed id);

    constructor(address) {
        issuer = msg.sender;
    }

    modifier onlyIssuer() { require(msg.sender == issuer, "NOT_ISSUER"); _; }

    function issue(address holder, string calldata name, string calldata uri) external onlyIssuer returns (uint256) {
        uint256 id = ++totalBadges;
        badges[id] = Badge(holder, name, uri, block.timestamp);
        holderBadges[holder].push(id);
        emit BadgeIssued(id, holder, name);
        return id;
    }

    function revoke(uint256 id) external onlyIssuer {
        require(badges[id].holder != address(0), "NOT_EXISTS");
        delete badges[id];
        emit BadgeRevoked(id);
    }

    function badgeCount(address holder) external view returns (uint256) {
        return holderBadges[holder].length;
    }
}
