
<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");


$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $recolector = $_POST['recolector'];
    $supervisor = $_POST['supervisor'];
    $contenedor = $_POST['contenedor'];

    require_once("conexion.php");

    $query = "CALL sp_AddAsignacion($recolector,$contenedor,$supervisor)";

    $result = mysqli_query($conn, $query);



    if ($result) {

        $response['success'] = true;
        array_push($datos,
                array('Message' => 'Se registró la asignación.'));

    } else {

        $response['success'] = false;
        array_push(
            $datos,
            array('Message' => 'Falló la peticion')
        );
    }
} else {

    $response['success'] = false;
    array_push(
        $datos,
        array('Message' => 'Error de solicitud')
    );
}

$response['data'] = $datos;

echo json_encode($response);
