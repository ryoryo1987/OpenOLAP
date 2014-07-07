<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">

<xsl:template match="/">
	<html lang="ja">
	<head>
	<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS"/>

	<title>OpenOLAP</title>
		<link rel="stylesheet" type="text/css" href="xml/table/common.css"/>
		<link rel="stylesheet" type="text/css" href="../../../css/common.css"/>
		<link id="stylefile" rel="stylesheet" type="text/css" href="xml/table/spreadStyle_blue_1.css"/>
		<script language="JavaScript1.2" src="xml/table/simpleTable.js"></script>
	</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[

]]>
</xsl:comment>
</script>

	<body>
	<form name="form_main" method="post">
		<div id="myTable" style="margin:10 20 20 20;">
			<xsl:apply-templates select="OpenOLAP" />
		</div>
	</form>
	</body>
	</html>
</xsl:template>

<xsl:template match="OpenOLAP">
<table id="tblTableBody" class="ListTable">
<xsl:attribute name="line"><xsl:value-of select="//tableLine/@line"/></xsl:attribute>
	<tr>
		<xsl:for-each select="//sql/sqlcol">
			<td class="colHeader">
				<xsl:value-of select="./@*[name()='name']" />
			</td>
		</xsl:for-each>
	</tr>

	<xsl:for-each select="//data/row">
<!--
<xsl:sort select="./value[number($Sort_select)]" data-type="{$Sort_data-type}" order="{$Sort_order}" />
-->
		<tr>
			<xsl:for-each select="./@*">
				<td class='standard_right'>
					<xsl:value-of select="." />
				</td>
			</xsl:for-each>
		</tr>
	</xsl:for-each>

</table>

</xsl:template>
</xsl:stylesheet>

