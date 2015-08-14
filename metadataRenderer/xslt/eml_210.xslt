<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:utils="urn:XSLTUtils"
  xmlns:eml="eml://ecoinformatics.org/eml-2.1.0" exclude-result-prefixes="msxsl">

  <xsl:output method="html" indent="yes"/>

  <!-- When the root node in the XML is encountered (the metadata element), the  
       HTML template is set up. -->
  <xsl:template match="/">
    <div class="meta-container">

      <!-- TITLE. If the metadata doesn't have an title element or if it contains no data, no text appears below. -->
      <xsl:if test="/eml:eml/dataset/title != ''">
        <h2 class="meta-title">
          <xsl:value-of select="/eml:eml/dataset/title" disable-output-escaping="yes"/>
        </h2>
      </xsl:if>
      
      <div class="meta-record">
  
        <!-- ABSTRACT. If the metadata doesn't have an abstract element or if it contains no data, no text appears below. -->
        <xsl:if test="/eml:eml/dataset/abstract != ''">
          <div class="meta-abstract">
            <div class="meta-abstract-heading">Abstract:</div>
            
            <xsl:choose>
              <xsl:when test="string-length(/eml:eml/dataset/abstract)>400">
                <!-- if length is longer than 400 (or whatever)-->
                <!-- Use spans to truncate the abstact and allow the remainder to be shown -->
                <!-- NOTE: this functionality requires jquery, which is not included in this
                  file because it is assumed to exist in the parent document for the snippet
                  that this XSLT creates -->
                <div>
                  <span style="display:none">
                    <xsl:value-of select="/eml:eml/dataset/abstract" disable-output-escaping="yes"/>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [Less]</a>
                  </span>
                  <span style="display:inline">
                    <xsl:call-template name="trim-last-word">
                      <xsl:with-param name="in" select="substring(/eml:eml/dataset/abstract, 1, 400)"
                      />
                    </xsl:call-template>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [More]</a>
                  </span>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/eml:eml/dataset/abstract" disable-output-escaping="yes"/>
              </xsl:otherwise>
            </xsl:choose>
  
          </div> <!--/meta-abstract-->
        </xsl:if>
  
        <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
        <xsl:if test="/eml:eml/dataset/distribution/online/url != ''">
          <div class="meta-resources">
            <dl>
              <dt>
                <div class="meta-resource-heading">Online Resource(s):</div>
              </dt>
              <xsl:for-each select="/eml:eml/dataset/distribution/online">
                <div class="meta-resource">
                  <dd>
                    <a href="{normalize-space(url)}" target="_blank">
                      <xsl:choose>
                        <xsl:when test="onlineDescription != ''">
                          <xsl:value-of select="onlineDescription" disable-output-escaping="yes"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="url" disable-output-escaping="yes"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </a>
                  </dd>
                </div>
              </xsl:for-each>
            </dl>
          </div>
        </xsl:if>

        <!-- FULL METADATA LINK -->
        <!-- The %META-LINK-HREF% is replaced after the transform by the calling code, which knows the URL to the transformed file -->
        <a class="meta-link" href="%META-LINK-HREF%" target="_blank">View Full Metadata Record</a>
        &#160;&#160;&#160;&#160;
        <input style="visibility:hidden;" onclick="toggleBox(%i%);" type="button" value="Show/Hide data extent on map" />
        
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
