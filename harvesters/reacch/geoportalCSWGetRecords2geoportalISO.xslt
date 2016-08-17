<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmi="http://www.isotc211.org/2005/gmi"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xs"
    extension-element-prefixes="exsl"
    version="1.0" >
    <xsl:output indent="yes"/>
    <xsl:param name="outputPath"></xsl:param>
    <xsl:template match="/csw:GetRecordsResponse/csw:SearchResults">
        <xsl:for-each select="gmi:MI_Metadata">
            <exsl:document method="xml"
                href="{$outputPath}{str:tokenize(gmd:fileIdentifier/gco:CharacterString, ':')[last()]}.xml">
                <xsl:copy-of select="."/>
            </exsl:document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
