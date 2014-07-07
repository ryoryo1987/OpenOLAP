<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%
	int groupId = Integer.parseInt(request.getParameter("groupId"));
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>

	<frameset cols="0,300,*">
	  <frame name="dom_frm" frameborder="0" scrolling="no"  target="contents" src="sec_dom.jsp?groupId=<%=groupId%>">
	  <FRAME NAME="navi_frm2" frameborder="1" scrolling="yes"  target="navi_form" src="../../blank.html">
	  <frame name="right_frm" frameborder="1" scrolling="yes"  target="contents" src="../../blank.html">
	</frameset>

</html>

