<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
<xsl:output indent="yes" />

<xsl:variable name="maxRow" select="count(//additionalData/rowHeader/row)"></xsl:variable>

<xsl:template match="/">
<OpenOLAP>
    <xsl:apply-templates select="//property" mode="direct"/>
    <xsl:apply-templates select="//sql" mode="direct"/>
    <xsl:apply-templates select="//screenSql" mode="direct"/>

    <xsl:apply-templates select="//data" mode="direct"/>

	<!--何件表示するか-->
<additionalData>
	<rowHeader>
		<xsl:apply-templates select="//additionalData/rowHeader"/>
	</rowHeader>
	<xsl:apply-templates select="//additionalData/colHeader" mode="direct"/>
</additionalData>
</OpenOLAP>

</xsl:template>

<!--*******************************************************************************-->
<xsl:template match="@*|*|text()" mode="direct">
	<xsl:copy>
		<xsl:apply-templates select="@*|*|text()"  mode="direct"/>
	</xsl:copy>
</xsl:template>
<!--*******************************************************************************-->
<xsl:template match="rowHeader">
	<!--何件表示するか-->
	<xsl:call-template name="loop">
		<xsl:with-param name="count" select="number(//OpenOLAP/property/dispRow/@*[name()='startRow'])" />
		<xsl:with-param name="end" select="number(//OpenOLAP/property/dispRow/@*[name()='endRow'])" />
		<xsl:with-param name="rowVal" select="/row[number(//OpenOLAP/property/dispRow/@*[name()='startRow'])]" />
	</xsl:call-template>
</xsl:template>

<!--*******************************************************************************-->
<!--*****************固定回数ループ処理***************-->
<xsl:template name="loop">
	<xsl:param name="count"/> 
	<xsl:param name="end" /> 
	<xsl:param name="rowVal" /> 

	<xsl:if test="$count &lt;= $end">
		<xsl:call-template name="oneRec">
			<xsl:with-param name="rowNum" select="$count" /> 
			<xsl:with-param name="rowVal" select="$rowVal" /> 
		</xsl:call-template>

		<xsl:call-template name="loop">
			<xsl:with-param name="end" select="$end" /> 
			<xsl:with-param name="count" select="$count + 1" /> 
			<xsl:with-param name="rowVal" select="/row[$count+1]" /> 
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<!--*******************************************************************************-->

<!--*******************************************************************************-->
<xsl:template name="oneRec">
	<xsl:param name="rowNum"/> 
	<xsl:param name="rowVal"/> 
		<xsl:if test="$rowNum &lt;= $maxRow">
		    <xsl:apply-templates select="./*[$rowNum]" mode="direct"/>
		</xsl:if>
</xsl:template>
<!--*******************************************************************************-->
</xsl:stylesheet>

