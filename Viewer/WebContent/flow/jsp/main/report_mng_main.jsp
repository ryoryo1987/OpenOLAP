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
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<script type="text/javascript" src="../../../spread/js/spreadFunc.js"></script>
	<script language="JavaScript">
		function updateTree(){
			document.form_main.target="navi_frm";
			document.form_main.action="../../objects.jsp";
			document.form_main.submit();
		}

	</script>
</head>

<body>
<form name="form_main" id="form_main" method="post" action="">
<!-- ページヘッダー -->
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">フォルダ・レポート管理</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>

			<iframe name="iframe_main" src="../frm_report_mng_control.jsp?seqId=<%=request.getParameter("seqId")%>" width="700" height="80%" style="margin:20 20 10 20 ;"></iframe>

<br>
<div width="700" align="center">
<input type="button" value="" onclick="updateTree()" class="normal_update_tree" onMouseOver="className='over_update_tree'" onMouseDown="className='down_update_tree'" onMouseUp="className='up_update_tree'" onMouseOut="className='out_update_tree'">
</div>

<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>

</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
