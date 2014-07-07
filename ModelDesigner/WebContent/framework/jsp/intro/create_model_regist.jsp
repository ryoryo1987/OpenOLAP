<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%//@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../../connect.jsp" %>

<%

String Sql="";
int objSeq=0;
int exeCount=0;
int tp=Integer.parseInt(request.getParameter("tp"));



	if (tp == 0) {
		//SEQUENCE 取得
		Sql = "SELECT nextval('model_seq') as seq_no";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			objSeq = rs.getInt("seq_no");
		}
		rs.close();

		session.putValue("modelSeq",objSeq+"");



		String strXML = "";
		if("1".equals(session.getValue("model_type"))){//モデルコピーの場合
			strXML = "(select model_xml from oo_r_model where model_seq=" + session.getValue("ref_model") + ")";
		}else{
			strXML+="'";
			strXML+="<initialInfo>";
			strXML+="<modelType>" + session.getValue("model_type") + "</modelType>";
			strXML+="<refModel>" + session.getValue("ref_model") + "</refModel>";
			strXML+="<refMeasures>" + session.getValue("ref_measures") + "</refMeasures>";
			strXML+="<refDimensions>" + session.getValue("ref_dimensions") + "</refDimensions>";
		//	strXML+="<refTables>" + session.getValue("ref_tables") + "</refTables>";
			strXML+="</initialInfo>";
			strXML+="'";
		}


		//新規登録
		Sql = "INSERT INTO oo_r_model (";
		Sql = Sql + "model_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",dsn";
		Sql = Sql + ",db_user";
		Sql = Sql + ",db_user_pwd";
		Sql = Sql + ",schema";
		Sql = Sql + ",model_flg";
		Sql = Sql + ",model_xml";
		Sql = Sql + ",last_update";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + session.getValue("name") + "'";
		Sql = Sql + ",'" + session.getValue("RModelDsn") + "'";
		Sql = Sql + ",'" + session.getValue("RModelUserName") + "'";
		Sql = Sql + ",'" + session.getValue("RModelUserPWD") + "'";
		Sql = Sql + ",'" + session.getValue("schema") + "'";
		if("1".equals(session.getValue("model_type"))){//モデルコピーの場合
			Sql = Sql + ",(select model_flg from oo_r_model where model_seq=" + session.getValue("ref_model") + ")";
		}else{
			Sql = Sql + ",'0'";
		}
		Sql = Sql + "," + strXML;
		Sql = Sql + ",NOW()";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);



	} else if (tp == 1) {
		objSeq=Integer.parseInt(request.getParameter("modelSeq"));
		Sql = "UPDATE oo_r_model SET name = '" + request.getParameter("modelName") + "'";
		Sql = Sql + " WHERE model_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);


	} else if (tp == 2) {

		objSeq=Integer.parseInt(request.getParameter("modelSeq"));

		//キューブがある場合は削除できない
		Sql = "SELECT * FROM oo_v_report";
		Sql = Sql + " WHERE model_seq = '" + objSeq + "'";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
		}else{
			Sql = "DELETE FROM oo_r_model";
			Sql = Sql + " WHERE model_seq = " + objSeq;
			exeCount = stmt.executeUpdate(Sql);
		}
		rs.close();




	}

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
<%
	if (tp == 0) {
	//	out.println("parent.opener.location.reload()");
		out.println("window.dialogArguments.location.reload()");

		out.println("parent.window.close();");
	} else if (tp == 2) {
		if(exeCount==0){
			out.println("alert('このモデルはレポートとして使用されている為、削除できません。')");
		}else{
			session.putValue("modelSeq",null);
			out.println("alert('削除しました。')");
			out.println("parent.frm_main.location.reload()");
		}
	}
%>
	}
	</script>
</head>
<body onload="load()">
<%=Sql%>
</body>
</html>