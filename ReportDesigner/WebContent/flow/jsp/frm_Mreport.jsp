<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="*,0" frameborder="no" framespacing="0">
	<frameset cols="*,0,0" frameborder="no" framespacing="0">
		<frame src="main/report_cube_main.jsp" name="frm_main1" scrolling="yes" noresize>
		<frame src="../blank.html" name="frm_main2" scrolling="yes" noresize>
		<frame src="../blank.html" name="frm_main3" scrolling="yes" noresize>
	</frameset>
	<frame src="../blank.html" name="frm_hidden" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>