<%@ page import = "java.sql.*"%>
<%@ page import = "designer.*"%>
<% 


//Session変数をチェック　セッション切れの場合はログインページへ飛ばす
if(session.getAttribute("loginName")==null){
	String strDelete = request.getServletPath().substring(request.getServletPath().indexOf("/",1));
	String strFullUrl = ""+request.getRequestURL();
	String strLoginUrl=ood.replace(strFullUrl,strDelete,"/timeout.jsp");

	response.sendRedirect(strLoginUrl);
	return;

//	out.println("<script language='JavaScript'>");
//	out.println("window.top.location.href='" + strLoginUrl + "';");
//	out.println("</script>");
}

request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない


String connDsnRModel,connNameRModel,connPasswordRModel;
Connection connMetaRModel = null;
Statement stmtRModel = null;
Statement stmtRModel2 = null;
Statement stmtRModel3 = null;
Statement stmtRModel4 = null;
Statement stmtRModel5 = null;

//Select Driver
//Class.forName("oracle.jdbc.driver.OracleDriver");
DriverManager.registerDriver(new org.postgresql.Driver());

//Dsn loginName loginPassword
connDsnRModel = "" + session.getValue("RModelDsn");
connNameRModel = session.getValue("RModelUserName") + "";
connPasswordRModel = session.getValue("RModelUserPWD") + "";

//	out.println(connDsn+connName+connPassword);
//	out.close();
//	response.sendRedirect("end.jsp");

//Connect


connMetaRModel = (Connection)session.getValue("METAConnect_RModel");
stmtRModel = (Statement)session.getValue("METAStatement_RModel");
stmtRModel2 = (Statement)session.getValue("METAStatement2_RModel");
stmtRModel3 = (Statement)session.getValue("METAStatement3_RModel");
stmtRModel4 = (Statement)session.getValue("METAStatement4_RModel");
stmtRModel5 = (Statement)session.getValue("METAStatement5_RModel");


//try{
if (connMetaRModel==null){
	connMetaRModel = DriverManager.getConnection(connDsnRModel,connNameRModel,connPasswordRModel);
//	connMeta.setAutoCommit(false);
//	connMeta.rollback();
	stmtRModel = connMetaRModel.createStatement();
	stmtRModel2 = connMetaRModel.createStatement();
	stmtRModel3 = connMetaRModel.createStatement();
	stmtRModel4 = connMetaRModel.createStatement();
	stmtRModel5 = connMetaRModel.createStatement();
	session.putValue("METAConnect_RModel",connMetaRModel);
	session.putValue("METAStatement_RModel",stmtRModel);
	session.putValue("METAStatement2_RModel",stmtRModel2);
	session.putValue("METAStatement3_RModel",stmtRModel3);
	session.putValue("METAStatement4_RModel",stmtRModel4);
	session.putValue("METAStatement5_RModel",stmtRModel5);
}





//rollback
//connMeta.rollback();
ResultSet rsRModel =null; // stmt
ResultSet rsRModel2=null; // stmt2
ResultSet rsRModel3=null; // stmt3
ResultSet rsRModel4=null; // stmt4
ResultSet rsRModel5=null; // stmt5
//ResultSet abc=null;



String Sql2RModel = "SET search_path TO " + session.getValue("RModelSchema") + "";
int exeCount = stmtRModel.executeUpdate(Sql2RModel);























%>