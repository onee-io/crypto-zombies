// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ZombieHelper.sol";

// 僵尸喂养合约
contract ZombieFeeding is ZombieHelper {
    using SafeMath for uint256;

    // 喂养僵尸
    function feed(uint zombieId) public ownerOf(zombieId) {
        Zombie storage zombie = zombies[zombieId];
        require(_isReady(zombie), "Your zombie are cooldown");
        // 喂养次数+1
        zombieFeedTimes[zombieId] = zombieFeedTimes[zombieId].add(1);
        // 触发冷却
        _triggerCooldown(zombie);
        // 每喂养10次会生成一只新的僵尸 继承父僵尸基因序列
        if (zombieFeedTimes[zombieId] % 10 == 0) {
            uint newDna = zombie.dna - zombie.dna % 10 + 8; // 将基因最后一位改为8，标记为喂养生成僵尸
            _createZombie("zombie's son", newDna);
        }
    }
}