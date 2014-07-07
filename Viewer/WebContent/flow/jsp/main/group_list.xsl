<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">


<xsl:comment>ソート初期設定</xsl:comment>
<xsl:variable name="Sort_select"></xsl:variable>
<xsl:variable name="Sort_datatype"></xsl:variable>
<xsl:variable name="Sort_order"></xsl:variable>


<xsl:template match="/">


<html lang="ja">
<head>
<title>OpenOLAP</title>
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS"/>
<link rel="stylesheet" type="text/css" href="../../../css/common.css"/>
<link rel="stylesheet" type="text/css" href="../../../css/xmlTable.css"/>
<script type="text/javascript" src="../js/xmlTable.js"></script>
<script type="text/javascript" src="../js/registration.js"></script>
<script type="text/javascript" src="load.js"></script>
<script type="text/JavaScript">
<xsl:comment>
<![CDATA[




	function sort(sort_no,sort_type,obj){

		if((obj!=null)&&(obj.style.cursor=="col-resize")){
			return;
		}

		if(document.SpreadForm.Sort_order.value=="ascending"){
			document.SpreadForm.Sort_order.value="descending";
		}else if(document.SpreadForm.Sort_order.value=="descending"){
			document.SpreadForm.Sort_order.value="ascending";
		}else if(document.SpreadForm.Sort_order.value==""){
			document.SpreadForm.Sort_order.value="ascending";
		}


		//data-type
		if(sort_type=="number"){
			document.SpreadForm.Sort_datatype.value = "number";
		}else if(sort_type=="text"){
			document.SpreadForm.Sort_datatype.value = "text";
		}else{
			document.SpreadForm.Sort_datatype.value = "text";
		}


		var xmlDocObj = parent.XMLData;
		var xslDocObj = parent.objXSL;

		var key1 = xslDocObj.selectSingleNode("*//xsl:sort/@select");
		var key2 = xslDocObj.selectSingleNode("*//xsl:sort/@data-type");
		var key3 = xslDocObj.selectSingleNode("*//xsl:sort/@order");


		//xsl:sort
		//select
		key1.value = "./value[" + sort_no +"]";

		key2.value = document.SpreadForm.Sort_datatype.value;


		//order
		key3.value = document.SpreadForm.Sort_order.value;



		var source = xmlDocObj.selectSingleNode("rows");
		DataTableArea.innerHTML = source.transformNode(xslDocObj);




		changeAllCellWidth();
	}





function winOpen(type){
	var objId = null;
	var userId = null;
	if(type==0){//新規
		objId = 0;
		userId = "";
	}else if(type==1){//変更
		var obj=eventSource;
		while(obj.tagName!="BODY"){
			if(obj.tagName=="TR"){
				break;
			}
			obj=obj.parentNode;
		}
		objId = obj.attributes.getNamedItem("ID").value;
		userId=obj.attributes.getNamedItem("USER").value;
	}else if(type.tagName=="TR"){//ダブルクリック時
		objId = type.attributes.getNamedItem("ID").value;
		userId=type.attributes.getNamedItem("USER").value;
	}
//	alert("group_prpt.jsp?objId=" + objId + "&userId=" + userId);
//	newWin = window.open("group_prpt.jsp?objId=" + objId + "&userId=" + userId,"_blank","menubar=no,toolbar=no,width=700px,height=450px,resizable");
	window.showModalDialog("group_prpt.jsp?objId=" + objId + "&userId=" + userId,self,"dialogHeight:425px; dialogWidth:630px;");


}


function delUser(){

	var objId = toUpObj(eventSource,"TR").id;
	var singleNode=parent.XMLData.selectSingleNode("//rows");
	for(i=0;i<singleNode.childNodes.length;i++){
		if(singleNode.childNodes[i].tagName=="row"){
			if(singleNode.childNodes[i].attributes.getNamedItem("ID").value==objId){
				if(showConfirm("CFM3",singleNode.childNodes[i].childNodes[1].text)){
					singleNode.removeChild(singleNode.childNodes[i]);
					break;
				}
			}
		}
	}
	domReload(parent,self);

}


//目的のタグになるまで親を辿る
function toUpObj(obj,targetTagName){
	var returnObj=null;
	while(true){
		if(obj.tagName==targetTagName){
			returnObj=obj;
			break;
		}
		if(obj.parentNode==undefined){
			break;
		}else{
			obj=obj.parentNode;
		}
	}
	return returnObj;
}


function domReload(frmXML,frmReload){//XMLページ再読み込み
	frmReload.document.open();//ドキュメントの初期化
	var strResult = frmXML.XMLData.transformNode(frmXML.objXSL);
	frmReload.document.write(strResult);
}


var eventSource=null;


//var menuText = new Array( "新規作成","変更","削除","レポート設定");
//var menuAction = new Array("winOpen(0)","winOpen(1)","delUser()","reportConfig()");
var menuText = new Array( "新規作成","変更","削除");
var menuAction = new Array("winOpen(0)","winOpen(1)","delUser()");

if(window.createPopup){
	var backgroundOutColor = "#dddddd";           //マウスが外れた時の背景色
	var backgroundOverColor = "#FFDCAF";          //マウスが乗った時の背景色

	var divMenu = "";                    //メニュー内容
	var oPopup = window.createPopup();       //ポップアップオブジェクト作成
	divMenu = '<DIV STYLE="border:1px solid #333333;border-right:0; background:' + backgroundOutColor + ';">';

		//メニュー内容作成
	for(count = 0; count < menuText.length; count++){
		divMenu +='<DIV onmouseover="this.style.background=\'' + backgroundOverColor + '\';" onmouseout="this.style.background=\'' + backgroundOutColor + '\';" onclick="parent.' + menuAction[count] + '" style="font-size:11px; height:20px; padding-left:3px;padding-top:5px; cursor:hand; border-bottom:1px solid #333333; border-right:1px solid #333333;">' + menuText[count] + '</DIV>';
	}
	divMenu += '</DIV>';
	document.oncontextmenu = ContextMenu;                 //右クリックイベント発生時
}



function ContextMenu(){
//	alert(event.srcElement.tagName);
//	if(!(event.srcElement.tagName=="TD"||event.srcElement.tagName=="NOBR")){
//		return;
//	}
	eventSource=event.srcElement;
	var menuNum=1;
	obj=eventSource;
	while(obj.tagName!="BODY"){
		if((obj.tagName=="TR")&&(obj.attributes.getNamedItem("ID").value!="")){
			setChangeFlg();
			menuNum=menuText.length;
			break;
		}
		obj=obj.parentNode;
	}


	if(window.createPopup){
		var topper = event.clientX + 0;              //ポップアップを表示するX座標を取得
		var lefter = event.clientY + 0;              //ポップアップを表示するY座標を取得
		oPopup.document.body.innerHTML = divMenu; //ポップアップに表示する内容を設定
			//ポップアップを表示するメソッドをcall
		oPopup.show(topper, lefter, 100, (20*menuNum)+1, document.body);
		return(false);
	}

//	if(eventSource.tagName!="DIV"){
		return false;
//	}

}

function winEvent(){ 
    oPopup.hide(); 
} 

/*
function reportConfig(){
	var obj=eventSource;
	while(obj.tagName!="BODY"){
		if(obj.tagName=="TR"){
			break;
		}
		obj=obj.parentNode;
	}
	objId = obj.attributes.getNamedItem("ID").value;

//	newWin = window.open("sec_control.jsp?groupId=" + objId,"_blank","menubar=no,toolbar=no,width=900px,height=800px,resizable");
	window.showModalDialog("sec_control.jsp?groupId=" + objId,self,"dialogHeight:800px; dialogWidth:900px;");
}
*/

]]>
</xsl:comment>
</script>

</head>




<BODY id="SpreadBody" class="SpreadBody" onload="" onselectstart="return false" onresize="resizeArea()">
<FORM name="SpreadForm">
<SPAN onmousedown="mouseDown2();" onmouseup="mouseUp();">
<TABLE id="SpreadTable" class="SpreadTable">
	<TR>
		<TD>
			<!--mouseMove関数があるxmlTable.jsが読み込まれるのはここのonmousemoveイベントが発生する後なので、load.js内で別途onmousemoveイベントをアタッチする。
			<SPAN id="ColumnHeaderArea" class="ColumnHeaderArea" onmousemove="mouseMove();">
			-->
			<SPAN id="ColumnHeaderArea" class="ColumnHeaderArea">
				<TABLE class="ColumnHeaderTable" cellspacing="0" cellpadding="2">
					<xsl:call-template name="columngroup1" />
				</TABLE>
			</SPAN>
		</TD>
	</TR>
	<TR>
		<TD>
			<DIV id="DataTableArea" class="DataTableArea">
				<xsl:apply-templates select="rows" />
			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>

	<input type="hidden" name="Sort_select" value="" />
	<input type="hidden" name="Sort_datatype" value="" />
	<input type="hidden" name="Sort_order" value="" />

</FORM>


</BODY>
</html>
</xsl:template>



<xsl:template name="columngroup1">
	<COLGROUP id="columngroup1">
		<xsl:for-each select="rows/coldef/column">
			<COL>
				<xsl:attribute name="style">width:<xsl:value-of select="width" />;</xsl:attribute>
			</COL>
		</xsl:for-each>
	</COLGROUP>

	<TR Spread="ColumnHeaderRow">
		<xsl:for-each select="rows/coldef/column">
			<TD>
				<xsl:attribute name="onclick">sort('<xsl:value-of select="position()"/>','<xsl:value-of select="type"/>',this);</xsl:attribute>
				<xsl:value-of select="heading" />
			</TD>
		</xsl:for-each>
		<TD style="border:none;" class="adjustCell"></TD>
	</TR>
</xsl:template>




<xsl:template match="rows">

<TABLE id="DataTable" class="DataTable" cellspacing="0" cellpadding="2">
	<COLGROUP id="columngroup2">
		<xsl:for-each select="coldef/column">
			<COL>
				<xsl:attribute name="style">width:<xsl:value-of select="width" />;</xsl:attribute>
			</COL>
		</xsl:for-each>
	</COLGROUP>



	<xsl:for-each select="/rows/row">
		<xsl:sort select="./value[number($Sort_select)]" data-type="{$Sort_datatype}" order="{$Sort_order}" />
		<xsl:variable name="rowNum" select="position()" />
		<tr>

			<xsl:attribute name="ID">
				<xsl:value-of select="@ID" />
			</xsl:attribute>

			<xsl:attribute name="USER">
				<xsl:value-of select="@USER" />
			</xsl:attribute>

			<xsl:attribute name="onmouseover">
				javascript:this.style.backgroundColor="#FFDCAF";
			</xsl:attribute>
			<xsl:attribute name="onmouseout">
				javascript:this.style.backgroundColor="white";
			</xsl:attribute>
			<xsl:attribute name="OnDblClick">
				javascript:winOpen(this);setChangeFlg();
			</xsl:attribute>



			<xsl:variable name="tempPosition" select="."/>

			<xsl:for-each select="./value">
				<td>
					<xsl:variable name="cellNum" select="position()" />

					<xsl:attribute name="align">
						<xsl:choose>
							<xsl:when test="//coldef/column[$cellNum]/type[.='number']">
								<xsl:text>right</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>left</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>




					<nobr>
						<xsl:value-of select="." />
					</nobr>

				</td>
			</xsl:for-each>
		</tr>
	</xsl:for-each>


</TABLE>

</xsl:template>
</xsl:stylesheet>

