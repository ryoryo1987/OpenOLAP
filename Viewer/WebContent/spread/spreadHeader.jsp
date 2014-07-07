<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="openolap.viewer.Report"
%>
<%

	Report report = (Report) session.getAttribute("report");
	String reportName = "";
		if ( report != null ) {
			reportName = report.getReportName();
		}
	String errorMessage = (String) request.getAttribute("errorMessage");
	String message = (String) request.getAttribute("message");

%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<TITLE><%=(String)session.getValue("aplName")%></TITLE>
	<link rel="stylesheet" type="text/css" href="./css/common.css">
</HEAD>

<BODY onload="init();" style="background-color:#EFECE7">
<FORM name="form_main" method="post">
</FORM>
</BODY>
</HTML>

<script language="JavaScript">
	function init() {

<%
		if ( errorMessage == null ) {

			if ( message != null ) {
%>
				alert("<%= message %>");
<%
			}
%>
			document.form_main.action='Controller?action=loadClientInitAct';
			document.form_main.target='info_area';
			document.form_main.submit();
<%
		} else {
%>
//			loadingStatus.loadingIMG.src = "../images/logo_anime_stop.gif";
//			loadingStatus.loadingIMG.src = "../images/title.jpg";

			alert("<%= errorMessage %>");
<%
		}
%>
	}
</script>
