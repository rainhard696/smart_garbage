
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $user = $_GET['user'];

    require_once("conexion.php");

    $query = "CALL sp_GetProfileSupervisor($user)";

    $result = mysqli_query($conn, $query);


    $filas = mysqli_num_rows($result);


    if ($result) {

        if ($filas > 0) {
            $response['success'] = true;

            while ($row = mysqli_fetch_assoc($result)) {
                $path = $row['Foto'];
                $type = pathinfo($path, PATHINFO_EXTENSION);
                $data = file_get_contents($path);
                $base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);
                array_push(
                    $datos,
                    array(
                        'Nombres'        => $row['Nombres'],
                        'Apellidos'        => $row['Apellidos'],
                        'Direccion'        => $row['Direccion'],
                        'Celular'        => $row['Celular'],
                        'DNI'        => $row['DNI'],
                        'Foto'        => $base64
                    )
                );
            }
        } else {
            $response['success'] = false;

            array_push(
                $datos,
                array('Message' => 'No se encontró el usuario')
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
