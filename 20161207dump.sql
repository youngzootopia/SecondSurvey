CREATE DATABASE  IF NOT EXISTS `secondSurvey` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `secondSurvey`;
-- MySQL dump 10.13  Distrib 5.7.12, for Win32 (AMD64)
--
-- Host: 211.253.29.113    Database: secondSurvey
-- ------------------------------------------------------
-- Server version	5.5.52-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clists`
--

DROP TABLE IF EXISTS `clists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clists` (
  `CID` int(11) NOT NULL DEFAULT '0',
  `Category` varchar(255) DEFAULT NULL,
  `ProgramName` varchar(255) DEFAULT NULL,
  `EpisodeNum` int(11) DEFAULT NULL,
  `VideoURL` varchar(255) DEFAULT NULL,
  `VideoFileName` varchar(255) DEFAULT NULL,
  `VideoThumb` varchar(255) DEFAULT NULL,
  `FPS` float DEFAULT NULL,
  `RegisterDateTime` datetime DEFAULT NULL,
  `LastSavedDateTime` datetime DEFAULT NULL,
  `TagStatus` int(11) DEFAULT NULL,
  `User` varchar(255) DEFAULT NULL,
  `ProgramNameKor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filterings`
--

DROP TABLE IF EXISTS `filterings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filterings` (
  `sUserID` varchar(255) NOT NULL DEFAULT '',
  `serviceProvider` varchar(255) DEFAULT NULL,
  `degree` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sUserID`),
  CONSTRAINT `fk_sUserID_from_users` FOREIGN KEY (`sUserID`) REFERENCES `users` (`sUserID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shot_infos`
--

DROP TABLE IF EXISTS `shot_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shot_infos` (
  `ShotID` int(11) NOT NULL DEFAULT '0',
  `ShotNum` int(11) DEFAULT NULL,
  `StartFrame` int(11) DEFAULT NULL,
  `EndFrame` int(11) DEFAULT NULL,
  `ThumbURL` varchar(255) DEFAULT NULL,
  `CID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ShotID`),
  KEY `fk_CID_from_clist` (`CID`),
  CONSTRAINT `fk_CID_from_clist` FOREIGN KEY (`CID`) REFERENCES `clists` (`CID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `sUserID` varchar(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `password_digest` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `married` varchar(2) DEFAULT NULL,
  `children` varchar(2) DEFAULT NULL,
  `job` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `hobby` varchar(100) DEFAULT NULL,
  `currentShot` int(11) DEFAULT NULL,
  `group` int(11) DEFAULT NULL,
  PRIMARY KEY (`sUserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'secondSurvey'
--

--
-- Dumping routines for database 'secondSurvey'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-07 11:06:11
