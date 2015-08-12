<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:utils="urn:XSLTUtils"
  exclude-result-prefixes="msxsl">

  <xsl:output method="html" indent="yes"/>

  <!-- When the root node in the XML is encountered (the metadata element), the  
       HTML template is set up. -->
  <xsl:template match="/">
    <div class="meta-container">

      <!-- TITLE. If the metadata doesn't have an title element or if it contains no data, no text appears below. -->
      <xsl:if test="/metadata/idinfo/citation/citeinfo/title != ''">
        <h2 class="meta-title">
          <xsl:value-of select="/metadata/idinfo/citation/citeinfo/title"
            disable-output-escaping="yes"/>
        </h2>
      </xsl:if>

      <div class="meta-record">

        <!-- ABSTRACT. If the metadata doesn't have an abstract element or if it contains no data, no text appears below. -->
        <xsl:if test="/metadata/idinfo/descript/abstract != ''">
          <div class="meta-abstract">
            <div class="meta-abstract-heading">Abstract:</div>
            
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
  
          </div> <!--/meta-abstract-->
        </xsl:if>
  
        <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
        
        <xsl:if
          test="(/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != '')
          or (/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != '')">
          <div class="meta-resources">
            <dl>
              <dt>
                <div class="meta-resource-heading">Online Resource(s):</div>
              </dt>
  
              <xsl:if test="/metadata/distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr != ''">
                <xsl:for-each select="/metadata/distinfo/stdorder/digform">
                  <div class="meta-resource">
                    <dd>
                      <a href="{normalize-space(digtopt/onlinopt/computer/networka/networkr)}"
                        target="_blank">
                        <xsl:value-of select="digtinfo/formname" disable-output-escaping="yes"/>
                      </a>
                    </dd>
                  </div>
                </xsl:for-each>
              </xsl:if>
              
              <xsl:if test="/metadata/distInfo/distributor/distorTran/onLineSrc/linkage != ''">
                <xsl:for-each select="/metadata/distInfo/distributor/distorTran/onLineSrc">
                  <div class="meta-resource">
                    <dd>
                      <a href="{normalize-space(linkage)}"
                        target="_blank">
                        <xsl:choose>
                          <xsl:when test="orDesc != ''">
                            <xsl:value-of select="normalize-space(orDesc)" disable-output-escaping="yes"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="normalize-space(linkage)" disable-output-escaping="yes"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </a>
                    </dd>
                  </div>
                </xsl:for-each>
              </xsl:if>
            </dl>
          </div>
        </xsl:if>

        <!-- FULL METADATA LINK -->
        <!-- The %META-LINK-HREF% is replaced after the transform by the calling code, which knows the URL to the transformed file -->
        <a class="meta-link" href="%META-LINK-HREF%" target="_blank">View Full Metadata Record</a>

      </div> <!--/meta-record-->
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
