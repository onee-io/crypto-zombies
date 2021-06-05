// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieFactory.sol";

// 僵尸助手合约
contract ZombieHelper is ZombieFactory {
    
    // 升级费用
    uint public levelUpFee = 0.0001 ether;

    // 判断僵尸大于指定等级
    modifier aboveLevel(uint level, uint zombieId) {
        require(zombies[zombieId].level >= level, "Your zombie level is less than level.");
        _;
    }

    // 判断调用者为僵尸的拥有者
    modifier onlyOwnerOf(uint zombieId) {
        require(msg.sender == zombieToOwner[zombieId], "This zombie doesn't belong to you.");
        _;
    }

    // 设置升级费（只有合约拥有者才可以修改）
    function setLevelUpFee(uint fee) external onlyOwner {
        levelUpFee = fee;
    }

    // 付费升级
    function levelUp(uint zombieId) external payable {
        require(msg.value >= levelUpFee, "Your balance is not enough.");
        zombies[zombieId].level++;
    }

    // 僵尸改名（需为自己所拥有的僵尸并且等级至少2级）
    function changeName(uint zombieId, string calldata name) external aboveLevel(2, zombieId) onlyOwnerOf(zombieId) {
        zombies[zombieId].name = name;
    }

    // 自定义僵尸DNA（需为自己所拥有的僵尸并且等级至少20级）
    function changeDna(uint zombieId, uint dna) external aboveLevel(20, zombieId) onlyOwnerOf(zombieId) {
        zombies[zombieId].dna = dna;
    }

    // 获取地址所拥有的僵尸数组
    function getZombiesByOwner(address owner) external view returns (uint[] memory) {
        // 为了节省gas消耗 在内存中创建结果数组 方法之后完后就会销毁
        uint[] memory result = new uint[](ownerZombieCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // 触发冷却
    function _triggerCooldown(Zombie storage zombie) internal {
        // 冷却时间到次日凌晨0点
        zombie.readyTime = uint32(block.timestamp + cooldownTime) - uint32(block.timestamp + cooldownTime) % 1 days;
    }

    // 判断僵尸是否完成冷却
    function _isReady(Zombie storage zombie) internal view returns (bool) {
        return block.timestamp >= zombie.readyTime;
    }

    // 僵尸合体 产生新僵尸
    function _multiply(uint zombieId, uint targetDna) internal onlyOwnerOf(zombieId) {
        Zombie storage zombie = zombies[zombieId];
        require(_isReady(zombie), "Your zombie are cooldown");
        // 取两个基因序列的平均数为新的基因序列
        targetDna = targetDna % dnaModulus; // 确保目标基因序列满足格式
        uint newDna = (zombie.dna + targetDna) / 2;
        newDna = newDna - newDna % 10 + 9; // 将基因最后一位改为9，标记为合体僵尸
        _createZombie("NoName", newDna);
        // 触发冷却
        _triggerCooldown(zombie);
    }
}