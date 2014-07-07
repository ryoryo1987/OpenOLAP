<%@ page language="java" contentType="text/xml;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="sqlviewer.xsl" ?>

<%@ include file="../../connect.jsp"%>


<rows>

<%
	ResultSetMetaData rsmd=null;
	String Sql ="";
	String strError ="";
	int i=0;
	int recordCount= 0;
	int colCount = 0;
	String strScript = request.getParameter("ara_script");

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




	if("".equals(strError)){
		out.println("<coldef>");
			for(i=1;i<=colCount;i++){
				out.println("<column>");
				out.println("<heading>"+rsmd.getColumnName(i)+"</heading>");
				out.println("<type>Text</type>");
				out.println("</column>");
			}
		out.println("</coldef>");

		int j=1;
		while(rs.next()&&j<=1000){
			j++;
			out.println("<row>");
			for(i=1;i<=colCount;i++){
				out.println("<value>"+ood.replace(ood.replace(ood.replace(rs.getString(i),"&","&amp;"),"<","&lt;"),">","&gt;")+"</value>");
			}
			out.println("</row>");
		}
		rs.close();


	}else{
		out.println("<error>" + strError + "</error>");
	}

%>
</rows>


