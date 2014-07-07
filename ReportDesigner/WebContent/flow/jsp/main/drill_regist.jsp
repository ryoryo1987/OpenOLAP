<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int updateCount = 0;

	String objSeq=request.getParameter("objSeq");


	SQL = " update oo_v_report";
	SQL = SQL + " set drill_xml = '" + replace(request.getParameter("hid_xml"),"'","''") + "'";
	SQL = SQL + " ,update_date = NOW()";
	SQL = SQL + " where report_id = " + objSeq;
	updateCount = stmt.executeUpdate(SQL);



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("ドリルスルー設定を登録しました。");
			parent.window.close();
		}
	</script>
</head>
<body onload="load()">
<%=SQL%>
<br><br>
updateCount:<%=updateCount%>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
