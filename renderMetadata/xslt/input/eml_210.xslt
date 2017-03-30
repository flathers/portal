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
  xmlns:eml="eml://ecoinformatics.org/eml-2.1.0"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="xsltPath">NO XSLT PATH</xsl:param>
  <xsl:param name="xmlUrl">https://www.northwestknowledge.net/</xsl:param>
  <xsl:param name="landingPageLink">https://www.northwestknowledge.net/</xsl:param>
  
  <xsl:template match="/">
    <nkn:record>
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
        <xsl:value-of select="normalize-space(/eml:eml/dataset/title)"/>
      </nkn:title>
      
      <nkn:abstract>
        <xsl:value-of select="normalize-space(/eml:eml/dataset/abstract)"/>
      </nkn:abstract>
      
      <nkn:date>
        <xsl:value-of select="/eml:eml/dataset/pubDate"/>
      </nkn:date>
      
      <!-- Contact Info -->
      <xsl:if test="/eml:eml/dataset/creator[. != '']">
        <nkn:contact>
          <xsl:if test="/eml:eml/dataset/creator/individualName[. != '']">
            <nkn:person>
              <xsl:value-of select="normalize-space(/eml:eml/dataset/creator/individualName)"/>
            </nkn:person>
          </xsl:if>
          <xsl:if test="/eml:eml/dataset/creator/organizationName[. != '']">
            <nkn:organization>
              <xsl:value-of select="/eml:eml/dataset/creator/organizationName"/>
            </nkn:organization>
          </xsl:if>
          <xsl:if test="/eml:eml/dataset/creator/electronicMailAddress[. != '']">
            <nkn:email>
              <xsl:value-of select="/eml:eml/dataset/creator/electronicMailAddress"/>
            </nkn:email>
          </xsl:if>
        </nkn:contact>
      </xsl:if>
      
      <!-- Constraints -->
      <nkn:constraints>
        <xsl:value-of select="normalize-space(/eml:eml/dataset/intellectualRights)"/>
      </nkn:constraints>
      
      <!-- Geographic Bounds -->
      <nkn:geoBounds>
        <xsl:if test="/eml:eml/dataset/coverage/geographicCoverage/boundingCoordinates[. != '']">
          <nkn:geoBoundsW>
            <xsl:value-of select="/eml:eml/dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"/>
          </nkn:geoBoundsW>
          <nkn:geoBoundsE>
            <xsl:value-of select="/eml:eml/dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"/>
          </nkn:geoBoundsE>
          <nkn:geoBoundsN>
            <xsl:value-of select="/eml:eml/dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"/>
          </nkn:geoBoundsN>
          <nkn:geoBoundsS>
            <xsl:value-of select="/eml:eml/dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"/>
          </nkn:geoBoundsS>
        </xsl:if>
      </nkn:geoBounds>
      
      <!-- Temporal Bounds -->
      <xsl:if test="/eml:eml/dataset/coverage/temporalCoverage[. != '']">
        <nkn:temporalBounds>
          <xsl:if test="/eml:eml/dataset/coverage/temporalCoverage/rangeOfDates[. != '']">
            <xsl:value-of
              select="/eml:eml/dataset/coverage/temporalCoverage/rangeOfDates/beginDate/calendarDate"/> to <xsl:value-of select="/eml:eml/dataset/coverage/temporalCoverage/rangeOfDates/endDate/calendarDate"/>
          </xsl:if>
        </nkn:temporalBounds>
      </xsl:if>
      
      <!-- Online Links -->
      <xsl:if test="(/eml:eml/dataset/distribution != '')">
        <nkn:links>
          <xsl:for-each select="/eml:eml/dataset/distribution">
            <nkn:link>
              <xsl:if test="not(starts-with(normalize-space(online/url), 'file://'))">
                <nkn:linkUrl>
                  <xsl:value-of select="online/url"/>
                </nkn:linkUrl>
                <nkn:linkType>Unknown</nkn:linkType>
                <nkn:linkTitle>
                  <xsl:value-of select="online/onlineDescription"/>
                </nkn:linkTitle>
              </xsl:if>
            </nkn:link>
          </xsl:for-each>
        </nkn:links>
      </xsl:if>
 
    </nkn:record>
  </xsl:template>
</xsl:stylesheet>
