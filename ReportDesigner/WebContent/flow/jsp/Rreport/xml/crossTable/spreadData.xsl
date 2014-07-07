<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
<xsl:output indent="yes" />

<xsl:comment>Table(Row,col) Header Column</xsl:comment>

<xsl:key name="rowHeaderList" match="//data/row" use="concat(
			'-',
			@___rowHeaderCd1--value___,
			'-',
			@___rowHeaderCd2--value___,
			'-',
			@___rowHeaderCd3--value___,
			'-')"/>

<xsl:key name="colHeaderList" match="//data/row" use="concat(
			'-',
			@___colHeaderCd1--value___,
			'-',
			@___colHeaderCd2--value___,
			'-',
			@___colHeaderCd3--value___,
			'-')"/>

<xsl:template match="/">
<OpenOLAP>
    <xsl:apply-templates select="//property" mode="direct"/>
    <xsl:apply-templates select="//sql" mode="direct"/>

<additionalData>
	<xsl:apply-templates select="//data" mode="rowHeader"/>
	<xsl:apply-templates select="//data" mode="colHeader"/>
</additionalData>

    <xsl:apply-templates select="//data" mode="direct"/>
</OpenOLAP>
</xsl:template>

<!--*******************************************************************************-->
<xsl:template match="@*|*|text()" mode="direct">
	<xsl:copy>
		<xsl:apply-templates select="@*|*|text()"  mode="direct"/>
	</xsl:copy>
</xsl:template>
<!--*******************************************************************************-->

<!--*******************************************************************************-->
<xsl:template match="data" mode="rowHeader">
<rowHeader>
	<xsl:for-each select="row[
		(
		 generate-id()=generate-id(key('rowHeaderList', concat(
			'-',
			@___rowHeaderCd1--value___,
			'-',
			@___rowHeaderCd2--value___,
			'-',
			@___rowHeaderCd3--value___,
			'-')))
		)]">

		<xsl:apply-templates select="." mode="direct"/>
	</xsl:for-each>
</rowHeader>

</xsl:template>
<!--*******************************************************************************-->

<!--*******************************************************************************-->
<xsl:template match="data" mode="colHeader">
<colHeader>
	<xsl:for-each select="row[
		generate-id()=generate-id(key('colHeaderList', concat(
			'-',
			@___colHeaderCd1--value___,
			'-',
			@___colHeaderCd2--value___,
			'-',
			@___colHeaderCd3--value___,
			'-')))
		]">

		<xsl:apply-templates select="." mode="direct"/>
	</xsl:for-each>
</colHeader>

</xsl:template>
<!--*******************************************************************************-->

</xsl:stylesheet>

