<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>


<html>

<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<script type="text/javascript" src="../../../spread/js/spreadFunc.js"></script>

	<script language="JavaScript">

		function pushFinish() {


			//共通エラーチェックを先に行う
			if(!checkData()){return;}

			var report_name=document.form_main.txt_report_name.value;
			var par_id=document.form_main.hid_par_id.value;
			if(par_id=="root"){
				par_id="null";
			}
		//	parent.parent.frm_main2.frm_view.display_area.saveReportInfo(report_name,par_id);


			if(confirm(report_name+"を保存します。よろしいですか？")){
				document.form_main.action="report_rgs_regist.jsp";
				document.form_main.target="frm_hidden";
				document.form_main.submit();
			}

		}

		function pushBack(){
			parent.document.body.firstChild.cols = "*,0";
		}

	</script>
</head>

<body>
<form name="form_main" id="form_main" method="post" action="">
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">ポータルレポート作成　-　保存(2/2)</td>

		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>

<br>
<span class="title" style="margin-left:10px">レポート名：<input type="text" name="txt_report_name" value="" size="50" maxlength="30" mON='レポート名'" onchange="setChangeFlg();"></span>
<br><br>
<div id="div_path" style="margin-left:10;"></div>
<iframe name="iframe_main" src="report_rgs_tree.jsp" width="400" height="400" style="margin-left:10"></iframe>
<br>


<div class="WizardButtonArea3">
	<input type="button" value="" onclick="pushBack();setChangeFlg();" class="normal_back" onMouseOver="className='over_back'" onMouseDown="className='down_back'" onMouseUp="className='up_back'" onMouseOut="className='out_back'">
	<input type="button" value="" onclick="pushFinish();" class="normal_finish" onMouseOver="className='over_finish'" onMouseDown="className='down_finish'" onMouseUp="className='up_finish'" onMouseOut="className='out_finish'">
</div>



	<input type="hidden" name="hid_path" value="">
	<input type="hidden" name="hid_par_id" value="">

	<input type="hidden" name="hid_xml" value="<%=request.getParameter("hid_xml")%>">

</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
