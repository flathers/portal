<?xml version="1.0" encoding="UTF-8"?>
<!--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Inc. licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gsr="http://www.isotc211.org/2005/gsr"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gss="http://www.isotc211.org/2005/gss"
  xmlns:gmd="http://www.isotc211.org/2005/gmd">

  <xsl:output method="html" indent="yes"/>

  <!-- When the root node in the XML is encountered (the metadata element), the  
       HTML template is set up. -->
  <xsl:template match="/">
    <div class="meta-container">
      
      <!-- TITLE. Add the title data to the page. If the element does not exist or contains no data, no text appears below. -->
      <xsl:if
        test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString != ''">
        <h2 class="meta-title">
          <xsl:value-of
            select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"
            disable-output-escaping="yes"/>
        </h2>
      </xsl:if>
      
      <div class="meta-record">
  
        <!-- ABSTRACT. Add the abstract to the page. If element does not exist or contains no data, no text appears below.  -->
        <xsl:if
          test="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString != ''">
          <div class="meta-abstract">
            <div class="meta-abstract-heading">Abstract:</div>
            
            <xsl:choose>
              <xsl:when
                test="string-length(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)>400">
                <!-- if length is longer than 400 (or whatever)-->
                <!-- Use spans to truncate the abstact and allow the remainder to be shown -->
                <!-- NOTE: this functionality requires jquery, which is not included in this
                  file because it is assumed to exist in the parent document for the snippet
                  that this XSLT creates -->
                <div>
                  <span style="display:none">
                    <xsl:value-of
                      select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"
                      disable-output-escaping="yes"/>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [Less]</a>
                  </span>
                  <span style="display:inline">
                    <xsl:call-template name="trim-last-word">
                      <xsl:with-param name="in"
                        select="substring(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString, 1, 400)"
                      />
                    </xsl:call-template>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [More]</a>
                  </span>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"
                  disable-output-escaping="yes"/>
              </xsl:otherwise>
            </xsl:choose>
  
          </div> <!--/meta-abstract-->
        </xsl:if>
  
        <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
        <xsl:if test="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution != ''">
          <div class="meta-resources">
            <dl>
              <dt>
                <font style="font-weight:bold;">Online Resource(s): </font>
              </dt>
              <xsl:for-each
                select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions">
                <xsl:choose>
                  <!-- Canonical values for CI_OnLineFunctionCode are: 
                          download, information, offlineAccess, order, search
                       Which ones should we display?
                  -->
                  <xsl:when
                    test="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode = 'download'">
                    <div class="meta-resource">
                      <dd>
                        <a
                          href="{normalize-space(gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL)}"
                          target="_blank">
                          <xsl:choose>
                            <xsl:when
                              test="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name != ''">
                              <xsl:value-of
                                select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </a>
                      </dd>
                    </div>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
              <xsl:for-each
                select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
                <div class="meta-resource">
                  <dd>
                    <a
                      href="{normalize-space(gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL)}"
                      target="_blank">
                      <xsl:choose>
                        <xsl:when
                          test="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name != ''">
                          <xsl:value-of
                            select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
                          />
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
