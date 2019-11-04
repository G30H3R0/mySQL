-- MySQL dump 10.13  Distrib 8.0.15, for macos10.14 (x86_64)
--
-- Host: localhost    Database: FrayedFable
-- ------------------------------------------------------
-- Server version	8.0.15

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
-- Table structure for table `EntityAttribute`
--

DROP TABLE IF EXISTS `EntityAttribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `EntityAttribute` (
  `EntityAttributeID` int(11) NOT NULL AUTO_INCREMENT,
  `EntityAttributeTypeID` int(11) NOT NULL,
  `KeyID` int(11) NOT NULL,
  `AttributeValue` varchar(50) NOT NULL,
  `ModifDate` datetime NOT NULL,
  `CreatedDate` datetime NOT NULL,
  `KeyTypeID` int(11) NOT NULL,
  PRIMARY KEY (`EntityAttributeID`),
  KEY `EntityAttributeTypeID` (`EntityAttributeTypeID`),
  KEY `EntityAttribute_ibfk_1` (`KeyID`),
  CONSTRAINT `EntityAttribute_ibfk_1` FOREIGN KEY (`KeyID`) REFERENCES `Entities` (`EntityID`),
  CONSTRAINT `EntityAttribute_ibfk_2` FOREIGN KEY (`EntityAttributeTypeID`) REFERENCES `EntityAttributeType` (`EntityAttributeTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EntityAttribute`
--

LOCK TABLES `EntityAttribute` WRITE;
/*!40000 ALTER TABLE `EntityAttribute` DISABLE KEYS */;
INSERT INTO `EntityAttribute` VALUES (2,1,1,'8','2019-07-24 06:49:08','2019-07-24 06:49:08',1),(3,1,2,'3','2019-07-24 06:49:30','2019-07-24 06:49:30',1),(4,2,1,'5','2019-10-14 05:24:49','2019-07-24 06:51:13',1),(5,2,2,'258','2019-10-14 05:24:49','2019-07-24 06:51:13',1);
/*!40000 ALTER TABLE `EntityAttribute` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-03 21:57:36
