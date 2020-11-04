
<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'POST') {


    $nombres = $_POST['nombres'];
    $apellidos = $_POST['apellidos'];
    $cargo = $_POST['cargo'];
    $celular = $_POST['celular'];
    $direccion = $_POST['direccion'];
    $dni = $_POST['dni'];
    $capacidad = $_POST['capacidad'];
    $foto = $_POST['foto'];

    $path = "img_dir/";

    $random_digit = date('Y_m_d_h_i_s');
    $filename = $random_digit . '.jpg';
    $decoded = base64_decode($foto);
    $filepath = $path . $filename;

    require_once("conexion.php");

    $query = "CALL sp_AddPersonal ('$nombres', '$apellidos', $cargo, '$celular', '$direccion', '$dni', $capacidad, '$filepath')";

    $result = mysqli_query($conn, $query);


    if ($result) {

        file_put_contents($path . $filename, $decoded);

        $response['success'] = true;
        array_push(
            $datos,
            array('Message' => 'Se registró el usuario.')
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
