<?php

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2017 Northwest Knowledge Network
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


#some basic parameters
date_default_timezone_set('America/Los_Angeles');
$myServer = "nkn-ui-db-win.nkn.uidaho.edu";
$myUser = "";
$myPass = "";
$myDB = "nknDatastore";
$nknDatastoreRoot = getenv('HTTP_nknDatastoreRoot');

$output = "DSCHECK COMMENCING ".date('Y-m-d H:i:s')."\n";

//connect to the database
$dbhandle = mssql_connect($myServer, $myUser, $myPass)
  or die("Couldn't connect to SQL Server on $myServer");

//select a database to work with
$selected = mssql_select_db($myDB, $dbhandle)
  or die("Couldn't open database $myDB");



$output = $output."\n\nCHECKING FOR ORPHANED FILES ON FILE SYSTEM ".date('Y-m-d H:i:s')."\n";
$bad = 0;

//generate the file list
chdir($nknDatastoreRoot);
shell_exec('find published -type f > ' . $nknDatastoreRoot . 'published.txt');
$fileList = file($nknDatastoreRoot . 'published.txt');

//declare the SQL statement that will query the database
$query = "SELECT id FROM [file] WHERE path=@path";
$params = "@path varchar(256)";

foreach ($fileList as $path) {
  $path = trim($path);
  $path = str_replace("'", "\'", $path);
  $paramslist = "@path='$path'";

  $dbsql = "EXEC sp_executesql
          N'$query',
          N'$params',
          $paramslist";

  //execute the SQL query and return records
  $result = mssql_query($dbsql,$dbhandle);

  if(mssql_num_rows($result) != 1) {
    $output = $output."Did not find file in database: $path\n";
    $bad = 1;
  }
}
if ($bad == 0)
  $output = $output."None\n";
$bad = 0;



$output = $output."\n\nCHECKING FOR ORPHANED FILES IN DATABASE ".date('Y-m-d H:i:s')."\n";
$dbsql = "SELECT path FROM [file]";
$result = mssql_query($dbsql,$dbhandle);

//get the results
while($row = mssql_fetch_array($result)) {
  $path = $row["path"] ;
  if (!file_exists($path)) {
    $output = $output."Did not find file in file system: $path\n";
    $bad = 1;
  }
}
if ($bad == 0)
  $output = $output."None\n";
$bad = 0;



$output = $output."\n\nCHECKING FOR MD5 MISMATCHES ".date('Y-m-d H:i:s')."\n";
$dbsql = "SELECT * FROM (SELECT TOP 5000 [id],[path],[md5] FROM [nknDatastore].[dbo].[file] ORDER BY md5Verified ASC) AS a";
$result = mssql_query($dbsql,$dbhandle);

$updated = array();

//get the results
while($row = mssql_fetch_array($result)) {
  $path = $row["path"] ;
  $dbmd5 = $row["md5"];
  $fsmd5 = trim(md5_file($path));
  if(strcmp($fsmd5, $dbmd5)) {
    $output = $output."MD5 mismatch on $path  $fsmd5 = $dbmd5 \n";
    $bad = 1;
  }
  else {
    $updated[] = $row["id"];
  }
}
if ($bad == 0)
  $output = $output."None\n";
$bad = 0;


foreach ($updated as $id) {
  $id = trim($id);
  $dbsql = "UPDATE [file] SET md5Verified='".date('Y-m-d H:i:s')."' WHERE [id] = '$id'";

  $result = mssql_query($dbsql,$dbhandle);
}




//close the connection
mssql_close($dbhandle);

$output = $output."\n\nDSCHECK ENDING ".date('Y-m-d H:i:s')."\n";

//echo $output;
file_put_contents("/var/log/dscheck/dscheck-".date('YmdHis').".txt", $output);
?>
