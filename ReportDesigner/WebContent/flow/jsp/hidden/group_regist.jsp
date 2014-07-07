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



	SQL = "delete from oo_v_group";
	exeCount = stmt.executeUpdate(SQL);

	SQL = "delete from oo_v_user_group";
	exeCount = stmt.executeUpdate(SQL);



	String GroupIdList="";
	String GroupNameList="";

	String XMLString = request.getParameter("hid_dom");
	Document doc = new XMLConverter().toXMLDocument(XMLString);
	Element root = doc.getDocumentElement();
//	out.println("ルート要素名 : " + (root.getTagName()));

	// 各ノードリストを取得
	NodeList list = root.getElementsByTagName("row");
//	out.println("ノードリストの数は : " + (list.getLength()));
	for(int i=0;i<list.getLength();i++){
		Element rowElement = (Element)list.item(i);
		// data タグの id を取得
		String strGroupId = rowElement.getAttribute("ID");
		String strUserId = rowElement.getAttribute("USER");
		
		String strGroupName=rowElement.getChildNodes().item(1).getFirstChild().getNodeValue();
	//	String strComment=rowElement.getChildNodes().item(2).getFirstChild().getNodeValue();
		String strComment="";
		try {
			strComment=rowElement.getChildNodes().item(2).getFirstChild().getNodeValue();
		} catch(Exception e) { 
			out.println("<BR>" + e);
		}

		if(!"".equals(GroupIdList)){GroupIdList+=",";}
		GroupIdList+="'"+strGroupId+"'";
		if(!"".equals(GroupNameList)){GroupNameList+=",";}
		GroupNameList+="'"+strGroupName+"'";



		SQL = " insert into oo_v_group ";
		SQL = SQL + " (group_id,name,comment) values (";
		SQL = SQL + "'" + strGroupId + "'";
		SQL = SQL + ",'" + strGroupName + "'";
		SQL = SQL + ",'" + strComment + "'";
		SQL = SQL + ")";
		exeCount = stmt.executeUpdate(SQL);


		SQL = "insert into oo_v_group_report (group_id,report_id,right_flg,export_flg) select '" + strGroupId + "',report_id,'1','1' from oo_v_report";
		try {
			exeCount = stmt.executeUpdate(SQL);
		} catch(Exception e) { 
			out.println("<BR>" + e);
		}


		StringTokenizer arrUserId = new StringTokenizer(strUserId, ",");
		while (arrUserId.hasMoreTokens()){
			SQL = " insert into oo_v_user_group values (";
			SQL = SQL + "'" + arrUserId.nextToken() + "'";
			SQL = SQL + ",'" + strGroupId + "'";
			SQL = SQL + ")";
			exeCount = stmt.executeUpdate(SQL);
		//	out.println("SQL:" + SQL);

		}


	}




	SQL = "delete from oo_v_group_report where group_id not in (select group_id from oo_v_group)";
	exeCount = stmt.executeUpdate(SQL);



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="javascript">
		function load(){
			alert("登録しました。");
			top.frames[1].document.navi_form.change_flg.value = 0;

			//左ツリー更新
			var arrGroupId = new Array(<%=GroupIdList%>);
			var arrGroupName = new Array(<%=GroupNameList%>);
			parent.parent.navi_frm.refleshGroup(arrGroupId,arrGroupName);



		}
	</script>
</head>
<body onload="load()">
<br><br>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
