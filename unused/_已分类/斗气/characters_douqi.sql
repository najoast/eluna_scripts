/*
Navicat MySQL Data Transfer

Source Server         : dingzhi
Source Server Version : 50509
Source Host           : localhost:3306
Source Database       : characters

Target Server Type    : MYSQL
Target Server Version : 50509
File Encoding         : 65001

Date: 2018-05-25 00:49:48
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `characters_douqi`
-- ----------------------------
DROP TABLE IF EXISTS `characters_douqi`;
CREATE TABLE `characters_douqi` (
  `guid` int(10) NOT NULL,
  `douqizhi` int(30) NOT NULL DEFAULT '0',
  `liliang` int(30) NOT NULL,
  `minjie` int(30) NOT NULL,
  `naili` int(30) NOT NULL,
  `zhili` int(30) NOT NULL,
  `jingshen` int(30) NOT NULL,
  `gongqiang` int(30) NOT NULL,
  `faqiang` int(30) NOT NULL,
  `jisu` int(30) NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characters_douqi
-- ----------------------------
