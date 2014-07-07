<%@ page language="java" contentType="text/xml;charset=Shift_JIS"%><?xml version="1.0" encoding="Shift_JIS"?>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	Sql =       " select";
	Sql = Sql + "  name";
	Sql = Sql + ", model_xml";
	Sql = Sql + " from oo_r_model";
	Sql = Sql + " where model_seq="+request.getParameter("modelId");
	rs = stmt.executeQuery(Sql);

	while(rs.next()){
		String XMLString=rs.getString("model_xml");
		XMLString=XMLString.substring(XMLString.indexOf("?>")+2);//最初の<?xml version="1.0"?>を取り除く（先頭に空白等が入っているため）
		out.println(XMLString);

	}
%>

<%@ include file="../../connect_close.jsp" %>

