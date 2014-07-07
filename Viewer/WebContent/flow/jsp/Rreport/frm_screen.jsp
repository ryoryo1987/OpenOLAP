<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="36,*,300" frameborder="no" framespacing="0" scrolling="no">
	<frame name="frm_title" src="header.jsp" frameborder="no" framespacing="0" scrolling="no">
	<frame src="sample.jsp" name="frm_displayScreen" frameborder="no">
	<frameset cols="25%,25%,25%,250" frameborder="yes" framespacing="1">
		<frame src="xml/screen.xml" name="frm_screen" scrolling="yes">
		<frame src="screen_css.html" name="frm_css" scrolling="yes">
		<frame src="screen_model.jsp" name="frm_model" scrolling="yes">
		<frame src="screen_property.jsp" name="frm_property" scrolling="yes">
	</frameset>
</frameset>
<noframes></noframes>
</html>
