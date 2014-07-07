<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%
	int seqId = Integer.parseInt(request.getParameter("seqId"));
%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="*,0" frameborder="no" framespacing="0">
	<frameset cols="*,0" frameborder="no" framespacing="0">
		<frame src="main/sec_main.jsp?groupId=<%=seqId%>" name="frm_main1" scrolling="yes" noresize>
		<frame src="../blank.html" name="frm_main2" scrolling="yes" noresize>
	</frameset>
	<frame src="../blank.html" name="frm_hidden" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>