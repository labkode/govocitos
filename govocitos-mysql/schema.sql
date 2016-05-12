-- phpMyAdmin SQL Dump
-- version 4.0.6deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 12, 2016 at 02:40 PM
-- Server version: 5.5.35-0ubuntu0.13.10.2
-- PHP Version: 5.5.3-1ubuntu2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `detepre`
--
CREATE DATABASE IF NOT EXISTS `detepre` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `detepre`;

-- --------------------------------------------------------

--
-- Table structure for table `campanhas`
--

DROP TABLE IF EXISTS `campanhas`;
CREATE TABLE IF NOT EXISTS `campanhas` (
  `codigo_campanha` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Del estilo lugar-año (Ej.- gl-04)',
  `descripcion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Descripción de la campaña',
  PRIMARY KEY (`codigo_campanha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `campanhas`
--

INSERT INTO `campanhas` (`codigo_campanha`, `descripcion`) VALUES
('gl-03', 'Galicia lonja 2003 IIM'),
('gl-05', 'Galicia lonja 2005 IIM'),
('gl-06', 'Galicia lonja 2006 IIM'),
('gl-10', 'Galicia lonja 2010 IIM'),
('ID209', 'Mediterráneo');

-- --------------------------------------------------------

--
-- Table structure for table `clases`
--

DROP TABLE IF EXISTS `clases`;
CREATE TABLE IF NOT EXISTS `clases` (
  `codigo_clase` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'El nombre de la clase',
  `descripcion` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Descripción de la clase',
  PRIMARY KEY (`codigo_clase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `clases`
--

INSERT INTO `clases` (`codigo_clase`, `nombre`, `descripcion`) VALUES
('cn', 'cell with visible nucleus', 'cell with visible nucleus'),
('sn', 'cell without visible nucleus', 'cell without visible nucleus');

-- --------------------------------------------------------

--
-- Table structure for table `especies`
--

DROP TABLE IF EXISTS `especies`;
CREATE TABLE IF NOT EXISTS `especies` (
  `codigo_especie` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `scherle` float DEFAULT '1' COMMENT 'Factor de conversión de peso en volumen',
  `uno_beta` float DEFAULT '1' COMMENT 'Factor de corrección del perfil de los ovocitos',
  `formol_fresco_a` float DEFAULT '1' COMMENT 'Coeficiente de relación entre peso fresco y peso en formol de los ovarios',
  `formol_fresco_b` float DEFAULT '1' COMMENT 'Coeficiente de relación entre peso fresco y peso en formol de los ovarios',
  `diametro_min` float DEFAULT NULL COMMENT 'Diametro minimo para la deteccion automatica de bordes',
  `diametro_max` float DEFAULT NULL COMMENT 'Diametro maximo para la deteccion automatica de bordes',
  `umbral_redondez` float DEFAULT NULL COMMENT 'Umbral maximo de redondez admitido para la deteccion automatica de bordes, segun R=(per^2)/(4 pi area 1.064)',
  `path_datos_clasificador` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Ruta del fichero con los datos que el clasificador de la especie utiliza',
  PRIMARY KEY (`codigo_especie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `especies`
--

INSERT INTO `especies` (`codigo_especie`, `nombre`, `scherle`, `uno_beta`, `formol_fresco_a`, `formol_fresco_b`, `diametro_min`, `diametro_max`, `umbral_redondez`, `path_datos_clasificador`) VALUES
('Bg', 'Benthosema glaciale', 0.93, 0.72, 1, 1, NULL, NULL, NULL, './uploadedFiles/clasificador/'),
('lrt', 'Labrus bergylta', 0.93, 0.72, 1, 1, NULL, NULL, NULL, './uploadedFiles/clasificador/'),
('mz', 'Merluccius merluccius', 0.9263, 0.72, 1, 1, NULL, NULL, NULL, './uploadedFiles/clasificador/'),
('tl', 'Trisopterus luscus', 0.9342, 0.72, 1.0393, 1, NULL, NULL, NULL, './uploadedFiles/clasificador/');

-- --------------------------------------------------------

--
-- Table structure for table `especies_capturadas`
--

DROP TABLE IF EXISTS `especies_capturadas`;
CREATE TABLE IF NOT EXISTS `especies_capturadas` (
  `codigo_campanha` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia a la campaña para ese muestreo',
  `codigo_especie` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia a la especie capturada en ese muestreo de esa campaña',
  PRIMARY KEY (`codigo_campanha`,`codigo_especie`),
  KEY `fk_campanhas` (`codigo_campanha`),
  KEY `fk_especies` (`codigo_especie`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene las especies capturadas en cada muestreo de cada ca';

--
-- Dumping data for table `especies_capturadas`
--

INSERT INTO `especies_capturadas` (`codigo_campanha`, `codigo_especie`) VALUES
('ID209', 'Bg'),
('gl-10', 'lrt'),
('gl-03', 'mz'),
('gl-05', 'tl'),
('gl-06', 'tl');

-- --------------------------------------------------------

--
-- Table structure for table `estados_madurez`
--

DROP TABLE IF EXISTS `estados_madurez`;
CREATE TABLE IF NOT EXISTS `estados_madurez` (
  `codigo_estado_madurez` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(75) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nombre del estado de madurez',
  `descripcion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Descripción del estado de madurez',
  PRIMARY KEY (`codigo_estado_madurez`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `estados_madurez`
--

INSERT INTO `estados_madurez` (`codigo_estado_madurez`, `nombre`, `descripcion`) VALUES
('ac', 'cortical alveoli', 'cortical alveoli'),
('atre', 'atretic', 'general atresia'),
('hid', 'hydrated', 'hydrated'),
('vit', 'vitelogenic', 'general vitelogenesis');

-- --------------------------------------------------------

--
-- Table structure for table `factores_correccion`
--

DROP TABLE IF EXISTS `factores_correccion`;
CREATE TABLE IF NOT EXISTS `factores_correccion` (
  `codigo_especie` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'El código de la especie',
  `rango` bigint(5) NOT NULL COMMENT 'El rango para el factor de correccion (valor inicial del rango, en saltos de 25 micras)',
  `factor` float DEFAULT NULL COMMENT 'Factor de correccion',
  PRIMARY KEY (`codigo_especie`,`rango`),
  KEY `fk_especie_fc` (`codigo_especie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `factores_correccion`
--

INSERT INTO `factores_correccion` (`codigo_especie`, `rango`, `factor`) VALUES
('Bg', 0, 1),
('Bg', 25, 1),
('Bg', 50, 3.93905),
('Bg', 75, 2.98937),
('Bg', 100, 2.45794),
('Bg', 125, 2.11171),
('Bg', 150, 1.86534),
('Bg', 175, 1.67961),
('Bg', 200, 1.53373),
('Bg', 225, 1.41562),
('Bg', 250, 1.31769),
('Bg', 275, 1.23495),
('Bg', 300, 1.16396),
('Bg', 325, 1.10226),
('Bg', 350, 1.04806),
('Bg', 375, 1),
('Bg', 400, 1),
('Bg', 425, 1),
('Bg', 450, 1),
('Bg', 475, 1),
('Bg', 500, 1),
('Bg', 525, 1),
('Bg', 550, 1),
('Bg', 575, 1),
('Bg', 600, 1),
('Bg', 625, 1),
('Bg', 650, 1),
('Bg', 675, 1),
('Bg', 700, 1),
('Bg', 725, 1),
('Bg', 750, 1),
('Bg', 775, 1),
('Bg', 800, 1),
('Bg', 825, 1),
('Bg', 850, 1),
('Bg', 875, 1),
('Bg', 900, 1),
('Bg', 925, 1),
('Bg', 950, 1),
('Bg', 975, 1),
('Bg', 1000, 1),
('lrt', 125, 2.92024),
('lrt', 150, 2.63301),
('lrt', 175, 2.41231),
('lrt', 200, 2.23614),
('lrt', 225, 2.09146),
('lrt', 250, 1.96999),
('lrt', 275, 1.8662),
('lrt', 300, 1.77622),
('lrt', 325, 1.69729),
('lrt', 350, 1.62734),
('lrt', 375, 1.56481),
('lrt', 400, 1.5085),
('lrt', 425, 1.45744),
('lrt', 450, 1.4109),
('lrt', 475, 1.36823),
('lrt', 500, 1.32895),
('lrt', 525, 1.29263),
('lrt', 550, 1.25893),
('lrt', 575, 1.22755),
('lrt', 600, 1.19824),
('lrt', 625, 1.17078),
('lrt', 650, 1.14499),
('lrt', 675, 1.12071),
('lrt', 700, 1.0978),
('lrt', 725, 1.07614),
('lrt', 750, 1.05562),
('lrt', 775, 1.03614),
('lrt', 825, 1);

-- --------------------------------------------------------

--
-- Table structure for table `imagenes`
--

DROP TABLE IF EXISTS `imagenes`;
CREATE TABLE IF NOT EXISTS `imagenes` (
  `codigo_campanha` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia al código de la campaña del individuo al que pertenece la imagen',
  `codigo_especie` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Código de la espece del individuo a la que pertenece la imagen',
  `codigo_muestreo` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Codigo del muestreo al que pertenece el individuo de esta imagen',
  `codigo_individuo` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia al código del individuo al que pertenece la imagen',
  `codigo_imagen` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `protocolo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Clave foránea que determina el protocolo seguido',
  `tincion` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Tipo de tinción histológica utilizado en la imagen analizada',
  `magnificacion` float DEFAULT NULL COMMENT 'Aumentos utilizados para capturar la imagen en el microscopio',
  `calibracion` float DEFAULT '0' COMMENT 'Número de micras equivalentes a un pixel en la imagen',
  `calibracion_boolean` tinyint(1) NOT NULL COMMENT 'Indica si el valor de la calibración es correcto o por el contrario su valor no fue introducido (es este caso su valor es 0 por defecto)',
  `path_original` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Path de la imagen original en el disco',
  `luminosidad` float DEFAULT NULL COMMENT 'Nivel de gris de cada pixel',
  `filtro` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Nombre del filtro aplicado en la imagen',
  `tipo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Tipo de imagen',
  `filas` smallint(6) DEFAULT NULL COMMENT 'Número de filas de la imagen',
  `columnas` smallint(6) DEFAULT NULL COMMENT 'Número de columnas de la imagen',
  `bits` tinyint(4) DEFAULT NULL COMMENT 'Número de bits dedicados a cada pixel',
  `path_ovocitos` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML que contiene los contornos de los ovocitos',
  `path_xml_paso_1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML 1 que contiene los contornos de los ovocitos',
  `path_xml_paso_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML 2 que contiene los contornos de los ovocitos',
  `path_xml_paso_3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML 3 que contiene los contornos de los ovocitos',
  `path_xml_paso_4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML 4 que contiene los contornos de los ovocitos',
  `path_xml_paso_5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path al fichero XML 5 que contiene los contornos de los ovocitos',
  `fichero_inf` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Fichero .inf con información adicional de la imagen',
  `md5` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'MD5 code of the image',
  PRIMARY KEY (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`,`codigo_individuo`,`codigo_imagen`),
  KEY `fk_protocolo` (`protocolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `imagenes`
--

INSERT INTO `imagenes` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`, `codigo_imagen`, `protocolo`, `tincion`, `magnificacion`, `calibracion`, `calibracion_boolean`, `path_original`, `luminosidad`, `filtro`, `tipo`, `filas`, `columnas`, `bits`, `path_ovocitos`, `path_xml_paso_1`, `path_xml_paso_2`, `path_xml_paso_3`, `path_xml_paso_4`, `path_xml_paso_5`, `fichero_inf`, `md5`) VALUES
('gl-03', 'mz', '19', '25', 'a', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-19-25a.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-19-25a.xml', './uploadedFiles/imagenes/gl-03-mz-19-25a-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-19-25a-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-19-25a-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-19-25a-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-19-25a-XML5.xml', NULL, '4dac53fa44201e0b67aeb3fa4167829a'),
('gl-03', 'mz', '19', '25', 'b', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-19-25b.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-19-25b.xml', './uploadedFiles/imagenes/gl-03-mz-19-25b-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-19-25b-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-19-25b-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-19-25b-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-19-25b-XML5.xml', NULL, '7a0e85664896898ae1a2d0d6cd89b2cb'),
('gl-03', 'mz', '19', '25', 'c', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-19-25c.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-19-25c.xml', './uploadedFiles/imagenes/gl-03-mz-19-25c-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-19-25c-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-19-25c-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-19-25c-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-19-25c-XML5.xml', NULL, '1f73645719b6580e0d690474cc43e21a'),
('gl-03', 'mz', '19', '25', 'd', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-19-25d.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-19-25d.xml', './uploadedFiles/imagenes/gl-03-mz-19-25d-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-19-25d-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-19-25d-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-19-25d-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-19-25d-XML5.xml', NULL, '27fefe3856d650df5627c1f6b5c38acf'),
('gl-03', 'mz', '5', '35', 'a', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-5-35a.JPG', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-5-35a.xml', './uploadedFiles/imagenes/gl-03-mz-5-35a-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-5-35a-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-5-35a-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-5-35a-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-5-35a-XML5.xml', NULL, '5b0336bbc647245837251a7529313754'),
('gl-03', 'mz', '5', '35', 'b', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-5-35b.JPG', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-5-35b.xml', './uploadedFiles/imagenes/gl-03-mz-5-35b-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-5-35b-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-5-35b-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-5-35b-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-5-35b-XML5.xml', NULL, 'ff5f940514ac63835f17ea20006d780d'),
('gl-03', 'mz', '5', '35', 'c', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-5-35c.JPG', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-5-35c.xml', './uploadedFiles/imagenes/gl-03-mz-5-35c-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-5-35c-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-5-35c-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-5-35c-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-5-35c-XML5.xml', NULL, 'a04a808a04672e48e4b21ba1cad52768'),
('gl-03', 'mz', '5', '35', 'd', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-03-mz-5-35d.JPG', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-03-mz-5-35d.xml', './uploadedFiles/imagenes/gl-03-mz-5-35d-XML1.xml', './uploadedFiles/imagenes/gl-03-mz-5-35d-XML2.xml', './uploadedFiles/imagenes/gl-03-mz-5-35d-XML3.xml', './uploadedFiles/imagenes/gl-03-mz-5-35d-XML4.xml', './uploadedFiles/imagenes/gl-03-mz-5-35d-XML5.xml', NULL, '72bcc1495cd1d1b50b2fbd328af62133'),
('gl-05', 'tl', '18', '6', 'a', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-05-tl-18-6-a.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-05-tl-18-6-a.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a-XML1.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a-XML2.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a-XML3.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a-XML4.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a-XML5.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-a.inf', '619ec0aa5c73ac8e8e9e97cd29e44455'),
('gl-05', 'tl', '18', '6', 'b', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-05-tl-18-6-b.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-05-tl-18-6-b.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b-XML1.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b-XML2.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b-XML3.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b-XML4.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b-XML5.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-b.inf', '108f06a5c6514cae15f49766765b0e5c'),
('gl-05', 'tl', '18', '6', 'c', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-05-tl-18-6-c.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-05-tl-18-6-c.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c-XML1.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c-XML2.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c-XML3.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c-XML4.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c-XML5.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-c.inf', 'f237a85f76eeee4eb0354bb58fe2c07f'),
('gl-05', 'tl', '18', '6', 'd', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-05-tl-18-6-d.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-05-tl-18-6-d.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d-XML1.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d-XML2.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d-XML3.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d-XML4.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d-XML5.xml', './uploadedFiles/imagenes/gl-05-tl-18-6-d.inf', '1bc7c2ff78a9f503f4a0897af0554df9'),
('gl-06', 'tl', '32', '3', 'a', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-06-tl-32-3-a.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-06-tl-32-3-a.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a-XML1.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a-XML2.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a-XML3.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a-XML4.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a-XML5.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-a.inf', 'a9693c213fc8dc450934b44045a2d4a7'),
('gl-06', 'tl', '32', '3', 'b', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-06-tl-32-3-b.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-06-tl-32-3-b.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b-XML1.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b-XML2.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b-XML3.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b-XML4.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b-XML5.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-b.inf', '78b654ac9865b2f8eb3878896db1bb99'),
('gl-06', 'tl', '32', '3', 'c', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-06-tl-32-3-c.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-06-tl-32-3-c.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c-XML1.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c-XML2.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c-XML3.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c-XML4.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c-XML5.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-c.inf', '547f03c5f47822da59e98a63e94d3bb4'),
('gl-06', 'tl', '32', '3', 'd', 'HE', NULL, NULL, 1.09524, 1, './uploadedFiles/imagenes/gl-06-tl-32-3-d.tif', NULL, NULL, NULL, 1550, 2088, NULL, './uploadedFiles/imagenes/gl-06-tl-32-3-d.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d-XML1.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d-XML2.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d-XML3.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d-XML4.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d-XML5.xml', './uploadedFiles/imagenes/gl-06-tl-32-3-d.inf', 'f9a5f6b61d96571e0fb1bde94afb85f6'),
('ID209', 'Bg', '09', '191', 'a', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/191_50a.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/191_50a.xml', './uploadedFiles/imagenes/191_50a-XML1.xml', './uploadedFiles/imagenes/191_50a-XML2.xml', './uploadedFiles/imagenes/191_50a-XML3.xml', './uploadedFiles/imagenes/191_50a-XML4.xml', './uploadedFiles/imagenes/191_50a-XML5.xml', NULL, 'eafa9cad7384fc623d03bb8c5f14e382'),
('ID209', 'Bg', '09', '191', 'b', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/191_50b.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/191_50b.xml', './uploadedFiles/imagenes/191_50b-XML1.xml', './uploadedFiles/imagenes/191_50b-XML2.xml', './uploadedFiles/imagenes/191_50b-XML3.xml', NULL, NULL, NULL, '6a71218c1c06012a772473e027643247'),
('ID209', 'Bg', '09', '191', 'c', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/191_50c.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/191_50c.xml', './uploadedFiles/imagenes/191_50c-XML1.xml', './uploadedFiles/imagenes/191_50c-XML2.xml', './uploadedFiles/imagenes/191_50c-XML3.xml', NULL, NULL, NULL, '6778605133c93e9e567c25f0a4a75516'),
('ID209', 'Bg', '09', '191', 'd', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/191_50d.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/191_50d.xml', './uploadedFiles/imagenes/191_50d-XML1.xml', './uploadedFiles/imagenes/191_50d-XML2.xml', './uploadedFiles/imagenes/191_50d-XML3.xml', NULL, NULL, NULL, 'cac489a93e51a675c7a5792d48c7feb2'),
('ID209', 'Bg', '09', '195', 'a', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/195_50a.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/195_50a.xml', './uploadedFiles/imagenes/195_50a-XML1.xml', './uploadedFiles/imagenes/195_50a-XML2.xml', './uploadedFiles/imagenes/195_50a-XML3.xml', NULL, NULL, NULL, 'cae5d06ebf598955c69a2fa6d742f95a'),
('ID209', 'Bg', '09', '195', 'b', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/195_50b.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/195_50b.xml', './uploadedFiles/imagenes/195_50b-XML1.xml', './uploadedFiles/imagenes/195_50b-XML2.xml', './uploadedFiles/imagenes/195_50b-XML3.xml', NULL, NULL, NULL, '52a92f161c68f5f58bc23785b859e41a'),
('ID209', 'Bg', '09', '195', 'c', NULL, 'MY', 5, 0.657143, 1, './uploadedFiles/imagenes/195_50c.tif', NULL, NULL, NULL, 2325, 3132, NULL, './uploadedFiles/imagenes/195_50c.xml', './uploadedFiles/imagenes/195_50c-XML1.xml', './uploadedFiles/imagenes/195_50c-XML2.xml', './uploadedFiles/imagenes/195_50c-XML3.xml', NULL, NULL, NULL, 'da2811e78b79e7dac16630db3019f4bd');

-- --------------------------------------------------------

--
-- Table structure for table `individuos`
--

DROP TABLE IF EXISTS `individuos`;
CREATE TABLE IF NOT EXISTS `individuos` (
  `codigo_campanha` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Código de la campaña a la que pertenece el individuo',
  `codigo_especie` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Codigo de la especie a la que pertenece el individuo',
  `codigo_muestreo` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Codigo de muestreo al que pertenece el individuo',
  `codigo_individuo` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `talla` double DEFAULT NULL COMMENT 'Longitud total del individuo analizado',
  `peso_total` double DEFAULT NULL COMMENT 'Peso total del individuo analizado',
  `peso_eviscerado` double DEFAULT NULL COMMENT 'Peso del individuo después de extraer las vísceras y las gónadas',
  `sexo` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Valores macho o hembra. Valor NULL el individuo es indeterminado',
  `estado_madurez` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Estado de desarrollo de la gónada determinado por histología',
  `peso_gonadas_fresco` double DEFAULT NULL COMMENT 'Peso total de las dos gónadas en fresco',
  `peso_gonadas_formol` double DEFAULT NULL COMMENT 'Peso total de las dos gónadas en formol',
  `peso_higado` double DEFAULT NULL COMMENT 'Peso total del hígado en fresco',
  PRIMARY KEY (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`,`codigo_individuo`),
  KEY `imagenes.fk_individuos` (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`,`codigo_individuo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `individuos`
--

INSERT INTO `individuos` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`, `talla`, `peso_total`, `peso_eviscerado`, `sexo`, `estado_madurez`, `peso_gonadas_fresco`, `peso_gonadas_formol`, `peso_higado`) VALUES
('gl-03', 'mz', '19', '25', 55, 1286.4, 1109.8, '2', 'rc', 15.62, 15.334752, 45),
('gl-03', 'mz', '5', '35', 60, 1498, 1228, '2', 'as', 157.61, 155.848056, 71.83),
('gl-05', 'tl', '18', '6', 26.8, 231.92, 189.45, '2', 'as', 18.17, NULL, 9.8),
('gl-06', 'tl', '32', '3', 36, 667.75, 535.58, '2', 'as', 32.2, NULL, 56.46),
('gl-10', 'lrt', '3', '23', 39.9, 1102.41, 988.99, '2', NULL, 38.16, 38.698056, 16.85),
('gl-10', 'lrt', '8', '2', 33, 653.92, 591.27, '2', NULL, 36.24, 36.750984, 8.21),
('ID209', 'Bg', '09', '191', 3.3, NULL, NULL, 'Female', NULL, 0.0245, 0.0245, NULL),
('ID209', 'Bg', '09', '195', 3.7, NULL, NULL, 'Female', NULL, 0.0194, 0.0194, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `individuos_fecundidad`
--

DROP TABLE IF EXISTS `individuos_fecundidad`;
CREATE TABLE IF NOT EXISTS `individuos_fecundidad` (
  `codigo_campanha` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia a la campaña del individuo',
  `codigo_especie` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia a la especie del individuo',
  `codigo_muestreo` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia al muestreo del individuo',
  `codigo_individuo` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia al individuo',
  `codigo_rejilla` smallint(6) NOT NULL COMMENT 'Clave foránea que hace referencia a la rejilla',
  `codigo_estado_madurez` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave foránea que hace referencia al estado de madurez',
  `fecundidad` float NOT NULL COMMENT 'Resultado de la fecundidad para un estado de madurez y un individuo',
  `fecha_fecundidad` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora en la que se realizó el cálculo de la fecundidad',
  `K` float DEFAULT '1' COMMENT 'Factor de corrección para la distribución de tallas',
  `metodo` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Método utilizado para el cálculo de K (lupa o histología)',
  `imgs_usadas` smallint(6) DEFAULT NULL COMMENT 'Número de imágenes usadas para el cálculo de fecundidad',
  PRIMARY KEY (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`,`codigo_individuo`,`codigo_rejilla`,`codigo_estado_madurez`),
  KEY `fk_estado_madurez` (`codigo_estado_madurez`),
  KEY `fk_rejilla` (`codigo_rejilla`),
  KEY `fk_individuo` (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`,`codigo_individuo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `individuos_fecundidad`
--

INSERT INTO `individuos_fecundidad` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`, `codigo_rejilla`, `codigo_estado_madurez`, `fecundidad`, `fecha_fecundidad`, `K`, `metodo`, `imgs_usadas`) VALUES
('gl-03', 'mz', '19', '25', 17, 'ac', 694576, '2013-11-13 16:16:39', 1.0749, 'Hist', 4),
('gl-03', 'mz', '19', '25', 17, 'atre', 142571, '2013-11-13 16:16:39', 1.0749, 'Hist', 4),
('gl-03', 'mz', '5', '35', 17, 'ac', 1374430, '2013-11-15 09:01:41', 1.18366, 'Hist', 4);

-- --------------------------------------------------------

--
-- Table structure for table `internal_images`
--

DROP TABLE IF EXISTS `internal_images`;
CREATE TABLE IF NOT EXISTS `internal_images` (
  `name` varchar(20) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `path` varchar(200) DEFAULT NULL,
  `link` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `internal_images`
--

INSERT INTO `internal_images` (`name`, `description`, `type`, `path`, `link`) VALUES
('csic.png', 'CSIC', 'sponsor', './uploadedFiles/csic.png', 'http://www.csic.es/'),
('iim_logo.jpg', 'IIM-CSIC', 'sponsor', './uploadedFiles/iim_logo.jpg', 'http://www.iim.csic.es/'),
('logo_lia.png', 'LIA2', 'sponsor', './uploadedFiles/logo_lia.png', 'http://lia.ei.uvigo.es'),
('Detepre.png', 'DETEPRE', 'logo', './uploadedFiles/Detepre.png', 'http://lia.ei.uvigo.es/projects/gonadas/detepre.html'),
('uvigo.png', 'UVIGO', 'sponsor', './uploadedFiles/uvigo.png', 'http://www.uvigo.es'),
('usc.PNG', 'USC', 'sponsor', './uploadedFiles/usc.PNG', 'http://www.usc.es'),
('xunta.png', 'XUNTA', 'sponsor', './uploadedFiles/xunta.png', 'http://www.conselleriaiei.org/');

-- --------------------------------------------------------

--
-- Table structure for table `internal_users`
--

DROP TABLE IF EXISTS `internal_users`;
CREATE TABLE IF NOT EXISTS `internal_users` (
  `login` varchar(20) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `rol` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `internal_users`
--

INSERT INTO `internal_users` (`login`, `password`, `rol`) VALUES
('root', '8b75b745554ae61710e741cd4cba5626', 'superadmin'),
('operator', 'ffb7ffeef9815e06580d7278eb8c12fa', 'operator'),
('guest', '084e0343a0486ff05530df6c705c8bb4', 'guest');

-- --------------------------------------------------------

--
-- Table structure for table `muestreos`
--

DROP TABLE IF EXISTS `muestreos`;
CREATE TABLE IF NOT EXISTS `muestreos` (
  `codigo_campanha` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Se corresponde con el código de campaña de la muestra',
  `codigo_especie` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Codigo de la especie capturada en ese muestreo',
  `codigo_muestreo` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'El código de la muestra dentro de la campaña',
  `muestreador` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Nombre de la persona que realizó el muestreo',
  `puerto` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Nombre del puerto del que proceden las muestras',
  `latitud` float DEFAULT NULL COMMENT 'Latitud del punto de muestreo',
  `longitud` float DEFAULT NULL COMMENT 'Longitud del punto de muestreo',
  `fecha` varchar(22) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Fecha y hora en la que se realizó el muestreo',
  PRIMARY KEY (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`),
  KEY `fk_especies_capturadas` (`codigo_campanha`,`codigo_especie`),
  KEY `individuos.fk_muestreos` (`codigo_campanha`,`codigo_especie`,`codigo_muestreo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `muestreos`
--

INSERT INTO `muestreos` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `muestreador`, `puerto`, `latitud`, `longitud`, `fecha`) VALUES
('gl-03', 'mz', '19', 'Loli-María', 'LAXE', NULL, NULL, '2003-05-19 00:00:00'),
('gl-03', 'mz', '5', 'María-Mima', 'CELEIRO', NULL, NULL, '2003-02-03 00:00:00'),
('gl-05', 'tl', '18', 'Alex-Mariña', 'Ribeira', NULL, NULL, '2005-01-20 00:00:00'),
('gl-06', 'tl', '32', 'Alex', 'Ribeira', NULL, NULL, '2006-01-09 05:00:00'),
('gl-10', 'lrt', '3', 'David-Rosa-Iván', NULL, NULL, NULL, '2010-01-18 00:00:00'),
('gl-10', 'lrt', '8', 'David-Sonia-Mariña', NULL, NULL, NULL, '2010-03-01 00:00:00'),
('ID209', 'Bg', '09', 'Eva', NULL, NULL, NULL, '2009-12-00 00:00');

-- --------------------------------------------------------

--
-- Table structure for table `protocolos`
--

DROP TABLE IF EXISTS `protocolos`;
CREATE TABLE IF NOT EXISTS `protocolos` (
  `protocolo` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Clave primaria de la tabla. Es el nombre identificativo del protocolo',
  `descripcion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Breve descripción del protocolo',
  `fichero_detalles` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Fichero que contiene información detallada del protocolo, a saber, pasos, tiempos, etc',
  PRIMARY KEY (`protocolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Lista de protocolos aplicados sobre imagenes';

--
-- Dumping data for table `protocolos`
--

INSERT INTO `protocolos` (`protocolo`, `descripcion`, `fichero_detalles`) VALUES
('HE', 'hematoxilin-eosin', './uploadedFiles/protocolos/hematoxylin-eosin.doc');

-- --------------------------------------------------------

--
-- Table structure for table `rejillas`
--

DROP TABLE IF EXISTS `rejillas`;
CREATE TABLE IF NOT EXISTS `rejillas` (
  `codigo_rejilla` smallint(6) NOT NULL AUTO_INCREMENT,
  `puntos_fila` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Número de puntos por fila en la rejilla',
  `puntos_columna` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Número de puntos por columna en la rejilla',
  `distancia` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Distancia en micras entre los puntos de la rejilla',
  PRIMARY KEY (`codigo_rejilla`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=26 ;

--
-- Dumping data for table `rejillas`
--

INSERT INTO `rejillas` (`codigo_rejilla`, `puntos_fila`, `puntos_columna`, `distancia`) VALUES
(1, 12, 14, 125),
(2, 14, 12, 110),
(3, 18, 12, 160),
(4, 16, 16, 30),
(5, 137, 160, 13),
(6, 1550, 2088, 1),
(7, 357, 417, 5),
(8, 40, 25, 180),
(9, 26, 25, 180),
(10, 35, 40, 51),
(11, 25, 30, 69),
(12, 40, 34, 180),
(13, 26, 34, 180),
(14, 14, 16, 125),
(15, 894, 1044, 2),
(16, 12, 14, 190),
(17, 9, 11, 180),
(18, 4176, 6200, 1),
(19, 6264, 4650, 1),
(20, 2325, 3132, 1),
(21, 14, 17, 180),
(22, 6264, 6200, 1),
(23, 3132, 2325, 1),
(24, 8, 11, 180),
(25, 12, 14, 140);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `especies_capturadas`
--
ALTER TABLE `especies_capturadas`
  ADD CONSTRAINT `especies_capturadas_ibfk_1` FOREIGN KEY (`codigo_especie`) REFERENCES `especies` (`codigo_especie`),
  ADD CONSTRAINT `especies_capturadas_ibfk_4` FOREIGN KEY (`codigo_campanha`) REFERENCES `campanhas` (`codigo_campanha`);

--
-- Constraints for table `factores_correccion`
--
ALTER TABLE `factores_correccion`
  ADD CONSTRAINT `fk_especie_fc` FOREIGN KEY (`codigo_especie`) REFERENCES `especies` (`codigo_especie`) ON UPDATE CASCADE;

--
-- Constraints for table `imagenes`
--
ALTER TABLE `imagenes`
  ADD CONSTRAINT `imagenes_ibfk_1` FOREIGN KEY (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`) REFERENCES `individuos` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`);

--
-- Constraints for table `individuos`
--
ALTER TABLE `individuos`
  ADD CONSTRAINT `individuos_ibfk_1` FOREIGN KEY (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`) REFERENCES `muestreos` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`);

--
-- Constraints for table `individuos_fecundidad`
--
ALTER TABLE `individuos_fecundidad`
  ADD CONSTRAINT `individuos_fecundidad_ibfk_1` FOREIGN KEY (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`) REFERENCES `individuos` (`codigo_campanha`, `codigo_especie`, `codigo_muestreo`, `codigo_individuo`),
  ADD CONSTRAINT `individuos_fecundidad_ibfk_2` FOREIGN KEY (`codigo_estado_madurez`) REFERENCES `estados_madurez` (`codigo_estado_madurez`),
  ADD CONSTRAINT `individuos_fecundidad_ibfk_3` FOREIGN KEY (`codigo_rejilla`) REFERENCES `rejillas` (`codigo_rejilla`);

--
-- Constraints for table `muestreos`
--
ALTER TABLE `muestreos`
  ADD CONSTRAINT `muestreos_ibfk_1` FOREIGN KEY (`codigo_campanha`, `codigo_especie`) REFERENCES `especies_capturadas` (`codigo_campanha`, `codigo_especie`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
