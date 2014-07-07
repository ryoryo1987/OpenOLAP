<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%

String Sql="";
int exeCount=0;
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");
String stepNo = request.getParameter("hid_step_no");
String strScript = request.getParameter("textfield2");
String customFlg = request.getParameter("tp");

strScript = ood.replace(strScript,"'","''");//'シングルコーテーションをエスケープ処理


//'いったんレコードを削除
Sql="DELETE FROM oo_custom_sql ";
Sql=Sql+" WHERE cube_seq=" + objSeq;
Sql=Sql+" AND step=" + stepNo;
exeCount = stmt.executeUpdate(Sql);

%>

<%
	if(customFlg.equals("1")){
		Sql="INSERT INTO oo_custom_sql (";
		Sql=Sql+" cube_seq";
		Sql=Sql+" ,step";
		Sql=Sql+" ,script";
		Sql=Sql+") VALUES (";
		Sql=Sql+"" + objSeq;
		Sql=Sql+"," + stepNo;
		Sql=Sql+",'" + strScript + "'";
		Sql=Sql+")";
		exeCount = stmt.executeUpdate(Sql);
	}

%>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">
	function load(){
		top.frames[1].document.navi_form.change_flg.value = 0;
		showMsg("TNG1");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>