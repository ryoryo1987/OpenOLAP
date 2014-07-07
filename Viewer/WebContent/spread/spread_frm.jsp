<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>

<%
	String idString = null;
	if(request.getParameter("cubeSeq") != null) {
		idString = "cubeSeq=" + request.getParameter("cubeSeq");
	}
	if(request.getParameter("seqId") != null) {
		idString = "seqId=" + request.getParameter("seqId");
	}
%>

<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</HEAD>

<FRAMESET rows="0,0,*,0" framespacing="0">
	<FRAME name="spread_header" scrolling="no" src="Controller?action=getReportHeader&<%= idString %>" frameborder="0" noresize>
	<FRAME name="info_area" scrolling="no" src="./spread/blank.html" frameborder="0" noResize>
	<FRAME name="display_area" scrolling="no" src="./spread/blank.html" frameborder="0">
	<FRAME name="chart_sub_area" scrolling="no" src="./spread/blank.html">
	<NOFRAMES>
		<p>このページにはフレームが使用されていますが、お使いのブラウザではサポートされていません。</p>
	</NOFRAMES>

</FRAMESET>
</HTML>