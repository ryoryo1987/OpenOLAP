<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
<xsl:output indent="yes" omit-xml-declaration="no" encoding="Shift_JIS"/>

<xsl:variable name="sizeWidth" select="//OpenOLAP/property/sizeWidth/@value"></xsl:variable>
<xsl:variable name="sizeHeight" select="//OpenOLAP/property/sizeHeight/@value"></xsl:variable>

<xsl:template match="/">
	<html lang="ja">
	<head>
	<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS"/>

	<title>OpenOLAP</title>
		<link rel="stylesheet" type="text/css" href="xml/chart/common.css"/>
		<link rel="stylesheet" type="text/css" href="../../../css/common.css"/>
		<link id="stylefile" rel="stylesheet" type="text/css" href="xml/chart/spreadStyle_blue_1.css"/>
		<script language="JavaScript1.2" src="xml/chart/simpleChart.js"></script>
	</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[
function displayChart(XMLDoc,XSLDoc){
	var tempXMLStr=XMLDoc.transformNode(XSLDoc);
	tempXMLStr=tempXMLStr.substr(tempXMLStr.indexOf("?>")+2);
	document.form_main.chartXML.value="<?xml version='1.0' encoding='Shift_JIS'?>"+tempXMLStr;
	document.form_main.chartXML.value=encodeURI(document.form_main.chartXML.value);//
//document.form_main.chartXML.value=escape(document.form_main.chartXML.value);

//alert(document.form_main.chartXML.value);
//alert(tempXMLStr);
	if(tempXMLStr.indexOf("<CategoryAxisName><")!=-1){
		return;
	}
	if(tempXMLStr.indexOf("<ValueAxisName><")!=-1){
		return;
	}
	if(tempXMLStr.indexOf("<Value><")!=-1){
		return;
	}

//alert(tempXMLStr);
	document.form_main.action = "../../../Controller?action=dispChartFromXML&chartDispMode=xml&strCode=Shift_JIS";
	document.form_main.target = "frm_chart";
	document.form_main.submit();


}


]]>
</xsl:comment>
</script>

	<body>
	<form name="form_main" method="post">
<xsl:element name="div">
	<xsl:attribute name="style">margin:10 20 20 20;display:<xsl:value-of select="//OpenOLAP/property/dispTable/@dispTable" /></xsl:attribute>
	<xsl:apply-templates select="OpenOLAP" />
</xsl:element>

<div style='display:inline'>
<xsl:element name="iframe">
	<xsl:attribute name="name">frm_chart</xsl:attribute>
	<xsl:attribute name="src">blank.html</xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="$sizeWidth+5" /></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="$sizeHeight+10" />" /></xsl:attribute>
	<xsl:attribute name="style">margin-left:20</xsl:attribute>
</xsl:element>

</div>

<textarea name="xmlText" id='xmlText' cols="50" rows="5" style='display:none'>
	<xsl:apply-templates select="/" mode="direct"/>
</textarea>

<input type="hidden" name="chartXML" id="chartXML" value=""/>

	</form>
	</body>
	</html>
</xsl:template>

<xsl:template match="OpenOLAP">
<table id="tblTableBody" class="ListTable">
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

<!--*******************************************************************************-->
<xsl:template match="@*|*|text()" mode="direct">
	<xsl:copy>
		<xsl:apply-templates select="@*|*|text()"  mode="direct"/>
	</xsl:copy>
</xsl:template>
<!--*******************************************************************************-->

</xsl:stylesheet>

