<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">


<xsl:comment>ソート初期設定</xsl:comment>
<xsl:variable name="Sort_select"></xsl:variable>
<xsl:variable name="Sort_data-type"></xsl:variable>
<xsl:variable name="Sort_order"></xsl:variable>



<xsl:template match="/">





<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>

<title>OpenOLAP Model Designer</title>
	<link rel="stylesheet" type="text/css" href="../css/common.css"/>
	<link rel="stylesheet" type="text/css" href="../css/report.css"/>



<script type="text/JavaScript">
<xsl:comment>
<![CDATA[


]]>
</xsl:comment>
</script>

</head>




<body>
<form name="form_main" id="form_main" method="post" action="">
	<!-- レイアウト用 -->
	<div class="main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main">
 				<!-- コンテンツ -->


				 <input type="hidden" name="Sort_select" value="" />
				 <input type="hidden" name="Sort_data-type" value="" />
				 <input type="hidden" name="Sort_order" value="ascending" />
				<br/>
				<div id="myTable" style="margin:10 20 20 20;"><xsl:apply-templates select="rows" /></div>


			</td>
			<td class="right"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>

</form>
</body>
</html>
</xsl:template>



<xsl:template match="rows">

<xsl:choose>
<xsl:when test="count(/rows/row) &gt; 0">

	<table class="standard_report">
		<caption>
			<xsl:choose>
				<xsl:when test="/rows/error[.!='']">
					SQLが不正です。<br/>
					<xsl:value-of select="/rows/error" />
				</xsl:when>
				<xsl:otherwise>
					<a target="_blank">
						<xsl:attribute name="href"><xsl:value-of select="/rows/csv" /></xsl:attribute>
						<img src="../../images/excel.gif" alt="CSV形式出力"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</caption>
		<tr>
			<xsl:for-each select="//heading">
				<th class="standard_center" align="center">
					<xsl:value-of select="." />
				</th>
			</xsl:for-each>
		</tr>

		<xsl:for-each select="/rows/row">
			<xsl:variable name="rowNum" select="position()" />
			<tr>

				<xsl:for-each select="./value">
					<xsl:variable name="cellNum" select="position()" />
					<xsl:variable name="separateCol" select="./@group"/>



						<xsl:choose>
							<xsl:when test="$rowNum = 1 or . != parent::row/preceding-sibling::row[1]/value[$cellNum] or parent::row/value[number($separateCol)]!= parent::row/preceding-sibling::row[1]/value[number($separateCol)]">
								<td class="standard_top">
									<xsl:attribute name="align"><xsl:value-of select="./@pos" /></xsl:attribute>
									<xsl:value-of select="." />
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="standard_null">
									<xsl:attribute name="align"><xsl:value-of select="./@pos" /></xsl:attribute>
								</td>
							</xsl:otherwise>
						</xsl:choose>

				</xsl:for-each>
			</tr>
		</xsl:for-each>

	</table>

</xsl:when>
<xsl:otherwise>
	<font size="3">登録されている<xsl:value-of select="//objectname" />はありません。</font>
</xsl:otherwise>
</xsl:choose>

</xsl:template>
</xsl:stylesheet>

