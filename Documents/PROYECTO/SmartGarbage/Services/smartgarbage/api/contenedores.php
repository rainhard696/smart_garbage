
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'GET') {


    require_once("conexion.php");

    $query = "CALL sp_GetContenedores()";

    $result = mysqli_query($conn, $query);


    $filas = mysqli_num_rows($result);


    if ($result) {

        if ($filas > 0) {
            $response['success'] = true;

            while ($row = mysqli_fetch_assoc($result)) {
                array_push(
                    $datos,
                    array(
                        'IdContenedor'  => $row['IdContenedor'],
                        'Capacidad'     => $row['Capacidad'],
                        'Latitud'       => $row['Latitud'],
                        'Longitud'      => $row['Longitud'],
                        'Estado'        => $row['Estado'],
                        'Asignado'      => $row['IsAssigned'],
                    )
                );
            }

        } else {
            $response['success'] = false;

            array_push($datos,
                array('Message' => 'No se encontró datos'));
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
