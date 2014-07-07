<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="Shift_JIS" indent="yes"/>
<xsl:key name="属性リスト" match="row" use="concat(
			'-',
			@任意コード,
			'-',
			@任意名,
			'-')"/>

<xsl:template match="/">
	
	<xsl:for-each select="data/row[
		(
		 generate-id()=generate-id(key('属性リスト', concat(
			'-',
			@任意コード,
			'-',
			@任意名,
			'-')))
		) 追加絞込条件]">
		<option>
			<xsl:attribute name="value"><xsl:value-of select="@任意コード" /></xsl:attribute>
			<xsl:value-of select="@任意名" />
		</option>
	</xsl:for-each>




</xsl:template>
</xsl:stylesheet>


