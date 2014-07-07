
// ���������������� �c�[���o�[�X�^�C���֘A�萔 ����������������

	// ��ʕ����\���i�\�A�O���t�j�֐؂�ւ����̃O���t�\���p�t���[���̏c��
	var chartSubAreaInitialHeight = 300;

// ���������� �c�[���o�[�̃X�^�C�������֐� ��������������������������������������

var selectedButton = null; // �v���_�E�����j���[�\�����̃{�^��

// �J���[�p���b�g�\���{�^���̑I����ԃX�^�C�����N���A
function clearColorButton() {
	document.all("divPallet").style.display='none'
}

// ********************************************************
// �c�[���o�[�{�^���̃C�x���g
// ********************************************************
function tbMouseOver(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // �c�[���o�[�̃{�^�������p�s�\

	tbButton.className = 'over_toolicon';
}

function tbMouseDown(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // �c�[���o�[�̃{�^�������p�s�\

	tbButton.className = 'down_toolicon';
}

function tbMouseUp(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // �c�[���o�[�̃{�^�������p�s�\

	tbButton.className = 'up_toolicon';
}

function tbMouseOut(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // �c�[���o�[�̃{�^�������p�s�\

	tbButton.className = 'out_toolicon';
}

function tbClick(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // �c�[���o�[�̃{�^�������p�s�\

	var tbTable = null;
		if ( tbButton.tagName == "IMG" ) {
			tbTable = tbButton.parentNode.parentNode.parentNode.parentNode.parentNode;
		} else {
			return false;
		}

	// �J���[�p���b�g�\���{�^�����N���b�N���ꂽ
	if ( tbTable.id == "tblColorBtn" ) {
		showColorPallet(tbTable);
	}
}

// �c�[���o�[�{�^���̗L�������`�F�b�N����
function isButtonEnable(tbButton) {
//alert(tbButton.outerHTML);
	var tbTable = null;
		if ( tbButton.tagName == "IMG" ) {
			tbTable = tbButton.parentNode.parentNode.parentNode.parentNode.parentNode;
		} else {
			return false;
		}

//alert(tbTable.outerHTML);
	// �S��ʕ\���i�\�j�̏ꍇ�́A�`���[�g�{�^����ŃC�x���g�𔭐������Ȃ�
	if ( (tbTable.id == "tblChartBtn") && (isChartTblWithOnlySpread(tbTable)) ) {
			return false;
	} else {
		return true;
	}

}

// ============== �T�u�E�C���h�E�֘A�i�F�֘A�A��ʕ����X�^�C���֘A�j ===================================

// ============== ���� ==================================================

// �T�u�E�C���h�E�ŁA�I�����ꂽ
function subWindowButton_up(eButton) {
	if ( eButton.parentNode.parentNode.parentNode.parentNode.id != "tblColorPallet" ) { return; }

	// �J���[�p���b�g�ŐF���I�����ꂽ
	if ( eButton.parentNode.parentNode.parentNode.parentNode.id == "tblColorPallet" ) {

		// �I���ς݂̃Z����F�t������
		setColorToSelectedCell( eButton.colorStyle );
	}
}


// �`���[�g�\���̈�iFrameset�̍Ō��Frame�^�O�j���X�V����
function dispChartSubArea(toSize) {

	var frameRows = parent.document.getElementsByTagName('frameset')[0].rows;
	var frameRowsArray = frameRows.split(",");

	// �`���[�g�\���̈��\����Ԃɐݒ�itoSize !=0 ���A�t���[���T�C�Y !=0) �̏ꍇ��
	// �������I�����`���[�g�\���̈�̏������͍s�Ȃ�Ȃ�
	if ((toSize != 0 ) && (frameRowsArray[frameRowsArray.length - 1] != 0)) {
		return;
	}

	frameRowsArray[frameRowsArray.length - 1] = toSize;
	parent.document.getElementsByTagName('frameset')[0].rows = frameRowsArray.join();

}

// ============== �F�֘A ==================================================

// �J���[�p���b�g��\��
function showColorPallet(eButtonTable) {
	selectedButton = eButtonTable;							// �{�^����I����Ԃɐݒ�
	document.all("divPallet").style.display='block';		// �p���b�g�\��
	document.attachEvent('onmouseup', mouse_up_for_menu);	// mouse_up_for_menu�C�x���g��document�ɃZ�b�g
}

// document���̃}�E�X�A�b�v�ŃJ���[�{�^���̃X�^�C�������������A�p���b�g���\���ɂ���
function mouse_up_for_menu() {
	selectedButton = null;							// �I����Ԃ̃{�^����������
	clearColorButton();								// �J���[�{�^���̏������N���A
	document.all("divPallet").style.display='none';	// �p���b�g�̔�\����
	document.detachEvent('onmouseup', mouse_up_for_menu);	// �C�x���g�̃N���A
}

// ============== ��ʕ����X�^�C���֘A ==================================================

// ��ʕ����X�^�C���̃^�C�v��\��
function showWindowDivisionType(eButtonTable) {

	selectedButton = eButtonTable;									// �{�^����I����Ԃɐݒ�
	document.all("divWindowDivisionType").style.display='block';	// �p���b�g�\��
	document.attachEvent('onmouseup', mouse_up_for_win_div_menu);	// mouse_up_for_win_div_menu�C�x���g��document�ɃZ�b�g
}

// document���̃}�E�X�A�b�v�ŉ�ʕ����X�^�C���̃X�^�C�������������A��ʕ����^�C�v���\���ɂ���
function mouse_up_for_win_div_menu() {

	selectedButton = null;											// �I����Ԃ̃{�^����������
	document.all("divWindowDivisionType").style.display='none';		// ��ʕ����^�C�v�̔�\����
	document.detachEvent('onmouseup', mouse_up_for_win_div_menu);	// �C�x���g�̃N���A
}

// ============== ��ʕ����X�^�C��,�`���[�g�^�C�v�֘A=====================================

// �S��ʕ\���i�\�j�̏ꍇ�́A�`���[�g�{�^����ŃC�x���g�𔭐������Ȃ�
function isChartTblWithOnlySpread(eButtonTable) {
	if(eButtonTable.id == "tblChartBtn") {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (node.text == "0") { // 0:�S��ʕ\���i�\�j
			return true;
		}
	}
	return false;
}

// ============== �Z���N�^�֘A ==================================================

	// �Z���N�^�E�C���h�E Open
	function openSelector(targetAxisID, clickType) {

		// �N���b�N���ꂽ�}�E�X�{�^���̃^�C�v�ƁA�w�肳�ꂽclickType����v���Ȃ��ꍇ�A�I��
		// clickType=1: ���N���b�N �AclickType=2: �E�N���b�N
		if(event.type!="click") { // onclick�̏ꍇ�̓c�[���o�[�{�^����onclick�C�x���g����ł���Aonclick�ł͏��event.button���u0�v�ƂȂ邽�߃`�F�b�N���Ȃ�
			if(event.button!=clickType) {
				return;
			}
		}

//		window.open('Controller?action=displaySelecter','_blank','width=500px,height=580px,statusbar=no,toolbar=no');

//	���[�_���Z���N�^
		var args = new Array();
		args[0] = window;
		args[1] = axesXMLData;
		var ret = showModalDialog('Controller?action=displaySelecter&targetAxisID='+targetAxisID,args,'dialogHeight:580px;dialogWidth:500px;toolbar=no;status:no;');
	}

// ============== �n�C���C�g�֘A ==================================================

	// �n�C���C�g�E�C���h�E Open
	function openHighLight() {

		// �F�����擾���Ahidden�ɓo�^
		var colorInfoArray = getColorArray();
		if( colorInfoArray != null ) {
			document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// �w�b�_�[���̐F���
			document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// �f�[�^�e�[�u���̐F���
		}
		document.SpreadForm.action = "Controller?action=registColorOnly";
		document.SpreadForm.target = "silentAccess";
		document.SpreadForm.submit();

	//	window.open('Controller?action=displayHighLight&mode=registColorOnly','_blank','width=600px,height=600px,statusbar=no,toolbar=no');
	//	showModalDialog("Controller?action=displayHighLight&mode=registColorOnly",self,"dialogHeight:650px;dialogWidth:550px;");
		showModalDialog("Controller?action=displayHighLight",self,"dialogHeight:720px;dialogWidth:550px;");
	}

// ============== ���|�[�g�̃G�N�X�|�[�g ===============================

	//�G�N�X�|�[�g�{�^���N���b�N
	function export_button_click() {

		// �T�[�o�ւ̃A�N�Z�X�󋵂�ݒ�(�C���[�W�𓮂���)
//		setLoadingStatus(true);

		// ���ݕ\������Ă���s/��̏����擾���Ahidden�ɕۑ�����
		// �i�e�����o���h�������Ŕ�\���ƂȂ��Ă��郁���o�͊܂߂Ȃ��B�j
		setViewingColRowInfo();

		// �F�����擾���Ahidden�ɕۑ�����
		setColorInfo();

		// �T�[�o�[�֑��M
		document.SpreadForm.action = "Controller?action=exportReport";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();

	}

	// ���ݕ\������Ă���s/��̏����擾���Ahidden�ɕۑ�����
	function setViewingColRowInfo() {

		// �d�����Ă���Key�����O���邽�߂�Dictionary���g�p����
		var viewCol0KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewCol1KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewCol2KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow0KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow1KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow2KeyDict = new ActiveXObject("Scripting.Dictionary");

		var viewColIndexKey_hidden = "";
		var viewRowIndexKey_hidden = "";

		// �s�E��w�b�_�̕\������SpreadIndex���X�g
		var colSpreadIndexArray = (new VBArray(viewingColSpreadIndexKeysDict.Keys())).toArray();
		var rowSpreadIndexArray = (new VBArray(viewingRowSpreadIndexKeysDict.Keys())).toArray();

		for ( var i = 0; i < colSpreadIndexArray.length; i++ ) {
			var colSpreadIndex = colSpreadIndexArray[i];
			var colKeyArray = viewingColSpreadIndexKeysDict.Item(colSpreadIndex);

			// Key���X�g(COL)
			if ( !viewCol0KeyDict.Exists(colKeyArray[0]) ) {
				viewCol0KeyDict.Add(colKeyArray[0], 1);
			}
			if ( colKeyArray[1] != "" ) {
				if ( !viewCol1KeyDict.Exists(colKeyArray[1]) ) {
					viewCol1KeyDict.Add(colKeyArray[1], 1);
				}
			}
			if ( colKeyArray[2] != "" ) {
				if ( !viewCol2KeyDict.Exists(colKeyArray[2]) ) {
					viewCol2KeyDict.Add(colKeyArray[2], 1);
				}
			}

			// SpreadIndex,Key���X�g(COL)
			if ( viewColIndexKey_hidden != "" ) {
				viewColIndexKey_hidden += ",";
			}
			viewColIndexKey_hidden += colSpreadIndex + ":" + colKeyArray.join(";");
		}

		for ( var i = 0; i < rowSpreadIndexArray.length; i++ ) {
			var rowSpreadIndex = rowSpreadIndexArray[i];
			var rowKeyArray = viewingRowSpreadIndexKeysDict.Item(rowSpreadIndex);

			// Key���X�g(ROW)
			if ( !viewRow0KeyDict.Exists(rowKeyArray[0]) ) {
				viewRow0KeyDict.Add(rowKeyArray[0], 1);
			}
			if ( rowKeyArray[1] != "" ) {
				if ( !viewRow1KeyDict.Exists(rowKeyArray[1]) ) {
					viewRow1KeyDict.Add(rowKeyArray[1], 1);
				}
			}
			if ( rowKeyArray[2] != "" ) {
				if ( !viewRow2KeyDict.Exists(rowKeyArray[2]) ) {
					viewRow2KeyDict.Add(rowKeyArray[2], 1);
				}
			}

			// SpreadIndex,Key���X�g(ROW)
			if ( viewRowIndexKey_hidden != "" ) {
				viewRowIndexKey_hidden += ",";
			}
			viewRowIndexKey_hidden += rowSpreadIndex + ":" + rowKeyArray.join(";");
		}


		// Dictionary ���Key���X�g���擾
		var viewColKeyArray = new Array(3);
			viewColKeyArray[0] = (new VBArray(viewCol0KeyDict.Keys())).toArray();
			viewColKeyArray[1] = (new VBArray(viewCol1KeyDict.Keys())).toArray();
			viewColKeyArray[2] = (new VBArray(viewCol2KeyDict.Keys())).toArray();

		var viewRowKeyArray = new Array(3);
			viewRowKeyArray[0] = (new VBArray(viewRow0KeyDict.Keys())).toArray();
			viewRowKeyArray[1] = (new VBArray(viewRow1KeyDict.Keys())).toArray();
			viewRowKeyArray[2] = (new VBArray(viewRow2KeyDict.Keys())).toArray();

		// hidden �֓o�^
		document.SpreadForm.viewCol0KeyList_hidden.value  = viewColKeyArray[0];
		document.SpreadForm.viewCol1KeyList_hidden.value  = viewColKeyArray[1];
		document.SpreadForm.viewCol2KeyList_hidden.value  = viewColKeyArray[2];
		document.SpreadForm.viewRow0KeyList_hidden.value  = viewRowKeyArray[0];
		document.SpreadForm.viewRow1KeyList_hidden.value  = viewRowKeyArray[1];
		document.SpreadForm.viewRow2KeyList_hidden.value  = viewRowKeyArray[2];

		document.SpreadForm.viewColIndexKey_hidden.value = viewColIndexKey_hidden;
		document.SpreadForm.viewRowIndexKey_hidden.value = viewRowIndexKey_hidden;

	}

	// �F����hidden�ɐݒ�
	function setColorInfo() {

		var colorIndexInfoArray = getColorIndexInfoArray();
		if ( colorIndexInfoArray != null ) {
			document.SpreadForm.colHdrColor.value = colorIndexInfoArray[0];	// ��w�b�_�[���̐F���
			document.SpreadForm.rowHdrColor.value = colorIndexInfoArray[1];	// �s�w�b�_�[���̐F���
			document.SpreadForm.dataHdrColor.value = colorIndexInfoArray[2];// �f�[�^�e�[�u�����̐F���

//alert("colValue:" + document.SpreadForm.colHdrColor.value);
//alert("rowValue:" + document.SpreadForm.rowHdrColor.value);
//alert("pageValue:" + document.SpreadForm.dataHdrColor.value);

		}
	}

// ============== ���|�[�g�ۑ� ================================================

	// ���|�[�g����ۑ�����
	function saveReportInfo(reportName, folderID) {

		// �T�[�o�ւ̃A�N�Z�X�󋵂�ݒ�(�C���[�W�𓮂���)
//		setLoadingStatus(true);

		// �h��������ۑ�
		var axes = axesXMLData.selectNodes("/root/Axes/Members");
		for ( var i = 0; i < axes.length; i++ ) {
			var drillStatString = "";
			var axisID = axes[i].getAttributeNode("id").value;
			var members = axes[i].selectNodes(".//Member");
//alert(members.length);

			for ( var j = 0; j < members.length; j++ ) {
				var thisNode = members[j];
				var uName = thisNode.selectSingleNode("UName").text;
				var isDrilled = thisNode.selectSingleNode("isDrilled").text;
				if ( isDrilled == "true" ) {
					isDrilled = "1";
				} else {
					isDrilled = "0";
				}
				if(drillStatString != "" ) {
					drillStatString += ",";
				}
				drillStatString += uName + ":" + isDrilled;
			}

			document.getElementById("dim" + axisID).value = drillStatString;
		}


		// �F�����擾
		var colorInfoArray = getColorArray();

		// �F����hidden�ɓo�^
		if( colorInfoArray != null ) {
			document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// �w�b�_�[���̐F���
			document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// �f�[�^�e�[�u���̐F���
		}

		// �T�[�o�[�֑��M
		document.SpreadForm.action = "Controller?action=saveClientReportStatus&reportName=" + reportName + "&folderID=" + folderID;
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();

	}

// ============== ���O�A�E�g ================================================

	// ���O�A�E�g���s
	function logout() {

		if ( showConfirm("CFM4") ) {
			document.SpreadForm.action = "Controller?action=logout";
			document.SpreadForm.target = "_top";
			document.SpreadForm.submit();
		}

	}

//********************************************************************
//********************************************************************
//********************************************************************

	// �h��Ԃ��A�n�C���C�g�؂�ւ��{�^�����N���b�N���ꂽ
	function clickColorButton(event){

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//�N���b�N�����{�^��������Ă����B
		button.blur();//�I���݂͂��Ȃ����B

		button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");

		// ���̕\�����̃^�C�v���擾
			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			var tempParentNode;
			var firstChildNodes;

			//���
			tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickColor(1)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

			//image
			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="<image src='./images/paint.gif' style='margin-left:5;margin-right:5'></image>";
			tempAhrefElement.appendChild(tempElement);

			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="�h��Ԃ�";

			tempAhrefElement.appendChild(tempElement);

			button.dimList.appendChild(tempAhrefElement);

			//�Q��
			tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickColor(2)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

			//image
			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="<image src='./images/highlight.gif' style='margin-left:5;margin-right:5'></image>";
			tempAhrefElement.appendChild(tempElement);

			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="�n�C���C�g";

			tempAhrefElement.appendChild(tempElement);

			button.dimList.appendChild(tempAhrefElement);



			bodyNode.appendChild(button.dimList);
			if (button.dimList.isInitialized == null){
				initializeDimList(button.dimList);
			}
//		}

		// ������
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// �N���b�N���ꂽ�X���C�T�[�{�^�����A�N�e�B�u�ɐݒ�
		if (button != activeSlicer) {
			changeSlicerStyle(button,40);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// �X�^�C���̏������C�x���g��ǉ�
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;

	}

	// �h��Ԃ��A�n�C���C�g�؂�ւ��{�^���ŁA�����Ƃ��ēn���ꂽ�ԍ�(1�A2)�̃{�^�����N���b�N���ꂽ
	function clickColor(no){
		if(activeSlicer!=null){
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

		// ���|�[�g���XML�X�V
		var colorTypeObj = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/colorType");
		if (no != colorTypeObj.text) { // ���|�[�g���XML�������̐ݒ�ƈقȂ�ꍇ�A�X�V����B
			colorTypeObj.text = no;
		} else {
			if(no == "1"){ // �h��Ԃ��̏�ԂŁA�h��Ԃ����I�����ꂽ�ꍇ�A�����I��
				return;
			}
		}

		if(no=="1"){ // �h��Ԃ�

			// �F�����擾���Ahidden�ɓo�^
//			var colorInfoArray = getColorArray();
//			if( colorInfoArray != null ) {
//				document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// �w�b�_�[���̐F���
//				document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// �f�[�^�e�[�u���̐F���
//			}

			document.all.tblColorBtn.style.display="block";
			document.all.tblHigtLightBtn.style.display="none";

			// �T�[�o�[�֑��M�E�ĕ\�������Ăяo��
//			document.SpreadForm.action="Controller?action=renewHtmlAct&mode=registColorOnly&newColorType=" + no;
			document.SpreadForm.action="Controller?action=renewHtmlAct&newColorType=" + no;
			document.SpreadForm.target='display_area';
//			document.SpreadForm.action="Controller?action=loadClientInitAct&newColorType=" + no;
//			document.SpreadForm.target='info_area';
			document.SpreadForm.submit();

		}else if(no=="2"){ // �n�C���C�g
			document.all.tblColorBtn.style.display="none";
			document.all.tblHigtLightBtn.style.display="block";
			openHighLight();

			// HighLight �́uOK�v�{�^���ŃZ�b�V�����֓o�^����
		}
		
	}

