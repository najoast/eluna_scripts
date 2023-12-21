SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `item_recovery`
-- ----------------------------
DROP TABLE IF EXISTS `item_recovery`;
CREATE TABLE `item_recovery` (
  `id` int(10) NOT NULL,
  `shuliang` tinyint(4) NOT NULL,
  `jiage` tinyint(4) NOT NULL,
  `huobi` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of item_recovery
-- ----------------------------
INSERT INTO `item_recovery` VALUES ('23456', '1', '100', '49426');
INSERT INTO `item_recovery` VALUES ('34567', '1', '5', '49426');