<?php

//set the target path to the base upload folder in the pre-prod datastore
$target_path = "/preprod-datastore/uploads/";

//configuration for the getUsername service
$getUsernameURL = "https://nknportal-prod.nkn.uidaho.edu/getUsername/";
$config_kw = "nknportal";


//sanitize the session ID and check it against the getUsername service
//if session_id or username comes back NULL, then quit
$session_id = filter_var($_POST["session_id"], FILTER_CALLBACK, array('options' => 'validate_id'));
if (!isset($session_id))
  exit(1);
$username = get_username($session_id, $getUsernameURL, $config_kw);
if (!isset($username))
  exit(1);


//sanitize the uuid--if it comes back NULL, then quit
$uuid = filter_var($_POST["uuid"], FILTER_CALLBACK, array('options' => 'validate_id'));
if (!isset($uuid))
  exit(1);


//create target subdirectory
$target_path = $target_path . $uuid . "/";
if (!file_exists($target_path)) {
  mkdir($target_path, 0777, true);
}

$target_path = $target_path . basename( $_FILES['uploadedfile']['name']);


/**
* validate/sanitize the uuid or session_id:
*   may contain alphanumerics, -
*   uuid may be enclosed in braces {uuid}
*   Drupal session_id can't contain braces, but it won't hurt to allow them
*   no more than 50 characters
* @param string $value
*/
function validate_id($value) {
  $values = trim($value);
  if (strlen($value) > 50)
  return;
  $pattern = '/^{?[a-zA-Z0-9\-]+}?$/';
  if (preg_match($pattern, $value, $matches))
  return($matches[0]);
  return;
}


/**
* check the session_id against logged-in users
* return string $username for the session
* @param string $value
*/
function getUsername($session_id, $url, $config_kw) {
  $data = array('session_id' => $session_id, 'config_kw' => $config_kw);

  // use key 'http' even if you send the request to https://...
  $options = array(
    'http' => array(
      'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
      'method'  => 'POST',
      'content' => http_build_query($data)
    )
  );
  $context  = stream_context_create($options);
  $result = file_get_contents($url, false, $context);
  if ($result === FALSE)
    return;
  $result = json_decode($result);
  if ($result->{'username'} != '')
    return ($result->{'username'});
  return;
}



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
