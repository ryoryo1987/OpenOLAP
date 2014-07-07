<%@ page import = "java.sql.*"%>
<%@ page import = "designer.*"%>
<% 
//Session変数をチェック　セッション切れの場合はログインページへ飛ばす
if(session.getAttribute("loginName")==null){
	String strDelete = request.getServletPath().substring(request.getServletPath().indexOf("/",0));
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

connMeta = (Connection)session.getValue("METAConnect");
stmt = (Statement)session.getValue("METAStatement");
stmt2 = (Statement)session.getValue("METAStatement2");
stmt3 = (Statement)session.getValue("METAStatement3");
stmt4 = (Statement)session.getValue("METAStatement4");
stmt5 = (Statement)session.getValue("METAStatement5");

//try{
if (connMeta==null){
	connMeta = DriverManager.getConnection(connDsn,connName,connPassword);
	stmt = connMeta.createStatement();
	stmt2 = connMeta.createStatement();
	stmt3 = connMeta.createStatement();
	stmt4 = connMeta.createStatement();
	stmt5 = connMeta.createStatement();
	session.putValue("METAConnect",connMeta);
	session.putValue("METAStatement",stmt);
	session.putValue("METAStatement2",stmt2);
	session.putValue("METAStatement3",stmt3);
	session.putValue("METAStatement4",stmt4);
	session.putValue("METAStatement5",stmt5);
}



//}catch(Exception ex){
//	out.println(ex.getMessage());
//	out.close();
//	response.sendRedirect("end.jsp");
//	connMeta=null;
//	session.putValue("Error",ex.getMessage());
//}
//	out.println(connMeta);
//	out.close();
//	response.sendRedirect("end.jsp");

ResultSet rs =null; // stmt
ResultSet rs2=null; // stmt2
ResultSet rs3=null; // stmt3
ResultSet rs4=null; // stmt4
ResultSet rs5=null; // stmt5
//ResultSet abc=null;































%>
