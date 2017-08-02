<link rel="stylesheet" type="text/css" href="/portal/renderMetadata/css/searchResult.css" />
<link rel="stylesheet" type="text/css" href="/portal/renderMetadata/css/boot.css" />

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

	function transform($xmlDoc, $xsltPath, $xmlUrl, $outputXsltPath) {
		$landingPageLink = '/portal/renderMetadata/php/render.php?xml='.$xmlUrl.'&tt=landingPage';

		$xslDoc = new DOMDocument();
		$xslDoc->load($xsltPath);

		//Render the source metadata to intermediate XML
		$proc = new XSLTProcessor();
		$proc->importStylesheet($xslDoc);
		$proc->setParameter('', 'xmlUrl', $xmlUrl);
		$proc->setParameter('', 'landingPageLink', $landingPageLink);
		$proc->setParameter('', 'xsltPath', str_replace('../xslt/', '', $xsltPath));
		$tempXml = $proc->transformToXML($xmlDoc);

		if (!isset($_GET['raw'])) {
			//Render the intermediate XML to HTML output
			$xmlDoc = new DOMDOcument();
			$xmlDoc->loadXML($tempXml);
			$xslDoc = new DOMDocument();
			$xslDoc->load($outputXsltPath);
			$proc = new XSLTProcessor();
			$proc->importStylesheet($xslDoc);
			$output = $proc->transformToXML($xmlDoc);
      echo $output;
		}
		else {
			header('Content-Type: text/xml');
      echo $tempXml;
		}
	}

	//PHP spews warnings into the logs when you use an undefined namespace
	//in an xpath query, so this turns them off
	error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));

	$XMLURL = $_GET['xml'];
	$XSLURL = $_GET['xsl'];
	$transformType = $_GET['tt'];
	$xmlDoc = new DOMDocument();
	$xmlDoc->load($XMLURL);
	$xpath = new DOMXPath($xmlDoc);

  $xsltPath = "../xslt/output/";
  switch ($transformType) {
    case  "searchResult":
      $outputXsltPath = $xsltPath . "searchResult.xslt";
      break;
    case "landingPage":
      $outputXsltPath = $xsltPath . "landingPage.xslt";
      break;
    default:
      $outputXsltPath = $xsltPath . "searchResult.xslt";
      break;
  }

  $xsltPath = "../xslt/input/";
  $arcgisPath = $xsltPath . "arcgis.xslt";
	$eml_210Path = $xsltPath . "eml_210.xslt";
	$fgdcPath = $xsltPath . "fgdc.xslt";
	$iso_19115_2Path = $xsltPath . "iso_19115_2.xslt";
	$iso_19115_2_dsPath = $xsltPath . "iso_19115_2_ds.xslt";
	$iso_19139Path = $xsltPath . "iso_19139.xslt";
	$dc_mdeditPath = $xsltPath . "dc_mdedit.xslt";

	//Try to see if this is an ISO 19115-2 metadata with MI_Metadata root
	$standard = $xpath->query("/gmi:MI_Metadata/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19115-2";
			transform($xmlDoc, $iso_19115_2Path, $XMLURL, $outputXsltPath);
			return;
		}
	}


	//If it wasn't 19115-2 with MI_Metadata root,
	//see if it's an ISO 19115-2 metadata with DS_Series root
	$standard = $xpath->query("/gmd:DS_Series/gmd:seriesMetadata[1]/gmi:MI_Metadata[1]/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19115-2-ds";
			transform($xmlDoc, $iso_19115_2_dsPath, $XMLURL, $outputXsltPath);
			return;
		}
	}


	//If it wasn't 19115-2, see if it's 19139
	$standard = $xpath->query("/gmd:MD_Metadata/gmd:metadataStandardVersion[1]/gco:CharacterString[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ISO 19139";
			transform($xmlDoc, $iso_19139Path, $XMLURL, $outputXsltPath);
			return;
		}
	}


	//If it wasn't ISO, see if it's FGDC
	$standard = $xpath->query("/metadata/metainfo[1]/metstdv[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "FGDC CSDGM";
			transform($xmlDoc, $fgdcPath, $XMLURL, $outputXsltPath);
			return;
		}
	}


	//If it wasn't FGDC, see if it's ArcGIS 10.1
  $standard = $xpath->query("/metadata/Esri/ArcGISFormat");
  if ($standard) {
    if ($standard->item(0)->textContent != "") {
      //echo "ArcGIS 10.1";
      transform($xmlDoc,  $arcgisPath, $XMLURL, $outputXsltPath);
      return;
    }
  }


	//If it wasn't ArcGIS 10.1, see if it's ArcGIS 10.0
	$standard = $xpath->query("/metadata/mdStanName[1]");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "ArcGIS 10.0";
			transform($xmlDoc,  $arcgisPath, $XMLURL, $outputXsltPath);
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
			transform($xmlDoc, $eml_210Path, $XMLURL, $outputXsltPath);
			return;
		}
	}


  //If it wasn't EML 2.1.0, see if it's a DC record
	//created in mdedit.  Again, we don't have a standard
	//name element, but we're using the identifier as a
	//proxy.  This is likely to cause collisions with
	//DC records from other sources in the future.

	$standard = $xpath->query("/rdf:RDF/rdf:Description/dc:identifier");
	if ($standard) {
		if ($standard->item(0)->textContent != "") {
			//echo "DC mdedit";
			transform($xmlDoc, $dc_mdeditPath, $XMLURL, $outputXsltPath);
			return;
		}
	}

	//We don't know what it is.  Use the transform specified on the query string.
	//echo "unrecognized";
	transform($xmlDoc, $XSLURL, $XMLURL, $outputXsltPath);
	return;

?>

