
// �Z���N�^�{�f�B���̏�����
function initialize() {

	// ===== �ϐ��Q�����ݒ� =====

	// �f�B�����V�������XML�̃p�X
	var loadXMLPath = "Controller?action=getAxisMemberInfoByAxisID&axisID=" + dimNumber;

// Modal Dialog
//	spreadXMLData = parent.window.opener.parent.info_area.axesXMLData;
	spreadXMLData = window.dialogArguments[1];
	if ( dimNumber!=16 ) {
		axisMemberXMLData =  new ActiveXObject("MSXML2.DOMDocument");
		axisMemberXMLData.async = false;
		var result = axisMemberXMLData.load(loadXMLPath);

		if (!result) {
		
			// �G���[���b�Z�[�W��\��
			showSelecterMessage('1', loadXMLPath);
			
			// �Z���N�^�E�C���h�E���N���[�Y
			parent.window.close();
		
		}

	}

	// �ݒ蒆�̎��̃����o���(�I�����ꂽ���A�h�������)
	var statusArea = parent.frm_header.document.all("statusArea");

	// �����o�̃X�^�C���𒲐�(�\���E��\���A�h����)

	// �����o�Ƃ��̃h�����X�e�[�^�X���i�[����A�z�z��𐶐�
	var selectedInfoList = statusArea.all( dimNumber ).innerText;
	settingArray = selectedInfoList.split(",");
	associationKeyDrill = new Array();
	for ( var i = 0; i < settingArray.length; i++ ) {
		var tmpArray  = settingArray[i].toString().split(":");
		// tmpArray[0]: KEY
		// tmpArray[1]: �h�����X�e�[�^�X
		associationKeyDrill[tmpArray[0]] = tmpArray[1];
	}

	adjustMemberStyle(tab1, associationKeyDrill, "selectable");
	adjustMemberStyle(tab2, associationKeyDrill, "selected");

	// ���W���[�����o�[�^�C�v�̃C���[�W��ݒ�
	if ( dimNumber == "16" ) {	// ���W���[
		if ( parent.frm_header.document.all("measureTypeArea").firstChild.innerText != "" ) {

			var measureTypeArray = parent.frm_header.document.all("measureTypeArea").firstChild.innerText.split(",");
			for(i=0;i<tab2.childNodes.length;i++){
				node = tab2.childNodes[i];
				// measureTypeArray[i].split(":")[0]: ���W���[ID
				// measureTypeArray[i].split(":")[1]: ���W���[�^�C�vID

				node.firstChild.firstChild.style.backgroundImage = getMeasureTypeImageURLByID( measureTypeArray[i].split(":")[1] );
				var measureTypeNameArray = getMeasureTypeNameArray();
				node.firstChild.firstChild.title = measureTypeNameArray[getMeasureTypeIndexByID(measureTypeArray[i].split(":")[1])];
			}
		}
	}


	// �������������I������̂Ń����o�[�I�𗓂�\����Ԃɂ���
	tab1.style.visibility = "visible";
	tab2.style.visibility = "visible";


}

// �����o�[�X�^�C���𒲐�(�\���E��\���A�h����)
function adjustMemberStyle( tab, associationKeyDrill, target ) {
	for(i=0;i<tab.childNodes.length;i++){

		var sourceNode = tab.childNodes[i];
		var sourceNodeKey   = sourceNode.id;	// sourceNode ��ID(XML:UName)

		// ����N�����ꂽ�Z���N�^�Ŋ��ɐݒ肳�ꂽ�����o�̏�Ԃ����ƂɁA�����o�̃X�^�C�������肷��

		// �Ή����郁���o�[�����݂���
		if ( associationKeyDrill[sourceNodeKey] != null ) {

			if ( ( associationKeyDrill[sourceNodeKey] == "1" && sourceNode.firstChild.firstChild.toggle == "p" ) ||
				 ( associationKeyDrill[sourceNodeKey] == "0" && sourceNode.firstChild.firstChild.toggle == "m" )
			   ) {

				setCellDrillStatusUp(sourceNode);
			}

		// �Ή����郁���o�[�����݂��Ȃ�
		} else {
			if ( target == "selectable" ) {
				// �h�������̏�ԂƂ���
				setCellDrillStatusUp(sourceNode);
			} else if ( target == "selected" ) {
				// ��\���ɂ���
				removeNode(sourceNode);
			}
		}

		// �����o�̃h�����ɂ��\��/��\���𒲐�
		dispCheck(sourceNode);

	}
}

// =============================================================================
//  �����o����i�h�����j
// =============================================================================
//�g�O���{�^����������
function clickToggle(th){
	var thisTr = th.parentNode.parentNode;
	var tbl = thisTr.parentNode;

	//�q����S�Ď擾����
	var arrChildIndex = getDescendantIndexes(dimNumber,thisTr.id,"all");

	if(th.toggle=="p"){
		th.toggle="m";
		th.innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
		for(i=0;i<arrChildIndex.length;i++){
		//	tbl.childNodes[arrChildIndex[i]].dispflg="1";
			dispCheck(tbl.childNodes[arrChildIndex[i]]);
		}
	}else if(th.toggle=="m"){
		th.toggle="p";
		th.innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
		for(i=0;i<arrChildIndex.length;i++){
		//	tbl.childNodes[arrChildIndex[i]].dispflg="0";
			dispCheck(tbl.childNodes[arrChildIndex[i]]);
		}
	}else if(th.toggle=="n"){
		return;
	}
}

// �Z�����h�����A�b�v�ɂ���
function setCellDrillStatusUp(sourceNode) {
	if(sourceNode.firstChild.childNodes[0].toggle=="m"){
		sourceNode.firstChild.childNodes[0].toggle="p";
		sourceNode.firstChild.childNodes[0].innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
	}
}

// =============================================================================
//  �����o����i�h�����_�E���֘A�A�����o�擾)
// =============================================================================

	// �q���̃C���f�b�N�X���X�g���擾
	function getDescendantIndexes(dimID, memberID, flg) {
		var indexArray = new Array();

		if (axisMemberXMLData != null) {
			var targetNode = axisMemberXMLData.selectSingleNode("/Members[@id = " + dimID + "]//Member[./UName=" + memberID + "]");
			if (targetNode != null) {
				if(flg=="all"){
					var childNodes = targetNode.selectNodes(".//Member");
				}else if(flg=="child"){
					var childNodes = targetNode.selectNodes("./Member");
				}
				for(var i = 0; i < childNodes.length; i++ ) {
					var node = childNodes[i];
					indexArray[i] = node.selectSingleNode("@id").value;
				}
			}
		}

		return indexArray;
	}


	// �e�̃C���f�b�N�X���X�g���擾
	function getParentIndex(dimID, memberID) {
		var parentIndex = null;

		if (axisMemberXMLData != null) {
			var targetNode = axisMemberXMLData.selectSingleNode("/Members[@id = " + dimID + "]//Member[./UName=" + memberID + "]");
			if (targetNode == null) { return null; }
			var parentNode = targetNode.parentNode;
			if ( parentNode == null ) { return null; }

			if ( parentNode.nodeName == "Members" ) { // �ŏ�ʃ��x���̃m�[�h
				parentIndex = null;
			} else { // �ŏ�ʃ��x���ȊO�̃m�[�h
				parentIndex = parentNode.selectSingleNode("@id").value;
			}
		}

		return parentIndex;
	}


// =============================================================================
//  �����o����i�����o�I���j
// =============================================================================
//�N���b�N���ꂽ�����o�[��I����Ԃɂ���

var preClickTr;

function clickName( th ) {
	var thisTr = th.parentNode.parentNode;
	var tbl = thisTr.parentNode;

	//SHIFT�L�[����������Ă���ꍇ�̏���
	if ( event.shiftKey == true ) {
		if(preClickTr==null){return;};
		var preNum  = preClickTr.index;
		var nodeNum = thisTr.index;
		if ( preNum == nodeNum ) {//�v��obj�ƃN���b�Nobj�������ꍇ
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;
		}else{//�v��obj�ƃN���b�Nobj���قȂ�ꍇ�͂��͈̔͂��擾
			if ( parseInt(preNum) < parseInt(nodeNum) ) {
				fromNum=parseInt(preNum);
				toNum=parseInt(nodeNum);
			} else {
				fromNum=parseInt(nodeNum);
				toNum=parseInt(preNum);
			}
		}

		for(i=fromNum;i<=toNum;i++){
			if(tbl.childNodes[i].exist=="1"){//�����o�[�Ƃ��đ��݂��邩���`�F�b�N
				//�Z���N�g��Ԃɂ���
				tbl.childNodes[i].selected="1";
				tbl.childNodes[i].style.background = selectedMemberColor;
			}
		}

		//Toobj���v���X�̏ꍇ�͎q�����I����Ԃɂ���
		if(tbl.childNodes[toNum].firstChild.childNodes[0].toggle=="p"){
			var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[toNum].id,"all");
			for(i=0;i<arrChildIndex.length;i++){
				if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//�����o�[�Ƃ��đ��݂��邩���`�F�b�N
					if(tbl.childNodes[arrChildIndex[i]].selected=="0"){;
						tbl.childNodes[arrChildIndex[i]].selected="1";
						tbl.childNodes[arrChildIndex[i]].style.background = selectedMemberColor;
					}
				}
			}
		}


		return;

	//SHIFT�L�[����������Ă��Ȃ��ꍇ�̏���
	}else{

		preClickTr = thisTr;//�v��obj���Z�b�g



		var arrChildIndex = getDescendantIndexes(dimNumber,thisTr.id,"all");

		//�����o�[�Ƃ��Ď��q���̐��𒲂ׂ�
		var childCount=0;
		for(i=0;i<arrChildIndex.length;i++){
			if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//�����o�[�Ƃ��đ��݂��邩���`�F�b�N
				childCount++;
			}
		}


		if((thisTr.selected=="0")&&(thisTr.firstChild.childNodes[0].toggle!="p")){//���I�����v���X�ȊO�̏ꍇ�͇A�B�̏������s��Ȃ�
			//�@�Z���N�g��Ԃɂ���
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;
		}else if((thisTr.selected=="0")&&(thisTr.firstChild.childNodes[0].toggle=="p")&&(childCount==0)){//���I�����v���X���q�������o�[����0�̏ꍇ�͇A�B�̏������s��Ȃ�
			//�@�Z���N�g��Ԃɂ���
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;

		}else{
			//�@�Z���N�g��Ԃɂ���
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;


			var colorChangeCount=0;
			if(arrChildIndex.length!=0){
				//�A�F�����Ă��Ȃ��q��������ꍇ�́A�F��t����
				for(i=0;i<arrChildIndex.length;i++){
					if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//�����o�[�Ƃ��đ��݂��邩���`�F�b�N
						if(tbl.childNodes[arrChildIndex[i]].selected=="0"){;
							tbl.childNodes[arrChildIndex[i]].selected="1";
							tbl.childNodes[arrChildIndex[i]].style.background = selectedMemberColor;
							colorChangeCount++;
						}
					}
				}
			}


			if(colorChangeCount==0){//�B�F�����Ȃ���ΑS�I�������Z�b�g
				thisTr.selected="0";
				thisTr.style.background = unSelectedMemberColor;
				//�q��������ꍇ�͎q�����F������
				if(arrChildIndex.length!=0){
					for(i=0;i<arrChildIndex.length;i++){
						tbl.childNodes[arrChildIndex[i]].selected="0";
						tbl.childNodes[arrChildIndex[i]].style.background = unSelectedMemberColor;
					}
				}
			}

		}

	}

}

// =============================================================================
//  �����o����i�\���E��\���̐؂�ւ��j
// =============================================================================

//�\���E��\����؂�ւ���
function dispCheck(trObj){

//	if(trObj.exist==1&&trObj.dispflg=="1"){//�\������ׂɂ́u�����o�[�����݁v���u�W�J����Ă���v���O�����
	if(trObj.exist==1){//�\������ׂɂ́u�����o�[�����݁v���O�����
		var parentPlusFlg=false;

		//�e���W�J����Ă��Ȃ��ꍇ�͕\�����Ă͂����Ȃ��̂ŁA�����̂ڂ��Đ�c�ɕ\������Ă���u+�v�����o�[�����邩�ǂ������擾����
		if(getParentIndex(dimNumber,trObj.id)!=null){
			var parentTr=trObj.parentNode.childNodes[getParentIndex(dimNumber,trObj.id)];
			var k=0;
			while(true){
				k++;
				if(parentTr==null){
					break;
				}
				if((parentTr.firstChild.childNodes[0].toggle=="p")&&(parentTr.style.display=="block")){
					parentPlusFlg=true;
					break;
				}
				if(getParentIndex(dimNumber,parentTr.id)!=null){
					parentTr=parentTr.parentNode.childNodes[getParentIndex(dimNumber,parentTr.id)];
				}else{
					break;
				}
			}
		}

		if(parentPlusFlg){
			trObj.style.display="none";//��\���i��c�ɕ\������Ă���u+�v�����o�[����j
		}else{
			trObj.style.display="block";//�\���i��c�ɕ\������Ă���u+�v�����o�[�Ȃ��j

			//�ǉ�����郁���o�[�̐e�����o�[���}�C�i�X�ɐ؂�ւ���
			if(getParentIndex(dimNumber,trObj.id)!=null){
				var parentObj = trObj.parentNode.childNodes[getParentIndex(dimNumber,trObj.id)];
				parentObj.firstChild.childNodes[0].toggle="m";
			//	parentObj.firstChild.childNodes[0].innerHTML="-";
				parentObj.firstChild.childNodes[0].innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
			}
		}
//	}else{//�u�����o�[�����݁v���u�W�J����Ă���v�O������𖞂����Ă��Ȃ��ꍇ
	}else{//�u�����o�[�����݁v�O������𖞂����Ă��Ȃ��ꍇ
		trObj.style.display="none";//��\��
	}

}

// =============================================================================
//  �����o����i�u���j
// =============================================================================
//�u���{�^��
function replace(){
	var selectedRowNum=0;
	for(i=0;i<tab1.childNodes.length;i++){
		if(tab1.childNodes[i].selected=="1"){
			selectedRowNum++;
		}
	}
	if(selectedRowNum==0){//�����ɑI�������o�[�����Ȃ���Ή����s��Ȃ�
		return;
	}

	remove(2);
	add();
}

// =============================================================================
//  �����o����i�ǉ��j
// =============================================================================

//�ǉ��{�^��
function add() {
	for(i=0;i<tab1.childNodes.length;i++){
		if(tab1.childNodes[i].selected=="1"){
			tab2.childNodes[i].exist="1";
		//	tab2.childNodes[i].selected="1";
			dispCheck(tab2.childNodes[i]);
			tab1.childNodes[i].selected="0";
			tab1.childNodes[i].style.background=unSelectedMemberColor;

		}
	}
}

// =============================================================================
//  �����o����i�폜�j
// =============================================================================

//�폜�{�^��
function remove(mode){
	if(mode==1){
		for(i=0;i<tab2.childNodes.length;i++){
			if(tab2.childNodes[i].selected=="1"){
				removeNode(tab2.childNodes[i]);
			}
		}
	}else if(mode==2){
		for(i=0;i<tab2.childNodes.length;i++){
			removeNode(tab2.childNodes[i]);
		}
	}
}

//�폜����
function removeNode(node) {
	//	node.dispflg="0";
		node.exist="0";
		node.selected="0";
		node.style.background=unSelectedMemberColor;
		dispCheck(node);
}


// =============================================================================
//  �����o����i���W���[�^�C�v�̕ύX�j
// =============================================================================

// ���W���[�^�C�v�I���{�b�N�X�̕\��
function makeMeasureTypeSelecter( imgNode ) {
	if ( imgNode.nextSibling.tagName == "SELECT" ) { 
		removeSelecter( imgNode );
		return; 
	}

	if (document.frm_main.measureType != null) { // ���Ƀ��W���[�^�C�v�I���{�b�N�X���\���� �Ȃ�΁A�I��
		return;
	}

	var oSelect = document.createElement("<select id='measureType' onchange='changeMeasureType(this)'>");
	var measureTypeNameArray = getMeasureTypeNameArray();
	var oOption;

// previousSibling ��IMG URL���ID���擾
// getMeasureTypeIndex(imgNode.previousSibling.style.backgroundImage)
// selected=true ��t�^
	var currentMeasureTypeID = getMeasureTypeIndex(imgNode.style.backgroundImage);
	for ( var i = 0; i < measureTypeNameArray.length; i++ ) {
		var selectedString = "";
		if ( i == currentMeasureTypeID) {
			selectedString = " selected=true";
		}
		oOption = document.createElement("<option" + selectedString + ">");
		oOption.innerText = measureTypeNameArray[i];
		oSelect.appendChild(oOption);
	}
	imgNode.insertAdjacentElement('afterEnd',oSelect);
}

// ���W���[�^�C�v���ύX���ꂽ
function changeMeasureType( oSelect ) {
	// ���W���[�^�C�v�̃C���[�W,�^�C�g����ύX
	var measureIMGArray = getMeasureIMGArray();
	var measureTypeNameArray = getMeasureTypeNameArray();
	oSelect.previousSibling.style.backgroundImage = measureIMGArray[document.frm_main.measureType.selectedIndex];
	oSelect.previousSibling.title = measureTypeNameArray[document.frm_main.measureType.selectedIndex];

	// ���W���[�^�C�v�̃Z���N�g�{�b�N�X���폜
	removeSelecter( oSelect.previousSibling );
}

// ���W���[�^�C�v�I���{�b�N�X���폜
function removeSelecter( imgNode ) {
	if ( imgNode == null ) { return; }
	if ( imgNode.nextSibling == null ) { return; }
	if ( imgNode.nextSibling.tagName != "SELECT" ) { return; }

	imgNode.parentNode.removeChild( imgNode.nextSibling );
}

// ���W���[�����o�[�^�C�v��ID���X�g
function getMeasureIDArray() {
	var measureIDArray = measureMemTypeIDListString.split(",");
	return measureIDArray;
}

// ���W���[�����o�[�^�C�v�̃C���[�WUR�̔z����擾����
function getMeasureIMGArray() {
	var measureIMGArray = measureMemTypeIMGListString.split(",");
	return measureIMGArray;
}

// ���W���[�^�C�v�̖��̂̔z����擾����
function getMeasureTypeNameArray() {
	var measureTypeNameArray = measureMemTypeNameListString.split(",");
	return measureTypeNameArray;
}

function getMeasureTypeIDByIndex( index ) {
	var measureIDArray = getMeasureIDArray();
	return measureIDArray[i];
}

function getMeasureTypeIDByImage( imageURL ) {
	var measureIDArray = getMeasureIDArray();
	var measureMemberTypeIndex = getMeasureTypeIndex( imageURL );
	return measureIDArray[measureMemberTypeIndex];
}

function getMeasureTypeIndex( imageURL ) {
	var measureIMGArray = getMeasureIMGArray();
	for ( var i = 0; i < measureIMGArray.length; i++ ) {
		if ( measureIMGArray[i] == imageURL ) {
			return i;
		}
	}
	return null;
}

function getMeasureTypeIndexByID( ID ) {
	var measureIDArray = getMeasureIDArray();
	for ( var i = 0; i < measureIDArray.length; i++ ){
		if ( measureIDArray[i] == ID ) {
			return i;
		}
	}
	return null;
}

function getMeasureTypeImageURLByID( ID ) {
	var measureIMGArray = getMeasureIMGArray();
	var measureIndex = getMeasureTypeIndexByID(ID);

	return measureIMGArray[measureIndex];
}


function getMeasureTypeImageURL( index ) {
	var measureIMGArray = getMeasureIMGArray();

	return measureIMGArray(index);
}

// =============================================================================
//  �����o����i�f�B�����V���������o���\���^�C�v�̕ύX�j
// =============================================================================

	// �^����ꂽ�^�C�v�̖��̂�ݒ肷��
	function changeDisplayName (dispNameType) {
		for(i=0;i<tab1.childNodes.length;i++){
			tab1.childNodes[i].firstChild.childNodes[1].innerHTML=tab1.childNodes[i].firstChild.childNodes[1].getAttribute(dispNameType);
		}
		for(i=0;i<tab2.childNodes.length;i++){
			tab2.childNodes[i].firstChild.childNodes[1].innerHTML=tab2.childNodes[i].firstChild.childNodes[1].getAttribute(dispNameType);
		}
	}

	// �^����ꂽ��ID�̃����o���̕\���^�C�v���擾(�Z���N�^�w�b�_���)
	function getSelectedMemberDispType() {

		var thisDispNameType = "";
		var thisDispNameTypeArray = parent.frm_header.document.all("dimMemDispTypeArea").firstChild.innerText.split(",");
		for ( var i = 0; i < thisDispNameTypeArray.length; i++ ) {
			// thisDispNameTypeArray[i].split(":")[0]: �f�B�����V����ID
			// thisDispNameTypeArray[i].split(":")[1]: �f�B�����V�����̃����o�\�����^�C�v

			var thisDispNameTypeIDValue = thisDispNameTypeArray[i].split(":")
			if ( dimNumber == thisDispNameTypeIDValue[0] ) {
				thisDispNameType = thisDispNameTypeIDValue[1];
				break;
			}
		}

		return thisDispNameType;
	}

// =============================================================================
//  ��������
// =============================================================================

// �T�[�o�[�ŁA�����o�[���E���x���ɂ��f�B�����V���������o���������s
function searchList() {

	// ���̓`�F�b�N
	if(!checkData()){return;}

	document.frm_main.action = "Controller?action=searchDimensionMember";
	document.frm_main.target = "frm_data";
	document.frm_main.submit();
}

//�����o�[�̍i����
function memberFocus(arrId){
	for(i=0;i<tab1.childNodes.length;i++){
		tab1.childNodes[i].exist="0";
	}
	for(i=0;i<arrId.length;i++){
		tab1.all(arrId[i]).exist="1";
	}
	for(i=0;i<tab1.childNodes.length;i++){
		dispCheck(tab1.childNodes[i]);
	}
}

// =============================================================================
//  �����o����i�ꊇ�h���������j
// =============================================================================
//�S�h�����_�E���E�S�h�����A�b�v
function setTree(table,flg){
	var tbl = document.getElementById(table).firstChild;


	if(flg==1){//�S�h�����A�b�v
		for(i=0;i<tbl.childNodes.length;i++){
			if(tbl.childNodes[i].firstChild.childNodes[0].toggle=="m"){
				tbl.childNodes[i].firstChild.childNodes[0].toggle="p";
				tbl.childNodes[i].firstChild.childNodes[0].innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
				var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[i].id,"child");
				for(j=0;j<arrChildIndex.length;j++){
				//	tbl.childNodes[arrChildIndex[j]].dispflg="0";
					dispCheck(tbl.childNodes[arrChildIndex[j]]);
				}
			}
		}
	}else if(flg==2){//�S�h�����_�E��
		for(i=0;i<tbl.childNodes.length;i++){
			if(tbl.childNodes[i].firstChild.childNodes[0].toggle=="p"){
				tbl.childNodes[i].firstChild.childNodes[0].toggle="m";
				tbl.childNodes[i].firstChild.childNodes[0].innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
				var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[i].id,"child");
				for(j=0;j<arrChildIndex.length;j++){
				//	tbl.childNodes[arrChildIndex[j]].dispflg="1";
					dispCheck(tbl.childNodes[arrChildIndex[j]]);
				}
			}
		}
	}

}

// =============================================================================
//  �I����e�̊m�菈��
// =============================================================================
function setSelecterStatus() {

// �ݒ�����擾

	// ���݁A�ݒ蒆�̃f�B�����V����/���W���[�̃����o��Ԃ�ۑ�
	var ret = setSelectedList( dimNumber, "submit" );
	if (ret == -1 ) {
		return false;
	}

}

// ���|�[�g���X�V���A�Z���N�^���g���N���[�Y����
// ���|�[�g���X�V��A�T�[�o�[�����瑗�M���ꂽJava�X�N���v�g�ɂ����s�����
function executeLoadSpread() {

	// ���|�[�g���X�V
	document.frm_main.action = "Controller?action=loadClientInitAct";
	document.frm_main.target = "info_area";	
	document.frm_main.submit();

	// �Z���N�^�E�C���h�E���N���[�Y
	parent.window.close();

}

// =============================================================================
//  �Z���N�^���̕ۑ�
// =============================================================================
function setSelectedList( dimNum, mode ) {
	// �Z���N�^�ɂ��ݒ���̕ێ��ASession�ւ̓o�^

	var selecterInfo = getSelectedMemberList();
	if (selecterInfo == "") {	// �I���ς݂̃����o�[������
// Modal Dialog
		window.dialogArguments[0].showMessage( "6" );
//		parent.window.opener.showMessage( "6" );
		return -1;
	}

	// ===== �ݒ���Z���N�^�w�b�_�Ɉꎞ�I�ɕۑ� =====
	// �f�B�����V����/���W���[�̑I�����ꂽ�����o��Key�E�h�������
	var statusArea = parent.frm_header.document.all("statusArea");
	var dimArea = statusArea.all( dimNum );
	dimArea.innerText = selecterInfo;

	// ���W���[�^�C�v
	var measureArea = parent.frm_header.document.all("measureTypeArea");
	if ( dimNumber == "16" ) {

		var measureTypeString = "";
		for(i=0;i<tab2.childNodes.length;i++){
			var node = tab2.childNodes[i];
			if ( measureTypeString == "" ) {
				measureTypeString = node.id + ":" + getMeasureTypeIDByImage( node.firstChild.firstChild.style.backgroundImage );
			} else {
				measureTypeString += "," + node.id + ":" + getMeasureTypeIDByImage( node.firstChild.firstChild.style.backgroundImage );
			}
		}
		measureArea.firstChild.innerText = measureTypeString;
	}

	// ===== �ݒ���Z�b�V�����ɕۑ� =====
	if ( mode == "submit" ) {

		// ���W���[�^�C�v
		document.frm_main.measureTypes.value = measureArea.firstChild.innerText;

		// �����o���̕\���^�C�v
		var dimMemDispArea = parent.frm_header.document.all("dimMemDispTypeArea");
		document.frm_main.dimMemDispTypes.value = dimMemDispArea.firstChild.innerText;

		// �f�B�����V����/���W���[���̑I�����ꂽ�����o��Key�E�h�������
		document.frm_main.dim1.value = statusArea.all("1").innerText;
		document.frm_main.dim2.value = statusArea.all("2").innerText;
		document.frm_main.dim3.value = statusArea.all("3").innerText;
		document.frm_main.dim4.value = statusArea.all("4").innerText;
		document.frm_main.dim5.value = statusArea.all("5").innerText;
		document.frm_main.dim6.value = statusArea.all("6").innerText;
		document.frm_main.dim7.value = statusArea.all("7").innerText;
		document.frm_main.dim8.value = statusArea.all("8").innerText;
		document.frm_main.dim9.value = statusArea.all("9").innerText;
		document.frm_main.dim10.value = statusArea.all("10").innerText;
		document.frm_main.dim11.value = statusArea.all("11").innerText;
		document.frm_main.dim12.value = statusArea.all("12").innerText;
		document.frm_main.dim13.value = statusArea.all("13").innerText;
		document.frm_main.dim14.value = statusArea.all("14").innerText;
		document.frm_main.dim15.value = statusArea.all("15").innerText;
		document.frm_main.dim16.value = statusArea.all("16").innerText;

		// �Z���̐F
// Modal Dialog
//		var colorArray = parent.window.opener.parent.display_area.getColorArray();
		var colorArray = window.dialogArguments[0].parent.display_area.getColorArray();
		if(colorArray != null) {
			document.frm_main.hdrColorInfo.value = colorArray[0];
			document.frm_main.dtColorInfo.value = colorArray[1];
		}

		// === �Z�b�V�����֓o�^ ===
		document.frm_main.action = "Controller?action=registClientReportStatus";
		document.frm_main.target = "frm_data";	
		document.frm_main.submit();
	}
}

	//�u�I���ς݂̃����o�[�v���ɑ��݂��郁���o��z��ŕԂ�
	function getSelectedMemberList(){
		var arrSelectedMember = new Array();
		var count = 0;
		for(i=0;i<tab2.childNodes.length;i++){
			if(tab2.childNodes[i].exist=="1"){
				var tempString = "";
				//Id���Z�b�g
				tempString=tab2.childNodes[i].id;
				tempString+=":";
				//�h������Ԃ��Z�b�g�i�}�C�i�X:1�A����ȊO:0�j
				if(tab2.childNodes[i].firstChild.childNodes[0].toggle=="m"){
					tempString+="1";
				}else{
					tempString+="0";
				}
				arrSelectedMember[count]=tempString;
				count++;
			}
		}

		return arrSelectedMember;
	}

