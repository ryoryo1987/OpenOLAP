<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>
<frameset rows="36,*,300" frameborder="no" framespacing="0" scrolling="no">
	<frame name="frm_title" src="header.jsp" frameborder="no" scrolling="no">
	<frame name="frm_view" src="sample.jsp" frameborder="no" framespacing="0" scrolling="yes">
	<frameset cols="50%,50%,300" frameborder="yes" framespacing="1">
		<frame src="mapping_db.html" name="frm_mapping_db" scrolling="yes">
		<frame src="mapping_xmllist.jsp" name="frm_mapping_xmllist" scrolling="yes">
		<frame src="mapping_property.jsp" name="frm_mapping_property" scrolling="yes">
	</frameset>
</frameset>
<noframes></noframes>
</html>
