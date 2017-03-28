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
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="xmlUrl">https://www.northwestknowledge.net/</xsl:param>
  <xsl:param name="summaryLink">https://www.northwestknowledge.net/</xsl:param>
  <xsl:template match="/">
    
    <nkn:record>
      
      <nkn:title><xsl:value-of select="/metadata/idinfo/citation/citeinfo/title" /></nkn:title>
      <nkn:xmlUrl><xsl:value-of select="$xmlUrl" /></nkn:xmlUrl>
      <nkn:summaryLink><xsl:value-of select="$summaryLink" /></nkn:summaryLink>
      
      
      <xsl:if
        test="(/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != '')
        or (/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != '')">
        <nkn:links>
          <xsl:if test="/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != ''">
            <xsl:for-each select="/metadata/distinfo/stdorder/digform">
              <nkn:link>
                <nkn:linkUrl><xsl:value-of select="digtopt/onlinopt/computer/networka/networkr" /></nkn:linkUrl>
                <nkn:linkType>Unknown</nkn:linkType>
                <nkn:linkTitle><xsl:value-of select="digtinfo/formname" /></nkn:linkTitle>
              </nkn:link>
            </xsl:for-each>
          </xsl:if>
          
          <xsl:if test="/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != ''">
            <xsl:for-each select="/metadata/distInfo/distributor/distorTran/onLineSrc">
              <xsl:if test="not(starts-with(normalize-space(linkage), 'file://'))">
                <nkn:link>
                  <nkn:linkUrl><xsl:value-of select="linkage" /></nkn:linkUrl>
                  <nkn:linkType>Unknown</nkn:linkType>
                  <nkn:linkTitle>
                    <xsl:choose>
                      <xsl:when test="orDesc != ''">
                        <xsl:value-of select="orDesc" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="linkage" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </nkn:linkTitle>
                </nkn:link>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
        </nkn:links>
      </xsl:if>
      
    </nkn:record>
    
  </xsl:template>
</xsl:stylesheet>