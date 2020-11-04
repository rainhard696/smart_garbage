
<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
$datos = array();


if ($_SERVER['REQUEST_METHOD'] == 'POST') {


    $foto = $_POST['foto'];

    $path = "img_dir/";

    $random_digit = date('Y_m_d_h_i_s');
    $filename = $random_digit . '.jpg';
    $decoded = base64_decode($foto);
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
        array('Message' => 'Error de solicitud')
    );
}

$response['data'] = $datos;
echo json_encode($response);
