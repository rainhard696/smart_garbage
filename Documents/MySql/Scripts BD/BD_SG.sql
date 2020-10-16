-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-10-2020 a las 08:53:13
-- Versión del servidor: 10.4.14-MariaDB
-- Versión de PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `smartgarbage`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddAsignacion` (IN `_recolector` INT, IN `_contenedor` INT, IN `_supervisor` INT)  BEGIN

INSERT INTO `asignacion`
(
`IdRecolector`,
`IdContenedor`,
`IdSupervisor`,
`Fecha`,
`Secuencia`,
`CantidadRec`)
VALUES
(_recolector,
_contenedor,
_supervisor,
now(),
0,
0);

UPDATE recolector
set Estado = 'En ruta'
where IdRecolector = _recolector;

UPDATE contenedor
set IsAssigned = 'SI'
where IdContenedor = _contenedor;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddPersonal` (IN `_nombres` TEXT, IN `_apellidos` TEXT, IN `_cargo` INT, IN `_telefono` TEXT, IN `_direccion` TEXT, IN `_dni` TEXT)  BEGIN

declare lastidu INT;
declare lastidp INT;

insert into usuarios(Usuario,Password,IdRol) values(_dni,_dni,_cargo);

set lastidu = (SELECT LAST_INSERT_ID());

insert into persona(Nombres,Apellidos,Direccion,Celular,DNI,IdUsuario,Foto) 
values (_nombres,_apellidos,_direccion,_telefono,_dni,lastidu,'');

set lastidp = (SELECT LAST_INSERT_ID());

IF _cargo = 1 THEN
        insert into recolector(Capacidad,IdPersona,Estado) values (50,lastidp,'Disponible');
    END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkUser` (IN `_user` TEXT, IN `_pass` TEXT)  BEGIN

select IdUsuario, Usuario, IdRol from usuarios WHERE Usuario like _user and Password like _pass;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetContenedores` ()  BEGIN
	SELECT * FROM contenedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetProfileRecolector` (IN `_user` INT)  BEGIN

	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI, r.Capacidad, R.Estado
    from persona p
    inner join recolector r
    on p.IdPersona = r.IdPersona
    where p.IdUsuario = _user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetProfileSupervisor` (IN `_user` INT)  BEGIN

	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI
    from persona p
    where p.IdUsuario = _user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetRecolectores` ()  BEGIN

	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI, r.Capacidad, R.Estado, r.IdRecolector
    from persona p
    inner join recolector r
    on p.IdPersona = r.IdPersona;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetSupervisores` ()  BEGIN

select p.Nombres, p.Apellidos, p.DNI, p.IdPersona  from persona p
inner join usuarios u
on p.IdUsuario = u.IdUsuario
where u.IdRol = 2;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignacion`
--

CREATE TABLE `asignacion` (
  `IdAsignacion` int(11) NOT NULL,
  `IdRecolector` int(11) NOT NULL,
  `IdContenedor` int(11) NOT NULL,
  `IdSupervisor` int(11) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Secuencia` int(11) NOT NULL,
  `CantidadRec` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `asignacion`
--

INSERT INTO `asignacion` (`IdAsignacion`, `IdRecolector`, `IdContenedor`, `IdSupervisor`, `Fecha`, `Secuencia`, `CantidadRec`) VALUES
(1, 1, 1, 1, '2020-10-16 01:07:37', 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contenedor`
--

CREATE TABLE `contenedor` (
  `IdContenedor` int(11) NOT NULL,
  `Capacidad` double NOT NULL,
  `Latitud` double NOT NULL,
  `Longitud` double NOT NULL,
  `Estado` varchar(50) NOT NULL,
  `IsAssigned` varchar(2) DEFAULT 'NO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contenedor`
--

INSERT INTO `contenedor` (`IdContenedor`, `Capacidad`, `Latitud`, `Longitud`, `Estado`, `IsAssigned`) VALUES
(1, 50, -12.057307, -75.212, 'LLeno', 'SI'),
(2, 100, -12.045346, -75.220013, 'Medio', 'NO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `IdPersona` int(11) NOT NULL,
  `Nombres` varchar(50) NOT NULL,
  `Apellidos` varchar(50) NOT NULL,
  `Direccion` varchar(100) NOT NULL,
  `Celular` varchar(9) NOT NULL,
  `DNI` varchar(8) NOT NULL,
  `Foto` varchar(50) NOT NULL,
  `IdUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`IdPersona`, `Nombres`, `Apellidos`, `Direccion`, `Celular`, `DNI`, `Foto`, `IdUsuario`) VALUES
(8, 'Recolector', 'Test', 'Calle Test', '987654321', '12345678', '', 11),
(9, 'Admin', 'Admin', 'Calle Real', '999555444', '11111111', '', 1),
(10, 'Jimmy', 'Bruno', 'Huancayo', '998877456', '44556688', '', 12),
(11, 'Frank', 'Miller', 'Huancayo', '998741258', '77887788', '', 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recolector`
--

CREATE TABLE `recolector` (
  `IdRecolector` int(11) NOT NULL,
  `Capacidad` int(11) DEFAULT NULL,
  `LatitudRec` double DEFAULT NULL,
  `LongitudRec` double DEFAULT NULL,
  `Foto` varchar(50) DEFAULT NULL,
  `IdPersona` int(11) NOT NULL,
  `Estado` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `recolector`
--

INSERT INTO `recolector` (`IdRecolector`, `Capacidad`, `LatitudRec`, `LongitudRec`, `Foto`, `IdPersona`, `Estado`) VALUES
(1, 50, NULL, NULL, NULL, 8, 'En ruta'),
(2, 50, NULL, NULL, NULL, 11, 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `IdRol` int(11) NOT NULL,
  `Descripcion` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`IdRol`, `Descripcion`) VALUES
(1, 'Recolector'),
(2, 'Supervisor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `supervisor`
--

CREATE TABLE `supervisor` (
  `IdSupervisor` int(11) NOT NULL,
  `Nombres` varchar(50) NOT NULL,
  `Apellidos` varchar(50) NOT NULL,
  `Direccion` varchar(100) NOT NULL,
  `Celular` varchar(9) NOT NULL,
  `DNI` varchar(8) NOT NULL,
  `Foto` varchar(50) DEFAULT NULL,
  `IdPersona` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `IdUsuario` int(11) NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Password` varchar(40) NOT NULL,
  `IdRol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`IdUsuario`, `Usuario`, `Password`, `IdRol`) VALUES
(1, 'admin', 'admin', 2),
(11, '12345678', '12345678', 1),
(12, '44556688', '44556688', 2),
(13, '77887788', '77887788', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  ADD PRIMARY KEY (`IdAsignacion`);

--
-- Indices de la tabla `contenedor`
--
ALTER TABLE `contenedor`
  ADD PRIMARY KEY (`IdContenedor`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`IdPersona`);

--
-- Indices de la tabla `recolector`
--
ALTER TABLE `recolector`
  ADD PRIMARY KEY (`IdRecolector`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`IdRol`);

--
-- Indices de la tabla `supervisor`
--
ALTER TABLE `supervisor`
  ADD PRIMARY KEY (`IdSupervisor`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`IdUsuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  MODIFY `IdAsignacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `contenedor`
--
ALTER TABLE `contenedor`
  MODIFY `IdContenedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `IdPersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `recolector`
--
ALTER TABLE `recolector`
  MODIFY `IdRecolector` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `IdRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `supervisor`
--
ALTER TABLE `supervisor`
  MODIFY `IdSupervisor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `IdUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
