<?xml version="1.0" encoding="UTF-8"?>

<!--

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2016 Northwest Knowledge Network
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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gsr="http://www.isotc211.org/2005/gsr"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gss="http://www.isotc211.org/2005/gss"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="xmlUrl">https://www.northwestknowledge.net/</xsl:param>
  <xsl:param name="summaryLink">https://www.northwestknowledge.net/</xsl:param>
  <xsl:template match="/gmd:DS_Series/gmd:seriesMetadata">

    <nkn:record>
      
      <nkn:title><xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" /></nkn:title>
      <nkn:xmlUrl><xsl:value-of select="$xmlUrl" /></nkn:xmlUrl>
      <nkn:summaryLink><xsl:value-of select="$summaryLink" /></nkn:summaryLink>

      <nkn:abstract><xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/></nkn:abstract>
      <nkn:publisher><xsl:value-of select="gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/></nkn:publisher>
      <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString[. != '']">
	<nkn:constraints><xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString"/></nkn:constraints>
      </xsl:if>
      <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal[. != '']">
	<nkn:geoBoundsW>
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/> 
	</nkn:geoBoundsW>
	<nkn:geoBoundsE>
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/> 
	</nkn:geoBoundsE>
	<nkn:geoBoundsN>
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/> 
	</nkn:geoBoundsN>
	<nkn:geoBoundsS>
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
	</nkn:geoBoundsS>
      </xsl:if>
      <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition[. != '']">
	<nkn:temporal>
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/> to  
	   <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
	</nkn:temporal>
      </xsl:if>
      
     
<!-- Handling of online linkages is not quite right -->
      <xsl:if test="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution != ''"> 
        <nkn:links>
	    <xsl:for-each select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions">
              <nkn:link>
                  <nkn:linkUrl><xsl:value-of select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
                  <nkn:linkTitle><xsl:value-of select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></nkn:linkTitle>
              </nkn:link>
            </xsl:for-each>  
        </nkn:links>
      </xsl:if> 
          

<!--
       #   <xsl:if test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions != ''">
       #     <xsl:for-each select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
              <a target="_blank" 
                href="{normalize-space(gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL)}">
                <xsl:choose>
                  <xsl:when
                    test="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name != ''">
                    <xsl:value-of
                      select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name"
                     />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
                     />
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </xsl:for-each>
          </xsl:if>
-->
	
     
    </nkn:record>
    
  </xsl:template>
</xsl:stylesheet>
