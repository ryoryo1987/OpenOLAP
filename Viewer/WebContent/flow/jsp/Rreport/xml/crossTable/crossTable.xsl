<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" version="4.01" encoding="Shift_JIS" indent="yes" />

<!-- ***************************************************************************
		共通変数宣言部
**************************************************************************** -->

<!-- 行もしくは列に配置されたディメンションの名称、コードの情報 -->
<xsl:variable name="rowHeaderCol1" select="//OpenOLAP/property/rowHeader1/rowHeaderName1/@value"></xsl:variable>
<xsl:variable name="rowHeaderCol2" select="//OpenOLAP/property/rowHeader2/rowHeaderName2/@value"></xsl:variable>
<xsl:variable name="rowHeaderCol3" select="//OpenOLAP/property/rowHeader3/rowHeaderName3/@value"></xsl:variable>
<xsl:variable name="rowHeaderColCd1" select="//OpenOLAP/property/rowHeader1/rowHeaderCd1/@value"></xsl:variable>
<xsl:variable name="rowHeaderColCd2" select="//OpenOLAP/property/rowHeader2/rowHeaderCd2/@value"></xsl:variable>
<xsl:variable name="rowHeaderColCd3" select="//OpenOLAP/property/rowHeader3/rowHeaderCd3/@value"></xsl:variable>
<xsl:variable name="colHeaderCol1" select="//OpenOLAP/property/colHeader1/colHeaderName1/@value"></xsl:variable>
<xsl:variable name="colHeaderCol2" select="//OpenOLAP/property/colHeader2/colHeaderName2/@value"></xsl:variable>
<xsl:variable name="colHeaderCol3" select="//OpenOLAP/property/colHeader3/colHeaderName3/@value"></xsl:variable>
<xsl:variable name="colHeaderColCd1" select="//OpenOLAP/property/colHeader1/colHeaderCd1/@value"></xsl:variable>
<xsl:variable name="colHeaderColCd2" select="//OpenOLAP/property/colHeader2/colHeaderCd2/@value"></xsl:variable>
<xsl:variable name="colHeaderColCd3" select="//OpenOLAP/property/colHeader3/colHeaderCd3/@value"></xsl:variable>

<!-- メジャー情報 -->
<xsl:variable name="measure1" select="//OpenOLAP/property/measures/measure1/@value"></xsl:variable>
<xsl:variable name="measure2" select="//OpenOLAP/property/measures/measure2/@value"></xsl:variable>
<xsl:variable name="measure3" select="//OpenOLAP/property/measures/measure3/@value"></xsl:variable>
<xsl:variable name="measure4" select="//OpenOLAP/property/measures/measure4/@value"></xsl:variable>
<xsl:variable name="measure5" select="//OpenOLAP/property/measures/measure5/@value"></xsl:variable>
<xsl:variable name="measure6" select="//OpenOLAP/property/measures/measure6/@value"></xsl:variable>
<xsl:variable name="measure7" select="//OpenOLAP/property/measures/measure7/@value"></xsl:variable>
<xsl:variable name="measure8" select="//OpenOLAP/property/measures/measure8/@value"></xsl:variable>
<xsl:variable name="measure9" select="//OpenOLAP/property/measures/measure9/@value"></xsl:variable>
<xsl:variable name="measure10" select="//OpenOLAP/property/measures/measure10/@value"></xsl:variable>


<!-- 列ヘッダテーブル、データテーブルの列幅の初期値 -->
<xsl:variable name="defaultColWidth" select="100" />


<xsl:key name="属性リスト1" match="//OpenOLAP/data/row" use="
	concat(
		@___rowHeaderCd1--value___
		,'-'
		,@___rowHeaderCd2--value___
		,'-'
		,@___rowHeaderCd3--value___
		,'-',@___colHeaderCd1--value___
		,'-',@___colHeaderCd2--value___
		,'-',@___colHeaderCd3--value___
	)"/>


<!-- 行に配置された軸数 -->
<xsl:variable name="rowHiesCount">
	<xsl:choose>
		<xsl:when test="$rowHeaderCol1!='0' and $rowHeaderCol2!='0' and $rowHeaderCol3!='0' ">
			<xsl:text>3</xsl:text>
		</xsl:when>
		<xsl:when test="$rowHeaderCol1!='0' and $rowHeaderCol2!='0' ">
			<xsl:text>2</xsl:text>
		</xsl:when>
		<xsl:when test="$rowHeaderCol1!='0' ">
			<xsl:text>1</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>0</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>



<!-- 列に配置された軸数 -->
<xsl:variable name="colHiesCount">
	<xsl:choose>
		<xsl:when test="$colHeaderCol1!='0' and $colHeaderCol2!='0' and $colHeaderCol3!='0' ">
			<xsl:text>3</xsl:text>
		</xsl:when>
		<xsl:when test="$colHeaderCol1!='0' and $colHeaderCol2!='0' ">
			<xsl:text>2</xsl:text>
		</xsl:when>
		<xsl:when test="$colHeaderCol1!='0' ">
			<xsl:text>1</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>0</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>



<!-- ***************************************************************************
		メイン出力部
**************************************************************************** -->

<xsl:template match="/">
	<link rel="stylesheet" type="text/css" href="xml/crossTable/css/common.css"/>
	<link id="stylefile" rel="stylesheet" type="text/css" href="xml/crossTable/css/spreadStyle.css"/>

	<script type="text/javascript" src="xml/crossTable/js/colRange.js"></script>
	<script type="text/javascript" src="xml/crossTable/js/spread.js"></script>
	<script type="text/javascript" src="xml/crossTable/js/spreadFunc.js"></script>

<BODY id='SpreadBody' class='SpreadBody' onselectstart="return false" onresize="resizeArea()">

<FORM name='SpreadForm' action="#" method="post">

<!-- メニュー表示部 -->

<!-- Spread表示部 -->
<SPAN onmousedown='mouseDown();' onmouseup='mouseUp();' onmousemove='mouseMove();'>

<TABLE id='SpreadTable' class='SpreadTable' cols='2' style='visibility:hidden;'>
<!-- SPREAD表の各要素であるTABLEタグを配置するためのTABLE -->

	<COLGROUP>
		<COL id='CROSS_RH' />
		<COL id='CH_DC' />
	</COLGROUP>

	<!-- スペース調整用の空行 -->
	<TR>
		<TD>
		</TD>
	</TR>

	<!-- 列に配置された軸のタイトル表示行 -->
	<TR>
		<TD></TD>
		<TD>
			<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader" mode="CH_TITLE">
				<xsl:with-param name="screenType" select="'spread'"/>
			</xsl:apply-templates>
		</TD>
	</TR>

	<!-- 配置用のテーブルで、列ヘッダ・行ヘッダ・列ヘッダの交差セルを格納する列(１列目)を設定。
		 列ヘッダ、行ヘッダ・列ヘッダの交差セルはこの行のセル（TD）内に
		 それぞれTABLEとして記述する。 -->
	<TR>
		<TD>
			<SPAN id='CrossHeaderArea'>

				<!-- 行ヘッダ、列ヘッダの交差部をTABLEで生成。 -->

				<TABLE class='CrossHeaderTable' cellspacing='0' cellpadding='2'>
					<COLGROUP>
						<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="COL">
							<xsl:with-param name="CrossHeaderorRH">CrossHeader</xsl:with-param>
						</xsl:apply-templates>
					</COLGROUP>
					<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="RH_TITLE" />
				</TABLE>
			</SPAN>
		</TD>


	    <!-- 列ヘッダ表示部 -->
		<TD>
			<SPAN id='ColumnHeaderArea' class='ColumnHeaderArea'>

				<TABLE class='ColumnHeaderTable' id='ColumnHeaderTable' cellspacing='0' cellpadding='2'>

					<!-- COLGROUP 生成 -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader">
						<xsl:with-param name="CHorDT" select="'CH'" />
					</xsl:apply-templates>

					<!-- TR,TD 生成 -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader" mode="TRTD" />
					
				</TABLE>
			</SPAN>
		</TD>
	</TR>

    <!-- 行ヘッダ表示部 -->
	<TR>
		<TD>
			<SPAN id='RowHeaderArea' class='RowHeaderArea'>


				<TABLE class='RowHeaderTable' id='RowHeaderTable' cellspacing='0' cellpadding='2'>
				<xsl:attribute name="line"><xsl:value-of select="//tableLine/@line"/></xsl:attribute>

					<COLGROUP id='RH_CGroup'>
						<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="COL">
							<xsl:with-param name="CrossHeaderorRH">RH</xsl:with-param>
						</xsl:apply-templates>
					</COLGROUP>

					<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="CELL"/>

				</TABLE>

			</SPAN>
		</TD>

		<TD>
			<DIV id='DataTableArea' class='DataTableArea'>

				<!-- データ表示部を表すテーブル。
					 データ表示部は一つのTABLEとして表されている。 frame='border' rules='all'-->
				<TABLE id='DataTable' class='DataTable' cellspacing='0' cellpadding='2' >
					<!-- COLGROUP 生成 -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader">
						<xsl:with-param name="CHorDT" select="'DT'" />
					</xsl:apply-templates>

					<!-- TR,TD 生成 -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="DT" />
				</TABLE>

			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>

</FORM>

<!-- 軸情報格納部（テーブルリフレッシュ時に生成） -->
<DIV id="metaDataArea" style="DISPLAY:none">
	<!-- 行ヘッダ、列ヘッダにセットされた軸数 -->
	<DIV id="colHiesCount"><xsl:value-of select="$colHiesCount" /></DIV>
	<DIV id="rowHiesCount"><xsl:value-of select="$rowHiesCount" /></DIV>

</DIV>

</BODY>
</xsl:template>



<!-- **************************************************************************
     **************************************************************************
	     関数群
     **************************************************************************
     ********************************************************************** -->

<!-- ==========================================================================
	 列ヘッダタイトル生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/colHeader" mode="CH_TITLE">
	<xsl:param name="screenType" />
	<xsl:element name="TABLE">
		<xsl:attribute name="class">CH_TITLE_TABLE</xsl:attribute>

		<xsl:element name="TR">

			<!-- 一段目 -->
			<xsl:if test="$colHeaderCol1!='0'">
				<xsl:call-template name="makeColTitleTD">
					<xsl:with-param name="repNode" select=".//row[1]" />
					<xsl:with-param name="positionNo" select="$colHeaderCol1" />
				</xsl:call-template>

				<!-- 二段目 -->
				<xsl:if test="$colHeaderCol2!='0'">
					<xsl:call-template name="makeColTitleTD">
						<xsl:with-param name="repNode" select=".//row[1]" />
						<xsl:with-param name="positionNo" select="$colHeaderCol2" />
					</xsl:call-template>

					<!-- 三段目 -->
					<xsl:if test="$colHeaderCol3!='0'">
						<xsl:call-template name="makeColTitleTD">
							<xsl:with-param name="repNode" select=".//row[1]" />
							<xsl:with-param name="positionNo" select="$colHeaderCol3" />
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:if>


		</xsl:element>
	</xsl:element>

</xsl:template>



<xsl:template name="makeColTitleTD">
	<xsl:param name="repNode" />
	<xsl:param name="positionNo" />

	<xsl:element name="TD">
		<xsl:attribute name="title"><xsl:value-of select="local-name($repNode/@*[name()=$positionNo])" /></xsl:attribute>
		<xsl:attribute name="class">colHieNames</xsl:attribute>

		<xsl:element name="DIV">
			<xsl:attribute name="style">display:inline</xsl:attribute>

			<xsl:element name="NOBR">
				<xsl:element name="DIV">
					<xsl:attribute name="style">display:inline</xsl:attribute>
					<xsl:value-of select="local-name($repNode/@*[name()=$positionNo])" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>


</xsl:template>


<!-- ==========================================================================
	 行ヘッダタイトル生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="RH_TITLE">
	<xsl:choose>
		<xsl:when test="$colHiesCount = 1">
			<xsl:call-template name="makeRowTitleTRTD">
				<xsl:with-param name="rowID" select="0" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$colHiesCount = 2">
			<xsl:element name="TR">
				<xsl:attribute name="id">CrossHeader_R0</xsl:attribute>
				<xsl:element name="TD">
					<xsl:attribute name="id">CrossHeader_R0C0</xsl:attribute>
					<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
					<xsl:text>　</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:call-template name="makeRowTitleTRTD">
				<xsl:with-param name="rowID" select="1" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$colHiesCount = 3">
			<xsl:element name="TR">
				<xsl:attribute name="id">CrossHeader_R0</xsl:attribute>
				<xsl:element name="TD">
					<xsl:attribute name="id">CrossHeader_R0C0</xsl:attribute>
					<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
					<xsl:text>　</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="TR">
				<xsl:attribute name="id">CrossHeader_R1</xsl:attribute>
				<xsl:element name="TD">
					<xsl:attribute name="id">CrossHeader_R1C0</xsl:attribute>
					<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
					<xsl:text>　</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:call-template name="makeRowTitleTRTD">
				<xsl:with-param name="rowID" select="2" />
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>

<!--
		<xsl:with-param name="repNode" select=".//row[1]" />
		<xsl:with-param name="positionNo" select="$colHeaderCol1" />
-->
</xsl:template>


<xsl:template name="makeRowTitleTRTD">
	<xsl:param name="rowID" />

	<xsl:element name="TR">
		<xsl:attribute name="id">CrossHeader_R<xsl:value-of select="$rowID" /></xsl:attribute>

			<xsl:call-template name="makeRowTitleTD">
				<xsl:with-param name="rowID" select="$rowID" />
				<xsl:with-param name="colID" select="0" />
				<xsl:with-param name="positionNo" select="$rowHeaderCol1" />
			</xsl:call-template>
			<xsl:if test="$rowHiesCount &gt; 1" >
				<xsl:call-template name="makeRowTitleTD">
					<xsl:with-param name="rowID" select="$rowID" />
					<xsl:with-param name="colID" select="1" />
					<xsl:with-param name="positionNo" select="$rowHeaderCol2" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$rowHiesCount &gt; 2" >
				<xsl:call-template name="makeRowTitleTD">
					<xsl:with-param name="rowID" select="$rowID" />
					<xsl:with-param name="colID" select="2" />
					<xsl:with-param name="positionNo" select="$rowHeaderCol3" />
				</xsl:call-template>
			</xsl:if>

	</xsl:element>

</xsl:template>



<xsl:template name="makeRowTitleTD">
	<xsl:param name="rowID" />
	<xsl:param name="colID" />
	<xsl:param name="positionNo" />

	<!-- 軸名を取得するために使用するノード -->
	<xsl:variable name="repNode" select=".//row[1]" />

	<xsl:element name="TD">
		<xsl:attribute name="title"><xsl:value-of select="local-name($repNode/@*[name()=$positionNo])" /></xsl:attribute>
		<xsl:attribute name="class">rowHieNames</xsl:attribute>
		<xsl:attribute name="id">CrossHeader_R<xsl:value-of select="$rowID" />C<xsl:value-of select="$colID" /></xsl:attribute>
		<xsl:attribute name="style">border:none;</xsl:attribute>

		<xsl:element name="DIV">
			<xsl:attribute name="style">display:inline;width:100%</xsl:attribute>

			<xsl:element name="NOBR">
				<xsl:element name="DIV">
					<xsl:attribute name="class">CH_TITLE</xsl:attribute>
					<xsl:value-of select="local-name($repNode/@*[name()=$positionNo])" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>

<!-- ==========================================================================
	 列ヘッダテーブルもしくは,データ表示テーブルのCOL要素生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/colHeader">
	<xsl:param name="CHorDT" />

	<xsl:element name="COLGROUP">
		<xsl:if test="$CHorDT='CH'">
			<xsl:attribute name="id">CH_CG</xsl:attribute>
		</xsl:if>
		<xsl:for-each select=".//row">
			<xsl:variable name="hie0XMLNode" select="." />
			<xsl:variable name="hie0XMLIndex" select="position() - 1" />


			<xsl:call-template name="makeColHeaderCOL">
				<xsl:with-param name="CHorDT" select="$CHorDT" />
				<xsl:with-param name="colIndex" select="$hie0XMLIndex" />
			</xsl:call-template>


		</xsl:for-each>

		<!-- 列ヘッダのダミーセル分のCOL要素生成 -->
		<xsl:if test="$CHorDT='CH'">
			<xsl:element name="COL">
				<xsl:attribute name="width"><xsl:value-of select="$defaultColWidth"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:element>

</xsl:template>




<xsl:template name="makeColHeaderCOL">
	<xsl:param name="CHorDT" />
	<xsl:param name="colIndex" />

	<xsl:element name="COL">
		<xsl:attribute name="id"><xsl:value-of select="$CHorDT" />_CG<xsl:value-of select="$colIndex" /></xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="$defaultColWidth"/></xsl:attribute>
		<xsl:if test="$CHorDT='CH'">
			<xsl:attribute name="preWidth">0</xsl:attribute>
		</xsl:if>
	</xsl:element>
</xsl:template>


<!-- ==========================================================================
	 列ヘッダテーブルのTRTD要素を生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/colHeader" mode="TRTD">

	<!-- 一段目 -->
	<xsl:if test="$colHeaderCol1!='0'">
		<xsl:call-template name="makeColHeaderTRTD">
			<xsl:with-param name="rowID" select="0"/>
			<xsl:with-param name="positionNo" select="$colHeaderCol1" />
			<xsl:with-param name="headerClassName" select="'headerColorLV1'" />
		</xsl:call-template>

		<!-- 二段目 -->
		<xsl:if test="$colHeaderCol2!='0'">
			<xsl:call-template name="makeColHeaderTRTD">
				<xsl:with-param name="rowID" select="1"/>
				<xsl:with-param name="positionNo" select="$colHeaderCol2" />
				<xsl:with-param name="headerClassName" select="'headerColorLV2'" />
			</xsl:call-template>

			<!-- 三段目 -->
			<xsl:if test="$colHeaderCol3!='0'">
				<xsl:call-template name="makeColHeaderTRTD">
					<xsl:with-param name="rowID" select="2"/>
					<xsl:with-param name="positionNo" select="$colHeaderCol3" />
					<xsl:with-param name="headerClassName" select="'headerColorLV3'" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:if>

</xsl:template>

<xsl:template name="makeColHeaderTRTD">
	<xsl:param name="rowID" />
	<xsl:param name="positionNo" />
	<xsl:param name="headerClassName" />

	<!-- 
		列にメジャーがある場合の処理を追加
	-->

	<xsl:element name="TR">
		<xsl:attribute name="ID">CH_R<xsl:value-of select="$rowID" /></xsl:attribute>
		<xsl:attribute name="Spread">ColumnHeaderRow</xsl:attribute>

			<xsl:call-template name="makeColHeaderTD">
				<xsl:with-param name="rowID" select="$rowID" />
				<xsl:with-param name="positionNo" select="$positionNo" />
				<xsl:with-param name="headerClassName" select="$headerClassName" />
			</xsl:call-template>


		<!-- スクロール位置調整用のダミーセル生成 -->
		<xsl:element name="TD">
			<xsl:attribute name="id">adjustCell</xsl:attribute>
			<xsl:attribute name="class">adjustCell</xsl:attribute>
			<xsl:attribute name="style">BACKGROUND-COLOR:white;</xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template name="makeColHeaderTD">
	<xsl:param name="rowID" />
	<xsl:param name="positionNo" />
	<xsl:param name="headerClassName" />

	<xsl:for-each select=".//row">

		<xsl:element name="TD">
			<xsl:attribute name="id">CH_R<xsl:value-of select="$rowID" />C<xsl:value-of select="(position() - 1)" /></xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="$headerClassName" /></xsl:attribute>
			<xsl:element name="NOBR">
				<xsl:text /><xsl:value-of select="./@*[name()=$positionNo]" /><xsl:text />
			</xsl:element>

		</xsl:element>
	</xsl:for-each>
</xsl:template>



<!-- ==========================================================================
	 行ヘッダテーブルのCOL要素生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="COL">
	<xsl:param name="CrossHeaderorRH" />

	<!-- 一段目 -->
	<xsl:if test="$rowHeaderCol1!='0'">
		<xsl:element name="COL">
			<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG0</xsl:attribute>
		</xsl:element>

		<!-- 二段目 -->
		<xsl:if test="$rowHeaderCol2!='0'">
			<xsl:element name="COL">
				<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG1</xsl:attribute>
			</xsl:element>

			<!-- 三段目 -->
			<xsl:if test="$rowHeaderCol3!='0'">
				<xsl:element name="COL">
					<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG2</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:if>
	</xsl:if>

</xsl:template>




<!-- ==========================================================================
	 行ヘッダテーブルのTR,TD要素を生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="CELL">


	<xsl:for-each select=".//row">

		<!-- 変数： 行Index(0start) -->
		<xsl:variable name="rowIndex" select="position() - 1" />

		<xsl:element name="TR">
			<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
			<xsl:attribute name="Spread">RowHeaderRow</xsl:attribute>


			<!-- 
				列にメジャーがある場合の処理を追加
			-->

			<!-- 一段目 -->
			<xsl:if test="$rowHeaderCol1!='0'">
				<xsl:element name="TD">
					<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" />C0</xsl:attribute>
					<xsl:attribute name="class">headerColorLV1</xsl:attribute>
					<xsl:element name="NOBR">
						<xsl:text />
							<xsl:value-of select="./@*[name()=$rowHeaderCol1]" />
						<xsl:text />
					</xsl:element>
				</xsl:element>

				<!-- 二段目 -->
				<xsl:if test="$rowHeaderCol2!='0'">
					<xsl:element name="TD">
						<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" />C1</xsl:attribute>
						<xsl:attribute name="class">headerColorLV2</xsl:attribute>
						<xsl:element name="NOBR">
							<xsl:text />
							<xsl:value-of select="./@*[name()=$rowHeaderCol2]" />
							<xsl:text />
						</xsl:element>
					</xsl:element>

					<!-- 三段目 -->
					<xsl:if test="$rowHeaderCol3!='0'">
						<xsl:element name="TD">
							<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" />C3</xsl:attribute>
							<xsl:attribute name="class">headerColorLV3</xsl:attribute>
							<xsl:element name="NOBR">
								<xsl:text />
								<xsl:value-of select="./@*[name()=$rowHeaderCol3]" />
								<xsl:text />
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:element>

	</xsl:for-each>


	<!-- スクロール位置調整用のダミーセル生成 -->
	<xsl:element name="TR">
		<xsl:for-each select="./HierarchyID">
			<xsl:element name="TD">
				<xsl:attribute name="id">adjustCell</xsl:attribute>
				<xsl:attribute name="class">adjustCell</xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>

</xsl:template>


<!-- ==========================================================================
	 データ表示テーブルのTR,TD要素生成
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="DT">

	<!-- データ表示行を生成 -->
	<xsl:for-each select=".//row">

		<!-- 変数： 行Index(0start) -->
		<xsl:variable name="rowIndex" select="position() - 1" />

		<!-- NoRemove --><xsl:variable name="rowVal1" select="./@___rowHeaderCd1--value___" />
		<!-- NoRemove --><xsl:variable name="rowVal2" select="./@___rowHeaderCd2--value___" />
		<!-- NoRemove --><xsl:variable name="rowVal3" select="./@___rowHeaderCd3--value___" />

		<xsl:element name="TR">

			<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
			<!-- データ表示行内にデータ表示セルを生成 -->
				<xsl:for-each select="/OpenOLAP/additionalData/colHeader/row">
		<xsl:variable name="colVal1" select="./@___colHeaderCd1--value___" />
		<xsl:variable name="colVal2" select="./@___colHeaderCd2--value___" />
		<xsl:variable name="colVal3" select="./@___colHeaderCd3--value___" />
						<xsl:element name="TD">
							<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" />C<xsl:value-of select="(position() - 1)" /></xsl:attribute>

								<!-- 値表示 -->
								<xsl:for-each select="key('属性リスト1',
									concat(
										$rowVal1
										,'-',$rowVal2
										,'-',$rowVal3
										,'-',./@___colHeaderCd1--value___
										,'-',./@___colHeaderCd2--value___
										,'-',./@___colHeaderCd3--value___
									))">
									<xsl:value-of select="./@___measure1--value___" />
								</xsl:for-each>
								<br/>

						</xsl:element>
				</xsl:for-each>
			</xsl:element>
	</xsl:for-each>

</xsl:template>


</xsl:stylesheet>
