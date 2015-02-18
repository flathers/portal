<?php
//http://us1.php.net/mssql_query

$myServer = "nkn-ui-db-win.nkn.uidaho.edu";
$myUser = "flathers";
$myPass = "epsc0rNKN";
$myDB = "nknDatastore"; 
$metadataTransformerURL = "https://www.northwestknowledge.net/metadata.php?xml=";


//connection to the database
$dbhandle = mssql_connect($myServer, $myUser, $myPass)
  or die("Couldn't connect to SQL Server on $myServer"); 

//select a database to work with
$selected = mssql_select_db($myDB, $dbhandle)
  or die("Couldn't open database $myDB"); 

//declare the SQL statement that will query the database
$query = "SELECT metadataURL FROM datasetDOI WHERE doi=@doi"; 

//create parameter
$doi = $_GET['doi'];
$doi = substr($doi, 0, 32);
$params = "@doi varchar(32)";
$paramslist = "@doi='$doi'";

$dbsql = "EXEC sp_executesql 
          N'$query', 
          N'$params',
          $paramslist";

//execute the SQL query and return records
$result = mssql_query($dbsql,$dbhandle);

$redirect = "";

//get the results 
while($row = mssql_fetch_array($result)) {
  $redirect = $metadataTransformerURL.$row["metadataURL"];
}

//close the connection
mssql_close($dbhandle);

if ($redirect == '')
  die('DOI '.$doi.' not found');

//redirect the browser
header('Location:'.$redirect) ;
?>
