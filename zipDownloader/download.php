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

# config
$basePath = '/datastore/published/';
#The default execution time limit of 30 seconds spoils large downloads.
#setting this to zero means no time limit.
#60 seconds/min * 60 minutes/hr * x hours
set_time_limit(60 * 60 * 12);

# basic test of input validity
$uuid = $_GET['uuid'];
$doi = $_GET['doi'];

if (!$uuid && !$doi)
  die('Invalid entry: no UUID or DOI specified.');

if ($uuid && $doi)
  die('Invalid entry: cannot use both UUID and DOI.');

if ($doi)
  die('Download by DOI is not yet implemented.');

# get the download path and test for directory traversals
$dir = $basePath . $uuid;
$path = realpath($dir);

if (strpos($path . '/', $basePath) === false) {
#  echo $path.'/<br />'.$basePath.'<br />';
  echo '<br />Error: directory traversal';
  return;
}

$zipfilename = "data.zip";

if( isset( $files ) ) unset( $files );

$target = $path;

$d = dir( $target );

# create the list of files to zip
$files = array();
$rdi = new RecursiveDirectoryIterator($path);
foreach(new RecursiveIteratorIterator($rdi) as $file) {
	if(substr($file, -2) != '..' && substr($file, -2) != '/.') {
		$fileName = str_replace($basePath, '', $file);
		$files[] = $fileName;
	}
}

header( "Content-Type: application/x-zip" );
header( "Content-Disposition: attachment; filename=\"$zipfilename\"" );

$filespec = "";

foreach( $files as $entry ) {
	$filespec .= "\"$entry\" ";
}

chdir( $basePath );

$stream = popen( "/usr/bin/zip -q -0 - $filespec", "r" );

if( $stream ) {
	fpassthru( $stream );
	fclose( $stream );
}

?>
