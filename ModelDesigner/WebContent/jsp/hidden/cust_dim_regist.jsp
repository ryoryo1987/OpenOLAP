<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%
Connection connMeta_Session = null;
connMeta_Session = (Connection)session.getValue(session.getId()+"Conn");
if (connMeta_Session!=null){
	connMeta_Session.commit();
}
%>
<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int tp = Integer.parseInt(request.getParameter("tp"));
int exeCount=0;

//String strName = request.getParameter("txt_name");
String strName = request.getParameter("hid_name");
String strComment = request.getParameter("txt_comment");
String strAddMemberFlg = request.getParameter("hid_add_flg");
String strDeleteMemberFlg = request.getParameter("hid_delete_flg");
String strRenameMemberFlg = request.getParameter("hid_rename_flg");


//String strUserSeq = request.getParameter("hid_user_seq");
String dimSeq = request.getParameter("hid_dim_seq");
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

String strTempTable1="";
String strTempTableP="";
%>

<%



/*
	Sql = "DELETE FROM oo_cube";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);

	Sql = "DELETE FROM oo_cube_structure";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);
*/

	if(tp==0){

		//SEQUENCE 取得
	//	Sql = "SELECT nextval('oo_s_dim_" + dimSeq + "_seq') as seq_no";
		Sql = "SELECT MAX(part_seq)+1 as seq_no FROM oo_dimension_part WHERE dimension_seq = " + dimSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();

		strTempTable1 = "oo_dim_" + dimSeq + "_1";
		strTempTableP  = "oo_dim_" + dimSeq + "_" + objSeq;



		Sql = "INSERT INTO oo_dimension_part (";
		Sql = Sql + "dimension_seq";
		Sql = Sql + ",part_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ",part_type";
		if("1".equals(session.getValue("dimType"))){
			Sql = Sql + ",add_member_flg";
			Sql = Sql + ",rename_member_flg";
			Sql = Sql + ",delete_member_flg";
		}
		Sql = Sql + ") VALUES (";
		Sql = Sql + "" + dimSeq;
		Sql = Sql + "," + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",NULL";
		if("1".equals(session.getValue("dimType"))){
			Sql = Sql + ",'" + strAddMemberFlg + "'";
			Sql = Sql + ",'" + strRenameMemberFlg + "'";
			Sql = Sql + ",'" + strDeleteMemberFlg + "'";
		}
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);



		Sql = "CREATE TABLE " + session.getValue("loginSchema") + "." + strTempTableP;
		Sql = Sql + " AS SELECT * FROM " + strTempTable1;
		exeCount = stmt.executeUpdate(Sql);






	}else if(tp==1){

		if("1".equals(session.getValue("dimType"))){
			Sql = "UPDATE oo_dimension_part SET ";
			Sql = Sql + " name = '" + strName + "'";
			Sql = Sql + ",comment = '" + strComment + "'";
			Sql = Sql + ",add_member_flg = '" + strAddMemberFlg + "'";
			Sql = Sql + ",rename_member_flg = '" + strRenameMemberFlg + "'";
			Sql = Sql + ",delete_member_flg = '" + strDeleteMemberFlg + "'";
			Sql = Sql + " WHERE dimension_seq = " + dimSeq;
			Sql = Sql + " AND part_seq = " + objSeq;
			exeCount = stmt.executeUpdate(Sql);
		}else if("2".equals(session.getValue("dimType"))){
			Sql = "UPDATE oo_dimension_part SET ";
			Sql = Sql + " name = '" + strName + "'";
			Sql = Sql + ",comment = '" + strComment + "'";
			Sql = Sql + " WHERE dimension_seq = " + dimSeq;
			Sql = Sql + " AND part_seq = " + objSeq;
			exeCount = stmt.executeUpdate(Sql);
		}

		//ディメンションメンバの更新
		Sql = "select oo_dim_level_adjust(" + dimSeq + "," + objSeq + ") as a";
		rs = stmt.executeQuery(Sql);


	}else if(tp==2){

		Sql = "DELETE FROM oo_dimension_part";
		Sql = Sql + " WHERE dimension_seq = " + dimSeq;
		Sql = Sql + " AND part_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);

		Sql = "DROP TABLE " + "oo_dim_" + dimSeq + "_" + objSeq;
		exeCount = stmt.executeUpdate(Sql);




	}




%>

<html>
<head>
	<meta http-eq	<title>OpenOLAP Model Designer</title>
	<title>OpenOLAP Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
	function load(){
		parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=dimSeq%>,<%=objSeq%>","<%=strName%>");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>