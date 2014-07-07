<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">

<xsl:comment>Table Header Column</xsl:comment>
<xsl:variable name="headerCol1" select="//OpenOLAP/property/headerCol1/@col"></xsl:variable>
<xsl:variable name="headerCol2" select="//OpenOLAP/property/headerCol2/@col"></xsl:variable>
<xsl:variable name="headerCol3" select="//OpenOLAP/property/headerCol3/@col"></xsl:variable>

<xsl:template match="/">
	<html lang="ja">
	<head>
	<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS"/>

	<title>OpenOLAP</title>
		<link rel="stylesheet" type="text/css" href="xml/table/common.css"/>
		<link rel="stylesheet" type="text/css" href="../../../css/common.css"/>
		<link id="stylefile" rel="stylesheet" type="text/css" href="xml/table/spreadStyle_blue_1.css"/>
		<script language="JavaScript1.2" src="xml/table/repeatTable.js"></script>
	</head>

	<body>
	<form name="form_main" method="post">
		<div id="myTable" style="margin:10 20 20 20;">
			<xsl:apply-templates select="//OpenOLAP" />
		</div>
	</form>
	</body>
	</html>
</xsl:template>

<xsl:template match="OpenOLAP">
	<xsl:for-each select="//data/row">
		<xsl:variable name="preTitleData">
			<xsl:value-of select="./@*[name()=$headerCol1]"/>
			<xsl:value-of select="./@*[name()=$headerCol2]"/>
			<xsl:value-of select="./@*[name()=$headerCol3]"/>
		</xsl:variable>

		<xsl:variable name="rowPosition">
			<xsl:value-of select="position()" />
		</xsl:variable>

		<xsl:variable name="preTitleData2">
			<xsl:choose>
				<xsl:when test="$rowPosition=1">
					@@FirstData@@
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//data/row[$rowPosition+-1]/@*[name()=$headerCol1]" />
					<xsl:value-of select="//data/row[$rowPosition+-1]/@*[name()=$headerCol2]" />
					<xsl:value-of select="//data/row[$rowPosition+-1]/@*[name()=$headerCol3]" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--違う場合だけ、表示-->
		<xsl:choose>
			<xsl:when test="$preTitleData!=$preTitleData2">
					<xsl:apply-templates mode="differentContents" select="." />
			</xsl:when>
		</xsl:choose>

	</xsl:for-each>
</xsl:template>


<!--Different Contents-->
<xsl:template match="*" mode="differentContents">
<table id="tblTableBody" class="ListTable">
<xsl:attribute name="line"><xsl:value-of select="//tableLine/@line"/></xsl:attribute>
	<caption>
<!--
		<xsl:value-of select="local-name(./@*[name()=$headerCol1])" />
		<xsl:value-of select="local-name(./@*[name()=$headerCol2])" />
		<xsl:value-of select="local-name(./@*[name()=$headerCol3])" />:
-->
		<xsl:value-of select="./@*[name()=$headerCol1]" />　<!--全角スペース 空白-->
		<xsl:value-of select="./@*[name()=$headerCol2]" />　<!--全角スペース 空白-->
		<xsl:value-of select="./@*[name()=$headerCol3]" />
	</caption>

	<tr>
		<xsl:for-each select="//sql/sqlcol">
			<xsl:choose><!--exclude hedder column-->
				<xsl:when test="@name=$headerCol1 or @name=$headerCol2 or @name=$headerCol3">
				</xsl:when>
				<xsl:otherwise>
					<td class="colHeader">
						<xsl:value-of select="./@*[name()='name']" />
					</td>
					</xsl:otherwise>
				</xsl:choose>
		</xsl:for-each>
	</tr>

	<xsl:apply-templates mode="sameContents" select="." />

	</table>
</xsl:template>

<!--Same Contents-->
<xsl:template match="*" mode="sameContents">
	<xsl:variable name="rowNum" select="position()" />
		<tr>
			<xsl:for-each select="./@*">
				<xsl:choose>
					<xsl:when test="name()=$headerCol1 or name()=$headerCol2 or name()=$headerCol3">
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:value-of select="." />
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</tr>

	<xsl:variable name="preTitleData">
		<xsl:value-of select="./@*[name()=$headerCol1]" />
		<xsl:value-of select="./@*[name()=$headerCol2]" />
		<xsl:value-of select="./@*[name()=$headerCol3]" />
	</xsl:variable>

	<xsl:variable name="preTitleData2">
		<xsl:value-of select="following-sibling::*[position()=1]/@*[name()=$headerCol1]" />
		<xsl:value-of select="following-sibling::*[position()=1]/@*[name()=$headerCol2]" />
		<xsl:value-of select="following-sibling::*[position()=1]/@*[name()=$headerCol3]" />
	</xsl:variable>

	<xsl:choose>
	<xsl:when test="$preTitleData=$preTitleData2">
		<xsl:apply-templates mode="sameContents" select="following-sibling::*[position()=1]"/>
	</xsl:when>
	</xsl:choose>


</xsl:template>
</xsl:stylesheet>

