<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</head>

<frameset cols="0,200,*">
  <frame name="update_tree_frm" frameborder="1" scrolling="no"  target="contents" src="hidden/report_mng_tree_regist.jsp?opr=update">
  <FRAME NAME="navi_frm2" frameborder="1" scrolling="yes"  target="navi_form" src="main/report_mng_tree.jsp?seqId=<%=request.getParameter("seqId")%>">
  <frame name="right_frm" frameborder="1" scrolling="no"  target="contents" src="hidden/blank.jsp">
</frameset>
</html>
