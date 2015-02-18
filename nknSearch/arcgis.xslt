<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:utils="urn:XSLTUtils"
  exclude-result-prefixes="msxsl">


  <!-- When the root node in the XML is encountered (the metadata element), the  
       HTML template is set up. -->
  <xsl:template match="/">


        <DIV class="content">

          <!-- TITLE. If the metadata doesn't have this element or if it contains no data, no text appears below. -->
          <xsl:if test="/metadata/dataIdInfo[1]/idCitation[1]/resTitle[1] != ''">
            <h2 class="arcmeta">
              <xsl:value-of select="/metadata/dataIdInfo[1]/idCitation[1]/resTitle[1]" disable-output-escaping="yes"/>
            </h2>
          </xsl:if>

          <!-- ABSTRACT. If the metadata doesn't have this element or if it contains no data, no text appears below. -->
          <xsl:if test="/metadata/dataIdInfo[1]/idAbs[1] != ''">
            <DIV class="arcmeta_content abstract">
              <font style="font-weight:bold;">ABSTRACT</font>
              <xsl:choose>
                <xsl:when test="string-length(/metadata/dataIdInfo/idAbs)>400">
                  <!-- if length is longer than 400 (or whatever)
                    Use spans to truncate the abstact and allow the remainder to be shown -->
                  <div>
                    <span style="display:none">
                      <xsl:value-of select="/metadata/dataIdInfo/idAbs" disable-output-escaping="yes"/>
                      <a href="#" onclick="jQuery(this).parent().parent().children().toggle(); return false"> [Less]</a>
                    </span>
                    <span style="display:inline">
                      <xsl:call-template name="trim-last-word">
                        <xsl:with-param name="in" select="substring(/metadata/dataIdInfo/idAbs, 1, 400)" />
                      </xsl:call-template>
                      <a href="#" onclick="jQuery(this).parent().parent().children().toggle(); return false"> [More]</a>
                    </span>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="/metadata/dataIdInfo/idAbs" disable-output-escaping="yes"/>
                </xsl:otherwise>
              </xsl:choose>
            </DIV>
          </xsl:if>

          <!-- PURPOSE. If the metadata doesn't have this element or if it contains no data, no text appears below. -->
<!--
          <xsl:if test="/metadata/dataIdInfo[1]/idPurp[1] != ''">
            <DIV class="arcmeta_content purpose">
              <font style="font-weight:bold;">Purpose: </font>
              <xsl:value-of select="/metadata/dataIdInfo[1]/idPurp[1]" disable-output-escaping="yes" />
            </DIV>
          </xsl:if>
-->
          <!-- ONLINE RESOURCE -->
          <xsl:if test="/metadata/distInfo/distributor/distorTran/onLineSrc != ''">
            <dl>
              <dt>
                <font style="font-weight:bold;">Online Resource(s):</font>
              </dt>
              <xsl:for-each select="/metadata/distInfo/distributor/distorTran">
                <DIV class="arcmeta_content links">
                  <dd>
                    <a href="{onLineSrc/linkage}">
                      <xsl:value-of select="onLineSrc/orDesc" disable-output-escaping="yes"/>
                    </a>
                  </dd>
                </DIV>
              </xsl:for-each>
            </dl>
          </xsl:if>

        </DIV>
        <!-- close class="content" -->
  </xsl:template>
    <xsl:template name="trim-last-word">
    <xsl:param name="in" />
    <xsl:choose>
      <xsl:when test="substring($in, string-length($in), 1)=' '">
        <xsl:value-of select="$in" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim-last-word">
          <xsl:with-param name="in" select="substring($in, 1, string-length($in)-1)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
