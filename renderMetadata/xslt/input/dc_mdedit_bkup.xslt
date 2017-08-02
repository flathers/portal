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
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
  xmlns:ows="http://www.opengis.net/ows">
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
        <xsl:value-of select="normalize-space(/rdf:RDF/rdf:Description/dc:title)"/>
      </nkn:title>

      <nkn:abstract>
        <xsl:value-of select="normalize-space(/rdf:RDF/rdf:Description/dc:description)"/>
      </nkn:abstract>

      <nkn:date>
        <xsl:value-of select="/rdf:RDF/rdf:Description/dc:date"/>
      </nkn:date>

      <!-- Contact Info -->
      <nkn:contact>
        <nkn:person>
          <xsl:value-of select="/rdf:RDF/rdf:Description/dc:creator"/>
        </nkn:person>
        <nkn:organization>
          <xsl:value-of select="/rdf:RDF/rdf:Description/dc:publisher"/>
        </nkn:organization>
      </nkn:contact>

      <!-- Constraints -->
      <nkn:constraints>
        <xsl:value-of select="/rdf:RDF/rdf:Description/dc:rights"/>
      </nkn:constraints>

      <!-- Geographic Bounds -->
      <nkn:geoBounds>
        <nkn:geoBoundsW>
          <xsl:value-of
            select="substring-before(/rdf:RDF/rdf:Description[1]/ows:WGS84BoundingBox[1]/ows:LowerCorner[1], ' ')"
          />
        </nkn:geoBoundsW>
        <nkn:geoBoundsE>
          <xsl:value-of
            select="substring-before(/rdf:RDF/rdf:Description[1]/ows:WGS84BoundingBox[1]/ows:UpperCorner[1], ' ')"
          />
        </nkn:geoBoundsE>
        <nkn:geoBoundsN>
          <xsl:value-of
            select="substring-after(/rdf:RDF/rdf:Description[1]/ows:WGS84BoundingBox[1]/ows:UpperCorner[1], ' ')"
          />
        </nkn:geoBoundsN>
        <nkn:geoBoundsS>
          <xsl:value-of
            select="substring-after(/rdf:RDF/rdf:Description[1]/ows:WGS84BoundingBox[1]/ows:LowerCorner[1], ' ')"
          />
        </nkn:geoBoundsS>
      </nkn:geoBounds>

      <!-- Online Links -->
      <xsl:if test="(/rdf:RDF/rdf:Description/dct:references != '')">
        <nkn:links>
          <xsl:for-each select="/rdf:RDF/rdf:Description/dct:references">
            <nkn:link>
              <xsl:if test="not(starts-with(normalize-space(onLineSrc/linkage), 'file://'))">
                <nkn:linkUrl>
                  <xsl:value-of select="."/>
                </nkn:linkUrl>
                <nkn:linkType>Unknown</nkn:linkType>
                <nkn:linkTitle>
                  <xsl:value-of select="."/>
                </nkn:linkTitle>
              </xsl:if>
            </nkn:link>
          </xsl:for-each>
        </nkn:links>
      </xsl:if>

    </nkn:record>
  </xsl:template>
</xsl:stylesheet>
