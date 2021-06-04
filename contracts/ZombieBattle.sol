// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieHelper.sol";

// 僵尸对战合约
contract ZombieBattle is ZombieHelper {

    // 随机数种子
    uint randNonce = 0;
    // 攻击胜利概率
    uint attackVicttoryProbability = 70;

    // 生成指定位数的随机数
    function randMod(uint modulus) internal returns (uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    }

    // 设置攻击胜利概率
    function setAttackVicttoryProbability(uint probability) external onlyOwner {
        attackVicttoryProbability = probability;
    }

    // 僵尸攻击
    function attack(uint zombieId, uint targetId) external ownerOf(zombieId) {
        Zombie storage myZombie = zombies[zombieId];
        Zombie storage enemyZombie = zombies[targetId];
        // 生成战斗结果随机数
        uint rand = randMod(100);
        if (rand < attackVicttoryProbability) {
            // 战斗胜利
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            _multiply(zombieId, enemyZombie.dna);
        } else {
            // 战斗失败
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}