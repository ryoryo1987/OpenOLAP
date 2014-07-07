<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" encoding="Shift_JIS"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="PAGE">
    <HTML>
    <BODY>
    <xsl:apply-templates/>
    </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="EMPLOYEES">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="EMPLOYEE">
    <xsl:value-of select="ENAME"/> | 
    <xsl:value-of select="JOB"/> | 
    <xsl:value-of select="HIREDATE"/><BR/>
  </xsl:template>

</xsl:stylesheet>