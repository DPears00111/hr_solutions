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
-- Table structure for table `review_categories`
--

DROP TABLE IF EXISTS `review_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `category_name` varchar(50) NOT NULL,
  `rating` int NOT NULL,
  `comments` text,
  PRIMARY KEY (`category_id`),
  KEY `review_id` (`review_id`),
  CONSTRAINT `review_categories_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `performance_reviews` (`review_id`),
  CONSTRAINT `review_categories_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_categories`
--

LOCK TABLES `review_categories` WRITE;
/*!40000 ALTER TABLE `review_categories` DISABLE KEYS */;
INSERT INTO `review_categories` VALUES (1,1,'Job Knowledge',5,'Understands their role and tools very well.'),(2,1,'Quality of Work',4,'Delivers high quality work consistently.'),(3,1,'Soft Skills',4,'Has good communication with team members.'),(4,1,'Initiative',5,'Always takes steps to do the work perfectly.'),(5,2,'Job Knowledge',3,'Has average knowledge of the job.'),(6,2,'Quality of Work',4,'Produces consistently high-quality deliverables.'),(7,2,'Soft Skills',4,'Communicates effectively and respectfully.'),(8,2,'Initiative',5,'Frequently takes proactive steps to improve work.'),(9,3,'Job Knowledge',2,'Falls short on most of the work needed.'),(10,3,'Quality of Work',1,'Delivers projects late and most times with problems.'),(11,3,'Soft Skills',3,'Does not communicate well with the people she is managing.'),(12,3,'Initiative',1,'Does the absolute minimum and most times less than that.'),(13,4,'Job Knowledge',5,'Has the best understanding of the job.'),(14,4,'Quality of Work',5,'Produces very high quality, neat and impressive work.'),(15,4,'Soft Skills',4,'Has good work relationships with the rest of the team.'),(16,4,'Initiative',5,'Always goes above and beyond.'),(17,5,'Job Knowledge',3,'Understands the job as expected.'),(18,5,'Quality of Work',3,'Produces the expected quality of work.'),(19,5,'Soft Skills',5,'Incredibly communicative and a people person.'),(20,5,'Initiative',3,'Like the rest of his work, does the expected of him and nothing beyond that.'),(21,6,'Job Knowledge',5,'Perfect understanding of the job.'),(22,6,'Quality of Work',4,'Gives high quality work.'),(23,6,'Soft Skills',4,'Communicates effectively and respectfully.'),(24,6,'Initiative',5,'Always finding smart ways to make their work better without being told.'),(25,7,'Job Knowledge',1,'No understanding.'),(26,7,'Quality of Work',1,'Terrible quality.'),(27,7,'Soft Skills',1,'Incredibly rude and does not work well with others.'),(28,7,'Initiative',1,'Never takes initiative.'),(29,8,'Job Knowledge',3,'Has basic understanding of the job.'),(30,8,'Quality of Work',3,'Produces good work.'),(31,8,'Soft Skills',4,'Communicates effectively and respectfully.'),(32,8,'Initiative',3,'Takes steps to improve work.'),(33,9,'Job Knowledge',5,'Knows their job incredibly well.'),(34,9,'Quality of Work',4,'Good work quality.'),(35,9,'Soft Skills',4,'Works and communicates well with others.'),(36,9,'Initiative',5,'Takes the initiative to do work.'),(37,10,'Job Knowledge',3,'Knows the job.'),(38,10,'Quality of Work',4,'Work is in great quality.'),(39,10,'Soft Skills',4,'Communicates well.'),(40,10,'Initiative',2,'Doesn\'t frequently take initiative.');
/*!40000 ALTER TABLE `review_categories` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-22 13:49:57
