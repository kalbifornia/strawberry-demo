-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: ampdatabase
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ampapi`
--

DROP TABLE IF EXISTS `ampapi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampapi` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `ConsolePath` varchar(100) DEFAULT NULL,
  `UsesPII` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampapi`
--

LOCK TABLES `ampapi` WRITE;
/*!40000 ALTER TABLE `ampapi` DISABLE KEYS */;
INSERT INTO `ampapi` VALUES (1,'my-crm-to-pc-batch-api','An API which delivers data from CRM to PolicyCenter','/api/v1/my-crm-to-pc-batch-api/console/',_binary '\0'),(2,'my-pc-mvr-experience-api','An API which handles experience layer for call to get MVR records','/api/v1/my-pc-mvr-experience-api/console/',_binary ''),(3,'my-mvr-process-api','An API which handles orchestration for getting MVR records','/api/v1/my-mvr-process-api/console/',_binary ''),(4,'my-vendor-violation-predictor-system-api','An API which requests data from Violation Predictor vendor','/api/v1/my-vendor-violation-predictor-system-api/console/',_binary '\0'),(5,'my-vendor-account-lookup-system-api','An API which brings back vendor account variables based on input criteria','/api/v1/my-vendor-account-lookup-system-api/console/',_binary '\0'),(6,'my-vendor-mvr-sys','An API which gets MVR data from vendor','/api/v1/my-vendor-mvr-sys/console/',_binary ''),(7,'my-digital-pc-account-experience-api','An API which handles experience layer for getting Account info from portal to PolicyCenter','/api/v1/my-digital-pc-account-experience-api/console/',_binary '\0'),(8,'my-pc-account-system-api','An API which sends account data to PolicyCenter','/api/v1/my-pc-account-system-api/console/',_binary '\0');
/*!40000 ALTER TABLE `ampapi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampapiapi`
--

DROP TABLE IF EXISTS `ampapiapi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampapiapi` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SourceAPIID` int NOT NULL,
  `TargetAPIID` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNIQUE_APIAPI_SourceTargetAPI` (`SourceAPIID`,`TargetAPIID`),
  KEY `FK_APIAPI_SourceAPI_idx` (`SourceAPIID`),
  KEY `FK_APIAPI_TargetAPI_idx` (`TargetAPIID`),
  CONSTRAINT `FK_APIAPI_SourceAPI` FOREIGN KEY (`SourceAPIID`) REFERENCES `ampapi` (`ID`),
  CONSTRAINT `FK_APIAPI_TargetAPI` FOREIGN KEY (`TargetAPIID`) REFERENCES `ampapi` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampapiapi`
--

LOCK TABLES `ampapiapi` WRITE;
/*!40000 ALTER TABLE `ampapiapi` DISABLE KEYS */;
INSERT INTO `ampapiapi` VALUES (1,2,3),(2,3,4),(3,3,5),(4,3,6);
/*!40000 ALTER TABLE `ampapiapi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampapiinstance`
--

DROP TABLE IF EXISTS `ampapiinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampapiinstance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `APIID` int NOT NULL,
  `ClusterID` int DEFAULT NULL,
  `AnypointInstanceID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_APIInstance_API_idx` (`APIID`),
  KEY `FK_APIInstance_Cluster_idx` (`ClusterID`),
  CONSTRAINT `FK_APIInstance_API` FOREIGN KEY (`APIID`) REFERENCES `ampapi` (`ID`),
  CONSTRAINT `FK_APIInstance_Cluster` FOREIGN KEY (`ClusterID`) REFERENCES `ampcluster` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampapiinstance`
--

LOCK TABLES `ampapiinstance` WRITE;
/*!40000 ALTER TABLE `ampapiinstance` DISABLE KEYS */;
INSERT INTO `ampapiinstance` VALUES (13,1,2,NULL),(14,2,1,NULL),(15,3,1,NULL),(16,4,1,NULL),(17,5,1,NULL),(18,6,1,NULL),(19,7,1,NULL),(20,8,1,NULL),(21,1,6,NULL),(22,2,4,NULL),(23,3,4,NULL),(24,4,4,NULL),(25,5,3,NULL),(26,6,4,NULL),(27,7,3,NULL),(28,8,8,NULL),(29,1,10,NULL),(30,2,8,NULL),(31,3,8,NULL),(32,4,8,NULL),(33,5,7,NULL);
/*!40000 ALTER TABLE `ampapiinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampapisystem`
--

DROP TABLE IF EXISTS `ampapisystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampapisystem` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `APIID` int NOT NULL,
  `SystemID` int NOT NULL,
  `SystemTypeID` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNIQUE_APISystem` (`APIID`,`SystemID`,`SystemTypeID`),
  KEY `FK_APISystem_API_idx` (`APIID`) /*!80000 INVISIBLE */,
  KEY `FK_APISystem_System_idx` (`SystemID`),
  KEY `FK_APISystem_SystemType_idx` (`SystemTypeID`),
  CONSTRAINT `FK_APISystem_API` FOREIGN KEY (`APIID`) REFERENCES `ampapi` (`ID`),
  CONSTRAINT `FK_APISystem_System` FOREIGN KEY (`SystemID`) REFERENCES `ampsystem` (`ID`),
  CONSTRAINT `FK_APISystem_SystemType` FOREIGN KEY (`SystemTypeID`) REFERENCES `ampsystemtype` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampapisystem`
--

LOCK TABLES `ampapisystem` WRITE;
/*!40000 ALTER TABLE `ampapisystem` DISABLE KEYS */;
INSERT INTO `ampapisystem` VALUES (1,1,1,1),(2,1,5,2),(5,2,5,1),(4,4,23,2),(3,6,24,2);
/*!40000 ALTER TABLE `ampapisystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampcluster`
--

DROP TABLE IF EXISTS `ampcluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampcluster` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EnvironmentID` int NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `DeploymentType` int NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNIQUE_ClusterNameEnvironment` (`Name`,`EnvironmentID`),
  KEY `FK_ClusterDeploymentType_idx` (`DeploymentType`),
  KEY `FK_ClusterEnvironment_idx` (`EnvironmentID`),
  CONSTRAINT `FK_ClusterDeploymentType` FOREIGN KEY (`DeploymentType`) REFERENCES `ampdeploymenttype` (`ID`),
  CONSTRAINT `FK_ClusterEnvironment` FOREIGN KEY (`EnvironmentID`) REFERENCES `ampenvironment` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampcluster`
--

LOCK TABLES `ampcluster` WRITE;
/*!40000 ALTER TABLE `ampcluster` DISABLE KEYS */;
INSERT INTO `ampcluster` VALUES (1,1,'MainPod','',1),(2,1,'BatchPod','',1),(3,2,'Pod2','',1),(4,2,'Pod3','',1),(5,2,'Pod4','',1),(6,2,'Batch4','',1),(7,3,'Pod2','',1),(8,3,'Pod3','',1),(9,3,'Pod4','',1),(10,3,'Batch4','',1);
/*!40000 ALTER TABLE `ampcluster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampdeploymenttype`
--

DROP TABLE IF EXISTS `ampdeploymenttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampdeploymenttype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampdeploymenttype`
--

LOCK TABLES `ampdeploymenttype` WRITE;
/*!40000 ALTER TABLE `ampdeploymenttype` DISABLE KEYS */;
INSERT INTO `ampdeploymenttype` VALUES (1,'ON_PREM','On-Premise'),(2,'RTF','Runtime Fabric'),(3,'CLOUD','CloudHub');
/*!40000 ALTER TABLE `ampdeploymenttype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampenvironment`
--

DROP TABLE IF EXISTS `ampenvironment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampenvironment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampenvironment`
--

LOCK TABLES `ampenvironment` WRITE;
/*!40000 ALTER TABLE `ampenvironment` DISABLE KEYS */;
INSERT INTO `ampenvironment` VALUES (1,'Dev'),(3,'Production'),(2,'QA');
/*!40000 ALTER TABLE `ampenvironment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampoperatingsystemtype`
--

DROP TABLE IF EXISTS `ampoperatingsystemtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampoperatingsystemtype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampoperatingsystemtype`
--

LOCK TABLES `ampoperatingsystemtype` WRITE;
/*!40000 ALTER TABLE `ampoperatingsystemtype` DISABLE KEYS */;
INSERT INTO `ampoperatingsystemtype` VALUES (1,'WINDOWS','Windows'),(2,'LINUX','Linux');
/*!40000 ALTER TABLE `ampoperatingsystemtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampserver`
--

DROP TABLE IF EXISTS `ampserver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampserver` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `ClusterID` int DEFAULT NULL,
  `OperatingSystemID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_ServerOS_idx` (`OperatingSystemID`),
  KEY `FK_ServerCluster_idx` (`ClusterID`),
  CONSTRAINT `FK_ServerCluster` FOREIGN KEY (`ClusterID`) REFERENCES `ampcluster` (`ID`),
  CONSTRAINT `FK_ServerOS` FOREIGN KEY (`OperatingSystemID`) REFERENCES `ampoperatingsystemtype` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampserver`
--

LOCK TABLES `ampserver` WRITE;
/*!40000 ALTER TABLE `ampserver` DISABLE KEYS */;
INSERT INTO `ampserver` VALUES (1,'devserver1','',1,1),(2,'devserver2','',1,1),(3,'devserver3','',2,1),(4,'devserver4','',2,1),(5,'qaserver1','',3,1),(6,'qaserver2','',3,1),(7,'qaserver3','',4,1),(8,'qaserver4','',4,1),(9,'qaserver5','',5,1),(10,'qaserver6','',5,1),(11,'qaserver7','',6,2),(12,'qaserver8','',6,2),(13,'prodserver1','',7,1),(14,'prodserver2','',7,1),(15,'prodserver3','',8,1),(16,'prodserver4','',8,1),(17,'prodserver5','',9,1),(18,'prodserver6','',9,1),(19,'prodserver7','',10,1),(20,'prodserver8','',10,1),(21,'prodserver9','',7,1),(22,'prodserver10','',8,1),(23,'prodserver11','',9,1),(24,'prodserver12','',10,1);
/*!40000 ALTER TABLE `ampserver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampsystem`
--

DROP TABLE IF EXISTS `ampsystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampsystem` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampsystem`
--

LOCK TABLES `ampsystem` WRITE;
/*!40000 ALTER TABLE `ampsystem` DISABLE KEYS */;
INSERT INTO `ampsystem` VALUES (1,'CRM','CRM: Customer Relationship Management System'),(2,'CIF','CIF: Customer Information File'),(3,'PMS','PMS: Legacy Policy System'),(4,'Livewire','Livewire ClaimCenter'),(5,'PC','PolicyCenter'),(6,'BC','BillingCenter'),(7,'GAINWeb 2.0','GAINWeb 2.0 Core4 Portal'),(8,'GAINWeb 1.0','GAINWeb 1.0 Legacy Portal'),(9,'DataHub','DataHub System'),(10,'Active Directory','Active Directory user directory system'),(11,'Saviynt','Saviynt Identity Access Management System'),(23,'Violation Predictor Vendor','Vendor System for Violation Predictor'),(24,'L LLC Vendor System','L LLC Vendor System for all sorts of lookups like MVR, Credit Report, etc');
/*!40000 ALTER TABLE `ampsystem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ampsystemtype`
--

DROP TABLE IF EXISTS `ampsystemtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ampsystemtype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ShortName_UNIQUE` (`ShortName`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ampsystemtype`
--

LOCK TABLES `ampsystemtype` WRITE;
/*!40000 ALTER TABLE `ampsystemtype` DISABLE KEYS */;
INSERT INTO `ampsystemtype` VALUES (1,'SOURCE','Source System'),(2,'TARGET','Target System'),(3,'DEPEND','Dependency System');
/*!40000 ALTER TABLE `ampsystemtype` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-18 20:18:15
