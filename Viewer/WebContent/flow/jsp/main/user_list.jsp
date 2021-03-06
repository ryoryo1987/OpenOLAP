<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>

<%
	String SQL="";
	SQL = 		" select ";
	SQL = SQL + " user_id,name,password,adminflg,export_file_type,comment";
	SQL = SQL + " ,attribute1";
	SQL = SQL + " ,attribute2";
	SQL = SQL + " ,attribute3";
	SQL = SQL + " ,color_style_id";
	SQL = SQL + " from oo_v_user";
	SQL = SQL + " ORDER BY user_id";
	rs = stmt.executeQuery(SQL);
%>

<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
	<title><%=(String)session.getValue("aplName")%></title>

<script language="JavaScript">


function load(){

//	var XMLData = new ActiveXObject("MSXML2.DOMDocument");
	parent.XMLData.async = false;

	var strXml='<?xml version="1.0" encoding="Shift_JIS" ?>';
	strXml+='<?xml:stylesheet type="text/xsl" href="user_list.xsl" ?>';
	strXml+='<rows>';
	strXml+='	<coldef>';
	strXml+='		<column>';
	strXml+='			<heading>ID</heading>';
	strXml+='			<type>number</type>';
	strXml+='			<width>40</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>ユーザー名</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>120</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>パスワード</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>120</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>ユーザーの種類</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>120</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>エクスポート形式</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>120</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>コメント</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>200</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>　</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>100%</width>';
	strXml+='		</column>';
	strXml+='	</coldef>';

<%
	while(rs.next()) {

		String tempGroupId="";
		SQL = 		" select ";
		SQL = SQL + " user_id,group_id";
		SQL = SQL + " from oo_v_user_group";
		SQL = SQL + " where user_id = " + rs.getString("user_id");
		SQL = SQL + " ORDER BY group_id";
		rs2 = stmt2.executeQuery(SQL);
		while(rs2.next()) {
			if(!"".equals(tempGroupId)){
				tempGroupId+=",";
			}
			tempGroupId=rs2.getString("group_id");
		}
		rs2.close();


	//	out.println("strXml+='<row>'");
		out.println("strXml+='<row ID=\"" + rs.getString("user_id") + "\" GROUP=\"" + tempGroupId + "\" color_style_id=\"" + rs.getString("color_style_id") + "\">'");
		out.println("strXml+='<value>" + rs.getString("user_id") + "</value>'");
		out.println("strXml+='<value>" + rs.getString("name") + "</value>'");
		out.println("strXml+='<value>" + rs.getString("password") + "</value>'");
		out.println("strXml+='<value>" + rs.getString("adminflg") + "</value>'");
		out.println("strXml+='<value>" + rs.getString("export_file_type") + "</value>'");
		out.println("strXml+='<value>" + rs.getString("comment") + "</value>'");
		out.println("strXml+='</row>'");
	}
	rs.close();
%>

	strXml+='</rows>';

	parent.XMLData.loadXML(strXml);




	// 初期化関数
//	var objXSL = new ActiveXObject("MSXML2.DOMDocument");
	parent.objXSL.async = false;
	var xsltLoadResult = parent.objXSL.load("user_list.xsl");


	// XSLT変換
	var strResult = parent.XMLData.transformNode(parent.objXSL);
	document.write(strResult);



}


</script>

</HEAD>
<body onload="load()">
</body>
</HTML>



<%@ include file="../../connect_close.jsp" %>
