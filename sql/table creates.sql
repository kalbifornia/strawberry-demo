CREATE TABLE `ampapi` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `ConsolePath` varchar(100) DEFAULT NULL,
  `UsesPII` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ampenvironment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ampapiinstance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `APIID` int NOT NULL,
  `EnvironmentID` int NOT NULL,
  `AnypointInstanceID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_APIInstance_API_idx` (`APIID`),
  KEY `FK_APIInstance_Environment_idx` (`EnvironmentID`),
  CONSTRAINT `FK_APIInstance_API` FOREIGN KEY (`APIID`) REFERENCES `ampapi` (`ID`),
  CONSTRAINT `FK_APIInstance_Environment` FOREIGN KEY (`EnvironmentID`) REFERENCES `ampenvironment` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ampoperatingsystemtype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ampsystemtype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ShortName_UNIQUE` (`ShortName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ampsystem` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ampdeploymenttype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(10) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ampcluster` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `DeploymentType` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_ClusterDeploymentType_idx` (`DeploymentType`),
  CONSTRAINT `FK_ClusterDeploymentType` FOREIGN KEY (`DeploymentType`) REFERENCES `ampdeploymenttype` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
