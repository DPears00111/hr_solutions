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
-- Table structure for table `time_off`
--

DROP TABLE IF EXISTS `time_off`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_off` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employeeId` int NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `reason` varchar(100) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employeeId` (`employeeId`),
  CONSTRAINT `time_off_ibfk_1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_off`
--

LOCK TABLES `time_off` WRITE;
/*!40000 ALTER TABLE `time_off` DISABLE KEYS */;
INSERT INTO `time_off` VALUES (1,1,'2025-07-22','2025-07-22','Sick Leave','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(2,1,'2024-12-01','2024-12-01','Personal','pending','2025-07-22 11:38:04','2025-07-22 11:38:04'),(3,2,'2025-07-15','2025-07-15','Family Responsibility','rejected','2025-07-22 11:38:04','2025-07-22 11:38:04'),(4,2,'2024-12-02','2024-12-02','Vacation','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(5,3,'2025-07-10','2025-07-10','Medical Appointment','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(6,3,'2024-12-05','2024-12-05','Personal','pending','2025-07-22 11:38:04','2025-07-22 11:38:04'),(7,4,'2025-07-20','2025-07-20','Bereavement','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(8,5,'2024-12-01','2024-12-01','Childcare','pending','2025-07-22 11:38:04','2025-07-22 11:38:04'),(9,6,'2025-07-18','2025-07-18','Sick Leave','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(10,7,'2025-07-22','2025-07-22','Vacation','pending','2025-07-22 11:38:04','2025-07-22 11:38:04'),(11,8,'2024-12-02','2024-12-02','Medical Appointment','approved','2025-07-22 11:38:04','2025-07-22 11:38:04'),(12,9,'2025-07-19','2025-07-19','Childcare','rejected','2025-07-22 11:38:04','2025-07-22 11:38:04'),(13,10,'2024-12-03','2024-12-03','Vacation','pending','2025-07-22 11:38:04','2025-07-22 11:38:04');
/*!40000 ALTER TABLE `time_off` ENABLE KEYS */;
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
