<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>

<%

	String Sql;
	String seqId = request.getParameter("seqId");
	String strReportName="";
	String strReportOwnerFlg="";

	Sql="";
	Sql += " SELECT report_id,report_name,report_owner_flg";
	Sql += " FROM oo_v_report";
	Sql += " WHERE report_id = " + seqId;
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		strReportName=rs.getString("report_name");
		strReportOwnerFlg=rs.getString("report_owner_flg");
	}
	rs.close();

%>

<html>

<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script type="text/javascript" src="../../../spread/js/toolBar.js"></script>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<link rel="stylesheet" type="text/css" href="../../../css/flow.css">
	<style>
		.item_title
		{
			padding-left:5px;
		}
		.item_name
		{
			padding-left:25px;
		}
		.item
		{
			padding-left:65px;
			vertical-align:top;
		}


	</style>

	<script language="JavaScript">

		function load(){

			if(self.name=="right_frm"){
				document.all.tdTitle.innerHTML="<%=strReportName%>";
			}else{
				document.all.tdTitle.innerHTML="ポータルレポート作成　-　レポート設定(1/2)";
			}

<%
			if(seqId==null){//ポータルレポート作成画面では保存ボタンを表示しない
				out.println("document.all.tblBtn8.style.display='none';");
			}
%>
		}


		function pushNext() {
			parent.document.body.firstChild.cols = "0,*";
			document.form_main.action = "report_rgs_main.jsp";
			document.form_main.target = "frm_main2";
			document.form_main.submit();

		}

	</script>

</head>

<body onload="load()">
<form name="form_main" id="form_main" method="post" action="">
<table width="100%" height="100%" cellspacing="0" cellpadding="0"><tr><td>
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter" id="tdTitle"></td>

					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn1" title="新規作成" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.displayObject(-999,-999,300,300,'blank.html','internet','','1');setChangeFlg();">
										<img src="../../../images/temp1.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn2" title="削除" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.del();setChangeFlg();">
										<img src="../../../images/temp2.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn3" title="入れ替え" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.changeWindow();setChangeFlg();">
										<img src="../../../images/temp3.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn4" title="横に並べて表示" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.displayLineUp('crosswise');setChangeFlg();">
										<img src="../../../images/temp4.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn5" title="縦に並べて表示" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.displayLineUp('lengthwise');setChangeFlg();">
										<img src="../../../images/temp5.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn6" title="全て閉じる" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.controlAllWindow('close');setChangeFlg();">
										<img src="../../../images/temp6.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn7" title="全て開く" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.controlAllWindow('open');setChangeFlg();">
										<img src="../../../images/temp7.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblBtn8" title="保存" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.save();setChangeFlg();">
										<img src="../../../images/save.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td class="HeaderTitleCenter" style="width:22;text-align:right;padding:6 5 0 0">
						<table id="tblLogoutBtn" title="ログアウト" cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td>
									<div style="display:inline;white-space:nowrap;" onClick="frm_chart.logout_flow(this, '<%= request.getContextPath() %>');setChangeFlg();">
										<img src="../../../images/logout.gif" class="normal_toolicon"  onMouseOver="tbMouseOver(this);" onMouseDown="tbMouseDown(this);" onMouseUp="tbMouseUp(this);" onMouseOut="tbMouseOut(this);" />
									</div>
								</td>
							</tr>
						</table>
					</td>
	</tr>
</table>

</td></tr>

<tr><td width="100%" height="100%" style="padding-left:8">
<iframe name="frm_chart" src="portal_chart.jsp?seqId=<%=seqId%>" width="100%" height="100%"></iframe>
</td></tr>


<%if(seqId==null){%>
<tr><td>
<div class="WizardButtonArea">
	<input type="button" value="" onclick="frm_chart.save();pushNext();setChangeFlg();" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
</div>
</td></tr>
<%}%>

</table>


<!--隠しオブジェクト-->
	<input type="hidden" name="hid_xml" value="">
	<input type="hidden" name="strReportOwnerFlg" value="<%=strReportOwnerFlg%>">


</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
