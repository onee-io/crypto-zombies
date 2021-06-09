// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieMarket.sol";
import "./ZombieFeeding.sol";
import "./ZombieBattle.sol";

// 僵尸核心合约
contract ZombieCore is ZombieMarket, ZombieFeeding, ZombieBattle {

    // 名称
    string public constant name = "OneeCryptoZombie";
    // 符号
    string public constant symbol = "OCZ";

    // 提现
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // 检查余额
    function checkBalance() external view onlyOwner returns (uint) {
        return address(this).balance;
    }

    receive() external payable {}

    fallback() external payable {}
}