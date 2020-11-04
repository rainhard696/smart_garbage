
<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'POST') {


    $iduser = $_POST['iduser'];
    require_once("conexion.php");

    $query = "CALL sp_Logout($iduser)";

    $result = mysqli_query($conn, $query);


    if ($result) {
        $response['success'] = true;
        array_push(
            $datos,
            array('Message' => 'Se cerró sesión correctamente.')
        );
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
