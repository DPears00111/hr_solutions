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
-- Table structure for table `performance_reviews`
--

DROP TABLE IF EXISTS `performance_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `reviewer_id` int NOT NULL,
  `review_date` date NOT NULL,
  `overall_rating` enum('Poor','Needs Improvement','Meets Expectations','Exceeds Expectations','Outstanding') NOT NULL,
  `achievements` text,
  `general_feedback` text,
  `reviewer_comments` text,
  `employee_comments` text,
  `status` enum('draft','completed','archived') DEFAULT 'completed',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `employee_id` (`employee_id`),
  KEY `reviewer_id` (`reviewer_id`),
  CONSTRAINT `performance_reviews_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `performance_reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_reviews`
--

LOCK TABLES `performance_reviews` WRITE;
/*!40000 ALTER TABLE `performance_reviews` DISABLE KEYS */;
INSERT INTO `performance_reviews` VALUES (1,1,2,'2025-06-20','Exceeds Expectations','Introduced process improvements that saved time across departments.','Could contribute more in team discussions.','Appreciate your dedication, but focus on improving consistency.','Looking forward to new challenges and continued growth.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(2,2,1,'2025-06-18','Meets Expectations','Played a key role in a successful product launch.','Reliable and always meets expectations.','Appreciate your dedication, but focus on improving consistency.','Thanks for recognizing my efforts. I\'m excited for next quarter.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(3,3,2,'2025-06-22','Meets Expectations','Consistently delivered high-quality work under tight deadlines.','Should work on time management in multi-project scenarios.','Please improve on your work.','I strongly disagree with this review. I\'ve consistently met deadlines, helped team members, and gone above my job requirements, yet none of that is reflected here. This feels biased and doesn\'t represent the actual work I\'ve done.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(4,4,2,'2025-06-15','Meets Expectations','Introduced process improvements that saved time across departments.','Needs to improve documentation practices.','Consider mentoring junior staff to give the a good start in the job.','Glad to be part of a supportive and challenging environment.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(5,5,2,'2025-06-14','Exceeds Expectations','Increased code coverage and reduced technical debt.','Brings creative solutions to challenging problems.','Your contributions to team are recognized.','Glad to be part of a supportive and challenging environment.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(6,6,2,'2025-06-12','Meets Expectations','Played a key role in a successful product launch.','Needs to improve documentation practices.','You are a valuable asset to the team and your efforts show.','Glad to be part of a supportive and challenging environment.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(7,7,2,'2025-06-10','Meets Expectations','Successfully led the migration to a new system with minimal downtime.','Needs to improve documentation practices.','Consider doing your job.','I appreciate the feedback and will work on the suggested areas.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(8,8,2,'2025-06-08','Exceeds Expectations','Consistently delivered high-quality work under tight deadlines.','Reliable and always meets expectations.','Keep up the good work, there is always room for improvement.','I appreciate the feedback and look forward to improving.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(9,9,2,'2025-06-06','Meets Expectations','Designed and conducted multiple UX research initiatives.','Has grown into a dependable leader.','Your contributions to team goals have been crucial.','Looking forward to new challenges and continued growth.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21'),(10,10,2,'2025-06-04','Meets Expectations','Introduced process improvements that saved time across departments.','Reliable and always meets expectations.','Your contributions to team goals have been crucial.','Thanks for recognizing my efforts. I\'m excited for next quarter.','completed','2025-07-22 11:38:21','2025-07-22 11:38:21');
/*!40000 ALTER TABLE `performance_reviews` ENABLE KEYS */;
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
