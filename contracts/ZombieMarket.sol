// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ZombieOwnership.sol";

// 僵尸市场合约
contract ZombieMarket is ZombieOwnership {

    // 税金
    uint public tax = 0.0001 ether;
    // 最低售价
    uint public minPrice = 0.0001 ether;

    // 僵尸售卖结构体
    struct ZombieSales {
        // 卖家地址
        address payable seller;
        // 售卖价格
        uint price;
    }

    // 僵尸商店（售卖中的僵尸集合）
    mapping (uint => ZombieSales) public zombieShop;

    // 僵尸挂出售卖事件
    event SaleZombie(uint indexed zombieId, uint indexed price);
    // 购买商店僵尸事件
    event BuyShopZombie(uint indexed zombieId, address indexed buyer, address indexed seller);

    // 出售我的僵尸
    function saleMyZombie(uint zombieId, uint price) external onlyOwnerOf(zombieId) {
        require(price >= tax + minPrice, "Your price is too low");
        // 僵尸售卖信息添加到商店
        zombieShop[zombieId] = ZombieSales(msg.sender, price);
        emit SaleZombie(zombieId, price);
    }

    // 购买商店中的僵尸
    function buyShopZombie(uint zombieId) external payable {
        ZombieSales memory zombieSales = zombieShop[zombieId];
        require(address(0) != zombieSales.seller, "Zombie are not on sale.");
        require(msg.value >= zombieSales.price, "Your price is too low");
        // 僵尸所有权转移
        _transfer(zombieSales.seller, msg.sender, zombieId);
        // 抛除税金后的金额转移给卖家
        zombieSales.seller.transfer(msg.value - tax);
        // 商店中移除此售卖信息
        delete zombieShop[zombieId];
        emit BuyShopZombie(zombieId, msg.sender, zombieSales.seller);
    }

    // 设置税金
    function setTax(uint value) external onlyOwner {
        tax = value;
    }

    // 设置最低销售金额
    function setMinPrice(uint value) external onlyOwner {
        minPrice = value;
    }
}