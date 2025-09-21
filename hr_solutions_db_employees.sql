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
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `position` varchar(100) NOT NULL,
  `department` varchar(50) NOT NULL,
  `employment_history` text NOT NULL,
  `contact` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Sibongile Nkosi','Software Engineer','Development','Joined in 2015, promoted to Senior in 2018','sibongile.nkosi@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(2,'Lungile Moyo','HR Manager','HR','Joined in 2013, promoted to Manager in 2017','lungile.moyo@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(3,'Thabo Molefe','Quality Analyst','QA','Joined in 2018','thabo.molefe@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(4,'Keshav Naidoo','Sales Representative','Sales','Joined in 2020','keshav.naidoo@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(5,'Zanele Khumalo','Marketing Specialist','Marketing','Joined in 2019','zanele.khumalo@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(6,'Sipho Zulu','UI/UX Designer','Design','Joined in 2016','sipho.zulu@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(7,'Naledi Moeketsi','DevOps Engineer','IT','Joined in 2017','naledi.moeketsi@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(8,'Farai Gumbo','Content Strategist','Marketing','Joined in 2021','farai.gumbo@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(9,'Karabo Dlamini','Accountant','Finance','Joined in 2018','karabo.dlamini@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39'),(10,'Fatima Patel','Customer Support Lead','Support','Joined in 2016','fatima.patel@moderntech.com','2025-07-22 11:37:39','2025-07-22 11:37:39');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
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
