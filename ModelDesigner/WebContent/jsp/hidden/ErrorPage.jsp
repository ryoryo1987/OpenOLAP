<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page isErrorPage="true" %>
<%@ page import = "java.util.*"%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
		function load(){
			alert("<%=ood.replace(exception.toString().replace('\n',' '),"\"","\\\"")%>");
			location.replace("blank.jsp");
		}
	</script>
</head>
<body onload="load()">
</body>
<html>

