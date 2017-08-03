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
  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gsr="http://www.isotc211.org/2005/gsr"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gss="http://www.isotc211.org/2005/gss"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="xsltPath">NO XSLT PATH</xsl:param>
  <xsl:param name="xmlUrl">https://www.northwestknowledge.net/</xsl:param>
  <xsl:param name="landingPageLink">https://www.northwestknowledge.net/</xsl:param>

  <xsl:template match="/">
    <nkn:record>
      <nkn:randID>  <!-- use this random ID to help construct the searchResults accordion -->
        <xsl:value-of select="generate-id()"/>
      </nkn:randID>
      <nkn:xsltPath>
        <xsl:value-of select="$xsltPath"/>
      </nkn:xsltPath>
      <nkn:xmlUrl>
        <xsl:value-of select="$xmlUrl"/>
      </nkn:xmlUrl>
      <nkn:landingPageLink>
        <xsl:value-of select="$landingPageLink"/>
      </nkn:landingPageLink>

      <nkn:title>
        <xsl:value-of
          select="normalize-space(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString)"
        />
      </nkn:title>

      <nkn:abstract>
        <xsl:value-of
          select="normalize-space(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)"
        />
      </nkn:abstract>

      <nkn:date>
        <xsl:value-of
          select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date"
        />
      </nkn:date>

      <!-- Point of Contact Info -->
      <nkn:contact>
        <xsl:if
          test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty != ''">
          <nkn:person>
            <xsl:value-of
              select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString"
            />
          </nkn:person>
          <nkn:organization>
            <xsl:value-of
              select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"
            />
          </nkn:organization>
          <nkn:email>
            <xsl:value-of
              select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"
            />
          </nkn:email>
        </xsl:if>
      </nkn:contact>
      
      <!-- Constraints -->
      <nkn:constraints>
        <xsl:if
          test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints[. != '']">
          <xsl:value-of
            select="normalize-space(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints)"/>
          <xsl:text>
          </xsl:text>
        </xsl:if>
        <xsl:if
          test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints[. != '']">
          <xsl:value-of
            select="normalize-space(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints)"/>
          <xsl:text>
          </xsl:text>
        </xsl:if>
        <xsl:value-of
          select="normalize-space(//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints)"
        />
      </nkn:constraints>

      <!-- Geographic Bounds -->
      <nkn:geoBounds>
        <nkn:geoBoundsW>
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"
          />
        </nkn:geoBoundsW>
        <nkn:geoBoundsE>
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"
          />
        </nkn:geoBoundsE>
        <nkn:geoBoundsN>
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"
          />
        </nkn:geoBoundsN>
        <nkn:geoBoundsS>
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"
          />
        </nkn:geoBoundsS>
      </nkn:geoBounds>

      <!-- Temporal Bounds -->
      <xsl:if
        test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement[. != '']">
        <nkn:temporal>
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='TimePeriod']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='begin']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='TimeInstant']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='timePosition']"
          /> to <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='TimePeriod']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='end']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='TimeInstant']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='timePosition']"
          />
        </nkn:temporal>
      </xsl:if>

      <!-- Online Links -->
      <xsl:if
        test="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine != ''">
        <nkn:links>
          <xsl:for-each
            select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
            <nkn:link>
              <nkn:linkUrl>
                <xsl:value-of select="."/>
              </nkn:linkUrl>
              <nkn:linkType>Unknown</nkn:linkType>
              <xsl:choose>
                <xsl:when
                  test="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function != ''">
                  <nkn:linkTitle>
                    <xsl:value-of
                      select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode"
                    />
                  </nkn:linkTitle>
                </xsl:when>
                <xsl:otherwise>
                  <nkn:linkTitle>
                    <xsl:value-of
                      select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
                    />
                  </nkn:linkTitle>
                </xsl:otherwise>
              </xsl:choose>
            </nkn:link>
          </xsl:for-each>
        </nkn:links>
      </xsl:if>


    </nkn:record>

  </xsl:template>
</xsl:stylesheet>
