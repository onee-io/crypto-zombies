// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ZombieHelper.sol";
import "./IERC721.sol";

contract ZombieOwnership is ZombieHelper, IERC721 {
    using SafeMath for uint256;

    mapping (uint => address) zombieApprovals;

    // 查询余额
    function balanceOf(address owner) external view override returns (uint256 balance) {
        return ownerZombieCount[owner];
    }

    // 查询所有者
    function ownerOf(uint256 tokenId) external view override returns (address owner) {
        return zombieToOwner[tokenId];
    }

    // 交易
    function transfer(address to, uint256 tokenId) external override {
        require(msg.sender == zombieToOwner[tokenId] || msg.sender == zombieApprovals[tokenId] , "You are not owner or approved.");
        _transfer(msg.sender, to, tokenId);
    }

    // 批准
    function approve(address to, uint256 tokenId) external override {
        require(msg.sender == zombieToOwner[tokenId], "You are not owner.");
        zombieApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    // 接收
    function takeOwnership(uint256 tokenId) external override {
        require(msg.sender == zombieApprovals[tokenId], "You are not approved.");
        // 查询原拥有者
        address owner = zombieToOwner[tokenId];
        _transfer(owner, msg.sender, tokenId);
    }

    // 交易函数
    function _transfer(address from, address to, uint tokenId) internal {
        ownerZombieCount[to] = ownerZombieCount[to].add(1);
        ownerZombieCount[from] = ownerZombieCount[from].sub(1);
        zombieToOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
}