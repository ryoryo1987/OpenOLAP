// *********************************************************
//  �_�C�X ����
// *********************************************************

	// *********************************************************
	//  �ϐ��錾��
	// *********************************************************
	var colEdgeComboMax = 500;	// ��ɔz�u�ł��鎟��/���W���[�̊e�i�̃����o�̐ς̍ő�l
	var rowEdgeComboMax = 2000;	// �s�ɔz�u�ł��鎟��/���W���[�̊e�i�̃����o�̐ς̍ő�l
	var spreadComboMax = 20000;	// Spread��ɔz�u�ł���s�E��̎���/���W���[�̊e�i�̃����o�̐ς̍ő�l

	// dragColor:���^�C�g�����A����ւ�/�}���\�Ȉʒu�ɂ���ꍇ�ɂ��F
	// 			 css/colorStyle.js�Őݒ�
	// defaultAxisTitleColor:���^�C�g���Z���̃f�t�H���g�F
	//			 			 css/colorStyle.js�Őݒ�

//	var dragLineWidth="3px";	// �����}���ʒu�ŕ\������r���̑���
	var sourceTd="";			// �h���b�O���̎��^�C�g����\��TD�I�u�W�F�N�g
	var sourceDim="";			// �h���b�O���̃G�b�W�i0:COL,1:ROW,2:PAGE�j
	var sourceNum="";			// �h���b�O���̃G�b�W���̎���Index(=hieIndex)
	var targetDim="";			// �h���b�O��̃G�b�W�i0:COL,1:ROW,2:PAGE�j
	var targetNum="";			// �h���b�O���̃G�b�W���̎���Index(=hieIndex)
	var diceType="";			// �_�C�X�̃^�C�v�i����ւ� or �}���j

	var dragableObj = null;		// �h���b�O���Ƀ}�E�X�|�C���^�̌��ǂ��I�u�W�F�N�g���i�[
	var axisTitleDepth = 5; 	// ���^�C�g���Z���̊K�w�̐[���̍ő�l

	// *********************************************************
	//  �C�x���g�֐�
	// *********************************************************

	// �h���b�O���s�Ȃ��I�u�W�F�N�g���A�}�E�X�|�C���^���ǂꂾ���E�ɕ\�����邩�B
	var dragObjDeltaX = 10;

	// �h���b�O�X�^�[�g
	function axisTitleDown(obj) {

		//�E�N���b�N�̏ꍇ�̓h���b�O���[�h���I��
		if(event.button==2) {
			return;
		}

		//�N���X�w�b�_���́A���ύX�\�G���A�̏ꍇ�̓h���b�O���[�h���I��
		if (onCrossHeaderCellVLine(event)) {
			return;
		}

		//�ړ����I�u�W�F�N�g(TD)���擾
		sourceTd = obj.parentNode.parentNode.parentNode;

		//�h���b�O���ɂ��Ă���C���[�W�I�u�W�F�N�g(DIV)��\��
		dragableObj               = document.all("dragNode");
		dragableObj.style.left    = event.clientX + dragObjDeltaX;
		dragableObj.style.top     = event.clientY;
		dragableObj.firstChild.nextSibling.innerText = sourceTd.firstChild.firstChild.firstChild.nextSibling.innerText;
		dragableObj.style.display = "inline";
		dragableObj.dispName      = sourceTd.firstChild.firstChild.firstChild.nextSibling.innerText; // �\���p�̖���

		// �C�x���g�̕t�^
		document.attachEvent( "onmousemove", dragAxis );	// �h���b�O�C�x���g
		document.attachEvent( "onmouseup", dragStatusClear ); // �h���b�O��Ԃ̃N���A�C�x���g
	}

	// ���̃h���b�O
	function dragAxis() {
		if ( dragableObj == null ) { return; }

		// �h���b�O�ɍ��킹�Ď���/���W���[�A�C�R���Ɩ��̂��ړ�����
		dragableObj.style.left    = event.clientX + dragObjDeltaX;
		dragableObj.style.top     = event.clientY;

		// ���^�C�g���Z���̃X�^�C����ύX
		var axisTitleCell = getAxisTitleCell(window.event.srcElement);
		if ( axisTitleCell != null ) {
			adjustAxisNameCellStyle(axisTitleCell);
		} else {
			// null �̏ꍇ�͎��^�C�g���Z����Ƀ}�E�X���������߉������Ȃ�
			backDraggableToDefaultStyle(dragableObj);	// �h���b�O�I�u�W�F�N�g�̃X�^�C�������ɖ߂�
		}

	}

	// �_�C�X�������s
	function axisTitleUp(targetTd) {
		if ( sourceTd == "" ) { return; }
		if ( sourceTd == targetTd ) { return; }

		sourceDim=sourceTd.dragtype;
		sourceNum=sourceTd.cellIndex;
		targetDim=targetTd.dragtype;
		targetNum=targetTd.cellIndex;

		if ( targetTd.id == "insertArea" ) {	// PageEdge�Ɏ��������ݒ�ŁAtarget=PageEdge�̏ꍇ
			diceType="insert";
		} else {
			//�ړ�����Z���̂R�����v�Z�ɂ�蒲��
			if(cellCheck(targetTd)=="1"){
				diceType="insert";
			}else if(cellCheck(targetTd)=="2"){
				diceType="replace";
			}else if(cellCheck(targetTd)=="3"){
				targetNum=targetNum+1;
				diceType="insert";
			}
		}

		//���̌��ʁA�ړ��悪�ړ����Ɠ����ł����return;
		if(((sourceDim==targetDim)&&(sourceNum==targetNum)) || ((sourceDim=="2")&&(targetDim=="2"))){
			return;
		}

		// ���������� XML�X�V���� ����������
		// �����ݒ�
		var sourceDimName;
		var targetDimName;
			if ( sourceDim == "0" ) {
				sourceDimName = "COL";
			} else if ( sourceDim == "1" ) {
				sourceDimName = "ROW";
			} else if ( sourceDim == "2" ) {
				sourceDimName = "PAGE";
			}
			if ( targetDim == "0" ) {
				targetDimName = "COL";
			} else if ( targetDim == "1" ) {
				targetDimName = "ROW";
			} else if ( targetDim == "2" ) {
				targetDimName = "PAGE";
			}

		// ===== ����ւ��E�}�������̔��� =====
		var colEdgeNode  = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/COL");
		var rowEdgeNode  = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/ROW");
		var pageEdgeNode = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/PAGE");
		var colNodes  = colEdgeNode.selectNodes("./HierarchyID");
		var rowNodes  = rowEdgeNode.selectNodes("./HierarchyID");
		var pageNodes = pageEdgeNode.selectNodes("./HierarchyID");

		var sourceNodes;
		var targetNodes;
			if ( sourceDimName == "COL" ) {
				sourceNodes = colNodes;
			} else if ( sourceDimName == "ROW" ) {
				sourceNodes = rowNodes;
			} else if ( sourceDimName == "PAGE" ) {
				sourceNodes = pageNodes;
			}

			if ( targetDimName == "COL" ) {
				targetNodes = colNodes;
			} else if ( targetDimName == "ROW" ) {
				targetNodes = rowNodes;
			} else if ( targetDimName == "PAGE" ) {
				targetNodes = pageNodes;
			}

		var checkFLG = isDragOK( diceType, sourceDimName, sourceNum, sourceNodes, targetDimName, targetNum,targetNodes, colNodes, rowNodes );

		if ( checkFLG == false ) {
			return;
		}

		// ===== ��������ւ�/�}������ =====

		var sourceEdgeNode;	// �ړ����̃G�b�W�̂w�l�k�m�[�h
		var targetEdgeNode;	// �ړ���̃G�b�W�̂w�l�k�m�[�h
			if ( sourceDimName == "COL" ) {
				sourceEdgeNode = colEdgeNode;
			} else if ( sourceDimName == "ROW" ) {
				sourceEdgeNode = rowEdgeNode;
			} else if ( sourceDimName == "PAGE" ) {
				sourceEdgeNode = pageEdgeNode;
			}
			if ( targetDimName == "COL" ) {
				targetEdgeNode = colEdgeNode;
			} else if ( targetDimName == "ROW" ) {
				targetEdgeNode = rowEdgeNode;
			} else if ( targetDimName == "PAGE" ) {
				targetEdgeNode = pageEdgeNode;
			}

		var sourceNode = sourceNodes[sourceNum];	// �ړ����̎���/���W���[�̂w�l�k�m�[�h
		var targetNode = targetNodes[targetNum];	// �ړ���̎���/���W���[�̂w�l�k�m�[�h

		if ( diceType == "replace" ) {	// ��������ւ��̏ꍇ

			var sourceNextNode = sourceNodes[sourceNum+1];
			targetEdgeNode.replaceChild( sourceNode, targetNode );

			if ( sourceNextNode == null ) {	// �h���b�O�����ŏI�i
				sourceEdgeNode.appendChild( targetNode );
			} else {
				if ( targetNode.childNodes[0].text == sourceNextNode.childNodes[0].text) {
					// �}���ꏊ���A����ւ����XML�̏�Ԃ���擾���邽�߁A�ēx�擾����
					var insertNode = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/"+ sourceDimName +"/HierarchyID[" + (sourceNum+1) + "]");
					sourceEdgeNode.insertBefore( targetNode, insertNode );
				}
				sourceEdgeNode.insertBefore( targetNode, sourceNextNode );
			}

		} else if ( diceType == "insert" ) {	// �����}���̏ꍇ
			if ( targetNode == null ) {	// target���̍Ō�֒ǉ� or 
										// �y�[�W�G�b�W�Ɏ����������ꍇ�̃y�[�W�G�b�W�ւ̒ǉ�
				targetEdgeNode.appendChild( sourceNode );
			} else {
				targetEdgeNode.insertBefore( sourceNode, targetNode );
			}
		}

		// ���������� �T�[�o�[����Spread���X�V���ĕ\�� ����������

		// GIF�C���[�W�𓮂����i�T�[�o�[�ւ̃A�N�Z�X���������j
//		parent.display_area.setLoadingStatus(true);

		// ���̔z�u���
		var colAxisListString  = getAxisIdListInEdge( "COL", axesXMLData );
		var rowAxisListString  = getAxisIdListInEdge( "ROW", axesXMLData );
		var pageAxisListString = getAxisIdListInEdge( "PAGE", axesXMLData );
		document.SpreadForm.colItems.value  = colAxisListString;
		document.SpreadForm.rowItems.value  = rowAxisListString;
		document.SpreadForm.pageItems.value = pageAxisListString;

		// �F�����擾
		var colorInfoArray = getColorArray();
		if( colorInfoArray != null ) {
			document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// �w�b�_�[���̐F���
			document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// �f�[�^�e�[�u���̐F���
		}

		// �T�[�o�[�֑��M�E�ĕ\�������Ăяo��
		document.SpreadForm.action='Controller?action=renewHtmlAct&mode=registColorSetings';
		document.SpreadForm.target='display_area';
		document.SpreadForm.submit();
	}


	// ���^�C�g���Z������}�E�X���o��
	function axisTitleOut(tdObj) {
		backDraggableToDefaultStyle(dragableObj);
//		cellClear(tdObj);	// �Z���̃X�^�C�����N���A
	}

	// *********************************************************
	//  �X�^�C���֐��i�ݒ�j
	// *********************************************************

	// �h���b�O���Ă���I�u�W�F�N�g�̃X�^�C����ύX
	function adjustAxisNameCellStyle(targetTd) {
		if ( sourceTd == targetTd ) { // �ړ����ƈړ��悪�����Z���̏ꍇ�A����
			backDraggableToDefaultStyle(dragableObj);
			return; 
		}

		if ( ( sourceTd.parentNode.parentNode.parentNode.id == "pageEdgeTable" ) && 
	         ( targetTd.parentNode.parentNode.parentNode.id == "pageEdgeTable" )
	       ) { 
			backDraggableToDefaultStyle(dragableObj);
			return; 
		}

		if ( targetTd.id == "insertArea" ) {	
		// �y�[�W�G�b�W�̑}���p�G���A�֎���/���W���[��}��
		// ���y�[�W�G�b�W�̑}���p�G���A�F�y�[�W�G�b�W�Ɏ���/���W���[���z�u����Ă��Ȃ��ꍇ�ɕ\��

			changeDraggableToInsertStyle(dragableObj);

//			if ( dragableObj.firstChild.className != 'insertIMG' ) {
//				dragableObj.firstChild.removeAttribute("class");
//				dragableObj.firstChild.className = 'insertIMG';
//			}

//			targetTd.style.backgroundColor=dragColor;
//			targetTd.firstChild.firstChild.firstChild.nextSibling.style.backgroundColor=dragColor;
		} else {

//			if (dragableObj.firstChild.className != 'replaceIMG') {
//				dragableObj.firstChild.removeAttribute("class");
//				dragableObj.firstChild.className = 'replaceIMG';
//			}


			if(cellCheck(targetTd)=="1") {
				changeDraggableToInsertStyle(dragableObj);
/*
				if ( targetTd.dragtype != "2" ) {	// �h���b�O�悪�s����
					targetTd.style.padding="0px "+dragLineWidth+" 0px 0px";
					targetTd.style.borderLeftWidth=dragLineWidth;
				}
				targetTd.style.borderLeftColor=dragColor;
*/
			}else if( ( cellCheck(targetTd)=="2" ) ){
				changeDraggableToReplaceStyle(dragableObj, targetTd);
/*
				if ( targetTd.dragtype == "2" ) {	// �h���b�O�悪�y�[�W
					targetTd.style.borderColor=dragColor;
				}
				targetTd.style.backgroundColor=dragColor;
				targetTd.firstChild.firstChild.firstChild.nextSibling.style.backgroundColor=dragColor;
*/
			}else if(cellCheck(targetTd)=="3"){
				changeDraggableToInsertStyle(dragableObj);
/*
				if ( targetTd.dragtype != "2" ) {	// �h���b�O�悪�s����
					targetTd.style.padding="0px 0px 0px "+dragLineWidth;
					targetTd.style.borderRightWidth=dragLineWidth;
				}
				targetTd.style.borderRightColor=dragColor;
*/
			}

		}

	}


	// �h���b�O���Ă���I�u�W�F�N�g�̃X�^�C�����f�t�H���g�ɕύX
	function backDraggableToDefaultStyle(dragableNode) {
		if ( dragableNode == null ) { return; }
		if ( dragableNode.firstChild.className != 'dragAxisIMG' ) {
			dragableNode.firstChild.removeAttribute("class");
			dragableNode.firstChild.className = 'dragAxisIMG';

			dragableNode.firstChild.nextSibling.removeAttribute("class");
			dragableNode.firstChild.nextSibling.className = 'dragAxisCenter';

			dragableNode.firstChild.nextSibling.innerText = dragableNode.dispName;

			dragableNode.firstChild.nextSibling.nextSibling.style.display = "inline";

		}
	}

	// �h���b�O���Ă���I�u�W�F�N�g�̃X�^�C����}�����[�h�ɕύX
	function changeDraggableToInsertStyle(dragableNode) {
		if ( dragableNode == null ) { return; }
		if ( dragableNode.firstChild.className != 'insertIMG' ) {

			var sourceDimName = getAxisName(sourceTd);	// �u�����̃f�B�����V������

			dragableNode.firstChild.removeAttribute("class");
			dragableNode.firstChild.className = 'insertIMG';

			dragableNode.firstChild.nextSibling.removeAttribute("class");
			dragableNode.firstChild.nextSibling.className = 'insertDimName';

			dragableNode.firstChild.nextSibling.innerHTML = "<span style='font-weight:bold'>" + sourceDimName + "</span> ��}��";

			dragableNode.firstChild.nextSibling.nextSibling.style.display = "none";

		}
	}

	// �h���b�O���Ă���I�u�W�F�N�g�̃X�^�C����u�����[�h�ɕύX
	function changeDraggableToReplaceStyle(dragableNode, targetTd) {
		if ( dragableNode == null ) { return; }
		if ( dragableNode.firstChild.className != 'replaceIMG' ) {

			var targetDimName = getAxisName(targetTd);	// �u����̃f�B�����V������
			var sourceDimName = getAxisName(sourceTd);	// �u�����̃f�B�����V������

			dragableNode.firstChild.removeAttribute("class");
			dragableNode.firstChild.className = 'replaceIMG';

			dragableNode.firstChild.nextSibling.removeAttribute("class");
			dragableNode.firstChild.nextSibling.className = 'replaceDimName';
			dragableNode.firstChild.nextSibling.innerHTML = "<span style='font-weight:bold'>" + sourceDimName + "</span> ��<br><span style='font-weight:bold'>" + targetDimName + "</span> �����ւ�";

			dragableNode.firstChild.nextSibling.nextSibling.style.display = "none";

		}
	}

	// �������擾����i���W���[�̏ꍇ�́A�u���W���[�v�ƂȂ�j
	// 	input  node     ���^�C�g��������сA�X���C�T�[�{�^����\��TD�I�u�W�F�N�g
	// 	return axisName ����\������
	function getAxisName(node) {
		var axisName = null;
			if (node.dragtype == "2") { // node���y�[�W�G�b�W
				axisName = node.title;
			} else if ( (node.dragtype == "0") || (node.dragtype == "1") ) { // node���s�G�b�W�A��G�b�W
				axisName = node.firstChild.firstChild.firstChild.nextSibling.innerText;
			}

		return axisName;
	}

	// *********************************************************
	//  �X�^�C���֐��i�N���A�j
	// *********************************************************

	// �h���b�O��Ԃ��N���A
	function clearDragStatus() {

		//�h���b�O���ɂ��Ă���C���[�W�I�u�W�F�N�g(DIV)������
		if(dragableObj!=null){
			dragableObj.style.display = "none";
			dragableObj = null;
		}
		// �C�x���g���폜
		document.detachEvent( "onmousemove", dragAxis );
		document.detachEvent( "onmouseup", dragStatusClear );

	}

//	//�Z���̃X�^�C���i�킫�̐����E�Z���F�j���N���A
//	function cellClear(tdObj){
//
//		if ( tdObj.dragtype != "2" ) {	// �h���b�O�悪�s����
//			tdObj.style.borderLeftWidth  = "0";
//			tdObj.style.borderRightWidth = "0";
//			tdObj.style.padding = "0px "+dragLineWidth+" 0px "+dragLineWidth;
//			tdObj.style.borderLeftColor  = defaultAxisTitleColor;
//			tdObj.style.borderRightColor = defaultAxisTitleColor;
//		} else {
//			tdObj.style.borderColor  = defaultAxisTitleColor;
//		}
//
//		tdObj.style.backgroundColor  = defaultAxisTitleColor;
//		tdObj.firstChild.firstChild.firstChild.nextSibling.style.backgroundColor = defaultAxisTitleColor;
//	}

	function dragStatusClear() {//������
		sourceTdClear();
		clearDragStatus();
	}

	function sourceTdClear(){
		sourceTd="";	// TD�̏�����
	}

	// *********************************************************
	//  �ʒu�擾�֐�
	// *********************************************************

	// ���^�C�g���Z�����̃����o�ł���΁A���^�C�g���Z�������߂�
	function getAxisTitleCell( node ) {

		if (node == null) { return null; }
		if ( (node.tagName != "DIV") && (node.tagName != "A") && (node.tagName != "NOBR") && (node.tagName != "TD") ) { return null; }

		// ���^�C�g���Z���̊K�w�̐[���̕�������ɒH���Ď��^�C�g���Z����T��
		for ( var i = 0; i < axisTitleDepth; i++ ) { 
			if (node == null) {
				break;
			}

			if (node.axisTitle == "1") {//���^�C�g���Z�����̃����o�ł�����
				return node; //���^�C�g���Z����Ԃ�
			}

			node = node.parentNode;
		}

		return null;
	}


	//�Z�����O�����ɂ��ĉ��ԖڂɃ}�E�X�|�C���^�����邩��Ԃ��i�����FTD�G�������g�A�߂�l�F�ԍ��j
	function cellCheck(tdObj) {
/*
alert(tdObj.outerHTML + "\n\n" + event.srcElement.tagName + "\n" 
      + "pageX:" + event.pageX + "\n" 
      + "screenX:" + event.screenX + "\n" 
      + "event.offsetX:" + event.offsetX + "\n" 
      + "event.srcElement.clientLeft:" + event.srcElement.clientLeft + "\n" 
      + "event.srcElement.offsetLeft:" + event.srcElement.offsetLeft + "\n" 
      + "event.srcElement.scrollLeft:" + event.srcElement.scrollLeft + "\n" 
      + "tdObj.clientLeft:" + tdObj.clientLeft + "\n" 
      + "tdObj.clientWidth:" + tdObj.clientWidth + "\n" 
      + "tdObj.offsetWidth:" + tdObj.offsetWidth
);
*/

//	var startObj = tdObj.firstChild.firstChild.firstChild;

		// �}�E�X�|�C���^�̃Z�����ł�X���W���擾
		var x = getAxisTitleX(tdObj, event);

			// X���W�̕␳���s�Ȃ�
//			if (tdObj.dragtype == "0") {				// ��w�b�_�̎����\���Z��
//				if ( event.srcElement.id == "axisCenter" ) {
//					x += startObj.clientWidth;
//				} else if ( event.srcElement.id == "axisRight" ) {
//					x += startObj.clientWidth + startObj.nextSibling.clientWidth;
//				}
//			} else if (tdObj.dragtype == "1") {			// �s�w�b�_�̎����\���Z��
//				if ( event.srcElement.id == "axisCenter" ) {
//					x += startObj.clientWidth;
//				}
//			} else if (tdObj.dragtype == "2") {			// �y�[�W�G�b�W�̃X���C�T�[�{�^��
//				if ( event.srcElement.tagName == "A" ) { // �y�[�W�G�b�W���A�����J�ŃC�x���g����
//					x += startObj.clientWidth;
//				}
//			}

/*
alert(
        tdObj.outerHTML + "\n\n"
      + "event.srcElement.outerHTML:" + event.srcElement.outerHTML + "\n" 
      + "x:" + x + "\n"
      + "startObj.clientWidth:" + startObj.clientWidth + "\n"
      + "startObj.nextSibling.clientWidth:" + startObj.nextSibling.clientWidth + "\n"
      + "startObj.nextSibling.nextSibling.clientWidth:" + startObj.nextSibling.nextSibling.clientWidth + "\n"
      + "tdObj.clientWidth:" + tdObj.clientWidth + "\n"
      + "tdObj.offsetWidth:" + tdObj.offsetWidth + "\n"
);
*/

		if(x<=tdObj.offsetWidth*0.2){
			return "1";
		}else if(x<=tdObj.offsetWidth*0.8){
			return "2";
		}else{
			return "3";
		}
	}

	// *********************************************************
	//  ���̑��֐�
	// *********************************************************

	// �C�x���g���������������\��TD�I�u�W�F�N�g���ɂ�����AX���W�����߂�B
	//		obj�F�C�x���g���������������\��TD�I�u�W�F�N�g
	//		e: �C�x���g
	function getAxisTitleX(obj, e) {

		var tdObj = obj;
		var event = e;

		var newX = e.offsetX;

		var startObj;
		if ( (tdObj.firstChild != null) && (tdObj.firstChild.firstChild != null) && (tdObj.firstChild.firstChild.firstChild != null) ) {
			startObj = tdObj.firstChild.firstChild.firstChild;
		}

		// X���W�̕␳���s�Ȃ�
		if (tdObj.dragtype == "0") {				// ��w�b�_�̎����\���Z��
			if ( event.srcElement.id == "axisCenter" ) {
				newX += startObj.clientWidth;
			} else if ( event.srcElement.id == "axisRight" ) {
				newX += startObj.clientWidth + startObj.nextSibling.clientWidth;
			}
		} else if (tdObj.dragtype == "1") {			// �s�w�b�_�̎����\���Z��
			if ( event.srcElement.id == "axisCenter" ) {
				newX += startObj.clientWidth;
			}
		} else if (tdObj.dragtype == "2") {			// �y�[�W�G�b�W�̃X���C�T�[�{�^��
			if ( event.srcElement.tagName == "A" ) { // �y�[�W�G�b�W���A�����J�ŃC�x���g����
				newX += startObj.clientWidth;
			}
		}

		return newX;

	}

	// �h���b�O�ۂ𔻒f����
	function isDragOK ( diceType, sourceDimName, sourceNum, sourceNodes, targetDimName, targetNum,targetNodes, colNodes, rowNodes ) {


		// �����̑}�����s�Ȃ��Ă��A�s�܂��͗�̒i����0�ɂȂ�Ȃ����H
		if ( ( diceType == "insert" ) && 
	         ( sourceDimName == "COL" || sourceDimName == "ROW" ) &&
	         ( sourceNodes.length == 1 ) ) {
			showMessage( "1", sourceDimName );
			return false;
		}

		// �����̑}�����s�Ȃ��Ă��A�s�܂��͗�̒i����4�ȏ�ɂȂ�Ȃ����H
		if ( ( diceType == "insert" ) && 
	         ( targetDimName == "COL" || targetDimName == "ROW" ) &&
	         ( targetNodes.length == 3 ) ) {
			showMessage( "2", targetDimName );
			return false;
		}

		// �����̓���ւ��E�}����̃f�[�^�e�[�u���̍s�܂��͗�̐���
		// �K��l(colEdgeComboMax or rowEdgeComboMax)�ȓ���

		// �s�܂��͗�̐����ω�������ꍇ
		if ( ( targetDimName == "COL" || targetDimName == "ROW" ) &&
		     ( sourceDimName != targetDimName ) ) {

			var edgeComboNum = 1;
			var edgeID    = 0;
			var tmpMemNum = 0;

			// �ړ���̃G�b�W�̊e�i�̎���/���W���[�����o���̐ς����߂�
			for ( var i = 0; i < targetNodes.length; i++ ) {
				// ����ID���擾
				edgeID = targetNodes[i].text;

				// ��������ւ����ɂ͓���ւ��Ώێ���/���W���[���X�L�b�v
				if ( ( diceType == "replace" ) && 
				     ( targetNum  == i ) ) {
					continue;
				}

				// �g�ݍ��킹�����擾
				tmpMemNum = parseInt( document.all("dimNumbers").all(edgeID).innerText );
				edgeComboNum = edgeComboNum * tmpMemNum;
			}

			// ����Ɉړ����̎���/���W���[�̃����o������Z����
			edgeID = sourceNodes[sourceNum].text;	// ����ID
			tmpMemNum = parseInt( document.all("dimNumbers").all(edgeID).innerText );
			edgeComboNum = edgeComboNum * tmpMemNum;

			// ����𒴂��Ă��Ȃ���

			if ( targetDimName == "COL" ) {
				if ( edgeComboNum > colEdgeComboMax ) {
					showMessage( "3", colEdgeComboMax, targetDimName );
					return false;
				}
			} else if ( targetDimName == "ROW" ) {
				if ( edgeComboNum > rowEdgeComboMax ) {
					showMessage( "3", rowEdgeComboMax, targetDimName );
					return false;
				}
			}
		}

		// �f�[�^�e�[�u���̃Z�����i�s�Ɨ�̊e�i�̃����o���v�̐ρj��
		// �K��l(spreadComboMax)�ȓ���

		// �f�[�^�e�[�u���Z�������ω�������ꍇ
		if ( ( sourceDimName == "PAGE" ) && 
		     ( targetDimName == "COL" || targetDimName == "ROW" ) ) {

			var spreadComboNum = 1;

			// ��G�b�W�̌v�Z
			for ( var i = 0; i < colNodes.length; i++ ) {
				// ����ID���擾
				edgeID = colNodes[i].text;

				// �y�[�W�G�b�W����̎�������ւ����F����ւ��Ώێ���/���W���[���X�L�b�v
				if ( ( sourceDimName == "PAGE" ) &&
				     ( targetDimName == "COL"  ) &&
				     ( diceType == "replace" ) &&
				     ( targetNum  == i ) ) {
					continue;
				}

				// �g�ݍ��킹�����擾
				tmpMemNum = parseInt( document.all("dimNumbers").all(edgeID).innerText );
				spreadComboNum = spreadComboNum * tmpMemNum;
			}

			// �s�G�b�W�̌v�Z(��G�b�W�̌v�Z���ʂɑ΂��ď�Z)
			for ( var i = 0; i < rowNodes.length; i++ ) {
				// ����ID���擾
				edgeID = rowNodes[i].text;

				// �y�[�W�G�b�W����̎�������ւ����F����ւ��Ώێ���/���W���[���X�L�b�v
				if ( ( sourceDimName == "PAGE" ) &&
				     ( targetDimName == "ROW" ) &&
				     ( diceType == "replace" ) && 
				     ( targetNum  == i ) ) {
					continue;
				}

				// �g�ݍ��킹�����擾
				tmpMemNum = parseInt( document.all("dimNumbers").all(edgeID).innerText );
				spreadComboNum = spreadComboNum * tmpMemNum;
			}

			// �ړ������y�[�W�G�b�W�F����Ɉړ����̎���/���W���[�̃����o������Z����
			if ( sourceDimName == "PAGE" ) {
				edgeID = sourceNodes[sourceNum].text;	// ����ID
				tmpMemNum = parseInt( document.all("dimNumbers").all(edgeID).innerText );
				spreadComboNum = spreadComboNum * tmpMemNum;
			}

			// ����𒴂��Ă��Ȃ���
			if ( ( targetDimName == "COL" || targetDimName == "ROW" ) &&
		         ( spreadComboNum > spreadComboMax ) ) {

				showMessage( "4", spreadComboMax );
				return false;
			}

		}

		return true;
	}

