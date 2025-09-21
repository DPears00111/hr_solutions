CREATE DATABASE  IF NOT EXISTS `hr_solutions_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hr_solutions_db`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: hr_solutions_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `performance_goals`
--

DROP TABLE IF EXISTS `performance_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_goals` (
  `goal_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `set_goal` text NOT NULL,
  `progress` text,
  `new_goal` text,
  `status` enum('not_started','in_progress','completed','abandoned') DEFAULT 'not_started',
  `deadline` date DEFAULT NULL,
  PRIMARY KEY (`goal_id`),
  KEY `review_id` (`review_id`),
  CONSTRAINT `performance_goals_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `performance_reviews` (`review_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_goals`
--

LOCK TABLES `performance_goals` WRITE;
/*!40000 ALTER TABLE `performance_goals` DISABLE KEYS */;
INSERT INTO `performance_goals` VALUES (1,1,'Boost client engagement','Initiated bi-weekly newsletters','Launch feedback collection campaign','in_progress','2025-12-31'),(2,1,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(3,2,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(4,2,'Boost client engagement','Initiated bi-weekly newsletters','Launch feedback collection campaign','in_progress','2025-12-31'),(5,3,'Improve system reliability','Conducted a reliability audit and reduced outages by 30%','Implement alert automation for better response times','in_progress','2025-08-31'),(6,3,'Boost client engagement','Initiated bi-weekly newsletters','Launch feedback collection campaign','in_progress','2025-12-31'),(7,4,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(8,4,'Improve system reliability','Conducted a reliability audit and reduced outages by 30%','Implement alert automation for better response times','in_progress','2025-08-31'),(9,5,'Improve system reliability','Conducted a reliability audit and reduced outages by 30%','Implement alert automation for better response times','in_progress','2025-08-31'),(10,5,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(11,6,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(12,6,'Improve system reliability','Conducted a reliability audit and reduced outages by 30%','Implement alert automation for better response times','in_progress','2025-08-31'),(13,7,'Enhance test coverage','Increased unit tests by 2%','Introduce integration testing framework','not_started','2025-09-30'),(14,7,'Boost client engagement','No notable progress','Launch feedback collection campaign','not_started','2025-12-31'),(15,8,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(16,8,'Boost client engagement','Initiated bi-weekly newsletters','Launch feedback collection campaign','in_progress','2025-12-31'),(17,9,'Boost client engagement','Initiated bi-weekly newsletters','Launch feedback collection campaign','in_progress','2025-12-31'),(18,9,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(19,10,'Enhance test coverage','Increased unit tests by 25%','Introduce integration testing framework','in_progress','2025-09-30'),(20,10,'Improve system reliability','Conducted a reliability audit and reduced outages by 30%','Implement alert automation for better response times','in_progress','2025-08-31');
/*!40000 ALTER TABLE `performance_goals` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-22 13:49:56
