<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
<xsl:output method="text" encoding="Shift_JIS" />

<xsl:template match="/">
	<xsl:apply-templates select="OpenOLAP" />
</xsl:template>



<xsl:template match="OpenOLAP">
<xsl:for-each select="//sql/sqlcol"><xsl:value-of select="./@*[name()='name']" />,</xsl:for-each>


<xsl:text>,
</xsl:text>

	<xsl:for-each select="//data/row">
		<xsl:for-each select="./@*"><xsl:value-of select="." />,</xsl:for-each>
<xsl:text>,
</xsl:text>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>

