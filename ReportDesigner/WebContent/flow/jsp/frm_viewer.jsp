<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="*,48" frameborder="no" framespacing="0">
	<frame src="../../Controller?action=displayNewReport&cubeSeq=<%=request.getParameter("cubeSeq")%>" name="frm_view" scrolling="yes" noresize>
	<frame src="back_next.html" name="frm_next" scrolling="no" noresize>
</frameset>
<noframes></noframes>
</html>