<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "openolap.viewer.Report"%>
<%@ page import = "java.util.*"%>
<%@ include file="../flow/connect.jsp" %>

<%
	String SQL = "";
	int updateCount = 0;

//	session.setAttribute("highLightXML",(String)request.getParameter("hid_xml"));

	Report report = (Report)session.getAttribute("report");
	report.setHighLightXML((String)request.getParameter("hid_xml"));
	report.setColorType("2");
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">

		var openerFrame = window.dialogArguments;
		var colorTypeID=2; // ハイライトモードを表す

		function load(){

			// サーバーへ送信・再表示処理呼び出し
			openerFrame.SpreadForm.action="Controller?action=renewHtmlAct&newColorType="+colorTypeID;
			openerFrame.SpreadForm.target='display_area';
			openerFrame.document.SpreadForm.submit();


			parent.window.close();



		}
	</script>
</head>
<body onload="load()">
<br><br>
updateCount:<%=updateCount%>
</body>
</html>
<%@ include file="../flow/connect_close.jsp" %>
