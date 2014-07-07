<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "openolap.viewer.Report"%>
<%@ page import = "openolap.viewer.XMLConverter"%>


<%@ include file="../../connect.jsp" %>
<%
	String SQL = "";
	int exeCount = 0;


	String XMLString = request.getParameter("hid_dom");
//	out.println("<pre>"+XMLString+"</pre>");
	Document doc = new XMLConverter().toXMLDocument(XMLString);
	Element root = doc.getDocumentElement();
	out.println("ルート要素名 : " + (root.getTagName()));

	// 各ノードリストを取得
	NodeList list = root.getElementsByTagName("category");
	out.println("ノードリストの数は : " + (list.getLength()));
	for(int i=0;i<list.getLength();i++){
		Element rowElement = (Element)list.item(i);
		// data タグの id を取得
		

		out.println("<BR>ID:" + rowElement.getAttribute("ID"));
		out.println("<BR>KI:" + rowElement.getAttribute("KI"));
		out.println("<BR>RIGHT:" + rowElement.getAttribute("RIGHT"));
	//	out.println("<BR>SAVE:" + rowElement.getAttribute("SAVE"));
		out.println("<BR>EXPORT:" + rowElement.getAttribute("EXPORT"));
		out.println("<BR><BR>");


		SQL = " delete from oo_v_group_report ";
		SQL = SQL + " where group_id = " + request.getParameter("hid_group_id");
		SQL = SQL + " and report_id = " + rowElement.getAttribute("ID");
		exeCount = stmt.executeUpdate(SQL);

		SQL = " insert into oo_v_group_report ";
	//	SQL = SQL + " (group_id,report_id,right_flg,save_flg,export_flg) values (";
		SQL = SQL + " (group_id,report_id,right_flg,export_flg) values (";
		SQL = SQL + "'" + request.getParameter("hid_group_id") + "'";
		SQL = SQL + ",'" + rowElement.getAttribute("ID") + "'";
		SQL = SQL + ",'" + rowElement.getAttribute("RIGHT") + "'";
		String tempString="";
	//	if("-".equals(rowElement.getAttribute("SAVE"))){
	//		tempString="";
	//	}else{
	//		tempString=rowElement.getAttribute("SAVE");
	//	}
	//	SQL = SQL + ",'" + tempString + "'";
		if("-".equals(rowElement.getAttribute("EXPORT"))){
			tempString="";
		}else{
			tempString=rowElement.getAttribute("EXPORT");
		}
		SQL = SQL + ",'" + tempString + "'";
		SQL = SQL + ")";
		exeCount = stmt.executeUpdate(SQL);




	}










%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("登録しました。");
			top.frames[1].document.navi_form.change_flg.value = 0;
			parent.window.close()
		}
	</script>
</head>
<body onload="load()">
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
