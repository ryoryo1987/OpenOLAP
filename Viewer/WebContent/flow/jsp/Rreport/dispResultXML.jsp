<%@ page language="java"
	contentType="text/xml;charset=Shift_JIS"
%><%
	StringBuffer dataXMLText = (StringBuffer) request.getAttribute("dataXMLText");
	String XMLString = dataXMLText.toString();
	XMLString=XMLString.substring(XMLString.indexOf("?>")+2);//�ŏ���<?xml version="1.0"?>����菜���i�擪�ɋ󔒓��������Ă��邽�߁j
	out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>"+XMLString);
%>