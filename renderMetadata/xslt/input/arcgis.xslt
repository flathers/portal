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
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>
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
        <xsl:value-of select="normalize-space(/metadata/dataIdInfo[1]/idCitation[1]/resTitle[1])"/>
      </nkn:title>

      <nkn:abstract>
        <xsl:value-of select="normalize-space(/metadata/dataIdInfo/idAbs)"/>
        <xsl:if test="/metadata/dataIdInfo/idPurp[. != '']">
          <xsl:text>
          </xsl:text>
          <xsl:value-of select="/metadata/dataIdInfo/idPurp"/>
        </xsl:if>
      </nkn:abstract>

      <!--
      <xsl:if test="(/metadata/dataIdInfo/suppInfo != '')">
        <nkn:supInfo>
          <xsl:value-of select="/metadata/dataIdInfo/suppInfo"/>
        </nkn:supInfo>
      </xsl:if>
      
      <xsl:if test="(/metadata/dataIdInfo/idCredit != '')">
        <nkn:dataCred>
          <xsl:value-of select="/metadata/dataIdInfo/idCredit"/>
        </nkn:dataCred>
      </xsl:if>
-->

      <xsl:if test="(/metadata/dataIdInfo/idCitation/date/pubDate != '')">
        <nkn:date>
          <xsl:value-of select="/metadata/dataIdInfo/idCitation/date/pubdate"/>
        </nkn:date>
      </xsl:if>

      <!-- Contact Info -->
      <xsl:if test="/metadata/mdContact[. != '']">
        <nkn:contact>
          <xsl:if test="/metadata/mdContact/rpIndName[. != '']">
            <nkn:person>
              <xsl:value-of select="/metadata/mdContact/rpIndName"/>
            </nkn:person>
          </xsl:if>
          <xsl:if test="/metadata/mdContact/rpOrgName[. != '']">
            <nkn:organization>
              <xsl:value-of select="/metadata/mdContact/rpOrgName"/>
            </nkn:organization>
          </xsl:if>
          <xsl:if test="/metadata/mdContact/rpCntInfo[. != '']">
            <nkn:email>
              <xsl:value-of select="/metadata/mdContact/rpCntInfo/cntAddress/eMailAdd"/>
            </nkn:email>
          </xsl:if>
        </nkn:contact>
      </xsl:if>

      <!-- Constraints -->
      <nkn:constraints>
        <xsl:if test="/metadata/dataIdInfo/resConst/LegConsts/othConsts[. != '']">
          <xsl:value-of select="/metadata/dataIdInfo/resConst/LegConsts/othConsts"/>
          <xsl:text>
          </xsl:text>
        </xsl:if>
        <xsl:if test="/metadata/dataIdInfo/resConst/LegConsts/useLimit[. != '']">
          <xsl:value-of select="/metadata/dataIdInfo/resConst/LegConsts/useLimit"/>
          <xsl:text>
          </xsl:text>
        </xsl:if>
        <xsl:value-of select="/metadata/dataIdInfo/resConst/Consts/useLimit"/>
      </nkn:constraints>

      <!-- Geographic Bounds -->
      <nkn:geoBounds>
        <xsl:if test="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/westBL[. != '']">
          <nkn:geoBoundsW>
            <xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/westBL"/>
          </nkn:geoBoundsW>
          <nkn:geoBoundsE>
            <xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/eastBL"/>
          </nkn:geoBoundsE>
          <nkn:geoBoundsN>
            <xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/northBL"/>
          </nkn:geoBoundsN>
          <nkn:geoBoundsS>
            <xsl:value-of select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/southBL"/>
          </nkn:geoBoundsS>
        </xsl:if>
      </nkn:geoBounds>

      <!-- Temporal Bounds -->
      <xsl:if test="/metadata/dataIdInfo/dataExt/tempEle[. != '']">
        <nkn:temporalBounds>
          <xsl:if test="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Instant[. != '']">
            <xsl:value-of
              select="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Instant/tmPosition"/>
            <xsl:if test="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period[. != '']">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:if test="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period[. != '']">
            <xsl:value-of
              select="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period/tmBegin"/> to
              <xsl:value-of
              select="/metadata/dataIdInfo/dataExt/tempEle/TempExtent/exTemp/TM_Period/tmEnd"/>
          </xsl:if>
        </nkn:temporalBounds>
      </xsl:if>

      <!-- Online Links -->
      <nkn:links>
        <xsl:if
          test="
            (/metadata/distInfo/distTranOps/onLineSrc/linkage != '')
            or (/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != '')">

          <xsl:if test="(/metadata/distInfo/distTranOps/onLineSrc/linkage != '')">
            <xsl:for-each select="/metadata/distInfo/distTranOps/onLineSrc">
              <xsl:if test="not(starts-with(normalize-space(linkage), 'file://'))">
                <nkn:link>
                  <nkn:linkUrl>
                    <xsl:value-of select="linkage"/>
                  </nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
                  <nkn:linkTitle>
                    <xsl:choose>
                      <xsl:when test="orDesc != ''">
                        <xsl:value-of select="orDesc"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="linkage"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </nkn:linkTitle>
                </nkn:link>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="(/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != '')">
            <xsl:for-each select="/metadata/distInfo/distributor/distorTran/onLineSrc">
              <xsl:if test="not(starts-with(normalize-space(linkage), 'file://'))">
                <nkn:link>
                  <nkn:linkUrl>
                    <xsl:value-of select="linkage"/>
                  </nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
                  <nkn:linkTitle>
                    <xsl:choose>
                      <xsl:when test="orDesc != ''">
                        <xsl:value-of select="orDesc"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="linkage"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </nkn:linkTitle>
                </nkn:link>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>
      </nkn:links>

    </nkn:record>
  </xsl:template>
</xsl:stylesheet>
