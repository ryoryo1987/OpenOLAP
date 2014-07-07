<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="*,0" frameborder="no" framespacing="0">
	<frame src="main/report_mng_main.jsp?seqId=<%=request.getParameter("seqId")%>" name="frm_main" scrolling="yes" noresize>
	<frame src="../blank.html" name="frm_hidden" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>