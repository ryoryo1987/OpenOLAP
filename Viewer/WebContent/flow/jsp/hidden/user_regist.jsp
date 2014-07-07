<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "openolap.viewer.Report"%>
<%@ page import = "openolap.viewer.XMLConverter"%>


<%@ include file="../../connect.jsp" %>
<%!
  private String getChildren(Element element, String tagName) {
    NodeList list = element.getElementsByTagName(tagName);
    Element cElement = (Element)list.item(1);
    return cElement.getFirstChild().getNodeValue();
  }


%>
<%
	String SQL = "";
	int exeCount = 0;



	SQL = "delete from oo_v_user";
	exeCount = stmt.executeUpdate(SQL);

	SQL = "delete from oo_v_user_group";
	exeCount = stmt.executeUpdate(SQL);



	String XMLString = request.getParameter("hid_dom");
	Document doc = new XMLConverter().toXMLDocument(XMLString);
out.println("<BR>doc:"+doc);

	Element root = doc.getDocumentElement();
	out.println("ルート要素名 : " + (root.getTagName()));

	// 各ノードリストを取得
	NodeList list = root.getElementsByTagName("row");
	out.println("ノードリストの数は : " + (list.getLength()));
	for(int i=0;i<list.getLength();i++){
		Element rowElement = (Element)list.item(i);
		// data タグの id を取得
		String strUserId = rowElement.getAttribute("ID");
		String strGroupId = rowElement.getAttribute("GROUP");
		String strColorStyleId = rowElement.getAttribute("color_style_id");

		
		String strUserName=rowElement.getChildNodes().item(1).getFirstChild().getNodeValue();
		String strPassword=rowElement.getChildNodes().item(2).getFirstChild().getNodeValue();
		String strAdminFlg=rowElement.getChildNodes().item(3).getFirstChild().getNodeValue();
		String strExportFileType=rowElement.getChildNodes().item(4).getFirstChild().getNodeValue();
	//	String strComment=rowElement.getChildNodes().item(4).getFirstChild().getNodeValue();
		String strComment="";
		try {
			strComment=rowElement.getChildNodes().item(5).getFirstChild().getNodeValue();
		} catch(Exception e) { 
			out.println("<BR>" + e);
		}


	//	out.println("<BR>strUserId: " + strUserId);
	//	out.println("<BR>strGroupId: " + strGroupId);
	//	out.println("<BR>strUserName: " + strUserName);
	//	out.println("<BR>strPassword: " + strPassword);
	//	out.println("<BR>strExportFileType: " + strExportFileType);
	//	out.println("<BR>strComment: " + strComment);


		SQL = " insert into oo_v_user ";
		SQL = SQL + " (user_id,name,password,adminflg,export_file_type,comment,color_style_id) values (";
		SQL = SQL + "'" + strUserId + "'";
		SQL = SQL + ",'" + strUserName + "'";
		SQL = SQL + ",'" + strPassword + "'";
		SQL = SQL + ",'" + strAdminFlg + "'";
		SQL = SQL + ",'" + strExportFileType + "'";
		SQL = SQL + ",'" + strComment + "'";
		SQL = SQL + ",'" + strColorStyleId + "'";
		SQL = SQL + ")";
		exeCount = stmt.executeUpdate(SQL);
		out.println("<br>"+SQL);
	//	out.println("<BR><BR>");


		StringTokenizer arrGroupId = new StringTokenizer(strGroupId, ",");
		while (arrGroupId.hasMoreTokens()){
			SQL = " insert into oo_v_user_group values (";
			SQL = SQL + "'" + strUserId + "'";
			SQL = SQL + ",'" + arrGroupId.nextToken() + "'";
			SQL = SQL + ")";
			try{
				exeCount = stmt.executeUpdate(SQL);
			} catch(Exception e) { 
				out.println("<BR>" + e);
			}
		}






	}





//	SQL = "delete from oo_v_report where user_id not in (select user_id from oo_v_user)";
//	exeCount = stmt.executeUpdate(SQL);
//
//	SQL = "delete from oo_v_group_report where group_id not in (select group_id from oo_v_group)";
//	exeCount = stmt.executeUpdate(SQL);



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("登録しました。");
			top.frames[1].document.navi_form.change_flg.value = 0;
		}
	</script>
</head>
<body onload="load()">
<br><br>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
