<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>

<%
/*
	String userSeq = "";
	String objSeq = "";

	String [] tmp = new String[2];
	int i = 0;
	//TREEから受け渡された引数を分割
	StringTokenizer in = new StringTokenizer(request.getParameter("seqId"), "," );
	while (in.hasMoreTokens()) {
		// 文字列を格納
		tmp[i] = in.nextToken();
		i++;
	}

	userSeq = tmp[0];
	objSeq = tmp[1];
*/
	String objSeq=request.getParameter("seqId");
	String schemaName=request.getParameter("schemaName");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
</head>
<frameset rows="280,*" frameborder="no" framespacing="0">
	<frame src="main/sqlviewer_main.jsp?objSeq=<%=objSeq%>&schemaName=<%=schemaName%>" name="frm_main" scrolling="no" noresize>
	<frame src="../blank.html" name="frm_main2" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>