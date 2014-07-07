<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>
<%
	String treeXSL = "";
	String SQL = "";
	String strCurrentTable = "";
	int i = 0;


	String dimSeq=request.getParameter("dimSeq");
	String objSeq=request.getParameter("objSeq");



	session.putValue("CustomTableName", "oo_dim_" + dimSeq +"_"+ objSeq);
	session.putValue("CustomTableSequence", "oo_s_dim_" + dimSeq +"_seq");
	session.putValue("dimSeq",""+dimSeq);
	session.putValue("objSeq",""+objSeq);

	strCurrentTable = (String)session.getValue("CustomTableName");

	treeXSL = "cust_dim_tree.xsl";





	out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>" + System.getProperty("line.separator"));
	out.println("<?xml:stylesheet type=\"text/xsl\" href=\"" + treeXSL + "\" ?>" + System.getProperty("line.separator"));



	int maxLevel=0;
	SQL = "SELECT max(level_no) as maxLevel FROM oo_level WHERE dimension_seq = " + dimSeq;
	rs = stmt.executeQuery(SQL);
	if(rs.next()) {
		maxLevel=rs.getInt("maxLevel");
	}
	rs.close();


	SQL = "SELECT replace(replace(replace(key,'&','&amp;'),'<','&lt;'),'>','&gt;') AS key,level,leaf_flg,replace(replace(replace(code,'&','&amp;'),'<','&lt;'),'>','&gt;') AS code,replace(replace(replace(short_name,'&','&amp;'),'<','&lt;'),'>','&gt;') AS short_name,replace(replace(replace(long_name,'&','&amp;'),'<','&lt;'),'>','&gt;') AS long_name,CASE WHEN org_level = " + maxLevel + " THEN 'F' WHEN org_level = 0 THEN 'V' ELSE 'D' END AS kind FROM oo_dim_tree('oo_dim_" + dimSeq +"_" + objSeq + "',null,null)";
	SQL = SQL + " WHERE org_level <> " + maxLevel;
	rs = stmt.executeQuery(SQL);


//	out.println("<pre>");



	// 階層の種別
	if("1".equals(session.getValue("dimType"))){
		out.println("<BistroObjects ID='0' TYPE='1' PARTS='" + objSeq + "'>ディメンション");
	}else if("2".equals(session.getValue("dimType"))){
		out.println("<BistroObjects ID='0' TYPE='2' PARTS='" + objSeq + "'>セグメントディメンション");
	}

	int BeforeLevel=0;
	while(rs.next()) {

		if(!(("2".equals(session.getValue("dimType")))&&(!("V".equals(rs.getString("kind")))))){

			//if(rs.getInt("level")<=BeforeLevel){
			for(int j=BeforeLevel;j>=rs.getInt("level");j--){
			//	out.println("<category>" + rs.getString("short_name") + "</category>");
				out.println("</category>");
			}
		//	if(rs.getInt("level")!=maxLevel){
	//			out.println("<category ID='" + rs.getString("key") + "' KI='" + rs.getString("kind") + "'>" + rs.getString("level") + ":" + rs.getString("short_name") + "");
				out.println("<category ID='" + rs.getString("key") + "' KI='" + rs.getString("kind") + "'>" + rs.getString("short_name") + "");
		//	}

			BeforeLevel=rs.getInt("level");

		}
	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("</category>");
	}

//	out.println("</pre>");

	out.println("</BistroObjects>");

/*
	SQL = 		" select ";
	SQL = SQL + " to_char(nvl(h1.key,-1))  h1 , nvl(replace(replace(replace(h1 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n1 ,";
	SQL = SQL + " to_char(nvl(h2.key,-1))  h2 , nvl(replace(replace(replace(h2 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n2 ,";
	SQL = SQL + " to_char(nvl(h3.key,-1))  h3 , nvl(replace(replace(replace(h3 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n3 ,";
	SQL = SQL + " to_char(nvl(h4.key,-1))  h4 , nvl(replace(replace(replace(h4 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n4 ,";
	SQL = SQL + " to_char(nvl(h5.key,-1))  h5 , nvl(replace(replace(replace(h5 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n5 ,";
	SQL = SQL + " to_char(nvl(h6.key,-1))  h6 , nvl(replace(replace(replace(h6 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n6 ,";
	SQL = SQL + " to_char(nvl(h7.key,-1))  h7 , nvl(replace(replace(replace(h7 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n7 ,";
	SQL = SQL + " to_char(nvl(h8.key,-1))  h8 , nvl(replace(replace(replace(h8 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n8 ,";
	SQL = SQL + " to_char(nvl(h9.key,-1))  h9 , nvl(replace(replace(replace(h9 .att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n9 ,";
	SQL = SQL + " to_char(nvl(h10.key,-1)) h10, nvl(replace(replace(replace(h10.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n10,";
	SQL = SQL + " to_char(nvl(h11.key,-1)) h11, nvl(replace(replace(replace(h11.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n11,";
	SQL = SQL + " to_char(nvl(h12.key,-1)) h12, nvl(replace(replace(replace(h12.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n12,";
	SQL = SQL + " to_char(nvl(h13.key,-1)) h13, nvl(replace(replace(replace(h13.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n13,";
	SQL = SQL + " to_char(nvl(h14.key,-1)) h14, nvl(replace(replace(replace(h14.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n14,";
	SQL = SQL + " to_char(nvl(h15.key,-1)) h15, nvl(replace(replace(replace(h15.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n15,";
	SQL = SQL + " to_char(nvl(h16.key,-1)) h16, nvl(replace(replace(replace(h16.att_2,'<','&lt;'),'>','&gt;'),'&','&amp;'),0) n16,";
*/

%>
