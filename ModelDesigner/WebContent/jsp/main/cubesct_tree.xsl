<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="Shift_JIS" omit-xml-declaration="yes"/>

<xsl:param name="show_ns"/>
<xsl:variable name="apos">'</xsl:variable>

<xsl:template match="/">

<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>

<title>OpenOLAP Model Designer</title>

<!--************* style sheet **************-->
<link rel="stylesheet" type="text/css" href="../css/tree.css"/>
<link rel="stylesheet" type="text/css" href="../css/rightclick.css"/>

<!--************* js file **************-->
<script language="JavaScript1.2" src="../js/tree.js"></script>
<script language="JavaScript1.2" src="../js/cubesctSet.js"></script>
<script language="JavaScript1.2" src="../js/registration.js"></script>


</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[

]]>
</xsl:comment>
</script>

<body onload="javaScript:init(); javaScript:navi_click('r',document.getElementById('root').firstChild.firstChild)" onselectstart="return false" ondrop="return false" ondragenter="return false" ondragover="return false">

<form id="navi_form" method="post" name="navi_form" target="navi_frm">

<!--Hidden List -->
<input type="hidden" name = "objKind" value=""/>
<input type="hidden" name = "seqId" value=""/>
<input type="hidden" name = "childId" value=""/>

<div id="root"  class="treeItem">
	<xsl:apply-templates select="." mode="tree-art" />
</div>

</form>
</body>
</html>

</xsl:template>

<xsl:template match="/" mode="tree-art">
	<div id="root" class="treeItem">
		<xsl:element name="img">
			<xsl:attribute name="id">root</xsl:attribute>
			<xsl:attribute name="src">../../images/Measure1.gif</xsl:attribute>
			<xsl:attribute name="onclick">javascript:navi_click('r',this); return false;</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="/*/@OBJKIND"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:navi_click('r',this); return false;</xsl:attribute>
			<xsl:attribute name="ondrop">javascript:drop();  return false;</xsl:attribute>
			<xsl:attribute name="ondragover">javascript:overDrag(); return false;</xsl:attribute>
			<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false;</xsl:attribute>
			<xsl:attribute name="ondragenter">javascript:enterDrag(); return false;</xsl:attribute>
			<xsl:attribute name="ondragend">javascript:endDrag(); return false;</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="/*/@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="/*/@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="/*/@OBJKIND"/></xsl:attribute>
			<xsl:text /><xsl:value-of select="/*/text()" /><xsl:text />
		</xsl:element>

		<div id="root" class="treeItem">
			<!-- 必要？ -->
			<xsl:attribute name="style">display:none;</xsl:attribute>
		    <xsl:apply-templates mode="tree-art" select="/*/*" />
		</div>
	</div>
</xsl:template>

<xsl:template match="*" mode="tree-art">

	<xsl:variable name="imgFileName">
		<xsl:choose>
			<xsl:when test="local-name()='Measure'">../../images/Measure2.gif</xsl:when>
			<xsl:when test="local-name()='TimeDim'">../../images/TimeDimensionTop2.gif</xsl:when>
			<xsl:when test="local-name()='TimeParts'">../../images/TimeDimension2.gif</xsl:when>
			<xsl:when test="local-name()='Dimension'">../../images/Dimension2.gif</xsl:when>
			<xsl:when test="local-name()='Parts'">../../images/CustParts2.gif</xsl:when>
			<xsl:otherwise>../../images/Dummy.gif</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="execFileName">
		<xsl:choose>
			<xsl:when test="local-name()='Dummy'">dummy.jsp</xsl:when>
			<xsl:otherwise>dummy.jsp</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="dispStyle">
		<xsl:choose>
			<xsl:when test="local-name()='Dummy'">display:none;</xsl:when>
			<xsl:otherwise>display:none;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="div">
		<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
		<xsl:attribute name="class">treeItem</xsl:attribute>
		<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>

	    <xsl:call-template name="tree-art-hierarchy" />

		<xsl:element name="img">
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$imgFileName" /></xsl:attribute>
			<xsl:attribute name="onclick">javascript:navi_click('f',this)</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:navi_click('f',this); return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
			<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragend">javascript:endDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test='@LV = "0"'>
					<xsl:attribute name="ondblclick">javascript:navi_dbl_click('0',this)</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ondblclick">javascript:navi_dbl_click('f',this)</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text /><xsl:value-of select="text()" /><xsl:text />
		</xsl:element>

			<xsl:element name="div">
				<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" />-C<xsl:text /></xsl:attribute>
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
			<xsl:when test="local-name()='Measure'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../../images/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../images/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      

		<xsl:when test = "not(node())">
			<img id="5" src="../../images/T.gif"/>
		</xsl:when>

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="5" src="../../images/Lplus.gif" onclick="JavaScript:navi_click('LP',this);" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="5" src="../../images/Tplus.gif" onclick="JavaScript:navi_click('TP',this);" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="5" src="../../images/L.gif" onclick="JavaScript:navi_click('LP',this);" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="5" src="../../images/T.gif" onclick="JavaScript:navi_click('TP',this);" ondragstart="return false;"/>
		</xsl:when>

		<xsl:otherwise><img id="1" src="../../images/blank.gif" ondragstart="return false;"/></xsl:otherwise>                                           

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
