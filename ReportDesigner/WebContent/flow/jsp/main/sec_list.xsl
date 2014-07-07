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
<script type="text/javascript" src="../js/tree.js"></script>
<script type="text/javascript" src="sec_list_load.js"></script>
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
			document.SpreadForm.Sort_order.value="descending";
		}


		//data-type
		if(sort_type=="number"){
			document.SpreadForm.Sort_datatype.value = "number";
		}else if(sort_type=="text"){
			document.SpreadForm.Sort_datatype.value = "text";
		}else{
			document.SpreadForm.Sort_datatype.value = "text";
		}


		var xmlDocObj = parent.dom_frm.getXMLTreeList();
		var xslDocObj = parent.dom_frm.getXSLTreeList();

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



	function changeCheckBox(obj,editFlg){
		/*
			editFlg 0:デフォルト（参照未許可→許可を下層に反映させない）
			editFlg 1:参照未許可→許可を下層に反映させる
		*/


		//チェックボックスのvalueをセット
		if(obj.checked==true){
			obj.value="1";
		}else if(obj.checked==false){
			obj.value="0";
		}
		permitFlg=obj.value;

		//フォルダかレポートか取得
		var ki=obj.parentNode.parentNode.parentNode.KI;
		var objId=obj.parentNode.parentNode.parentNode.id;

		//
		var type="";
		if(obj.parentNode.parentNode.cellIndex==2){
			type="RIGHT";
		}else if(obj.parentNode.parentNode.cellIndex==3){
			type="EXPORT";
		}


		//画面内アイコン変更（鍵のON/OFF）
		if(type=="RIGHT"){
			var imgFileName = obj.parentNode.parentNode.parentNode.childNodes[0].firstChild.firstChild.src;
			if(permitFlg=="1"){
				imgFileName=imgFileName.replace("_no.gif",".gif");
			}else if(permitFlg=="0"){
				imgFileName=imgFileName.replace(".gif","_no.gif");
			}
			obj.parentNode.parentNode.parentNode.childNodes[0].firstChild.firstChild.src=imgFileName;
		}


		//TreeDOM変更
		var henkanTaishoTreeNode=parent.dom_frm.getXMLTreeDom().selectSingleNode("//category[@ID='" + objId + "']");
		henkanTaishoTreeNode.attributes.getNamedItem(type).value=permitFlg;
/*
		if((type=='RIGHT')&&((obj.checked==false)||(editFlg=="1"))){//参照未許可と許可を下層に反映する
			allLoop2(henkanTaishoTreeNode.firstChild);
		}
*/


		if(ki=="F"){
			//DOM変更をツリーに反映
			syncTree2(henkanTaishoTreeNode);
		}


	}



	function getFlg(KI){
		if(permitFlg=="1"){
			return "1";
		}else if(permitFlg=="0"){
			if(KI=="F"){
				return "-";
			}else if(KI=="R"){
				return "0";
			}
		}
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


	function syncTree2(domNode){
	//alert(domNode.xml);
	//alert(xslData.xml);

		var strResult = domNode.transformNode(parent.dom_frm.getXSLTreeDom());
		var hiddenTree=parent.navi_frm2.document.getElementById("hiddenTree");
		hiddenTree.innerHTML = strResult;


		var nodeId = hiddenTree.firstChild.id;
		var addNode = hiddenTree.firstChild;
		hiddenTree.removeChild(addNode);

		var removeNode = parent.navi_frm2.document.getElementById(nodeId);
	//	removeNode.parentNode.appendChild(addNode);
		removeNode.parentNode.insertBefore(addNode,removeNode);
		removeNode.parentNode.removeChild(removeNode);

	}


	function dblclickClickNode(obj){
	//	alert(obj.parentNode.parentNode.parentNode.childNodes[1].childNodes[0].innerHTML);
		var clickObjId=obj.parentNode.parentNode.parentNode.childNodes[1].childNodes[0].innerHTML;
		var preClickObj;
		var preClickAhref;
		preClickObj=parent.navi_frm2.getpreClickObj();

		if (preClickObj.lastChild.style.display=='none'){
			parent.navi_frm2.reversePreNextImage(preClickObj);
			parent.navi_frm2.reversePM(preClickObj);
			parent.navi_frm2.reverseDisplay(preClickObj);
		}
		for(i=0;i<preClickObj.lastChild.childNodes.length;i++){
			if(preClickObj.lastChild.childNodes[i].id==clickObjId){
				parent.navi_frm2.Toggle('f',preClickObj.lastChild.childNodes[i].lastChild.previousSibling.previousSibling,'sec_list.jsp?id='+clickObjId);
				return;
			}
		}
	//	Toggle('r',preClickObj.lastChild.childNodes[0].lastChild.previousSibling.previousSibling,'sec_list.jsp?id='+clickObjId);

	}






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
			<!--mouseMove関数があるxmlTable.jsが読み込まれるのはここのonmousemoveイベントが発生する後なので、sec_tree_load.js内で別途onmousemoveイベントをアタッチする。
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
				<xsl:apply-templates select="rows"/>
			</DIV>
		</TD>
	</TR>
</TABLE>
</SPAN>



	<input type="hidden" name="Sort_select" value="" />
	<input type="hidden" name="Sort_datatype" value="" />
	<input type="hidden" name="Sort_order" value="ascending" />

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

<TABLE id="DataTable" class="DataTable" cellspacing="0" cellpadding="2" bgcolor="white">
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
			<xsl:variable name="tempPosition" select="."/>

			<xsl:attribute name="ID">
				<xsl:value-of select="@ID" />
			</xsl:attribute>

			<xsl:attribute name="onmouseover">
				javascript:this.style.backgroundColor="#FFDCAF";
			</xsl:attribute>
			<xsl:attribute name="onmouseout">
				javascript:this.style.backgroundColor="white";
			</xsl:attribute>

			<xsl:attribute name="KI">
				<xsl:value-of select="@KI" />
			</xsl:attribute>

			<xsl:for-each select="./value">
				<td>
					<xsl:variable name="cellNum" select="position()" />

					<xsl:attribute name="align">
						<xsl:choose>
							<xsl:when test="//coldef/column[$cellNum]/type[.='number']">
								<xsl:text>right</xsl:text>
							</xsl:when>
						<!--<xsl:when test="$cellNum=3or$cellNum=4or$cellNum=5">-->
							<xsl:when test="$cellNum=3or$cellNum=4">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>left</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<nobr>
						<xsl:choose>
							<xsl:when test="$cellNum='1'">
								<xsl:choose>
									<xsl:when test="../@KI='R' and ../@RTYPE='M' and ../@RIGHT='1'">
										<IMG SRC='../../../images/tree/m_report.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='R' and ../@RTYPE='M'  and ../@RIGHT='0'">
										<IMG SRC='../../../images/tree/m_report_no.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='R' and ../@RTYPE='R' and ../@RIGHT='1'">
										<IMG SRC='../../../images/tree/r_report.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='R' and ../@RTYPE='R' and ../@RIGHT='0'">
										<IMG SRC='../../../images/tree/r_report_no.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='R' and ../@RTYPE='P' and ../@RIGHT='1'">
										<IMG SRC='../../../images/tree/p_report.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='R' and ../@RTYPE='P' and ../@RIGHT='0'">
										<IMG SRC='../../../images/tree/p_report_no.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='F' and ../@RIGHT='1'">
										<IMG SRC='../../../images/tree/folder.gif'/>
									</xsl:when>
									<xsl:when test="../@KI='F' and ../@RIGHT='0'">
										<IMG SRC='../../../images/tree/folder_no.gif'/>
									</xsl:when>
									<xsl:otherwise>
										<IMG SRC='../../../images/tree/report.gif'/>
									</xsl:otherwise>
								</xsl:choose>
								<A href='javascript:;' style="text-decoration:none;color:black;margin-bottom:5px;" ondblclick='dblclickClickNode(this);'>
									<xsl:value-of select="." />
								</A>
							</xsl:when>
							<xsl:when test="($cellNum=3or$cellNum=4)and(.='○')">
								<input type="checkbox" value="1" checked="true" onclick="changeCheckBox(this,0);setChangeFlg();"/>
							</xsl:when>
							<xsl:when test="($cellNum=3or$cellNum=4)and(.='×')">
								<input type="checkbox" value="1" onclick="changeCheckBox(this,0);setChangeFlg();"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</nobr>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:for-each>


</TABLE>

</xsl:template>
</xsl:stylesheet>

