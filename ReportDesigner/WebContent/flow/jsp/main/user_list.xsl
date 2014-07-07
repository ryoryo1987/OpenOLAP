<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">


<xsl:comment>�\�[�g�����ݒ�</xsl:comment>
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
	var groupId = null;
	if(type==0){//�V�K
		objId = 0;
		groupId = "";
	}else if(type==1){//�ύX
		var obj=eventSource;
		while(obj.tagName!="BODY"){
			if(obj.tagName=="TR"){
				break;
			}
			obj=obj.parentNode;
		}
		objId = obj.attributes.getNamedItem("ID").value;
		groupId=obj.attributes.getNamedItem("GROUP").value;
	}else if(type.tagName=="TR"){//�_�u���N���b�N��
		objId = type.attributes.getNamedItem("ID").value;
		groupId=type.attributes.getNamedItem("GROUP").value;
	}
//	newWin = window.open("user_prpt.jsp?objId=" + objId + "&groupId=" + groupId,"_blank","menubar=no,toolbar=no,width=700px,height=500px,resizable");
	window.showModalDialog("user_prpt.jsp?objId=" + objId + "&groupId=" + groupId,self,"dialogHeight:500px; dialogWidth:650px");


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
//	alert(singleNode.xml);

	domReload(parent,self);

}

//�ړI�̃^�O�ɂȂ�܂Őe��H��
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



function domReload(frmXML,frmReload){//XML�y�[�W�ēǂݍ���
	frmReload.document.open();//�h�L�������g�̏�����
	var strResult = frmXML.XMLData.transformNode(frmXML.objXSL);
	frmReload.document.write(strResult);
}


var eventSource=null;


var menuText = new Array( "�V�K�쐬","�ύX","�폜");
var menuAction = new Array("winOpen(0)","winOpen(1)","delUser()");

if(window.createPopup){
	var backgroundOutColor = "#dddddd";           //�}�E�X���O�ꂽ���̔w�i�F
	var backgroundOverColor = "#FFDCAF";          //�}�E�X����������̔w�i�F

	var divMenu = "";                    //���j���[���e
	var oPopup = window.createPopup();       //�|�b�v�A�b�v�I�u�W�F�N�g�쐬
	divMenu = '<DIV STYLE="border:1px solid #333333;border-right:0; background:' + backgroundOutColor + ';">';

		//���j���[���e�쐬
	for(count = 0; count < menuText.length; count++){
		divMenu +='<DIV onmouseover="this.style.background=\'' + backgroundOverColor + '\';" onmouseout="this.style.background=\'' + backgroundOutColor + '\';" onclick="parent.' + menuAction[count] + ';" style="font-size:11px; height:20px; padding-left:3px;padding-top:5px; cursor:hand; border-bottom:1px solid #333333; border-right:1px solid #333333;">' + menuText[count] + '</DIV>';
	}
	divMenu += '</DIV>';
	document.oncontextmenu = ContextMenu;                 //�E�N���b�N�C�x���g������
}



function ContextMenu(){
//	alert(event.srcElement.tagName);
	eventSource=event.srcElement;
	var menuNum=1;
	obj=eventSource;
	while(obj.tagName!="BODY"){
		if((obj.tagName=="TR")&&(obj.attributes.getNamedItem("ID").value!="")){
			setChangeFlg();
			menuNum=menuText.length;
			if(obj.attributes.getNamedItem("ID").value=="1"){//userId��1�̏ꍇ�͍폜���j���[��\�����Ȃ�
				menuNum=menuNum-1;
			}
			break;
		}
		obj=obj.parentNode;
	}


	if(window.createPopup){
		var topper = event.clientX + 0;              //�|�b�v�A�b�v��\������X���W���擾
		var lefter = event.clientY + 0;              //�|�b�v�A�b�v��\������Y���W���擾
		oPopup.document.body.innerHTML = divMenu; //�|�b�v�A�b�v�ɕ\��������e��ݒ�
			//�|�b�v�A�b�v��\�����郁�\�b�h��call
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
			<!--mouseMove�֐�������xmlTable.js���ǂݍ��܂��̂͂�����onmousemove�C�x���g�����������Ȃ̂ŁAload.js���ŕʓronmousemove�C�x���g���A�^�b�`����B
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
			<xsl:choose>
				<xsl:when test="position()!='3'">
					<COL>
						<xsl:attribute name="style">width:<xsl:value-of select="width" />;</xsl:attribute>
					</COL>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</COLGROUP>

	<TR Spread="ColumnHeaderRow">
		<xsl:for-each select="rows/coldef/column">
			<xsl:choose>
				<xsl:when test="position()!='3'">
					<TD>
						<xsl:attribute name="onclick">sort('<xsl:value-of select="position()"/>','<xsl:value-of select="type"/>',this);</xsl:attribute>
						<xsl:value-of select="heading" />
					</TD>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<TD style="border:none;" class="adjustCell"></TD>
	</TR>
</xsl:template>




<xsl:template match="rows">

<TABLE id="DataTable" class="DataTable" cellspacing="0" cellpadding="2">
	<COLGROUP id="columngroup2">
		<xsl:for-each select="coldef/column">
			<xsl:choose>
				<xsl:when test="position()!='3'">
					<COL>
						<xsl:attribute name="style">width:<xsl:value-of select="width" />;</xsl:attribute>
					</COL>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</COLGROUP>



	<xsl:for-each select="/rows/row">
		<xsl:sort select="./value[number($Sort_select)]" data-type="{$Sort_datatype}" order="{$Sort_order}" />
		<xsl:variable name="rowNum" select="position()" />
		<tr>

			<xsl:attribute name="GROUP">
				<xsl:value-of select="@GROUP" />
			</xsl:attribute>

			<xsl:attribute name="ID">
				<xsl:value-of select="@ID" />
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

				<xsl:choose>

					<xsl:when test="position()!='3'">


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
								<xsl:choose>
									<xsl:when test="position()='4' and .='1'">
										�Ǘ���
									</xsl:when>
									<xsl:when test="position()='4' and .='2'">
										��ʃ��[�U�[
									</xsl:when>
									<xsl:when test="position()='4' and .='3'">
										�Q�X�g
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="." />
									</xsl:otherwise>
								</xsl:choose>
							</nobr>



						</td>

					</xsl:when>

				</xsl:choose>


			</xsl:for-each>
		</tr>
	</xsl:for-each>


</TABLE>

</xsl:template>
</xsl:stylesheet>

