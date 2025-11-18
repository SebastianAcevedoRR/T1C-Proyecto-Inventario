-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-11-2025 a las 15:47:44
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbfarmacia`
--
CREATE DATABASE IF NOT EXISTS `dbfarmacia` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `dbfarmacia`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ActualizarCompraEstado`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarCompraEstado` (IN `pidcompra` INT, IN `pestado` VARCHAR(20))   BEGIN
		UPDATE compra SET
			Estado=pestado
		WHERE idCompra = pidcompra;
	END$$

DROP PROCEDURE IF EXISTS `ActualizarProductoStock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarProductoStock` (IN `pidProducto` INT, IN `pstock` DECIMAL(8,2))   BEGIN
		UPDATE producto SET
			Stock=pstock
		WHERE idProducto = pidproducto;
	END$$

DROP PROCEDURE IF EXISTS `ActualizarVentaEstado`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarVentaEstado` (IN `pidventa` INT, IN `pestado` VARCHAR(20))   BEGIN
		UPDATE ventas SET
			Estado=pestado
		WHERE idventa = pidventa;
	END$$

DROP PROCEDURE IF EXISTS `BuscarProductos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarProductos` (IN `criterio` VARCHAR(30), IN `Prod` VARCHAR(20))   BEGIN
	IF criterio='Buscar' THEN
		SELECT p.idProducto,pr.Descripcion AS presentacion,p.Descripcion,p.Concentracion,p.Stock,p.Costo,p.Precio_Venta,p.FechaVencimiento,p.RegistroSanitario,l.Nombre as laboratorio,p.Estado
		
		FROM producto AS p INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
        INNER JOIN laboratorio AS l ON p.idLaboratorio=l.idLaboratorio
		WHERE p.Descripcion LIKE CONCAT("%",Prod,"%");
        END IF;
	END$$

DROP PROCEDURE IF EXISTS `ComprasPorFecha`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ComprasPorFecha` (IN `criterio` VARCHAR(30), IN `fechaIni` DATE, IN `fechaFin` DATE)   BEGIN
		IF criterio = "Buscar" THEN
			SELECT c.idCompra,p.Nombre AS proveedor,c.Fecha,CONCAT(e.Nombres," ",e.Apellidos) AS empleado,tc.Descripcion AS tipocomprobante,c.Numero,
			c.Estado,c.Total  FROM compra AS c
			INNER JOIN proveedor AS p ON c.idProveedor=p.IdProveedor
			INNER JOIN empleado AS e ON c.idEmpleado=e.idEmpleado
            INNER JOIN tipocomprobante AS tc ON c.idTipoComprobante=tc.idTipoComprobante
			WHERE (c.Fecha>=fechaIni AND c.Fecha<=fechaFin)  ORDER BY c.idCompra DESC;
            END IF;
            END$$

DROP PROCEDURE IF EXISTS `ConsultaProductosCat`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConsultaProductosCat` (IN `criterio` VARCHAR(30), IN `Prod` VARCHAR(20))   BEGIN
	IF criterio='Buscar' THEN
		SELECT p.idProducto,pr.Descripcion AS presentacion,p.Descripcion,p.Concentracion,p.Stock,p.Costo,p.Precio_Venta,p.FechaVencimiento,p.RegistroSanitario,l.Nombre as laboratorio,p.Estado
		
		FROM producto AS p INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
        INNER JOIN laboratorio AS l ON p.idLaboratorio=l.idLaboratorio
		WHERE pr.Descripcion LIKE CONCAT("%",Prod,"%");
        END IF;
	END$$

DROP PROCEDURE IF EXISTS `DetalleCompraParametro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DetalleCompraParametro` (IN `criterio` VARCHAR(20), IN `buscar` VARCHAR(20))   BEGIN
			IF criterio = "id" THEN
				SELECT dc.idCompra,p.idProducto,pr.Descripcion AS presentacion,p.Descripcion,p.Concentracion,dc.Cantidad,dc.Costo,dc.Importe  FROM detallecompra AS dc
				INNER JOIN producto AS p ON dc.idProducto=p.idProducto
                INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
				WHERE dc.idCompra=buscar ORDER BY dc.idCompra;
			
			END IF; 
			
	END$$

DROP PROCEDURE IF EXISTS `DetalleVentaParametro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DetalleVentaParametro` (IN `criterio` VARCHAR(20), IN `buscar` VARCHAR(20))   BEGIN
			IF criterio = "id" THEN
				SELECT dv.IdVenta,p.idProducto,pr.Descripcion AS presentacion,p.Descripcion,p.Concentracion,dv.Cantidad,dv.Precio,dv.Importe  FROM detalleventa AS dv
				INNER JOIN producto AS p ON dv.idProducto=p.idProducto
                INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
				WHERE dv.IdVenta=buscar ORDER BY dv.IdVenta;
			
			END IF; 
			
	END$$

DROP PROCEDURE IF EXISTS `ProductosPorParametro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProductosPorParametro` (IN `pcriterio` VARCHAR(20), IN `pbusqueda` VARCHAR(30))   BEGIN
	IF pcriterio = "id" THEN
		SELECT p.idProducto,p.Descripcion,p.Concentracion,p.Stock,p.Costo,p.Precio_Venta,p.RegistroSanitario,p.FechaVencimiento,p.Estado,c.Descripcion AS presentacion
		FROM producto AS p INNER JOIN presentacion AS c ON p.idPresentacion = c.idPresentacion
		WHERE p.idProducto=pbusqueda AND p.Estado="Activo";
        END IF;
        
        END$$

DROP PROCEDURE IF EXISTS `UltimoIdCompra`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UltimoIdCompra` ()  NO SQL BEGIN
		SELECT MAX(idCompra) AS id FROM compra;
	END$$

DROP PROCEDURE IF EXISTS `UltimoIdVenta`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UltimoIdVenta` ()  NO SQL BEGIN
		SELECT MAX(idVenta) AS id FROM ventas;
	END$$

DROP PROCEDURE IF EXISTS `VentasPorDetalle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VentasPorDetalle` (IN `criterio` VARCHAR(30), IN `fechaIni` DATE, IN `fechaFin` DATE)   BEGIN
		IF criterio = "consultar" THEN
			SELECT p.idProducto,p.Descripcion AS Producto,pr.Descripcion AS Presentacion,dv.Costo,dv.Precio,
			SUM(dv.Cantidad) AS Cantidad,SUM(dv.Importe) AS Total,
			SUM(TRUNCATE((Importe-(dv.Costo*dv.Cantidad)),2)) AS Ganancia FROM ventas AS v
			INNER JOIN detalleventa AS dv ON v.IdVenta=dv.IdVenta
			INNER JOIN producto AS p ON dv.idProducto=p.idProducto
			INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
			WHERE (v.Fecha>=fechaIni AND v.Fecha<=fechaFin) AND v.Estado="EMITIDO" GROUP BY p.IdProducto
			ORDER BY v.IdVenta DESC;
		END IF;

	END$$

DROP PROCEDURE IF EXISTS `VentasPorFecha`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VentasPorFecha` (IN `criterio` VARCHAR(30), IN `fechaIni` DATE, IN `fechaFin` DATE)   BEGIN
		IF criterio = "Buscar" THEN
			SELECT v.IdVenta,CONCAT(c.Nombres, " ",c.Apellidos) AS cliente,v.Fecha,CONCAT(e.Nombres," ",e.Apellidos) AS empleado,td.Descripcion AS tipocomprobante,v.Serie,v.Numero,
			v.Estado,v.Total  FROM ventas AS v
			INNER JOIN tipocomprobante AS td ON v.idTipoComprobante=td.idTipoComprobante
			INNER JOIN cliente AS c ON v.idCliente=c.idCliente
			INNER JOIN empleado AS e ON v.idEmpleado=e.idEmpleado
			WHERE (v.Fecha>=fechaIni AND v.Fecha<=fechaFin)ORDER BY v.IdVenta DESC;
            
            ELSEIF criterio = "caja" THEN	
		   SELECT SUM(dv.Cantidad) AS Cantidad,p.Descripcion AS Producto,dv.Precio,
			SUM(dv.Importe) AS Total, SUM(TRUNCATE((Importe-(dv.Costo*dv.Cantidad)),2)) AS Ganancia,v.Fecha FROM ventas AS v
			INNER JOIN detalleventa AS dv ON v.IdVenta=dv.IdVenta
			INNER JOIN producto AS p ON dv.idProducto=p.idProducto
			INNER JOIN presentacion AS pr ON p.idPresentacion=pr.idPresentacion
			WHERE v.Fecha=fechaIni AND v.Estado="EMITIDO" GROUP BY p.idProducto
			ORDER BY v.IdVenta DESC;
            
           
            END IF;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `Nombres` varchar(35) NOT NULL,
  `Apellidos` varchar(35) NOT NULL,
  `Sexo` varchar(2) NOT NULL,
  `Dni` varchar(10) NOT NULL,
  `Telefono` varchar(15) NOT NULL,
  `Ruc` varchar(20) NOT NULL,
  `Email` varchar(35) NOT NULL,
  `Direccion` varchar(50) NOT NULL,
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `Nombres`, `Apellidos`, `Sexo`, `Dni`, `Telefono`, `Ruc`, `Email`, `Direccion`) VALUES
(1, 'Maria Jesus  ', 'BardalesTrigozo', 'F', '33425619', '987412350', '10334256192', 'mariajesus@gmail.com', 'Jr. Las Americas 1520'),
(2, 'Martin ', 'Campos Correa', 'M', '33156740', '965410372', '10331567402', 'martin_03@gmail.com', 'Av. Panama 120'),
(3, 'Azucena Jesus', 'Salas Mazuelos', 'F', '71902256', '987412530', '10719022564', 'azucenajesus@gmail.com', 'Jr. Coloquial 40'),
(4, 'Pedro', 'Suarez Rosales', 'M', '71328596', '987415263', '10713284594', 'pedor@gmail.com', 'Jr. Chachapoyas 130'),
(5, 'Juana ', 'Trigoso Bardales', 'F', '71832691', '942610387', '10719022568', 'juana07@gmail.com', 'Jr. Camporredondo 30'),
(6, 'Erick', 'Sanchez Gonzales', 'M', '33425619', '984120367', '10334269856', 'Erick_@gmail.com', 'Jr. La verdad 1520'),
(7, 'Daniel', 'Nuñez ', 'M', '71902257', '984123650', '10719022567', 'Daniel@gmail.com', 'Av. San Martin 120'),
(8, 'Carlos', '', 'M', '71902258', '', '', 'carlos@hotmail.com', ''),
(9, 'Jazmin', '', 'F', '', '', '10719022569', 'jazmin@gmail.com', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

DROP TABLE IF EXISTS `compra`;
CREATE TABLE IF NOT EXISTS `compra` (
  `idCompra` int(11) NOT NULL AUTO_INCREMENT,
  `Numero` varchar(15) NOT NULL,
  `Fecha` date NOT NULL,
  `TipoPago` varchar(30) NOT NULL,
  `Estado` varchar(10) NOT NULL,
  `idProveedor` int(11) NOT NULL,
  `idEmpleado` int(11) NOT NULL,
  `idTipoComprobante` int(11) NOT NULL,
  PRIMARY KEY (`idCompra`),
  KEY `idProveedor` (`idProveedor`),
  KEY `idEmpleado` (`idEmpleado`),
  KEY `idTipoComprobante` (`idTipoComprobante`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compra`
--

INSERT INTO `compra` (`idCompra`, `Numero`, `Fecha`, `TipoPago`, `Estado`, `idProveedor`, `idEmpleado`, `idTipoComprobante`) VALUES
(1, 'C00001', '2020-08-03', '', 'NORMAL', 1, 1, 2),
(2, 'C00002', '2020-08-03', '', 'NORMAL', 1, 1, 2),
(3, 'C00003', '2020-08-04', '', 'ANULADO', 1, 1, 2),
(4, 'C00004', '2020-08-04', '', 'NORMAL', 1, 1, 2),
(5, 'C00005', '2020-08-04', '', 'NORMAL', 1, 1, 1),
(6, 'C00006', '2020-08-04', '', 'NORMAL', 1, 1, 1),
(7, 'C00007', '2020-08-04', '', 'NORMAL', 1, 1, 1),
(8, 'C00008', '2020-08-04', '', 'NORMAL', 2, 1, 2),
(9, 'C00009', '2020-08-06', '', 'ANULADO', 2, 1, 2),
(10, 'C00010', '2020-08-06', '', 'NORMAL', 1, 1, 1),
(11, '000000', '2020-08-11', '', 'NORMAL', 2, 1, 2),
(12, '0000001', '2020-08-13', '', 'ANULADO', 2, 1, 2),
(13, '0000001', '2020-08-15', '', 'NORMAL', 2, 1, 1),
(14, '0000001', '2020-08-17', '', 'NORMAL', 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecompra`
--

DROP TABLE IF EXISTS `detallecompra`;
CREATE TABLE IF NOT EXISTS `detallecompra` (
  `idCompra` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  KEY `idCompra` (`idCompra`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detallecompra`
--

INSERT INTO `detallecompra` (`idCompra`, `idProducto`, `Cantidad`) VALUES
(1, 3, 29),
(2, 1, 20),
(2, 3, 15),
(3, 4, 20),
(4, 2, 1),
(4, 3, 100),
(5, 3, 10),
(6, 1, 20),
(6, 2, 10),
(7, 2, 5),
(7, 3, 10),
(8, 2, 5),
(8, 1, 20),
(8, 4, 6),
(9, 6, 10),
(10, 6, 15),
(10, 3, 10),
(11, 6, 10),
(11, 7, 10),
(12, 7, 20),
(13, 7, 5),
(14, 6, 10),
(14, 7, 15),
(1, 3, 29),
(2, 1, 20),
(2, 3, 15),
(3, 4, 20),
(4, 2, 1),
(4, 3, 100),
(5, 3, 10),
(6, 1, 20),
(6, 2, 10),
(7, 2, 5),
(7, 3, 10),
(8, 2, 5),
(8, 1, 20),
(8, 4, 6),
(9, 6, 10),
(10, 6, 15),
(10, 3, 10),
(11, 6, 10),
(11, 7, 10),
(12, 7, 20),
(13, 7, 5),
(14, 6, 10),
(14, 7, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleeliminacion`
--

DROP TABLE IF EXISTS `detalleeliminacion`;
CREATE TABLE IF NOT EXISTS `detalleeliminacion` (
  `idEliminacion` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `cantidad` int(10) NOT NULL,
  KEY `eliminacion_idEliminacion_detalleeliminacion` (`idEliminacion`),
  KEY `empleado_idEmpleado_detalleeliminacion` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventa`
--

DROP TABLE IF EXISTS `detalleventa`;
CREATE TABLE IF NOT EXISTS `detalleventa` (
  `IdVenta` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  KEY `IdVenta` (`IdVenta`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalleventa`
--

INSERT INTO `detalleventa` (`IdVenta`, `idProducto`, `Cantidad`) VALUES
(1, 1, 10),
(2, 1, 15),
(2, 2, 2),
(3, 1, 5),
(3, 2, 1),
(3, 4, 10),
(4, 4, 8),
(4, 5, 11),
(4, 1, 5),
(4, 3, 2),
(5, 4, 10),
(5, 2, 20),
(6, 1, 10),
(6, 2, 1),
(6, 3, 5),
(7, 1, 30),
(10, 1, 10),
(11, 2, 2),
(11, 3, 3),
(12, 3, 10),
(12, 2, 11),
(12, 4, 9),
(13, 1, 10),
(15, 6, 5),
(16, 2, 7),
(16, 4, 13),
(16, 6, 5),
(17, 3, 10),
(17, 4, 2),
(17, 7, 15),
(18, 3, 10),
(18, 6, 5),
(19, 6, 5),
(20, 7, 15),
(21, 6, 5),
(22, 4, 17),
(22, 2, 5),
(23, 4, 10),
(23, 6, 5),
(23, 2, 4),
(24, 4, 10),
(24, 2, 1),
(24, 6, 5),
(26, 3, 10),
(1, 1, 10),
(2, 1, 15),
(2, 2, 2),
(3, 1, 5),
(3, 2, 1),
(3, 4, 10),
(4, 4, 8),
(4, 5, 11),
(4, 1, 5),
(4, 3, 2),
(5, 4, 10),
(5, 2, 20),
(6, 1, 10),
(6, 2, 1),
(6, 3, 5),
(7, 1, 30),
(10, 1, 10),
(11, 2, 2),
(11, 3, 3),
(12, 3, 10),
(12, 2, 11),
(12, 4, 9),
(13, 1, 10),
(15, 6, 5),
(16, 2, 7),
(16, 4, 13),
(16, 6, 5),
(17, 3, 10),
(17, 4, 2),
(17, 7, 15),
(18, 3, 10),
(18, 6, 5),
(19, 6, 5),
(20, 7, 15),
(21, 6, 5),
(22, 4, 17),
(22, 2, 5),
(23, 4, 10),
(23, 6, 5),
(23, 2, 4),
(24, 4, 10),
(24, 2, 1),
(24, 6, 5),
(26, 3, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eliminacion`
--

DROP TABLE IF EXISTS `eliminacion`;
CREATE TABLE IF NOT EXISTS `eliminacion` (
  `idEliminacion` int(11) NOT NULL AUTO_INCREMENT,
  `numero` int(20) NOT NULL,
  `fecha` date NOT NULL,
  `autorizacion` varchar(50) NOT NULL,
  `idEmpleados` int(11) NOT NULL,
  PRIMARY KEY (`idEliminacion`),
  KEY `empleado_idEmpleado_eliminacion` (`idEmpleados`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

DROP TABLE IF EXISTS `empleado`;
CREATE TABLE IF NOT EXISTS `empleado` (
  `idEmpleado` int(11) NOT NULL AUTO_INCREMENT,
  `Nombres` varchar(35) NOT NULL,
  `Apellidos` varchar(35) NOT NULL,
  `tipoUsuario` varchar(30) NOT NULL,
  `Sexo` varchar(2) NOT NULL,
  `Rut` int(10) NOT NULL,
  `Email` varchar(30) NOT NULL,
  `Estado` varchar(10) NOT NULL,
  `idUsuario` int(11) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `contraseña` varchar(30) NOT NULL,
  PRIMARY KEY (`idEmpleado`),
  KEY `idUsuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`idEmpleado`, `Nombres`, `Apellidos`, `tipoUsuario`, `Sexo`, `Rut`, `Email`, `Estado`, `idUsuario`, `usuario`, `contraseña`) VALUES
(1, 'Franz Jensen', 'Loja Zelada', 'Administrador', 'M', 71902238, 'franzjensen03@gmail.com', 'Activo', 1, '', ''),
(3, 'Cristian Yover', 'Vasquez Nauca', 'Administrador', 'M', 71902265, 'yover@gmsil.com', 'Activo', 2, '', ''),
(4, 'Maria ', 'Camus Sanchez', 'Enfermera', 'F', 33428516, 'maria@gmail.com', 'Activo', 0, '', ''),
(5, 'Juana ', 'Mesones Portocarrero', 'Enfermera', 'F', 33451264, 'juana_32@hotmail.com', 'Activo', 0, '', ''),
(6, 'Miriam Melissa ', 'Tarazona Campos', 'Tecnica Enfermera', 'F', 334125697, 'melissa@hotmail.com', 'Inactivo', 0, '', ''),
(10, 'Juan Manuel', 'Vargas Tarrillo', 'Enfermero', 'M', 71913061, 'juanmanuel@gmail.com', 'Activo', 0, '', ''),
(11, 'Martin', 'Melendes Vilca', 'Enfermero', 'M', 40569815, 'martin@gmail.com', 'Inactivo', 0, '', ''),
(12, 'Paty ', 'Gomex Vera', 'Tecnica Enfermersa', 'F', 33425691, 'paty@hotmail.com', 'Inactivo', 0, '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `laboratorio`
--

DROP TABLE IF EXISTS `laboratorio`;
CREATE TABLE IF NOT EXISTS `laboratorio` (
  `idLaboratorio` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(35) NOT NULL,
  `Direccion` varchar(35) NOT NULL,
  `Telefono` int(15) NOT NULL,
  `Estado` varchar(10) NOT NULL,
  PRIMARY KEY (`idLaboratorio`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `laboratorio`
--

INSERT INTO `laboratorio` (`idLaboratorio`, `Nombre`, `Direccion`, `Telefono`, `Estado`) VALUES
(1, 'PHARMA', 'Lambayeque', 985481300, 'Activo'),
(2, 'ELIFARMA', 'Lima', 985733594, 'Activo'),
(3, 'FARVET', 'Lima', 912475603, 'Activo'),
(4, 'EXELTIS', 'Amazonas', 947203651, 'Activo'),
(5, 'ELIFARMA', 'Amazonas', 417859632, 'Activo'),
(6, 'GLENMARK', 'Cajamarca', 418759632, 'Activo'),
(7, 'SANOFI', 'Cajamarca', 984231067, 'Activo'),
(8, 'GLENTS', 'Arequipa', 987654321, 'Inactivo'),
(9, 'Inkafarma', 'Bagua', 987451263, 'Inactivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `moviminetogeneral`
--

DROP TABLE IF EXISTS `moviminetogeneral`;
CREATE TABLE IF NOT EXISTS `moviminetogeneral` (
  `idMovimiento` int(11) NOT NULL AUTO_INCREMENT,
  `tipoMovimiento` varchar(30) NOT NULL,
  `numero` int(11) NOT NULL,
  `fechaMovimiento` date NOT NULL,
  `idEmpleados` int(11) NOT NULL,
  PRIMARY KEY (`idMovimiento`),
  KEY `empleado_idEmpleado_movimientogeneral` (`idEmpleados`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presentacion`
--

DROP TABLE IF EXISTS `presentacion`;
CREATE TABLE IF NOT EXISTS `presentacion` (
  `idPresentacion` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(35) NOT NULL,
  `Estado` varchar(30) NOT NULL,
  PRIMARY KEY (`idPresentacion`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `presentacion`
--

INSERT INTO `presentacion` (`idPresentacion`, `Descripcion`, `Estado`) VALUES
(1, 'Aerosol', 'Activo'),
(2, 'Capsula', 'Activo'),
(3, 'Colirio', 'Activo'),
(4, 'Concentración', 'Inactivo'),
(5, 'Crema', 'Activo'),
(6, 'Elixir', 'Activo'),
(7, 'Emulsion', 'Inactivo'),
(8, 'Enema', 'Activo'),
(9, 'Espuma', 'Activo'),
(10, 'Farmaco', 'Activo'),
(11, 'Gel', 'Activo'),
(12, 'Gragea', 'Activo'),
(13, 'Granulos', 'Activo'),
(14, 'Inyectable', 'Activo'),
(15, 'Jalea', 'Activo'),
(16, 'Jarabe', 'Activo'),
(17, 'Linimento', 'Activo'),
(18, 'Locion', 'Activo'),
(19, 'Medicamento', 'Activo'),
(20, 'Ovulo', 'Activo'),
(21, 'Pasta', 'Inactivo'),
(22, 'Polvo', 'Activo'),
(23, 'Pomada', 'Activo'),
(24, 'Solución', 'Activo'),
(25, 'Supositorio', 'Inactivo'),
(26, 'Suspensión', 'Activo'),
(27, 'Tableta', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  `idProducto` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(35) NOT NULL,
  `Dosis` varchar(30) NOT NULL,
  `Stock` int(11) NOT NULL,
  `min_stock` int(10) NOT NULL,
  `FechaVencimiento` date NOT NULL,
  `idPresentacion` int(11) NOT NULL,
  `idLaboratorio` int(11) NOT NULL,
  PRIMARY KEY (`idProducto`),
  KEY `idPresentacion` (`idPresentacion`),
  KEY `idLaboratorio` (`idLaboratorio`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `Descripcion`, `Dosis`, `Stock`, `min_stock`, `FechaVencimiento`, `idPresentacion`, `idLaboratorio`) VALUES
(1, 'Ibuprofeno', '500 mg', 90, 0, '2021-08-08', 27, 6),
(2, 'Hepabionta', '10mg /30ml', 90, 13, '2022-08-14', 14, 4),
(3, 'Apronax', '500 mg', 150, 2, '2021-08-08', 27, 5),
(4, 'Naproxeno', '400 mg', 180, 0, '2022-08-11', 3, 4),
(5, 'Tylenol', '15 mg / 20ml', 40, 3, '2021-08-29', 7, 6),
(6, 'Penicilina', '500 mg', 50, 4, '2021-08-05', 14, 3),
(7, 'Flexitol', '1 %', 20, 9, '2021-08-16', 16, 3),
(8, 'Apronax', ' 500 mg', 100, 1, '2021-08-13', 27, 4),
(9, 'Panadol', '400 mg', 5, 3, '2021-08-22', 27, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
CREATE TABLE IF NOT EXISTS `proveedor` (
  `IdProveedor` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(35) NOT NULL,
  `Dni` varchar(11) NOT NULL,
  `Ruc` varchar(20) NOT NULL,
  `Direccion` varchar(35) NOT NULL,
  `Email` varchar(35) NOT NULL,
  `Telefono` varchar(20) NOT NULL,
  `Banco` varchar(35) NOT NULL,
  `Cuenta` varchar(35) NOT NULL,
  `Estado` varchar(10) NOT NULL,
  PRIMARY KEY (`IdProveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`IdProveedor`, `Nombre`, `Dni`, `Ruc`, `Direccion`, `Email`, `Telefono`, `Banco`, `Cuenta`, `Estado`) VALUES
(1, 'JORGE RAUL CAMUS PILCO', '33425689', '10334256897', 'Jr.Amazonas', 'jorgeraul@hotmail.com', '987612453', 'BCP', '1032456759484', 'Activo'),
(2, 'ELIFARMA', '', '0933428595', 'Av. Heroes del cenepa 1520', '', '987412350', 'BCP', '0126544949944884', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipocomprobante`
--

DROP TABLE IF EXISTS `tipocomprobante`;
CREATE TABLE IF NOT EXISTS `tipocomprobante` (
  `idTipoComprobante` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(35) NOT NULL,
  `Estado` varchar(10) NOT NULL,
  PRIMARY KEY (`idTipoComprobante`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipocomprobante`
--

INSERT INTO `tipocomprobante` (`idTipoComprobante`, `Descripcion`, `Estado`) VALUES
(1, 'Boleta', 'Activo'),
(2, 'Factura', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

DROP TABLE IF EXISTS `ventas`;
CREATE TABLE IF NOT EXISTS `ventas` (
  `IdVenta` int(11) NOT NULL AUTO_INCREMENT,
  `Tipodepago` varchar(25) NOT NULL,
  `Numero` varchar(20) NOT NULL,
  `Fecha` date NOT NULL,
  `Estado` varchar(10) NOT NULL,
  `idCliente` int(11) NOT NULL,
  `idEmpleado` int(11) NOT NULL,
  `idTipoComprobante` int(11) NOT NULL,
  PRIMARY KEY (`IdVenta`),
  KEY `idCliente` (`idCliente`),
  KEY `idEmpleado` (`idEmpleado`),
  KEY `idTipoComprobante` (`idTipoComprobante`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`IdVenta`, `Tipodepago`, `Numero`, `Fecha`, `Estado`, `idCliente`, `idEmpleado`, `idTipoComprobante`) VALUES
(1, '001', 'C00001', '2020-08-02', 'ANULADO', 2, 1, 1),
(2, '001', 'C00002', '2020-08-03', 'EMITIDO', 1, 1, 1),
(3, '001', 'C00003', '2020-08-03', 'EMITIDO', 3, 1, 2),
(4, '001', 'C00004', '2020-08-03', 'EMITIDO', 2, 1, 2),
(5, '001', 'C00005', '2020-08-03', 'EMITIDO', 2, 1, 1),
(6, '001', 'C00006', '2020-08-04', 'EMITIDO', 2, 1, 1),
(7, '001', 'C00007', '2020-08-04', 'EMITIDO', 3, 1, 2),
(8, '001', 'C00008', '2020-08-04', 'EMITIDO', 2, 1, 2),
(9, '001', 'C00009', '2020-08-04', 'EMITIDO', 3, 1, 1),
(10, '001', 'C00010', '2020-08-04', 'EMITIDO', 1, 1, 1),
(11, '001', 'C00011', '2020-08-04', 'EMITIDO', 2, 1, 1),
(12, '001', 'C00012', '2020-08-05', 'EMITIDO', 1, 1, 2),
(13, '001', 'C00013', '2020-08-05', 'EMITIDO', 3, 1, 2),
(14, '001', 'C00014', '2020-08-05', 'EMITIDO', 1, 1, 1),
(15, '001', 'C00015', '2020-08-06', 'EMITIDO', 1, 1, 2),
(16, '001', 'C00016', '2020-08-06', 'EMITIDO', 2, 1, 1),
(17, '001', 'C00017', '2020-08-06', 'EMITIDO', 2, 1, 2),
(18, '001', 'C00018', '2020-08-10', 'EMITIDO', 3, 1, 1),
(19, '001', 'C00019', '2020-08-11', 'ANULADO', 2, 1, 1),
(20, '001', 'C00020', '2020-08-11', 'EMITIDO', 2, 1, 1),
(21, '001', 'C00021', '2020-08-11', 'EMITIDO', 2, 1, 1),
(22, '001', 'C00022', '2020-08-11', 'EMITIDO', 2, 1, 2),
(23, '001', 'C00023', '2020-08-11', 'ANULADO', 3, 1, 2),
(24, '001', 'C00024', '2020-08-12', 'EMITIDO', 2, 1, 2),
(25, '001', 'C00025', '2020-08-12', 'ANULADO', 3, 1, 2),
(26, '001', 'C00026', '2020-08-13', 'ANULADO', 4, 1, 2);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`idTipoComprobante`) REFERENCES `tipocomprobante` (`idTipoComprobante`),
  ADD CONSTRAINT `compra_ibfk_2` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`),
  ADD CONSTRAINT `compra_ibfk_3` FOREIGN KEY (`idProveedor`) REFERENCES `proveedor` (`IdProveedor`);

--
-- Filtros para la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD CONSTRAINT `detallecompra_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`),
  ADD CONSTRAINT `detallecompra_ibfk_2` FOREIGN KEY (`idCompra`) REFERENCES `compra` (`idCompra`);

--
-- Filtros para la tabla `detalleeliminacion`
--
ALTER TABLE `detalleeliminacion`
  ADD CONSTRAINT `eliminacion_idEliminacion_detalleeliminacion` FOREIGN KEY (`idEliminacion`) REFERENCES `eliminacion` (`idEliminacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `empleado_idEmpleado_detalleeliminacion` FOREIGN KEY (`idProducto`) REFERENCES `empleado` (`idEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalleventa`
--
ALTER TABLE `detalleventa`
  ADD CONSTRAINT `detalleventa_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`),
  ADD CONSTRAINT `detalleventa_ibfk_2` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `eliminacion`
--
ALTER TABLE `eliminacion`
  ADD CONSTRAINT `empleado_idEmpleado_eliminacion` FOREIGN KEY (`idEmpleados`) REFERENCES `eliminacion` (`idEliminacion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `moviminetogeneral`
--
ALTER TABLE `moviminetogeneral`
  ADD CONSTRAINT `empleado_idEmpleado_movimientogeneral` FOREIGN KEY (`idEmpleados`) REFERENCES `empleado` (`idEmpleado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`idLaboratorio`) REFERENCES `laboratorio` (`idLaboratorio`),
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`idPresentacion`) REFERENCES `presentacion` (`idPresentacion`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`idTipoComprobante`) REFERENCES `tipocomprobante` (`idTipoComprobante`),
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `ventas_ibfk_3` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
