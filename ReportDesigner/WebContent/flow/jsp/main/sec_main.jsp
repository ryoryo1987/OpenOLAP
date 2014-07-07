<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>


<html>

<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<script language="JavaScript">


		function regist(){

			document.form_main.hid_dom.value=control_frm.dom_frm.getXMLTreeDom().xml;

			document.form_main.action="../hidden/sec_regist.jsp";
			document.form_main.target="frm_hidden";
			document.form_main.submit();
		}


	</script>
</head>

<body onresize="control_frm.right_frm.resizeArea()">
<form name="form_main" id="form_main" method="post" action="">
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">権限設定</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>

<br>
<br>

<center>
	<iframe name="control_frm" src="sec_control.jsp?groupId=<%=request.getParameter("groupId")%>" width="90%" height="470"></iframe>
</center>
	<div class="command">
		<input type="button" value="" onclick="regist()" class="normal_ok" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'" />
	</div>


<input type="hidden" name="hid_dom" value="">
<input type="hidden" name="hid_group_id" value="<%=request.getParameter("groupId")%>">

</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
