<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>

<%@ include file="../../connect.jsp"%>
<%
	String seqId = request.getParameter("seqId");

	String SQL = "";


	String exportFileType = "";
	String colorStyleId = "";

	SQL = "SELECT export_file_type,color_style_id FROM oo_v_user WHERE user_id = " + seqId;
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		exportFileType = rs.getString("export_file_type");
		colorStyleId = rs.getString("color_style_id");
	}
	rs.close();



%>


<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">




		function regist(){

			//共通エラーチェックを先に行う
			if(!checkData()){return;}

			document.form_main.action = "../hidden/exp_regist.jsp";
			document.form_main.target = "frm_hidden";
			document.form_main.submit();

		}

	</script>








</head>

<body>
	<form id="form_main" method="post" name="form_main">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">各種設定</td>
			<td class="HeaderTitleRight">
				<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
			</td>
		</tr>
	</table>

	<div style="margin:15">



				<table>
					<tr>
						<td align="right"><span class="title">エクスポート形式：</span></td>
						<td>
							<select name="lst_export_file">
								<option value="XMLSpreadSheet" <%if("XMLSpreadSheet".equals(exportFileType)){out.println("selected");}%>>XMLSpreadSheet</option>
								<option value="CSV" <%if("CSV".equals(exportFileType)){out.println("selected");}%>>CSV</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">Mレポートの色：</span></td>
						<td>
							<select name="lst_m_color">
<%

	SQL = "SELECT id,name FROM oo_v_color_style order by id";
	rs = stmt.executeQuery(SQL);
	while(rs.next()) {
		String tempStr = "";
		if(rs.getString("id").equals(colorStyleId)){
			tempStr = "selected";
		}
		out.println("<option value='" + rs.getString("id") + "' " + tempStr + ">" + rs.getString("name") + "</option>");
	}
	rs.close();

%>
							</select>
						</td>
					</tr>
				</table>
			

<BR>


				<div class="command">
						<!-- **************************  更新　ボタン ***************************** -->
						<input type="button" name="edi_btn" value="" class="normal_update" onClick="javaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
				</div>


				<input type="hidden" name="hid_user_id" value="<%=seqId%>">

	</div>
	</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
