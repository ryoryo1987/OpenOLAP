<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">


<xsl:comment>ソート初期設定</xsl:comment>
<xsl:variable name="Sort_select">4</xsl:variable>
<xsl:variable name="Sort_data-type">text</xsl:variable>
<xsl:variable name="Sort_order">ascending</xsl:variable>



<xsl:template match="/">





<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>

<title>OpenOLAP Model Designer</title>
	<link rel="stylesheet" type="text/css" href="../css/common.css"/>


<script type="text/JavaScript">
<xsl:comment>
<![CDATA[




	function sort(sort_no,sort_type){

		if(document.form_main.Sort_order.value=="ascending"){
			document.form_main.Sort_order.value="descending";
		}else if(document.form_main.Sort_order.value=="descending"){
			document.form_main.Sort_order.value="ascending";
		}

		var key1 = document.XSLDocument.selectSingleNode("*//xsl:sort/@select");
		var key2 = document.XSLDocument.selectSingleNode("*//xsl:sort/@data-type");
		var key3 = document.XSLDocument.selectSingleNode("*//xsl:sort/@order");

		//xsl:sortの属性値を変更
		//selectを指定
		key1.value = "./value[" + sort_no +"]";

		//data-typeを指定
		if(sort_type=="Number"){//typeがdefaultであればnumberでソート
			key2.value = "number";
		}else if(sort_type=="Text"){
			key2.value = "text";//typeがそれ以外ならばtextでソート
		}

		//orderを指定
		key3.value = document.form_main.Sort_order.value;

		var source = document.XMLDocument.selectSingleNode("rows");
		myTable.innerHTML = source.transformNode(document.XSLDocument);


	}


]]>
</xsl:comment>
</script>

</head>




<body>
<form name="form_main" method="post">


 <input type="hidden" name="Sort_select" value="" />
 <input type="hidden" name="Sort_data-type" value="" />
 <input type="hidden" name="Sort_order" value="ascending" />

<table class="frame" style="margin-left:7px;">
	<tr>
		<td class="main" style="text-align:left;padding-left:15">
			<div id="myTable"><xsl:apply-templates select="rows" /></div>
		</td>
	</tr>
</table>
</form>
</body>
</html>
</xsl:template>



<xsl:template match="rows">
<b>
	<xsl:choose>
		<xsl:when test="/rows/error[.!='']">
			SQLが不正です。<br/>
			<xsl:value-of select="/rows/error" />
		</xsl:when>
		<xsl:otherwise>
			レコード <xsl:value-of select="count(/rows/row)" />件
			<xsl:if test="count(/rows/row) = 1000">
				のみ表示
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</b>

<table id="tblTableBody" class="standard" cellspacing="0">
	<tr>
		<xsl:for-each select="//heading">
			<th class="standard">
				<xsl:attribute name="onclick">
					sort('<xsl:value-of select="position()"/>','<xsl:value-of select="../type"/>' )
				</xsl:attribute>
				<xsl:attribute name="onmouseover">
					<xsl:text>
						this.style.cursor='hand'
					</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="style">
					<xsl:text>
						display:inline;
					</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="nowrap"/>

				<xsl:value-of select="." />

			</th>
		</xsl:for-each>
	</tr>

	<xsl:for-each select="/rows/row">
		<xsl:sort select="./value[number($Sort_select)]" data-type="{$Sort_data-type}" order="{$Sort_order}" />
		<xsl:variable name="rowNum" select="position()" />
		<tr>
			<xsl:variable name="tempPosition" select="."/>

			<xsl:for-each select="./value">
				<td class="standard">
					<nobr>

						<xsl:variable name="cellNum" select="position()" />

					<!--	<xsl:if test="$rowNum = 1 or . != parent::row/preceding-sibling::row[1]/value[$cellNum]">-->
							<xsl:value-of select="." />
					<!--	</xsl:if>-->

					</nobr>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:for-each>

	<tr style="visibility:hidden;">
		<xsl:for-each select="//heading">
			<td>
				<nobr>
					<xsl:value-of select="."/>
				</nobr>
			</td>
		</xsl:for-each>
	</tr>

</table>

<!--
								<xsl:for-each select="/rows/row[2]/value">
									<xsl:variable name="i" select="position()" />
									<xsl:value-of select="parent::row/preceding-sibling::row/value[$i]" />
								</xsl:for-each>
-->

</xsl:template>
</xsl:stylesheet>

