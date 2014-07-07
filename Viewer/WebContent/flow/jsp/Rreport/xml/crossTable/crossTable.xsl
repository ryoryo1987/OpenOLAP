<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" version="4.01" encoding="Shift_JIS" indent="yes" />

<!-- ***************************************************************************
		���ʕϐ��錾��
**************************************************************************** -->

<!-- �s�������͗�ɔz�u���ꂽ�f�B�����V�����̖��́A�R�[�h�̏�� -->
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

<!-- ���W���[��� -->
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


<!-- ��w�b�_�e�[�u���A�f�[�^�e�[�u���̗񕝂̏����l -->
<xsl:variable name="defaultColWidth" select="100" />


<xsl:key name="�������X�g1" match="//OpenOLAP/data/row" use="
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


<!-- �s�ɔz�u���ꂽ���� -->
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



<!-- ��ɔz�u���ꂽ���� -->
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
		���C���o�͕�
**************************************************************************** -->

<xsl:template match="/">
	<link rel="stylesheet" type="text/css" href="xml/crossTable/css/common.css"/>
	<link id="stylefile" rel="stylesheet" type="text/css" href="xml/crossTable/css/spreadStyle.css"/>

	<script type="text/javascript" src="xml/crossTable/js/colRange.js"></script>
	<script type="text/javascript" src="xml/crossTable/js/spread.js"></script>
	<script type="text/javascript" src="xml/crossTable/js/spreadFunc.js"></script>

<BODY id='SpreadBody' class='SpreadBody' onselectstart="return false" onresize="resizeArea()">

<FORM name='SpreadForm' action="#" method="post">

<!-- ���j���[�\���� -->

<!-- Spread�\���� -->
<SPAN onmousedown='mouseDown();' onmouseup='mouseUp();' onmousemove='mouseMove();'>

<TABLE id='SpreadTable' class='SpreadTable' cols='2' style='visibility:hidden;'>
<!-- SPREAD�\�̊e�v�f�ł���TABLE�^�O��z�u���邽�߂�TABLE -->

	<COLGROUP>
		<COL id='CROSS_RH' />
		<COL id='CH_DC' />
	</COLGROUP>

	<!-- �X�y�[�X�����p�̋�s -->
	<TR>
		<TD>
		</TD>
	</TR>

	<!-- ��ɔz�u���ꂽ���̃^�C�g���\���s -->
	<TR>
		<TD></TD>
		<TD>
			<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader" mode="CH_TITLE">
				<xsl:with-param name="screenType" select="'spread'"/>
			</xsl:apply-templates>
		</TD>
	</TR>

	<!-- �z�u�p�̃e�[�u���ŁA��w�b�_�E�s�w�b�_�E��w�b�_�̌����Z�����i�[�����(�P���)��ݒ�B
		 ��w�b�_�A�s�w�b�_�E��w�b�_�̌����Z���͂��̍s�̃Z���iTD�j����
		 ���ꂼ��TABLE�Ƃ��ċL�q����B -->
	<TR>
		<TD>
			<SPAN id='CrossHeaderArea'>

				<!-- �s�w�b�_�A��w�b�_�̌�������TABLE�Ő����B -->

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


	    <!-- ��w�b�_�\���� -->
		<TD>
			<SPAN id='ColumnHeaderArea' class='ColumnHeaderArea'>

				<TABLE class='ColumnHeaderTable' id='ColumnHeaderTable' cellspacing='0' cellpadding='2'>

					<!-- COLGROUP ���� -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader">
						<xsl:with-param name="CHorDT" select="'CH'" />
					</xsl:apply-templates>

					<!-- TR,TD ���� -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader" mode="TRTD" />
					
				</TABLE>
			</SPAN>
		</TD>
	</TR>

    <!-- �s�w�b�_�\���� -->
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

				<!-- �f�[�^�\������\���e�[�u���B
					 �f�[�^�\�����͈��TABLE�Ƃ��ĕ\����Ă���B frame='border' rules='all'-->
				<TABLE id='DataTable' class='DataTable' cellspacing='0' cellpadding='2' >
					<!-- COLGROUP ���� -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/colHeader">
						<xsl:with-param name="CHorDT" select="'DT'" />
					</xsl:apply-templates>

					<!-- TR,TD ���� -->
					<xsl:apply-templates select="/OpenOLAP/additionalData/rowHeader" mode="DT" />
				</TABLE>

			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>

</FORM>

<!-- �����i�[���i�e�[�u�����t���b�V�����ɐ����j -->
<DIV id="metaDataArea" style="DISPLAY:none">
	<!-- �s�w�b�_�A��w�b�_�ɃZ�b�g���ꂽ���� -->
	<DIV id="colHiesCount"><xsl:value-of select="$colHiesCount" /></DIV>
	<DIV id="rowHiesCount"><xsl:value-of select="$rowHiesCount" /></DIV>

</DIV>

</BODY>
</xsl:template>



<!-- **************************************************************************
     **************************************************************************
	     �֐��Q
     **************************************************************************
     ********************************************************************** -->

<!-- ==========================================================================
	 ��w�b�_�^�C�g������
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/colHeader" mode="CH_TITLE">
	<xsl:param name="screenType" />
	<xsl:element name="TABLE">
		<xsl:attribute name="class">CH_TITLE_TABLE</xsl:attribute>

		<xsl:element name="TR">

			<!-- ��i�� -->
			<xsl:if test="$colHeaderCol1!='0'">
				<xsl:call-template name="makeColTitleTD">
					<xsl:with-param name="repNode" select=".//row[1]" />
					<xsl:with-param name="positionNo" select="$colHeaderCol1" />
				</xsl:call-template>

				<!-- ��i�� -->
				<xsl:if test="$colHeaderCol2!='0'">
					<xsl:call-template name="makeColTitleTD">
						<xsl:with-param name="repNode" select=".//row[1]" />
						<xsl:with-param name="positionNo" select="$colHeaderCol2" />
					</xsl:call-template>

					<!-- �O�i�� -->
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
	 �s�w�b�_�^�C�g������
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
					<xsl:text>�@</xsl:text>
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
					<xsl:text>�@</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="TR">
				<xsl:attribute name="id">CrossHeader_R1</xsl:attribute>
				<xsl:element name="TD">
					<xsl:attribute name="id">CrossHeader_R1C0</xsl:attribute>
					<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
					<xsl:text>�@</xsl:text>
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

	<!-- �������擾���邽�߂Ɏg�p����m�[�h -->
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
	 ��w�b�_�e�[�u����������,�f�[�^�\���e�[�u����COL�v�f����
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

		<!-- ��w�b�_�̃_�~�[�Z������COL�v�f���� -->
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
	 ��w�b�_�e�[�u����TRTD�v�f�𐶐�
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/colHeader" mode="TRTD">

	<!-- ��i�� -->
	<xsl:if test="$colHeaderCol1!='0'">
		<xsl:call-template name="makeColHeaderTRTD">
			<xsl:with-param name="rowID" select="0"/>
			<xsl:with-param name="positionNo" select="$colHeaderCol1" />
			<xsl:with-param name="headerClassName" select="'headerColorLV1'" />
		</xsl:call-template>

		<!-- ��i�� -->
		<xsl:if test="$colHeaderCol2!='0'">
			<xsl:call-template name="makeColHeaderTRTD">
				<xsl:with-param name="rowID" select="1"/>
				<xsl:with-param name="positionNo" select="$colHeaderCol2" />
				<xsl:with-param name="headerClassName" select="'headerColorLV2'" />
			</xsl:call-template>

			<!-- �O�i�� -->
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
		��Ƀ��W���[������ꍇ�̏�����ǉ�
	-->

	<xsl:element name="TR">
		<xsl:attribute name="ID">CH_R<xsl:value-of select="$rowID" /></xsl:attribute>
		<xsl:attribute name="Spread">ColumnHeaderRow</xsl:attribute>

			<xsl:call-template name="makeColHeaderTD">
				<xsl:with-param name="rowID" select="$rowID" />
				<xsl:with-param name="positionNo" select="$positionNo" />
				<xsl:with-param name="headerClassName" select="$headerClassName" />
			</xsl:call-template>


		<!-- �X�N���[���ʒu�����p�̃_�~�[�Z������ -->
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
	 �s�w�b�_�e�[�u����COL�v�f����
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="COL">
	<xsl:param name="CrossHeaderorRH" />

	<!-- ��i�� -->
	<xsl:if test="$rowHeaderCol1!='0'">
		<xsl:element name="COL">
			<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG0</xsl:attribute>
		</xsl:element>

		<!-- ��i�� -->
		<xsl:if test="$rowHeaderCol2!='0'">
			<xsl:element name="COL">
				<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG1</xsl:attribute>
			</xsl:element>

			<!-- �O�i�� -->
			<xsl:if test="$rowHeaderCol3!='0'">
				<xsl:element name="COL">
					<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG2</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:if>
	</xsl:if>

</xsl:template>




<!-- ==========================================================================
	 �s�w�b�_�e�[�u����TR,TD�v�f�𐶐�
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="CELL">


	<xsl:for-each select=".//row">

		<!-- �ϐ��F �sIndex(0start) -->
		<xsl:variable name="rowIndex" select="position() - 1" />

		<xsl:element name="TR">
			<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
			<xsl:attribute name="Spread">RowHeaderRow</xsl:attribute>


			<!-- 
				��Ƀ��W���[������ꍇ�̏�����ǉ�
			-->

			<!-- ��i�� -->
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

				<!-- ��i�� -->
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

					<!-- �O�i�� -->
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


	<!-- �X�N���[���ʒu�����p�̃_�~�[�Z������ -->
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
	 �f�[�^�\���e�[�u����TR,TD�v�f����
 ========================================================================== -->
<xsl:template match="/OpenOLAP/additionalData/rowHeader" mode="DT">

	<!-- �f�[�^�\���s�𐶐� -->
	<xsl:for-each select=".//row">

		<!-- �ϐ��F �sIndex(0start) -->
		<xsl:variable name="rowIndex" select="position() - 1" />

		<!-- NoRemove --><xsl:variable name="rowVal1" select="./@___rowHeaderCd1--value___" />
		<!-- NoRemove --><xsl:variable name="rowVal2" select="./@___rowHeaderCd2--value___" />
		<!-- NoRemove --><xsl:variable name="rowVal3" select="./@___rowHeaderCd3--value___" />

		<xsl:element name="TR">

			<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
			<!-- �f�[�^�\���s���Ƀf�[�^�\���Z���𐶐� -->
				<xsl:for-each select="/OpenOLAP/additionalData/colHeader/row">
		<xsl:variable name="colVal1" select="./@___colHeaderCd1--value___" />
		<xsl:variable name="colVal2" select="./@___colHeaderCd2--value___" />
		<xsl:variable name="colVal3" select="./@___colHeaderCd3--value___" />
						<xsl:element name="TD">
							<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" />C<xsl:value-of select="(position() - 1)" /></xsl:attribute>

								<!-- �l�\�� -->
								<xsl:for-each select="key('�������X�g1',
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
