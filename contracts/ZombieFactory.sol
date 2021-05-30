// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// 僵尸工厂合约
contract ZombieFactory is Ownable {
    using SafeMath for uint256;

    // 基因位数
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // 冷却时间
    uint public cooldownTime = 1 days;
    // 僵尸售价
    uint public zombiePrice = 0.0001 ether;
    // 僵尸总数
    uint public zombieCount = 0;

    // 定义僵尸结构体
    struct Zombie {
        // 姓名
        string name;
        // 基因序列
        uint dna;
        // 胜利次数
        uint winCount;
        // 失败次数
        uint lossCount;
        // 等级
        uint level;
        // 冷却时间
        uint readyTime;
    } 

    // 所有僵尸集合
    Zombie[] public zombies;
    // 僵尸拥有者映射：僵尸ID => 拥有者
    mapping (uint => address) public zombieToOwner;
    // 地址拥有僵尸数组映射：拥有者 => 僵尸ID数组
    mapping (address => uint[]) ownerZombies;
    // 僵尸喂养次数映射：僵尸ID => 喂养次数
    mapping (uint => uint) zombieFeedTimes;

    // 僵尸创建事件
    event NewZombie(uint zombieId, string name, uint dna);

    // 创建僵尸
    function createZombie(string memory name) public {
        // 校验每个账户只能免费生成一只僵尸
        require(ownerZombies[msg.sender].length == 0, "You already have a zombie.");
        uint randomDna = _generateRandomDna(name);
        randomDna = randomDna - randomDna % 10; // 将基因最后一位改为0，标记为免费僵尸
        _createZombie(name, randomDna);
    }

    // 购买僵尸
    function buyZombie(string memory name) public payable {
        // 校验账户目前没有僵尸
        require(ownerZombies[msg.sender].length > 0, "You can create a zombie for free.");
        // 校验金额大于等于僵尸售价
        require(msg.value >= zombiePrice, "Your balance is not enough.");
        uint randomDna = _generateRandomDna(name);
        randomDna = randomDna - randomDna % 10 + 1; // 将基因最后一位改为1，标记为购买僵尸
        _createZombie(name, randomDna);
    }

    // 修改僵尸售价（只有合约拥有者才可以修改）
    function setZombiePrice(uint price) external onlyOwner {
        zombiePrice = price;
    }

    // 生成随机基因序列（此随机算法不安全）
    function _generateRandomDna(string memory name) private view returns (uint) {
        return uint(keccak256(abi.encodePacked(name, block.timestamp))) % dnaModulus;
    }

    // 创建僵尸
    function _createZombie(string memory name, uint dna) internal {
        // 生成僵尸
        zombies.push(Zombie(name, dna, 0, 0, 1, 0));
        uint zombieId = zombies.length - 1;
        // 设定僵尸拥有者并更新数量
        zombieToOwner[zombieId] = msg.sender;
        ownerZombies[msg.sender].push(zombieId);
        zombieCount = zombieCount.add(1);
        // 触发僵尸创建事件
        emit NewZombie(zombieId, name, dna);
    }
}