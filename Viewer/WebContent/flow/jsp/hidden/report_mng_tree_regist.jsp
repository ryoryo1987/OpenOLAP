<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="openolap.viewer.User"%> 
<%//@ include file="../../connect.jsp" %>
<%@ include file="../../connect.jsp" %>
<%
//request.setCharacterEncoding("Shift_JIS");
%>

<%
/*
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
connMeta = (Connection)session.getValue(session.getId()+"Conn");
stmt     = (Statement) session.getValue(session.getId()+"Stmt");
stmt2     = (Statement) session.getValue(session.getId()+"Stmt2");
stmt     = (Statement) session.getValue(session.getId()+"stmt");
*/
%>
<%
	String SQL = "";

	String parentRecord = "";
	String childRecord = "";
	int updateCount = 0;


	//処理種別
	String strOPR = request.getParameter("opr");


	if ( strOPR.equals("update") ) {

		// *********************************************************************
		// **** update ****
		// *********************************************************************
		if (request.getParameter("parent_record") == null) {
			return;
		}
		if (request.getParameter("child_record") == null) {
			return;
		}
		parentRecord = request.getParameter("parent_record");
		childRecord =  request.getParameter("child_record");
		if ( parentRecord.equals("") || childRecord.equals("") ) {
			return;
		}

		SQL = 		" update oo_v_report";
		if ( parentRecord.equals("root") ) {
			SQL = SQL + " set par_id = null ";
		} else {
			SQL = SQL + " set par_id = " + parentRecord;
		}
		SQL = SQL + " ,update_date = NOW()";
		SQL = SQL + " where report_id in (" + childRecord + ")";

		updateCount = stmt.executeUpdate(SQL);

	} else if ( strOPR.equals("delete") ) {
		// *********************************************************************
		// **** delete ****
		// *********************************************************************
		SQL = " delete from oo_v_report";
		SQL = SQL + " where report_id in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt.executeUpdate(SQL);

		SQL = " delete from oo_v_axis";
		SQL = SQL + " where report_id in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt.executeUpdate(SQL);

		SQL = " delete from oo_v_axis_member";
		SQL = SQL + " where report_id in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt.executeUpdate(SQL);

		SQL = " delete from oo_v_color";
		SQL = SQL + " where report_id in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt.executeUpdate(SQL);

		SQL = " delete from oo_v_measure_member_type";
		SQL = SQL + " where report_id in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt.executeUpdate(SQL);

	} else if ( strOPR.equals("rename") ) {
		// *********************************************************************
		// **** rename ****
		// *********************************************************************

		SQL = " update oo_v_report";
		SQL = SQL + " set report_name = '" + request.getParameter("txt_report_name") + "'";
		SQL = SQL + " ,update_date = NOW()";
		SQL = SQL + " where report_id = " + request.getParameter("key");
		updateCount = stmt.executeUpdate(SQL);



	} else if ( strOPR.equals("add") ) {
		User user = (User)session.getAttribute("user");
		boolean isAdmin = user.isAdmin();
		String userSeq = user.getUserID();

		SQL = " insert into oo_v_report (";
		SQL = SQL + " report_id            ";
		SQL = SQL + ",par_id        ";
		SQL = SQL + ",user_id        ";
		SQL = SQL + ",report_name";
		SQL = SQL + ",cube_seq";
		SQL = SQL + ",kind_flg";
		SQL = SQL + ",update_date";
		SQL = SQL + ",report_owner_flg";
		SQL = SQL + ") values (";
		SQL = SQL + "" + request.getParameter("key");
		if("root".equals(request.getParameter("par_key"))){
			SQL = SQL + ",NULL";
		}else{
			SQL = SQL + "," + request.getParameter("par_key");
		}
		if(isAdmin){
			SQL = SQL + ",'0'";
		}else{
			SQL = SQL + ",'" + userSeq + "'";
		}
		SQL = SQL + ",'" + request.getParameter("txt_report_name") + "'";
		SQL = SQL + ",0";
		SQL = SQL + ",'F'";
		SQL = SQL + ",NOW()";
		if(isAdmin){
			SQL = SQL + ",'1'";
		}else{
			SQL = SQL + ",'2'";
		}
		SQL = SQL + ")";
		updateCount = stmt.executeUpdate(SQL);




	}

%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="javascript">
		function load(){
		//	setChangeFlg();//アクションごとにDBに反映されるので破棄メッセージは要らない

<%
		String tempParId="";
		if("root".equals(request.getParameter("parent_record"))){
			tempParId="NULL";
		}else{
			tempParId=request.getParameter("parent_record");
		}
%>

<%		if(!"yes".equals(request.getParameter("dragflg"))){%>

		//--右画面連携更新
			document.update_form.target="right_frm"
		//階層カスタマイズ種別対応
			document.update_form.action="../main/report_mng_tree_table.jsp?id=<%=tempParId%>";
			document.update_form.submit();
		//--右画面連携更新
<%}%>

			location.replace("blank.jsp");

		}
	</script>
</head>
<body onload="load()">
<form id="update_form" method="post" name="update_form" target="right"> 
<input type="hidden" name = "preClick"/>
<%=SQL + "<BR>"%>
<%=strOPR + "<BR>"%>
<%=updateCount + "<BR>"%>
</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
