<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">

<xsl:template match="/">

<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS"/>
	<title>OpenOLAP</title>
		<link rel="stylesheet" type="text/css" href="xml/condition/common.css"/>
		<link id="stylefile" rel="stylesheet" type="text/css" href="xml/condition/spreadStyle_blue_1.css"/>
		<script language="JavaScript1.2" src="xml/condition/condition.js"></script>
		<script language="JavaScript" src="condition_load.js"></script>
</head>

<script type="text/JavaScript">
<xsl:comment>
<![CDATA[
/*
function makeListBox(listBox,selfNextType,xmlNode){
	var conditionNode;
	var argAttrName;
	var argAttrValue;
	if(selfNextType=="self"){
		conditionNode=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group/listbox/listName[@listName='"+listBox.selectSingleNode("./listName").getAttribute("listName")+"']").parentNode;
		XMLDoc2.loadXML(XMLDoc.selectSingleNode("/OpenOLAP/data").xml);
	}else if(selfNextType=="next"){
		conditionNode=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group/listbox/listName[@listName='"+listBox.name+"']").parentNode.nextSibling;
//	alert(conditionNode.xml);
		if(conditionNode==null){//nextがない場合はリターン
			return;
		}else{
			argAttrName=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group/listbox/listName[@listName='"+listBox.name+"']").parentNode.selectSingleNode("./listName").getAttribute("listId");
			argAttrValue=listBox.value;
			if(argAttrValue!=""&&argAttrValue!="%"){
				XMLDoc2.loadXML(XMLDoc.selectSingleNode("/OpenOLAP/data").xml);
			}
		}
	}


	var listName=conditionNode.selectSingleNode("./listName").getAttribute("listName");
	var strHTML = "<div id='div_" + listName + "'><select name='" + listName + "' id='" + listName + "'";
	strHTML += " onchange='makeListBox(this,\"next\")'";
	strHTML += ">";
	if((selfNextType=="next")&&(argAttrValue==""||argAttrValue=="%")){
		strHTML += "<option value=''>------------</option>";
	}else{
		strHTML += "<option value='%'>全て</option>";
		var listId=conditionNode.selectSingleNode("./listId").getAttribute("listId");
		var listValue=conditionNode.selectSingleNode("./listName").getAttribute("listName");
		var newXSLCode=originalXSLCode.replace(/任意コード/g,listId);
		newXSLCode=newXSLCode.replace(/任意名/g,listValue);
		if(argAttrValue==undefined){
			newXSLCode=newXSLCode.replace("追加絞込条件","");
		}else{
			newXSLCode=newXSLCode.replace("追加絞込条件","and (@"+argAttrName+"='"+argAttrValue+"')");
		}
		XSLDoc.loadXML(newXSLCode);
		strHTML += XMLDoc2.transformNode(XSLDoc);
	}
	strHTML += "</select></div>";

	if(document.all("div_" + listName)==undefined){
		if(selfNextType=="self"){
			document.all.div_conditions.innerHTML+="<br><br>";
		}
		document.all.div_conditions.innerHTML+=strHTML;
	}else{
		document.all("div_" + listName).outerHTML=strHTML;
	}


	//次のリストボックスを生成
	makeListBox(document.all(listName),'next');
}



function output(){
	var tempStr="";
	for(i=0;i<XMLDoc.selectSingleNode("/OpenOLAP/property/conditions").childNodes.length;i++){
		for(j=0;j<XMLDoc.selectSingleNode("/OpenOLAP/property/conditions").childNodes[i].childNodes.length;j++){
			var listName=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions").childNodes[i].childNodes[j].selectSingleNode("./listName").getAttribute("listName");
			tempStr+=document.all(listName).id+" : "+document.all(listName).value+"\n";
		}
	}

	strXML="";
	strXML+="";


//alert(parent.getReportId());

	alert(tempStr);

}
*/


var AttrValue="";//リストボックス選択値格納変数

function setAttrValue(obj){
	AttrValue=obj.value;
}


function makeListBox(groupNo,listNo){
	XMLDoc2.loadXML(XMLDoc.selectSingleNode("/OpenOLAP/data").xml);

	var listId=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group["+groupNo+"]/listbox["+listNo+"]/listId").getAttribute("listId");
	var listName=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group["+groupNo+"]/listbox["+listNo+"]/listName").getAttribute("listName");
	var listPK=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group["+groupNo+"]/listbox["+listNo+"]").getAttribute("propertyId");

//	if(listId=="0"){//listIdが「0」のものに関してはリストを作成しない
//		return;
//	}
	if((listId=="0")||(listName=="0")||(listPK=="0")){
		return;
	}



	var strHTML = "";
	if(listNo==0){//グループが切り替わるとき
		strHTML += "<div class='con_title''>条件"+(groupNo+1)+"</div>";
	}


	//リストボックスHTMLの作成
	strHTML += "<div class='con_data' id='div_" + listPK + "'><select name='" + listPK + "' id='" + listPK + "' listId='" + listId + "'";
	strHTML += " onchange='setAttrValue(this);rowListOutput("+groupNo+","+(listNo+1)+");'";
	strHTML += ">";
	if((listNo!=0)&&(AttrValue==""||AttrValue=="%")){
		strHTML += "<option value=''>------------</option>";
	}else{
		strHTML += "<option value='%'>全て</option>";
		var newXSLCode=originalXSLCode.replace(/任意コード/g,listId);
		newXSLCode=newXSLCode.replace(/任意名/g,listName);
		if(AttrValue==""){
			newXSLCode=newXSLCode.replace("追加絞込条件","");
		}else{
			var previousListId=XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group["+groupNo+"]/listbox["+(listNo-1)+"]/listId").getAttribute("listId");
			newXSLCode=newXSLCode.replace("追加絞込条件","and (@"+previousListId+"='"+AttrValue+"')");
		}
		XSLDoc.loadXML(newXSLCode);
		strHTML += XMLDoc2.transformNode(XSLDoc);
	}
	strHTML += "</select></div>";


	//selectプルダウンメニューの表示
	if(document.all("div_" + listPK)==undefined){
		if(listNo==0){//グループが切り替わるときは改行を入れる
			document.all.div_conditions.innerHTML+="<br/><br/>";
		}
		document.all.div_conditions.innerHTML+=strHTML;
	}else{
		document.all("div_" + listPK).outerHTML=strHTML;
	}


	//リストボックス選択値セット
	AttrValue=document.all(listPK).value;


}




function rowListOutput(groupNo,startListNo){
	for(var listNo=startListNo;listNo<XMLDoc.selectSingleNode("/OpenOLAP/property/conditions/group["+groupNo+"]").childNodes.length;listNo++){
		makeListBox(groupNo,listNo);//リストボックス作成
	}
	AttrValue="";
}



function load2(){
	for(i=0;i<XMLDoc.selectSingleNode("/OpenOLAP/property/conditions").childNodes.length;i++){
		rowListOutput(i,0);//グループの最初のリスト
	}
}


function output(){
	var strXML="<?xml version='1.0' encoding='Shift_JIS' ?>";
	strXML+="<OpenOLAP>";
	strXML+="<report_info report_type='R' report_id='"+parent.getReportId()+"'/>";
	strXML+="<args>";

	for(i=0;i<document.all.length;i++){
		var obj=document.all(i);
		if(obj.tagName=="SELECT"){
			strXML+="<arg colName='"+obj.id+"' code='"+obj.value+"'/>";
		}
	}

	strXML+="</args>";
	strXML+="</OpenOLAP>";




	document.form_main.hid_xml.value=strXML;

	document.form_main.action="../main/drill_arg.jsp?load=second";
	document.form_main.target="frm_result";
	document.form_main.submit();




/*
<OpenOLAP>
 <report_info report_type='R' report_id=''/>
 <args>
  <arg colName='クラスID' code='10-12'/> 連結は[-]
  <arg colName='' code=''/>
  <arg colName='' code=''/>
  <arg colName='' code=''/>
 </args>
</OpenOLAP>
*/


}


]]>
</xsl:comment>
</script>

<body>
	<form name="form_main" id="form_main" method="post" action="">
	<div style="margin-left:10">
		<div id="div_conditions"></div>

		<table id="tblTableBody">
			<tr>
				<td>
					<input type="button" id="btn_kensaku" value="" onclick="output()" class="normal_search" onMouseOver="className='over_search'" onMouseDown="className='down_search'" onMouseUp="className='up_search'" onMouseOut="className='out_search'" />
					<input type="hidden" name="hid_modify_xml" value=""/>
				</td>
			</tr>
		</table>

		<textarea name="xmlText" id='xmlText' cols="0" rows="0" style='display:none'>
		    <xsl:apply-templates select="/" mode="direct"/>
		</textarea>


		<input type="hidden" name="hid_xml" value=""/>
	</div>
	</form>


<!--	<iframe name="frm_hidden" src="blank.html" style="visibility:hidden;"></iframe>-->


</body>
</html>

</xsl:template>

<!--*******************************************************************************-->
<xsl:template match="@*|*|text()" mode="direct">
	<xsl:copy>
		<xsl:apply-templates select="@*|*|text()"  mode="direct"/>
	</xsl:copy>
</xsl:template>
<!--*******************************************************************************-->
</xsl:stylesheet>
