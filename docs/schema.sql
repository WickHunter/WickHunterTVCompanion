CREATE DATABASE IF NOT EXISTS wick_hunter;
USE wick_hunter;

SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) UNSIGNED NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entry_type` (
  `Name` varchar(15) NOT NULL PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT IGNORE INTO `entry_type` (`Name`) VALUES
('limit'),
('market');

CREATE TABLE IF NOT EXISTS `base_size_type` (
  `Name` varchar(15) NOT NULL PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT IGNORE INTO `base_size_type` (`Name`) VALUES
('percent'),
('usd');

CREATE TABLE IF NOT EXISTS `exchange` (
  `Name` varchar(255) NOT NULL PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT IGNORE INTO `exchange` (`Name`) VALUES
('binance'),
('bybit');

CREATE TABLE IF NOT EXISTS `order_type` (
  `Name` varchar(31) NOT NULL PRIMARY KEY,
  `Conditional` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT IGNORE INTO `order_type` (`Name`, `Conditional`) VALUES
('Limit', 0),
('Market', 0),
('Stoploss', 1),
('StoplossLimit', 1),
('TakeProfit', 1),
('TakeProfitLimit', 1);

CREATE TABLE IF NOT EXISTS `account` (
  `Username` varchar(255) NOT NULL PRIMARY KEY,
  `Password` varchar(255) NOT NULL,
  `Identifier` varchar(255) NOT NULL UNIQUE,
  `MemberSince` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IP` varchar(31) DEFAULT NULL,
  `DiscordWebhookURL` varchar(255) DEFAULT NULL,
  `Enabled` tinyint(1) DEFAULT 1,
  `Admin` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `api_key_set` (
  `ID` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Exchange` varchar(255) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Key` varchar(255) NOT NULL,
  `Secret` varchar(255) NOT NULL,
  FOREIGN KEY(Exchange) REFERENCES exchange(Name) ON UPDATE CASCADE,
  FOREIGN KEY(Username) REFERENCES account(Username) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `configuration` (
  `ID` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Enabled` tinyint(1) DEFAULT 1,
  `Exchange` varchar(255) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Symbol` varchar(31) NOT NULL,
  `Side` varchar(31) NOT NULL,
  `BaseSize` decimal(13,8) NOT NULL,
  `BaseSizeType` varchar(15) NOT NULL,
  `SafetyBaseSize` decimal(13,8) NOT NULL,
  `SafetyBaseSizeType` varchar(15) NOT NULL,
  `EntryType` varchar(15) NOT NULL,
  `Leverage` varchar(31) NOT NULL,
  `CrossLeverage` tinyint(1) NOT NULL,
  `UseTakeProfit` tinyint(1) DEFAULT '0',
  `TakeProfitDistance` decimal(5,2) DEFAULT NULL,
  `UseStoploss` tinyint(1) DEFAULT '0',
  `StoplossDistance` decimal(5,2) DEFAULT NULL,
  `TakeProfitTrailing` tinyint(1) DEFAULT '0',
  `TakeProfitTrail` decimal(4,2) NOT NULL,
  `UseDCA` tinyint(1) DEFAULT '0',
  `ManualDCA` tinyint(1) DEFAULT '0',
  `DCACount` int(2) DEFAULT NULL,
  `DCADeviation` decimal(5,2) DEFAULT NULL,
  `DCAVolumeScale` decimal(4,2) DEFAULT NULL,
  `DCAStepScale` decimal(4,2) DEFAULT NULL,
  FOREIGN KEY(Exchange) REFERENCES exchange(Name) ON UPDATE CASCADE,
  FOREIGN KEY(Username) REFERENCES account(Username) ON UPDATE CASCADE,
  FOREIGN KEY(EntryType) REFERENCES entry_type(Name) ON UPDATE CASCADE,
  FOREIGN KEY(BaseSizeType) REFERENCES base_size_type(Name) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `manual_dca` (
  `ID` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Configuration` int(11) NOT NULL,
  `Size` decimal(13, 8) NOT NULL,
  `Price` decimal(13, 8) NOT NULL,
  `Number` int(11) NULL,
  FOREIGN KEY(Configuration) REFERENCES configuration(ID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `max_positions` (
  `Exchange` varchar(255) NOT NULL,
  `Number` int(5) NOT NULL,
  FOREIGN KEY(Exchange) REFERENCES exchange(Name) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `tradingViewSignal` (
  `ID` bigint(15) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Time` timestamp DEFAULT CURRENT_TIMESTAMP,
  `Exchange` varchar(255) NOT NULL,
  `Side` varchar(31) NOT NULL,
  `Symbol` varchar(31) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `trade` (
  `ID` bigint(15) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `OrderType` varchar(31) NOT NULL,
  `OrderID` varchar(127) NOT NULL UNIQUE,
  `Symbol` varchar(31) NOT NULL,
  `Side` varchar(15) NOT NULL,
  `Price` decimal(13,8) DEFAULT NULL,
  `OrderStatus` varchar(31) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ClosedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Quantity` decimal(13,8) DEFAULT NULL,
  FOREIGN KEY(Username) REFERENCES account(Username) ON UPDATE CASCADE,
  FOREIGN KEY(OrderType) REFERENCES order_type(Name) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
