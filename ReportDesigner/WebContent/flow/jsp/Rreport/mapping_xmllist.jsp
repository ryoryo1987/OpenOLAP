<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>

<html lang="ja">
<head>
<title>OpenOLAP</title>
<link type="text/css" rel="stylesheet" href="../../../css/common.css" />
<link type="text/css" rel="stylesheet" href="../../../css/tree.css" />

<script language="JavaScript1.2" src="js/dbtree.js"></script>
<script language="JavaScript1.2" src="js/dragdrop.js"></script>
</head>
<script type="text/JavaScript1.2">
var cssXSL = new ActiveXObject("MSXML2.DOMDocument");
cssXSL.async = false;
cssXSL.load("./mapping_xmllist.xsl");
var xmlData = new ActiveXObject("MSXML2.DOMDocument");
xmlData.async = false;

//*************Ç∆ÇËÇ†Ç¶Ç∏ÅB

//xmlData.load("./xml/table/data.xml");
//alert(cssXSL.xml);
//alert(xmlData.xml);

//function load(){
//loadCssXML();
//}
//*************Ç∆ÇËÇ†Ç¶Ç∏ÅB

/*
	function setXML(){
		xmlData=parent.parent.frm_backNext.getScreenXML();
		cssXSL=parent.parent.frm_backNext.getScreenXSL();
	}
*/

	function loadCssXML(xmlArg){
		xmlData=xmlArg;
//		cssXSL=xslArg;
//		xmlData.loadXML(xmlString);
//		setXML();
//alert(xmlData.xml);
//alert(cssXSL.xml);
		xmlData=xmlData.selectSingleNode("*");

		var strResult = xmlData.transformNode(cssXSL);
//alert(strResult);
		var treeObj = document.getElementById("treeObj");
		treeObj.innerHTML = strResult;
	}

	function clickNode(th){
//		//Set Property
//		var source = xmlData.selectSingleNode("//*[@id="+th.id+"]");
//		var screenType = parent.frm_property.document.getElementById("styleType");
//		screenType.innerText=source.getAttribute("name");
//		screenType.seq=source.getAttribute("id");
//		displayScreen(source);
	}

//****************************************************************************
var dispXSL = new ActiveXObject("MSXML2.DOMDocument");
dispXSL.async = false;
var dispXML = new ActiveXObject("MSXML2.DOMDocument");
dispXML.async = false;

/*
	function displayScreen(xmlNode){
		dispXML.load(""+xmlNode.parentNode.getAttribute("fileName"));
		dispXSL.load(""+xmlNode.parentNode.getAttribute("xslfileName1"));
//alert(xmlNode.parentNode.getAttribute("fileName"));
//alert(xmlNode.parentNode.getAttribute("xslfileName1"));

	var styleNode = dispXSL.selectSingleNode("//*[@id='stylefile']");
	styleNode.setAttribute("href",""+xmlNode.getAttribute("fileName"));

	var strResult = dispXML.transformNode(dispXSL);
	parent.frm_displayScreen.document.open();
	parent.frm_displayScreen.document.write(strResult);

		dispXSL.load(""+xmlNode.getAttribute("fileName"));
//alert(dispXSL.xml);
	}
*/

</script>
<body style="margin-top:0px;margin-left:0px;padding-top:0px;background : url('../../../images/Rreport/title.gif') white repeat-x" onload="return false;">
<form name="navi_form" id="navi_form" target="navi_frm" method="post" action="">
<input type="hidden" name="preClick" />
<input type="hidden" name="child_record" value="" />
<input type="hidden" name="parent_record" value="" />
<input type="hidden" name="objKind" value="" />
<input type="hidden" name="seqId" value="" />
<input type="hidden" name="change_flg" value="0" />
<input type="hidden" name="copyObj_objKind" value="" />
<input type="hidden" name="copyObj_id" value="" />
<input type="hidden" name="copyParentObj_objKind" value="" />
<input type="hidden" name="copyParentObj_id" value="" />

<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">ï\é¶çÄñ⁄Ç∆èåèçÄñ⁄ÇÃí«â¡</td>
	</tr>
</table>

<div id="treeObj" style="margin-left:7">
</div>

<div id="nonDisp" style='display:none'>
</div>

</form>
</body>
</html>
