<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int updateCount = 0;

	
	String reportID = "";

	SQL = "SELECT NEXTVAL('report_id') AS new_seq";
	rs = stmt.executeQuery(SQL);
	if (rs.next()) {
		reportID=rs.getString("new_seq");
	}
	rs.close();



	SQL = " insert into oo_v_report (report_id,report_name,par_id,user_id,report_owner_flg,update_date,kind_flg,report_type,screen_xml) values (";
	SQL = SQL + reportID;
	SQL = SQL + ",'" + request.getParameter("txt_report_name") + "'";
	if("root".equals(request.getParameter("hid_par_id"))){
		SQL = SQL + ",null";
	}else{
		SQL = SQL + " ," + request.getParameter("hid_par_id") + "";
	}
	SQL = SQL + " ,'0'";	// 共通レポートの場合は0（個人レポートの場合は個人のuser_id）
//	SQL = SQL + ",'" + Report.personalReportOwnerFLG + "' ";	// 「２」：個人レポート
	SQL = SQL + " ,'1'";	// 「1」：共通レポート
	SQL = SQL + " ,NOW()";
	SQL = SQL + " ,'R'";
	SQL = SQL + " ,'P'";
	SQL = SQL + " ,'" + replace(request.getParameter("hid_xml"),"'","\"") + "'";
	SQL = SQL + ")";
	updateCount = stmt.executeUpdate(SQL);


%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("<%=request.getParameter("txt_report_name")%>を登録しました。");
			top.frames[1].document.navi_form.change_flg.value = 0;

			document.form_main.action = "../../../OpenOLAP.jsp";
			document.form_main.target = "_top";
			document.form_main.submit();
		}
	</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post">

<%=SQL%>
<br><br>
updateCount:<%=updateCount%>

</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
