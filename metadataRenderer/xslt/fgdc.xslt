<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:utils="urn:XSLTUtils"
  exclude-result-prefixes="msxsl">

  <xsl:output method="html" indent="yes"/>

  <!-- When the root node in the XML is encountered (the metadata element), the  
       HTML template is set up. -->
  <xsl:template match="/">
    <div class="content">

      <!-- TITLE. If the metadata doesn't have an title element or if it contains no data, no text appears below. -->
      <xsl:if test="/metadata/idinfo/citation/citeinfo/title != ''">
        <h2 class="arcmeta">
          <xsl:value-of select="/metadata/idinfo/citation/citeinfo/title"
            disable-output-escaping="yes"/>
        </h2>
      </xsl:if>

      <!-- ABSTRACT. If the metadata doesn't have an abstract element or if it contains no data, no text appears below. -->
      <xsl:if test="/metadata/idinfo/descript/abstract != ''">
        <div class="arcmeta_content abstract">
          <font style="font-weight:bold;">Abstract: </font>

          <xsl:choose>
            <xsl:when test="string-length(/metadata/idinfo/descript/abstract)>400">
              <!-- if length is longer than 400 (or whatever)-->
              <!-- Use spans to truncate the abstact and allow the remainder to be shown -->
              <!-- NOTE: this functionality requires jquery, which is not included in this
                file because it is assumed to exist in the parent document for the snippet
                that this XSLT creates -->
              <div>
                <span style="display:none">
                  <xsl:value-of select="/metadata/idinfo/descript/abstract"
                    disable-output-escaping="yes"/>
                  <a href="#"
                    onclick="jQuery(this).parent().parent().children().toggle(); return false">
                    [Less]</a>
                </span>
                <span style="display:inline">
                  <xsl:call-template name="trim-last-word">
                    <xsl:with-param name="in"
                      select="substring(/metadata/idinfo/descript/abstract, 1, 400)"/>
                  </xsl:call-template>
                  <a href="#"
                    onclick="jQuery(this).parent().parent().children().toggle(); return false">
                    [More]</a>
                </span>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/metadata/idinfo/descript/abstract"
                disable-output-escaping="yes"/>
            </xsl:otherwise>
          </xsl:choose>

        </div> <!--/arcmeta_content abstract-->
      </xsl:if>

      <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
      <xsl:if
        test="/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != ''">
        <dl>
          <dt>
            <font style="font-weight:bold;">Online Resource(s):</font>
          </dt>
          <xsl:for-each select="/metadata/distinfo/stdorder/digform">
            <div class="arcmeta_content_links">
              <dd>
                <a href="{normalize-space(digtopt/onlinopt/computer/networka/networkr)}"
                  target="_blank">
                  <xsl:value-of select="digtinfo/formname" disable-output-escaping="yes"/>
                </a>
              </dd>
            </div>
          </xsl:for-each>
        </dl>
      </xsl:if>

    </div> <!--/content-->


  </xsl:template>
  <xsl:template name="trim-last-word">
    <xsl:param name="in"/>
    <xsl:choose>
      <xsl:when test="substring($in, string-length($in), 1)=' '">
        <xsl:value-of select="$in"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim-last-word">
          <xsl:with-param name="in" select="substring($in, 1, string-length($in)-1)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
