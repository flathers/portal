<?php

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 20015 Northwest Knowledge Network
#
# Licensed under the Creative Commons CC BY 4.0 License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://creativecommons.org/licenses/by/4.0/legalcode
#
# Software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

//http://us1.php.net/mssql_query

$myServer = "nkn-ui-db-win.nkn.uidaho.edu";
$myUser = "";
$myPass = "";
$myDB = "nknDatastore";
$metadataTransformerURL = "https://www.northwestknowledge.net/renderMetadata/php/render.php?xml=";


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
