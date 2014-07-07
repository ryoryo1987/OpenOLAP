<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;

%>

<html>

<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script type="text/javascript" src="../../../spread/js/spreadFunc.js"></script>
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



		function pushNext() {
			var cubeSeq = frm_cube.document.form_main.hid_cube_seq.value;
			if(cubeSeq==""){
				alert("キューブを選択してください。");
				return;
			}
			parent.document.body.firstChild.cols = "0,*,0";
			document.form_main.action = "../frm_viewer.jsp?cubeSeq=" + cubeSeq;
			document.form_main.target = "frm_main2";
			document.form_main.submit();

		}


	</script>

</head>

<body>
<form name="form_main" id="form_main" method="post" action="">
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">レポート作成　-　キューブ選択(1/3)</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
<table>
	<tr>
		<td valign="top" style="padding-top:17;padding-left:7">
			<div id="div_status" style="display:inline;width:328;">
				<table name="tbl_status" id="tbl_status" style="width:100%">
					<tr>
						<td>
							<div style="display:inline;width:23;"></div>
							<div class="title" style="display:inline;width:140;font-weight:bold;text-align:left;">キューブ</div>
							<div class="title" style="display:inline;width:50;font-weight:bold;text-align:center;">件数</div>
							<div class="title" style="display:inline;width:100;font-weight:bold;text-align:center;">更新日時</div>
							<iframe name="frm_cube" src="report_cube_list.jsp" width="328" height="462" style="overflow-y:auto"></iframe>
						</td>
					</tr>
				</table>
			</div>

		</td>
		<td valign="top">
			<div id="div_prpt">
			</div>
		</td>
	</tr>
</table>


<div class="WizardButtonArea">
	<input type="button" value="" onclick="pushNext();setChangeFlg();" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
</div>




<!--隠しオブジェクト-->
</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
