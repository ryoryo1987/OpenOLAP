<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.sql.*"%>
<%//@ include file="../../connect.jsp" %>
<%//@ include file="../connect.jsp" %>
<%
request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない

%>

<%
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
connMeta = (Connection)session.getValue(session.getId()+"Conn");
stmt     = (Statement) session.getValue(session.getId()+"Stmt");
stmt2     = (Statement) session.getValue(session.getId()+"Stmt2");
stmt3     = (Statement) session.getValue(session.getId()+"Stmt3");
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

		SQL = 		" update " + session.getValue("CustomTableName") + "";
		if ( parentRecord.equals("root") ) {
			SQL = SQL + " set par_key = null ";
		} else {
			SQL = SQL + " set par_key = " + parentRecord;
		}
		SQL = SQL + " where key in (" + childRecord + ")";

		updateCount = stmt3.executeUpdate(SQL);

	} else if ( strOPR.equals("delete") ) {
		// *********************************************************************
		// **** delete ****
		// *********************************************************************
		SQL = " delete from " + session.getValue("CustomTableName") + "";
		SQL = SQL + " where key in (" + request.getParameter("hid_delete_key") + ")";
		updateCount = stmt3.executeUpdate(SQL);


	} else if ( strOPR.equals("rename") ) {
		// *********************************************************************
		// **** rename ****
		// *********************************************************************

		SQL = " update " + session.getValue("CustomTableName") + "";
		SQL = SQL + " set long_name = '" + request.getParameter("long_name") + "'";
		SQL = SQL + " ,short_name = '" + request.getParameter("short_name") + "'";
		if("2".equals(session.getValue("dimType"))){
			if("1".equals(session.getValue("strSegDataType"))){
			//	if("1".equals(request.getParameter("key"))){
					SQL = SQL + " ,min_val = '" + request.getParameter("min_val") + "'";
					SQL = SQL + " ,max_val = '" + request.getParameter("max_val") + "'";
			//	}else{
			//		SQL = SQL + " ,min_val = NULL";
			//		SQL = SQL + " ,max_val = NULL";
			//	}
			}else if("2".equals(session.getValue("strSegDataType"))){
			//	if("1".equals(request.getParameter("key"))){
					SQL = SQL + " ,calc_text = '" + request.getParameter("like") + "'";
			//	}else{
			//		SQL = SQL + " ,calc_text = ''";
			//	}
			}
		}
		SQL = SQL + " where key = " + request.getParameter("key");
		updateCount = stmt3.executeUpdate(SQL);


	} else if ( strOPR.equals("add") ) {

		SQL = " insert into " + session.getValue("CustomTableName") + "(";
		SQL = SQL + " key            ";
		SQL = SQL + ",par_key        ";
//		SQL = SQL + ",col_1          ";
//		SQL = SQL + ",col_2          ";
//		SQL = SQL + ",col_3          ";
//		SQL = SQL + ",col_4          ";
//		SQL = SQL + ",col_5          ";
//		SQL = SQL + ",col_6          ";
		SQL = SQL + ",sort_col       ";
		SQL = SQL + ",code           ";
		SQL = SQL + ",short_name     ";
		SQL = SQL + ",long_name      ";
//		SQL = SQL + ",calc_text      ";
//		SQL = SQL + ",time_date      ";
		SQL = SQL + ",org_level      ";
//		SQL = SQL + ",cust_level     ";
		SQL = SQL + ",leaf_flg       ";
//		SQL = SQL + ",kind_flg       ";
		SQL = SQL + ",calc_text";
		SQL = SQL + ",min_val        ";
		SQL = SQL + ",max_val        ";
		SQL = SQL + ") values (";
		SQL = SQL + "" + request.getParameter("key");
		if("root".equals(request.getParameter("par_key"))){
			SQL = SQL + ",NULL";
		}else{
			SQL = SQL + "," + request.getParameter("par_key");
		}
//		SQL = SQL + ",col_1          ";
//		SQL = SQL + ",col_2          ";
//		SQL = SQL + ",col_3          ";
//		SQL = SQL + ",col_4          ";
//		SQL = SQL + ",col_5          ";
//		SQL = SQL + ",col_6          ";
	//	SQL = SQL + ",'V" + request.getParameter("key")+"'";
		if("1".equals(session.getValue("dimType"))){
			SQL = SQL + ",'zzzzz_" + request.getParameter("short_name") + "'";//keyではなくshort_nameでソートするように変更
		}else if("2".equals(session.getValue("dimType"))){
			SQL = SQL + ",'" + request.getParameter("short_name") + "'";//keyではなくshort_nameでソートするように変更
		}
		SQL = SQL + ",'V" + request.getParameter("key")+"'";
		SQL = SQL + ",'" + request.getParameter("short_name") + "'";
		SQL = SQL + ",'" + request.getParameter("long_name") + "'";
//		SQL = SQL + ",calc_text      ";
//		SQL = SQL + ",time_date      ";
		SQL = SQL + ",0";
//		SQL = SQL + ",cust_level     ";
		SQL = SQL + ",'0'";
//		SQL = SQL + ",kind_flg       ";
//		SQL = SQL + ",calc_text";
		if("1".equals(session.getValue("dimType"))){
			SQL = SQL + ",NULL";
			SQL = SQL + ",NULL";
			SQL = SQL + ",NULL";
		}else if("2".equals(session.getValue("dimType"))){
			if("1".equals(session.getValue("strSegDataType"))){
				SQL = SQL + ",NULL";
				SQL = SQL + "," + request.getParameter("min_val");
				SQL = SQL + "," + request.getParameter("max_val");
			}else if("2".equals(session.getValue("strSegDataType"))){
				SQL = SQL + ",'" + request.getParameter("like") + "'";
				SQL = SQL + ",NULL";
				SQL = SQL + ",NULL";
			}

		}
		SQL = SQL + ")";
		updateCount = stmt3.executeUpdate(SQL);




	}

%>

<html>	<title>OpenOLAP Model Designer</title>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="javascript">
		function load(){
			setChangeFlg();
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
