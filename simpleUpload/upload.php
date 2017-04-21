<?php

$nknDatastoreRoot = getenv('HTTP_nknDatastoreRoot');
$base_path = $nknDatastoreRoot . 'uploads/';

//configuration for the getUsername service
$getUsernameURL = "https://nknportal-prod.nkn.uidaho.edu/getUsername/";
$config_kw = "nknportal";


//sanitize the session ID and check it against the getUsername service
//if session_id or username comes back NULL, then quit
$session_id = filter_var($_POST["session_id"], FILTER_CALLBACK, array('options' => 'validate_id'));
if (!isset($session_id)) {
  http_response_code(403);
  exit;
}

$username = get_username($session_id, $getUsernameURL, $config_kw);
if (!isset($username)) {
  http_response_code(403);
  exit;
}

//sanitize the uuid--if it comes back NULL, then quit
$uuid = filter_var($_POST["uuid"], FILTER_CALLBACK, array('options' => 'validate_id'));
if (!isset($uuid)) {
  http_response_code(403);
  exit;
}

/**
* validate/sanitize the uuid or session_id:
*   may contain alphanumerics, -, _
*   uuid may be enclosed in braces {uuid}
*   Drupal session_id can't contain braces, but it won't hurt to allow them
*   no more than 50 characters
* @param string $value
*/
function validate_id($value) {
  $values = trim($value);
  if (strlen($value) > 50)
  return;
  $pattern = '/^{?[a-zA-Z0-9\-_]+}?$/';
  if (preg_match($pattern, $value, $matches))
  return($matches[0]);
  return;
}


/**
* check the session_id against logged-in users
* return string $username for the session
* @param string $value
*/
function get_username($session_id, $url, $config_kw) {
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


//create target subdirectory
$target_path = $base_path . $uuid . "/";
if (!file_exists($target_path)) {
  mkdir($target_path, 0777, true);
}

//Get the file, place it in the target path, and return
$file_path = $target_path . basename($_FILES['uploadedfile']['name']);
if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $file_path)) {

  $resp_array = array(
    'message'     => "The file ".  basename( $_FILES['uploadedfile']['name'])." has been uploaded",
    'source'      => $_FILES['uploadedfile']['name'],
    'file_path' => $file_path,
    'url' => 'https://nknportal-dev.nkn.uidaho.edu/portal/simpleUpload/' . $file_path,
    'size'        => $_FILES['uploadedfile']['size']
  );

  echo json_encode($resp_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
  Proc_Close (Proc_Open ("/usr/bin/python ./postUploadAsync.py ".$target_path." &", Array (), $foo));
}
else {
  http_response_code(500);
  exit;
}

?>
