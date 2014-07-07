<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>
<%
	String treeXSL = "";
	String SQL = "";
	int i = 0;


	String dimSeq=request.getParameter("dimSeq");
	String objSeq=request.getParameter("objSeq");




	session.putValue("dimSeq",""+dimSeq);
	session.putValue("objSeq",""+objSeq);


	treeXSL = "report_rgs_tree.xsl";





	out.println("<?xml version=\"1.0\" encoding=\"Shift-JIS\"?>" + System.getProperty("line.separator"));
	out.println("<?xml:stylesheet type=\"text/xsl\" href=\"" + treeXSL + "\" ?>" + System.getProperty("line.separator"));



	int maxLevel=0;
	SQL = "SELECT max(level_no) as maxLevel FROM oo_level WHERE dimension_seq = " + dimSeq;
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		maxLevel=rs.getInt("maxLevel");
	}
	rs.close();


//	SQL = "SELECT report_id,level,leaf_flg,code,report_name,long_name,kind_flg AS kind FROM oo_report_tree('oo_v_report',null,null)";
	SQL = "SELECT report_id,level,report_name,kind_flg as kind FROM oo_report_tree('oo_v_report',null,null)";
	SQL = SQL + " WHERE kind_flg = 'F'";

	rs = stmt.executeQuery(SQL);





	out.println("<BistroObjects ID='0' TYPE='1' PARTS='" + objSeq + "'>ƒŒƒ|[ƒg");

	int BeforeLevel=0;
	while(rs.next()) {


		for(int j=BeforeLevel;j>=rs.getInt("level");j--){
			out.println("</category>");
		}
		out.println("<category ID='" + rs.getString("report_id") + "' KI='" + rs.getString("kind") + "'>" + rs.getString("report_name") + "");
		BeforeLevel=rs.getInt("level");

	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("</category>");
	}


	out.println("</BistroObjects>");

%>
<%@ include file="../../connect_close.jsp" %>
