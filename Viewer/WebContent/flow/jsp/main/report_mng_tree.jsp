<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>
<%
	String treeXSL = "";
	String SQL = "";
	int i = 0;



	session.putValue("userId", request.getParameter("seqId"));



	treeXSL = "report_mng_tree.xsl";

	out.println("<?xml version=\"1.0\" encoding=\"Shift-JIS\"?>" + System.getProperty("line.separator"));
	out.println("<?xml:stylesheet type=\"text/xsl\" href=\"" + treeXSL + "\" ?>" + System.getProperty("line.separator"));




	String tempStr="";
	if("AdminFolderReport".equals((String)session.getValue("userId"))){//共通フォルダ・レポート管理の場合
		SQL = "SELECT report_id,level,report_name,kind_flg as kind FROM oo_report_tree('oo_v_report',null,null)";
		SQL = SQL + " WHERE kind_flg = 'F'";
	}else if(!"AdminFolderReport".equals((String)session.getValue("userId"))){//個人用フォルダ・レポート管理の場合
		SQL = "SELECT report_id,level,report_name,kind_flg as kind FROM oo_report_tree('oo_v_report',null,null," + (String)session.getValue("userId") + ",'1')";
		SQL = SQL + " WHERE kind_flg = 'F'";
		tempStr="2";
	}
	rs = stmt.executeQuery(SQL);


//	out.println(SQL);



	out.println("<BistroObjects ID='0' flg='"+tempStr+"'>レポート");

	int BeforeLevel=0;
	while(rs.next()) {


			for(int j=BeforeLevel;j>=rs.getInt("level");j--){
				out.println("</category"+tempStr+">");
			}
			out.println("<category"+tempStr+" ID='" + rs.getString("report_id") + "' KI='" + rs.getString("kind") + "'>" + rs.getString("report_name") + "");

			BeforeLevel=rs.getInt("level");

	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("</category"+tempStr+">");
	}


	out.println("</BistroObjects>");


%>
<%@ include file="../../connect_close.jsp" %>
