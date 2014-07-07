<%@ page language="java"
	contentType="text/xml;charset=Shift_JIS"
%><%
	StringBuffer dataXMLText = (StringBuffer) request.getAttribute("dataXMLText");
	String XMLString = dataXMLText.toString();
	XMLString=XMLString.substring(XMLString.indexOf("?>")+2);//Å‰‚Ì<?xml version="1.0"?>‚ğæ‚èœ‚­iæ“ª‚É‹ó”’“™‚ª“ü‚Á‚Ä‚¢‚é‚½‚ßj
	out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>"+XMLString);
%>