<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="filter_tree.xsl" ?>


<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../connect.jsp" %>

<%
	String Sql="";
//	int cubeSeq=Integer.parseInt(request.getParameter("cubeSeq"));
//	String cubeName="";



	String tableName = request.getParameter("tableName");

	Sql="";
	Sql += " SELECT";
	Sql += " oo_fun_columnList('" + tableName + "','" + session.getValue("strUserName") + "') AS columnlist";
	rs = stmt.executeQuery(Sql);
	out.println("<Cube> "+tableName);
	while(rs.next()){
		StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
		while(st.hasMoreTokens()) {
			String columnText = st.nextToken();
			StringTokenizer st2 = new StringTokenizer(columnText," ");
			String columnName = st2.nextToken();
			out.println("<Measure TABLE='" + tableName + "' ID='" + columnName + "'>" + columnName + "</Measure>");
		}
	}
	rs.close();
	out.println("</Cube>");


%>
