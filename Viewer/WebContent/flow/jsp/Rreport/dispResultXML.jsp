<%@ page language="java"
	contentType="text/xml;charset=Shift_JIS"
%><%
	StringBuffer dataXMLText = (StringBuffer) request.getAttribute("dataXMLText");
	String XMLString = dataXMLText.toString();
	XMLString=XMLString.substring(XMLString.indexOf("?>")+2);//最初の<?xml version="1.0"?>を取り除く（先頭に空白等が入っているため）
	out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>"+XMLString);
%>