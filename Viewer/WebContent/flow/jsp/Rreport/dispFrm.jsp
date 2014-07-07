<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ include file="../../connect.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title><%=(String)session.getValue("aplName")%></title>


<script>
	var XMLData = new ActiveXObject("MSXML2.DOMDocument");
	XMLData.async = false;

	var XSLData1 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData1.async = false;
	var XSLData2 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData2.async = false;
	var XSLData3 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData3.async = false;
	var XSLData4 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData4.async = false;
	var XSLData5 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData5.async = false;
	var XSLData6 = new ActiveXObject("MSXML2.DOMDocument");
	XSLData6.async = false;


	var rowXSL = new ActiveXObject("MSXML2.DOMDocument");
	rowXSL.async = false;

<%
//request.getParameter("kind") session or db
//request.getParameter("rId") kind=db reportId
//request.getParameter("sessName") kind=session session_name

	String kind=request.getParameter("kind");
	String rId=request.getParameter("rId");// kind=db reportId
	String sessName=request.getParameter("sessName");
//	String colName=request.getParameter("colName");
	String recordXMLURL="";
	String dispXmlURL="";
	String dispXslURL1="";
	String dispXslURL2="";
	String dispXslURL3="";
	String dispXslURL4="";
	String dispXslURL5="";
	String dispXslURL6="";

	if(kind.equals("session")){
		recordXMLURL="../../../Controller?action=getResultXML&source=session";
		dispXmlURL="?kind=session&sessName=RsourceXML";
		dispXslURL1="?kind=session&sessName=screenXSL1";
		dispXslURL2="?kind=session&sessName=screenXSL2";
		dispXslURL3="?kind=session&sessName=screenXSL3";
		dispXslURL4="?kind=session&sessName=screenXSL4";
		dispXslURL5="?kind=session&sessName=screenXSL5";
		dispXslURL6="?kind=session&sessName=screenXSL6";
		rId=(String)request.getSession().getAttribute("session_report_id");
	}else if(kind.equals("db")){
		recordXMLURL="../../../Controller?action=getResultXML&source=db&rId="+rId;
		dispXmlURL="?kind=db&colName=screen_xml&rId="+rId;
		dispXslURL1="?kind=db&colName=screen_xsl&rId="+rId;
		dispXslURL2="?kind=db&colName=screen_xsl2&rId="+rId;
		dispXslURL3="?kind=db&colName=screen_xsl3&rId="+rId;
		dispXslURL4="?kind=db&colName=screen_xsl4&rId="+rId;
		dispXslURL5="?kind=db&colName=screen_xsl5&rId="+rId;
		dispXslURL6="?kind=db&colName=screen_xsl6&rId="+rId;
	}
%>
function getReportId(){
	return "<%=rId%>";
}

function getXMLData(){
	XMLData.load("<%=recordXMLURL%>");
	//Error 
	if(XMLData.xml==''){
		document.form_main.action = "<%=recordXMLURL%>";
		document.form_main.target = "_self";
		document.form_main.submit();
	}
	return XMLData;
}

function getXMLData2(){

	XMLData = getXMLData();
	XSLData1 = getXSLData(1);
	XSLData2 = getXSLData(2);
	var strResult="";
	XMLData.setProperty("SelectionLanguage", "XPath");
	XSLData2.setProperty("SelectionLanguage", "XPath");
	strResult = XMLData.transformNode(XSLData2);
	var tempXML= new ActiveXObject("MSXML2.DOMDocument");
	tempXML.async = false;
	tempXML.loadXML(strResult);

	return tempXML;
}

function getXSLData(num){
		if(num==1){
			XSLData1.load("dispXml.jsp<%=dispXslURL1%>");
			return XSLData1;
		}else if(num==2){
			XSLData2.load("dispXml.jsp<%=dispXslURL2%>");
			return XSLData2;
		}else if(num==3){
			XSLData3.load("dispXml.jsp<%=dispXslURL3%>");
			return XSLData3;
		}else if(num==4){
			XSLData4.load("dispXml.jsp<%=dispXslURL4%>");
			return XSLData4;
		}else if(num==5){
			XSLData5.load("dispXml.jsp<%=dispXslURL5%>");
			return XSLData5;
		}else if(num==6){
			XSLData6.load("dispXml.jsp<%=dispXslURL6%>");
			return XSLData6;
		}
}
//function getRowXsl(){
//	rowXSL.load("./xml/table/rowDisp.xsl");
//	return rowXSL;
//}

</script>


</head>

<script>
//表示するもの（件数、条件、等々）を分ける。
	var propXML = getXMLData();
//alert(propXML.xml);
	var kind = propXML.selectSingleNode("//OpenOLAP/property/pattern");

	if(kind!=null){

		if(kind.getAttribute("frm")=='condition'){
			document.write("<frameset rows='200,*'>");
			document.write("  <frame name='frm_search' frameborder='0' scrolling='no'  target='contents' src='blank.html' noresize>");
			document.write("  <frame name='frm_result' frameborder='0' scrolling='yes'  target='contents' src='blank.html'>");
			document.write("</frameset>");
			XMLData = getXMLData();
			XSLData1 = getXSLData(1);
			strResult = XMLData.transformNode(XSLData1);
			frm_search.document.write(strResult);
		}else if(kind.getAttribute("xslfile")=='2'){
				document.write("<frameset rows='30,*'>");
				document.write("  <frame name='frm_search' frameborder='0' scrolling='no'  target='contents' src='dispCnt2.jsp' noresize>");
				document.write("  <frame name='frm_result' frameborder='0' scrolling='yes'  target='contents' src='blank.html'>");
				document.write("</frameset>");

	//			XMLData = getXMLData();
	//			XSLData1 = getXSLData(1);
	//			XSLData2 = getXSLData(2);
	//			var strResult="";
	//			XMLData.setProperty("SelectionLanguage", "XPath");
	//			XSLData2.setProperty("SelectionLanguage", "XPath");
	//			strResult = XMLData.transformNode(XSLData2);
	//			var tempXML= new ActiveXObject("MSXML2.DOMDocument");
	//			tempXML.async = false;
	//			tempXML.loadXML(strResult);

	//			strResult = tempXML.transformNode(XSLData1);
	//			document.write(strResult);
		}else{
			var cnt = propXML.selectSingleNode("//OpenOLAP/property/dispRow");
			if(cnt.getAttribute("dispRow")=='0'){
				XMLData = getXMLData();
				XSLData1 = getXSLData(1);
	//alert(XMLData.xml);
	//alert(XSLData1.xml);
				strResult = XMLData.transformNode(XSLData1);
				document.write(strResult);
			}else{
				document.write("<frameset rows='50,*'>");
				document.write("  <frame name='frm_search' frameborder='0' scrolling='yes'  target='contents' src='dispCnt.jsp' noresize>");
				document.write("  <frame name='frm_result' frameborder='0' scrolling='yes'  target='contents' src='blank.html'>");
				document.write("</frameset>");
			}
		}

	}
</script>


</html>

<%@ include file="../../connect_close.jsp" %>
