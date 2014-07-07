<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int objSeq=Integer.parseInt(request.getParameter("hid_obj_seq"));
String objKind=request.getParameter("hid_obj_kind");
int exeCount=0;
String strName=(String)request.getParameter("txt_name");
String strComment=(String)request.getParameter("txt_comment");
String strDns=(String)session.getValue("loginDsn");
int tp=Integer.parseInt(request.getParameter("tp"));

	String chkTableFlg = "0";
	String chkViewFlg = "0";
	if (request.getParameter("chk_tbl") != null) chkTableFlg = "1";
	if (request.getParameter("chk_view") != null) chkViewFlg = "1";

/*
	if (tp!=2) {
		//スキーマの存在を確認
		Sql = "SELECT * FROM pg_namespace";
		Sql = Sql + " WHERE nspname = '" + strName + "'";
		rs = stmt.executeQuery(Sql);
		if(!rs.next()){
		%>
		<script language="JavaScript" src="../js/registration.js"></script>
		<script language="JavaScript">
			showMsg("USR2","<%=strName%>");
		</script>
		<%
		return;
		}
		rs.close();
	}
*/

	if (tp == 0) {
		//SEQUENCE 取得
		Sql = "SELECT nextval('oo_user_seq') as seq_no";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			objSeq = rs.getInt("seq_no");
		}
		rs.close();

		//新規登録
		Sql = "INSERT INTO oo_user (";
		Sql = Sql + "user_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ",table_flg";
		Sql = Sql + ",view_flg";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",'" + chkTableFlg + "'";
		Sql = Sql + ",'" + chkViewFlg + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);


	} else if (tp == 1) {
		Sql = "UPDATE oo_user SET user_seq = " + objSeq + ",";
		Sql = Sql + "name = '" + strName + "',";
		Sql = Sql + "comment = '" + strComment + "',";
		Sql = Sql + "table_flg = '" + chkTableFlg + "',";
		Sql = Sql + "view_flg = '" + chkViewFlg + "'";
		Sql = Sql + " WHERE user_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);


	} else if (tp == 2) {
		Sql = "DELETE FROM oo_user";
		Sql = Sql + " WHERE user_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);

	}
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
		parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=objSeq%>","<%=strName%>");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>