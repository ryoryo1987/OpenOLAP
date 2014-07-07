<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="Shift_JIS" indent="yes"/>
<xsl:key name="�������X�g" match="row" use="concat(
			'-',
			@�C�ӃR�[�h,
			'-',
			@�C�Ӗ�,
			'-')"/>

<xsl:template match="/">
	
	<xsl:for-each select="data/row[
		(
		 generate-id()=generate-id(key('�������X�g', concat(
			'-',
			@�C�ӃR�[�h,
			'-',
			@�C�Ӗ�,
			'-')))
		) �ǉ��i������]">
		<option>
			<xsl:attribute name="value"><xsl:value-of select="@�C�ӃR�[�h" /></xsl:attribute>
			<xsl:value-of select="@�C�Ӗ�" />
		</option>
	</xsl:for-each>




</xsl:template>
</xsl:stylesheet>


