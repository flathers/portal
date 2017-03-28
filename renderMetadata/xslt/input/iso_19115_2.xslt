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
  <xsl:template match="/">

    <nkn:record>
      
      <nkn:title><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" /></nkn:title>
      <nkn:xmlUrl><xsl:value-of select="$xmlUrl" /></nkn:xmlUrl>
      <nkn:summaryLink><xsl:value-of select="$summaryLink" /></nkn:summaryLink>

      <nkn:abstract><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/></nkn:abstract>
      <nkn:publisher><xsl:value-of select="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/></nkn:publisher>

      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation[. != '']">
        <nkn:supInfo><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation"/></nkn:supInfo>
      </xsl:if>

      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date[. != '']">
        <nkn:date><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date"/></nkn:date>
      </xsl:if>

      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType[. != '']">
        <nkn:geoForm><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType"/></nkn:geoForm>
      </xsl:if>

	<!-- Constraints -->
      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[. != '']">
	<xsl:for-each select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints">
	  <nkn:constraints>
		<xsl:if test="gmd:accessConstraints != ''">
		  <xsl:value-of select="gmd:accessConstraints"/><xsl:text> / </xsl:text>
        	</xsl:if>
		<xsl:if test="gmd:useConstraints != ''">
		  <xsl:value-of select="gmd:useConstraints"/><xsl:text> / </xsl:text>
        	</xsl:if>
		<xsl:if test="gmd:otherConstraints != ''">
		  <xsl:value-of select="gmd:otherConstraints"/>
        	</xsl:if>
	  </nkn:constraints>	
	</xsl:for-each>
      </xsl:if>

	<!-- Spatial Bounds -->
      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal[. != '']">
	<nkn:geoBoundsW>
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/> 
	</nkn:geoBoundsW>
	<nkn:geoBoundsE>
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/> 
	</nkn:geoBoundsE>
	<nkn:geoBoundsN>
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/> 
	</nkn:geoBoundsN>
	<nkn:geoBoundsS>
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
	</nkn:geoBoundsS>
      </xsl:if>

	<!-- Temporal Bounds -->
      <xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition[. != '']">
	<nkn:temporal>
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/> to  
	   <xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
	</nkn:temporal>
      </xsl:if>
      
        <!-- Point of Contact Info -->
      <nkn:contact>
<!--
        <xsl:if test="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString != ''">
          <nkn:cntOrg><xsl:value-of select="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/></nkn:cntOrg>
        </xsl:if>
        <xsl:if test="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString != ''">
          <nkn:cntEmail><xsl:value-of select="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/></nkn:cntEmail>
        </xsl:if>
        <xsl:if test="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString != ''">
          <nkn:cntVoice><xsl:value-of select="/gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/></nkn:cntVoice>
        </xsl:if>
-->
	<xsl:if test="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty != ''">
	  <nkn:cntPerson><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"/></nkn:cntPerson>
	  <nkn:cntOrg><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/></nkn:cntOrg>
	  <nkn:cntEmail><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/></nkn:cntEmail>
	  <nkn:cntVoice><xsl:value-of select="/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/></nkn:cntVoice>
	</xsl:if>

      </nkn:contact>
     
<!-- Handling of online linkages may not be quite right -->
      <xsl:if test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine != ''">
        <nkn:links>
	    <xsl:for-each select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
              <nkn:link>
                  <nkn:linkUrl><xsl:value-of select="." /></nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
<!--               	  <nkn:linkTitle><xsl:value-of select="." /></nkn:linkTitle>  -->
		  <xsl:choose>
		 	<xsl:when test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function != ''"> 
                  	  <nkn:linkTitle><xsl:value-of select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function" /></nkn:linkTitle>
		 	</xsl:when> 
		 	<xsl:otherwise> 
                  	  <nkn:linkTitle><xsl:value-of select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></nkn:linkTitle>
		 	</xsl:otherwise> 
		  </xsl:choose> 
              </nkn:link>
            </xsl:for-each>
        </nkn:links>
      </xsl:if>

<!-- for ISO 10115-2 DS (data series) -->
      <xsl:if test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine != ''">
        <nkn:links>
            <xsl:for-each select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">

	     <xsl:choose>
	      <xsl:when test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode = 'download' or 'order'">

              <nkn:link>
                  <nkn:linkUrl><xsl:value-of select="."/></nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
                  <xsl:choose>
                        <xsl:when test="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function != ''">
                          <nkn:linkTitle><xsl:value-of select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function" /></nkn:linkTitle>
                        </xsl:when>
                        <xsl:otherwise>
                          <nkn:linkTitle><xsl:value-of select="/gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" /></nkn:linkTitle>
                        </xsl:otherwise>
                  </xsl:choose>
              </nkn:link>

	      </xsl:when>
	     </xsl:choose>

            </xsl:for-each>
        </nkn:links>
      </xsl:if>
          

	
     
    </nkn:record>
    
  </xsl:template>
</xsl:stylesheet>
