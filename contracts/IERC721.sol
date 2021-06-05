// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// NFT合约接口定义
interface IERC721 {

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // 批准事件
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // 查询余额
    function balanceOf(address owner) external view returns (uint256 balance);
    // 查询所有者
    function ownerOf(uint256 tokenId) external view returns (address owner);
    // 交易
    function transfer(address to, uint256 tokenId) external;
    // 批准
    function approve(address to, uint256 tokenId) external;
    // 接收
    function takeOwnership(uint256 tokenId) external;
}