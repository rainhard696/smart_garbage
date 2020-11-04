-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-10-2020 a las 19:34:52
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `spFiltrarPsicologos` (IN `_especialidad` TEXT, IN `_genero` TEXT, IN `_orden` INT)  BEGIN
SELECT * FROM tbl_psicologos
WHERE especialidad like _especialidad AND genero like _genero 
order by CASE WHEN _orden = 0 THEN valoracion END ASC,    
			CASE WHEN _orden = 1 THEN valoracion END DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddAsignacion` (IN `_recolector` INT, IN `_contenedor` INT, IN `_supervisor` INT)  BEGIN

INSERT INTO `asignacion`
(
`IdRecolector`,
`IdContenedor`,
`IdSupervisor`,
`FechaAsignacion`,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddPersonal` (IN `_nombres` TEXT, IN `_apellidos` TEXT, IN `_cargo` INT, IN `_telefono` TEXT, IN `_direccion` TEXT, IN `_dni` TEXT, IN `_capacidad` DOUBLE, IN `_foto` TEXT)  BEGIN

declare lastidu INT;
declare lastidp INT;

insert into usuarios(Usuario,Password,IdRol) values(_dni,_dni,_cargo);

set lastidu = (SELECT LAST_INSERT_ID());

insert into persona(Nombres,Apellidos,Direccion,Celular,DNI,IdUsuario,Foto) 
values (_nombres,_apellidos,_direccion,_telefono,_dni,lastidu,_foto);

set lastidp = (SELECT LAST_INSERT_ID());

IF _cargo = 1 THEN
        insert into recolector(Capacidad,IdPersona,Estado) values (_capacidad,lastidp,'Disponible');
    END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddPersonal2` (IN `_nombres` TEXT, IN `_apellidos` TEXT, IN `_cargo` INT, IN `_telefono` TEXT, IN `_direccion` TEXT, IN `_dni` TEXT, IN `_capacidad` DOUBLE, IN `_foto` TEXT)  BEGIN

declare lastidu INT;
declare lastidp INT;

insert into usuarios(Usuario,Password,IdRol) values(_dni,_dni,_cargo);

set lastidu = (SELECT LAST_INSERT_ID());

insert into persona(Nombres,Apellidos,Direccion,Celular,DNI,IdUsuario,Foto) 
values (_nombres,_apellidos,_direccion,_telefono,_dni,lastidu,_foto);

set lastidp = (SELECT LAST_INSERT_ID());

IF _cargo = 1 THEN
        insert into recolector(Capacidad,IdPersona,Estado) values (_capacidad,lastidp,'Disponible');
    END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkUser` (IN `_user` TEXT, IN `_pass` TEXT)  BEGIN

select IdUsuario, Usuario, IdRol from usuarios WHERE Usuario like _user and Password like _pass;

IF EXISTS (select IdUsuario, Usuario, IdRol from usuarios WHERE Usuario like _user and Password like _pass)
THEN
BEGIN
	UPDATE usuarios
    set IsLogged = 'SI'
    where usuario like _user;
end;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CompletarAsignacion` (IN `_recolector` INT, IN `_idasignacion` INT)  BEGIN

update asignacion
set
	secuencia = (select (MAX(secuencia)+1) FROM asignacion where IdRecolector = _recolector),
    FechaRecoleccion = now(),
    CantidadRec = (select capacidad FROM contenedor where idcontenedor = (select idcontenedor from asignacion where idasignacion = _idasignacion))
WHERE idasignacion = _idasignacion;

update contenedor
set
	Estado = "Vacío",
    IsAssigned = 'NO'
where idContenedor = (select idcontenedor from asignacion where idasignacion = _idasignacion);

update recolector
set
	Estado = "Disponible"
where IdRecolector = _recolector;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAsignacionesRecolector` (IN `_idrecolector` INT)  BEGIN

select a.*, c.latitud, c.longitud, c.estado, c.capacidad from asignacion a
inner join contenedor c
on a.IdContenedor = c.IdContenedor
where IdRecolector = _idrecolector;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetContenedores` ()  BEGIN
	SELECT * FROM contenedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetProfileRecolector` (IN `_user` INT)  BEGIN

	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI, r.Capacidad, R.Estado, p.Foto, r.IdRecolector
    from persona p
    inner join recolector r
    on p.IdPersona = r.IdPersona
    where p.IdUsuario = _user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetProfileSupervisor` (IN `_user` INT)  BEGIN

	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI, p.Foto
    from persona p
    where p.IdUsuario = _user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetRecolectores` ()  BEGIN
	select p.Nombres, p.Apellidos, p.Direccion, p.Celular, p.DNI, r.Capacidad, R.Estado, r.IdRecolector, u.IsLogged
    from persona p
    inner join recolector r
    on p.IdPersona = r.IdPersona
    inner join usuarios u
    on p.IdUsuario = u.IdUsuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetSupervisores` ()  BEGIN

select p.Nombres, p.Apellidos, p.DNI, p.IdPersona  from persona p
inner join usuarios u
on p.IdUsuario = u.IdUsuario
where u.IdRol = 2;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetUsuarioPsicologo` (IN `_username` TEXT, IN `_passw` TEXT)  BEGIN
SELECT * FROM tbl_psicologos WHERE email = _username AND password = _passw;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Logout` (IN `_user` INT)  BEGIN
update usuarios
set IsLogged = 'NO'
where idusuario = _user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ReporteAsignacion` ()  BEGIN

	select p.Nombres, p.Apellidos, p.DNI, ro.Descripcion, a.FechaAsignacion, a.FechaRecoleccion, a.CantidadRec
    from persona p
    inner join recolector r
    on p.IdPersona = r.IdPersona
    inner join asignacion a
    on r.idrecolector = a.idrecolector
    inner join usuarios u 
    on p.IdUsuario = u.IdUsuario
    inner join roles ro
    on u.IdRol = ro.IdRol
    order by a.FechaAsignacion desc;

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
  `FechaAsignacion` datetime NOT NULL,
  `Secuencia` int(11) NOT NULL,
  `CantidadRec` double NOT NULL,
  `FechaRecoleccion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `asignacion`
--

INSERT INTO `asignacion` (`IdAsignacion`, `IdRecolector`, `IdContenedor`, `IdSupervisor`, `FechaAsignacion`, `Secuencia`, `CantidadRec`, `FechaRecoleccion`) VALUES
(1, 1, 1, 1, '2020-10-16 01:07:37', 0, 0, NULL),
(2, 3, 2, 1, '2020-10-29 21:12:33', 1, 100, '2020-10-29 22:46:12'),
(3, 10, 2, 1, '2020-10-30 13:32:32', 1, 100, '2020-10-30 13:33:24');

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
(2, 100, -12.045346, -75.220013, 'Vacío', 'NO');

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
  `Foto` varchar(255) NOT NULL,
  `IdUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`IdPersona`, `Nombres`, `Apellidos`, `Direccion`, `Celular`, `DNI`, `Foto`, `IdUsuario`) VALUES
(8, 'Recolector', 'Test', 'Calle Test', '987654321', '12345678', 'img_dir/2020_10_30_01_53_25.jpg', 11),
(9, 'Admin', 'Admin', 'Calle Real', '999555444', '11111111', 'img_dir/2020_10_30_01_53_25.jpg', 1),
(10, 'Jimmy', 'Bruno', 'Huancayo', '998877456', '44556688', 'img_dir/2020_10_30_01_53_25.jpg', 12),
(11, 'Frank', 'Miller', 'Huancayo', '998741258', '77887788', 'img_dir/2020_10_30_01_53_25.jpg', 13),
(12, 'Piter', 'Berna', 'Huancayo', '977777777', '77777777', 'img_dir/2020_10_30_01_53_25.jpg', 14),
(13, 'James', 'Santos', 'Av. Junin', '974125896', '85641236', 'img_dir/2020_10_30_01_53_25.jpg', 15),
(21, 'Tony', 'Roman', 'Huancayo', '984985498', '78542136', 'img_dir/2020_10_30_01_53_25.jpg', 23),
(22, 'qwerty', 'qwerty', 'Huancayo', '998877456', '55546321', 'img_dir/2020_10_30_01_53_25.jpg', 24),
(23, 'Rick', 'Sanchez', 'Huancayo', '998877456', '65574125', 'img_dir/2020_10_30_01_53_25.jpg', 25),
(24, 'Martin', 'Prince', 'Huancayo', '998877456', '75142478', 'img_dir/2020_10_30_01_53_25.jpg', 26),
(25, 'Gerald', 'Diaz', 'Huancayo', '998877456', '44445555', 'img_dir/2020_10_30_04_59_17.jpg', 27),
(26, 'RIchard', 'Ramon', 'Huancayo', '998877456', '88889999', 'img_dir/2020_10_30_07_30_29.jpg', 28);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recolector`
--

CREATE TABLE `recolector` (
  `IdRecolector` int(11) NOT NULL,
  `Capacidad` double DEFAULT NULL,
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
(2, 50, NULL, NULL, NULL, 11, 'Disponible'),
(3, 50, NULL, NULL, NULL, 12, 'Disponible'),
(4, 100, NULL, NULL, NULL, 13, 'Disponible'),
(5, 100, NULL, NULL, NULL, 21, 'Disponible'),
(6, 50, NULL, NULL, NULL, 22, 'Disponible'),
(7, 50, NULL, NULL, NULL, 23, 'Disponible'),
(8, 100, NULL, NULL, NULL, 24, 'Disponible'),
(9, 100, NULL, NULL, NULL, 25, 'Disponible'),
(10, 100, NULL, NULL, NULL, 26, 'Disponible');

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
  `IdRol` int(11) NOT NULL,
  `IsLogged` varchar(45) DEFAULT 'NO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`IdUsuario`, `Usuario`, `Password`, `IdRol`, `IsLogged`) VALUES
(1, 'admin', 'admin', 2, 'SI'),
(11, '12345678', '12345678', 1, 'NO'),
(12, '44556688', '44556688', 2, 'NO'),
(13, '77887788', '77887788', 1, 'NO'),
(14, '77777777', '77777777', 1, 'NO'),
(15, '85641236', '85641236', 1, 'NO'),
(23, '78542136', '78542136', 1, 'NO'),
(24, '55546321', '55546321', 1, 'NO'),
(25, '65574125', '65574125', 1, 'NO'),
(26, '75142478', '75142478', 1, 'NO'),
(27, '44445555', '44445555', 1, 'NO'),
(28, '88889999', '88889999', 1, 'SI');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  ADD PRIMARY KEY (`IdAsignacion`),
  ADD KEY `FK_asig_rec` (`IdRecolector`),
  ADD KEY `FK_asig_cont` (`IdContenedor`),
  ADD KEY `FK_asig_sup` (`IdSupervisor`);

--
-- Indices de la tabla `contenedor`
--
ALTER TABLE `contenedor`
  ADD PRIMARY KEY (`IdContenedor`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`IdPersona`),
  ADD KEY `FK_pers_user` (`IdUsuario`);

--
-- Indices de la tabla `recolector`
--
ALTER TABLE `recolector`
  ADD PRIMARY KEY (`IdRecolector`),
  ADD KEY `FK_rec_pers` (`IdPersona`);

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
  ADD PRIMARY KEY (`IdUsuario`),
  ADD KEY `FK_user_rol` (`IdRol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignacion`
--
ALTER TABLE `asignacion`
  MODIFY `IdAsignacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `contenedor`
--
ALTER TABLE `contenedor`
  MODIFY `IdContenedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `IdPersona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `recolector`
--
ALTER TABLE `recolector`
  MODIFY `IdRecolector` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
  MODIFY `IdUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignacion`
--
ALTER TABLE `asignacion`
  ADD CONSTRAINT `FK_asig_cont` FOREIGN KEY (`IdContenedor`) REFERENCES `contenedor` (`IdContenedor`),
  ADD CONSTRAINT `FK_asig_rec` FOREIGN KEY (`IdRecolector`) REFERENCES `recolector` (`IdRecolector`),
  ADD CONSTRAINT `FK_asig_sup` FOREIGN KEY (`IdSupervisor`) REFERENCES `usuarios` (`IdUsuario`);

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `FK_pers_user` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`);

--
-- Filtros para la tabla `recolector`
--
ALTER TABLE `recolector`
  ADD CONSTRAINT `FK_rec_pers` FOREIGN KEY (`IdPersona`) REFERENCES `persona` (`IdPersona`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `FK_user_rol` FOREIGN KEY (`IdRol`) REFERENCES `roles` (`IdRol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
