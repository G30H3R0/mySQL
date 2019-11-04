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
-- Dumping routines for database 'FrayedFable'
--
/*!50003 DROP PROCEDURE IF EXISTS `CoordinateCRUD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CoordinateCRUD`(
IN $CoordinateID int
, IN $long decimal (9,6)
, IN $lat decimal (9,6) 
, IN $EntityID int
, IN $CRUD varchar(1)
)
BEGIN
	IF $CRUD = 'C' AND $Long IS NOT NULL AND $Lat IS NOT NULL AND $EntityID IS NOT NULL THEN
	BEGIN
		INSERT INTO Coordinates (Longitude, Latitude, EntityID, ModifDate, CreatedDate)
        VALUES ($long, $lat, $EntityID, NOW(), NOW());
        SELECT 'Created' as CRUD;
	END;
	ELSEIF $CRUD = 'R' THEN
	BEGIN
		SELECT c.CoordinateID, c.Longitude, c.Latitude, e.EntityID, e.EntityName, et.EntityTypeName, ea.AttributeValue, eat.Name, eat.Description, 'READ' as CRUD
		FROM Coordinates c
		JOIN Entities e ON c.EntityID = e.EntityID
		JOIN EntityTypes et ON e.EntityTypeID = et.EntityTypeID
		LEFT JOIN EntityAttribute ea ON ea.KeyID = c.CoordinateID
		LEFT JOIN EntityAttributeType eat ON ea.EntityAttributeTypeID = eat.EntityAttributeTypeID
        WHERE (c.CoordinateID = $CoordinateID OR $CoordinateID IS NULL)
        AND (c.Longitude = $long OR $long IS NULL)
        AND (c.Latitude = $lat OR $lat IS NULL)
        AND (c.EntityID = $EntityID OR $EntityID IS NULL)
		ORDER BY et.EntityTypeID, e.EntityID, eat.EntityAttributeTypeID, ea.EntityAttributeID;
    END;
    ELSEIF $CRUD = 'U' AND $CoordinateID IS NOT NULL AND $Long IS NOT NULL AND $Lat IS NOT NULL AND $EntityID IS NOT NULL THEN
	BEGIN
		UPDATE Coordinates 
        SET Longitude = $long, Latitude = $lat, EntityID = $EntityID, ModifDate = NOW()
        WHERE CoordinateID = $CoordinateID;
        SELECT 'Updated' as CRUD;
    END;
    ELSEIF $CRUD = 'D' AND $CoordinateID IS NOT NULL THEN 
    BEGIN
		DELETE FROM Coordinates WHERE CoordinateID = $CoordinateID;
        SELECT 'Deleted' as CRUD;
    END;
    ELSE 
    BEGIN
		SELECT 'Implicit CRUD' as CRUD;
    END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Coordinates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Coordinates`(
	IN Latitude DECIMAL,
	IN Longitude DECIMAL
 )
BEGIN
 SELECT et.EntityTypeName, e.EntityName, c.Latitude, c.Longitude
 FROM Coordinates c
 JOIN Entity e ON c.EntityID = e.EntityID
 JOIN EntityType et ON e.EntityTypeID = et.EntityTypeID
 JOIN Settings s ON 1 = 1 #Coordinate Radius
 WHERE (c.Latitude BETWEEN Latitude + s.Value AND Latitude - s.Value)
 AND (c.Longitude BETWEEN Longitude + s.Value AND Longitude - s.Value);
 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CoordinatesGetCloseEntities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CoordinatesGetCloseEntities`(
	IN Lon decimal(9,6),
	IN Lat decimal(9,6)
 )
BEGIN
 SELECT c.CoordinateID, e.EntityID, et.EntityTypeName, e.EntityName, c.Latitude, c.Longitude, ea.AttributeValue, eat.Name, eat.Description
 FROM Coordinates c
 JOIN Entities e ON c.EntityID = e.EntityID
 JOIN EntityTypes et ON e.EntityTypeID = et.EntityTypeID
 JOIN Settings s ON s.Description = 'Coordinate Radius for GET nearby entities'
 LEFT JOIN EntityAttribute ea ON ea.KeyID = c.CoordinateID
 LEFT JOIN EntityAttributeType eat ON ea.EntityAttributeTypeID = eat.EntityAttributeTypeID
WHERE (Lon <= (c.Longitude + CAST(s.Value as DECIMAL(9,6))) #Below top
	AND (Lon >= (c.Longitude - CAST(s.Value as DECIMAL(9,6))))) #Above Bottom
AND (Lat <= (c.Latitude + CAST(s.Value as DECIMAL(9,6))) #To the left of
	AND (Lat >= (c.Latitude - CAST(s.Value as DECIMAL(9,6))))); #To the right of
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CoordinatesUpdMovingEntities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CoordinatesUpdMovingEntities`()
BEGIN
 

 #Create New table for tracking info. Drop it first if it exists.
DROP TABLE IF EXISTS NewCoord;

#Moving Monsters
 CREATE TABLE NewCoord AS
 SELECT c.CoordinateID, e.EntityID, e.EntityName,  c.Longitude as 'CurrentLong', c.Latitude as 'CurrentLat', eaDirection.AttributeValue as 'Direction', eaDistance.AttributeValue as 'Distance'
 , c.Longitude + ((1 / (50 / eaDistance.AttributeValue)) * sin(eaDirection.AttributeValue)) as 'NewLong'
 , c.Latitude + ((1 / (50 / eaDistance.AttributeValue)) * cos(eaDirection.AttributeValue)) as 'NewLat'
FROM Coordinates c 
JOIN Entities e ON c.EntityID = e.EntityID
JOIN EntityTypes et ON e.EntityTypeID = e.EntityTypeID
JOIN EntityAttribute eaDirection ON eaDirection.KeyID = c.CoordinateID
JOIN EntityAttribute eaDistance ON  eaDistance.KeyID = c.CoordinateID
JOIN EntityAttributeType eatDirection ON eatDirection.Name = 'Direction' AND eaDirection.EntityAttributeTypeID = eatDirection.EntityAttributeTypeID
JOIN EntityAttributeType eatDistance ON eatDistance.Name = 'Distance' AND eaDistance.EntityAttributeTypeID = eatDistance.EntityAttributeTypeID
WHERE et.EntityTypeName = 'Monsters'
 AND (((c.Longitude + ((1 / (50 / eaDistance.AttributeValue)) * sin(eaDirection.AttributeValue))) < 50) AND ((c.Longitude + ((1 / (50 / eaDistance.AttributeValue)) * sin(eaDirection.AttributeValue))) > 26))
 AND (((c.Latitude + ((1 / (50 / eaDistance.AttributeValue)) * cos(eaDirection.AttributeValue))) > -125) AND ((c.Latitude + ((1 / (50 / eaDistance.AttributeValue)) * cos(eaDirection.AttributeValue))) < -67));

#Changing Direction
INSERT INTO NewCoord
 SELECT c.CoordinateID
, e.EntityID
 , e.EntityName
 ,  c.Longitude as 'CurrentLong'
 , c.Latitude as 'CurrentLat'
 ,  FLOOR(RAND()*(360-1+1))+1 as 'Direction'
 , eaDistance.AttributeValue as 'Distance'
 , c.Longitude as 'NewLong'
 , c.Latitude as 'NewLat'
FROM Coordinates c 
LEFT JOIN NewCoord nc ON c.CoordinateID = nc.CoordinateID
JOIN Entities e ON c.EntityID = e.EntityID
JOIN EntityTypes et ON e.EntityTypeID = e.EntityTypeID
JOIN EntityAttribute eaDirection ON eaDirection.KeyID = c.CoordinateID
JOIN EntityAttribute eaDistance ON  eaDistance.KeyID = c.CoordinateID
JOIN EntityAttributeType eatDirection ON eatDirection.Name = 'Direction' AND eaDirection.EntityAttributeTypeID = eatDirection.EntityAttributeTypeID
JOIN EntityAttributeType eatDistance ON eatDistance.Name = 'Distance' AND eaDistance.EntityAttributeTypeID = eatDistance.EntityAttributeTypeID
WHERE nc.CoordinateID IS NULL; 
 
UPDATE Coordinates c
JOIN NewCoord nc ON c.CoordinateID = nc.CoordinateID
SET c.Longitude = nc.NewLong, c.Latitude = nc.NewLat, c.ModifDate = NOW();

UPDATE EntityAttribute ea
JOIN NewCoord nc ON ea.EntityAttributeTypeID = 2 AND ea.KeyID = nc.CoordinateID
SET ea.AttributeValue = nc.Direction, ea.ModifDate = NOW();

INSERT INTO WanderingLogging (CoordinateID, EntityID, CurrentLong, CurrentLat, Direction, Distance, NewLong, NewLat, ModifDate, CreatedDate)
SELECT DISTINCT CoordinateID, EntityID, CurrentLong, CurrentLat, Direction, Distance, NewLong, NewLat, NOW(), NOW()
FROM NewCoord;

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EntityAttributeCRUD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EntityAttributeCRUD`(
IN $EntityAttributeID int
, IN $EntityAttributeTypeID int
, IN $KeyTypeID int
, IN $KeyID int
, IN $AttributeValue varchar(50)
, IN $CRUD varchar(1)
)
BEGIN
	IF $CRUD = 'C' AND $EntityAttributeTypeID IS NOT NULL AND $Key IS NOT NULL AND $AttributeValue IS NOT NULL
    THEN
	BEGIN
		INSERT INTO EntityAttribute (EntityAttributeTypeID, KeyID, AttributeValue, ModifDate, CreatedDate)
        VALUES ($EntityAttributeTypeID, $KeyID, $AttributeValue, NOW(), NOW());
        
        SELECT 'Created';
	END;
	ELSEIF $CRUD = 'R' 
    THEN
	BEGIN
		SELECT e.EntityName, et.EntityTypeName, ea.AttributeValue, eat.Name, eat.Description, 'READ' as CRUD
		FROM Entities e
		JOIN EntityTypes et ON e.EntityTypeID = et.EntityTypeID
        LEFT JOIN Coordinates c ON e.EntityID = c.EntityID
		LEFT JOIN EntityAttribute ea ON ea.KeyID = c.CoordinateID
		LEFT JOIN EntityAttributeType eat ON ea.EntityAttributeTypeID = eat.EntityAttributeTypeID
        WHERE EntityAttributeID IS NOT NULL
        AND (ea.EntityAttributeID = $EntityAttributeID OR $EntityAttributeID IS NULL)
        AND (eat.EntityAttributeTypeID = $EntityAttributeTypeID OR $EntityAttributeTypeID IS NULL)
        AND (ea.KeyID = $KeyID OR $KeyID IS NULL)
        AND (ea.AttributeValue = $AttributeValue OR $AttributeValue IS NULL)
		ORDER BY et.EntityTypeID, e.EntityID, eat.EntityAttributeTypeID, ea.EntityAttributeID;
    END;
    ELSEIF $CRUD = 'U' AND $EntityAttributeTypeID IS NOT NULL AND $KeyID IS NOT NULL AND $AttributeValue IS NOT NULL AND $KeyTypeID IS NOT NULL
    THEN
	BEGIN
		UPDATE EntityAttribute 
        SET EntityAttributeTypeID = $EntityAttributeTypeID, KeyTypeID = $KeyTypeID, KeyID = $KeyID, AttributeValue = $AttributeValue, ModifDate = NOW()
        WHERE EntityAttributeID = $EntityAttributeID;
        
        SELECT 'Updated' as CRUD;
    END;
    ELSEIF $CRUD = 'D' AND $EntityAttributeID IS NOT NULL 
    THEN 
    BEGIN
		DELETE FROM EntityAttribute WHERE EntityAttributeID = $EntityAttributeID;
        
        SELECT 'Deleted' as CRUD;
    END;
    ELSE 
    BEGIN
		SELECT 'Implicit CRUD' as CRUD;
    END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EntityAttributeTypeCRUD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EntityAttributeTypeCRUD`(
 IN $EntityAttributeTypeID int
, IN $Name varchar(50)
, IN $Description varchar(50)
, IN $CRUD varchar(1)
)
BEGIN
	IF $CRUD = 'C' AND $Name IS NOT NULL AND $Description IS NOT NULL
    THEN
	BEGIN
		INSERT INTO EntityAttributeType (Name, Description, ModifDate, CreatedDate)
        VALUES ($Name, $Description, NOW(), NOW());
        
        SELECT 'Create';
	END;
	ELSEIF $CRUD = 'R' 
    THEN
	BEGIN
		SELECT Name, Description
        FROM EntityAttributeType
		ORDER BY Name, Description;
    END;
    ELSEIF $CRUD = 'U' AND $EntityAttributeTypeID IS NOT NULL AND $Name IS NOT NULL AND $Description IS NOT NULL 
    THEN
	BEGIN
		UPDATE EntityAttributeType 
        SET Name = $Name, Description = $Description, ModifDate = NOW()
        WHERE EntityAttributeTypeID = $EntityAttributeTypeID;
        
        SELECT 'Updated' as CRUD;
    END;
    ELSEIF $CRUD = 'D' AND $EntityAttributeTypeID IS NOT NULL 
    THEN 
    BEGIN
		DELETE FROM EntityAttributeType WHERE EntityAttributeTypeID = $EntityAttributeTypeID;
        
        SELECT 'Deleted' as CRUD;
    END;
    ELSE 
    BEGIN
		SELECT 'Implicit CRUD' as CRUD;
    END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EntityCRUD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EntityCRUD`(
IN $EntityID int
, IN $EntityName varchar(50)
, IN $EntityTypeID int
, IN $CRUD varchar(1)
)
BEGIN
	IF $CRUD = 'C' AND $EntityTypeID IS NOT NULL AND $EntityName IS NOT NULL 
    THEN
	BEGIN
		INSERT INTO Entities (EntityName, EntityTypeID, ModifDate, CreatedDate)
        VALUES ($EntityName, $EntityTypeID, NOW(), NOW());
        
        SELECT 'Create';
	END;
	ELSEIF $CRUD = 'R' 
    THEN
	BEGIN
		SELECT e.EntityID, e.EntityName, et.EntityTypeName, ea.AttributeValue, eat.Name, eat.Description, 'READ' as CRUD
		FROM Entities e
		JOIN EntityTypes et ON e.EntityTypeID = et.EntityTypeID
        LEFT JOIN Coordinates c ON e.EntityID = c.EntityID
		LEFT JOIN EntityAttribute ea ON ea.KeyID = c.CoordinateID
		LEFT JOIN EntityAttributeType eat ON ea.EntityAttributeTypeID = eat.EntityAttributeTypeID
        WHERE (e.EntityID = $EntityID OR $EntityID IS NULL)
        AND (e.EntityName = $EntityName OR $EntityName IS NULL)
        AND (et.EntityTypeID = $EntityTypeID OR $EntityTypeID IS NULL)
		ORDER BY et.EntityTypeID, e.EntityID, eat.EntityAttributeTypeID, ea.EntityAttributeID;
    END;
    ELSEIF $CRUD = 'U' AND $EntityID IS NOT NULL AND $EntityName IS NOT NULL AND $EntityTypeID IS NOT NULL 
    THEN
	BEGIN
		UPDATE Entities 
        SET EntityName = $EntityName, EntityTypeID = $EntityTypeID, ModifDate = NOW()
        WHERE EntityID = $EntityID;
        
        SELECT 'Updated' as CRUD;
    END;
    ELSEIF $CRUD = 'D' AND $EntityID IS NOT NULL 
    THEN 
    BEGIN
		DELETE FROM Entities WHERE EntityID = $EntityID;
        
        SELECT 'Deleted' as CRUD;
    END;
    ELSE 
    BEGIN
		SELECT 'Implicit CRUD' as CRUD;
    END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EntityTypeCRUD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EntityTypeCRUD`(
 IN $EntityTypeID int
, IN $EntityTypeName varchar(50)
, IN $CRUD varchar(1)
)
BEGIN
	IF $CRUD = 'C' AND $EntityTypeName IS NOT NULL 
    THEN
	BEGIN
		INSERT INTO EntityTypes (EntityTypeName, ModifDate, CreatedDate)
        VALUES ($EntityTypeName, NOW(), NOW());
        
        SELECT 'Create';
	END;
	ELSEIF $CRUD = 'R' 
    THEN
	BEGIN
		SELECT EntityTypeID, EntityTypeName
        FROM EntityTypes
		ORDER BY EntityTypeID, EntityTypeName;
    END;
    ELSEIF $CRUD = 'U'  AND $EntityTypeName IS NOT NULL AND $EntityTypeID IS NOT NULL 
    THEN
	BEGIN
		UPDATE EntityTypes 
        SET EntityTypeName = $EntityTypeName, ModifDate = NOW()
        WHERE EntityTypeID = $EntityTypeID;
        
        SELECT 'Updated' as CRUD;
    END;
    ELSEIF $CRUD = 'D' AND $EntityTypeID IS NOT NULL 
    THEN 
    BEGIN
		DELETE FROM EntityTypes WHERE EntityTypeID = $EntityTypeID;
        
        SELECT 'Deleted' as CRUD;
    END;
    ELSE 
    BEGIN
		SELECT 'Implicit CRUD' as CRUD;
    END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `HelloWorld` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `HelloWorld`()
BEGIN
   SELECT 'Aye Matey' as HW;
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

-- Dump completed on 2019-11-03 21:57:45
