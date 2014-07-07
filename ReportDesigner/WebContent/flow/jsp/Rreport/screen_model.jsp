<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>
<%
	String Sql;
	Sql =       " select";
	Sql = Sql + " model_seq";
	Sql = Sql + ", name";
	Sql = Sql + ", schema";
	Sql = Sql + ", model_flg";
	Sql = Sql + " from oo_r_model";
	Sql = Sql + " order by model_seq";
	rs = stmt.executeQuery(Sql);
%>
<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="screen_model.xsl" ?>

<models>画面一覧

<%
	while(rs.next()){
		out.println("<model id='"+rs.getString("model_seq")+"' name='"+rs.getString("name")+"'></model>");
		
	}
%>
</models>


<%@ include file="../../connect_close.jsp" %>
