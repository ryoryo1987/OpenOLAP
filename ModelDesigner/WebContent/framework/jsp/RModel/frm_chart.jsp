<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect.jsp" %>
<%
	session.putValue("modelSeq",(String)request.getParameter("modelSeq"));



	String strDsn="";
	String strDBuser="";
	String strDBPWD="";
	String strSchema="";
	String strModelName="";
	String Sql="";
	Sql = " SELECT dsn,db_user,db_user_pwd,schema,name FROM oo_r_model";
	Sql += " WHERE model_seq = '" + (String)request.getParameter("modelSeq") + "'";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		strDsn=rs.getString("dsn");
		strDBuser=rs.getString("db_user");
		strDBPWD=rs.getString("db_user_pwd");
		strSchema=rs.getString("schema");
		strModelName=rs.getString("name");
	}
	rs.close();


	session.putValue("RModelDsn",strDsn);
	session.putValue("RModelUserName",strDBuser);
	session.putValue("RModelUserPWD",strDBPWD);
	session.putValue("RModelSchema",strSchema);
	session.putValue("RModelName",strModelName);

	session.putValue("METAConnect_RModel",null);


	//スキーマ検索パスの設定
	String loginSchema = (String)session.getValue("loginSchema");
	strSchema=strSchema + "," + loginSchema;
	Sql = "SET search_path TO " + strSchema + "";
	int exeCount = stmt.executeUpdate(Sql);

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
</head>
<frameset rows="74,*,0" frameborder="no" framespacing="0">
		<frame src="chart_menu.jsp" name="frm_top" scrolling="no" noresize>
		<frame src="chart_main.jsp" name="frm_main1" scrolling="yes" noresize>
		<frame src="blank.jsp" name="frm_hidden" scrolling="yes" noresize>
</frameset>
<noframes></noframes>
</html>