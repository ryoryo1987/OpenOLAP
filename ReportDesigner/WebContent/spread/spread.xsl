<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" version="4.01" encoding="Shift_JIS" indent="yes" />

<!-- ���ʕϐ��錾�� -->

<!-- �s����ї�̊e�i��ID���i�[����I�u�W�F�N�g -->
<xsl:variable name="colHieObj"  select="/root/OlapInfo/AxesInfo/COL" />
<xsl:variable name="rowHieObj"  select="/root/OlapInfo/AxesInfo/ROW" />
<xsl:variable name="pageHieObj" select="/root/OlapInfo/AxesInfo/PAGE" />

<!-- �s����ї�̊e�i�̎�����ID(hierarchy��ID�^�O�̒l) -->
<xsl:variable name="colHie0ID" select="$colHieObj/HierarchyID[1]" />
<xsl:variable name="colHie1ID" select="$colHieObj/HierarchyID[2]" />
<xsl:variable name="colHie2ID" select="$colHieObj/HierarchyID[3]" />
<xsl:variable name="rowHie0ID" select="$rowHieObj/HierarchyID[1]" />
<xsl:variable name="rowHie1ID" select="$rowHieObj/HierarchyID[2]" />
<xsl:variable name="rowHie2ID" select="$rowHieObj/HierarchyID[3]" />

<!-- �s����ї�̊e�i�̎����̃I�u�W�F�N�g -->
<xsl:variable name="colHie0Node" select="/root/Axes/Members[@id=$colHie0ID]" />
<xsl:variable name="colHie1Node" select="/root/Axes/Members[@id=$colHie1ID]" />
<xsl:variable name="colHie2Node" select="/root/Axes/Members[@id=$colHie2ID]" />
<xsl:variable name="rowHie0Node" select="/root/Axes/Members[@id=$rowHie0ID]" />
<xsl:variable name="rowHie1Node" select="/root/Axes/Members[@id=$rowHie1ID]" />
<xsl:variable name="rowHie2Node" select="/root/Axes/Members[@id=$rowHie2ID]" />

<!-- �s����ї�̎��� -->
<xsl:variable name="colHiesCount" select="count($colHieObj/HierarchyID)" />
<xsl:variable name="rowHiesCount" select="count($rowHieObj/HierarchyID)" />

<!-- �s����ї�̊e�i�̃����o�� -->
<xsl:variable name="colHie0Count" select="count($colHie0Node//Member)" />
<xsl:variable name="colHie1Count" select="count($colHie1Node//Member)" />
<xsl:variable name="colHie2Count" select="count($colHie2Node//Member)" />
<xsl:variable name="rowHie0Count" select="count($rowHie0Node//Member)" />
<xsl:variable name="rowHie1Count" select="count($rowHie1Node//Member)" />
<xsl:variable name="rowHie2Count" select="count($rowHie2Node//Member)" />

<!-- �g�ݍ��킹�� -->
<xsl:variable name="colComboNum">
	<xsl:choose>
		<xsl:when test="$colHiesCount=1">
			<xsl:value-of select="$colHie0Count" />
		</xsl:when>
		<xsl:when test="$colHiesCount=2">
			<xsl:value-of select="$colHie0Count*$colHie1Count" />
		</xsl:when>
		<xsl:when test="$colHiesCount=3">
			<xsl:value-of select="$colHie0Count*$colHie1Count*$colHie2Count" />
		</xsl:when>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="rowComboNum">
	<xsl:choose>
		<xsl:when test="$rowHiesCount=1">
			<xsl:value-of select="$rowHie0Count" />
		</xsl:when>
		<xsl:when test="$rowHiesCount=2">
			<xsl:value-of select="$rowHie0Count*$rowHie1Count" />
		</xsl:when>
		<xsl:when test="$rowHiesCount=3">
			<xsl:value-of select="$rowHie0Count*$rowHie1Count*$rowHie2Count" />
		</xsl:when>
	</xsl:choose>
</xsl:variable>


	<!-- �ϐ�����
		underColIndex1ComboNum:��̈�i�ڂ����̒i�̎������o�̑g�ݍ��킹��
		underColIndex2ComboNum:��̓�i�ڂ����̒i�̎������o�̑g�ݍ��킹��
		underColIndex3ComboNum:��̎O�i�ڂ����̒i�̎������o�̑g�ݍ��킹��
		���s�̒i���̏ꍇ�Ɠ������ꍇ�́A1��Ԃ�
	 -->
	<xsl:variable name="underColIndex1ComboNum">
		<xsl:choose>
			<xsl:when test="$colHiesCount=1">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="$colHiesCount=2">
				<xsl:value-of select="$colHie1Count" />
			</xsl:when>
			<xsl:when test="$colHiesCount=3">
				<xsl:value-of select="$colHie1Count * $colHie2Count" />
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="underColIndex2ComboNum">
		<xsl:choose>
			<xsl:when test="$colHiesCount=2">
				<xsl:value-of select="1" />
			</xsl:when>
			<xsl:when test="$colHiesCount=3">
				<xsl:value-of select="$colHie2Count" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="underColIndex3ComboNum">
		<xsl:choose>
			<xsl:when test="$colHiesCount=3">
				<xsl:value-of select="1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

<xsl:template match="/">

<BODY id='SpreadBody' class='SpreadBody' onload="loadSpread();" onselectstart="return false" onresize="resizeArea()"> 

<!-- ���j���[�\���� -->
<!-- �p���b�g -->
<div name="divPallet" id="divPallet" class="divPallet">
	<table id="tblColorPallet" cellpadding="0" cellspacing="0" border="0" onselectstart="return false;">
		<tr valign="middle">
			<td colspan='4' align="middle">
				<table id="remove" colorStyle="" title="�h��Ԃ��Ȃ�" cellpadding="0" cellspacing="0" border="1" bordercolor="black" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img style="display:none" src="./images/color/transparent.gif" /> <!-- �u�h��Ԃ��̐F�v�{�^���̍����ɕ\������C���[�W��� -->
							�h��Ԃ��Ȃ�
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr valign="middle">
			<td>
				<!-- �� -->
				<table id="tblRed" colorStyle="Red" title="��" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="��" src="./images/color/red.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- �� -->
				<table id="tblOrange" colorStyle="Orange" title="��" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="��" src="./images/color/orange.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- ���F -->
				<table id="tblYellow" colorStyle="Yellow" title="���F" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="���F" src="./images/color/yellow.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- �� -->
				<table id="tblGreen" colorStyle="Green" title="��" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="��" src="./images/color/green.gif" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<!-- ���F -->
				<table id="tblLightBlue" colorStyle="LightBlue" title="���F" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="���F" src="./images/color/lightblue.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- �� -->
				<table id="tblBlue" colorStyle="Blue" title="��" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="��" src="./images/color/blue.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- �� -->
				<table id="tblPurple" colorStyle="Purple" title="��" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="��" src="./images/color/purple.gif" />
						</td>
					</tr>
				</table>
			</td>
			<td>
				<!-- �s���N -->
				<table id="tblPink" colorStyle="Pink" title="�s���N" cellpadding="0" cellspacing="0" border="0" onMouseUp="subWindowButton_up(this);">
					<tr valign="middle">
						<td>
							<img hspace="0" height="12" width="12" border="0" alt="�s���N" src="./images/color/pink.gif" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<FORM name='SpreadForm' action="#" method="post">

<table id="spreadHeader" class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>

		<!-- ���|�[�g�^�C�g�� -->
		<td valign="top" class="HeaderTitleCenter" style="padding-top:16">
			<xsl:value-of select="root/OlapInfo/ReportInfo/Report/ReportName" />
		</td>

		<!-- �c�[���o�[�G���A -->
		<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
			<!-- �Z���N�^�{�^�� -->
			<table id="tblSelecterBtn" title="�Z���N�^" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<div style="display:inline;white-space:nowrap;" onclick="openSelector(16,1);"> <!-- ���W���[���w�肵��(������=16)�A���N���b�N(������=1)�ŃZ���N�^�I�[�v�� -->
							<img src="./images/selecter.gif" class="normal_toolicon" onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
						</div>
					</td>
				</tr>
			</table>
		</td>
		<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 0 0 0">
			<table style="border-collapse:collapse">
				<tr>
					<td>
						<table id="tblColorBtn" title="�h��Ԃ��̐F" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;">
										<img src="./images/paint.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" onClick="tbClick(this);" />
									</div>
								</td>
							</tr>
						</table>
						<table id="tblHigtLightBtn" style="display:none;" title="�n�C���C�g" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onclick="openHighLight();">
										<img src="./images/highlight.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td class="HeaderTitleCenter" style="width:10;text-align:right;padding:6 5 0 0">
			<table style="border-collapse:collapse">
				<tr>
					<td>
						<table id="tblChartBtnRight" group='color' groupId='tblColorBtn' title="�J���[�I��" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onclick="return clickColorButton(event);">
										<img src="./images/tri_bottom.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td id="tblChartTd" class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0;">
			<!-- �O���t�̎�ރ{�^�� -->
			<table id="tblChartBtn" title="�O���t�̎��" cellpadding="0" cellspacing="0" border="0">
				<tr valign="middle">
					<td>
						<div id="chartKindArea" style="width:22;display:inline;white-space:nowrap;" onclick="return clickChartButton(event,'000');">
							<img style="display:none;" />
						</div>
					</td>
				</tr>
			</table>
		</td>

<!-- ��ʕ����X�^�C��-->
		<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
			<table id="tabWindowDivisionBtn" title="��ʕ\��" cellpadding="0" cellspacing="0" border="0">
				<tr valign="middle">
					<td>
						<div style="display:inline;white-space:nowrap;" onclick="clickDisplayStyle(event);">
							<img id="tabWindowDivisionBtn_Img" src="./images/chart/table.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
						</div>
					</td>
				</tr>
			</table>
		</td>

		<xsl:if test="root/UserInfo/isThisReportExportable = 1">
			<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
				<!-- �G�N�X�|�[�g -->
				<table id="tblExpBtn" title="�G�N�X�|�[�g" cellpadding="0" cellspacing="0" border="0">
					<tr valign="middle">
						<td>
							<div style="display:inline;white-space:nowrap;" onClick="export_button_click();">
								<xsl:choose>
									<xsl:when test="root/UserInfo/exportType='CSV'">
										<img src="./images/export_csv.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />

									</xsl:when>
									<xsl:when test="root/UserInfo/exportType = 'XMLSpreadSheet'">
										<img src="./images/export_csv.gif" class="normal_toolicon" onMouseOver="className='over_toolicon'" onMouseDown="className='down_toolicon'" onMouseUp="className='up_toolicon'" onMouseOut="className='out_toolicon'" />
									</xsl:when>
								</xsl:choose>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</xsl:if>
		<!-- �ۑ� -->
		<xsl:if test="(root/UserInfo/isAdmin = 1) or (root/UserInfo/isPersonalReportSavable = 1) ">
			<xsl:if test="root/OlapInfo/ReportInfo/Report/isNewReport != 1">
				<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
					<table id="tblSaveBtn" title="�ۑ�" cellpadding="0" cellspacing="0" border="0">
						<tr valign="middle">
							<td>
								<div style="display:inline;white-space:nowrap;" onClick='saveReportInfo("","");'>
									<img src="./images/save.gif" class="normal_toolicon" onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />

								</div>
							</td>
						</tr>
					</table>
				</td>
			</xsl:if>
		</xsl:if>

		<!-- ���O�A�E�g -->
		<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:5 5 0 0">
			<table id="tblLogoutBtn" title="���O�A�E�g" cellpadding="0" cellspacing="0" border="0">
				<tr valign="middle">
					<td>
						<div style="display:inline;white-space:nowrap;" onClick="logout();">
							<img src="./images/logout.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
						</div>
					</td>
				</tr>
			</table>
		</td>
		<!-- �c�[���o�[�G���A end -->
	</tr>
</table>

<!-- �y�[�W�G�b�W�\���G���A�O�g -->
<span class="spanPageEdge">
<table id="tblPageEdge" width="100%" cellpadding="0" cellspacing="0" onselectstart="return false;">
	<tr valign="top">
		<td width="8" style="background-color:white"></td>
		<td>
			<!-- �y�[�W�G�b�W -->
			<table style="border-collapse:collapse" border="0">
				<tr>
					<td style="padding:0">
					<!-- �y�[�W�G�b�W�\���� -->
					<TABLE name='pageEdgeTable' id='pageEdgeTable' class='pageEdgeTable'>
						<TR style='visibility:hidden;'>
							<xsl:apply-templates select="/root/OlapInfo/AxesInfo/PAGE" mode="PAGE_EDGE_TITLE" />
						</TR>
					</TABLE>
					</td>
				</tr>
			</table>
		</td>

		<!-- �T�[�o���M�p�G���A -->
		<td align="right" width="30" style="padding:0;display:inline">
			<iframe name="loadingStatus" width="30" frameborder="0" height="20" src="./spread/spreadLoadingStatus.html" scrolling="no" ></iframe>
		</td>
		<td style="display:none">
			<iframe name="silentAccess" src="./spread/blank.html"></iframe>
		</td>

	</tr>
</table>

</span>



<!-- Spread�\���� -->
<SPAN id='SpreadSpan' onmousedown='mouseDown();' onmouseup='mouseUp();' onmousemove='mouseMove();'>

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
			<xsl:apply-templates select="/root/OlapInfo/AxesInfo/COL" mode="CH_TITLE">
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
						<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" mode="COL">
							<xsl:with-param name="CrossHeaderorRH">CrossHeader</xsl:with-param>
						</xsl:apply-templates>
					</COLGROUP>

					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" mode="RH_TITLE">
						<xsl:with-param name="screenType" select="'spread'"/>
					</xsl:apply-templates>
				</TABLE>
			</SPAN>
		</TD>


	    <!-- ��w�b�_�\���� -->
		<TD>
			<SPAN id='ColumnHeaderArea' class='ColumnHeaderArea'>

				<TABLE class='ColumnHeaderTable' cellspacing='0' cellpadding='2' onClick='cellClicked()'>

					<!-- COLGROUP ���� -->
					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/COL">
						<xsl:with-param name="CHorDT" select="'CH'" />
					</xsl:apply-templates>

					<!-- TR,TD ���� -->
					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/COL" mode="TRTD" />
					
				</TABLE>
			</SPAN>
		</TD>
	</TR>

    <!-- �s�w�b�_�\���� -->
	<TR>
		<TD>
			<SPAN id='RowHeaderArea' class='RowHeaderArea'>

				<TABLE class='RowHeaderTable' cellspacing='0' cellpadding='2' onClick='cellClicked()'>
					<COLGROUP id='RH_CGroup'>
						<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" mode="COL">
							<xsl:with-param name="CrossHeaderorRH">RH</xsl:with-param>
						</xsl:apply-templates>
					</COLGROUP>

					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" />

				</TABLE>
			</SPAN>
		</TD>

		<TD>
			<DIV id='DataTableArea' class='DataTableArea'>

				<!-- �f�[�^�\������\���e�[�u���B
					 �f�[�^�\�����͈��TABLE�Ƃ��ĕ\����Ă���B -->
				<TABLE id='DataTable' class='DataTable' cellspacing='0' cellpadding='2' onClick='cellClicked()'>
					<!-- COLGROUP ���� -->
					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/COL">
						<xsl:with-param name="CHorDT" select="'DT'" />
					</xsl:apply-templates>

					<!-- TR,TD ���� -->
					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" mode="DT" />
				</TABLE>
			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>

<!-- �`���[�g�\���� -->
<DIV id='chartAreaDIV' class='chartAreaDIV' style='height:100%;width:100%;'>

	<!-- �S��ʕ\���i�O���t�j���̍s�E��ɔz�u���ꂽ�f�B�����V�������i�_�C�X�p�j -->
	<TABLE name="colRowDimTable" id="colRowDimTable" class="SpreadTable" style="margin-left:10px;">
		<TR>
			<TD class="title" style="padding-top:8px;font-weight:bold">�s�w�b�_�F</TD>
			<TD>
				<TABLE>
					<xsl:apply-templates select="/root/OlapInfo/AxesInfo/ROW" mode="RH_TITLE">
						<xsl:with-param name="screenType" select="'chartOnly'"/>
					</xsl:apply-templates>
				</TABLE>
			</TD>
            <TD style="width:10"></TD> <!-- �ʒu�����p -->
			<TD class="title" style="padding-top:8px;font-weight:bold">��w�b�_�F</TD>
			<TD>
				<xsl:apply-templates select="/root/OlapInfo/AxesInfo/COL" mode="CH_TITLE">
					<xsl:with-param name="screenType" select="'chartOnly'"/>
				</xsl:apply-templates>
			</TD>
		</TR>
	</TABLE>

	<!-- �`���[�g�C���[�W�\���piframe -->
	<iframe name="chart_area" class="chartArea" src="./spread/blank.html">
	</iframe>
</DIV>

	<!--
		���������� hidden�p�����[�^�� ����������
	-->

	<!-- ��̊e�i�ɔz�u���ꂽ���̒l�擾�ΏۂƂȂ郁���o��Key���X�g  -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewCol0KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">

			<xsl:for-each select="$colHie0Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewCol1KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$colHie1Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewCol2KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$colHie2Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>

	<!-- �擾�ΏۂƂȂ���SpreadIndex�Ɨ�̊e�i�̃����oKey�̑g�ݍ��킹���X�g  -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewColIndexKey_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:call-template name="makeInitialDispSpreadIndexKey">
				<xsl:with-param name="hie0" select="$colHie0Node" />
				<xsl:with-param name="hie1" select="$colHie1Node" />
				<xsl:with-param name="hie2" select="$colHie2Node" />
				<xsl:with-param name="hiesCount" select="$colHiesCount" />
				<xsl:with-param name="hie1Count" select="$colHie1Count" />
				<xsl:with-param name="hie2Count" select="$colHie2Count" />
			</xsl:call-template>
		</xsl:attribute>
	</xsl:element>

	<!-- �s�̊e�i�ɔz�u���ꂽ���̒l�擾�ΏۂƂȂ郁���o��Key���X�g  -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewRow0KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$rowHie0Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewRow1KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$rowHie1Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewRow2KeyList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$rowHie2Node//Member">
				<xsl:choose>
					<!-- �ŏ��̗v�f�͕K���\�� -->
					<xsl:when test="position() = 1">
						<xsl:value-of select="./UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>,</xsl:text>
							<xsl:value-of select="./UName" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>

	<!-- �擾�ΏۂƂȂ�s��SpreadIndex�ƍs�̊e�i�̃����oKey�̑g�ݍ��킹���X�g  -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">viewRowIndexKey_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:call-template name="makeInitialDispSpreadIndexKey">
				<xsl:with-param name="hie0" select="$rowHie0Node" />
				<xsl:with-param name="hie1" select="$rowHie1Node" />
				<xsl:with-param name="hie2" select="$rowHie2Node" />
				<xsl:with-param name="hiesCount" select="$rowHiesCount" />
				<xsl:with-param name="hie1Count" select="$rowHie1Count" />
				<xsl:with-param name="hie2Count" select="$rowHie2Count" />
			</xsl:call-template>
		</xsl:attribute>
	</xsl:element>

	<!-- ��ɔz�u���ꂽ��ID�̃��X�g -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">colEdgeIDList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$colHieObj/HierarchyID">
				<xsl:if test="position() != 1">
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:value-of select="." />
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>

	<!-- �s�ɔz�u���ꂽ��ID�̃��X�g -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">rowEdgeIDList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$rowHieObj/HierarchyID">
				<xsl:if test="position() != 1">
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:value-of select="." />
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>

	<!-- �y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[Key�̃��X�g -->
	<xsl:element name="INPUT">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">pageEdgeIDValueList_hidden</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="$pageHieObj/HierarchyID">
				<xsl:if test="position() != 1">
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:variable name="tmpPageHieID" select="." />
				<xsl:value-of select="$tmpPageHieID" />
				<xsl:text>:</xsl:text>
				<!-- �y�[�W�̎���KEY(=UName) -->
				<xsl:variable name="tmpMemberIndex" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$tmpPageHieID]/DefaultMemberKey" />
				<xsl:choose>
					<xsl:when test="$tmpMemberIndex='NA'">
						<xsl:value-of select="/root/Axes/Members[@id=$tmpPageHieID]//Member[1]/UName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$tmpMemberIndex" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:attribute>
	</xsl:element>

	<INPUT type="hidden" name="dtColorInfo" value="" />  <!-- �f�[�^�e�[�u���Z���̐F��� -->
	<INPUT type="hidden" name="hdrColorInfo" value="" /> <!-- �w�b�_�[�Z���̐F��� -->

	<INPUT type="hidden" name="colItems" value="" />	<!-- ��G�b�W�̎���ID���X�g -->
	<INPUT type="hidden" name="rowItems" value="" />	<!-- �s�G�b�W�̎���ID���X�g -->
	<INPUT type="hidden" name="pageItems" value="" />	<!-- �y�[�W�G�b�W�̎���ID���X�g -->

	<INPUT type="hidden" name="defaultMembers" value="" />	<!-- �S���̃f�t�H���g�����o���X�g -->


	<!-- ����/���W���[���̑I�����ꂽ�����o��Key�E�h������� -->
	<INPUT type="hidden" name="dim1" value="" />
	<INPUT type="hidden" name="dim2" value="" />
	<INPUT type="hidden" name="dim3" value="" />
	<INPUT type="hidden" name="dim4" value="" />
	<INPUT type="hidden" name="dim5" value="" />
	<INPUT type="hidden" name="dim6" value="" />
	<INPUT type="hidden" name="dim7" value="" />
	<INPUT type="hidden" name="dim8" value="" />
	<INPUT type="hidden" name="dim9" value="" />
	<INPUT type="hidden" name="dim10" value="" />
	<INPUT type="hidden" name="dim11" value="" />
	<INPUT type="hidden" name="dim12" value="" />
	<INPUT type="hidden" name="dim13" value="" />
	<INPUT type="hidden" name="dim14" value="" />
	<INPUT type="hidden" name="dim15" value="" />
	<INPUT type="hidden" name="dim16" value="" />


	<!-- �s�w�b�_�A��w�b�_�A�f�[�^�e�[�u�����̐F���(X,Y���W+�F) -->
	<INPUT type="hidden" name="colHdrColor" value="" />
	<INPUT type="hidden" name="rowHdrColor" value="" />
	<INPUT type="hidden" name="dataHdrColor" value="" />

	<!-- �h�����X���[�pXML -->
	<INPUT type="hidden" name="argXmlHidden" value="" />


</FORM>

<!-- �����i�[���i�e�[�u�����t���b�V�����ɐ����j -->
<DIV id="metaDataArea" style="DISPLAY:none">
	<!-- �s�w�b�_�A��w�b�_�ɃZ�b�g���ꂽ���� -->
	<DIV id="colHiesCount"><xsl:value-of select="$colHiesCount" /></DIV>
	<DIV id="rowHiesCount"><xsl:value-of select="$rowHiesCount" /></DIV>

	<!-- �s�w�b�_�A��w�b�_�̊e�i�̎��̃����o�� -->
	<DIV id="colHie0Count"><xsl:value-of select="$colHie0Count" /></DIV>
	<DIV id="colHie1Count"><xsl:value-of select="$colHie1Count" /></DIV>
	<DIV id="colHie2Count"><xsl:value-of select="$colHie2Count" /></DIV>
	<DIV id="rowHie0Count"><xsl:value-of select="$rowHie0Count" /></DIV>
	<DIV id="rowHie1Count"><xsl:value-of select="$rowHie1Count" /></DIV>
	<DIV id="rowHie2Count"><xsl:value-of select="$rowHie2Count" /></DIV>
</DIV>


<!-- �S�����A���W���[�̃����o�� -->
<DIV id="dimNumbers" style="display:none">
	<xsl:for-each select="/root/Axes/Members">
		<xsl:element name="DIV">
			<xsl:attribute name="id">
				<xsl:value-of select="@id" />
			</xsl:attribute>
			<xsl:value-of select="count(.//Member)" />
		</xsl:element>
	</xsl:for-each>
</DIV>

<!-- ���̃h���b�O�ɂ��ړ�����I�u�W�F�N�g -->
<DIV id="dragNode" class="dragNode">
	<DIV id="dragAxisIMG" class="dragAxisIMG"></DIV>
	<DIV id="dimName" class="dragAxisCenter">shortName</DIV>
	<DIV class="dragAxisRight"></DIV>
</DIV>

</BODY>

</xsl:template>



<!-- ==========================================================================
     
	     �֐��Q

 ========================================================================== -->


<!-- ==========================================================================
	 �����\���ŕ\������s�E��v�f��Index�EKey���X�g����
 ========================================================================== -->
<xsl:template name="makeInitialDispSpreadIndexKey">
	<xsl:param name="hie0" />
	<xsl:param name="hie1" />
	<xsl:param name="hie2" />
	<xsl:param name="hiesCount" />
	<xsl:param name="hie1Count" />
	<xsl:param name="hie2Count" />

	<xsl:for-each select="$hie0//Member">
		<xsl:variable name="hie0Node" select="." />
		<xsl:variable name="hie0XMLIndex" select="position() - 1" />

		<xsl:if test="$hiesCount = 1">
			<xsl:variable name="spreadIndex" select="$hie0XMLIndex" />
			<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
				<xsl:call-template name="writeInitialDispSpreadIndexKey">
					<xsl:with-param name="spreadIndex" select="$spreadIndex" />
					<xsl:with-param name="hie0Node" select="$hie0Node" />
					<xsl:with-param name="hie1Node" select="-1" />
					<xsl:with-param name="hie2Node" select="-1" />
					<xsl:with-param name="hiesCount" select="$hiesCount" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$hiesCount &gt; 1">
			<xsl:for-each select="$hie1//Member">
				<xsl:variable name="hie1Node" select="." />
				<xsl:variable name="hie1XMLIndex" select="position() - 1" />

				<xsl:if test="$hiesCount = 2">
					<xsl:variable name="spreadIndex" select="($hie0XMLIndex * $hie1Count) + $hie1XMLIndex" />
					<xsl:if test="not(./ancestor::Member[isDrilled='false']) and not($hie0Node/ancestor::Member[isDrilled='false'])">
						<xsl:call-template name="writeInitialDispSpreadIndexKey">
							<xsl:with-param name="spreadIndex" select="$spreadIndex" />
							<xsl:with-param name="hie0Node" select="$hie0Node" />
							<xsl:with-param name="hie1Node" select="$hie1Node" />
							<xsl:with-param name="hie2Node" select="-1" />
							<xsl:with-param name="hiesCount" select="$hiesCount" />
						</xsl:call-template>
					</xsl:if>
				</xsl:if>

				<xsl:if test="$hiesCount = 3">
					<xsl:for-each select="$hie2//Member">
						<xsl:variable name="hie2Node" select="." />
						<xsl:variable name="hie2XMLIndex" select="position() - 1" />

						<xsl:variable name="spreadIndex" select="($hie0XMLIndex * $hie1Count * $hie2Count) + ($hie1XMLIndex * $hie2Count) + $hie2XMLIndex" />
						<xsl:if test="not(./ancestor::Member[isDrilled='false']) and not($hie0Node/ancestor::Member[isDrilled='false']) and not($hie1Node/ancestor::Member[isDrilled='false'])">
							<xsl:call-template name="writeInitialDispSpreadIndexKey">
								<xsl:with-param name="spreadIndex" select="$spreadIndex" />
								<xsl:with-param name="hie0Node" select="$hie0Node" />
								<xsl:with-param name="hie1Node" select="$hie1Node" />
								<xsl:with-param name="hie2Node" select="$hie2Node" />
								<xsl:with-param name="hiesCount" select="$hiesCount" />
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="writeInitialDispSpreadIndexKey">
	<xsl:param name="spreadIndex" />
	<xsl:param name="hie0Node" />
	<xsl:param name="hie1Node" />
	<xsl:param name="hie2Node" />
	<xsl:param name="hiesCount" />

	<xsl:if test="$spreadIndex != 0">
		<xsl:text>,</xsl:text>
	</xsl:if>
	<xsl:value-of select="$spreadIndex" />
	<xsl:text>:</xsl:text>
	<xsl:value-of select="$hie0Node/UName" />
	<xsl:text>;</xsl:text>
	<xsl:if test="$hiesCount &gt; 1">
		<xsl:value-of select="$hie1Node/UName" />
	</xsl:if>
	<xsl:text>;</xsl:text>
	<xsl:if test="$hiesCount = 3">
		<xsl:value-of select="$hie2Node/UName" />
	</xsl:if>
</xsl:template>


<!-- ==========================================================================
	 �s�w�b�_�e�[�u����COL�v�f����
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/ROW" mode="COL">
	<xsl:param name="CrossHeaderorRH" />

	<xsl:for-each select="./HierarchyID">
		<xsl:element name="COL">
			<xsl:attribute name="id"><xsl:value-of select="$CrossHeaderorRH" />_CG<xsl:value-of select="position() - 1" /></xsl:attribute>
		
		</xsl:element>
	</xsl:for-each>
</xsl:template>

<!-- ==========================================================================
	 �y�[�W�G�b�W��Table����
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/PAGE" mode="PAGE_EDGE_TITLE">
	<xsl:for-each select="./HierarchyID">
		<xsl:variable name="pageDimID" select="." />
		<xsl:variable name="pageDimNode" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$pageDimID]" />
		<xsl:element name="TD">
			<xsl:attribute name="title"><xsl:value-of select="$pageDimNode/@name" /></xsl:attribute>
			<xsl:attribute name="dimId"><xsl:value-of select="$pageDimID" /></xsl:attribute>
			<xsl:attribute name="dragtype">2</xsl:attribute>
			<xsl:attribute name="onmouseout">axisTitleOut(this)</xsl:attribute>
			<xsl:attribute name="onmouseup">axisTitleUp(this)</xsl:attribute>
			<xsl:attribute name="axisTitle">1</xsl:attribute>
			<xsl:attribute name="style">padding:0;</xsl:attribute>

			<xsl:element name="DIV">
				<xsl:attribute name="style">visibility:hidden;</xsl:attribute>
				<xsl:element name="DIV">
					<xsl:attribute name="style">visibility:hidden;</xsl:attribute>
					<xsl:text>�i�y�[�W�G�b�W�G���A�j</xsl:text>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:for-each>

	<xsl:if test="not(./HierarchyID)">
		<xsl:element name="TD">
			<xsl:attribute name="id">insertArea</xsl:attribute>
			<xsl:attribute name="dimId" />
			<xsl:attribute name="style">padding:0px 3px;bordernone</xsl:attribute>
			<xsl:attribute name="dragtype">2</xsl:attribute>
			<xsl:attribute name="onmouseout">axisTitleOut(this)</xsl:attribute>
			<xsl:attribute name="onmouseup">axisTitleUp(this)</xsl:attribute>
			<xsl:attribute name="axisTitle">1</xsl:attribute>

			<xsl:element name="DIV">
				<xsl:attribute name="style">display:inline;</xsl:attribute>
				<xsl:element name="NOBR">
					<xsl:element name="DIV">
						<xsl:attribute name="class">pageAxisIMG</xsl:attribute>
						<xsl:attribute name="style">background-image:url(./images/insert.gif);</xsl:attribute>
					</xsl:element>
					<xsl:element name="DIV">
						<xsl:attribute name="style">display:inline;</xsl:attribute>
						<xsl:text>�i�f�B�����V����/���W���[�}���G���A�j</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- ==========================================================================
	 ��w�b�_�^�C�g������
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/COL" mode="CH_TITLE">
	<xsl:param name="screenType" />
	<xsl:element name="TABLE">
		<xsl:if test="$screenType='spread'">
			<xsl:attribute name="class">CH_TITLE_TABLE</xsl:attribute>
		</xsl:if>
		<xsl:if test="$screenType='chartOnly'">
			<xsl:attribute name="style"></xsl:attribute>
		</xsl:if>

		<xsl:element name="TR">
			<xsl:for-each select="./HierarchyID">

				<xsl:variable name="colDimID" select="." />
				<xsl:variable name="colDimNode" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$colDimID]" />

				<xsl:element name="TD">
					<xsl:if test="$screenType='spread'">
						<xsl:attribute name="class">colHieNames</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="dragtype">0</xsl:attribute>
					<xsl:attribute name="onmouseout">axisTitleOut(this)</xsl:attribute>
					<xsl:attribute name="onmouseup">axisTitleUp(this)</xsl:attribute>
					<xsl:attribute name="axisTitle">1</xsl:attribute>

					<xsl:element name="DIV">
						<xsl:attribute name="style">display:inline</xsl:attribute>

						<xsl:element name="NOBR">
							<xsl:element name="DIV">
								<xsl:attribute name="id">axisLeft</xsl:attribute>
								<xsl:attribute name="class">colAxisIMG</xsl:attribute>
								<xsl:choose> <!-- ���W���[�̏ꍇ�́A�C���[�W��ύX -->
									<xsl:when test=". = 16">
										<xsl:attribute name="style">cursor:hand;background:url('./images/measureLeft.gif') no-repeat;</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="style">cursor:hand;</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:attribute name="onmousedown">axisTitleDown(this);openSelector(<xsl:value-of select="$colDimID" />,2);</xsl:attribute>
							</xsl:element>
							<xsl:element name="DIV">
								<xsl:attribute name="id">axisCenter</xsl:attribute>
								<xsl:attribute name="class">axisCenter</xsl:attribute>
								<xsl:value-of select="$colDimNode/@name" />
							</xsl:element>
							<xsl:element name="DIV">
								<xsl:attribute name="id">axisRight</xsl:attribute>
								<xsl:attribute name="class">axisRight</xsl:attribute>
							</xsl:element>
						</xsl:element>

					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>

<!-- ==========================================================================
	 �s�w�b�_�^�C�g������
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/ROW" mode="RH_TITLE">
	<xsl:param name="screenType" />
	<xsl:choose>
		<xsl:when test="$colHiesCount = 1">
			<xsl:call-template name="makeRowTitleTRObj">
				<xsl:with-param name="rowID" select="0" />
				<xsl:with-param name="screenType" select="$screenType" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$colHiesCount = 2">
			<xsl:if test="$screenType='spread'">
				<xsl:element name="TR">
					<xsl:attribute name="id">CrossHeader_R0</xsl:attribute>
					<xsl:element name="TD">
						<xsl:attribute name="id">CrossHeader_R0C0</xsl:attribute>
						<xsl:attribute name="class">CrsHdr</xsl:attribute>
						<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
						<xsl:text>�@</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:call-template name="makeRowTitleTRObj">
				<xsl:with-param name="rowID" select="1" />
				<xsl:with-param name="screenType" select="$screenType" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$colHiesCount = 3">
			<xsl:if test="$screenType='spread'">
				<xsl:element name="TR">
					<xsl:attribute name="id">CrossHeader_R0</xsl:attribute>
					<xsl:element name="TD">
						<xsl:attribute name="id">CrossHeader_R0C0</xsl:attribute>
						<xsl:attribute name="class">CrsHdr</xsl:attribute>
						<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
						<xsl:text>�@</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:element name="TR">
					<xsl:attribute name="id">CrossHeader_R1</xsl:attribute>
					<xsl:element name="TD">
						<xsl:attribute name="id">CrossHeader_R1C0</xsl:attribute>
						<xsl:attribute name="class">CrsHdr</xsl:attribute>
						<xsl:attribute name="colSpan"><xsl:value-of select="$rowHiesCount" /></xsl:attribute>
						<xsl:text>�@</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:call-template name="makeRowTitleTRObj">
				<xsl:with-param name="rowID" select="2" />
				<xsl:with-param name="screenType" select="$screenType" />
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="makeRowTitleTRObj">
	<xsl:param name="rowID" />
	<xsl:param name="screenType" />

	<xsl:element name="TR">
		<xsl:if test="$screenType='spread'">
			<xsl:attribute name="id">CrossHeader_R<xsl:value-of select="$rowID" /></xsl:attribute>
		</xsl:if>

		<xsl:for-each select="./HierarchyID">

			<xsl:variable name="rowDimID" select="." />
			<xsl:variable name="rowDimNode" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$rowDimID]" />

			<xsl:element name="TD">
				<xsl:attribute name="class">rowHieNames</xsl:attribute>
				<xsl:if test="$screenType='spread'">
					<xsl:attribute name="id">CrossHeader_R<xsl:value-of select="$rowID" />C<xsl:value-of select="position() - 1" /></xsl:attribute>
					<xsl:attribute name="class">CrsHdr</xsl:attribute>
				</xsl:if>

				<xsl:attribute name="style">border:none;</xsl:attribute>
				<xsl:attribute name="dragtype">1</xsl:attribute>
				<xsl:attribute name="onmouseout">axisTitleOut(this)</xsl:attribute>
				<xsl:attribute name="onmouseup">axisTitleUp(this)</xsl:attribute>
				<xsl:attribute name="axisTitle">1</xsl:attribute>

				<xsl:element name="DIV">
					<xsl:attribute name="style">display:inline;width:100%</xsl:attribute>

					<xsl:element name="NOBR">
						<xsl:element name="DIV">
							<xsl:attribute name="id">axisLeft</xsl:attribute>
							<xsl:attribute name="class">rowAxisIMG</xsl:attribute>
							<xsl:choose> <!-- ���W���[�̏ꍇ�́A�C���[�W��ύX -->
								<xsl:when test=". = 16">
									<xsl:attribute name="style">cursor:hand;background:url('./images/measureLeft.gif') no-repeat;</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="style">cursor:hand;</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="onmousedown">axisTitleDown(this);openSelector(<xsl:value-of select="$rowDimID" />,2);</xsl:attribute>
						</xsl:element>
						<xsl:element name="DIV">
							<xsl:attribute name="id">axisCenter</xsl:attribute>
							<xsl:attribute name="class">axisCenter</xsl:attribute>
							<xsl:if test="not($screenType='chartOnly')"> <!-- Spread�\�����́A�N���X�w�b�_�̕��ύX�p�ɕK�v -->
								<xsl:attribute name="style">width:100%;font-weight:normal;color:black</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="$rowDimNode/@name" />
						</xsl:element>
						<xsl:element name="DIV">
							<xsl:attribute name="id">axisRight</xsl:attribute>
							<xsl:attribute name="class">axisRight</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

<!-- ==========================================================================
	 ��w�b�_�e�[�u����������,�f�[�^�\���e�[�u����COL�v�f����
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/COL">
	<xsl:param name="CHorDT" />

	<xsl:element name="COLGROUP">
		<xsl:if test="$CHorDT='CH'">
			<xsl:attribute name="id">CH_CG</xsl:attribute>
		</xsl:if>
		<xsl:for-each select="$colHie0Node//Member">
			<xsl:variable name="hie0XMLNode" select="." />
			<xsl:variable name="hie0XMLIndex" select="position() - 1" />

			<xsl:if test="$colHiesCount = 1">
				<!-- ���������o�̕\��/��\����ϐ��ɐݒ� -->
				<xsl:variable name="displayString">
					<xsl:choose>
						<xsl:when test="not(./ancestor::Member[isDrilled='false'])">
							<xsl:text>width:100;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>width:0;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="makeColHeaderCOL">
					<xsl:with-param name="CHorDT" select="$CHorDT" />
					<xsl:with-param name="colIndex" select="$hie0XMLIndex" />
					<xsl:with-param name="displayString" select="$displayString" />
				</xsl:call-template>

			</xsl:if>

			<xsl:if test="$colHiesCount &gt; 1">

				<xsl:if test="$colHiesCount = 2">
					<xsl:for-each select="$colHie1Node//Member">
						<xsl:variable name="hie1XMLIndex" select="position() -1" />
						<xsl:variable name="colIndex" select="$hie0XMLIndex * $colHie1Count + $hie1XMLIndex" />

						<!-- ���������o�̕\��/��\����ϐ��ɐݒ� -->
						<xsl:variable name="displayString">
							<xsl:choose>
								<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($hie0XMLNode/ancestor::Member[isDrilled='false'])">
									<xsl:text>width:100;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>width:0;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:call-template name="makeColHeaderCOL">
							<xsl:with-param name="CHorDT" select="$CHorDT" />
							<xsl:with-param name="colIndex" select="$colIndex" />
							<xsl:with-param name="displayString" select="$displayString" />
						</xsl:call-template>

					</xsl:for-each>
				</xsl:if>

				<xsl:if test="$colHiesCount = 3">
					<xsl:for-each select="$colHie1Node//Member">
						<xsl:variable name="hie1XMLNode" select="." />
						<xsl:variable name="hie1XMLIndex" select="$hie0XMLIndex * $underColIndex1ComboNum + ( (position() -1) * $underColIndex2ComboNum )" />

						<xsl:for-each select="$colHie2Node//Member">
							<xsl:variable name="member3Index" select="$hie1XMLIndex + position() -1" />

							<!-- ���������o�̕\��/��\����ϐ��ɐݒ� -->
							<xsl:variable name="displayString">
								<xsl:choose>
									<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($hie0XMLNode/ancestor::Member[isDrilled='false']) and not($hie1XMLNode/ancestor::Member[isDrilled='false'])">
										<xsl:text>width:100;</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>width:0;</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:call-template name="makeColHeaderCOL">
								<xsl:with-param name="CHorDT" select="$CHorDT" />
								<xsl:with-param name="colIndex" select="$member3Index" />
								<xsl:with-param name="displayString" select="$displayString" />
							</xsl:call-template>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>

		<!-- ��w�b�_�̃_�~�[�Z������COL�v�f���� -->
		<xsl:if test="$CHorDT='CH'">
			<xsl:element name="COL">
				<xsl:attribute name="width">80</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template name="makeColHeaderCOL">
	<xsl:param name="CHorDT" />
	<xsl:param name="colIndex" />
	<xsl:param name="displayString" />

	<xsl:element name="COL">
		<xsl:attribute name="id"><xsl:value-of select="$CHorDT" />_CG<xsl:value-of select="$colIndex" /></xsl:attribute>
		<xsl:attribute name="style"><xsl:value-of select="$displayString" /></xsl:attribute>
		<xsl:if test="$CHorDT='CH'">
			<xsl:attribute name="preWidth">0</xsl:attribute>
		</xsl:if>
	</xsl:element>
</xsl:template>


<!-- ==========================================================================
	 ��w�b�_�e�[�u����TRTD�v�f�𐶐�
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/COL" mode="TRTD">

	<!-- ��i�ڂ�\�� -->
	<xsl:call-template name="makeColHeaderTRTD">
		<xsl:with-param name="rowID" select="0"/>
		<xsl:with-param name="underColIndexComboNum" select="$underColIndex1ComboNum" />
	</xsl:call-template>

	<xsl:if test="$colHiesCount &gt;1">
		<!-- ��i�ڂ�\�� -->
		<xsl:call-template name="makeColHeaderTRTD">
			<xsl:with-param name="rowID" select="1"/>
			<xsl:with-param name="underColIndexComboNum" select="$underColIndex2ComboNum" />
		</xsl:call-template>

		<xsl:if test="$colHiesCount=3">
			<!-- �O�i�ڂ�\�� -->
			<xsl:call-template name="makeColHeaderTRTD">
				<xsl:with-param name="rowID" select="2"/>
				<xsl:with-param name="underColIndexComboNum" select="$underColIndex3ComboNum" />
			</xsl:call-template>

		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template name="makeColHeaderTRTD">
	<xsl:param name="rowID" />
	<xsl:param name="underColIndexComboNum" />

	<xsl:element name="TR">
		<xsl:attribute name="ID">CH_R<xsl:value-of select="$rowID" /></xsl:attribute>
		<xsl:attribute name="Spread">ColumnHeaderRow</xsl:attribute>

		<xsl:choose>
			<!-- ��i�ڕ\���� -->
			<xsl:when test="$rowID=0">
				<xsl:call-template name="makeColHeaderTD">
					<xsl:with-param name="rowID" select="$rowID" />
					<xsl:with-param name="underColIndexComboNum" select="$underColIndexComboNum" />
					<xsl:with-param name="overHierarchyIndex" select="0" />
				</xsl:call-template>
			</xsl:when>

			<!-- ��i�ڕ\���� -->
			<xsl:when test="$rowID=1">
				<xsl:for-each select="$colHie0Node//Member">
					<xsl:variable name="hie0SpreadIndex" select="(position() - 1) * $underColIndex1ComboNum" />
					<xsl:call-template name="makeColHeaderTD">
						<xsl:with-param name="rowID" select="$rowID" />
						<xsl:with-param name="underColIndexComboNum" select="$underColIndexComboNum" />
						<xsl:with-param name="overHierarchyIndex" select="$hie0SpreadIndex" />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>

			<!-- �O�i�ڕ\���� -->
			<xsl:when test="$rowID=2">
				<xsl:for-each select="$colHie0Node//Member">
					<xsl:variable name="hie0SpreadIndex" select="(position() - 1) * $underColIndex1ComboNum"/>

					<xsl:for-each select="$colHie1Node//Member">
						<xsl:variable name="hie1SpreadIndex" select="$hie0SpreadIndex + ( (position() - 1) * $underColIndex2ComboNum )"/>
						<xsl:call-template name="makeColHeaderTD">
							<xsl:with-param name="rowID" select="$rowID" />
							<xsl:with-param name="underColIndexComboNum" select="1" />
							<xsl:with-param name="overHierarchyIndex" select="$hie1SpreadIndex" />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>

		<!-- �X�N���[���ʒu�����p�̃_�~�[�Z������ -->
		<xsl:element name="TD">
			<xsl:attribute name="id">adjustCell</xsl:attribute>
			<xsl:attribute name="class">adjustCell</xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template name="makeColHeaderTD">
	<xsl:param name="rowID" />
	<xsl:param name="underColIndexComboNum" />
	<xsl:param name="overHierarchyIndex" />

	<xsl:variable name="tmpColID"   select="/root/OlapInfo/AxesInfo/COL/HierarchyID[$rowID+1]" />
	<xsl:variable name="tmpColNode" select="/root/Axes/Members[@id=$tmpColID]" />
	<xsl:variable name="dispNameType" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$tmpColID]/DisplayMemberType" />
	<xsl:for-each select="$tmpColNode//Member">

		<!-- �Z�����h��������Ďq����\�����Ă��邩�ǂ�����ݒ� -->
		<xsl:variable name="internalDisplayString">
			<xsl:choose>
				<xsl:when test="'true'=./isDrilled">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="TD">
			<xsl:attribute name="id">CH_R<xsl:value-of select="$rowID" />C<xsl:value-of select="$overHierarchyIndex + ( (position() - 1) * $underColIndexComboNum )" /></xsl:attribute>
			<xsl:attribute name="colspan"><xsl:value-of select="$underColIndexComboNum" /></xsl:attribute>
			<xsl:attribute name="key"><xsl:value-of select="UName" /></xsl:attribute>
			<xsl:attribute name="level"><xsl:value-of select="LNum" /></xsl:attribute>
			<xsl:attribute name="internalDisp"><xsl:value-of select="$internalDisplayString" /></xsl:attribute>

			<!--draw color according to a level-->
			<xsl:attribute name="class">headerColorLV<xsl:value-of select="LNum"/></xsl:attribute>

			<xsl:element name="NOBR">
				<xsl:element name="IMG">
					<xsl:choose>
						<xsl:when test="'true'=./isLeaf">
							<xsl:attribute name="src">./images/none.gif</xsl:attribute>
						</xsl:when>
						<xsl:when test="'false'=./isLeaf">
							<xsl:choose>
								<xsl:when test="not(descendant::Member)">
									<xsl:attribute name="src">./images/none.gif</xsl:attribute>
								</xsl:when>
								<xsl:when test="'false'=./isDrilled">
									<xsl:attribute name="style">cursor:hand</xsl:attribute>
									<xsl:attribute name="src">./images/plus.gif</xsl:attribute>
								</xsl:when>
								<xsl:when test="'true'=./isDrilled">
									<xsl:attribute name="style">cursor:hand</xsl:attribute>
									<xsl:attribute name="src">./images/minus.gif</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="'false'=./isLeaf">
						<xsl:if test="descendant::Member">
							<xsl:attribute name="onClick">drill(this)</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:element>
				<xsl:text /><xsl:value-of select="*[name()=$dispNameType]" /><xsl:text />
			</xsl:element>

		</xsl:element>
	</xsl:for-each>
</xsl:template>

<!-- ==========================================================================
	 �s�w�b�_�e�[�u����TR,TD�v�f�𐶐�
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/ROW">

	<xsl:for-each select="$rowHie0Node//Member">

		<!-- �ϐ��̐���:
				hie0Node�F�s�w�b�_0���(1�i��)�̎��̃����o
				hie0XMLIndex�F�s�w�b�_0���(1�i��)�̎��̃����o��Index
							  �i�O����X�^�[�g�ŁA�P�Â����j-->
		<xsl:variable name="hie0Node" select="." />
		<xsl:variable name="hie0XMLIndex" select="position() - 1" />

		<xsl:variable name="hie0internalDisplayString">
			<xsl:choose>
				<xsl:when test="'true'=./isDrilled">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$rowHiesCount = 1">
			<!-- �ϐ��̐���
				displayString:�s�w�b�_�������\�����邩�ǂ�����\����������i�[
				internalDisplayString: �s�w�b�_�ŏI�i�̎��̃h�����ɂ��A
									   �\��/��\����������ێ�����B -->
			<xsl:variable name="displayString">
				<xsl:choose>
					<xsl:when test="not(./ancestor::Member[isDrilled='false'])">
						<xsl:text>DISPLAY:''</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>DISPLAY:none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="makeRowHeaderTRTD">
				<xsl:with-param name="hie0Node" select="." />
				<xsl:with-param name="hie1Node" select="-1" />
				<xsl:with-param name="hie2Node" select="-1" />
				<xsl:with-param name="hie0XMLIndex" select="$hie0XMLIndex" />
				<xsl:with-param name="hie1XMLIndex" select="-1" />
				<xsl:with-param name="hie2XMLIndex" select="-1" />
				<xsl:with-param name="rowIndex" select="$hie0XMLIndex" />
				<xsl:with-param name="hie0RowSpanNum" select="1" />
				<xsl:with-param name="hie1RowSpanNum" select="1" />
				<xsl:with-param name="hie2RowSpanNum" select="1" />
				<xsl:with-param name="displayString" select="$displayString"/>
				<xsl:with-param name="hie0internalDisplayString" select="$hie0internalDisplayString"/>
				<xsl:with-param name="hie1internalDisplayString" select="-1"/>
				<xsl:with-param name="hie2internalDisplayString" select="-1"/>
			</xsl:call-template>

		</xsl:if>

		<xsl:if test="$rowHiesCount &gt; 1">
			<!-- �ϐ��̐���:
				hie1LastDispXMLIndex:�s�w�b�_1���(2�i��)�̎��ŁA
									 �����\���ŕ\������(TD��stle��display��''�j
									 ��Ԍ��̃����o -->

			<xsl:variable name="hie1LastDispXMLIndex">
				<xsl:call-template name="getLastDispXMLIndex" >
					<xsl:with-param name="hieIndex" select="1" />
					<xsl:with-param name="hieCount" select="$rowHie1Count" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:for-each select="$rowHie1Node//Member">
				<!-- �ϐ��̐���:
					hie1Node�F�s�w�b�_1���(2�i��)�̎��̃����o
					hie1XMLIndex�F�s�w�b�_1�s��(2�i��)�̎��̃����o��Index
								  �i�O����X�^�[�g�ŁA�P�Â����j-->
				<xsl:variable name="hie1Node" select="." />
				<xsl:variable name="hie1XMLIndex" select="position() - 1" />

				<xsl:variable name="hie1internalDisplayString">
					<xsl:choose>
						<xsl:when test="'true'=./isDrilled">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>false</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:if test="$rowHiesCount = 2">
					<!-- �ϐ��̐���
						rowIndex�F�s�w�b�_�̍sIndex�B
								  �i�O����X�^�[�g�ŁA�P�Â������A
								    �s�w�b�_�̊e�i�̑S�����o�̑g�ݍ��킹��-1�܂ŁB)
						displayString:�s�w�b�_�������\�����邩�ǂ�����\����������i�[
						internalDisplayString: �s�w�b�_�ŏI�i�̎��̃h�����ɂ��A
											   �\��/��\����������ێ�����B -->
					<xsl:variable name="rowIndex" select="($hie0XMLIndex * $rowHie1Count) + $hie1XMLIndex" />

					<xsl:variable name="displayString">
						<xsl:choose>
							<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($hie0Node/ancestor::Member[isDrilled='false'])">
								<xsl:text>DISPLAY:''</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>DISPLAY:none</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:call-template name="makeRowHeaderTRTD">
						<xsl:with-param name="hie0Node" select="$hie0Node" />
						<xsl:with-param name="hie1Node" select="." />
						<xsl:with-param name="hie2Node" select="-1" />
						<xsl:with-param name="hie0XMLIndex" select="$hie0XMLIndex" />
						<xsl:with-param name="hie1XMLIndex" select="$hie1XMLIndex" />
						<xsl:with-param name="hie2XMLIndex" select="-1" />
						<xsl:with-param name="rowIndex" select="$rowIndex" />
						<xsl:with-param name="hie0RowSpanNum" select="$hie1LastDispXMLIndex + 1" />
						<xsl:with-param name="hie1RowSpanNum" select="1" />
						<xsl:with-param name="hie2RowSpanNum" select="1" />
						<xsl:with-param name="displayString" select="$displayString"/>
						<xsl:with-param name="hie0internalDisplayString" select="$hie0internalDisplayString"/>
						<xsl:with-param name="hie1internalDisplayString" select="$hie1internalDisplayString"/>
						<xsl:with-param name="hie2internalDisplayString" select="-1"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$rowHiesCount = 3">
					<xsl:for-each select="$rowHie2Node//Member">
						<!-- �ϐ��̐���:
							hie2Node�F�s�w�b�_2���(3�i��)�̎��̃����o
							hie2XMLIndex�F�s�w�b�_2�s��(3�i��)�̎��̃����o��Index
										  �i�O����X�^�[�g�ŁA�P�Â����j-->
						<xsl:variable name="hie2Node" select="." />
						<xsl:variable name="hie2XMLIndex" select="position() - 1" />

						<!-- �ϐ��̐���
							rowIndex�F�s�w�b�_�̍sIndex�B
									  �i�O����X�^�[�g�ŁA�P�Â������A
									    �s�w�b�_�̊e�i�̑S�����o�̑g�ݍ��킹��-1�܂ŁB)
							displayString:�s�w�b�_�������\�����邩�ǂ�����\����������i�[
							internalDisplayString: �s�w�b�_�ŏI�i�̎��̃h�����ɂ��A
												   �\��/��\����������ێ�����B -->
						<xsl:variable name="rowIndex" select="($hie0XMLIndex * $rowHie1Count * $rowHie2Count) + ($hie1XMLIndex * $rowHie2Count) + $hie2XMLIndex" />

						<xsl:variable name="displayString">
							<xsl:choose>
								<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($hie0Node/ancestor::Member[isDrilled='false']) and not($hie1Node/ancestor::Member[isDrilled='false'])">
									<xsl:text>DISPLAY:''</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>DISPLAY:none</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="hie2internalDisplayString">
							<xsl:choose>
								<xsl:when test="'true'=./isDrilled">
									<xsl:text>true</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>false</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<!-- �ϐ��̐���:
							hie2LastDispXMLIndex:�s�w�b�_2���(3�i��)�̎��ŁA
												 �����\���ŕ\������(TD��stle��display��''�j
												 ��Ԍ��̃����o -->

						<xsl:variable name="hie2LastDispXMLIndex">
							<xsl:call-template name="getLastDispXMLIndex" >
								<xsl:with-param name="hieIndex" select="2" />
								<xsl:with-param name="hieCount" select="$rowHie2Count" />
							</xsl:call-template>
						</xsl:variable>


						<xsl:call-template name="makeRowHeaderTRTD">
							<xsl:with-param name="hie0Node" select="$hie0Node" />
							<xsl:with-param name="hie1Node" select="$hie1Node" />
							<xsl:with-param name="hie2Node" select="." />
							<xsl:with-param name="hie0XMLIndex" select="$hie0XMLIndex" />
							<xsl:with-param name="hie1XMLIndex" select="$hie1XMLIndex" />
							<xsl:with-param name="hie2XMLIndex" select="$hie2XMLIndex" />
							<xsl:with-param name="rowIndex" select="$rowIndex" />
							<xsl:with-param name="hie0RowSpanNum" select="($hie1LastDispXMLIndex * $rowHie2Count) + $hie2LastDispXMLIndex + 1" />
							<xsl:with-param name="hie1RowSpanNum" select="$hie2LastDispXMLIndex + 1" />
							<xsl:with-param name="hie2RowSpanNum" select="1" />
							<xsl:with-param name="displayString" select="$displayString"/>
							<xsl:with-param name="hie0internalDisplayString" select="$hie0internalDisplayString"/>
							<xsl:with-param name="hie1internalDisplayString" select="$hie1internalDisplayString"/>
							<xsl:with-param name="hie2internalDisplayString" select="$hie2internalDisplayString"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>

			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>

	<xsl:element name="TR">
		<!-- �X�N���[���ʒu�����p�̃_�~�[�Z������ -->
		<xsl:for-each select="./HierarchyID">
			<xsl:element name="TD">
				<xsl:attribute name="id">adjustCell</xsl:attribute>
				<xsl:attribute name="class">adjustCell</xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>

</xsl:template>

<xsl:template name="makeRowHeaderTRTD">
	<xsl:param name="hie0Node" />
	<xsl:param name="hie1Node" />
	<xsl:param name="hie2Node" />
	<xsl:param name="hie0XMLIndex" />
	<xsl:param name="hie1XMLIndex" />
	<xsl:param name="hie2XMLIndex" />
	<xsl:param name="rowIndex" />
	<xsl:param name="hie0RowSpanNum" />
	<xsl:param name="hie1RowSpanNum" />
	<xsl:param name="hie2RowSpanNum" />
	<xsl:param name="displayString" />
	<xsl:param name="hie0internalDisplayString" />
	<xsl:param name="hie1internalDisplayString" />
	<xsl:param name="hie2internalDisplayString" />

	<xsl:element name="TR">
		<xsl:attribute name="id">RH_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
		<xsl:attribute name="Spread">RowHeaderRow</xsl:attribute>

		<xsl:attribute name="style"><xsl:value-of select="$displayString" /></xsl:attribute>

		<!-- �s�w�b�_��0�s��(1�i��)�𐶐� -->
		<xsl:if test="$rowHiesCount = 1 or ( $rowHiesCount = 2 and $hie1XMLIndex = 0 ) or ( $rowHiesCount = 3 and $hie1XMLIndex = 0 and $hie2XMLIndex = 0 )">
			<xsl:call-template name="makeRowHeaderTD">
				<xsl:with-param name="axisID" select="$rowHie0ID" />
				<xsl:with-param name="colNum" select="0" />
				<xsl:with-param name="rowSpanNumber" select="$hie0RowSpanNum" />
				<xsl:with-param name="targetElement" select="$hie0Node" />
				<xsl:with-param name="dispRowIndex" select="$rowIndex" />
				<xsl:with-param name="internalDisplayString" select="$hie0internalDisplayString" />
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="$rowHiesCount &gt; 1">
			<xsl:if test="$rowHiesCount = 2 or ( $rowHiesCount = 3 and $hie2XMLIndex = 0 )">
				<!-- �s�w�b�_��1�s��(2�i��)�𐶐� -->
				<xsl:call-template name="makeRowHeaderTD">
					<xsl:with-param name="axisID" select="$rowHie1ID" />
					<xsl:with-param name="colNum" select="1" />
					<xsl:with-param name="rowSpanNumber" select="$hie1RowSpanNum" />
					<xsl:with-param name="targetElement" select="$hie1Node" />
					<xsl:with-param name="dispRowIndex" select="$rowIndex" />
					<xsl:with-param name="internalDisplayString" select="$hie1internalDisplayString" />
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$rowHiesCount = 3">
				<!-- �s�w�b�_��2�s��(3�i��)�𐶐� -->
				<xsl:call-template name="makeRowHeaderTD">
					<xsl:with-param name="axisID" select="$rowHie2ID" />
					<xsl:with-param name="colNum" select="2" />
					<xsl:with-param name="rowSpanNumber" select="$hie2RowSpanNum" />
					<xsl:with-param name="targetElement" select="$hie2Node" />
					<xsl:with-param name="dispRowIndex" select="$rowIndex" />
					<xsl:with-param name="internalDisplayString" select="$hie2internalDisplayString" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:element>
</xsl:template>

<!-- �s�w�b�_��TD�v�f���� -->
<xsl:template name="makeRowHeaderTD">
	<xsl:param name="axisID"/>
	<xsl:param name="colNum"/>
	<xsl:param name="rowSpanNumber"/>
	<xsl:param name="targetElement"/>
	<xsl:param name="dispRowIndex"/>
	<xsl:param name="internalDisplayString"/>

	<xsl:element name="TD">
		<xsl:attribute name="id">RH_R<xsl:value-of select="$dispRowIndex" />C<xsl:value-of select="$colNum" /></xsl:attribute>
		<xsl:attribute name="rowspan"><xsl:value-of select="$rowSpanNumber" /></xsl:attribute>
		<xsl:attribute name="key"><xsl:value-of select="$targetElement/UName" /></xsl:attribute>
		<xsl:attribute name="level"><xsl:value-of select="$targetElement/LNum" /></xsl:attribute>
		<xsl:attribute name="internalDisp"><xsl:value-of select="$internalDisplayString" /></xsl:attribute>

		<!--draw color according to a level-->
		<xsl:attribute name="class">headerColorLV<xsl:value-of select="LNum"/></xsl:attribute>

		<xsl:element name="NOBR">

			<!-- ���x���ɂ��A�C���f���g��\������ -->
			<xsl:variable name="indentString">
				<xsl:call-template name="makeIndentByLevel">
					<xsl:with-param name="level" select="$targetElement/LNum" />
					<xsl:with-param name="i" select="0"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$indentString" />
			<xsl:variable name="dispNameType" select="/root/OlapInfo/AxesInfo/HierarchyInfo[@id=$axisID]/DisplayMemberType" />
			<!-- �C���[�W��\������ -->
			<xsl:element name="IMG">
				<xsl:choose>
					<xsl:when test="'true'=$targetElement/isLeaf">
						<xsl:attribute name="src">./images/none.gif</xsl:attribute>
					</xsl:when>
					<xsl:when test="'false'=$targetElement/isLeaf">
						<xsl:choose>
							<xsl:when test="not($targetElement/descendant::Member)">
								<xsl:attribute name="src">./images/none.gif</xsl:attribute>
							</xsl:when>
							<xsl:when test="'false'=$targetElement/isDrilled">
								<xsl:attribute name="style">cursor:hand</xsl:attribute>
								<xsl:attribute name="src">./images/plus.gif</xsl:attribute>
							</xsl:when>
							<xsl:when test="'true'=$targetElement/isDrilled">
								<xsl:attribute name="style">cursor:hand</xsl:attribute>
								<xsl:attribute name="src">./images/minus.gif</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="'false'=$targetElement/isLeaf">
					<xsl:if test="$targetElement/descendant::Member">
						<xsl:attribute name="onClick">drill(this)</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:element>
			<xsl:text /><xsl:value-of select="$targetElement/*[name()=$dispNameType]" /><xsl:text />
		</xsl:element>
	</xsl:element>
</xsl:template>


<!-- �^����ꂽ�s�����̎��̃����o�ōŌ��DISPLAY�ł��郁���o�̃C���f�b�N�X�����߂�  -->
<xsl:template name="getLastDispXMLIndex" >
	<!-- Input)
			hieIndex:�����ΏۂƂ���A�s�w�b�_�̎��̗�ԍ�
			hieCount:�����ΏۂƂ���A�s�w�b�_�̎��̃����o��
		 Output)
			�����ΏۂƂ���s�w�b�_�̎��̃����o�̂����A
			�����\���ōŌ�ɕ\������郁���o�̃C���f�b�N�X
	-->

	<xsl:param name="hieIndex" />
	<xsl:param name="hieCount" />

	<xsl:variable name="descDispXMLIndexList" >

		<xsl:variable name="tmpRowID"   select="/root/OlapInfo/AxesInfo/ROW/HierarchyID[$hieIndex+1]" />
		<xsl:variable name="tmpRowNode" select="/root/Axes/Members[@id=$tmpRowID]" />

		<xsl:for-each select="$tmpRowNode//Member">
			<xsl:sort select="position()" order="descending" data-type="number"></xsl:sort>
			<xsl:if test="not(./ancestor::Member[isDrilled='false'])">
				<xsl:value-of select="position()" />
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!-- ���������o���̏����C���f�b�N�X(0 start)�ɕϊ� -->
	<xsl:value-of select="$hieCount - number(substring-before($descDispXMLIndexList,',')) " />
	
</xsl:template>

<!-- ���x���ɂ��A�C���f���g�𐶐� -->
<xsl:template name="makeIndentByLevel">
	<!-- 
	Input)
		level:���x��
		i:�C���f�b�N�X�B�W������̂��߂ɂ́A0�ł��邱��
	Output)
		level - i �̑S�p�X�y�[�X
	-->

	<xsl:param name="level" />
	<xsl:param name="i"/>

		<xsl:if test="$level &gt; $i">
			<xsl:text>�@</xsl:text>
			
			<xsl:call-template name="makeIndentByLevel">
				<xsl:with-param name="level" select="$level" />
				<xsl:with-param name="i" select="$i+1" />
			</xsl:call-template>
		</xsl:if>
</xsl:template>

<!-- ==========================================================================
	 �f�[�^�\���e�[�u����TR,TD�v�f����
 ========================================================================== -->
<xsl:template match="/root/OlapInfo/AxesInfo/ROW" mode="DT">
	<xsl:for-each select="$rowHie0Node//Member">
		<!-- �ϐ��̐���:rowHie0XMLNode�F�s�w�b�_0���(1�i��)�̎��̃����o
						rowHie0XMLIndex�F�s�w�b�_0���(1�i��)�̎��̃����o��Index
									  �i�O����X�^�[�g�ŁA�P�Â����j-->
		<xsl:variable name="rowHie0XMLNode" select="." />
		<xsl:variable name="rowHie0XMLIndex" select="position() - 1" />

		<xsl:if test="$rowHiesCount = 1">
			<!-- ��w�b�_�̎��������o�̕\��/��\����ϐ��ɐݒ� -->
			<xsl:variable name="displayString">
				<xsl:choose>
					<xsl:when test="not(./ancestor::Member[isDrilled='false'])">
						<xsl:text>DISPLAY:''</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>DISPLAY:none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="makeDCTRTD">
				<xsl:with-param name="rowIndex" select="$rowHie0XMLIndex" />
				<xsl:with-param name="displayString" select="$displayString" />
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="$rowHiesCount &gt; 1">
			<xsl:for-each select="$rowHie1Node//Member">
				<!-- �ϐ��̐���:rowHie1XMLNode�F�s�w�b�_1���(2�i��)�̎��̃����o
								rowHie1XMLIndex�F�s�w�b�_1�s��(2�i��)�̎���
												 �����o��Index
												�i�O����X�^�[�g�ŁA�P�Â����j
								rowIndex�F�s�w�b�_�̍sIndex
										  �i�O����X�^�[�g�ŁA�P�Â����B�s�w�b�_�̊e�i�̑S�����o�̑g�ݍ��킹��-1�j-->
				<xsl:variable name="rowHie1XMLNode" select="." />
				<xsl:variable name="rowHie1XMLIndex" select="position() - 1" />

				<xsl:if test="$rowHiesCount = 2">
					<xsl:variable name="rowIndex" select="$rowHie0XMLIndex * $rowHie1Count + $rowHie1XMLIndex" />

					<!-- ��w�b�_�̎��������o�̕\��/��\����ϐ��ɐݒ� -->
					<xsl:variable name="displayString">
						<xsl:choose>
							<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($rowHie0XMLNode/ancestor::Member[isDrilled='false'])">
								<xsl:text>DISPLAY:''</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>DISPLAY:none</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:call-template name="makeDCTRTD">
						<xsl:with-param name="rowIndex" select="$rowIndex" />
						<xsl:with-param name="displayString" select="$displayString" />
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$rowHiesCount = 3">
					<xsl:for-each select="$rowHie2Node//Member">
						<!-- �ϐ��̐���:
							rowHie2XMLIndex�F�s�w�b�_2�s��(3�i��)�̎��̃����o��Index
										  �i�O����X�^�[�g�ŁA�P�Â����j-->
						<xsl:variable name="rowHie2XMLIndex" select="position() - 1" />

						<!-- �ϐ��̐���
							rowIndex�F�s�w�b�_�̍sIndex�B
									  �i�O����X�^�[�g�ŁA�P�Â������A
									    �s�w�b�_�̊e�i�̑S�����o�̑g�ݍ��킹��-1�܂ŁB)
							displayString:�s�w�b�_�������\�����邩�ǂ�����\����������i�[
						-->
						<xsl:variable name="rowIndex" select="($rowHie0XMLIndex * $rowHie1Count * $rowHie2Count) + ($rowHie1XMLIndex * $rowHie2Count) + $rowHie2XMLIndex" />

						<xsl:variable name="displayString">
							<xsl:choose>
								<xsl:when test="not(./ancestor::Member[isDrilled='false']) and not($rowHie0XMLNode/ancestor::Member[isDrilled='false']) and not($rowHie1XMLNode/ancestor::Member[isDrilled='false'])">
									<xsl:text>DISPLAY:''</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>DISPLAY:none</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:call-template name="makeDCTRTD">
							<xsl:with-param name="rowIndex" select="$rowIndex" />
							<xsl:with-param name="displayString" select="$displayString" />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<xsl:template name="makeDCTRTD">

	<xsl:param name="rowIndex" />
	<xsl:param name="displayString" />

	<xsl:element name="TR">
		<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" /></xsl:attribute>
		<xsl:attribute name="style"><xsl:value-of select="$displayString" /></xsl:attribute>

		<xsl:choose>
			<!-- �s���P�i�̂Ƃ� -->
			<xsl:when test="$colHiesCount=1">
				<xsl:call-template name="makeDCTD">
					<xsl:with-param name="rowIndex" select="$rowIndex" />
					<xsl:with-param name="overHierarchyIndex" select="0" />
				</xsl:call-template>
			</xsl:when>

			<!-- �s���Q�i�̂Ƃ� -->
			<xsl:when test="$colHiesCount=2">
				<xsl:for-each select="$colHie0Node//Member" >
					<xsl:variable name="colHie0SpreadIndex" select="(position() - 1) * $underColIndex1ComboNum" />

					<xsl:call-template name="makeDCTD">
						<xsl:with-param name="rowIndex" select="$rowIndex" />
						<xsl:with-param name="overHierarchyIndex" select="$colHie0SpreadIndex" />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>

			<!-- �s���R�i�̂Ƃ� -->
			<xsl:when test="$colHiesCount=3">
				<xsl:for-each select="$colHie0Node//Member" >
					<xsl:variable name="colHie0SpreadIndex" select="(position() - 1) * $underColIndex1ComboNum"/>
						<xsl:for-each select="$colHie1Node//Member" >
							<xsl:variable name="colHie1SpreadIndex" select="$colHie0SpreadIndex + ( (position() - 1) * $underColIndex2ComboNum )"/>
							<xsl:call-template name="makeDCTD">
								<xsl:with-param name="rowIndex" select="$rowIndex" />
								<xsl:with-param name="overHierarchyIndex" select="$colHie1SpreadIndex" />
							</xsl:call-template>
						</xsl:for-each>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:element>
</xsl:template>


<xsl:template name="makeDCTD">
	<xsl:param name="rowIndex" />
	<xsl:param name="overHierarchyIndex" />

		<xsl:variable name="tmpColID"   select="/root/OlapInfo/AxesInfo/COL/HierarchyID[$colHiesCount]" />
		<xsl:variable name="tmpColNode" select="/root/Axes/Members[@id=$tmpColID]" />

		<!-- TD�^�O�̕\�� -->
		<xsl:for-each select="$tmpColNode//Member">
				<xsl:element name="TD">
					<xsl:attribute name="orgTColor" >
						<xsl:text>#000000</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="orgBColor" />
					<xsl:attribute name="id">DC_R<xsl:value-of select="$rowIndex" />C<xsl:value-of select="$overHierarchyIndex + (position() - 1)" /></xsl:attribute>
					<xsl:text>�@</xsl:text>
				</xsl:element>
		</xsl:for-each>

</xsl:template>
</xsl:stylesheet>
