<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,openolap.viewer.Report,openolap.viewer.Axis,openolap.viewer.AxisMember,openolap.viewer.MeasureMember,openolap.viewer.DimensionMember,openolap.viewer.jspHelper.DisplaySelecter,openolap.viewer.common.CommonSettings,openolap.viewer.MeasureMemberType,openolap.viewer.common.Constants"
%>
<%!

	// Imageファイル
	String treeMinusImage = "./images/minus_s.gif";
	String treePlusImage = "./images/plus_s.gif";
	String treeLeafImage = "./images/none_tab.gif";

	String measureImage = "url(./images/measure.gif)";

	private int outSelecterTable(HttpServletRequest request, JspWriter out, HttpSession session, CommonSettings commonSettings, String targetHTMLTable) throws java.io.IOException {

		String targetAxisID = request.getParameter("dimNumber");
		Report report = (Report)session.getAttribute("report");
	
		Axis axis = report.getAxisByID(targetAxisID);
		String dispMemNameType = (String)request.getParameter("dispMemNameType"); // メンバ名の表示タイプ

		int i = 0;
		Iterator axisMemIt = axis.getAxisMemberList().iterator();
		while ( axisMemIt.hasNext() ) {

			AxisMember axisMember = (AxisMember) axisMemIt.next();
			String idString = axisMember.getUniqueName();

		//	out.println("<TR id=\"" + idString + "\" exist=\"1\" dispflg=\"1\" index=\"" + i + "\" selected=\"0\" style=\"display:block;\">");
			out.println("<TR width='100%' id=\"" + idString + "\" exist=\"1\" index=\"" + i + "\" selected=\"0\" style=\"display:block;\">");
			out.print("<TD width='100%' style='white-space: nowrap;'>");

			String measureTypeImageURL = null;		// 画像URL
			String measureTypeName = null;
			String onClickString = null;	// クリック時に実行するJavaScript
			if ( axisMember instanceof MeasureMember ) {
					if ( targetHTMLTable.equals("selectedListTable") ) {
						MeasureMember measureMember = (MeasureMember) axisMember;
						measureTypeImageURL = measureMember.getMeasureMemberType().getImageURL();
						measureTypeName = measureMember.getMeasureMemberType().getName();
						onClickString = "makeMeasureTypeSelecter(this);";
					} else {
						measureTypeImageURL = measureImage;
						measureTypeName = "メジャー";
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

		return i;	// メンバ数
	}

%>
<%
	DisplaySelecter displaySelecter = new DisplaySelecter();
	Report report = (Report)session.getAttribute("report");
	int memberCount = 0;

	String measureMemberTypeIDListString  = "";		// メジャーメンバータイプのIDリスト
	String measureMemberTypeIMGListString = "";		// メジャーメンバータイプのイメージURLリスト
	String measureMemberTypeNameListString = "";	// メジャーメンバータイプの名称リスト

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

	// メジャーかメンバーか
	String memberType = null;
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		memberType = "メジャー";
	} else {
		memberType = "メンバー";
	}

%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title>セレクタ</title>

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
				<td class="title">選択可能な<%= memberType %>：
					<input type="button" onclick = "setTree('selectableListTable', 1)" title="折り畳み" class="normal_plus" onMouseOver="className='over_plus'" onMouseDown="className='down_plus'" onMouseUp="className='up_plus'" onMouseOut="className='out_plus'">
					<input type="button" onclick = "setTree('selectableListTable', 2)" title="展開" class="normal_minus" onMouseOver="className='over_minus'" onMouseDown="className='down_minus'" onMouseUp="className='up_minus'" onMouseOut="className='out_minus'">
				</td>
				<td></td>
				<td class="title">選択済みの<%= memberType %>：
					<input type="button" onclick = "setTree('selectedListTable', 1)" title="折り畳み" class="normal_plus" onMouseOver="className='over_plus'" onMouseDown="className='down_plus'" onMouseUp="className='up_plus'" onMouseOut="className='out_plus'">
					<input type="button" onclick = "setTree('selectedListTable', 2)" title="展開" class="normal_minus" onMouseOver="className='over_minus'" onMouseDown="className='down_minus'" onMouseUp="className='up_minus'" onMouseOut="className='out_minus'">
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
					<div style="position:absolute;left:20;top:284;width:80;text-align:center;background-color:white"><span class="title">条件の指定</span>
					</div>
					<div style="border:1 solid gray;padding:10;margin-top:20">
						<table>
							<tr>
								<td class="title">メンバー名：</td>
								<td>
									<input type="text" value="*" name='listMemberName' mON='メンバー名'
<%
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		out.println("disabled");
	}
%>
 >
								</td>

							</tr>
							<tr>
								<td class="title">レベル：</td>
								<td>
									<select name='listLevel' id='listLevel'
<%
	if ( request.getParameter("dimNumber").equals(Constants.MeasureID) ) {
		out.println("disabled");
	}
%>
>
										<option value='*'>全て</option>
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
		<input type="hidden" value="" name="measureTypes">		<!-- 全メジャーメンバーのタイプリスト -->
		<input type="hidden" value="" name="dimMemDispTypes">	<!-- 全ディメンションメンバの表示名タイプリスト -->
		<input type="hidden" value="" name="dtColorInfo">		<!-- ヘッダーセルの色リスト -->
		<input type="hidden" value="" name="hdrColorInfo">		<!-- データテーブルセルの色リスト -->


		<!-- ディメンション/メジャー毎の選択されたメンバのKey・ドリル情報 -->
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

		<!-- ディメンション/メジャーメンバ情報 -->
		<div id="memberCount" style="display:none" ><%= report.getTotalMeasureMemberNumber() %></div>

	</body>
</html>

<script>

var dimNumber = "<%= request.getParameter("dimNumber") %>";	// セレクタで設定中のディメンション/メジャー番号
var spreadXMLData = null;		// クライアント側に持つXMLオブジェクト(メンバ情報にセレクタで外されたメンバは含まない)
var axisMemberXMLData = null;	// 軸の全メンバ情報を持つXMLオブジェクト

var measureMemTypeIDListString   = "<%= measureMemberTypeIDListString %>";		// メジャーメンバータイプのIDリスト
var measureMemTypeIMGListString  = "<%= measureMemberTypeIMGListString %>";		// メジャーメンバータイプのイメージURLリスト
var measureMemTypeNameListString = "<%= measureMemberTypeNameListString %>";	// メジャーメンバータイプの名称リスト

var treeMinusImage = "<%= treeMinusImage %>";
var treePlusImage  = "<%= treePlusImage %>";



// =============================================================================
//  初期化
// =============================================================================
	var tab1 = document.getElementById("selectableListTable").firstChild;
	var tab2 = document.getElementById("selectedListTable").firstChild;

</script>

