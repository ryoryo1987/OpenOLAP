<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="openolap.viewer.User"%> 

<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int exeCount = 0;

	String userID = request.getParameter("hid_user_id");
	String lstExportFile = request.getParameter("lst_export_file");
	String lstMColor = request.getParameter("lst_m_color");


	SQL = " update oo_v_user ";
	SQL = SQL + " set";
	SQL = SQL + " export_file_type = '" + lstExportFile + "'";
	SQL = SQL + " ,color_style_id = '" + lstMColor + "'";
	SQL = SQL + " where";
	SQL = SQL + " user_id = " + userID;
	exeCount = stmt.executeUpdate(SQL);

	String name = "";
	String spreadstyleFile = "";
	String cellcolortableFile = "";
	SQL = "SELECT id,name,spreadstyle_file,cellcolortable_file FROM oo_v_color_style where id = '" + lstMColor + "'";
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		name = rs.getString("name");
		spreadstyleFile = rs.getString("spreadstyle_file");
		cellcolortableFile = rs.getString("cellcolortable_file");
	}
	rs.close();


	User user = (User)session.getAttribute("user");
	user.setExportFileType(lstExportFile);
	user.setColorStyleName(name);
	user.setSpreadStyleFile(spreadstyleFile);
	user.setCellColorTableFile(cellcolortableFile);






%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("ìoò^ÇµÇ‹ÇµÇΩÅB");
			top.frames[1].document.navi_form.change_flg.value = 0;
		}
	</script>
</head>
<body onload="load()">
<br><br>
<%//=SQL%>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
