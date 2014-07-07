<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>

<html lang="ja">
<head>
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title><%=(String)session.getValue("aplName")%></title>
<link rel="stylesheet" type="text/css" href="../../../css/common.css">
<body onload='search()'>
<form name="form_main" method="post">

<table style="margin:5 10 10 10;">
<div id="myTable" style='width:100%' style='display:inline;margin-left:10;margin-top:10'>
</div>
</table>

<div style='display:none'>
</div>

</form>
</body>
</html>

<script>
	var XMLData = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData1 = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData2 = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData3 = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData4 = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData5 = new ActiveXObject("MSXML2.DOMDocument");
	var XSLData6 = new ActiveXObject("MSXML2.DOMDocument");
	var tempXML = new ActiveXObject("MSXML2.DOMDocument");

//	var rowXSL = new ActiveXObject("MSXML2.DOMDocument");
//	var rowXML = new ActiveXObject("MSXML2.DOMDocument");


function search(){
	XMLData = parent.getXMLData2();
	XSLData1 = parent.getXSLData(1);
	XSLData2 = parent.getXSLData(2);
	XSLData3 = parent.getXSLData(3);
	XSLData4 = parent.getXSLData(4);
	XSLData5 = parent.getXSLData(5);
	XSLData6 = parent.getXSLData(6);
//rowXSL = parent.getRowXsl();
//alert(rowXSL.xml);
//alert(XMLData.xml);
//alert(XSLData.xml);

	var dispCountNode = XMLData.selectSingleNode("//OpenOLAP/property/dispRow[@dispRow]");
	var dispCountVal = dispCountNode.getAttribute("dispRow");
//alert(dispCountVal);
//return;
	dispResult(1,dispCountVal);

	var strHTML="";
	var recordCount = XMLData.selectNodes("//additionalData/rowHeader/row").length;
	strHTML+="<span style='font-weight:bold;font-size:12px'>件数："+recordCount+"</span>&nbsp;&nbsp;ページ："

	for(var i=0;i<recordCount/dispCountVal;i++){
//		if((i+1)==dispCountVal){
//			strHTML+=""
//		}else{
			strHTML+="<a href='JavaScript:dispResult("+((i*dispCountVal)+1)+","+(i+1)*dispCountVal+",this)'>"+(i+1)+"</a>&nbsp"
//		}
	}
//alert(strHTML);
	document.getElementById("myTable").innerHTML=strHTML;
}

function dispResult(startRownum,endRownum,th){
	var startRowTag = XMLData.selectSingleNode("//OpenOLAP/property/dispRow[@startRow]");
	startRowTag.setAttribute("startRow",startRownum);

	var endRowTag = XMLData.selectSingleNode("//OpenOLAP/property/dispRow[@endRow]");
	endRowTag.setAttribute("endRow",endRownum);;


	var strResult;
	if(XSLData6.xml!=''){
		strResult = XMLData.transformNode(XSLData6);
		tempXML.loadXML(strResult);
	}

	if(XSLData5.xml!=''){
		if(tempXML.xml!=''){
			strResult = tempXML.transformNode(XSLData5);
			tempXML.loadXML(strResult);
		}else{
			strResult = XMLData.transformNode(XSLData5);
			tempXML.loadXML(strResult);
		}
	}

	if(XSLData4.xml!=''){
		if(tempXML.xml!=''){
			strResult = tempXML.transformNode(XSLData4);
			tempXML.loadXML(strResult);
		}else{
			strResult = XMLData.transformNode(XSLData4);
			tempXML.loadXML(strResult);
		}
	}

	if(XSLData3.xml!=''){
		if(tempXML.xml!=''){
			strResult = tempXML.transformNode(XSLData3);
			tempXML.loadXML(strResult);
		}else{
			strResult = XMLData.transformNode(XSLData3);
			tempXML.loadXML(strResult);
		}
	}


	if(XSLData1.xml!=''){
		if(tempXML.xml!=''){
			strResult = tempXML.transformNode(XSLData1);
			tempXML.loadXML(strResult);
		}else{
			strResult = XMLData.transformNode(XSLData1);
			tempXML.loadXML(strResult);
		}
	}

	// XSLT変換
//	strResult = rowXML.transformNode(XSLData1);

	// 変換結果で、HTMLを更新
	parent.frm_result.document.open();
	parent.frm_result.document.write(strResult);

}
</script>
