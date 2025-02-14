CREATE DATABASE  IF NOT EXISTS `reinado` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `reinado`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: reinado
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `calificacion`
--

DROP TABLE IF EXISTS `calificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificacion` (
  `CALIFICACION_ID` int NOT NULL AUTO_INCREMENT,
  `EVENTO_ID` int NOT NULL,
  `USUARIO_ID` int NOT NULL,
  `CANDIDATA_ID` int DEFAULT NULL,
  `CALIFICACION_NOMBRE` varchar(30) NOT NULL,
  `CALIFICACION_PESO` int NOT NULL,
  `CALIFICACION_VALOR` decimal(10,2) NOT NULL,
  PRIMARY KEY (`CALIFICACION_ID`),
  UNIQUE KEY `unique_calificacion` (`EVENTO_ID`,`USUARIO_ID`,`CANDIDATA_ID`),
  KEY `FK_ABARCA` (`EVENTO_ID`),
  KEY `FK_ADMINISTRA` (`USUARIO_ID`),
  KEY `FK_TIENE_idx` (`CANDIDATA_ID`),
  CONSTRAINT `FK_ABARCA` FOREIGN KEY (`EVENTO_ID`) REFERENCES `evento` (`EVENTO_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_ADMINISTRA` FOREIGN KEY (`USUARIO_ID`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_TIENE` FOREIGN KEY (`CANDIDATA_ID`) REFERENCES `candidata` (`CANDIDATA_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificacion`
--

LOCK TABLES `calificacion` WRITE;
/*!40000 ALTER TABLE `calificacion` DISABLE KEYS */;
INSERT INTO `calificacion` VALUES (1,1,1,1,'Traje Típico',100,16.00),(2,1,1,2,'Traje Típico',100,18.00),(3,1,1,3,'Traje Típico',100,8.00),(4,1,1,4,'Traje Típico',100,18.00),(5,1,1,5,'Traje Típico',100,16.00),(6,1,1,6,'Traje Típico',100,18.00),(7,1,1,7,'Traje Típico',100,18.00),(8,1,1,8,'Traje Típico',100,6.00),(9,1,1,9,'Traje Típico',100,16.00),(10,1,1,10,'Traje Típico',100,8.00),(11,1,1,11,'Traje Típico',100,6.00),(12,1,1,12,'Traje Típico',100,8.00),(13,1,2,1,'Traje Típico',100,16.00),(14,1,2,2,'Traje Típico',100,18.00),(15,1,2,3,'Traje Típico',100,18.00),(16,1,2,4,'Traje Típico',100,6.00),(17,1,2,5,'Traje Típico',100,8.00),(18,1,2,6,'Traje Típico',100,18.00),(19,1,2,7,'Traje Típico',100,18.00),(20,1,2,8,'Traje Típico',100,14.00),(21,1,2,9,'Traje Típico',100,16.00),(22,1,2,10,'Traje Típico',100,10.00),(23,1,2,11,'Traje Típico',100,8.00),(24,1,2,12,'Traje Típico',100,16.00),(25,2,1,1,'Traje Gala',100,16.00),(26,2,1,2,'Traje Gala',100,16.00),(27,2,1,3,'Traje Gala',100,18.00),(28,2,1,4,'Traje Gala',100,18.00),(29,2,1,5,'Traje Gala',100,16.00),(30,2,1,6,'Traje Gala',100,16.00),(31,2,1,7,'Traje Gala',100,16.00),(32,2,1,8,'Traje Gala',100,16.00),(33,2,1,9,'Traje Gala',100,18.00),(34,2,1,10,'Traje Gala',100,8.00),(35,2,1,11,'Traje Gala',100,6.00),(36,2,1,12,'Traje Gala',100,16.00),(37,2,2,1,'Traje Gala',100,18.00),(38,2,2,2,'Traje Gala',100,16.00),(39,2,2,3,'Traje Gala',100,18.00),(40,2,2,4,'Traje Gala',100,14.00),(41,2,2,5,'Traje Gala',100,16.00),(42,2,2,6,'Traje Gala',100,8.00),(43,2,2,7,'Traje Gala',100,8.00),(44,2,2,8,'Traje Gala',100,8.00),(45,2,2,9,'Traje Gala',100,18.00),(46,2,2,10,'Traje Gala',100,20.00),(47,2,2,11,'Traje Gala',100,8.00),(48,2,2,12,'Traje Gala',100,16.00),(49,3,1,1,'Preguntas',100,18.00),(50,3,1,2,'Preguntas',100,18.00),(51,3,1,3,'Preguntas',100,18.00),(52,3,1,4,'Preguntas',100,16.00),(53,3,1,5,'Preguntas',100,4.00),(54,3,1,6,'Preguntas',100,4.00),(55,3,1,7,'Preguntas',100,18.00),(56,3,1,8,'Preguntas',100,12.00),(57,3,1,9,'Preguntas',100,8.00),(58,3,1,10,'Preguntas',100,10.00),(59,3,1,11,'Preguntas',100,2.00),(60,3,1,12,'Preguntas',100,16.00),(61,3,2,1,'Preguntas',100,20.00),(62,3,2,2,'Preguntas',100,14.00),(63,3,2,3,'Preguntas',100,6.00),(64,3,2,4,'Preguntas',100,4.00),(65,3,2,5,'Preguntas',100,16.00),(66,3,2,6,'Preguntas',100,14.00),(67,3,2,7,'Preguntas',100,18.00),(68,3,2,8,'Preguntas',100,6.00),(69,3,2,9,'Preguntas',100,4.00),(70,3,2,10,'Preguntas',100,14.00),(71,3,2,11,'Preguntas',100,18.00),(72,3,2,12,'Preguntas',100,16.00);
/*!40000 ALTER TABLE `calificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidata`
--

DROP TABLE IF EXISTS `candidata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidata` (
  `CANDIDATA_ID` int NOT NULL AUTO_INCREMENT,
  `CARRERA_ID` int NOT NULL,
  `ELECCION_ID` int NOT NULL,
  `CAND_APELLIDOPATERNO` varchar(30) NOT NULL,
  `CAND_APELLIDOMATERNO` varchar(30) NOT NULL,
  `CAND_NOMBRE1` varchar(30) NOT NULL,
  `CAND_NOMBRE2` varchar(30) DEFAULT NULL,
  `CAND_FECHANACIMIENTO` date DEFAULT NULL,
  `CAND_ACTIVIDAD_EXTRA` varchar(900) DEFAULT NULL,
  `CAND_ESTATURA` decimal(3,2) DEFAULT NULL COMMENT 'La estatura debe ser en metros',
  `CAND_HOBBIES` varchar(900) DEFAULT NULL,
  `CAND_IDIOMAS` varchar(100) DEFAULT NULL,
  `CAND_COLOROJOS` varchar(45) DEFAULT NULL,
  `CAND_COLORCABELLO` varchar(45) DEFAULT NULL,
  `CAND_LOGROS_ACADEMICOS` varchar(900) DEFAULT NULL,
  `CAND_NOTA_FINAL` int DEFAULT NULL,
  `ID_ELECCION` int NOT NULL,
  `CAND_CALIFICACIONFINAL` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`CANDIDATA_ID`),
  KEY `FK_ESTUDIA` (`CARRERA_ID`),
  KEY `FK_PERIODO_idx` (`ELECCION_ID`),
  KEY `ID_ELECCION_idx` (`ID_ELECCION`),
  CONSTRAINT `FK_ESTUDIA` FOREIGN KEY (`CARRERA_ID`) REFERENCES `carrera` (`CARRERA_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_PERIODO` FOREIGN KEY (`ELECCION_ID`) REFERENCES `eleccion` (`ELECCION_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidata`
--

LOCK TABLES `candidata` WRITE;
/*!40000 ALTER TABLE `candidata` DISABLE KEYS */;
INSERT INTO `candidata` VALUES (1,8,1,'Morillo','Rodríguez','Wendy','Elizabeth',NULL,'Para mi la Universidad de las Fuerzas Armadas ESPE, signfica una gran oportunidad para desarrollarse profesionalmente, aprender a trabajar tanto de manera individual como grupal y poder adquirir nuevas habilidades y experiencias necesarias para desenvolverse en la carrera elegida. La ESPE nos brinda un gran apoyo, valores, conocimientos, disciplina, liderazgo y responsabilidades muy importantes al momentos de llegar a enfretar los desafíos que se nos presenten a lo largo de este trayecto.',NULL,NULL,NULL,NULL,NULL,NULL,105,0,NULL),(2,3,1,'Reyes','Pérez','Jessenia','del Rocío',NULL,'La Universidad de las Fuerzas Armadas ESPE es la llama encendida de la valentía y la disciplina, donde se forjan almas con la nobleza del saber en el crisol del honor, guiadas por el ideal del servir y engrandecer la patria.',NULL,NULL,NULL,NULL,NULL,NULL,100,0,NULL),(3,10,1,'Estrella','Paladines','Yariely','Nicole',NULL,'La ESPE simboliza para mí, el compromiso con la defensa y el progreso de nuestro país, guiándome en el camino de la responsabilidad y el liderazgo con integridad.',NULL,NULL,NULL,NULL,NULL,NULL,86,0,1.00),(4,9,1,'Morán','Vega','Andrea','Gisselle',NULL,'Para mi significa más que un lugar de aprendizaje, es un segundo hogar donde he crecido personal y academicamente. Aquí, he encontrado inspiración en los profesores, he formado lazos con mis compañeros y he descubierto mis pasiones y habilidades. Esta Universidad me ha enseñado el valor de la perseverancia, la colaboración y el pensamiento crítico, estoy orgullosa de ser parte de una comunidad que fomenta la excelencia y el desarrollo integral.',NULL,NULL,NULL,NULL,NULL,NULL,76,0,NULL),(5,4,1,'Fuertes','Ortega','Liz','Scarlet',NULL,'La universidad para mí es un viaje de descubrimiento y crecimiento, es donde encuentro mi pasión, hago amistades para toda la vida y aprendo más sobre mí misma. Es un lugar donde mis sueños toman forma y mi futuro comienza a construirse. ',NULL,NULL,NULL,NULL,NULL,NULL,76,0,NULL),(6,2,1,'Aguirre','Espinosa','Gabriela','Nicole',NULL,'Para mí, la gloriosa ESPE (Universidad de las Fuerzas Armadas) representa un período de crecimiento, formación y madurez en mi vida, donde he desarrollado habilidades y conocimientos valiosos que me han permitido crecer como persona. Es un lugar donde he encontrado apoyo, amistades y mentoría que me han ayudado a encontrar mi camino y a alcanzar mis objetivos.',NULL,NULL,NULL,NULL,NULL,NULL,78,0,NULL),(7,7,1,'Sancan','Portillo','Martha','Dayana',NULL,'La Universidad de las Fuerzas Armadas ESPE simboliza para mí el privilegio de aprender, servir, y desarrollarme con excelencia y disciplina, inspirándome a alcanzar grandes metas.',NULL,NULL,NULL,NULL,NULL,NULL,96,0,NULL),(8,1,1,'Díaz','Pozo','Rebeca','Anahí',NULL,'La universidad de las fuerzas Armadas para mi representa un conjunto de valores; es el compromiso con el que los profesores nos transmiten su conocimiento día a día, es el poder de representar a una comunidad de jóvenes que desean llegar a ser buenos profesionales en la vida, es la calidad de educación que transmiten a sus estudiantes con el objetivo de crear lideres de esta sociedad',NULL,NULL,NULL,NULL,NULL,NULL,62,0,NULL),(9,11,1,'Montalván','Maldonado','Ariana','Daniela',NULL,'Para mí la Universidad ESPE genera disciplina, lealtad, civismo y patriotismo crea personas con un espíritu de liderazgo, nos brinda la seguridad de expresarnos y ser mejores ciudadanos, forma a los estudiantes como grandes profesionales, con un pensamiento lleno de valores y madurez mental, la Universidad es un lugar donde no solo vas a crecer en conocimiento si no como persona aprenderás a trabajar en equipo y a desenvolverte en la sociedad, creas amistades inolvidables, en conclusión nuestra gran universidad forma grandes profesionales, y te deja grandes anécdotas, por algo somos una de las mejores universidades del Ecuador, categoría A.',NULL,NULL,NULL,NULL,NULL,NULL,80,0,NULL),(10,12,1,'Briones','Mosquera','Kimberly','Brisney',NULL,'ESPE, integración y empatía, personas amables que emprenden una dura batalla para lograr sus objetivos; más que un conjunto de maestros, estudiantes y entidades, es unión, compañerismo, aprendizaje colectivo que nos proyecta a un futuro más desarrollado y lleno del conocimiento que imparten nuestros queridos maestros. Me es un privilegio inmenso poder decir que esta Universidad, se ha ganado un espacio en mi corazon y cada pequeño aporte de quienes conformamos esta institución, sumará para la educación de futuras generaciones.',NULL,NULL,NULL,NULL,NULL,NULL,70,0,NULL),(11,6,1,'Acosta','Acosta','Rachel','Alexandra',NULL,'Para mí, La Universidad de las Fuerzas Armadas - ESPE es más que un lugar de aprendizaje; es un refugio donde mis sueños toman forma y mis habilidades se cultivan. Es aquí donde encuentro inspiración, apoyo y la oportunidad de crecer no solo intelectualmente, sino también como persona. Gracias a esta institución cada clase es una puerta hacia el conocimiento y cada profesor un guía en mi viaje hacia el éxito.',NULL,NULL,NULL,NULL,NULL,NULL,48,0,NULL),(12,5,1,'Arreaga','Riera','Estefani','Nicole',NULL,'La Universidad ESPE significa para mí un pilar fundamental en mi desarrollo académico, profesional y personal, donde he adquirido conocimientos valiosos para crecer como persona, enfrentando y superando desafíos, desarrollando independencia , madurez y forjado amistades duraderas.',NULL,NULL,NULL,NULL,NULL,NULL,88,0,NULL);
/*!40000 ALTER TABLE `candidata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrera`
--

DROP TABLE IF EXISTS `carrera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrera` (
  `CARRERA_ID` int NOT NULL,
  `DEPARTAMENTO_ID` int NOT NULL,
  `CARRERA_NOMBRE` varchar(100) NOT NULL,
  PRIMARY KEY (`CARRERA_ID`),
  KEY `FK_PERTENECE` (`DEPARTAMENTO_ID`),
  CONSTRAINT `FK_PERTENECE` FOREIGN KEY (`DEPARTAMENTO_ID`) REFERENCES `departamento` (`DEPARTAMENTO_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrera`
--

LOCK TABLES `carrera` WRITE;
/*!40000 ALTER TABLE `carrera` DISABLE KEYS */;
INSERT INTO `carrera` VALUES (1,1,'Contabilidad y Auditoria'),(2,2,'Electronica y Telecomunicaciones'),(3,3,'Pedagogia de la actividad fisica y deporte'),(4,4,'Mecatronica'),(5,5,'Biotecnologia'),(6,6,'Petroquimica'),(7,7,'Medicina'),(8,8,'Tecnologias de la Informacion'),(9,9,'Agropecuaria'),(10,10,'Ingenieria Civil'),(11,11,'Seguridad y Defensa'),(12,12,'Ciencias Exactas');
/*!40000 ALTER TABLE `carrera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion`
--

DROP TABLE IF EXISTS `configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clave` varchar(50) NOT NULL,
  `valor` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clave_UNIQUE` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion`
--

LOCK TABLES `configuracion` WRITE;
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` VALUES (1,'votacion_publica_activa','1','Estado de la votación pública (1=activa, 0=inactiva)');
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `DEPARTAMENTO_ID` int NOT NULL,
  `DEPARTMENTO_NOMBRE` varchar(500) NOT NULL,
  `DEPARTAMENTO_SEDE` varchar(100) NOT NULL,
  PRIMARY KEY (`DEPARTAMENTO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (1,'Ciencias Económicas','Matriz'),(2,'Eléctrica, Electrónica y Telecomunicaciones','Matriz'),(3,'Ciencias Humanas y Sociales','Matriz'),(4,'Ciencias de la Energía y Mecánica','Matriz'),(5,'Sede Santo Domingo','Santo Domingo'),(6,'Sede Latacunga','Latacunga'),(7,'Ciencias Médicas','Matriz'),(8,'Ciencias de la Computación','Matriz'),(9,'Ciencias de la Vida y Agricultura','Matriz'),(10,'Ciencias de la Tierra y la Construcción ','Matriz'),(11,'Seguridad y Defensa','Matriz'),(12,'Ciencias Exactas','Matriz');
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `desempate`
--

DROP TABLE IF EXISTS `desempate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `desempate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `candidata_id` int DEFAULT NULL,
  `nota_final` decimal(10,2) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `candidata_id` (`candidata_id`),
  CONSTRAINT `desempate_ibfk_1` FOREIGN KEY (`candidata_id`) REFERENCES `candidata` (`CANDIDATA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `desempate`
--

LOCK TABLES `desempate` WRITE;
/*!40000 ALTER TABLE `desempate` DISABLE KEYS */;
/*!40000 ALTER TABLE `desempate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eleccion`
--

DROP TABLE IF EXISTS `eleccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eleccion` (
  `ELECCION_ID` int NOT NULL,
  `ELECCION_PERIODO` varchar(30) NOT NULL,
  PRIMARY KEY (`ELECCION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eleccion`
--

LOCK TABLES `eleccion` WRITE;
/*!40000 ALTER TABLE `eleccion` DISABLE KEYS */;
INSERT INTO `eleccion` VALUES (1,'May2024-Sept2024');
/*!40000 ALTER TABLE `eleccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evento`
--

DROP TABLE IF EXISTS `evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento` (
  `EVENTO_ID` int NOT NULL,
  `ELECCION_ID` int NOT NULL,
  `EVENTO_NOMBRE` varchar(30) NOT NULL,
  `EVENTO_PESO` int NOT NULL,
  `CALIF_POR_EVENTO` int NOT NULL,
  `EVENTO_ESTADO` varchar(45) NOT NULL,
  PRIMARY KEY (`EVENTO_ID`),
  KEY `FK_CORRESPONDE` (`ELECCION_ID`),
  CONSTRAINT `FK_CORRESPONDE` FOREIGN KEY (`ELECCION_ID`) REFERENCES `eleccion` (`ELECCION_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
INSERT INTO `evento` VALUES (1,1,'Traje Típico',100,1,'no'),(2,1,'Traje Gala',100,1,'no'),(3,1,'Preguntas',100,1,'no'),(4,1,'Publico',100,1,'no'),(5,1,'Desempate',100,1,'si');
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `features`
--

DROP TABLE IF EXISTS `features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `features` (
  `id_feature` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `enabled` tinyint NOT NULL DEFAULT '0',
  `role_name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_feature`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `features`
--

LOCK TABLES `features` WRITE;
/*!40000 ALTER TABLE `features` DISABLE KEYS */;
INSERT INTO `features` VALUES (1,'votacion_publica',1,NULL,NULL),(2,'monitoreo_notario',0,NULL,NULL),(3,'desempate',0,NULL,NULL),(4,'tabla_notario',0,NULL,'Acceso a la tabla del notario'),(5,'admin_eventos',0,NULL,'Administración de eventos'),(6,'top_candidatas',0,NULL,'Ver top de candidatas'),(7,'generar_reporte',1,NULL,'Generar reportes');
/*!40000 ALTER TABLE `features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finales`
--

DROP TABLE IF EXISTS `finales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finales` (
  `CALIFICACION_ID` int NOT NULL AUTO_INCREMENT,
  `EVENTO_ID` int NOT NULL,
  `USUARIO_ID` int NOT NULL,
  `CANDIDATA_ID` int DEFAULT NULL,
  `CALIFICACION_NOMBRE` varchar(30) NOT NULL,
  `CALIFICACION_PESO` int NOT NULL,
  `CALIFICACION_VALOR` decimal(10,2) NOT NULL,
  PRIMARY KEY (`CALIFICACION_ID`),
  UNIQUE KEY `unique_final_calificacion` (`EVENTO_ID`,`USUARIO_ID`,`CANDIDATA_ID`),
  KEY `FK_ABARCA` (`EVENTO_ID`),
  KEY `FK_ADMINISTRA` (`USUARIO_ID`),
  KEY `FK_TIENE_idx` (`CANDIDATA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finales`
--

LOCK TABLES `finales` WRITE;
/*!40000 ALTER TABLE `finales` DISABLE KEYS */;
INSERT INTO `finales` VALUES (1,4,1,1,'Votación Pública',100,15.00);
/*!40000 ALTER TABLE `finales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foto_candidata`
--

DROP TABLE IF EXISTS `foto_candidata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foto_candidata` (
  `FOTO_ID` int NOT NULL,
  `CANDIDATA_ID` int NOT NULL,
  `FOTO_DESCRIPCION` varchar(30) NOT NULL COMMENT 'Foto gala y tipico. Fotos generales de cada candidata',
  `FOTO_URL` varchar(40) NOT NULL,
  `FOTO_CARRUSEL_URL` varchar(255) NOT NULL COMMENT 'URL de la foto del carrusel para cada candidata',
  PRIMARY KEY (`FOTO_ID`),
  KEY `FK_DISPONE` (`CANDIDATA_ID`),
  CONSTRAINT `FK_DISPONE` FOREIGN KEY (`CANDIDATA_ID`) REFERENCES `candidata` (`CANDIDATA_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foto_candidata`
--

LOCK TABLES `foto_candidata` WRITE;
/*!40000 ALTER TABLE `foto_candidata` DISABLE KEYS */;
INSERT INTO `foto_candidata` VALUES (1,1,'FX','C:\\fakepath\\WEMRH.jpg','C:\\fakepath\\CARR_WEMRH.jpg'),(2,2,'FX','C:\\fakepath\\JDRPH.jpg','C:\\fakepath\\CARR_JDRPH.jpg'),(3,3,'FX','C:\\fakepath\\YNEPH.jpg','C:\\fakepath\\CARR_YNEPH.jpg'),(4,4,'FX','C:\\fakepath\\AGMVH.jpg','C:\\fakepath\\CARR_AGMVH.jpg'),(5,5,'FX','C:\\fakepath\\LSFOH.jpg','C:\\fakepath\\CARR_LSFOH.jpg'),(6,6,'FX','C:\\fakepath\\GNAEH.jpg','C:\\fakepath\\CARR_GNAEH.jpg'),(7,7,'FX','C:\\fakepath\\MDSPH.jpg','C:\\fakepath\\CARR_MDSPH.jpg'),(8,8,'FX','C:\\fakepath\\RADPH.jpg','C:\\fakepath\\CARR_RADPH.jpg'),(9,9,'FX','C:\\fakepath\\ADMMH.jpg','C:\\fakepath\\CARR_ADMMH.jpg'),(10,10,'FX','C:\\fakepath\\KBBMH.jpg','C:\\fakepath\\CARR_KBBMH.jpg'),(11,11,'FX','C:\\fakepath\\RAAAH.jpg','C:\\fakepath\\CARR_RAAAH.jpg'),(12,12,'FX','C:\\fakepath\\ENARH.jpg','C:\\fakepath\\CARR_ENARH.jpg');
/*!40000 ALTER TABLE `foto_candidata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puntajes_finales`
--

DROP TABLE IF EXISTS `puntajes_finales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `puntajes_finales` (
  `CANDIDATA_ID` int NOT NULL,
  `PUNTAJE_JUECES` decimal(10,2) DEFAULT '0.00',
  `PUNTAJE_PUBLICO` decimal(10,2) DEFAULT '0.00',
  `PUNTAJE_TOTAL` decimal(10,2) DEFAULT '0.00',
  `ULTIMA_ACTUALIZACION` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CANDIDATA_ID`),
  CONSTRAINT `puntajes_finales_ibfk_1` FOREIGN KEY (`CANDIDATA_ID`) REFERENCES `candidata` (`CANDIDATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `puntajes_finales`
--

LOCK TABLES `puntajes_finales` WRITE;
/*!40000 ALTER TABLE `puntajes_finales` DISABLE KEYS */;
/*!40000 ALTER TABLE `puntajes_finales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_features`
--

DROP TABLE IF EXISTS `user_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_features` (
  `user_id` int NOT NULL,
  `feature_name` varchar(50) NOT NULL,
  `enabled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`,`feature_name`),
  CONSTRAINT `user_features_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_features`
--

LOCK TABLES `user_features` WRITE;
/*!40000 ALTER TABLE `user_features` DISABLE KEYS */;
INSERT INTO `user_features` VALUES (6,'admin_eventos',1),(6,'tabla_notario',1),(6,'top_candidatas',1),(7,'admin_eventos',0),(7,'generar_reporte',0),(7,'tabla_notario',0),(7,'top_candidatas',0),(8,'admin_eventos',1),(8,'tabla_notario',1),(8,'top_candidatas',1),(9,'tabla_notario',1),(9,'top_candidatas',1);
/*!40000 ALTER TABLE `user_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ELECCION_ID` int DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `lastname` varchar(45) DEFAULT NULL,
  `rol` enum('juez','juezx','admin','notario','usuario','superadmin') NOT NULL,
  `activo` tinyint NOT NULL DEFAULT '0',
  `password_reset_token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_JUZGA_idx` (`ELECCION_ID`),
  CONSTRAINT `FK_JUZGA` FOREIGN KEY (`ELECCION_ID`) REFERENCES `eleccion` (`ELECCION_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Juez1',NULL,'$2a$10$F4IojLNcgsfQCwruggqgDe7GEyG4qmWXwdn94RfC0.XqxzKbeqT46','Flor','De Vela','juez',0,NULL),(2,1,'Juez2','','$2b$10$2TP1swb4BSCo/jztyYPe5eTyTtFyETH46/VVgMSQHc8i6JSQmt15q','Jaun','Pilicita','juez',0,NULL),(3,1,'Juez3',NULL,'$2a$10$IsxENTUmumv93Elw61AISeXSJASgV5aWNMinVhAYaBFWCVyQsbV0G','Juez3','Juez3','juezx',0,NULL),(4,1,'Juez4',NULL,'$2a$10$QqR6eG0ln.tIQTw8Y0bO0OSG56RDX6xhp8ADmckKSnt/HtS7jXBc6','Juez4','Juez4','juezx',0,NULL),(5,1,'Juez5',NULL,'$2a$10$iA6wDU48sc/uZHy2lgifPu8yqqRlMClDjVZrLH8.vKlDIbMNevksS','Juez5','Juez5','juezx',0,NULL),(6,1,'Veedor',NULL,'$2a$10$Tr3ifQmgZYwoZZtOCrpWcOz3jPiNOHTFnlPviy1kLiFWZAdXOxWSO','Marcelo','Mejía Mena','notario',0,NULL),(7,1,'admin','','admin','Dylan','Hernández','admin',0,'ld7k1esfw1'),(8,1,'luca','','$2a$10$6RpFCoR2MHDR0wAi7/f7OeNtlZ5gBXxEU62UZz4bgoOszNEjVHRPm','Luca','De Veintemilla','admin',0,NULL),(9,1,'juan','','$2a$10$r4vMi4U3tAnt/BEwDAda5OatG8DCfI3LbVEyXS7iWsSX2.1g1VIuW','Juan','Reyes','notario',0,NULL),(10,1,'kevin','','$2a$10$D71aXX4ggNlI50PHu.1Iver7lFlcYHJmSzLdU29Jmup.Gti2E.L9u','Kevin','Vargas','superadmin',0,'ld7k1esfw1'),(123,NULL,'kavargas7@espe.edu.ec','kavargas7@espe.edu.ec','$2a$10$Uxn1DK1J2rnLj3o6kXnVZeFDajXYMH.oi3HrsDtXXzC25PHAIT5la','Kevin ','Vargas ','usuario',0,NULL),(124,NULL,'bmmorales3@espe.edu.ec','bmmorales3@espe.edu.ec','$2a$10$MEWbGGW5FpjbauhwYvRzr.jQYd4bnKzYAlA5eKnRwE1McpOHvTdqe','Bryan','Morales','usuario',0,NULL),(125,NULL,'mrloachamin@espe.edu.ec','mrloachamin@espe.edu.ec','$2a$10$9w2zQf2cULbSv/I0Qd0XTelnBd9HCN5PdJDIyJRHWwa3M1B7FwQ/i','Mauricio ','Loachamin','usuario',0,NULL),(127,NULL,'superadmin','superadmin@espe.edu.ec','$2a$10$U7/66SR1vbH8Kfzs//DBhuAZEHJUq0x.MhMWVWuG5ZHqbEo/vlH42','Super','Admin','superadmin',0,NULL),(129,NULL,'mvmaldonado3@espe.edu.ec','mvmaldonado3@espe.edu.ec','$2a$10$B6G6Eimq3SsymRaC3AR6puvfBOMnVs0VWYKfa.hTLXeGHnz/rYFNy','Mile','Maldonado','usuario',0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_puntuaciones`
--

DROP TABLE IF EXISTS `vista_puntuaciones`;
/*!50001 DROP VIEW IF EXISTS `vista_puntuaciones`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_puntuaciones` AS SELECT 
 1 AS `CANDIDATA_ID`,
 1 AS `CAND_NOMBRE1`,
 1 AS `CAND_APELLIDOPATERNO`,
 1 AS `CAND_PUNTUACION_TOTAL`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `votaciones`
--

DROP TABLE IF EXISTS `votaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `votaciones` (
  `VOT_ID` int NOT NULL AUTO_INCREMENT,
  `USUARIO_ID` int NOT NULL,
  `EVENTO_ID` int NOT NULL,
  `CANDIDATA_ID` int NOT NULL,
  `VOT_ESTADO` enum('si','no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`VOT_ID`),
  UNIQUE KEY `unique_votacion` (`USUARIO_ID`,`EVENTO_ID`,`CANDIDATA_ID`),
  KEY `idx_votaciones_usuario_evento_candidata` (`USUARIO_ID`,`EVENTO_ID`,`CANDIDATA_ID`),
  KEY `idx_votaciones_usuario` (`USUARIO_ID`),
  KEY `idx_votaciones_candidata` (`CANDIDATA_ID`),
  KEY `idx_votaciones_evento` (`EVENTO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votaciones`
--

LOCK TABLES `votaciones` WRITE;
/*!40000 ALTER TABLE `votaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `votaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votaciones_publico`
--

DROP TABLE IF EXISTS `votaciones_publico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `votaciones_publico` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CANDIDATA_ID` int NOT NULL,
  `USUARIO_ID` int NOT NULL,
  `FECHA_VOTO` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `FK_VOTOPUB_CANDIDATA` (`CANDIDATA_ID`),
  KEY `FK_VOTOPUB_USUARIO` (`USUARIO_ID`),
  CONSTRAINT `FK_VOTOPUB_CANDIDATA` FOREIGN KEY (`CANDIDATA_ID`) REFERENCES `candidata` (`CANDIDATA_ID`),
  CONSTRAINT `FK_VOTOPUB_USUARIO` FOREIGN KEY (`USUARIO_ID`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votaciones_publico`
--

LOCK TABLES `votaciones_publico` WRITE;
/*!40000 ALTER TABLE `votaciones_publico` DISABLE KEYS */;
INSERT INTO `votaciones_publico` VALUES (1,1,129,'2025-02-13 18:56:55'),(2,1,125,'2025-02-13 18:57:00');
/*!40000 ALTER TABLE `votaciones_publico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `vista_puntuaciones`
--

/*!50001 DROP VIEW IF EXISTS `vista_puntuaciones`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_puntuaciones` AS select `c`.`CANDIDATA_ID` AS `CANDIDATA_ID`,`c`.`CAND_NOMBRE1` AS `CAND_NOMBRE1`,`c`.`CAND_APELLIDOPATERNO` AS `CAND_APELLIDOPATERNO`,((select coalesce(sum(`cal`.`CALIFICACION_VALOR`),0) from `calificacion` `cal` where ((`cal`.`CANDIDATA_ID` = `c`.`CANDIDATA_ID`) and (`cal`.`EVENTO_ID` in (1,2,3)))) + coalesce((select sum(`f`.`CALIFICACION_VALOR`) from `finales` `f` where (`f`.`CANDIDATA_ID` = `c`.`CANDIDATA_ID`)),0)) AS `CAND_PUNTUACION_TOTAL` from `candidata` `c` group by `c`.`CANDIDATA_ID` order by `CAND_PUNTUACION_TOTAL` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-14 10:40:42
