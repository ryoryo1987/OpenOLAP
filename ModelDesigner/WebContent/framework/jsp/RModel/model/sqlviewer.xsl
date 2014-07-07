<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">


<xsl:comment>ソート初期設定</xsl:comment>
<!--
<xsl:variable name="Sort_select">1</xsl:variable>
<xsl:variable name="Sort_datatype"><xsl:value-of select="//coldef/column[1]/type" /></xsl:variable>
<xsl:variable name="Sort_order">ascending</xsl:variable>
-->
<xsl:variable name="Sort_select"></xsl:variable>
<xsl:variable name="Sort_datatype"></xsl:variable>
<xsl:variable name="Sort_order"></xsl:variable>


<xsl:template match="/">


<html lang="ja">
<head>
<title></title>
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS"/>
<link rel="stylesheet" type="text/css" href="../../css/xmlTable.css"/>
<script type="text/javascript" src="../../js/xmlTable.js"></script>
<script type="text/javascript" src="../../js/load.js"></script>
<script type="text/JavaScript">
<xsl:comment>
<![CDATA[




	function sort(sort_no,sort_type,obj){
		if(obj.style.cursor=="col-resize"){
			return;
		}

		if(document.SpreadForm.Sort_order.value=="ascending"){
			document.SpreadForm.Sort_order.value="descending";
		}else if(document.SpreadForm.Sort_order.value=="descending"){
			document.SpreadForm.Sort_order.value="ascending";
		}else if(document.SpreadForm.Sort_order.value==""){
			document.SpreadForm.Sort_order.value="descending";
		}


		//data-typeを指定
		if(sort_type=="number"){
			document.SpreadForm.Sort_datatype.value = "number";
		}else if(sort_type=="text"){
			document.SpreadForm.Sort_datatype.value = "text";
		}else{
			document.SpreadForm.Sort_datatype.value = "text";
		}


		var key1 = document.XSLDocument.selectSingleNode("*//xsl:sort/@select");
		var key2 = document.XSLDocument.selectSingleNode("*//xsl:sort/@data-type");
		var key3 = document.XSLDocument.selectSingleNode("*//xsl:sort/@order");


		var aaa = document.XSLDocument.selectSingleNode("*//xsl:variable[@name='cnt']");
//		aaa.setAttribute("loadCnt","1");
		aaa.text=1;
		//xsl:sortの属性値を変更
		//selectを指定
		key1.value = "./value[" + sort_no +"]";
		key2.value = document.SpreadForm.Sort_datatype.value;
		//orderを指定
		key3.value = document.SpreadForm.Sort_order.value;


//		document.XSLDocument.selectSingleNode("*//xsl:variable[@name='Sort_select']").text="2";
//	var key1=document.XSLDocument.selectSingleNode("*//xsl:variable[@name='Sort_select']");
//	var key2=document.XSLDocument.selectSingleNode("*//xsl:variable[@name='Sort_datatype']");
//	var key3=document.XSLDocument.selectSingleNode("*//xsl:variable[@name='Sort_order']");
//		key1.text = "./value[" + sort_no +"]";
//		key2.text = document.SpreadForm.Sort_datatype.value;
//		key3.text = document.SpreadForm.Sort_order.value;
//alert(document.XSLDocument.xml)

		var source = document.XMLDocument.selectSingleNode("rows");
		DataTableArea.innerHTML = source.transformNode(document.XSLDocument);




		changeAllCellWidth();
	}


]]>
</xsl:comment>
</script>

</head>




<BODY id="SpreadBody" onload="loadSpread();" onselectstart="return false" onresize="resizeArea()">
<FORM name="SpreadForm">
<SPAN onmousedown="mouseDown2();" onmouseup="mouseUp();">
<TABLE id="SpreadTable" class="SpreadTable">
	<TR>
		<TD>
			<SPAN id="ColumnHeaderArea" onmousemove="mouseMove();">
				<TABLE class="ColumnHeaderTable" cellspacing="0" cellpadding="2">
					<xsl:call-template name="columngroup1" />
				</TABLE>
			</SPAN>
		</TD>
	</TR>
	<TR>
		<TD>
			<DIV id="DataTableArea">
				<xsl:apply-templates select="rows" />
			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>

	<input type="hidden" name="Sort_select" value="" />
	<input type="hidden" name="Sort_datatype" value="" />
	<input type="hidden" name="Sort_order" value="" />


</FORM>


</BODY>
</html>
</xsl:template>



<xsl:template name="columngroup1">
	<COLGROUP id="columngroup1">
		<xsl:for-each select="rows/coldef/column">
			<COL>
				<xsl:attribute name="style">
					width:<xsl:value-of select="width" />;
				</xsl:attribute>
			</COL>
		</xsl:for-each>
	</COLGROUP>

	<TR Spread="ColumnHeaderRow">
		<xsl:for-each select="rows/coldef/column">
			<TD>
				<xsl:attribute name="onclick">
					sort('<xsl:value-of select="position()"/>','<xsl:value-of select="type"/>',this);
				</xsl:attribute>

				<xsl:value-of select="heading" />
			</TD>
		</xsl:for-each>
		<TD style="border:none;" class="adjustCell"></TD>
	</TR>
</xsl:template>




<xsl:template match="rows">

<input type="hidden" name="loadCnt" loadCnt="0" />
<xsl:variable name="cnt">0</xsl:variable>

<TABLE id="DataTable" cellspacing="0" cellpadding="2">
	<COLGROUP id="columngroup2">
		<xsl:for-each select="coldef/column">
			<COL>
				<xsl:attribute name="style">
					width:<xsl:value-of select="width" />;
				</xsl:attribute>
			</COL>
		</xsl:for-each>
	</COLGROUP>

<xsl:choose>
	<xsl:when test="$cnt=1">
		<xsl:for-each select="/rows/row">
				<xsl:sort select="./value[number($Sort_select)]" data-type="{$Sort_datatype}" order="{$Sort_order}" />
			<xsl:variable name="rowNum" select="position()" />
			<tr>
				<xsl:variable name="tempPosition" select="."/>

				<xsl:for-each select="./value">
					<td class="standard">
						<xsl:variable name="cellNum" select="position()" />

						<xsl:attribute name="align">
							<xsl:choose>
								<xsl:when test="//coldef/column[$cellNum]/type[.='number']">
									<xsl:text>right</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>left</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<nobr>
							<xsl:value-of select="." />
						</nobr>
					</td>
				</xsl:for-each>
			</tr>
		</xsl:for-each>
	</xsl:when>

	<xsl:otherwise>
		<xsl:for-each select="/rows/row">
			<xsl:variable name="rowNum" select="position()" />
			<tr>
				<xsl:variable name="tempPosition" select="."/>

				<xsl:for-each select="./value">
					<td class="standard">
						<xsl:variable name="cellNum" select="position()" />

						<xsl:attribute name="align">
							<xsl:choose>
								<xsl:when test="//coldef/column[$cellNum]/type[.='number']">
									<xsl:text>right</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>left</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<nobr>
							<xsl:value-of select="." />
						</nobr>
					</td>
				</xsl:for-each>
			</tr>
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>


</TABLE>

</xsl:template>
</xsl:stylesheet>

