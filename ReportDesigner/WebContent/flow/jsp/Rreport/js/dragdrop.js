var eventSource=null;

var menuText;
var menuAction;

if(window.createPopup){
	var backgroundOutColor = "#dddddd";           //�}�E�X���O�ꂽ���̔w�i�F
	var backgroundOverColor = "#FFDCAF";          //�}�E�X����������̔w�i�F

	var divMenu = "";                    //���j���[���e
	var oPopup = window.createPopup();       //�|�b�v�A�b�v�I�u�W�F�N�g�쐬
	document.oncontextmenu = ContextMenu;                 //�E�N���b�N�C�x���g������
}

function ContextMenu(){
	eventSource=event.srcElement;
	var menuNum=3;//////Default�l
	obj=eventSource;
//	while(obj.tagName!="BODY"){//SourceElement�ɂ��A�o�����j���[��ς���B
//		if((obj.tagName=="TR")&&(obj.attributes.getNamedItem("ID").value!="")){
//			menuNum=menuText.length;
//			break;
//		}
//		obj=obj.parentNode;
//	}

	//Col�̎��A�ړ��A�폜���j���[���ł�B
	if((obj.tagName=='A' && obj.parentNode.objkind=='sqlcol')){
		menuText = new Array("���ړ�","���ړ�","�폜");
		menuAction = new Array("moveNode('up')","moveNode('down')","deleteNode('col')");
	}else if(obj.tagName=='A' && obj.parentNode.objkind=='where_clause'){
		menuText = new Array("���ړ�","���ړ�","�폜");
		menuAction = new Array("moveNode('up')","moveNode('down')","deleteNode('where')");
	}else{
		return;
	}

	divMenu = '<DIV STYLE="border:1px solid #333333;border-right:0;background:' + backgroundOutColor + ';">';

		//���j���[���e�쐬
	for(count = 0; count < menuText.length; count++){
		divMenu +='<DIV onmouseover="this.style.background=\'' + backgroundOverColor + '\';" onmouseout="this.style.background=\'' + backgroundOutColor + '\';" onclick="parent.' + menuAction[count] + '" style="font-size:11px;height:20px; padding-left:3px;padding-top:5px; cursor:hand; border-bottom:1px solid #333333; border-right:1px solid #333333">' + menuText[count] + '</DIV>';
	}
	divMenu += '</DIV>';

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
//*******************************************************************************
function moveNode(direction){
	var th = eventSource.parentNode;
//alert(eventSource.a.:active);
	var srcXmlNode = xmlData.selectSingleNode("//*[@id='"+th.id+"']")
	var dragNode;
	var dropNode;

	if(direction=='up'){
		if(srcXmlNode.previousSibling==null){
			return;
		}
		dragNode=srcXmlNode;
		dropNode=srcXmlNode.previousSibling;
//alert(dropNode.xml);
	}else if(direction=='down'){
		if(srcXmlNode.nextSibling==null){
			return;
		}
		dragNode=srcXmlNode.nextSibling;
		dropNode=srcXmlNode;
	}

	dragNode.parentNode.insertBefore(dragNode,dropNode);//Drop�̑O�ɒǉ�

	//Tree��ʕ\��
	reloadTree(dragNode.parentNode,th.parentNode.parentNode);

	//��ʕ\��
	createRowTag();//XML��RowTag(Database����)���쐬
	parent.parent.frm_backNext.mappingScreenDisplay();

	//�Y��������Active�ɂ���B
	var srcDiv = document.getElementById(th.id);
	var srcAhref = srcDiv.lastChild.previousSibling;
	srcAhref.setActive();
	eventSource=srcAhref;
}

function deleteNode(kind){
	var th = eventSource.parentNode;
//	if(kind=='col'){
//		srcXmlNode = xmlData.selectSingleNode("//*[@id='"+th.id+"']")
//	}else if(kind=='where'){
//		srcXmlNode = xmlData.selectSingleNode("//*[@id='"+th.id+"']")
//	}
		srcXmlNode = xmlData.selectSingleNode("//*[@id='"+th.id+"']");
		var pNode=srcXmlNode.parentNode;
		pNode.removeChild(srcXmlNode);

		reloadTree(pNode,th.parentNode.parentNode);

		//��ʕ\��
		createRowTag();//XML��RowTag(Database����)���쐬
		parent.parent.frm_backNext.mappingScreenDisplay();
	oPopup.hide(); 
}
//*********************************************************




//document.body.ondragover=searchDragObj;
//document.body.ondrop=drop;

//function searchFrame(){
//	alert(document.name);
//	alert(document.parentWindow.name);
//	alert(document.parentWindow.parentWindow.name);
//}
//*******************************************************************************
//*********************************************************
function startDragListToList(){
//alert();
//alert(window.event.srcElement.outerText);

    // get what is being dragged:
    srcObj = window.event.srcElement;

    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
    dummyObj = srcObj.outerHTML;

    // post the data for Windows:
    var dragData = window.event.dataTransfer;

    // set the type of data for the clipboard:
	var argStr;
	argStr  = "fromList";
	argStr += ':'+ window.event.srcElement.parentNode.id;
	argStr += ':'+ window.event.srcElement.outerText;
	argStr += ':'+ window.event.srcElement.parentNode.objkind;
//alert(argStr);

    dragData.setData('Text',argStr);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';
}




function enterDrag() {//�C�x���g�����̂��߂ɕK�v
    // allow target object to read clipboard:
//    window.event.dataTransfer.getData('Text');
}

//function endDrag() {
//    // when done remove clipboard data
//    window.event.dataTransfer.clearData();
////�����t���[�����ł����C�x���g���������B
//alert("end");
//}

//function searchDragObj(){
////document.form_main.flg.value=event.srcElement.outerText;
////alert(":"+event.srcElement.outerText+":");
//	if(event.srcElement.outerText=='�\��1'){
//
////    var dragData = window.event.dataTransfer;
////    dragData.effectAllowed = 'copy';
////		event.srcElement.style.cursor='no-drop';
////		document.form_main.flg.value=event.srcElement.style.cursor;
//		overDrag();
//		enterDrag()
//	}
//}

function getDropPoss(objKind,dropKind,dbText){

	//������E  ��ނɂ�蔻�f
	if(objKind=='logical_column'){//�ʏ�̃J����
		if(dropKind=='sqlcol' || dropKind=='sql'){
			return true;
		}
	}else if(objKind=='logical_model'){//�_��Table
		if(dropKind=='sql'){
			return true;
		}
	}else if(objKind=='RDBModel' && (dbText.indexOf("��������")!=-1)){//��������
		if(dropKind=='screenSql'){
			return true;
		}
	}else if(objKind=='RDBModel' && (dbText.indexOf("���o����")!=-1)){//���o����
		if(dropKind=='sql'){
			return true;
		}
	}else if(objKind=='logical_condition'){//����
		if(dropKind=='screenSql' || dropKind=='where_clause'){
			return true;
		}
	}

	//�E����E  ��ނɂ�蔻�f
	if(objKind=='sqlcol'){//�ʏ�̃J����
		if(dropKind=='sqlcol'){
			return true;
		}
	}
	return false;
}

function overDrag() {
    // tell onOverDrag handler not to do anything:

//window.event.dataTransfer.getData('Text')+'::'+window.event.srcElement.tagName);
	var objKind = window.event.dataTransfer.getData('Text').split(":")[3];
	var dropKind = window.event.srcElement.parentNode.objkind;
	var dbText = window.event.dataTransfer.getData('Text').split(":")[2];

	if(getDropPoss(objKind,dropKind,dbText)){
		window.event.srcElement.className = 'dragOver';
	    window.event.returnValue = false;
		event.srcElement.style.cursor='auto';
	}
}
function leaveDrag() {
	event.srcElement.style.cursor='auto';
	//window.event.srcElement.style.color = 'black';
	window.event.srcElement.className = 'dragEnd';
}


function drop() {
	window.event.srcElement.className = 'dragEnd';
	var dropKind = window.event.srcElement.parentNode.objkind;

	//Node��Text���擾
	var dbText = window.event.dataTransfer.getData('Text').split(":")[2];
	var dbId = window.event.dataTransfer.getData('Text').split(":")[1];
	var objKind = window.event.dataTransfer.getData('Text').split(":")[3];

	if(getDropPoss(objKind,dropKind,dbText)==false){
		return;//�Y���ꏊ�ł͂Ȃ��B
	}

	if(window.event.dataTransfer.getData('Text').split(":")[0]=="fromList"){
		//��ID�̎擾
		var dragId = window.event.dataTransfer.getData('Text').split(":")[1];
		var dragNode = xmlData.selectSingleNode("//*[@id='"+dragId+"']")
		//��ID�̎擾
		var dropId = window.event.srcElement.parentNode.id;
		var dropNode = xmlData.selectSingleNode("//*[@id='"+dropId+"']")
		dragNode.parentNode.insertBefore(dragNode,dropNode);//Drop�̑O�ɒǉ�

	//Tree��ʕ\��
	reloadTree(dragNode.parentNode,window.event.srcElement.parentNode.parentNode.parentNode);

	//��ʕ\��
	createRowTag();
	parent.parent.frm_backNext.mappingScreenDisplay();

		return;
	}
//*******************List���ł̓���ւ�(�����܂�)************************
	if(objKind=='logical_column'){//Select


		var sqlXML = parent.frm_mapping_db.getDbXML();
		var logicalNode = sqlXML.selectSingleNode("//*[@id='"+dbId+"']");
		var dbText = logicalNode.selectSingleNode(".//name").text;
		var dbId = logicalNode.getAttribute("id");
		var dbType = logicalNode.selectSingleNode(".//att1").text;

		//XML�������ɓ������O��t�����Ȃ����߁A�������O���ǂ������f
		var sameName = xmlData.selectSingleNode("//sqlcol[@name='"+dbText+"']");
		if(sameName!=null){
			dbText = getNewName(dbText);
		}
		//XML���擾
		var srcId = window.event.srcElement.parentNode.id;
		var xmlNode = xmlData.selectSingleNode("//*[@id='"+srcId+"']")
		if (xmlNode.getAttribute("id")=="sql"){
			//�ǉ�
			var newId = getNewId();//�V����ID���擾

			var strXML = "<sqlcol id='"+newId+"' name='"+dbText+"' datatype='"+dbType+"' cellformat='str' dbId='"+dbId+"'/>";
			var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
			XMLTemp.async = false;
			XMLTemp.loadXML(strXML);
			XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
			xmlNode.appendChild(XMLTemp);
		}else{
			//XML����������
			xmlNode.setAttribute("name",dbText);
			xmlNode.setAttribute("dbId",dbId);
			xmlNode.setAttribute("datatype",dbType);
		}
		delDefaultNodes(xmlData);

//alert(xmlData.xml);
//alert(window.event.srcElement.parentNode.outerHTML);
		//Tree��ʕ\��
		if (xmlNode.getAttribute("id")=="sql"){
			reloadTree(xmlNode,window.event.srcElement.parentNode);
		}else{
			reloadTree(xmlNode.parentNode,window.event.srcElement.parentNode.parentNode.parentNode);
		}
		//��ʕ\��
		createRowTag();
		parent.parent.frm_backNext.mappingScreenDisplay();
	}else if(objKind=='logical_condition'){//where
//		delDefaultNodes(xmlData);

		var srcId = window.event.srcElement.parentNode.id;
		var xmlNode = xmlData.selectSingleNode("//*[@id='"+srcId+"']");

		//�����̂�����΁A�ǉ��͂ł��Ȃ��B
		var sameId = xmlData.selectSingleNode("//*[@dbId='"+dbId+"']");
		if(sameId!=null){
			alert("�������̂����łɂ���܂��B");
			return;
		}

		if (xmlNode.getAttribute("id")=="screenSql"){
			var strXML = "<where_clause id='"+dbId+"' dbId='"+dbId+"' name='"+dbText+"'/>";
			var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
			XMLTemp.async = false;
			XMLTemp.loadXML(strXML);
			XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
			xmlNode.appendChild(XMLTemp);
		}else{
			//XML����������
			xmlNode.setAttribute("name",dbText);
			xmlNode.setAttribute("dbId",dbId);
			xmlNode.setAttribute("id",dbId);
		}
		//Tree��ʕ\��
		reloadTree(xmlNode,window.event.srcElement.parentNode);

		//��ʕ\��
		createRowTag();
//		parent.parent.frm_backNext.mappingScreenDisplay();

	}else if(objKind=='logical_model'){//�_��Table��
		delDefaultNodes(xmlData);

		var sqlXML = parent.frm_mapping_db.getDbXML();
		var logicalColNodes = sqlXML.selectNodes("//logical_model[@name='"+dbText+"']/select_clause/logical_column");

		for(i=0;i<logicalColNodes.length;i++){
			var dbText = logicalColNodes.item(i).selectSingleNode(".//name").text;//childNodes[0].text;//name
			var dbId = logicalColNodes.item(i).getAttribute("id");
			var dbType = logicalColNodes.item(i).selectSingleNode(".//att1").text;

			//XML�������ɓ������O��t�����Ȃ����߁A�������O���ǂ������f
			var sameName = xmlData.selectSingleNode("//sqlcol[@name='"+dbText+"']");
			if(sameName!=null){
				dbText = getNewName(dbText);
			}

			//XML���擾
			var srcId = window.event.srcElement.parentNode.id;
			var xmlNode = xmlData.selectSingleNode("//*[@id='"+srcId+"']")
			//�ǉ�
			var newId = getNewId();//�V����ID���擾

			var strXML = "<sqlcol id='"+newId+"' name='"+dbText+"' datatype='"+dbType+"' cellformat='str' dbId='"+dbId+"'/>";
			var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
			XMLTemp.async = false;
			XMLTemp.loadXML(strXML);
			XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
			xmlNode.appendChild(XMLTemp);
		}

		//Tree��ʕ\��
		reloadTree(xmlNode,window.event.srcElement.parentNode);

		//��ʕ\��
		createRowTag();
		parent.parent.frm_backNext.mappingScreenDisplay();

	}else if(objKind=='RDBModel' && (dbText.indexOf("��������")!=-1)){//�������܂Ƃ߂�
//		delDefaultNodes(xmlData);

		var sqlXML = parent.frm_mapping_db.getDbXML();

		var logicalColNodes = sqlXML.selectNodes("//where_clause/logical_condition");
		//XML���擾
		var srcId = window.event.srcElement.parentNode.id;
		var xmlNode = xmlData.selectSingleNode("//*[@id='"+srcId+"']")

		for(i=0;i<logicalColNodes.length;i++){
			var dbText = logicalColNodes.item(i).selectSingleNode(".//name").text;//childNodes[0].text;//name
			var dbId = logicalColNodes.item(i).getAttribute("id");

			//�����̂�����΁A�ǉ��͂ł��Ȃ��B
			var sameId = xmlData.selectSingleNode("//*[@dbId='"+dbId+"']");
			if(sameId!=null){
			}else{

				var strXML = "<where_clause id='"+dbId+"' dbId='"+dbId+"' name='"+dbText+"'/>";
				var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
				XMLTemp.async = false;
				XMLTemp.loadXML(strXML);
				XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
				xmlNode.appendChild(XMLTemp);
			}
		}

		//Tree��ʕ\��
		reloadTree(xmlNode,window.event.srcElement.parentNode);

		//��ʕ\��
		createRowTag();
//		parent.parent.frm_backNext.mappingScreenDisplay();

	}else if(objKind=='RDBModel' && (dbText.indexOf("���o����")!=-1)){//Select������ׂĂ܂Ƃ߂�
		//���łɕ\��̂܂܂̂��̂��폜
		delDefaultNodes(xmlData);

		var sqlXML = parent.frm_mapping_db.getDbXML();
		var logicalColNodes = sqlXML.selectNodes("//select_clause/logical_column");

		for(i=0;i<logicalColNodes.length;i++){
			var dbText = logicalColNodes.item(i).selectSingleNode(".//name").text;//childNodes[0].text;//name
			var dbId = logicalColNodes.item(i).getAttribute("id");
			var dbType = logicalColNodes.item(i).selectSingleNode(".//att1").text;

			//XML�������ɓ������O��t�����Ȃ����߁A�������O���ǂ������f
			var sameName = xmlData.selectSingleNode("//sqlcol[@name='"+dbText+"']");
			if(sameName!=null){
				dbText = getNewName(dbText);
			}

			//XML���擾
			var srcId = window.event.srcElement.parentNode.id;
			var xmlNode = xmlData.selectSingleNode("//*[@id='"+srcId+"']")
			//�ǉ�
			var newId = getNewId();//�V����ID���擾

			var strXML = "<sqlcol id='"+newId+"' name='"+dbText+"' datatype='"+dbType+"' cellformat='str' dbId='"+dbId+"'/>";
			var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
			XMLTemp.async = false;
			XMLTemp.loadXML(strXML);
			XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
			xmlNode.appendChild(XMLTemp);
		}

		//Tree��ʕ\��
		reloadTree(xmlNode,window.event.srcElement.parentNode);

		//��ʕ\��
		createRowTag();
		parent.parent.frm_backNext.mappingScreenDisplay();
	}


}

function delDefaultNodes(xmlData){
	//���łɕ\��̂܂܂̂��̂��폜
	var delNodes = xmlData.selectNodes("//*[@dbId='0']");
	var pNode = null;
	for(i=0;i<delNodes.length;i++){
		pNode=delNodes.item(i).parentNode;
		pNode.removeChild(delNodes.item(i));
	}
}

function reloadTree(xmlNode,htmlNode){
//	alert(preClickObj);

	var nonDisp = document.getElementById("nonDisp");
	var strHTML = xmlNode.transformNode(cssXSL);
	nonDisp.innerHTML=strHTML;
//alert("html:"+strHTML);
	var addNode = nonDisp.firstChild;

	var tempNode=htmlNode.parentNode;
//alert("tempNode:"+tempNode.outerHTML);
//alert("addNode:"+addNode.outerHTML);
//alert("htmlNode:"+htmlNode.outerHTML);
	tempNode.insertBefore(addNode,htmlNode);
	tempNode.removeChild(htmlNode);

	parent.frm_mapping_property.displayScreenProperty();//Property��ʂ̍ĕ\��
}

function getNewId(){// Max 500
	var temp;
	for(x=1;x<500;x++){
		temp=xmlData.selectSingleNode("//*[@id='"+x+"']");
		if (temp==null){
			return x;
		}
	}
}

function getNewName(dbName){// Max 500
	var temp;
	for(y=1;y<100;y++){
		temp=xmlData.selectSingleNode("//sqlcol[@name='"+dbName+"--"+y+"--']");
		if (temp==null){
			return dbName+"--"+y+"--";
		}
	}
}

//*********************XML Row Tag���쐬************************
function createRowTag(){
	var xmlPattern = xmlData.selectSingleNode("//property/pattern");
	var pattern = xmlPattern.getAttribute("row");
	var strXML="";
	var tempStr="";
	var sqlCol = xmlData.selectNodes("//sqlcol");

	var xmlRow = xmlData.selectSingleNode("//data");
//alert("a");
	var xmlRows = xmlData.selectNodes("//data/row");
//alert(xmlRows.length);
		for (var k=0;k<xmlRows.length;k++){
//alert(xmlRow.xml);
//alert(xmlRows.item(k).xml);
		xmlRow.removeChild(xmlRows.item(k));
//alert(k);
	}

//alert("b");


	if (pattern=='simple'){
		strXML+="<row ";
		for (i=0;i<sqlCol.length;i++){
			tempStr=sqlCol.item(i).getAttribute("name");
//			tempStr=tempStr.replace(/ /g,"");
			strXML+=""+tempStr+"='"+"%%"+removeRepeatMark(tempStr)+"%%' ";
//alert(strXML);
		}
		strXML+="/>";
	}
//alert("c");

	//�������O�̑����͂����Ȃ��B
//alert("b-Str:"+strXML);
	var XMLTemp = new ActiveXObject("MSXML2.DOMDocument");
	XMLTemp.async = false;
	var a = XMLTemp.loadXML(strXML);

//alert(strXML);
	XMLTemp=XMLTemp.selectSingleNode("*");//�^�ϊ�
//alert("a:"+xmlRow.xml);
//alert("b:"+XMLTemp.xml);
	xmlRow.appendChild(XMLTemp);

}

//�����ɓ������O�������Ƃ���--�L�������O���B
function removeRepeatMark(argStr){
	var retStr=argStr;
	var tempStr="";
	var strLen = argStr.indexOf("--");
	if(strLen!=-1){
		tempStr=retStr.substr(0,strLen);
		tempStr+=retStr.substring(retStr.indexOf("--",strLen+2)+2);
		retStr=tempStr;
	}
	return retStr
}
