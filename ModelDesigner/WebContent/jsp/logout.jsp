<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import = "java.sql.*"%>

<%

//	if("yes".equals(request.getParameter("ok"))){

		//コネクション切断
		Connection connMeta = (Connection)session.getValue("METAConnect");
		connMeta.close();

		//sessionを無効にする
		session.invalidate();

//	}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
<script language="JavaScript" src="js/registration.js"></script>
<script language="JavaScript">
	function load(){

<%//	if("yes".equals(request.getParameter("ok"))){%>
//		document.form_main.action = "logout.jsp?ok=yes";
//		document.form_main.target = "_self";
//		document.form_main.submit();
<%//}else{%>
	//	if(showConfirm("CFM5")){
			document.form_main.action = "../login.jsp";
			document.form_main.target = "_top";
			document.form_main.submit();
	//	}
<%//}%>

	}
</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post" action=""></form>

</body>
</html>