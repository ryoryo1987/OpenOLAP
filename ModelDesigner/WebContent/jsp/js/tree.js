//********��ʉE����p�ۑ�Obj*************
	// �E�N���b�N���j���[�uCut�v�őI�����ꂽ�I�u�W�F�N�g�̃Z���N�V����
	var cutObjectsId = null;
	// �E�N���b�N���̐e�I�u�W�F�N�g
	var cutParentObject = null;

// �h���b�O�J�n�I�u�W�F�N�g�̏����I�u�W�F�N�g id(judge navi_form or else)
var strDragStart = "";

//Click���ꂽ�C���[�W�̃I�u�W�F�N�g�����Ă����B
var preClickObj = null;
var preClickParentObj = null;
var preRightClickObj = new Object;

//preClickObj.src = "null";

//********* �L���[�u�J�X�^�}�C�Y�pALL�I�u�W�F�N�g�i�[ ********* (cubeSet.js)
var allIncRootNode = new Object;

// tree.js ���Ă΂ꂽ�ꏊ����"images"�f�B���N�g���ւ̑��΃p�X
var strImages = getImagesPath();

// Determinate reletive path for "images" folder.
function getImagesPath() {
	var strLoc = location.pathname;
	var strPath = "images";

//	var iPos = 1;							// except document root (/)
//	iPos = strLoc.indexOf("/",iPos) + 1;	// except context root (/OpenOLAP/)

//	while (true) {
//		iPos = strLoc.indexOf("/",iPos);
//		if (iPos<0) {
//			break;
//		} else {
//			strPath = "../" + strPath;
//			iPos++;
//		}
//	}

	//Objects.jsp��������ARoot
	if(strLoc.indexOf("objects.jsp")!=-1){
		strPath="images";
	}else{
		strPath="../../images";
	}
	return strPath;
}

function addMember(arg1,arg2,maxVal) {
var tempObj;
var addObj;

// Notice : "arg2" is not referenced now.
	addObj=createDivObj(maxVal);
	tempObj=document.createElement("<img id='5' src='"+strImages+"/L.gif' onclick=JavaScript:Toggle('TP',this,'');>");
		addObj.appendChild(tempObj);
	tempObj=createImageObj(maxVal);
		addObj.appendChild(tempObj);
	tempObj=createAhrefObj(maxVal,arg1);
		addObj.appendChild(tempObj);
	tempObj=createDivC_Obj(maxVal);
		addObj.appendChild(tempObj);
		preClickObj.lastChild.appendChild(addObj);
	allLoop(preClickObj,'ALL');
}

function renMember(key,arg1,arg2) {
var tempObj;
var workObj;
var iCount = 0;

	// not use 'arg2'

	tempObj = preClickObj;
	if (tempObj.lastChild.hasChildNodes()) {
		workObj = tempObj.lastChild.firstChild;
		while (true) {
			if (workObj.id==key) {
				// rename "innerHTML" - cube name
				workObj.lastChild.previousSibling.innerHTML = arg1;
				break;
			}
			if (workObj.id==tempObj.lastChild.lastChild.id) {
				break;
			} else {
				workObj = workObj.nextSibling;
			}
		}
	}
	return;
}



//**********************************************************************
//******************************* Drag & Drop (Tree -> Table )
//**********************************************************************
var srcObj = new Object;

// string to hold source of object being dragged:
var dummyObj;

var startDragNodeObj;//������E�ւ̃h���b�O�h���b�v�Ŏg�p

function startDrag(){
//	document.activeElement.className = "selected";

	strDragStart = "TREE_FRAME";
	startDragNodeObj = window.event.srcElement.parentNode;

	// get what is being dragged:
//	srcObj = window.event.srcElement;
    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
//    dummyObj = srcObj.outerHTML;
    // post the data for Windows:
    var dragData = window.event.dataTransfer;

    // set the type of data for the clipboard:
    dragData.setData('Text', window.event.srcElement.id);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';

}

function enterDrag() {
    // allow target object to read clipboard:
    window.event.dataTransfer.getData('Text');
}

function endDrag() {

    // when done remove clipboard data
    window.event.dataTransfer.clearData();
}

function overDrag() {
    // tell onOverDrag handler not to do anything:
	window.event.srcElement.className = 'dragOver';
}
function leaveDrag() {
	//window.event.srcElement.style.color = 'black';
	window.event.srcElement.className = 'dragEnd';
}

function drop() {

if (strDragStart == "") {
//	alert("cannot drop.");
	return;
}

var drop_id;//�z��ŁA�h���b�v���ꂽID������Ă����B
var temp_obj;//
var drop_id_txt = window.event.dataTransfer.getData('Text');//�J���}��؂��DropID
//alert(drop_id_txt);
var len_cnt = parent.right_frm.document.all.length - 0;//�E���̃h�L�������g�̂��ׂĂ̐��B�i��len_cnt�F����tree.xsl�̒��ł͗��p����Ă��Ȃ��ϐ��j
var j=0;//drop_id�̔z��̃J�E���g����ϐ�
var iCount=0;//drop_id�̔z��̃J�E���g����ϐ�

var folder_flg = false;
	if(drop_id_txt==null){
		return;
	}
	drop_id = drop_id_txt.split(',');//�z��ŁA�i�[

if (id_check1(drop_id, window.event.srcElement.parentNode)) {
	//	alert("OK - id_check1");
} else {
	//alert("NG - id_check1");


//	alert("Cannot move to " + window.event.srcElement.id + " : The source can't be dropped within source itself.");

	window.event.srcElement.className = 'dragEnd';
	return;
}

if (id_check2(drop_id, window.event.srcElement.parentNode)) {
	//	alert("OK - id_check2");
} else {
	//alert("NG - id_check2");

//	alert("Cannot move to " + window.event.srcElement.id + " : The source can't be dropped within souce itself.");

	window.event.srcElement.className = 'dragEnd';
	return;
}


if (!is_from_navi_form()) { // �E�e�[�u������̃h���b�O���h���b�v�̏ꍇ
	var rightTempObj;//�E��Drag���ꂽ����
	var rightTempImg;//�E��Drag���ꂽImage�i�����ɁA����������B�j
	var addNodeObj;
	for(j=0;j<drop_id.length;j++){
		rightTempObj=parent.right_frm.document.getElementById(drop_id[j]);
	//	if (rightTempObj.kind=="D"){//Dir��������폜�̑O�ɍ���Tree�𑀍�B
		if (rightTempObj.kind=="D"||rightTempObj.kind=="V"){//Dir��������폜�̑O�ɍ���Tree�𑀍�B
			var childFolder;//�ړ�������́i�h���b�O���ꂽID�ɑΉ�����Tree����Object�j
			for(x=0;x<preClickObj.lastChild.childNodes.length;x++){
				if (preClickObj.lastChild.childNodes[x].id==drop_id[j]){
					childFolder = preClickObj.lastChild.childNodes[x];

//alert("childFolder.id : "+childFolder.id);

					//Drop���ꂽ�����̍Ō�̎q���Ƃ��āA���������AElement�Ƃ��āA�}������B
					insertAdjustPosition(window.event.srcElement.parentNode,childFolder);

		//			preClickObj.lastChild.removeChild(childFolder);//�O�̏ꏊ�����菜��
		//			//Drop���ꂽ�����̍Ō�̎q���Ƃ��āA���������AElement�Ƃ��āA�}������B
		//			insertAdjustPosition(window.event.srcElement.parentNode,childFolder);

				}
			}
		}//�����܂łŁA�t�H���_���L�̏������I���B********************************************************

		//������A�폜����B
		rightTempObj.parentNode.removeChild(rightTempObj);
	}

/////*******************���W���[����***************************
	allLoop(window.event.srcElement.parentNode,'ALL');//�t��������
	allLoop(preClickObj,'ALL');//��菜����鑤
/////**********************************************************

//***********************************
	//�X�V�phidden���ڂɁA�i�[
	//�X�V�����ׂ����R�[�h
	document.navi_form.child_record.value = drop_id_txt;
	//�X�V�����ׂ��e�̃R�[�h
	document.navi_form.parent_record.value = window.event.srcElement.id;

//alert("�q�@"+document.navi_form.child_record.value);
//alert("�e�@"+document.navi_form.parent_record.value);

	document.navi_form.target="update_tree_frm";
	//document.navi_form.action="update_tree_data.jsp";
	document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";

//	//Tree��ʑΉ�
//	if (document.navi_form.typ.value == "1") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** customized hierarchy ****
//		// *********************************************************************
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else if (document.navi_form.typ.value == "2") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** segmentation hierarchy ****
//		// *********************************************************************
//		//�܂����Ή�
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** ���̑� ****
//		// *********************************************************************
//		//�܂����Ή�
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	}

	document.navi_form.submit();
//***********************************

} else { // �E�e�[�u������̃h���b�O���h���b�v�̏ꍇ(end)

	// �����c���[���ł̃h���b�O���h���b�v�̏ꍇ
	leftTreeMove(window.event.srcElement.parentNode);

}	// �����c���[���ł̃h���b�O���h���b�v�̏ꍇ(end)

	window.event.srcElement.className = 'dragEnd';


} 
//**************************************** drop() end

function leftTreeMove(dropNode){
	// startDragNodeObj; //::�h���b�v���m�[�h�i�h���b�O���Ă������́j
	var srcParentNode = startDragNodeObj.parentNode.parentNode; //::�h���b�v���i�h���b�O���Ă������́j�̐e�m�[�h
	var dstObj = dropNode; //::�h���b�v��
	srcParentNode.lastChild.removeChild(startDragNodeObj);//�O�̏ꏊ�����菜��
	//Drop���ꂽ�����̍Ō�̎q���Ƃ��āA���������AElement�Ƃ��āA�}������B
	insertAdjustPosition(dstObj,startDragNodeObj);

	allLoop(dstObj,'ALL');//�t��������
	allLoop(srcParentNode,'ALL');//��菜����鑤

	document.navi_form.child_record.value = startDragNodeObj.id;
	//�X�V�����ׂ��e�̃R�[�h
	document.navi_form.parent_record.value = dropNode.id;

	document.navi_form.target="update_tree_frm";
	//document.navi_form.action="update_tree_data.jsp";
	document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";

//	//Tree��ʑΉ�
//	if (document.navi_form.typ.value == "1") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** customized hierarchy ****
//		// *********************************************************************
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else if (document.navi_form.typ.value == "2") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** segmentation hierarchy ****
//		// *********************************************************************
//		//�܂����Ή�
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** ���̑� ****
//		// *********************************************************************
//		//�܂����Ή�
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	}

	document.navi_form.submit();
////////

//--�E��ʘA�g�X�V
	parent.right_frm.SpreadForm.target="_self"
	//parent.right_frm.tree_table_form.action="treeTable.jsp?id=" + preClickObj.id;
//	//Tree��ʑΉ�
//	parent.right_frm.tree_table_form.action="cust_dim_tree_table.jsp?typ=" + document.navi_form.typ.value + "&id=" + preClickObj.id;
	parent.right_frm.SpreadForm.action="cust_dim_tree_table.jsp?id=" + preClickObj.id;
//alert(parent.right_frm.SpreadForm.action);
	parent.right_frm.SpreadForm.submit();
}

function mouseDown() {
//	document.activeElement.className = "selected";
}

/////rightClick*********************************
//////�E���ŏ����ꂽ�ꍇ�A����Tree������폜����B�i�E����Ă΂��B�j
function rightObjDelete() {
var deleteId;
var i,j;

	deleteId = parent.right_frm.SpreadForm.hid_delete_key.value.split(",");
	for (i=0; deleteId.length>i ;i++){
		if(preClickObj.lastChild.hasChildNodes()){

			for(j=0;preClickObj.lastChild.childNodes.length>j;j++){
				if(deleteId[i]==preClickObj.lastChild.childNodes[j].id){
					//�폜
					preClickObj.lastChild.removeChild(preClickObj.lastChild.childNodes[j]);
				}
			}
		}
	}

	allLoop(preClickObj,'ALL');
}

//*******************************************���ʕϐ���n��
function getpreClickObj() {
	return preClickObj;
}
// Cut ���ꂽ�I�u�W�F�N�g���܂ރc���[�m�[�h�̎擾�Ɛݒ�
function setCutObjects(SeleText) {
	cutObjectsId=SeleText;
	cutParentObject=preClickObj;
}
function getCutObjects() {
	return cutObjectsId;
}
function getCutParentObject() {
	return cutParentObject;
}

function getPasteAble(){
	if (cutObjectsId!=null && cutParentObject!=null && cutParentObject!=preClickObj){
		return true;
	}else{
		return false;
	}
}

function is_from_navi_form() {
	if (strDragStart == "TREE_FRAME") {
		strDragStart = "";
		return true;
	} else if (strDragStart == "TABLE_FRAME") {
		strDragStart = "";
		return false;
	} else {
		// error trap

//alert("is_from_navi_from() error.");

	}
}


// �`�F�b�N�P�Fdestination �� source �̎q���ł��邱�Ƃ͋ւ���
function id_check1(drop_ids, evt_srcElmnt_pNode) {
	//drop_ids �� "�h���b�v��(src)" �� id
	var work_obj = evt_srcElmnt_pNode;		// "�h���b�v��(src)" �̃I�u�W�F�N�g(Div) �m�[�h
	var work_id = evt_srcElmnt_pNode.id;	// "�h���b�v��(src)" �� id = "�h���b�v��(src)" �� (Div) �� id
	var jCount;
	while (work_id != "root") {
		// "�h���b�v����ID"=="�h���b�v���ID" �̏ꍇ�͉������Ȃ�
		for (jCount=0; jCount<drop_ids.length; jCount++) {
			//alert("drop_id["+jCount+"]="+drop_ids[jCount]);
			if (drop_ids[jCount] == work_id) {
				//alert("[id_check] Cannot move " + drop_ids[jCount] + ": The source and destination id is the same.");
				return false;	// NG
			}
		}
		work_obj = work_obj.parentNode.parentNode;	// ���̐e�I�u�W�F�N�g (Div)
		work_id = work_obj.id;
	}
	return true;	// OK
}

// �`�F�b�N�Q�Fdestination �� source �������ɂȂ�i�ړ����Ă��ς��Ȃ��j���Ƃ͋ւ���
function id_check2(drop_ids, evt_srcElmnt_pNode) {
//alert(drop_ids);

//	if(evt_srcElmnt_pNode==preClickObj){
//		alert("�����ꏊ");
//		return;
//	}

	//drop_ids �� "�h���b�v��(src)" �� id
	var work_obj2 = evt_srcElmnt_pNode;		// "�h���b�v��(src)" �̃I�u�W�F�N�g(Div) �m�[�h
	var work_id2 = evt_srcElmnt_pNode.id;	// "�h���b�v��(src)" �� id = "�h���b�v��(src)" �� (Div) �� id
	var workobj3;
	var firstChildObj;
	var lastChildObj;
	var kCount;
	var lCount;

	if (!work_obj2.lastChild.hasChildNodes()) {
		// �h���b�v��̍Ō�̎q�m�[�h�̎q�m�[�h�������ꍇ�́A�h���b�v�����d�Ȃ�Ȃ��̂ŁA�n�j
		return true; // OK
	} else {
		// �h���b�v��̍Ō�̎q�m�[�h�̎q�m�[�h������ꍇ�́A�h���b�v�����d�Ȃ�\���𔻒�
		firstChildObj = work_obj2.lastChild.firstChild;
		lastChildObj = work_obj2.lastChild.lastChild;
		work_obj3 = firstChildObj;
		lCount = 0; // �q�m�[�h�̐�
		while (true) { // �������[�v�쐬
			lCount++;
			for (kCount=0; kCount<drop_ids.length; kCount++) {
				if (drop_ids[kCount] == work_obj3.id) {
					// �h���b�v���ƃh���b�v���ID���d�Ȃ�ꍇ�͂m�f
					return false;	// NG
				}
			}
			if (work_obj3.id == lastChildObj.id) {
				return true; // LOOP OUT (OK)
			} else {
				work_obj3 = work_obj3.nextSibling; // NEXT TRY
			}
		}
	}
}



//***************** Module
// public variable
//************Loop Module**************
function allLoop(node,proc) {
	// all loop include node & child & Sibling
	var startNode = node;

	if(proc=='ALL'){
		levelAdjust(startNode);
		pmLTAdjust(startNode);
	}else if(proc=='LEVEL'){
		levelAdjust(startNode);
	}else if(proc=='PMLT'){
		pmLTAdjust(startNode);
	}

	while (true) {
		// child
		if (startNode.lastChild.hasChildNodes()) {
			allLoop(startNode.lastChild.firstChild,proc);
		}

		// Sibling
		if (startNode.nextSibling != null) {
			startNode = startNode.nextSibling;
				if(proc=='ALL'){
					levelAdjust(startNode);
					pmLTAdjust(startNode);
				}else if(proc=='LEVEL'){
					levelAdjust(startNode);
				}else if(proc=='PMLT'){
					pmLTAdjust(startNode);
				}

		} else {
			break;
		}
	}
}


function thisAndPreviousNode(node,proc) {
	var startNode = node;

	//�e��PlusMinus���ύX����B
	pmLTAdjust(startNode.parentNode.parentNode);

	allLoop(startNode,proc);
	if (startNode.previousSibling!=null){
		startNode=startNode.previousSibling;
	}else{
		return;
	}
	allLoop(startNode,proc);

}
//�����ƁA���̍Ō�̎q��������������B
function thisAndLastChildNode(node,proc) {

	var startNode = node;
	//�e��PlusMinus���ύX����B
	if(proc=='ALL'){
//alert(startNode.outerHTML);
		levelAdjust(startNode);
		pmLTAdjust(startNode);
	}else if(proc=='LEVEL'){
		levelAdjust(startNode);
	}else if(proc=='PMLT'){
		pmLTAdjust(startNode);
	}

//alert("start");
//alert(startNode.outerHTML);
	if(startNode.lastChild.hasChildNodes()){
//alert(startNode.outerHTML);
		startNode = startNode.lastChild.lastChild;
//alert(startNode.outerHTML);
		allLoop(startNode,proc);
	}
}

//************adjust node**************
function levelAdjust(node) {
	var oDiv;
	var clcLevelNode;
	var Cnode=node;

	for(x=0;x<Cnode.childNodes.length;x++){///�K�w�����Ƃ�̂����B
		if(Cnode.childNodes[0].id=="root"){
			break;
		}else if(Cnode.childNodes[0].id=="H"){//ID=H �� blank or I gif
			Cnode.removeChild(Cnode.childNodes[0]);//��菜���Ă����̂ŁA�C���f�b�N�X�͏�ɍŏ��̂��́��O
			x--;//////Cnode.childNodes.length�̐�����菜���ƕς�邽�߁B
		}else{
			break;
		}
	}
	//�K�w�̐[�������߂鏈��
	clcLevelNode = node.parentNode.parentNode;//�ŏ��ɐe(ID='�ԍ�-C')�̐e(Id='�ԍ�')�Ɉڂ�B
	oDiv=document.createElement("<img id='dummy' src='"+strImages+"/I.gif'/>");
	while(clcLevelNode.tagName=="DIV" && clcLevelNode.id!="root"){
		if(clcLevelNode.nextSibling == null){
			oDiv = document.createElement("<img id='H' src='"+strImages+"/blank.gif'/>");
		}else{
			oDiv = document.createElement("<img id='H' src='"+strImages+"/I.gif'/>");
		}
		node.firstChild.insertAdjacentElement('BeforeBegin',oDiv);
		clcLevelNode = clcLevelNode.parentNode.parentNode;
	}
}


function pmLTAdjust(node) {//Plus Minus L T Adjust
	if(node.id=='root'){
		return;
	}

	var pmLTimage = node.lastChild.previousSibling.previousSibling.previousSibling;
    //                  .-C       .A              .image          .pmLTimage

	if (node.nextSibling == null) { //L
		if(node.lastChild.hasChildNodes()==true){
			pmLTimage.src=strImages+'/Lplus.gif';
		}else{
			pmLTimage.src=strImages+'/L.gif';
		}
	}else{ //T
		if(node.lastChild.hasChildNodes()==true){
			pmLTimage.src=strImages+'/Tplus.gif';
		}else{
			pmLTimage.src=strImages+'/T.gif';
		}
	}

	if(node.lastChild.style.display=='none'){
		pmLTimage.src=pmLTimage.src.replace('minus.gif','plus.gif');
	}else{
		pmLTimage.src=pmLTimage.src.replace('plus.gif','minus.gif');
	}

}
//Node�̖��́iA Href�j�̕���������������B
function updateNodeName(node,objId,objName,kind){
	if (kind=='THIS'){
		node.lastChild.previousSibling.innerHTML=objName;
	}else if(kind=='CHILD'){
		for(i=0;i<node.lastChild.childNodes.length;i++){
//alert(node.outerHTML);
//alert('objid'+objId);
//alert('nodeId'+node.lastChild.childNodes[i].id);
			if(node.lastChild.childNodes[i].id==objId){
				node.lastChild.childNodes[i].lastChild.previousSibling.innerHTML=objName;
				return;
			}
		}
	}
}

function reverseImage(node) {
	var nodeImage = node.lastChild.previousSibling.previousSibling;
    //                  .-C       .A              .image
	if(node.lastChild.style.display=='none'){//show child ?
		nodeImage.src = nodeImage.src.replace('2.gif','1.gif');
	}else{
		nodeImage.src = nodeImage.src.replace('1.gif','2.gif');
	}
}

function reversePM(node) {//Plus Minus change//���g�p
	var pmLTimage = node.lastChild.previousSibling.previousSibling.previousSibling;
    //                  .-C       .A              .image          .pmLTimage
	if(node.lastChild.style.display=='none'){//show child ?
		pmLTimage.src=pmLTimage.src.replace('plus.gif','minus.gif');
	}else{
		pmLTimage.src=pmLTimage.src.replace('minus.gif','plus.gif');
	}
}

function reverseDisplay(node) {//style.display change
	if(node.lastChild.style.display=='none'){//show child ?
		node.lastChild.style.display='block';
	}else{
		node.lastChild.style.display='none';
	}
}

function reversePreNextImage(th){

	if(preClickObj!=th){//�ŏ��́APreClick�ɉ��������Ă��Ȃ��B
		if(preClickObj!=null){
			var preImage = preClickObj.lastChild.previousSibling.previousSibling;
		    //                 .-C       .A              .image
			preImage.src=preImage.src.replace('1.gif','2.gif');
		}

		var thImage = th.lastChild.previousSibling.previousSibling;
	    //                 .-C       .A              .image
		thImage.src=thImage.src.replace('2.gif','1.gif');
	}
}

//*************** Sort *******************
function insertAdjustPosition(addNode,node) {
var preNode=null;
	for (i=0;i<addNode.lastChild.childNodes.length;i++) {
		if(addNode.lastChild.childNodes[i].id>node.id){
			break;
			//return preNode;//���̑O�ɂ���B
		}
		preNode = addNode.lastChild.childNodes[i];
	}

	if(preNode==null){
		if (addNode.lastChild.hasChildNodes()){
			addNode.lastChild.firstChild.insertAdjacentElement("beforeBegin",node);
		}else{
			addNode.lastChild.appendChild(node);
		}
	}else{
		preNode.insertAdjacentElement("afterEnd",node);
	}
}

//Tree�̍X�V���ɁA�������Click������B�i�E��ʂ̍X�V�I����Ă΂��j
function updateTreeObjToggle(tp){
	var upClickObj=null
	if(tp==0){//Insert
		upClickObj=preClickObj;
		preClickObj=null;//��x�N���A���Ȃ��Ɠ����ꏊ�́A�E�̃t�@�C�����X�V�ł��Ȃ��B�itp==0�p�j
	}else if(tp==1){//Update
		return;//none
	}else if(tp==2){//Delete
		upClickObj=preClickParentObj;
	}
	upClickObj.lastChild.previousSibling.click();
	upClickObj.lastChild.previousSibling.focus();
}

//******************************************
function Toggle(kind,node,file_name){

	
// �G���[�����ǉ�(�o�^�O�ɍ��c���[����֎~)
	if (location.pathname.indexOf("objects.jsp")!=-1 && kind!='TP'){//ObjectsJSP�̎������B���E��ʂ��ς��Ƃ������B
		var ret;
		if (document.navi_form.change_flg.value == 1) {
			//�j���m�F���b�Z�[�W�\��
			ret = showConfirm("CFM1");
// ���b�Z�[�W���ʉ��̂��ߎg�p���Ȃ�
//			ret = confirm("Are you sure you want to cancel the changes you made?");

			//�j�����܂�=Yes�̎�,��ʐ���p�t���O=0��Reset����
			if (ret == true) {
				document.navi_form.change_flg.value = 0;
			} else {
				//�j�����Ȃ��ꍇ����������
				return;
			}
		}
	}

	document.navi_form.seqId.value=node.id;
	document.navi_form.objKind.value=node.objkind;

	divNode = node.parentNode;

	// Unfold the branch if it isn't visible
	if(node.tagName=='IMG'){
		if(kind=='f' || kind=='0'){
			reversePreNextImage(divNode);
			reversePM(divNode);
			reverseDisplay(divNode);
		}else if(kind=='r'){//ROOT
			reversePreNextImage(divNode);
			reverseDisplay(divNode);
		}else{//�v���X�}�C�i�X�N���b�N
			reversePM(divNode);
			reverseDisplay(divNode);
			return;
		}
		node.nextSibling.focus();
	}else{// A href
		reversePreNextImage(divNode);
	}

	//if preClickNode == clickNode then none
	if(preClickObj!=divNode){
		preClickObj = divNode;
		preClickParentObj = preClickObj.parentNode.parentNode;

		var folderName;
		if(document.URL.indexOf("objects.jsp")==-1){
			folderName="";
		}else{
			folderName="jsp/";
		}
		document.navi_form.target = "right_frm";
		document.navi_form.action = folderName + file_name;
		document.navi_form.submit();
	}

}

function ToggleDblClick(kind,node,file_name){
return;

/*
//DEBUG  �G���[�����ǉ�(�o�^�O�ɍ��c���[����֎~)
	if (location.pathname.indexOf("objects.jsp")!=-1){//ObjectsJSP�̎������B
		if (document.navi_form.change_flg.value == 1) {

// DebugMessage�Ƃ߂�(����function�g���ĂȂ�?)
//			alert("Error!--Error!--Error!");
//			return;
		}
	}

	divNode = node.parentNode;
	preClickObj = divNode;
	preClickParentObj = preClickObj.parentNode.parentNode;

	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
*/
}

