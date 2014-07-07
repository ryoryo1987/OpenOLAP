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
<link type="text/css" rel="stylesheet" href="jsp/css/tree.css"/>

<!--************* right Click **************-->
<link rel="stylesheet" type="text/css" href="jsp/css/rightclick.css"/>
<script language="JavaScript1.2" src="jsp/js/leftTreeRightclick.js"></script>
<!--************* End right Click **************-->

<script language="JavaScript1.2" src="jsp/js/addTreeMember.js"></script>
<script language="JavaScript1.2" src="jsp/js/tree.js"></script>

<!-- Message -->
<script language="JavaScript1.2" src="jsp/js/registration.js"></script>
</head>

<script type="text/JavaScript1.2">
<xsl:comment>
<![CDATA[
]]>
</xsl:comment>
</script>

<body onload="createMenu()" onselectstart="return false;" onContextmenu="return false" style="margin-top:0px;margin-left:0px;padding-top:0px">
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



<img src="images/tree/menu.gif" style="margin-left:10;padding:0" ondragstart="return false;" onClick="javascript:Toggle('r',this.nextSibling,'introduction.jsp?id=root');" ondblClick="javascript:reverseDisplay(this.parentNode);"/>

<!--ツリータイトル部分-->
<table style="border-collapse:collapse;width:100%;table-layout:fixed;margin:0">
	<tr>
		<td style="width:49;height:34;background:url('images/tree/tree_title_left.gif') no-repeat"></td>
		<td style="height:34;background:url('images/tree/tree_title_center.gif') repeat-x;text-align:center;padding-top:10"><img src="images/tree/tree_title.gif" /></td>
		<td style="width:39;height:34;background:url('images/tree/tree_title_right.gif') no-repeat"></td>
	</tr>
</table>
<table style="border-collapse:collapse;width:100%;height:80%;table-layout:fixed">
	<tr>
		<td style="width:20;background-color:white"></td>
		<td style="background:url('images/tree/bg.jpg') no-repeat ;vertical-align:top">
			<div id="root" class="treeItem" style="padding-top:18;padding-left:16;width:100%;height:100%;overflow:auto">
				<xsl:apply-templates select="." mode="tree-art" />
			</div>
		</td>
		<td style="width:7;background-color:white"></td>
	</tr>
</table>


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
				<xsl:when test="local-name()='Configuration'">images/Configuration2.gif</xsl:when>
				<xsl:when test="local-name()='SchemaTop'">images/SchemaTop2.gif</xsl:when>
				<xsl:when test="local-name()='Schema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='ObjectDefinition'">images/ObjectDefinition2.gif</xsl:when>
				<xsl:when test="local-name()='DimensionTop'">images/DimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='DimensionSchema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='Dimension'">images/Dimension2.gif</xsl:when>
				<xsl:when test="local-name()='SegmentDimensionTop'">images/SegmentDimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='SegmentDimensionSchema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='SegmentDimension'">images/SegmentDimension2.gif</xsl:when>
				<xsl:when test="local-name()='TimeDimensionTop'">images/TimeDimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='TimeDimension'">images/TimeDimension2.gif</xsl:when>
				<xsl:when test="local-name()='MeasureTop'">images/MeasureTop2.gif</xsl:when>
				<xsl:when test="local-name()='MeasureSchema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='Measure'">images/Measure2.gif</xsl:when>
				<xsl:when test="local-name()='CubeModeling'">images/CubeModeling2.gif</xsl:when>
				<xsl:when test="local-name()='CubeTop'">images/CubeTop2.gif</xsl:when>
				<xsl:when test="local-name()='Cube'">images/Cube2.gif</xsl:when>
				<xsl:when test="local-name()='CubeStructure'">images/CubeStructure2.gif</xsl:when>
				<xsl:when test="local-name()='CustomMeasureTop'">images/CustomMeasureTop2.gif</xsl:when>
				<xsl:when test="local-name()='CustomMeasureCube'">images/Cube2.gif</xsl:when>
				<xsl:when test="local-name()='CustomMeasure'">images/CustomMeasure2.gif</xsl:when>
				<xsl:when test="local-name()='CustomDimSchema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='CustomSegDimSchema'">images/Schema2.gif</xsl:when>
				<xsl:when test="local-name()='CustomizeDimensionTop'">images/CustomizeDimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='CustomDimensionTop'">images/DimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='CustomDimension'">images/Dimension2.gif</xsl:when>
				<xsl:when test="local-name()='DimParts'">images/DimParts2.gif</xsl:when>
				<xsl:when test="local-name()='CustomSegmentDimensionTop'">images/SegmentDimensionTop2.gif</xsl:when>
				<xsl:when test="local-name()='CustomSegmentDimension'">images/SegmentDimension2.gif</xsl:when>
				<xsl:when test="local-name()='SegmentParts'">images/SegParts2.gif</xsl:when>
				<xsl:when test="local-name()='CubeManager'">images/CubeManager2.gif</xsl:when>
				<xsl:when test="local-name()='SQLTuning'">images/SQLTuning2.gif</xsl:when>
				<xsl:when test="local-name()='SQLTuningCube'">images/Cube2.gif</xsl:when>
				<xsl:when test="local-name()='SQLTuningCategory'">images/SQLTuningCategory2.gif</xsl:when>
				<xsl:when test="local-name()='CreateCube'">images/CreateCube2.gif</xsl:when>
				<xsl:when test="local-name()='LogOut'">images/Exit2.gif</xsl:when>
				<xsl:otherwise>images/foldericon2.gif</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="execFileName">
			<xsl:choose>
				<xsl:when test="local-name()='Configuration'">configuration.jsp</xsl:when>
				<xsl:when test="local-name()='SchemaTop'">frm_user.jsp</xsl:when>
				<xsl:when test="local-name()='Schema'">frm_user.jsp</xsl:when>
				<xsl:when test="local-name()='ObjectDefinition'">object_difinition.jsp</xsl:when>
				<xsl:when test="local-name()='DimensionTop'">dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='DimensionSchema'">frm_dimension.jsp</xsl:when>
				<xsl:when test="local-name()='Dimension'">frm_dimension.jsp</xsl:when>
				<xsl:when test="local-name()='SegmentDimensionTop'">seg_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='SegmentDimensionSchema'">frm_seg_dimension.jsp</xsl:when>
				<xsl:when test="local-name()='SegmentDimension'">frm_seg_dimension.jsp</xsl:when>
				<xsl:when test="local-name()='TimeDimensionTop'">frm_time.jsp</xsl:when>
				<xsl:when test="local-name()='TimeDimension'">frm_time.jsp</xsl:when>
				<xsl:when test="local-name()='MeasureTop'">measure_top.jsp</xsl:when>
				<xsl:when test="local-name()='MeasureSchema'">frm_measure.jsp</xsl:when>
				<xsl:when test="local-name()='Measure'">frm_measure.jsp</xsl:when>
				<xsl:when test="local-name()='CubeModeling'">cube_modeling.jsp</xsl:when>
				<xsl:when test="local-name()='CubeTop'">frm_cube.jsp</xsl:when>
				<xsl:when test="local-name()='Cube'">frm_cube.jsp</xsl:when>
				<xsl:when test="local-name()='CubeManager'">cube_manager.jsp</xsl:when>
				<xsl:when test="local-name()='CubeStructure'">frm_cubesct.jsp</xsl:when>
				<xsl:when test="local-name()='CustomMeasureTop'">custom_measure_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomMeasureCube'">frm_formula.jsp</xsl:when>
				<xsl:when test="local-name()='CustomMeasure'">frm_formula.jsp</xsl:when>
				<xsl:when test="local-name()='CustomDimSchema'">custom_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomSegDimSchema'">custom_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomizeDimensionTop'">customize_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomDimensionTop'">custom_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomDimension'">frm_cust_dim.jsp</xsl:when>
				<xsl:when test="local-name()='DimParts'">frm_cust_dim.jsp</xsl:when>
				<xsl:when test="local-name()='CustomSegmentDimensionTop'">custom_seg_dimension_top.jsp</xsl:when>
				<xsl:when test="local-name()='CustomSegmentDimension'">frm_segment_dim.jsp</xsl:when>
				<xsl:when test="local-name()='SegmentParts'">frm_segment_dim.jsp</xsl:when>
				<xsl:when test="local-name()='SQLTuning'">sql_tuning.jsp</xsl:when>
				<xsl:when test="local-name()='SQLTuningCube'">frm_sqltng.jsp</xsl:when>
				<xsl:when test="local-name()='SQLTuningCategory'">frm_sqltng.jsp</xsl:when>
				<xsl:when test="local-name()='CreateCube'">frm_jobstatus.jsp</xsl:when>
				<xsl:when test="local-name()='LogOut'">logout.jsp</xsl:when>
				<xsl:otherwise>treeTable.jsp</xsl:otherwise>
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
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>')</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:element>

		<xsl:element name="a">
			<xsl:attribute name="href">return false;</xsl:attribute>
			<xsl:attribute name="onclick">javascript:Toggle('f',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>'); return false;</xsl:attribute>
			<xsl:attribute name="id"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="name"><xsl:text /><xsl:value-of select="@ID" /><xsl:text /></xsl:attribute>
			<xsl:attribute name="ondrop">javascript:drop(); return false</xsl:attribute>
			<xsl:attribute name="ondragover">javascript:overDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragleave">javascript:leaveDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragenter">javascript:enterDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragend">javascript:endDrag(); return false</xsl:attribute>
			<xsl:attribute name="ondragstart">javascript:startDrag(); return false</xsl:attribute>
			<xsl:attribute name="objkind"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test='@LV = "0"'>
					<xsl:attribute name="ondblclick">javascript:ToggleDblClick('0',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>')</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ondblclick">javascript:ToggleDblClick('f',this,'<xsl:value-of select="$execFileName" />?id=<xsl:value-of select="@ID"/>')</xsl:attribute>
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
			<xsl:when test="local-name()='OpenOlap'"> </xsl:when>
			<xsl:when test="following-sibling::*"><img id="H" src="images/tree/I.gif" ondragstart="return false;"/></xsl:when>
			<xsl:otherwise><img id="H" src="images/blank.gif" ondragstart="return false;"/></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>

   <xsl:choose>                                                                                                      

		<xsl:when test = "not(node())">
			<img id="5" src="images/tree/T.gif"/>
		</xsl:when>

		<xsl:when test = "child::* and not(following-sibling::*)">
			<img id="5" src="images/tree/Lplus.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "child::* and following-sibling::*">
			<img id="5" src="images/tree/Tplus.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and not(following-sibling::*)">
			<img id="5" src="images/tree/L.gif" onclick="JavaScript:Toggle('LP',this,'');" ondragstart="return false;"/>
		</xsl:when>

		<xsl:when test = "not(child::*) and following-sibling::*">
			<img id="5" src="images/tree/T.gif" onclick="JavaScript:Toggle('TP',this,'');" ondragstart="return false;"/>
		</xsl:when>

       <xsl:otherwise><img id="1" src="images/blank.gif"/></xsl:otherwise>                                           
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
