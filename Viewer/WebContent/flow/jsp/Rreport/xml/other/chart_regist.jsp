<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ include file="../../../../connect.jsp" %>
<%

	String Sql = request.getParameter("hid_sql");
	int exeCount=0;
	exeCount = stmt.executeUpdate(Sql);

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("保存しました。");

		//	document.form_main.target="frm_main";
		//	document.form_main.action="relation.jsp";
		//	document.form_main.submit();

		}
	</script>
</head>
<body onload="load()">
	<form name="form_main" id="form_main" method="post" action="">
	</form>
<br><br>
<%=Sql%>
</body>
</html>

<%@ include file="../../../../connect_close.jsp" %>
