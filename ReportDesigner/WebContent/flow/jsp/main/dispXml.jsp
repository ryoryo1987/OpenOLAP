<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="openolap.viewer.ood"%><%@ include file="../../connect.jsp"%><%


	String report_id=request.getParameter("report_id");
	String dispXml="";


	String Sql = " select sql_xml from oo_v_report";
	Sql += " where report_id='" + report_id + "'";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		dispXml=rs.getString("sql_xml"); 
		dispXml=dispXml.substring(dispXml.indexOf("?>")+2);//�ŏ���<?xml version="1.0"?>����菜���i�擪�ɋ󔒓��������Ă��邽�߁j
	}
	rs.close();

	out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
	out.println(dispXml);


%>
<%@ include file="../../connect_close.jsp" %>


