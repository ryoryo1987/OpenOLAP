<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title><%=(String)session.getValue("aplName")%></title>

</head>

<frameset cols="0,248,*">
  <frame name="frm_hidden" frameborder="0" scrolling="yes"  target="contents" src="flow/blank.html">
  <frame name="navi_frm" frameborder="0" scrolling="no"  target="contents" src="flow/objects.jsp">
  <frame name="right_frm" frameborder="0" scrolling="yes"  target="contents" src="flow/home.jsp">
</frameset>
</html>
