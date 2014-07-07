<%@ page language="java" contentType="text/html;charset=Shift_JIS"%><%@ include file="../../connect.jsp"%><%
	String SQL = "";
	int updateCount = 0;
	String reportId=(String)request.getParameter("rId");

	SQL = " delete from oo_v_report ";
	SQL = SQL + " where report_id="+reportId;
//out.println(SQL);
	updateCount = stmt.executeUpdate(SQL);
%><?xml version="1.0" encoding="Shift_JIS"?>
<result result="削除しました。">
</result>
<%@ include file="../../connect_close.jsp" %>
