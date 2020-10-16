<?php

$distancia = $_GET['dis'];
echo "La distancia es: " .$distancia;
$usuario = "root";
$contrasena = "";
$servidor = "localhost";
$basededatos ="ultra";

$conexion = mysqli_connect($servidor,$usuario,"") or die("no se encuentra conexion") ;
$db = mysqli_select_db($conexion,$basededatos) or die("no se encuentra bd") ;

$fecha = time();
$consulta = "INSERT INTO datos (fecha,distancia) values (".$fecha.",".$distancia.")";
$resultado = mysqli_query($conexion,$consulta); 
?>