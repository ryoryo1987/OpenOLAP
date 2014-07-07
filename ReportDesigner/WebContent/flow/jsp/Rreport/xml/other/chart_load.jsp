<%@ page language="java" contentType="text/html;charset=Shift_JIS"%><%@ include file="../../../../connect.jsp" %><%

	String Sql = request.getParameter("hid_sql");
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		out.println(rs.getString(1)); 
	}
	rs.close();

%>
<%@ include file="../../../../connect_close.jsp" %>
