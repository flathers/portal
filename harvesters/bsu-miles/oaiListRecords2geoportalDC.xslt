<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xs"
    extension-element-prefixes="exsl"
    version="1.0" >
    <xsl:output indent="yes"/>
    <xsl:param name="outputPath"></xsl:param>
    <xsl:template match="/oai:OAI-PMH/oai:ListRecords">
        <xsl:for-each select="oai:record">
            <exsl:document method="xml"
                href="{$outputPath}{str:tokenize(oai:header/oai:identifier, ':')[last()]}.xml">
                <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                    xmlns:dc="http://purl.org/dc/elements/1.1/"
                    xmlns:dcmiBox="http://dublincore.org/documents/2000/07/11/dcmi-box/"
                    xmlns:dct="http://purl.org/dc/terms/" xmlns:ows="http://www.opengis.net/ows">
                    <rdf:Description rdf:about="{oai:header/oai:identifier}">
                        <dc:identifier><xsl:value-of select="oai:header/oai:identifier"/></dc:identifier>
                        <dc:title><xsl:value-of select="oai:metadata/oai_dc:dc/dc:title"/></dc:title>
                        <dc:description><xsl:value-of select="oai:metadata/oai_dc:dc/dc:description"/></dc:description>
                        <xsl:for-each select="oai:metadata/oai_dc:dc/dc:identifier[not(. = 'Not at this time.')]">
                            <dct:references><xsl:value-of select="."/></dct:references>
                        </xsl:for-each>
                        <dct:references>http://scholarworks.boisestate.edu/miles_data/</dct:references>
                        <dc:type>Dataset</dc:type>
                        <dc:creator>BSU MILES</dc:creator>
                        <dc:date><xsl:value-of select="oai:metadata/oai_dc:dc/dc:date.dateSubmitted"/></dc:date>
                        <dc:language>eng</dc:language>
                        <dc:subject>environment</dc:subject>
                        <xsl:for-each select="oai:metadata/oai_dc:dc/dc:subject">
                            <dc:subject><xsl:value-of select="." /></dc:subject>
                        </xsl:for-each>
                    </rdf:Description>
                </rdf:RDF>
            </exsl:document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

