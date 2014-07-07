<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,openolap.viewer.Report,openolap.viewer.Axis,openolap.viewer.AxisMember,openolap.viewer.MeasureMember,openolap.viewer.DimensionMember,openolap.viewer.jspHelper.DisplaySelecter,openolap.viewer.common.CommonSettings,openolap.viewer.MeasureMemberType,openolap.viewer.common.Constants"
%>
<%!

	// Image�t�@�C��
	String treeMinusImage = "./images/minus_s.gif";
	String treePlusImage = "./images/plus_s.gif";
	String treeLeafImage = "./images/none_tab.gif";

	String measureImage = "url(./images/measure.gif)";

	private int outSelecterTable(HttpServletRequest request, JspWriter out, HttpSession session, CommonSettings commonSettings, String targetHTMLTable) throws java.io.IOException {

		String targetAxisID = request.getParameter("dimNumber");
		Report report = (Report)session.getAttribute("report");
	
		Axis axis = report.getAxisByID(targetAxisID);
		String dispMemNameType = (String)request.getParameter("dispMemNameType"); // �����o���̕\���^�C�v

		int i = 0;
		Iterator axisMemIt = axis.getAxisMemberList().iterator();
		while ( axisMemIt.hasNext() ) {

			AxisMember axisMember = (AxisMember) axisMemIt.next();
			String idString = axisMember.getUniqueName();

		//	out.println("<TR id=\"" + idString + "\" exist=\"1\" dispflg=\"1\" index=\"" + i + "\" selected=\"0\" style=\"display:block;\">");
			out.println("<TR width='100%' id=\"" + idString + "\" exist=\"1\" index=\"" + i + "\" selected=\"0\" style=\"display:block;\">");
			out.print("<TD width='100%' style='white-space: nowrap;'>");

			String measureTypeImageURL = null;		// �摜URL
			String measureTypeName = null;
			String onClickString = null;	// �N���b�N���Ɏ��s����JavaScript
			if ( axisMember instanceof MeasureMember ) {
					if ( targetHTMLTable.equals("selectedListTable") ) {
						MeasureMember measureMember = (MeasureMember) axisMember;
						measureTypeImageURL = measureMember.getMeasureMemberType().getImageURL();
						measureTypeName = measureMember.getMeasureMemberType().getName();
						onClickString = "makeMeasureTypeSelecter(this);";
					} else {
						measureTypeImageURL = measureImage;
						measureTypeName = "���W���[";
						onClickString = "clickName(this.nextSibling);";
					}
				out.print("<span class='pl' toggle=\"n\" title='" + measureTypeName + "' style='white-space:nowrap;background-image:" + measureTypeImageURL + ";width:18px;height:15px;background-repeat:no-repeat;cursor:pointer;' onclick='" + onClickString + "'></span>");
			} else if ( axisMember instanceof DimensionMember ) {
				DimensionMember dimMember = (DimensionMember) axisMember;

				String toggle = "";
				String drillString = "";
				String style = "";
				if (dimMember.isLeaf()) {
					toggle = "n";
					drillString = "<img src='" + treeLeafImage + "'>";
					style = "white-space:nowrap;padding:0;";
				} else {
					toggle = "m";
					drillString = "<img src='" + treeMinusImage + "' style='cursor:hand;'>";
					style = "white-space:nowrap;cursor:pointer;padding:0;";
				}
				out.print("<span class='pl' toggle=\"" + toggle + "\" style='' onclick='clickToggle(this)'>" + drillString + "</span>");
			}

			out.print("<span class='member' style='vertical-align:middle;width:90%;white-space:nowrap;cursor:default;display:inline;' short_name='" + axisMember.getIndentedShortName() + "' long_name='" + axisMember.getIndentedLongName() + "' onclick='clickName(this)'>");
			if ( axisMember instanceof MeasureMember ) {
				out.print(axisMember.getIndentedShortName());
			} else {
				DimensionMember dimMember = (DimensionMember) axisMember;
				out.print(dimMember.getIndentedNameByDispNameType(dispMemNameType));
			}
			out.print("</span>");
			out.println("</TD>");
			out.println("</TR>");

			i++;
		}

		return i;	// �����o��
	}

%>
<%
	DisplaySelecter displaySelecter = new DisplaySelecter();
	Report report = (Report)session.getAttribute("report");
	int memberCount = 0;

	String measureMemberTypeIDListString  = "";		// ���W���[�����o�[�^�C�v��ID���X�g
	String measureMemberTypeIMGListString = "";		// ���W���[�����o�[�^�C�v�̃C���[�WURL���X�g
	String measureMemberTypeNameListString = "";	// ���W���[�����o�[�^�C�v�̖��̃��X�g

	CommonSettings commonSettings = (CommonSettings)getServletConfig().getServletContext().getAttribute("apCommonSettings");
	Iterator it = commonSettings.getMeasureMemberTypeList().iterator();
	int i = 0;
	while (it.hasNext()){
		MeasureMemberType measureMemberType = (MeasureMemberType) it.next();
		if ( i > 0 ) {
			measureMemberTypeIDListString   += ",";
			measureMemberTypeIMGListString  += ",";
			measureMemberTypeNameListString += ",";
		}
		measureMemberTypeIDListString   += measureMemberType.getId();
		measureMemberTypeIMGListString  += measureMemberType.getImageURL();
		measureMemberTypeNameListString += measureMemberType.getName();
		i++;
	}

	// ���W���[�������o�[��
	String memberType = null;
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		memberType = "���W���[";
	} else {
		memberType = "�����o�[";
	}

%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title>�Z���N�^</title>

		<script type="text/javascript" src="./css/colorStyle.js"></script>
		<script type="text/javascript" src="./spread/js/spread.js"></script>
		<script type="text/javascript" src="./spread/js/message.js"></script>
		<script type="text/javascript" src="./spread/js/selecterBody.js"></script>
		<script type="text/javascript" src="./flow/jsp/js/registration.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/common.css">
		<style>
			.list
			{
				border:1 inset gray;
				height:240px;
				width:200px;
				overflow:auto;
			}
		</style>
	</head>

<body onload='initialize();' onselectstart='return false'>

<div id="testArea1" style="display:inline;"></div>
<div id="testArea2" style="display:inline;"></div>

		<form name="frm_main" method="post" id="Form1">
		<table style="margin:0 10">
			<tr>
				<td class="title">�I���\��<%= memberType %>�F
					<input type="button" onclick = "setTree('selectableListTable', 1)" title="�܂���" class="normal_plus" onMouseOver="className='over_plus'" onMouseDown="className='down_plus'" onMouseUp="className='up_plus'" onMouseOut="className='out_plus'">
					<input type="button" onclick = "setTree('selectableListTable', 2)" title="�W�J" class="normal_minus" onMouseOver="className='over_minus'" onMouseDown="className='down_minus'" onMouseUp="className='up_minus'" onMouseOut="className='out_minus'">
				</td>
				<td></td>
				<td class="title">�I���ς݂�<%= memberType %>�F
					<input type="button" onclick = "setTree('selectedListTable', 1)" title="�܂���" class="normal_plus" onMouseOver="className='over_plus'" onMouseDown="className='down_plus'" onMouseUp="className='up_plus'" onMouseOut="className='out_plus'">
					<input type="button" onclick = "setTree('selectedListTable', 2)" title="�W�J" class="normal_minus" onMouseOver="className='over_minus'" onMouseDown="className='down_minus'" onMouseUp="className='up_minus'" onMouseOut="className='out_minus'">
				</td>
			</tr>
<tr style="display:none;"><td>
</td></tr>
			<tr>
				<td>
					<div class="list">
					<TABLE id='selectableListTable' width="100%" style="visibility:hidden;">

<%
						memberCount = outSelecterTable( request, out, session, commonSettings, "selectableListTable" );
%>
					</TABLE>
					</div>
				</td>

				<td style="width:80;text-align:center;vertical-align:middle">
					<input type="button" value="" onclick='replace()' class="normal_sub" onMouseOver="className='over_sub'" onMouseDown="className='down_sub'" onMouseUp="className='up_sub'" onMouseOut="className='out_sub'">
					<input type="button" value="" onclick='add()' class="normal_add" onMouseOver="className='over_add'" onMouseDown="className='down_add'" onMouseUp="className='up_add'" onMouseOut="className='out_add'"><br><br>
					<input type="button" value="" onclick='remove(1)' class="normal_del" onMouseOver="className='over_del'" onMouseDown="className='down_del'" onMouseUp="className='up_del'" onMouseOut="className='out_del'">
				</td>

				<td>
					<div class="list">
					<TABLE id='selectedListTable' width="100%" style="visibility:hidden;">
<%
							memberCount = outSelecterTable( request, out, session, commonSettings, "selectedListTable" );
%>
					</TABLE>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<div style="position:absolute;left:20;top:284;width:80;text-align:center;background-color:white"><span class="title">�����̎w��</span>
					</div>
					<div style="border:1 solid gray;padding:10;margin-top:20">
						<table>
							<tr>
								<td class="title">�����o�[���F</td>
								<td>
									<input type="text" value="*" name='listMemberName' mON='�����o�[��'
<%
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		out.println("disabled");
	}
%>
 >
								</td>

							</tr>
							<tr>
								<td class="title">���x���F</td>
								<td>
									<select name='listLevel' id='listLevel'
<%
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		out.println("disabled");
	}
%>
>
										<option value='*'>�S��</option>
<%
										displaySelecter.outLevelName( report, request.getParameter("dimNumber"), out );
%>
									</select>
								</td>
								<td>
								<input type="button" value="" class="normal_search" onMouseOver="className='over_search'" onMouseDown="className='down_search'" onMouseUp="className='up_search'" onMouseOut="className='out_search'" onclick="searchList();"
<%
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		out.println("disabled");
	}
%>
>
								</td>
							</tr>
						</table>
					</div>
					<div class="cmdBtnCenter" style="width:100%;text-align:center;margin:10">
						<input type="button" value="" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'" onclick="setSelecterStatus();">
						<input type="button" value="" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'" onclick="parent.window.close()">
					</div>
				</td>
			</tr>
		</table>

		<input type="hidden" value="<%=request.getParameter("dimNumber")%>" name="dimNumber">
		<input type="hidden" value="" name="measureTypes">		<!-- �S���W���[�����o�[�̃^�C�v���X�g -->
		<input type="hidden" value="" name="dimMemDispTypes">	<!-- �S�f�B�����V���������o�̕\�����^�C�v���X�g -->
		<input type="hidden" value="" name="dtColorInfo">		<!-- �w�b�_�[�Z���̐F���X�g -->
		<input type="hidden" value="" name="hdrColorInfo">		<!-- �f�[�^�e�[�u���Z���̐F���X�g -->


		<!-- �f�B�����V����/���W���[���̑I�����ꂽ�����o��Key�E�h������� -->
		<input type="hidden" value="" name="dim1">
		<input type="hidden" value="" name="dim2">
		<input type="hidden" value="" name="dim3">
		<input type="hidden" value="" name="dim4">
		<input type="hidden" value="" name="dim5">
		<input type="hidden" value="" name="dim6">
		<input type="hidden" value="" name="dim7">
		<input type="hidden" value="" name="dim8">
		<input type="hidden" value="" name="dim9">
		<input type="hidden" value="" name="dim10">
		<input type="hidden" value="" name="dim11">
		<input type="hidden" value="" name="dim12">
		<input type="hidden" value="" name="dim13">
		<input type="hidden" value="" name="dim14">
		<input type="hidden" value="" name="dim15">
		<input type="hidden" value="" name="dim16">

		</form>

		<!-- �f�B�����V����/���W���[�����o��� -->
		<div id="memberCount" style="display:none" ><%= report.getTotalMeasureMemberNumber() %></div>

	</body>
</html>

<script>

var dimNumber = "<%= request.getParameter("dimNumber") %>";	// �Z���N�^�Őݒ蒆�̃f�B�����V����/���W���[�ԍ�
var spreadXMLData = null;		// �N���C�A���g���Ɏ���XML�I�u�W�F�N�g(�����o���ɃZ���N�^�ŊO���ꂽ�����o�͊܂܂Ȃ�)
var axisMemberXMLData = null;	// ���̑S�����o��������XML�I�u�W�F�N�g

var measureMemTypeIDListString   = "<%= measureMemberTypeIDListString %>";		// ���W���[�����o�[�^�C�v��ID���X�g
var measureMemTypeIMGListString  = "<%= measureMemberTypeIMGListString %>";		// ���W���[�����o�[�^�C�v�̃C���[�WURL���X�g
var measureMemTypeNameListString = "<%= measureMemberTypeNameListString %>";	// ���W���[�����o�[�^�C�v�̖��̃��X�g

var treeMinusImage = "<%= treeMinusImage %>";
var treePlusImage  = "<%= treePlusImage %>";



// =============================================================================
//  ������
// =============================================================================
	var tab1 = document.getElementById("selectableListTable").firstChild;
	var tab2 = document.getElementById("selectedListTable").firstChild;

</script>

