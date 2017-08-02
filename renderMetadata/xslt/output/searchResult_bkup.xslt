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
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd"> 
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <div class="record">
     <!-- <div class="xsltpath">
        <xsl:value-of select="/nkn:record/nkn:xsltPath" />
      </div> -->
      <div class="recordTitle">
	<xsl:value-of select="/nkn:record/nkn:title" />
      </div>
      <div class="recordDetails">
       <div class="abstract">
        <xsl:value-of select="/nkn:record/nkn:abstract" />
       </div>

      <!-- Contact Information -->
      <xsl:if
        test="(/nkn:record/nkn:contact/nkn:cntPerson[. != '']) or (/nkn:record/nkn:contact/nkn:cntOrg[. != ''])">
        <div class="contact">
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntPerson[. != '']">
            <div class="person">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntPerson"/>
            </div>
          </xsl:if>
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntOrg[. != '']">
            <div class="organization">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntOrg"/>
            </div>
          </xsl:if>
          <xsl:if test="/nkn:record/nkn:contact/nkn:cntEmail[. != '']">
            <div class="email">
              <xsl:value-of select="/nkn:record/nkn:contact/nkn:cntEmail"/>
            </div>
          </xsl:if>
        </div>
       </xsl:if>

       <div class="summaryLink search">
        <a href="{/nkn:record/nkn:landingPageLink}" class="btn btn-sm btn-gold" target="_blank">More Details</a>
       </div>
      </div>  <!-- close recordDetails -->
    </div>
  </xsl:template>
</xsl:stylesheet>
