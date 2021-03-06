# 僵尸之谜

区块链 NFT 游戏，基于火币生态链 Heco 开发部署。

官方教程：[https://cryptozombies.io/](https://cryptozombies.io/)

视频教程：[https://www.youtube.com/playlist?list=PLV16oVzL15MQDi5sPb1WEBm7m7U6-11s1](https://www.youtube.com/playlist?list=PLV16oVzL15MQDi5sPb1WEBm7m7U6-11s1)

游戏地址：// TODO 待开发完成后部署到 Heco 主网

## 火币生态链 Heco 主网节点

- 名称：Heco Mainnet
- RPC URL：https://http-mainnet-node.huobichain.com
- 链ID：128
- 符号：HT
- 区块浏览器URL：https://hecoinfo.com

## 合约 UML

![](https://cdn.jsdelivr.net/gh/onee-io/onee-resource/picgo/20210608185633.jpg)

## 编译步骤

```sh
# 合约编译
$ truffle compile

# 合约部署
$ truffle migrate

# 安装前端依赖
$ npm install

# 启动游戏
$ npm run serve
```

## 需求列表

### 基因

- [x] 每个僵尸有一个16位10进制数字作为基因
- [x] 最后一位数字为特殊标识
- [x] 僵尸名称为 string 字符串
- [x] 根据名称和随机数创建僵尸基因

### 拥有

- [x] 每人可以免费领养1只僵尸
- [x] 拥有超过1只僵尸之后需要购买僵尸
- [x] 主动攻击另1只僵尸并且胜利之后可以产生1只僵尸
- [x] 喂食10次之后会产生一只僵尸

### 对战

- [x] 主动发起对战一方胜率为70%
- [x] 胜利计数，失败计数
- [x] 每天只能主动攻击1次

### 喂食

- [x] 每天只能喂食1次
- [x] 喂食计次
- [x] 喂食每满10次后会产生1只僵尸

### 交易

- [x] 可以把自己的僵尸放到市场定价并销售
- [x] 可以购买市场的僵尸
- [x] 税金为0.0001HT，可以修改
- [x] 最低售价0.0001HT，可以修改
- [x] 购买僵尸的钱除税金后交给原主人

### 升级

- [x] 主动发起对战并胜利可以升级一次
- [x] 可以付费升级
- [x] 升级费为0.0001HT，可以修改

### 查询

- [x] 查询发送者僵尸数量
- [x] 查询发送者僵尸数组
- [x] 查询单个僵尸数据
- [x] 根据地址查询僵尸
- [x] 查询商店的僵尸
- [x] 根据ID查询僵尸

### 杂项

- [x] 名称，标识
- [x] 空函数
- [x] 提款