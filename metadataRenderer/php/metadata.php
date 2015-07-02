<?php

	function transform($xmlDoc, $xslPath) {
		$xslDoc = new DOMDocument();
		$xslDoc->load($xslPath);

		$proc = new XSLTProcessor();
		$proc->importStylesheet($xslDoc);
		echo $proc->transformToXML($xmlDoc);
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
