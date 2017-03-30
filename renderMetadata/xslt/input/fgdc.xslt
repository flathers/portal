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
        <xsl:value-of select="normalize-space(/metadata/idinfo/citation/citeinfo/title)"/>
      </nkn:title>

      <nkn:abstract>
        <xsl:value-of select="normalize-space(metadata/idinfo/descript/abstract)"/>
        <xsl:if test="metadata/idinfo/descript/purpose[. != '']">
          <xsl:text>
          </xsl:text>
          <xsl:value-of select="metadata/idinfo/descript/purpose"/>
        </xsl:if>
      </nkn:abstract>

      <nkn:date>
        <xsl:value-of select="metadata/idinfo/citation/citeinfo/pubdate"/>
      </nkn:date>

      <!-- Contact Info -->
      <nkn:contact>
        <xsl:choose>
          <xsl:when test="metadata/idinfo/ptcontac/cntinfo/cntperp/cntper[. != '']">
            <nkn:person>
              <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntperp/cntper"/>
            </nkn:person>
          </xsl:when>
          <xsl:when test="metadata/idinfo/ptcontac/cntinfo/cntorgp/cntper[. != '']">
            <nkn:person>
              <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntorgp/cntper"/>
            </nkn:person>
          </xsl:when>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="metadata/idinfo/ptcontac/cntinfo/cntperp/cntorg[. != '']">
            <nkn:organization>
              <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntperp/cntorg"/>
            </nkn:organization>
          </xsl:when>
          <xsl:when test="metadata/idinfo/ptcontac/cntinfo/cntorgp/cntorg[. != '']">
            <nkn:organization>
              <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntorgp/cntorg"/>
            </nkn:organization>
          </xsl:when>
        </xsl:choose>

        <xsl:if test="metadata/idinfo/ptcontac/cntinfo/cntemail[. != '']">
          <nkn:email>
            <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntemail"/>
          </nkn:email>
        </xsl:if>

      </nkn:contact>

      <!-- Constraints -->
      <nkn:constraints>
        <xsl:value-of select="metadata/idinfo/accconst"/>
        <xsl:text>
        </xsl:text>
        <xsl:value-of select="metadata/idinfo/useconst"/>
        <xsl:text>
        </xsl:text>
        <xsl:value-of select="metadata/distinfo/distliab"/>
      </nkn:constraints>

      <!-- Geographic Bounds -->
      <nkn:geoBounds>
        <xsl:if test="metadata/idinfo/spdom/bounding[. != '']">
          <nkn:geoBoundsW>
            <xsl:value-of select="metadata/idinfo/spdom/bounding/westbc"/>
          </nkn:geoBoundsW>
          <nkn:geoBoundsE>
            <xsl:value-of select="metadata/idinfo/spdom/bounding/eastbc"/>
          </nkn:geoBoundsE>
          <nkn:geoBoundsN>
            <xsl:value-of select="metadata/idinfo/spdom/bounding/northbc"/>
          </nkn:geoBoundsN>
          <nkn:geoBoundsS>
            <xsl:value-of select="metadata/idinfo/spdom/bounding/southbc"/>
          </nkn:geoBoundsS>
        </xsl:if>
      </nkn:geoBounds>

      <!-- Temporal Bounds -->
      <xsl:if test="metadata/idinfo/timeperd/timeinfo[. != '']">
        <nkn:temporalBounds>
          <xsl:if test="metadata/idinfo/timeperd/timeinfo/sngdate/caldate[. != '']">
            <xsl:value-of select="metadata/idinfo/timeperd/timeinfo/sngdate/caldate"/>
          </xsl:if>
          <xsl:if test="metadata/idinfo/timeperd/timeinfo/rngdates/begdate[. != '']">
            <xsl:value-of select="metadata/idinfo/timeperd/timeinfo/rngdates/begdate"/> to <xsl:value-of select="metadata/idinfo/timeperd/timeinfo/rngdates/enddate"/>
          </xsl:if>
        </nkn:temporalBounds>
      </xsl:if>

      <!-- Online Links -->
      <nkn:links>
        <xsl:if
          test="/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != ''">
          <xsl:for-each select="/metadata/distinfo/stdorder/digform">
            <xsl:if
              test="not(starts-with(normalize-space(digtopt/onlinopt/computer/networka/networkr), 'file://'))">
              <nkn:link>
                <nkn:linkUrl>
                  <xsl:value-of
                    select="normalize-space(digtopt/onlinopt/computer/networka/networkr)"/>
                </nkn:linkUrl>
                <nkn:linkType>Unknown</nkn:linkType>
                <nkn:linkTitle>
                  <xsl:value-of select="digtinfo/formname"/>
                </nkn:linkTitle>
              </nkn:link>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>

        <xsl:if test="/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != ''">
          <xsl:for-each select="/metadata/distInfo/distributor/distorTran/onLineSrc">
            <xsl:if test="not(starts-with(normalize-space(linkage), 'file://'))">
              <nkn:link>
                <nkn:linkUrl>
                  <xsl:value-of select="normalize-space(linkage)"/>
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
      </nkn:links>

      <!-- Creator/Origin 
      <nkn:dataCred>
        <xsl:for-each select="metadata/idinfo/datacred[. != '']">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </nkn:dataCred>

      
      <nkn:creator>
        <xsl:if test="metadata/idinfo/citation/citeinfo/origin[. != '']">
          <xsl:value-of select="metadata/idinfo/citation/citeinfo/origin"/>
        </xsl:if>
      </nkn:creator>
-->
    </nkn:record>
  </xsl:template>
</xsl:stylesheet>
