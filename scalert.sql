CREATE DATABASE  IF NOT EXISTS `scalert` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `scalert`;
-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: rhapidfyre.com    Database: scalert
-- ------------------------------------------------------
-- Server version	5.5.64-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `accounts` (
  `idUser` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(80) DEFAULT NULL,
  `salt` varchar(80) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(255) NOT NULL,
  `rank` int(8) unsigned NOT NULL DEFAULT '1',
  `county` int(16) DEFAULT '0',
  `username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `userId_UNIQUE` (`idUser`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `archives`
--

DROP TABLE IF EXISTS `archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `archives` (
  `idIncident` int(32) unsigned NOT NULL AUTO_INCREMENT,
  `idLocation` int(32) unsigned NOT NULL,
  `idCreator` int(16) unsigned NOT NULL,
  `idBroadcast` int(16) NOT NULL DEFAULT '0' COMMENT 'Broadcastify Feed Number',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `details` text NOT NULL,
  `title` varchar(32) NOT NULL,
  `type` int(4) unsigned NOT NULL DEFAULT '1' COMMENT '1=Police 2=EMS 3=Fire 4=Multiagency',
  `alert_time` datetime DEFAULT NULL,
  `alert_message` varchar(155) DEFAULT NULL,
  `override` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Ignores votecount if true',
  `upvotes` int(32) NOT NULL DEFAULT '0',
  `downvotes` int(32) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idIncident`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `cities` (
  `idCity` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `idCounty` int(16) NOT NULL,
  `idState` int(16) NOT NULL,
  `zipcode` int(18) NOT NULL,
  `title` varchar(48) NOT NULL,
  PRIMARY KEY (`idCity`),
  UNIQUE KEY `zipcode` (`zipcode`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `comments` (
  `idComment` int(32) unsigned NOT NULL AUTO_INCREMENT,
  `idIncident` int(32) unsigned NOT NULL,
  `idParentComment` int(32) unsigned DEFAULT NULL,
  `idUser` int(16) unsigned NOT NULL,
  `commentText` varchar(255) NOT NULL,
  PRIMARY KEY (`idComment`),
  KEY `idUser` (`idUser`),
  KEY `idIncident` (`idIncident`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `accounts` (`idUser`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`idIncident`) REFERENCES `incidents` (`idIncident`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counties`
--

DROP TABLE IF EXISTS `counties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `counties` (
  `idCounty` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `idState` int(16) NOT NULL DEFAULT '1',
  `title` varchar(48) DEFAULT NULL,
  `idAdmin` int(16) unsigned NOT NULL COMMENT 'County Administrator',
  `broadcastify` int(32) unsigned NOT NULL COMMENT 'broadcastify ctid #',
  UNIQUE KEY `idCounty` (`idCounty`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incidents`
--

DROP TABLE IF EXISTS `incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `incidents` (
  `idIncident` int(32) unsigned NOT NULL AUTO_INCREMENT,
  `idLocation` int(32) unsigned NOT NULL,
  `idCreator` int(16) unsigned NOT NULL,
  `idBroadcast` int(16) NOT NULL DEFAULT '0' COMMENT 'Broadcastify Feed Number',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `details` text NOT NULL,
  `title` varchar(32) NOT NULL,
  `type` int(4) unsigned NOT NULL DEFAULT '1' COMMENT '1=Police 2=EMS 3=Fire 4=Multiagency',
  `alert_time` datetime DEFAULT NULL,
  `alert_message` varchar(155) DEFAULT NULL,
  `override` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Ignores votecount if true',
  `upvotes` int(32) NOT NULL DEFAULT '0',
  `downvotes` int(32) NOT NULL DEFAULT '0',
  `chp` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`idIncident`),
  UNIQUE KEY `idIncident` (`idIncident`)
) ENGINE=InnoDB AUTO_INCREMENT=110355 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `locations` (
  `idLocation` int(32) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto Incr',
  `longitude` varchar(16) DEFAULT NULL COMMENT 'Longitude',
  `latitude` varchar(16) DEFAULT NULL COMMENT 'Latitude',
  `title` varchar(32) DEFAULT NULL COMMENT 'Business Name/Landmark',
  `house_number` int(8) unsigned NOT NULL DEFAULT '1',
  `street` varchar(32) DEFAULT NULL,
  `xstreet` varchar(32) DEFAULT NULL,
  `zipcode` int(18) NOT NULL,
  `idState` int(16) unsigned NOT NULL DEFAULT '1',
  `idCounty` int(16) unsigned NOT NULL,
  `idCity` int(16) NOT NULL DEFAULT '1',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idLocation`),
  UNIQUE KEY `idLocation` (`idLocation`),
  UNIQUE KEY `idLocation_2` (`idLocation`,`longitude`,`latitude`)
) ENGINE=InnoDB AUTO_INCREMENT=39562 DEFAULT CHARSET=latin1 COMMENT='Locations stored for future retrieval';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_normal`
--

DROP TABLE IF EXISTS `log_normal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `log_normal` (
  `idLog` int(32) NOT NULL AUTO_INCREMENT COMMENT 'A_I',
  `idUser` int(16) unsigned NOT NULL COMMENT 'the user performing the action',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'timestamp of performed action',
  `method` varchar(32) NOT NULL DEFAULT 'update' COMMENT 'what action was performed',
  `idTable` varchar(24) NOT NULL COMMENT 'the table name affected',
  `idRow` int(16) NOT NULL COMMENT 'the id of the row affected',
  `notes` text COMMENT 'Notes about what happened, if any',
  PRIMARY KEY (`idLog`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `states` (
  `idState` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(48) NOT NULL,
  `short` varchar(2) DEFAULT NULL,
  `broadcastify` int(16) NOT NULL DEFAULT '0' COMMENT 'broadcastify stid #',
  UNIQUE KEY `idState` (`idState`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'scalert'
--

--
-- Dumping routines for database 'scalert'
--
/*!50003 DROP FUNCTION IF EXISTS `AddCHPLoc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `AddCHPLoc`(
  `longt` VARCHAR(16),
  `latt` VARCHAR(16),
  `tname` VARCHAR(32)
) RETURNS int(16) unsigned
BEGIN
	DECLARE idExist INT DEFAULT 0;

	# Check if idLocation exists already
	SELECT idLocation INTO idExist FROM locations
      WHERE longitude = longt
      AND latitude = latt
      ORDER BY updated DESC
      LIMIT 1;

	# If the location does not exist, create it
	IF idExist < 2 THEN
	  INSERT INTO locations (longitude, latitude, title)
	    VALUES (longt, latt, tname);
	  SET idExist = LAST_INSERT_ID();
    END IF;
    
    RETURN idExist;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetCity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCity`(
`st` INT(16) UNSIGNED,
`cnt` INT(16) UNSIGNED,
`cty` VARCHAR(48),
`postal` VARCHAR(5)
) RETURNS int(16) unsigned
BEGIN
	DECLARE rxCity INT(16) UNSIGNED;
    
    # Try locating by postal code first 
    SELECT idCity INTO rxCity FROM cities WHERE zipcode = postal;
    IF rxCity IS NULL THEN
    
		# if not found locate by city/state code
		SELECT idCity INTO rxCity FROM cities
			WHERE title LIKE CONCAT('%', cty, '%') AND idState = st AND idCounty = cnt;
		
		IF rxCity IS NULL THEN
			INSERT INTO cities (title, idState, idCounty, zipcode)
			VALUES (cty, st, cnt, postal);
			RETURN LAST_INSERT_ID();
		END IF;
        
	END IF;
	RETURN rxCity;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetCounty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCounty`(
`st` INT(16) UNSIGNED,
`cty` VARCHAR(48)
) RETURNS int(16) unsigned
BEGIN
	DECLARE rxCounty INT(16) UNSIGNED;
    SELECT idCounty INTO rxCounty FROM counties WHERE title LIKE CONCAT('%', cty, '%') AND idState = st;
    IF rxCounty IS NULL THEN
		INSERT INTO counties (title, idState) VALUES (cty, st);
        RETURN LAST_INSERT_ID();
    END IF;
	RETURN rxCounty;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetState`(
`st` VARCHAR(48)
) RETURNS int(16) unsigned
BEGIN
	DECLARE rxState INT(16) UNSIGNED;
    
    SELECT idState INTO rxState FROM states WHERE title LIKE CONCAT('%', st, '%');
    IF rxState IS NULL THEN
		INSERT INTO states (title) VALUES (st);
        RETURN LAST_INSERT_ID();
    END IF;
    
	RETURN rxState;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `InsertCHP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `InsertCHP`(
`loc` INT(32),
`deets` VARCHAR(32),
`ctype` INT(8),
`tname` VARCHAR(32),
`oride` TINYINT(1),
`numb` VARCHAR(32)
) RETURNS int(16) unsigned
BEGIN
	INSERT INTO incidents (idCreator, idLocation, details, type, title, override, chp)
      VALUES (2, loc, deets, ctype, tname, oride, numb);
    RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `NewIncident` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `NewIncident`(
  `loc` INT(32), # MUST be a valid idLocation
  `user` INT(16) UNSIGNED, # The incident creator
  `deets` VARCHAR(32),
  `ctype` INT(8),
  `tname` VARCHAR(32)
) RETURNS int(16) unsigned
BEGIN
	DECLARE idLoc INT(16) UNSIGNED;
    IF loc < 1 THEN SET idLoc = 1; END IF;
    
	INSERT INTO incidents (idLocation, details, type, title)
      VALUES (loc, deets, ctype, tname);
      
    RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `NewLocation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `NewLocation`(
  `house` INT(16),
  `streetn` VARCHAR(32),
  `ptitle` VARCHAR(64),
  `postal` VARCHAR(32),
  `cityn` VARCHAR(32),
  `staten` VARCHAR(32),
  `countyn` VARCHAR(32),
  `nation` VARCHAR(16),
  `longt` VARCHAR(32),
  `latt` VARCHAR(32)
) RETURNS int(16) unsigned
BEGIN

	DECLARE rxCity    INT(16) UNSIGNED;
	DECLARE rxState   INT(16) UNSIGNED;
	DECLARE rxCounty  INT(16) UNSIGNED;
    
    # Select state, or create the entry, then return idState to rxState
    SELECT GetState(staten) INTO rxState;
    
    # Select county, or create the entry, then return idCounty to rxCounty
    SELECT GetCounty(rxState, countyn) INTO rxCounty;
    
    # Select city, or create the entry, then return idCity to rxCity
    SELECT GetCity(rxState, rxCounty, cityn, postal) INTO rxCity;
    
    INSERT INTO locations
    (longitude, latitude, title, house_number, street, zipcode, idState, idCounty, idCity)
    VALUES
    (longt, latt, ptitle, house, streetn, postal, rxState, rxCounty, rxCity);
    
	RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateReport`(
  `idLoc` INT(16),
  `callname` VARCHAR(32),
  `agency` VARCHAR(64),
  `reprt` VARCHAR(32),
  `deets` VARCHAR(32)
)
BEGIN
    
  INSERT INTO incidents
  (idLocation, idCreator, type, title, details)
  VALUES
  (idLoc, reprt, agency, callname, deets);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DoArchive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`scenealert`@`%` PROCEDURE `DoArchive`()
    NO SQL
    COMMENT 'When called, archives any calls older than 365 days'
BEGIN

	DECLARE done INT DEFAULT FALSE;
    DECLARE n INT;
    DECLARE dtime DATETIME; 
    DECLARE lastYear DATETIME;
	DECLARE cursor1 CURSOR FOR SELECT idIncident,created FROM incidents;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SET lastYear = DATE_SUB(NOW(), INTERVAL 1 YEAR);

	SELECT CONCAT('Last Years Date: ', lastYear);

	OPEN cursor1;
    
    archive_loop: LOOP
    	
        FETCH cursor1 INTO n,dtime;
		
        IF done THEN LEAVE archive_loop;
        END IF;
        
        /* If date of this incident is last year or longer, archive */
        IF dtime <= lastYear THEN
			SELECT CONCAT('Incident #', n, ' is old and being archived!');
        	INSERT INTO archives SELECT * FROM incidents WHERE idIncident = n;
        ELSE
        	SELECT CONCAT('Incident #', n, ' is current.');
        END IF;
        
        
    END LOOP;
    
	CLOSE cursor1;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-16 13:06:16
