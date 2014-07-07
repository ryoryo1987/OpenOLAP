<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="*,50" frameborder="no" framespacing="0">
	<frameset cols="*,0,0,0" frameborder="no" framespacing="0">
		<frame src="r_report_start.jsp" name="frm_start" scrolling="yes" framespacing="0">
		<frame src="frm_screen.jsp" name="frm_screen" scrolling="yes" framespacing="0">
		<frame src="frm_mapping.jsp" name="frm_mapping" scrolling="yes" framespacing="0">
		<frame src="frm_resultRreport.jsp" name="frm_result" scrolling="yes" framespacing="0">
	</frameset>
	<frame src="back_next.jsp" name='frm_backNext' framespacing="0">
</frameset>
<noframes></noframes>
</html>
