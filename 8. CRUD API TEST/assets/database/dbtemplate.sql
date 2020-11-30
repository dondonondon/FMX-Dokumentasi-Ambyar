/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 100316
 Source Host           : localhost:3306
 Source Schema         : dbtemplate

 Target Server Type    : MySQL
 Target Server Version : 100316
 File Encoding         : 65001

 Date: 29/04/2020 16:36:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for siswa
-- ----------------------------
DROP TABLE IF EXISTS `siswa`;
CREATE TABLE `siswa`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nm` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `kelas` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `alamat` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of siswa
-- ----------------------------
INSERT INTO `siswa` VALUES (5, 'zxcasd', 'azxc', 'asdasd');
INSERT INTO `siswa` VALUES (7, 'zxcasd', 'azxc', 'asdasd');
INSERT INTO `siswa` VALUES (8, 'zxcasd', 'azxc', 'asdasd');
INSERT INTO `siswa` VALUES (9, 'zxcasd', 'azxc', 'asdasd');
INSERT INTO `siswa` VALUES (10, 'zxcasd', 'azxc', 'asdasd');

SET FOREIGN_KEY_CHECKS = 1;
