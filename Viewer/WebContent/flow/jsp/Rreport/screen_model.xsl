<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="Shift_JIS" omit-xml-declaration="yes"/>

<xsl:param name="show_ns"/>
<xsl:variable name="apos">'</xsl:variable>

<xsl:template match="/">

<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
<title>OpenOLAP</title>
<link type="text/css" rel="stylesheet" href="../../../css/common.css"/>
<link type="text/css" rel="stylesheet" href="../../../css/tree.css"/>

<script language="JavaScript1.2" src="js/dbtree.js"></script>
</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[

	function clickNode(th){
		//Set Property
		var source = document.XMLDocument.selectSingleNode("//*[@id="+th.id+"]");
		var screenType = parent.frm_property.document.getElementById("modelType");
		screenType.innerText=source.getAttribute("name");
		screenType.seq=source.getAttribute("id");

		parent.frm_css.reloadDisplayXML();//displayXMLを初期化
	}


]]>
</xsl:comment>
</script>

<body style="margin-top:0px;margin-left:0px;padding-top:0px;background : url('../../../images/Rreport/title.gif') white repeat-x">
<!--<body onload="createPopUpMenu()" onContextmenu="return false">-->
<form name="navi_form" id="navi_form" target="navi_frm" method="post" action="">

<input type="hidden" name = "a"/>
<input type="hidden" name = "preClick"/>

<input type="hidden" name = "child_record" value=""/>
<input type="hidden" name = "parent_record" value=""/>

<input type="hidden" name = "objKind" value=""/>
<input type="hidden" name = "seqId" value=""/>


<input type="hidden" name = "change_flg" value="0"/>


<input type="hidden" name = "copyObj_objKind" value=""/>
<input type="hidden" name = "copyObj_id" value=""/>
<input type="hidden" name = "copyParentObj_objKind" value=""/>
<input type="hidden" name = "copyParentObj_id" value=""/>


<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">論理モデル</td>
	</tr>
</table>

<div id="root" class="treeItem" style="margin-left:7">
	    <xsl:apply-templates select="." mode="tree-art" />
</div>

</form>
</body>
</html>

</xsl:template>

<xsl:template match="/" mode="tree-art">
	<div id="root" class="treeItem" style="border-style:hidden">
		<div id="root" class="treeItem" style="font-size : 12px; font-weight: normal;">
		    <xsl:apply-templates mode="tree-art" select="/*/*" />
		</div>
	</div>
</xsl:template>

<xsl:template match="*" mode="tree-art">

		<xsl:variable name="imgFileName">
			<xsl:choose>
				<xsl:when test="local-name()='dimensions'">../../../images/Rreport/DimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='dimension'">../../../images/Rreport/Dimension2.gif</xsl:when>
				<xsl:when test="local-name()='measures'">../../../images/Rreport/MeasureTop2.gif</xsl:when>
				<xsl:when test="local-name()='measure'">../../../images/Rreport/Measure2.gif</xsl:when>
				<xsl:when test="local-name()='level'">../../../images/Rreport/Level2.gif</xsl:when>

				<xsl:when test="local-name()='folder'">../../../images/Rreport/foldericon2.gif</xsl:when>
				<xsl:when test="local-name()='gamen'">../../../images/Rreport/gamen2.gif</xsl:when>
				<xsl:when test="local-name()='css'">../../../images/Rreport/css2.gif</xsl:when>
				<xsl:when test="local-name()='model'">../../../images/Rreport/model2.gif</xsl:when>

				<xsl:otherwise>../../../images/Rreport/foldericon2.gif</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="dispStyle">
			<xsl:choose>
				<xsl:when test="local-name()='dimensions'">display:block;</xsl:when>
				<xsl:when test="local-name()='measures'">display:block;</xsl:when>
				<xsl:otherwise>display:none;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>



	<xsl:element name="div">
		<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
		<xsl:attribute name="class">treeItem</xsl:attribute>
		<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

	    <xsl:call-template name="tree-art-hierarchy" />

		<xsl:element name="img">
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$imgFileName" /></xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'')</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:clickNode(this);return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@id" /><xsl:text /></xsl:attribute>

			<xsl:attribute name="ondragstart">javascript:startDrag();</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

			<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'')</xsl:attribute>
			<xsl:text /><xsl:value-of select="@name" /><xsl:text />
		</xsl:element>

			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@id" />-C<xsl:text /></xsl:attribute>
				<xsl:attribute name="style"><xsl:value-of select="$dispStyle" /></xsl:attribute>
				<xsl:attribute name="class">container</xsl:attribute>
				    <xsl:apply-templates mode="tree-art" />
			</xsl:element>

	</xsl:element>


</xsl:template>

<!-- Plobably Delete function-->
<xsl:template match="text()" mode="tree-art">
</xsl:template>

<xsl:template match="comment()" mode="tree-art">
    <xsl:call-template name="tree-art-hierarchy" />
    <xsl:text />___comment '<xsl:value-of select="." />'&#xA;<xsl:text />
</xsl:template>

<xsl:template name="tree-art-hierarchy">
    <xsl:for-each select="ancestor::*">
        <xsl:choose>
			<xsl:when test="local-name()='models'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../../../images/Rreport/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../../images/Rreport/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      

<!--
		<xsl:when test = "not(node())">
			<img id="L" src="../../../images/Rreport/T.gif"/>
		</xsl:when>
-->

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="L" src="../../../images/Rreport/Lplus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="L" src="../../../images/Rreport/Tplus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="L" src="../../../images/Rreport/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="L" src="../../../images/Rreport/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

       <xsl:otherwise><img id="1" src="../../../images/Rreport/blank.gif"/></xsl:otherwise>                                           
   </xsl:choose>                                                                                                     

</xsl:template>

<!-- recursive template to escape backslashes, apostrophes, newlines and tabs -->
<xsl:template name="escape-ws">
    <xsl:param name="text" />
    <xsl:choose>
        <xsl:when test="contains($text, '\')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '\')" />
            </xsl:call-template>
            <xsl:text>\\</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '\')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($text, $apos)">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, $apos)" />
            </xsl:call-template>
            <xsl:text>\'</xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, $apos)" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($text, '&#xA;')">
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-before($text, '&#xA;')" />
            </xsl:call-template>
            <xsl:text></xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#xA;')" />
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($text, '&#x9;')">
            <xsl:value-of select="substring-before($text, '&#x9;')" />
            <xsl:text></xsl:text>
            <xsl:call-template name="escape-ws">
                <xsl:with-param name="text" select="substring-after($text, '&#x9;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>
