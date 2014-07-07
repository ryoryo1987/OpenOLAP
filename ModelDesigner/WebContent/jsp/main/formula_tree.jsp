<?xml version="1.0" encoding="Shift_JIS"?>
<?xml:stylesheet type="text/xsl" href="formula_tree.xsl" ?>


<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../connect.jsp" %>

<%
	String Sql="";
	int cubeSeq=Integer.parseInt(request.getParameter("cubeSeq"));
	String cubeName="";


	Sql = " SELECT name "; 
	Sql += " FROM oo_cube"; 
	Sql += " WHERE cube_seq = " + cubeSeq; 
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		cubeName=rs.getString("name");
	}
	rs.close();
	out.println("<Cube ID='" + cubeSeq + "'> "+cubeName);

		Sql = " SELECT '1' AS type,measure_seq,name FROM ("; 
		Sql += " SELECT DISTINCT m.measure_seq AS measure_seq,m.name"; 
		Sql += " FROM oo_measure m,oo_cube_structure s"; 
		Sql += " WHERE m.measure_seq=s.measure_seq"; 
		Sql += " AND s.cube_seq = " + cubeSeq;
		Sql += " ) AS a";
		Sql += " UNION";
		Sql += " SELECT '2' AS type,formula_seq AS measure_seq,name"; 
		Sql += " FROM oo_formula"; 
		Sql += " WHERE cube_seq = " + cubeSeq;
		Sql += " ORDER BY type,measure_seq"; 
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			if("1".equals(rs.getString("type"))){
				out.println("<Measure ID='" + rs.getString("measure_seq") + "' MTYPE='" + rs.getString("type") + "'>" + rs.getString("name") + "</Measure>");
			}else{
				out.println("<CustomCalcCubeCalcMeasure ID='" + rs.getString("measure_seq") + "' MTYPE='" + rs.getString("type") + "'>" + rs.getString("name") + "</CustomCalcCubeCalcMeasure>");
			}
		}
		rs.close();

	out.println("</Cube>");


%>
