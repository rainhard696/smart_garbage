
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $user = $_GET['user'];

    require_once("conexion.php");

    $query = "CALL sp_GetAsignacionesRecolector($user)";

    $result = mysqli_query($conn, $query);


    $filas = mysqli_num_rows($result);


    if ($result) {

        if ($filas > 0) {
            $response['success'] = true;

            while ($row = mysqli_fetch_assoc($result)) {
                array_push(
                    $datos,
                    array(
                        'IdAsignacion'        => $row['IdAsignacion'],
                        'IdContenedor'        => $row['IdContenedor'],
                        'Latitud'        => $row['latitud'],
                        'Longitud'        => $row['longitud'],
                        'Capacidad'        => $row['capacidad'],
                        'FechaAsignacion'        => $row['FechaAsignacion'],
                        'FechaRecoleccion'        => $row['FechaRecoleccion']
                    )
                );
            }
        } else {
            $response['success'] = false;

            array_push(
                $datos,
                array('Message' => 'Aún no tienes contenedores asignados.')
            );
        }
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
