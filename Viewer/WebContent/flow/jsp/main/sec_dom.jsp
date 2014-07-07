<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ include file="../../connect.jsp" %>

<%

	int groupId = Integer.parseInt(request.getParameter("groupId"));


	String SQL="";
//	SQL = "SELECT report_id,level,report_name,kind_flg as kind,update_date FROM oo_report_tree('oo_v_report',null,null,'2','0')";
	SQL = "SELECT report_id,level,report_name,kind_flg as kind,report_type,update_date FROM oo_report_tree('oo_v_report',null,null)";
//	SQL = SQL + " where report_owner_flg<>'2'"
//	SQL = SQL + " ORDER BY report_name";
	rs = stmt.executeQuery(SQL);
%>

<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
<script language="JavaScript">

	var XMLTreeDom = new ActiveXObject("MSXML2.DOMDocument");
	XMLTreeDom.async = false;
	var strXml='<?xml version="1.0" encoding="Shift_JIS" ?>';
	strXml+='<?xml:stylesheet type="text/xsl" href="sec_tree.xsl" ?>';
<%
	out.println("strXml+='<BistroObjects ID=\"0\" TYPE=\"1\" PARTS=\"\">レポート';");
	int BeforeLevel=0;
	while(rs.next()) {

		String rightFlg="1";
	//	String saveFlg="1";
		String exportFlg="1";
		SQL = 		" select ";
		SQL = SQL + " group_id";
		SQL = SQL + " ,report_id";
		SQL = SQL + " ,right_flg";
	//	SQL = SQL + " ,save_flg";
		SQL = SQL + " ,export_flg";
		SQL = SQL + " from oo_v_group_report";
		SQL = SQL + " where group_id = " + groupId;
		SQL = SQL + " and report_id = " + rs.getString("report_id");
		rs2 = stmt2.executeQuery(SQL);
		if(rs2.next()) {
			rightFlg=rs2.getString("right_flg");
		//	saveFlg=rs2.getString("save_flg");
			exportFlg=rs2.getString("export_flg");
		}
		rs2.close();

		if("F".equals(rs.getString("kind"))){
		//	saveFlg="-";
			exportFlg="-";
		}



		for(int j=BeforeLevel;j>=rs.getInt("level");j--){
			out.println("strXml+='</category>';");
		}
	//	out.println("strXml+='<category ID=\"" + rs.getString("report_id") + "\" KI=\"" + rs.getString("kind") + "\" RIGHT=\"" + rightFlg + "\" SAVE=\"" + saveFlg + "\" EXPORT=\"" + exportFlg + "\" UPDATE=\"" + rs.getString("update_date") + "\" disp=\"none\">" + rs.getString("report_name") +"';");
		out.println("strXml+='<category ID=\"" + rs.getString("report_id") + "\" KI=\"" + rs.getString("kind") + "\" RTYPE=\"" + rs.getString("report_type") + "\" RIGHT=\"" + rightFlg + "\" EXPORT=\"" + exportFlg + "\" UPDATE=\"" + rs.getString("update_date") + "\" disp=\"none\">" + rs.getString("report_name") +"';");
		BeforeLevel=rs.getInt("level");

	}
	rs.close();

	for(int j=BeforeLevel;j>0;j--){
		out.println("strXml+='</category>';");
	}

	out.println("strXml+='</BistroObjects>';");
%>
	XMLTreeDom.loadXML(strXml);
//	alert(XMLTreeDom.xml);

	var XSLTreeDom = new ActiveXObject("MSXML2.DOMDocument");
	XSLTreeDom.async = false;
	XSLTreeDom.load("sec_tree.xsl");


	//右リスト用
	var XMLTreeList = new ActiveXObject("MSXML2.DOMDocument");
	XMLTreeList.async = false;
	var XSLTreeList = new ActiveXObject("MSXML2.DOMDocument");
	XSLTreeList.async = false;
	XSLTreeList.load("sec_list.xsl");


function load(){

	// XSLT変換
	var strResult = XMLTreeDom.transformNode(XSLTreeDom);
	parent.navi_frm2.document.write(strResult);

}


function getXMLTreeDom(){
	return XMLTreeDom;
}
function getXSLTreeDom(){
	return XSLTreeDom;
}
function getXMLTreeList(){
	return XMLTreeList;
}
function getXSLTreeList(){
	return XSLTreeList;
}


</script>

</HEAD>
<body onload="load()">
<form id="update_form" method="post" name="update_form" target="right"> 
<input type="hidden" name = "preClick"/>
</form>
<%=SQL%>
</body>
</HTML>


<%@ include file="../../connect_close.jsp" %>
