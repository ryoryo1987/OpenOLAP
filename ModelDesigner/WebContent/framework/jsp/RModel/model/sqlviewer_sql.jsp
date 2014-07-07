<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ page import="designer.PostgreSqlGenerator" %>

<%@ include file="../../../../connect.jsp"%>
<%
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
//	String strScript = request.getParameter("ara_script");
//	String strScript = "select * from product";


	PostgreSqlGenerator sqlGene = new PostgreSqlGenerator();
	String strScript = "";
	if(request.getParameter("hid_xml")!=null){

		String sqlLevel = request.getParameter("sqlLevel");
		if(sqlLevel.equals("AllTables")){
			strScript = sqlGene.getSQL(request.getParameter("hid_xml"));
		}else if(sqlLevel.equals("Table")){
			strScript = sqlGene.getTableSQL(request.getParameter("hid_xml"));
		}

	}
/*
	Sql = "SELECT COUNT(*) AS cnt FROM (" + strScript + ") AS SQL";
	try{
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			recordCount=rs.getInt("cnt");
		}
		rs.close();
	}catch(SQLException e){
		strError=e.toString()+"";
	}

	try{
		rs = stmt.executeQuery(strScript);
		rsmd = rs.getMetaData();
		colCount=rsmd.getColumnCount();
	}catch(SQLException e){
		strError=e.toString()+"";
	}
*/




%>


<html>
<head>
<title></title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../../jsp/css/common.css">
<script language="JavaScript">
//	parent.document.all.div_msg.innerHTML="<%=recordCount%>";
</script>
</head>
<body>
<pre style="font-size:12px">
<%=strScript%>
</pre>
</body>
</html>


