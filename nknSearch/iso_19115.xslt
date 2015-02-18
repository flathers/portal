<?xml version="1.0" encoding="UTF-8"?>
<!--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Inc. licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmi="http://www.isotc211.org/2005/gmi"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gmd="http://www.isotc211.org/2005/gmd"
>
	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>
	
  <!-- When the root node in the XML is encountered (the metadata element), the  
              HTML template is set up. -->
  <xsl:template match="/">

      <DIV class="content">

        <!-- TITLE. Add the title data to the page. If the element does not exist or contains no data, no text appears below. -->
	<xsl:if test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString != ''">
	  <h2 class="arcmeta" style="padding-bottom: 10px; border-bottom: 1px solid #ccc;"><xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" /></h2>
	</xsl:if>

	<!-- ABSTRACT. Add the abstract to the page. If element does not exist or contains no data, no text appears below.  -->
	<xsl:if test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString != ''">
	  <DIV class="arcmeta_content abstract"><font style="font-weight:bold;">Abstract: </font>

       	  <xsl:choose>
       	    <xsl:when test="string-length(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)>400">
       	    <!-- if length is longer than 400 (or whatever)-->
              <!-- Use spans to truncate the abstact and allow the remainder to be shown -->
       	      <div>
       	        <span style="display:none">
       	            <xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString" disable-output-escaping="yes"/>
       	            <a href="#" onclick="jQuery(this).parent().parent().children().toggle(); return false"> [Less]</a>
       	        </span>
       	        <span style="display:inline">
       	            <xsl:call-template name="trim-last-word">
                        <xsl:with-param name="in" select="substring(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString, 1, 400)" />
                    </xsl:call-template>
       	            <a href="#" onclick="jQuery(this).parent().parent().children().toggle(); return false"> [More]</a>
       	        </span>
       	      </div>
       	    </xsl:when>
       	    <xsl:otherwise>
       	      <xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString" disable-output-escaping="yes"/>
       	    </xsl:otherwise>
       	   </xsl:choose>
	  
	  </DIV>
	</xsl:if>

        <!-- PURPOSE. Add the purpose to the page. If element does not exist or contains no data, no text appears below.  -->
<!--
        <xsl:if test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose/gco:CharacterString != ''">
          <DIV class="arcmeta_content voice"><font style="font-weight:bold;">Purpose: </font>
          <xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose/gco:CharacterString" />
          </DIV>
        </xsl:if>
-->

        <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
	<xsl:if test="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution != ''">
	<dl><dt><font style="font-weight:bold;">Online Resource(s): </font></dt>
	  <xsl:for-each select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions">
	   <xsl:choose>
	    <xsl:when test="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode = 'download'">
	     <DIV class="arcmeta_content links">
             <dd><a href="{gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL}"><xsl:value-of select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></a></dd>
             </DIV>
            </xsl:when>
           </xsl:choose>
          </xsl:for-each>
	  <xsl:for-each select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
	  <DIV class="arcmeta_content links">
          <dd><a href="{gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL}"><xsl:value-of select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></a></dd>
          </DIV>
          </xsl:for-each>
        </dl>
        </xsl:if>


     </DIV>

  </xsl:template>

  <xsl:template name="trim-last-word">
    <xsl:param name="in" />
    <xsl:choose>
      <xsl:when test="substring($in, string-length($in), 1)=' '">
        <xsl:value-of select="$in" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim-last-word">
          <xsl:with-param name="in" select="substring($in, 1, string-length($in)-1)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
