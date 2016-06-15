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

	function transform($xmlDoc, $xslPath) {
		$xslDoc = new DOMDocument();
		$xslDoc->load($xslPath);

		$proc = new XSLTProcessor();
		$proc->importStylesheet($xslDoc);
		$output = $proc->transformToXML($xmlDoc);
		//add the URL of the metadata to the output in case the calling script doesn't know it
		echo $output."<div id=\"metadataURL\" style=\"visibility:hidden;display:none\">".$_GET['xml']."</div>";
	}

	//PHP spews warnings into the logs when you use an undefined namespace
	//in an xpath query, so this turns them off
	error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));

	$arcgisPath = "../xslt/arcgis.xslt";
	$eml_210Path = "../xslt/eml_210.xslt";
	$fgdcPath = "../xslt/fgdc.xslt";
	$iso_19115_2Path = "../xslt/iso_19115_2.xslt";
	$iso_19115_2_dsPath = "../xslt/iso_19115_2_ds.xslt";
	$iso_19139Path = "../xslt/iso_19139.xslt";

	$XMLURL = $_GET['xml'];
	$XSLURL = $_GET['xsl'];
	$xmlDoc = new DOMDocument();
	$xmlDoc->load($XMLURL);
	$xpath = new DOMXPath($xmlDoc);

	//Try to see if this is an ISO 19115-2 metadata with MI_Metadata root
	$standard = $xpath->query("/gmi:MI_Metadata/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19115-2";
			transform($xmlDoc, $iso_19115_2Path);
			return;
		}
	}


	//If it wasn't 19115-2 with MI_Metadata root,
	//see if it's an ISO 19115-2 metadata with DS_Series root
	$standard = $xpath->query("/gmd:DS_Series/gmd:seriesMetadata[1]/gmi:MI_Metadata[1]/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19115-2-ds";
			transform($xmlDoc, $iso_19115_2_dsPath);
			return;
		}
	}


	//If it wasn't 19115-2, see if it's 19139
	$standard = $xpath->query("/gmd:MD_Metadata/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19139";
			transform($xmlDoc, $iso_19139Path);
			return;
		}
	}


	//If it wasn't ISO, see if it's FGDC
	$standard = $xpath->query("/metadata/metainfo[1]/metstdv[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "FGDC CSDGM";
			transform($xmlDoc, $fgdcPath);
			return;
		}
	}


	//If it wasn't FGDC, see if it's ArcGIS 10.1
  $standard = $xpath->query("/metadata/Esri/ArcGISFormat");
  if ($standard) {
    if ($standard->item(0)->textContent != "") {
      //echo "ArcGIS 10.1";
      transform($xmlDoc,  $arcgisPath);
      return;
    }
  }


	//If it wasn't ArcGIS 10.1, see if it's ArcGIS 10.0
	$standard = $xpath->query("/metadata/mdStanName[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ArcGIS 10.0";
			transform($xmlDoc,  $arcgisPath);
			return;
		}
	}


	//If it wasn't ArcGIS 10.0, see if it's EML 2.1.0
	//EML doesn't have an element with the standard name,
	//so we're using document title as a proxy
	$standard = $xpath->query("/eml:eml/dataset/title");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "EML 2.1.0";
			transform($xmlDoc, $eml_210Path);
			return;
		}
	}

	//We don't know what it is.  Use the transform specified on the query string.
	//echo "unrecognized";
	transform($xmlDoc, $XSLURL);
	return;

?>
