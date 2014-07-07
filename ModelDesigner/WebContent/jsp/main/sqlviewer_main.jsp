<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String strScript="";
	Sql = "select oo_dim_sql(-1,'0','" + request.getParameter("schemaName") + "') as script";
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strScript=rs.getString("script");
	}
	rs.close();
%>

<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">

	<script language="JavaScript">

		function exeSql(){
			document.form_main.action="../main/sqlviewer_table.jsp";
			document.form_main.target="frm_main2";
			document.form_main.submit();
		}

	</script>
</head>

<body onload="exeSql()">

<form name="form_main" id="form_main" method="post" action="">
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				SQLビューア
			</td>
			<td class="HeaderTitleRight">
				<!--<input type="button" value="" onClick="JavaScript:parent.window.close();" class="normal_close" onMouseOver="className='over_close'" onMouseDown="className='down_close'" onMouseUp="className='up_close'" onMouseOut="className='out_close'">-->
				<input type="button" value="閉じる" onClick="JavaScript:parent.window.close();">
			</td>
		</tr>
	</table>

	<!-- レイアウト用 -->
	<div class="main" id="dv_main" style="margin:0">
	<table class="frame" style="margin:0">
		<tr>
			<td class="left" style="width:7px;"></td>
			<td class="main" style="padding-left:10px;padding-right:10px">
			
 				<!-- コンテンツ -->
				<table width="100%">
					<tr>
						<!-- 項目 =-->
						<td>
							<B>SQL</B><BR>
							<center>
								<textarea name="ara_script" cols="100" rows="10" style="width:100%;"><%=strScript%></textarea>
							</center>
						</td>
					</tr>
				</table>

				<input type="button" name="allcrt_btn" value="" onClick="exeSql();" class="normal_go" onMouseOver="className='over_go'" onMouseDown="className='down_go'" onMouseUp="className='up_go'" onMouseOut="className='out_go'">
				<hr>
			</td>
			<td class="right"></td>
		</tr>
	</table>
	</div>


<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>


</form>

</body>
</html>


