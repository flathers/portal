<?php

$target_path = "uploads/";
$target_path = $target_path . $_POST["uuid"] . "/";

if (!file_exists($target_path)) {
    mkdir($target_path, 0777, true);
}


$target_path = $target_path . basename( $_FILES['uploadedfile']['name']);

//echo "Source=" .        $_FILES['uploadedfile']['name'] . "<br />";
//echo "Destination=" .   $destination_path . "<br />";
//echo "Target path=" .   $target_path . "<br />";
//echo "Size=" .          $_FILES['uploadedfile']['size'] . "<br />";

if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {

	$resp_array = array(
		'message'     => "The file ".  basename( $_FILES['uploadedfile']['name'])." has been uploaded",
		'source'      => $_FILES['uploadedfile']['name'],
		'target_path' => $target_path,
		'url' => 'https://nknportal-dev.nkn.uidaho.edu/portal/simpleUpload/' . $target_path,
		'size'        => $_FILES['uploadedfile']['size']
	);

	if (isset($_SERVER['HTTP_ORIGIN'])) {
		header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
		header('Access-Control-Allow-Credentials: true');
		header('Access-Control-Max-Age: 86400');    // cache for 1 day
	}
	if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

		if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
		    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");         

		if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
		    header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

		exit(0);
	}

	header("Access-Control-Allow-Methods: POST, OPTIONS");
	//header("Access-Control-Allow-Headers: X-Requested-With");
	header("Access-Control-Allow-Origin: *");
	//header('Content-Type: application/json');

	echo json_encode($resp_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

} else{
	echo "There was an error uploading the file, please try again!";
}
?>
