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
<link type="text/css" rel="stylesheet" href="../css/tree.css"/>

<!--************* right Click **************-->
<!--************* End right Click **************-->

<script language="JavaScript" src="../js/registration.js"></script>
<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[
var preClickObj = new Object;
var preRightClickObj = new Object;
var preAddObj = new Object;

preClickObj.src = "null";


	function outputName(obj){
		if(obj.id==parent.document.form_main.hid_obj_seq.value){
			showMsg("FML1");
			return;
		}

		if(parent.document.form_main.are_formula.value!=""){
			parent.document.form_main.are_formula.value+="\n";
		}
		if(obj.mtype==1){
			parent.document.form_main.are_formula.value+="[%" + obj.innerHTML + "%]";
		}else if(obj.mtype==2){
			parent.document.form_main.are_formula.value+="[@" + obj.innerHTML + "@]";
		}
	}

]]>
</xsl:comment>
</script>
</head>

<body onload="">
<!--<body onload="createPopUpMenu()" onContextmenu="return false">-->
<form id="navi_form" method="post" name="navi_form" target="navi_frm"> 
<input type="hidden" name = "a"/>
<input type="hidden" name = "preClick"/>

<input type="hidden" name = "child_record" value=""/>
<input type="hidden" name = "parent_record" value=""/>

<input type="hidden" name = "objKind" value=""/>
<input type="hidden" name = "seqId" value=""/>

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
			<xsl:attribute name="id">root</xsl:attribute><!--<xsl:text /><xsl:value-of select="/*/@ID" /><xsl:text />-->
			<xsl:attribute name="src">../../images/Cube1.gif</xsl:attribute>
			<xsl:attribute name="onclick">return false;</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="/*/@OBJKIND"/></xsl:attribute>
		</xsl:element>

			<xsl:text /><xsl:value-of select="/*/text()" /><xsl:text />

			<div id="root" class="treeItem">
			    <xsl:apply-templates mode="tree-art" select="/*/*" />
			</div>
	</div>
</xsl:template>

<xsl:template match="*" mode="tree-art">

		<xsl:variable name="imgFileName">
			<xsl:choose>
				<xsl:when test="local-name()='Measure'">../../images/Measure2.gif</xsl:when>
				<xsl:when test="local-name()='CustomCalcCubeCalcMeasure'">../../images/CustomMeasure2.gif</xsl:when>
				<xsl:when test="local-name()='Configuration'">../../images/Configuration2.gif</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="execFileName">
			<xsl:choose>
				<xsl:when test="local-name()='Measure'">frm_measure.jsp</xsl:when>
				<xsl:when test="local-name()='CustomCalcCubeCalcMeasure'">frm_custom_calc_cube.jsp</xsl:when>
				<xsl:when test="local-name()='Configuration'">user_objects.jsp</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="dispStyle">
			<xsl:choose>
				<xsl:when test="local-name()='UserObjects'">display:none;</xsl:when>
			<!-- ************************************* 0611 ****************************************** -->
				<xsl:when test="local-name()='OLAPUsers'">display:none;</xsl:when>
			<!-- ************************************* 0611 ****************************************** -->
				<xsl:when test="local-name()='DimensionObjects'">display:none;</xsl:when>
				<xsl:when test="local-name()='TimeDimensionObjects'">display:none;</xsl:when>
				<xsl:when test="local-name()='MeasureObjects'">display:none;</xsl:when>
				<xsl:when test="local-name()='CustomCalculation'">display:none;</xsl:when>
				<xsl:when test="local-name()='CustomDimensions'">display:none;</xsl:when>
				<xsl:when test="local-name()='CubeObjects'">display:none;</xsl:when>
				<xsl:when test="local-name()='DMLTuning'">display:none;</xsl:when>
				<xsl:otherwise>display:block;</xsl:otherwise>
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
			<xsl:attribute name="onclick">return false;</xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">return false;</xsl:attribute>
			<xsl:attribute name="ondblclick">javascript:outputName(this);return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="mtype"><xsl:text /><xsl:value-of select="@MTYPE" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="ondragstart">return false;</xsl:attribute>
<!--
			<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
			<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragend">javascript:endDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
-->
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
<!--
			<xsl:choose>
				<xsl:when test='@LV = "0"'>
					<xsl:attribute name="ondblclick">javascript:ToggleDblClick('0',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>')</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>')</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
-->
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

<xsl:template match="text()" mode="tree-art">
<!--	<xsl:if test="string-length(translate(.,'&#x9;&#xA;',''))!=0">															-->
<!--		<div id="text" class="container" style="display: block;">															-->
<!--		    <xsl:call-template name="tree-art-hierarchy" />                                                                 -->
<!--				<img id="8-icon" src="../../images/file.gif" onclick="JavaScript:this.nextSibling.focus();"/>                     -->
<!--				<a href="javascript:void(0);" id="8-anchor" onfocus="javascript:void(0);" onblur="javascript:void(0);">     -->
<!--				    <xsl:call-template name="escape-ws">                                                                    -->
<!--			        <xsl:with-param name="text" select="." />                                                               -->
<!--				    </xsl:call-template>                                                                                    -->
<!--				</a>                                                                                                        -->
<!--		</div>                                                                                                              -->
<!--	</xsl:if>                                                                                                               -->
</xsl:template>

<xsl:template match="comment()" mode="tree-art">
    <xsl:call-template name="tree-art-hierarchy" />
    <xsl:text />___comment '<xsl:value-of select="." />'&#xA;<xsl:text />
</xsl:template>

<xsl:template name="tree-art-hierarchy">
    <xsl:for-each select="ancestor::*">
        <xsl:choose>
			<xsl:when test="local-name()='Cube'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="../../images/I.gif"/></xsl:when>
			<xsl:otherwise><img id="H" src="../../images/blank.gif"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      
<!-- DEBUG -->
		<xsl:when test = "not(node())">
			<img id="5" src="../../images/T.gif"/>
		</xsl:when>

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="5" src="../../images/Lminus.gif" onclick="JavaScript:Toggle('LP',this); return false"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="5" src="../../images/Tminus.gif" onclick="JavaScript:Toggle('TP',this); return false"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="5" src="../../images/L.gif" onclick="JavaScript:Toggle('LP',this); return false"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="5" src="../../images/T.gif" onclick="JavaScript:Toggle('TP',this); return false"/>
		</xsl:when>




<!--		<xsl:when test = "@LV='0' and not(following-sibling::*)">												-->
<!--			<img id="5" src="../../images/L.gif"/>                                                                    -->
<!--		</xsl:when>                                                                                             -->
<!--		<xsl:when test = "@LV='0' and following-sibling::*">                                                    -->
<!--			<img id="5" src="../../images/T.gif"/>                                                                    -->
<!--		</xsl:when>                                                                                             -->
<!--                                                                                                                -->
<!--		<xsl:when test = "not(following-sibling::*)">                                                           -->
<!--			<img id="5" src="../../images/Lplus.gif" onclick="JavaScript:Toggle('L',this);"/>                         -->
<!--		</xsl:when>                                                                                             -->
<!--		<xsl:when test="parent::node() and ../child::node()">                                                   -->
<!--			<img id="5" src="../../images/Tplus.gif" onclick="JavaScript:Toggle('T',this);"/>                         -->
<!--		</xsl:when>                                                                                             -->

       <xsl:otherwise><img id="1" src="../../images/blank.gif"/></xsl:otherwise>                                           
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
