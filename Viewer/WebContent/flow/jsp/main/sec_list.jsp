<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ include file="../../connect.jsp" %>


<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
	<title><%=(String)session.getValue("aplName")%></title>

<script language="JavaScript">


function load(){


	var strXml='<?xml version="1.0" encoding="Shift_JIS" ?>';
	strXml+='<?xml:stylesheet type="text/xsl" href="sec_list.xsl" ?>';
	strXml+='<rows>';
	strXml+='	<coldef>';
	strXml+='		<column>';
	strXml+='			<heading>名前</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>120</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>ID</heading>';
	strXml+='			<type>number</type>';
	strXml+='			<width>40</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>参照</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>50</width>';
	strXml+='		</column>';
//	strXml+='		<column>';
//	strXml+='			<heading>保存</heading>';
//	strXml+='			<type>text</type>';
//	strXml+='			<width>50</width>';
//	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>エクスポート</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>80</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>種類</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>80</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>更新日時</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>80</width>';
	strXml+='		</column>';
	strXml+='		<column>';
	strXml+='			<heading>　</heading>';
	strXml+='			<type>text</type>';
	strXml+='			<width>100%</width>';
	strXml+='		</column>';
	strXml+='	</coldef>';

<%	if("root".equals(request.getParameter("id"))){	%>
//	alert("<%=request.getParameter("id")%>");
		var singleNode=parent.dom_frm.getXMLTreeDom().selectSingleNode("//BistroObjects");
<%	}else{	%>
		var singleNode=parent.dom_frm.getXMLTreeDom().selectSingleNode("//category[@ID='<%=request.getParameter("id")%>']");
<%	}	%>


	for(t=1;t<singleNode.childNodes.length;t++){

	//	strXml+='<row ID="' + singleNode.childNodes[t].attributes.getNamedItem("ID").value + '" KI="' + singleNode.childNodes[t].attributes.getNamedItem("KI").value + '" RIGHT="' + singleNode.childNodes[t].attributes.getNamedItem("RIGHT").value + '" SAVE="' + singleNode.childNodes[t].attributes.getNamedItem("SAVE").value + '" EXPORT="' + singleNode.childNodes[t].attributes.getNamedItem("EXPORT").value + '">';
		strXml+='<row ID="' + singleNode.childNodes[t].attributes.getNamedItem("ID").value + '" KI="' + singleNode.childNodes[t].attributes.getNamedItem("KI").value + '" RTYPE="' + singleNode.childNodes[t].attributes.getNamedItem("RTYPE").value + '" RIGHT="' + singleNode.childNodes[t].attributes.getNamedItem("RIGHT").value + '" EXPORT="' + singleNode.childNodes[t].attributes.getNamedItem("EXPORT").value + '">';
		strXml+='<value>';
		strXml+=singleNode.childNodes[t].firstChild.xml;
		strXml+='</value>';
		strXml+='<value>';
		strXml+=singleNode.childNodes[t].attributes.getNamedItem("ID").value;
		strXml+='</value>';
		strXml+='<value>';
		strXml+=changeText(singleNode.childNodes[t].attributes.getNamedItem("RIGHT").value);
		strXml+='</value>';
//		strXml+='<value>';
//		strXml+=changeText(singleNode.childNodes[t].attributes.getNamedItem("SAVE").value);
//		strXml+='</value>';
		strXml+='<value>';
		strXml+=changeText(singleNode.childNodes[t].attributes.getNamedItem("EXPORT").value);
		strXml+='</value>';
		strXml+='<value>';
		strXml+=changeText2(singleNode.childNodes[t].attributes.getNamedItem("KI").value);
		strXml+='</value>';
		strXml+='<value>';
		strXml+=singleNode.childNodes[t].attributes.getNamedItem("UPDATE").value;
		strXml+='</value>';
		strXml+='</row>';
	}


	strXml+='</rows>';
	parent.dom_frm.getXMLTreeList().async = false;
	parent.dom_frm.getXMLTreeList().loadXML(strXml);


	// XSLT変換
	var strResult = parent.dom_frm.getXMLTreeList().transformNode(parent.dom_frm.getXSLTreeList());
	document.write(strResult);



}


function changeText(str){
	if(str=="1"){
		return "○";
	}else if(str=="0"){
		return "×";
	}else if(str=="-"){
		return "-";
	}
}

function changeText2(str){
	if(str=="R"){
		return "レポート";
	}else if(str=="F"){
		return "フォルダ";
	}
}



</script>

</HEAD>
<body onload="load()">
</body>
</HTML>



<%@ include file="../../connect_close.jsp" %>
