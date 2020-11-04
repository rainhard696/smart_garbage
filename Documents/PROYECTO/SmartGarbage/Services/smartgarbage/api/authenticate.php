
<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");


$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $user = $_POST['user'];
    $password = $_POST['password'];

    require_once("conexion.php");

    $query = "CALL sp_checkUser('$user','$password')";

    $result = mysqli_query($conn, $query);


    $filas = mysqli_num_rows($result);


    if ($result) {

        if ($filas > 0) {
            $response['success'] = true;

            while ($row = mysqli_fetch_assoc($result)) {
                array_push(
                    $datos,
                    array(
                        'IdUsuario'        => $row['IdUsuario'],
                        'Usuario'        => $row['Usuario'],
                        'IdRol'        => $row['IdRol'],
                    )
                );
            }

        } else {
            $response['success'] = false;

            array_push($datos,
                array('Message' => 'No se encontró el usuario'));
        }
    } else {

        $response['success'] = false;
        array_push($datos,
            array('Message' => 'Falló la peticion'));
    }
} else {

    $response['success'] = false;
    array_push($datos,
        array('Message' => 'Error de solicitud'));
}

$response['data'] = $datos;

echo json_encode($response);
