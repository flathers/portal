<?xml version="1.0" encoding="UTF-8"?>

<!--
  
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

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <p><img src="https://nkn-dev.nkn.uidaho.edu/sites/default/files/NKN_logo_v4.png" /></p>

    <div class="record lp-record">
    <div class="container-fluid">

    <div class="row">
     <div class="col-sm-12">
     <br />
      <!-- Title -->
      <h2 class="recordTitle lp-recordTitle">
        <xsl:value-of select="/nkn:record/nkn:title" />
      </h2>

     </div>
    </div>

    <div class="row">
     <div class="col-md-4 col-sm-6">

      <!-- Purpose -->
      <xsl:if test="/nkn:record/nkn:purpose[. != '']">
        <div class="purpose">
          <xsl:value-of select="/nkn:record/nkn:purpose"/>
        </div>
      </xsl:if>
      <!-- Abstract -->
      <xsl:if test="/nkn:record/nkn:abstract[. != '']">
        <div class="abstract">
          <xsl:value-of select="/nkn:record/nkn:abstract" disable-output-escaping="yes"/>
        </div>
      </xsl:if>
      <!-- Description -->
      <xsl:if test="/nkn:record/nkn:description[. != '']">
        <div class="descript">
          <xsl:value-of select="/nkn:record/nkn:description" disable-output-escaping="yes"/>
        </div>
      </xsl:if>
      <xsl:text></xsl:text>
      <!-- Constraints -->
      <xsl:if test="/nkn:record/nkn:constAccess[. != ''] or /nkn:record/nkn:constUse[. != ''] or /nkn:record/nkn:constOther[. != ''] or /nkn:record/nkn:liability[. != ''] or /nkn:record/nkn:license[. != '']">
        <div class="constraints">
	  <xsl:if test="/nkn:record/nkn:constAccess[. != '']">
	    <div class="constraint-access"><u>Access constraints</u>: 
		<xsl:value-of select="/nkn:record/nkn:constAccess" /><br /><br />
	    </div>
          </xsl:if>
	  <xsl:if test="/nkn:record/nkn:constUse[. != '']">
	    <div class="constraint-use"><u>Use constraints</u>: 
		<xsl:value-of select="/nkn:record/nkn:constUse" /><br /><br />
	    </div>
          </xsl:if>
	  <xsl:if test="/nkn:record/nkn:constOther[. != '']">
	    <div class="constraint-other"><u>Other constraints</u>: 
		<xsl:value-of select="/nkn:record/nkn:constOther" /><br /><br />
	    </div>
          </xsl:if>
	  <xsl:if test="/nkn:record/nkn:liability[. != '']">
	    <div class="liability"><u>Liability</u>: 
		<xsl:value-of select="/nkn:record/nkn:liability" /><br /><br />
	    </div>
          </xsl:if>
	  <xsl:if test="/nkn:record/nkn:license[. != '']">
	    <div class="license"><u>License</u>: 
		<xsl:value-of select="/nkn:record/nkn:license" />
	    </div>
          </xsl:if>
	</div>
      </xsl:if>
<!--
      <xsl:if test="/nkn:record/nkn:constraints[. != '']">
        <div class="constraints">
	  <xsl:for-each select="/nkn:record/nkn:constraints">
            <xsl:value-of select="/nkn:record/nkn:constraints" disable-output-escaping="yes"/><br /><br />
	  </xsl:for-each>
        </div>
      </xsl:if>
-->
     </div>
     <div class="col-md-3 col-sm-5">

      <!-- UUID or DOI -->
      <xsl:if test="/nkn:record/nkn:uuidDOI[. != '']">
        <div class="uuidDOI">
          <xsl:value-of select="/nkn:record/nkn:uuidDOI"/>
        </div>
      </xsl:if>
      <!-- Pub Date -->
      <xsl:if test="/nkn:record/nkn:date[. != '']">
        <div class="date">
          <xsl:value-of select="/nkn:record/nkn:date"/>
        </div>
      </xsl:if>
      <!-- Publisher -->
      <xsl:if test="/nkn:record/nkn:publisher[. != '']">
        <div class="publisher">
          <xsl:value-of select="/nkn:record/nkn:publisher"/>
        </div>
      </xsl:if>
      <!-- Creator/Originator -->
      <xsl:if test="/nkn:record/nkn:creator[. != '']">
        <div class="creator">
	  <xsl:for-each select="/nkn:record/nkn:creator">
            <p><xsl:value-of select="."/></p>
	  </xsl:for-each>
        </div>
      </xsl:if>
      <!-- Data Credit -->
      <xsl:if test="/nkn:record/nkn:dataCred[. != '']">
        <div class="dataCred">
          <xsl:value-of select="/nkn:record/nkn:dataCred"/>
        </div>
      </xsl:if>
      <!-- Contact Information -->
      <xsl:if
        test="(/nkn:record/nkn:contact/nkn:cntPerson[. != '']) or (/nkn:record/nkn:contact/nkn:cntOrg[. != ''])">
        <div class="contact">
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntPerson[. != '']">
            <div class="person">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntPerson"/>
            </div>
          </xsl:if>
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntOrg[. != '']">
            <div class="organization">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntOrg"/>
            </div>
          </xsl:if>
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntEmail[. != '']">
            <div class="email">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntEmail"/>
            </div>
          </xsl:if>
        </div>
      </xsl:if>

      <!-- Resource Description -->
      <xsl:if test="/nkn:record/nkn:resDesc[. != '']">
        <div class="resDesc">
          <xsl:value-of select="/nkn:record/nkn:resDesc"/>
        </div>
      </xsl:if>
      <!-- Resource Format -->
      <xsl:if test="/nkn:record/nkn:geoForm[. != '']">
        <div class="geoForm">
          <xsl:value-of select="/nkn:record/nkn:geoForm"/>
        </div>
      </xsl:if>
      <!-- Resource Format -->
      <xsl:if test="/nkn:record/nkn:formName[. != '']">
        <div class="formName">
          <xsl:value-of select="/nkn:record/nkn:formName"/>
        </div>
      </xsl:if>
      <!-- Supplimental Info -->
      <xsl:if test="/nkn:record/nkn:supInfo[. != '']">
        <div class="supInfo">
          <xsl:value-of select="/nkn:record/nkn:supInfo"/>
        </div>
      </xsl:if>

      <!-- Spatial Bounds -->
      <xsl:if test="/nkn:record/nkn:geoBounds/nkn:geoBoundsW[. != '']">
        <div class="geoBounds"/>
        <div class="geoBoundsW">
          <xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsW"/>
        </div>
        <div class="geoBoundsE">
          <xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsE"/>
        </div>
        <div class="geoBoundsN">
          <xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsN"/>
        </div>
        <div class="geoBoundsS">
          <xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsS"/>
        </div>
      </xsl:if>
      <!-- Temporal Bounds -->
      <xsl:if test="/nkn:record/nkn:temporal[. != '']">
        <div class="temporal">
          <xsl:value-of select="/nkn:record/nkn:temporal"/>
        </div>
      </xsl:if>

      <!-- Online links -->
      <div class="linksLabel">Data Download &amp; Online Resources:</div>
     <!-- <ul>-->
      <xsl:for-each select="/nkn:record/nkn:links/nkn:link">
      <!--  <li> -->
        <span class="summaryLink">
          <a href="{nkn:linkUrl}" target="_blank">
            <xsl:value-of select="nkn:linkTitle"/>
          </a>
          <div><xsl:value-of select="nkn:linkDesc"/></div>
        </span>
      <!--  </li> -->
      </xsl:for-each>
     <!-- </ul> -->
      <span class="summaryLink">
        <a href="{/nkn:record/nkn:xmlUrl}" target="_blank">View Metadata as Raw XML</a>
      </span>

     </div> <!-- close 2nd column -->
     <div class="col-md-4 col-sm-12">

	<script language="javascript" src="//maps.googleapis.com/maps/api/js?libraries=drawing"></script>
	<script language="javascript">
 	 <![CDATA[

  var map;
  var searchRect;

  var GLOBE_WIDTH = 256; // a constant in Google's map projection
  var nlat =  ]]><xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsN"/><![CDATA[ ;
  var slat =  ]]><xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsS"/><![CDATA[ ;
  var wlon =  ]]><xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsW"/><![CDATA[ ;
  var elon =  ]]><xsl:value-of select="/nkn:record/nkn:geoBounds/nkn:geoBoundsE"/><![CDATA[ ;

  var rectCntLat = (nlat - slat)/2 + slat; 
  var rectCntLon = (wlon - elon)/2 + elon; 

  var angle = elon - wlon;
  if (angle < 0) { angle += 360; }
  var angle2 = nlat - slat;
  var delta = 0;
  if (angle2 > angle) { angle = angle2; var delta = 3; }
  var zoomfactor = Math.floor(Math.log(960 * 360 / angle / GLOBE_WIDTH) / Math.LN2) - 3 - delta;

  function mapInit()
  {
    var mapProp = {
      center: new google.maps.LatLng(rectCntLat,rectCntLon),
      zoom: zoomfactor,
      minZoom: 2,
      maxZoom: 10,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoomControl: true,
      scrollwheel: false,
      zoomControlOptions: { style: google.maps.ZoomControlStyle.SMALL }
    };
  
    map=new google.maps.Map(document.getElementById("map_canvas"),mapProp);


// Draw rectangle with spatial extent
    var rectangle = new google.maps.Rectangle({
          strokeColor: '#FF0000',
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: '#FF0000',
          fillOpacity: 0.35,
          map: map,
          bounds: {
            north: nlat,  
            south: slat, 
            east: elon, 
            west: wlon  
          }
    });


  };

  google.maps.event.addDomListener(window, "load", mapInit);

 	 ]]>
	</script>
	<div id="map_canvas"></div>

     </div> <!-- close 3rd column -->
    </div> <!-- close bootstrap 3-column row -->

    </div> <!-- close container -->
    </div> <!-- close record -->

  </xsl:template>
</xsl:stylesheet>
