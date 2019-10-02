-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 01, 2019 at 06:02 PM
-- Server version: 5.5.64-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `scalert`
--

DELIMITER $$
--
-- Procedures
--
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
    
END$$

--
-- Functions
--
CREATE DEFINER=`scenealert`@`%` FUNCTION `AddIncident`() RETURNS int(16) unsigned
    NO SQL
    COMMENT 'Checks if it''s the new year before adding the call.'
BEGIN

   /*
    *  This procedure is ensuring the new call isn't of the new year.
    *  If it is, it will archive all inactive incidents, and reset
    *  the auto increment on the incidents table.
    */
    
    
   /*
    *  Ensures the new incident's number doesn't match an existing call.
    *  If it finds the idIncident exists, it will set that row to inactive,
    *  archive it and add this row, to ensure idIncident is unique
    */

	# Returns idIncident of the new row
	RETURN 0;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `archives`
--

CREATE TABLE IF NOT EXISTS `archives` (
  `idIncident` int(32) unsigned NOT NULL,
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
  `downvotes` int(32) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE IF NOT EXISTS `cities` (
  `idCounty` int(16) NOT NULL,
  `idState` int(16) NOT NULL,
  `zipcode` int(18) unsigned NOT NULL,
  `name` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`idCounty`, `idState`, `zipcode`, `name`) VALUES
(1, 1, 1, 'No City Given');

-- --------------------------------------------------------

--
-- Table structure for table `counties`
--

CREATE TABLE IF NOT EXISTS `counties` (
  `idCounty` int(16) unsigned NOT NULL,
  `idState` int(16) NOT NULL DEFAULT '1',
  `idAdmin` int(16) unsigned NOT NULL COMMENT 'County Administrator',
  `broadcastify` int(32) unsigned NOT NULL COMMENT 'broadcastify ctid #'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `counties`
--

INSERT INTO `counties` (`idCounty`, `idState`, `idAdmin`, `broadcastify`) VALUES
(1, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `incidents`
--

CREATE TABLE IF NOT EXISTS `incidents` (
  `idIncident` int(32) unsigned NOT NULL,
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
  `downvotes` int(32) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `incidents`
--

INSERT INTO `incidents` (`idIncident`, `idLocation`, `idCreator`, `idBroadcast`, `created`, `active`, `details`, `title`, `type`, `alert_time`, `alert_message`, `override`, `upvotes`, `downvotes`) VALUES
(1, 1, 1, 0, '2018-09-30 17:58:21', 1, 'Test Incident Only', 'Test Incident', 1, NULL, NULL, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE IF NOT EXISTS `locations` (
  `idLocation` int(32) unsigned NOT NULL COMMENT 'Auto Incr',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Longitude',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Latitude',
  `title` varchar(32) DEFAULT NULL COMMENT 'Business Name/Landmark',
  `house_number` int(8) unsigned NOT NULL DEFAULT '1',
  `street` varchar(32) DEFAULT NULL,
  `xstreet` varchar(32) DEFAULT NULL,
  `zipcode` int(18) NOT NULL,
  `idState` int(16) unsigned NOT NULL DEFAULT '1',
  `idCounty` int(16) unsigned NOT NULL,
  `idCity` int(16) NOT NULL DEFAULT '1',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Locations stored for future retrieval';

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`idLocation`, `longitude`, `latitude`, `title`, `house_number`, `street`, `xstreet`, `zipcode`, `idState`, `idCounty`, `idCity`, `updated`) VALUES
(1, NULL, NULL, NULL, 1, 'No Street Given', NULL, 0, 1, 0, 1, '2019-09-25 23:16:10');

-- --------------------------------------------------------

--
-- Table structure for table `log_normal`
--

CREATE TABLE IF NOT EXISTS `log_normal` (
  `idLog` int(32) NOT NULL COMMENT 'A_I',
  `idUser` int(16) unsigned NOT NULL COMMENT 'the user performing the action',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'timestamp of performed action',
  `method` varchar(32) NOT NULL DEFAULT 'update' COMMENT 'what action was performed',
  `idTable` varchar(24) NOT NULL COMMENT 'the table name affected',
  `idRow` int(16) NOT NULL COMMENT 'the id of the row affected',
  `notes` text COMMENT 'Notes about what happened, if any'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE IF NOT EXISTS `states` (
  `idState` int(16) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `broadcastify` int(16) NOT NULL DEFAULT '0' COMMENT 'broadcastify stid #'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`idState`, `name`, `broadcastify`) VALUES
(1, 'Alabama', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `archives`
--
ALTER TABLE `archives`
  ADD PRIMARY KEY (`idIncident`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`zipcode`),
  ADD UNIQUE KEY `zipcode` (`zipcode`);

--
-- Indexes for table `counties`
--
ALTER TABLE `counties`
  ADD UNIQUE KEY `idCounty` (`idCounty`);

--
-- Indexes for table `incidents`
--
ALTER TABLE `incidents`
  ADD PRIMARY KEY (`idIncident`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`idLocation`);

--
-- Indexes for table `log_normal`
--
ALTER TABLE `log_normal`
  ADD PRIMARY KEY (`idLog`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD UNIQUE KEY `idState` (`idState`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `archives`
--
ALTER TABLE `archives`
  MODIFY `idIncident` int(32) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `zipcode` int(18) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `counties`
--
ALTER TABLE `counties`
  MODIFY `idCounty` int(16) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `incidents`
--
ALTER TABLE `incidents`
  MODIFY `idIncident` int(32) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `idLocation` int(32) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto Incr',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `log_normal`
--
ALTER TABLE `log_normal`
  MODIFY `idLog` int(32) NOT NULL AUTO_INCREMENT COMMENT 'A_I';
--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `idState` int(16) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
