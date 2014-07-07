<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "openolap.viewer.Report"%>
<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int updateCount = 0;

	
	Report report = (Report)session.getAttribute("report");
	String reportID = report.getReportID();


	SQL = " update oo_v_report";
	SQL = SQL + " set report_name = '" + request.getParameter("txt_report_name") + "'";
	if("root".equals(request.getParameter("hid_par_id"))){
		SQL = SQL + " ,par_id is null";
	}else{
		SQL = SQL + " ,par_id = '" + request.getParameter("hid_par_id") + "'";
	}
	SQL = SQL + " ,update_date = NOW()";
	SQL = SQL + " ,kind_flg = 'R'";
	SQL = SQL + " where report_id = " + reportID;
	updateCount = stmt.executeUpdate(SQL);



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("レポートを登録しました。");
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
