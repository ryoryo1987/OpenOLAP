	var XMLDoc = new ActiveXObject("MSXML2.DOMDocument");
	XMLDoc.async = false;

	var XMLDoc2 = new ActiveXObject("MSXML2.DOMDocument");
	XMLDoc2.async = false;

	var XSLDoc = new ActiveXObject("MSXML2.DOMDocument");
	XSLDoc.async = false;
	XSLDoc.load("xml/condition/distinct.xsl");
	var originalXSLCode = XSLDoc.selectSingleNode("*").xml;


	var a = document.form_main.xmlText.innerHTML;
	a=a.replace(/&lt;/g,"<");
	a=a.replace(/&gt;/g,">");
	XMLDoc.loadXML("<?xml version='1.0' encoding='Shift_JIS'?>"+a);

	document.form_main.xmlText.innerHTML="";

	load2();

