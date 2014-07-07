<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String seqId = request.getParameter("seqId");

	String strReportName="";

	String Sql = "SELECT report_name FROM oo_v_report WHERE report_id = " + seqId;
	rs = stmt.executeQuery(Sql);
	if(rs.next()) {
		strReportName=rs.getString("report_name");
	}
	rs.close();

%>
<html>

<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
	</script>
</head>

<body>
<form name="form_main" id="form_main" method="post" action="">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<table class="Header">
			<tr>
				<td class="HeaderTitleLeft"></td>
				<td class="HeaderTitleCenter"><%=strReportName%></td>
				<td class="HeaderTitleRight">
					<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
	<td width="100%" height="100%">
	<!--	<iframe name="frm_inner" src="dispFrm.jsp?kind=db&amp;rId=<%=seqId%>" width="100%" height="100%"></iframe>-->
		<iframe name="frm_inner" src="waiting.jsp?seqId=<%=seqId%>"  frameborder="0" width="100%" height="100%"></iframe>
	</td>
	</tr>

</table>


<input type="hidden" name="hid_dom" value="">

</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
