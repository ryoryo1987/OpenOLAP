//Toggle() �̑�� 
function navi_click(kind,node) {
	document.navi_form.seqId.value=node.id;
	document.navi_form.objKind.value=node.objkind;

	//�q����ID�����ׂē���Ă����B!!! CURRENT SET (NOT ALL SET) for right table !!!
	var childLen = node.parentNode.lastChild.childNodes.length;
	var childValRight = "";
	for (i=0;i<childLen;i++){
		if(i==0){
			childValRight = node.parentNode.lastChild.childNodes[i].id;
		}else{
			childValRight = childValRight + "," + node.parentNode.lastChild.childNodes[i].id;
		}
	}
	document.navi_form.childId.value=childValRight;

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

		var folderName;
	//	if(document.URL.indexOf("objects.jsp")==-1){
			folderName="";
	//	}else{
	//		folderName="jsp/";
	//	}

		// ��⃊�X�g�E�ݒ胊�X�g�̕\��
		cube_set_display();
	}
}

//ToggleDblClick() �̑��
function navi_dbl_click(kind,node){
	divNode = node.parentNode;
	preClickObj = divNode;
	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
}

// ��⃊�X�g�i���j�E�ݒ胊�X�g�i�E�j�̕\��
function cube_set_display() {

	// �E�����X�g��HTML�̍쐬
	right_bdy_load();

	// �������X�g��HTML�̍쐬
	left_bdy_load();
}

// �E�����X�g��HTML�̍쐬
function right_bdy_load() {
	var myNode = preClickObj;
	var strrightTHTML = "<select name='lst_right' id='lst_right' size='7' multiple style='width:250;margin:0'>\n";
	if(myNode.lastChild.hasChildNodes()){
		for (iCount=0; iCount<myNode.lastChild.childNodes.length; iCount++) {
			strrightTHTML=strrightTHTML + "<option value='";
			strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].id + "'>";
			strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].lastChild.previousSibling.innerText + "</option>";
		}
	}
	strrightTHTML=strrightTHTML + "<select>";
	parent.parent.frm_main.document.form_main.all.div_right_move.innerHTML = strrightTHTML;


}

// �������X�g��HTML�̍쐬
function left_bdy_load() {
	//���݂�objKind, seqId���擾
	var reqKind = document.navi_form.objKind.value;
	var reqId = document.navi_form.seqId.value;

	//���ɑI�����ꂽ����
	var reqChildId = document.navi_form.childId.value;

	//Available Object�̃m�[�h��T��
	var myNode = searchNode(reqKind, reqId);

	// HTML�̍쐬
	var strrightTHTML = "";
	// ��ނɂ���āA�����I���ł��邩�P���ɂ���B
	if(reqKind=='Dimension' || reqKind=='TimeDim'){
		strrightTHTML="<select name='lst_left' id='lst_left' size='7' style='width:250;margin:0'>\n";
	}else{
		strrightTHTML="<select name='lst_left' id='lst_left' size='7' multiple style='width:250;margin:0'>\n";
	}
	var arrChildId = reqChildId.split(',');
	if(myNode!=null){
		if(myNode.lastChild.hasChildNodes()){
			for (iCount=0; iCount<myNode.lastChild.childNodes.length; iCount++) {
				var match_flag = 0;
				for (jCount=0; jCount<arrChildId.length; jCount++) {
					if (myNode.lastChild.childNodes[iCount].id == arrChildId[jCount]) {
						// ��v������
						match_flag = 1;
						break;
					}
				}
				if (match_flag == 0) {
					strrightTHTML=strrightTHTML + "<option value='";
					strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].id + "'>";
					strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].lastChild.previousSibling.innerText + "</option>";
				}
			}
		}
	}
	strrightTHTML=strrightTHTML + "<select>";
	parent.parent.frm_main.document.form_main.all.div_left_move.innerHTML = strrightTHTML;

}

function searchNode(sOBJKIND, sID) {
	// Measure, Dimension(Time Dimension),Parts �̊�m�[�h��߂�
	// selectedNode.parentNode.parentNode ;��ʃm�[�h��
	// selectedNode.lastChild.lastChild   ;���ʃm�[�h��
	// �p�[�c�̒T���͂��Ȃ��i���W���[�A�����܂Łj
	// �Y������m�[�h�������ꍇ�Anull ��Ԃ�

	var iCount = 0;
	var jCount = 0;
	var selectedNode;

	// Measure(objkind), x(id) ��m�[�h������
	selectedNode = allIncRootNode;

	// Measure ����(sOBJKIND = "Measure")
	if (sOBJKIND == "Measure") {
		return selectedNode;
	}

	// Dimension ����
	if (sOBJKIND == "Dimension" || sOBJKIND == "TimeDim") {
		if (!selectedNode.lastChild.hasChildNodes()) {
			// Dimension �������ꍇ�� null ��Ԃ�
			return null;
		}

		for (iCount=0; iCount<selectedNode.lastChild.childNodes.length; iCount++) {
			if (selectedNode.lastChild.childNodes[iCount].id == sID) {
				selectedNode = selectedNode.lastChild.childNodes[iCount];
				return selectedNode;
			}
		}

	}

// �R�ꌟ�o
//*alert("[ALL] (�Y������) "+selectedNode.objkind+" : "+selectedNode.id+" �̒��ł�");
	return null;
}



//�c���[�����\��
function init() {

	// �N���[���쐬��ɍ폜����m�[�h
	var allRemRootNode = new Object;
	allRemRootNode = document.getElementById("cloneNode");

	// ���̐e
	var thisRootNode = new Object;
	thisRootNode = allRemRootNode.parentNode;

	// �\��������m�[�h
	var siblingNode = new Object;
	siblingNode = allRemRootNode.previousSibling;
//alert(siblingNode.outerHTML);

	// ���ׂĂ̌��I�u�W�F�N�g���܂ރm�[�h��ݒ�
	allIncRootNode = allRemRootNode.lastChild.lastChild.cloneNode(true);//�S�m�[�h

	// �\���ɕs�v�ȃm�[�h���폜
	thisRootNode.removeChild(allRemRootNode);

	// �\������
	allLoop(siblingNode,'ALL')

}
