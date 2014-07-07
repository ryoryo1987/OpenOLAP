<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
</head>
<frameset rows="36,*,0,0,0" frameborder="no" framespacing="0">
	<frame src="tab/user_tab.jsp?objSeq=<%=request.getParameter("seqId")%>&objKind=<%=request.getParameter("objKind")%>" name="frm_tab" scrolling="no" noresize>
	<frame src="main/user_main.jsp?objSeq=<%=request.getParameter("seqId")%>&objKind=<%=request.getParameter("objKind")%>" name="frm_main" scrolling="yes" noresize>
	<frame src="help/user_help.jsp" name="frm_main2" scrolling="yes" noresize>
	<frame src="main/user_view.jsp" name="frm_main3" scrolling="yes" noresize>
	<frame src="../blank.html" name="frm_hidden" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>
