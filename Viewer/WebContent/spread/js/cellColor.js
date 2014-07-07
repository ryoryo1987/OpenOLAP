
// *************************************************************************************************
// �F�Â��̃f�[�^�\��
//	�E�Z��(TD�I�u�W�F�N�g)�̑���
//		<TD object>.selected: �Z�����I������Ă����"1"�A�I������Ă��Ȃ����"0"�B������Ԃł͑����Ȃ��B
//		<TD object>.colorName: �Z���ɂ����Ă���F�̖���(��F�uRed�v,�uPurple�vetc)
//		<TD object>.style.backgroundColor: ���ۂɃZ���ɂ��Ă���F�i�A�z�z����擾�j 
//	�E�A�z�z��
//		�|associationColorArray[]
//			Key:css/cellColorTable*.js�Œ�`���ꂽ�Z���F��ID�B(��:hdrRed�AhdrRedSelected)
//			Value:�F�̒l(��:#ffffff)
// *************************************************************************************************

// ============== �Z���I�� ==================================================
	var previousClickedCell = null;		// �O��I�����ꂽ�Z���̃I�u�W�F�N�g
	var coloredCellList  = new ActiveXObject("Scripting.Dictionary"); // �F�Â��ς݂̃Z�����X�g(Key:id,Value:Object)
	var selectedCellList = new ActiveXObject("Scripting.Dictionary"); // �I����Ԃ̃Z�����X�g(Key:id,Value:Object)

	// ���|�[�g�ɃZ�������݂��Ȃ����ߐF�Â��ł��Ȃ��Z�������i�[�B
	// �i�Z���N�^�ŊO���ꂽ�A���ړ��Ń��|�[�g�\�����ω������Ȃǂ̏ꍇ�ɔ����j
	var disableHdrColorString = "";	// �w�b�_��
	var disableDtColorString  = "";	// Spread�e�[�u����

//	var selectedPrefix = "selected"; 	// �I�𒆂�\���X�^�C���ɂ��ړ���
	var selectedSuffix = "Selected";	// �I�𒆂�\���X�^�C���ɂ��ڔ���

	// *********************************************************
	//  ���C�������֐�
	// *********************************************************

	// �Z�����I�����ꂽ(�Z���N���b�N�C�x���g)
	function cellClicked() {

		//�n�C���C�g�̏ꍇ�͐F�Â��ł��Ȃ�
		if(parent.display_area.document.all.tblHigtLightBtn.style.display=="block"){
			return;
		}



		var node = null;// �s�E��w�b�_�̃Z��(TD)
		if ( event.srcElement.tagName == "TD" ) {
			node = event.srcElement;
		} else if ( event.srcElement.tagName == "NOBR" ) {
			node = event.srcElement.parentNode;
		} else {
			return; 
		}

		if ( node.id == "adjustCell" ) { return; }	// adjustCell�̏ꍇ�͏������Ȃ�

		// ���ύX�̏ꍇ�A�Z���I�������͎��s���Ȃ�
		if ( changedColRange ) { 
			changedColRange = false;
			return; 
		}

		// �O��N���b�N���ꂽ�Z���Ɠ����Z�����N���b�N�F�I���σZ�����N���A���A�I��
		// �O��N���b�N���ꂽ�Z���ƈႤ�Z�����N���b�N�F�I���σZ�����N���A���A����N���b�N���ꂽ�Z����I������
		if ( previousClickedCell != null ) {
			if ( previousClickedCell.id == node.id ) {
				clearSelectedCell();
				return;
			} else {
				clearSelectedCell();
			}
		}

		// �I����Ԃɂ���Z���̃X�^�C����ύX
		applyColorStyleToCell ( node );

		// �N���b�N���ꂽ�Z��������I���܂ŉ��ۑ�
		previousClickedCell = node;

	}


	// �I���ς݂̃Z���Ɏw�肳�ꂽ�F�X�^�C����ݒ肷��
	// input: colorStyle : �F��\���X�^�C����
	function setColorToSelectedCell ( colorName ) {
		if ( previousClickedCell == null ) { return; }

		var dicArray = (new VBArray(selectedCellList.Keys())).toArray();
		if ( dicArray.length == 0 ) { return; }

		var node;
		for( var i = 0; i < dicArray.length; i++) {

			node = selectedCellList.Item(dicArray[i]);

			// �F�Â�
			paintCellColor( node, colorName );

			// �F�Â��ς݂̃Z��id���X�g���X�V
			if( coloredCellList.Exists(node.id) ) { //�F�Â�����Ă���
				if ( colorName == "" ) { //�p���b�g�Łu�h��Ԃ��Ȃ��v��I�����ꂽ
					coloredCellList.Remove( node.id );
				}
			} else { // �F�Â�����Ă��Ȃ�
				if ( colorName != "" ) { // �F�X�^�C����ݒ�
					coloredCellList.add( node.id, node );
				}
			}

		}

		// ������
		previousClickedCell = null;
		selectedCellList = new ActiveXObject("Scripting.Dictionary");
	}

	// *********************************************************
	//  �X�^�C������֐��i�w�b�_�A�f�[�^�e�[�u���j
	// *********************************************************

	// �N���b�N���ꂽ�Z���ɂ��A�ύX�ΏۃZ���̃X�^�C���ύX���s��
	function applyColorStyleToCell( ele ) {

		// ���N���b�N���ꂽ�Z���F�f�[�^�e�[�u���̃Z�����Z���̐F��ύX
		if ( getCellPosition( ele ) == "DATA" ) {
			setColorStyle( ele );
			return;
		}

		// ���N���b�N���ꂽ�Z���F��E�s�w�b�_�[�̃Z�����w�b�_���A�Ή�����f�[�^�e�[�u���̗�E�s�̐F��ύX
		changeHeaderCellsStyle(ele);		// �w�b�_��
		changeDataTableCellsStyle( ele );	// �f�[�^�e�[�u����
	}

	// �w�b�_�Z���̃X�^�C����ύX
	function changeHeaderCellsStyle( node ) {

		var hieIndex = getHieIndex(node);

		// �����̒i
		setColorStyle(node);

		// �����|�P�i
		if (( getHeaderObjNum(getCellPosition(node)) >= 2 ) && ( !isLastHie(node) )) {
			var childCells = getUnderHieNodes(node);
			for ( var i = 0; i < childCells.length; i++ ) {
				setColorStyle(childCells[i]);
			}

			// �����|�Q�i
			if (( getHeaderObjNum(getCellPosition(node)) == 3 ) && ( hieIndex == 0 )) {
				var grandChilds = getUnder2HieNodes(node);
				for ( var i = 0; i < grandChilds.length; i++ ) {
					setColorStyle(grandChilds[i]);
				}
			}
		}
	}

	// �f�[�^�e�[�u���Z���̃X�^�C����ύX
	// 	targetNode: ��FCOL�I�u�W�F�N�g�A�s�FTR�I�u�W�F�N�g
	// 	ele:  �N���b�N���ꂽ�I�u�W�F�N�g�i�s/��̃Z��TD�j
	function changeDataTableCellsStyle( ele ) {
		var target = getSpreadNodeByTDObj( ele );
		var loopMax = getDataTableCellNumbers( getCellPosition ( ele ) ); // �������̗�/�s�����Z����
		var targetEdge = getCellPosition(ele); // COL or ROW

		for ( var i = 0; i < getLowerHieComboNum( ele, getCellPosition(ele) ); i++ ) {//�I�����ꂽ��/�s�̃��[�v
			var index = 0;	// �������̗�/�s��Index
			if ( isCellInColHeader(ele) ) {
				index = parseInt( getCOLIndexByCOLObj(target) );
			} else if ( isCellInRowHeader(ele) ) {
				index = parseInt( getRowIndexByTRObj(target) );
			}

			var x,y;
			for ( var j = 0; j < loopMax; j++ ) {	//�������̗�/�s�����Z����������郋�[�v
				// �Z�����W�̎Z�o
				if ( targetEdge == "COL" ) {
					x = index;
					y = j;
				} else if ( targetEdge == "ROW" ) {
					x = j;
					y = index;
				}
				// �Z���̐F�Â�
				setColorStyle ( dataTable.rows(y).cells(x) );
			}

			target = target.nextSibling;
		}
	}

	// *********************************************************
	//  �X�^�C������֐��i�Z���j
	// *********************************************************

	// �I���ς݃Z���̃X�^�C������������
	function clearSelectedCell ( ) {

		if ( previousClickedCell == null ) { return; }
		var dicArray = (new VBArray(selectedCellList.Keys())).toArray();
		if ( dicArray.length == 0 ) { return; }

		var node;
		for( var i = 0; i < dicArray.length; i++) {
			node = selectedCellList(dicArray[i]);
			makeUnSelectedColor(node);
		}

		// ������
		previousClickedCell = null;
		selectedCellList.RemoveAll();
	}


	// �F�̃X�^�C����ݒ肷��
	function setColorStyle( node ) {

		makeSelectedColor( node );
		if( !selectedCellList.Exists(node.id) ) {
			selectedCellList.add( node.id, node );	// �I���ς݂̃Z��id���X�g�ɒǉ�
		}
	}

	// *********************************************************
	//  �Z���X�^�C���ύX�֐�
	// *********************************************************

	// �^����ꂽ�Z���̃X�^�C����I����Ԃ֕ύX����
	// 	input	: �I�u�W�F�N�g(�s�A��A�f�[�^�e�[�u���̃Z���iTD))
	function makeSelectedColor( ele ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( ele.selected == "1" ) { return; } // �I����Ԃ̃Z���ł����return

		var prefix = null;
		if (getCellPosition(ele) == "DATA") {
			prefix = "dt";
		} else {
			prefix = "hdr";
		}

		// �F�Â��Ă��Ȃ��Z����I����Ԃɂ���
		ele.selected  = "1";
		if ( ele.colorName == null ) { 
			ele.style.backgroundColor = associationColorArray[prefix + selectedSuffix];

		// �F�Â��Ă���Z����I����Ԃɂ���
		} else {
			ele.style.backgroundColor = associationColorArray[prefix + ele.colorName + selectedSuffix];
		}

	}

	// �^����ꂽ�Z���̃X�^�C�����I����Ԃ֕ύX����
	function makeUnSelectedColor( ele ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( ele.selected == "0" ) { return; } // ���I����Ԃ̃Z���łȂ����return

		var prefix = null;
		if (getCellPosition(ele) == "DATA") {
			prefix = "dt";
		} else {
			prefix = "hdr";
		}

		// �I���ς݂̐F�����I���̐F
		ele.selected = "0";
		if ( ele.colorName == null ) { // �F�Â��Ă��Ȃ��Z��
			ele.style.backgroundColor = "";
		} else {// �F�Â��Ă���Z��
			ele.style.backgroundColor = associationColorArray[prefix + ele.colorName];
		}
	}

	// �Z����F�t������
	function paintCellColor( ele, colorName ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( colorName == null ) { return; }

		// �F�Â�����
		ele.selected = "0";
		if ( colorName == "" ) { //�p���b�g�Łu�h��Ԃ��Ȃ��v��I�����ꂽ
			ele.removeAttribute("colorName");
			ele.style.backgroundColor = "";
		} else {
			var target = getCellPosition(ele);
			var prefix = null;
			if (target == "DATA") {
				prefix = "dt";
			} else {
				prefix = "hdr";
			}
			ele.colorName = colorName;
			ele.style.backgroundColor = associationColorArray[prefix + colorName];
			ele.orgBColor = associationColorArray[prefix + colorName];
		}

	}

	// *********************************************************
	//  �F�Â����擾�֐�
	// *********************************************************

	// ���݂̐F�ݒ���擾����i�Z���I���̓N���A����j
	// return:	String[]
	//        	String[0]:�w�b�_���̐F��� , String[1]:�{�f�B���̐F���
	// 			�����Fid.key:id.key:id.key:id.key:id.key:id.key;color
	//			�� id.key�̓w�b�_�Z���F�R�ȓ��A�f�[�^�Z���F�U�ȓ�
	function getColorArray() {

		// �I����Ԃ̃Z���̑I�����������A�F��I��O�̐F�ɖ߂��B
		if ( previousClickedCell != null ) {
			clearSelectedCell();
		}

		var dtColorInfo = "";
		var hdrColorInfo = "";

		var dicArray = ( new VBArray( coloredCellList.Keys() )).toArray();	// �F�Â��Ă���Z�����X�g
		var disableHdrColor = disableHdrColorString;	//�F�Â��s�\�ł������w�b�_�[�Z��
		var disableDtColor  = disableDtColorString;		//�F�Â��s�\�ł������e�[�u���Z��

		if ( ( dicArray.length == 0 ) && ( disableHdrColorString == "" ) && ( disableDtColorString == "" ) ) { return null; }

		var node;
		var str;
		for( var i = 0; i < dicArray.length; i++ ) {
			node = coloredCellList( dicArray[i] );
			str = "";
			if ( isCellInDataTable(node) ) { // �f�[�^�e�[�u�����̐F
				str = getIdKeyList( node, "COL" ) + ":" + getIdKeyList( node, "ROW" ) + ";" + node.colorName;
				if ( dtColorInfo == "" ) {
					dtColorInfo = str;
				} else {
					dtColorInfo += "," + str;
				}
			} else { // �w�b�_�̐F

				if ( isLastHie(node) ) { // ��or�s�ŉ��i�̃I�u�W�F�N�g
					if ( isCellInColHeader( node ) ) {
						str = getIdKeyList( node, "COL" ) + ";" + node.colorName;
					} else if ( isCellInRowHeader( node ) ) {
						str = getIdKeyList( node, "ROW" ) + ";" + node.colorName;
					}
				} else { // ��or�s�̍ŉ��i�ȊO�̐F���͕ۑ����Ȃ��i�F�Â����Ƀ��W�b�N�Ő�������j
					continue;
				}

				if ( hdrColorInfo == "" ) {
					hdrColorInfo = str;
				} else {
					hdrColorInfo += "," + str;
				}
			}
		}


		// disable���̒ǉ�(�F�Â����ꂽ�Z���������Ȃ�������)
			if ( (hdrColorInfo != "")  && (disableHdrColor != "") ) {
				disableHdrColor = "," + disableHdrColor;
			}
			if ( (dtColorInfo != "") && (disableDtColor != "") ) {
				disableDtColor = "," + disableDtColor;
			}

		var returnArray = new Array(1);
		returnArray[0] = hdrColorInfo + disableHdrColor;
		returnArray[1] = dtColorInfo  + disableDtColor;

		// disable���̏�����
		disableHdrColorString = "";
		disableDtColorString  = "";

		return returnArray;
	}

	// �F�����擾
	function getColorIndexInfoArray () {

		// �I����Ԃ̃Z���̑I�����������A�F��I��O�̐F�ɖ߂��B
		if ( previousClickedCell != null ) {
			clearSelectedCell();
		}

		var dicArray = ( new VBArray( coloredCellList.Keys() )).toArray();	// �F�Â��Ă���Z�����X�g
		if ( dicArray.length == 0 ) { return null; }

		var colArray = new Array();
		var rowArray = new Array();
		var dataArray = new Array();
		var colIndex = 0;
		var rowIndex = 0;
		var dataIndex = 0;


		for( var i = 0; i < dicArray.length; i++ ) {
			node = coloredCellList( dicArray[i] );
			var tmpString = getSpreadCoordinate(node) + ";" + node.colorName;
			if ( getCellPosition( node ) == "COL" ) {
				colArray[colIndex]= tmpString;
				colIndex++;
			} else if ( getCellPosition( node ) == "ROW" ) {
				rowArray[rowIndex] = tmpString;
				rowIndex++;
			} else if ( getCellPosition( node ) == "DATA" ) {
				dataArray[dataIndex] = tmpString;
				dataIndex++;
			}
		}

		var colorIndexInfoArray = new Array(3);
			colorIndexInfoArray[0] = colArray.join(",");
			colorIndexInfoArray[1] = rowArray.join(",");
			colorIndexInfoArray[2] = dataArray.join(",");

		return colorIndexInfoArray;

	}


	// *********************************************************
	//  �Z�����擾�֐�
	// *********************************************************


	// �w�肳�ꂽ�w�b�_�̎�ID,�����o�[�L�[�̑g�ݍ��킹�̑g�ݍ��킹�����擾����
	// <Input>  node  : �s/��w�b�_�� TD�I�u�W�F�N�g
	//          target: COL or ROW
	// <Output> �s/��̒i����ID�EKEY�̑g�ݍ��킹
	//		         hie0 : hie1 : hie2
	//		        ---------------------
	//		   col: id.key:id.key:id.key
	//		   row: id.key:id.key:id.key
	function getIdKeyList( node, target ) {

		if ( ( node == null ) || ( target == null ) || ( target == "" ) ) { return null;}

		var idKeyArray = new Array();

		if ( target == "COL" ) {
			var indexNode = document.getElementById( "CH_CG" + getColIndexByTDObj( node ) );
			var objNum = colObjNum;
		} else if ( target == "ROW" ) {
			var indexNode = document.getElementById( "RH_R" + getRowIndexByTRObj( node.parentNode ) );
			var objNum = rowObjNum;
		}

		var oAxis;
		for ( var i = 0; i < objNum; i++ ) {
			if ( i == 0 ) { // �ŉ��i
				oAxis = getCellObj( indexNode, target, (objNum - 1) );
			} else {
				oAxis = getUpperCellObject( oAxis, target );
			}
			idKeyArray[i] = getHieID( (objNum - 1 - i), target) + "." + oAxis.key;
		}

		idKeyArray.reverse();
		return idKeyArray.join(":");
	}

