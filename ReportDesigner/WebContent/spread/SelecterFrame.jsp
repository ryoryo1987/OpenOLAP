<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>

<%
	String targetAxisIDString = "";
	if(request.getParameter("targetAxisID") != null) {
		targetAxisIDString = "targetAxisID=" + request.getParameter("targetAxisID");
	}
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>セレクタ</title>
</head>
<frameset rows="80,*,0" border="0">
	<frame src="Controller?action=displaySelecterHeader&<%= targetAxisIDString %>" name="frm_header" scrolling="no">
	<frame src="./spread/blank.html" name="frm_body" scrolling="no">
	<frame src="./spread/blank.html" name="frm_data" scrolling="no">
</frameset>
</html>
