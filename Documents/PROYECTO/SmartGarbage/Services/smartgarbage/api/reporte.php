
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'GET') {


    require_once("conexion.php");

    $query = "CALL sp_ReporteAsignacion()";

    $result = mysqli_query($conn, $query);


    $filas = mysqli_num_rows($result);


    if ($result) {

        if ($filas > 0) {
            $response['success'] = true;

            while ($row = mysqli_fetch_assoc($result)) {
                array_push(
                    $datos,
                    array(
                        'Nombres'           => $row['Nombres'],
                        'Apellidos'         => $row['Apellidos'],
                        'DNI'               => $row['DNI'],
                        'Cargo'             => $row['Descripcion'],
                        'FechaAsignacion'   => $row['FechaAsignacion'],
                        'FechaRecoleccion'  => $row['FechaRecoleccion'],
                        'CantidadRec'       => $row['CantidadRec']
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
