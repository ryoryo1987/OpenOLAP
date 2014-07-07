<%@ page import = "java.sql.*"%>
<%@ page import = "designer.*"%>
<% 

//Session変数をチェック　セッション切れの場合はログインページへ飛ばす
if(session.getAttribute("loginName")==null){
	String strDelete = request.getServletPath().substring(request.getServletPath().indexOf("/",1));
	String strFullUrl = ""+request.getRequestURL();
	String strLoginUrl=ood.replace(strFullUrl,strDelete,"/login.jsp");
	out.println("<script language='JavaScript'>");
	out.println("window.top.location.href='" + strLoginUrl + "';");
	out.println("</script>");
}

request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない


String connDsn,connName,connPassword;
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
Statement stmt4 = null;
Statement stmt5 = null;

//Select Driver
//Class.forName("oracle.jdbc.driver.OracleDriver");
DriverManager.registerDriver(new org.postgresql.Driver());

//Dsn loginName loginPassword
connDsn = "" + session.getValue("loginDsn");
connName = session.getValue("loginName") + "";
connPassword = session.getValue("loginPassword") + "";

//	out.println(connDsn+connName+connPassword);
//	out.close();
//	response.sendRedirect("end.jsp");

//Connect

connMeta = (Connection)session.getValue("METAConnect_Session");
stmt = (Statement)session.getValue("METAStatement_Session");
stmt2 = (Statement)session.getValue("METAStatement2_Session");
stmt3 = (Statement)session.getValue("METAStatement3_Session");
stmt4 = (Statement)session.getValue("METAStatement4_Session");
stmt5 = (Statement)session.getValue("METAStatement5_Session");

//try{
if (connMeta==null){
	connMeta = DriverManager.getConnection(connDsn,connName,connPassword);
connMeta.setAutoCommit(false);
connMeta.rollback();
	stmt = connMeta.createStatement();
	stmt2 = connMeta.createStatement();
	stmt3 = connMeta.createStatement();
	stmt4 = connMeta.createStatement();
	stmt5 = connMeta.createStatement();
	session.putValue("METAConnect_Session",connMeta);
	session.putValue("METAStatement_Session",stmt);
	session.putValue("METAStatement2_Session",stmt2);
	session.putValue("METAStatement3_Session",stmt3);
	session.putValue("METAStatement4_Session",stmt4);
	session.putValue("METAStatement5_Session",stmt5);
}




//rollback
connMeta.rollback();
ResultSet rs =null; // stmt
ResultSet rs2=null; // stmt2
ResultSet rs3=null; // stmt3
ResultSet rs4=null; // stmt4
ResultSet rs5=null; // stmt5
//ResultSet abc=null;


String Sql2 = "SET search_path TO " + session.getValue("loginSchema") + "";
int exeCount = stmt.executeUpdate(Sql2);


























%>