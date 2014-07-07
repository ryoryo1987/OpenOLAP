<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
</head>
<frameset cols="0,300,*">
  <frame name="update_tree_frm" frameborder="1" scrolling="no"  target="contents" src="hidden/cust_dim_tree_regist.jsp?opr=update">
  <FRAME NAME="navi_frm" frameborder="1" scrolling="yes"  target="navi_form" src="main/cust_dim_tree.jsp?dimSeq=<%=request.getParameter("dimSeq")%>&objSeq=<%=request.getParameter("objSeq")%>">
  <frame name="right_frm" frameborder="1" scrolling="yes"  target="contents" src="hidden/blank.jsp">
</frameset>
</html>
