<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%
request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない

session.putValue("RModelDsn",(String)request.getParameter("lst_connect_source"));
session.putValue("RModelUserName",(String)request.getParameter("hid_user_name"));
session.putValue("RModelUserPWD",(String)request.getParameter("hid_user_pwd"));


String connDsn,connName,connPassword;
Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
Statement stmt4 = null;
Statement stmt5 = null;

DriverManager.registerDriver(new org.postgresql.Driver());

//Dsn loginName loginPassword
connDsn = (String)session.getValue("RModelDsn");
connName = (String)session.getValue("RModelUserName");
connPassword = (String)session.getValue("RModelUserPWD");



/*
out.println("<BR>connDsn:"+connDsn);
out.println("<BR>connName:"+(String)request.getParameter("hid_user_name"));
out.println("<BR>connPassword:"+(String)request.getParameter("hid_user_pwd"));
*/





connMeta = (Connection)session.getValue("METAConnect_RModel");
stmt = (Statement)session.getValue("METAStatement_RModel");
stmt2 = (Statement)session.getValue("METAStatement2_RModel");
stmt3 = (Statement)session.getValue("METAStatement3_RModel");
stmt4 = (Statement)session.getValue("METAStatement4_RModel");
stmt5 = (Statement)session.getValue("METAStatement5_RModel");



try {//コネクト
	connMeta = DriverManager.getConnection(connDsn ,connName ,connPassword);
} catch(SQLException ex){//コネクト失敗
	response.sendRedirect( "login_error.jsp?errMsg=" + ex.toString() + "&errNum=0");
	return;
}


stmt = connMeta.createStatement();
stmt2 = connMeta.createStatement();
stmt3 = connMeta.createStatement();
stmt4 = connMeta.createStatement();
stmt5 = connMeta.createStatement();
session.putValue("METAConnect_RModel",connMeta);
session.putValue("METAStatement_RModel",stmt);
session.putValue("METAStatement2_RModel",stmt2);
session.putValue("METAStatement3_RModel",stmt3);
session.putValue("METAStatement4_RModel",stmt4);
session.putValue("METAStatement5_RModel",stmt5);

ResultSet rs =null; // stmt
ResultSet rs2=null; // stmt2
ResultSet rs3=null; // stmt3
ResultSet rs4=null; // stmt4
ResultSet rs5=null; // stmt5








String Sql="";
String strOutput="";



out.println("<script language='JavaScript'>");
out.println("var tempStr='';");
out.println("tempStr+='<select name=\"lst_schema\" mON=\"スキーマ\" onchange=\"changeSchema(this)\">';");
out.println("tempStr+='<option value=\"\">--スキーマを選択--</option>';");

					
						

	Sql = "select nspname from pg_namespace order by nspname";
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		String tempStr="";
		if(rs.getString("nspname").equals((String)session.getValue("schema"))){tempStr="selected";}
		out.println("tempStr+='<option value=\"" + rs.getString("nspname") + "\"" + tempStr + ">" + rs.getString("nspname") + "</option>';");
	}
	rs.close();

out.println("tempStr+='</select>';");
out.println("//alert(tempStr);");
out.println("parent.frm_main.document.all.td_schema.innerHTML=tempStr;");
out.println("</script>");


/*
	strOutput="";
		Sql = "select distinct table_name as table_name from oo_dimension d,oo_level l where d.dimension_seq=l.dimension_seq and d.dimension_seq in (" + (String)session.getValue("ref_dimensions") + ")";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			if(!"".equals(strOutput)){strOutput+=",";}
			strOutput+=rs.getString("table_name");
		}
		rs.close();





	out.println("<script>");
	out.println("parent.frm_main.document.all.span_tables.innerHTML='" + strOutput + "';");
	out.println("</script>");
*/
%>
