// ============== �h�����_�E���֘A ============================================

	// *****************************************************
	//  �h���������ϐ��A�萔
	// *****************************************************

    // �h�����_�E���֘A
    var isDrillingFLG = false;		// drill�����ǂ�����\���t���O
									// drill��������������܂ł́A�V���ȃh�����������󂯕t���Ȃ��B

	// �����\���������̓h�����_�E���ň�x�ł��\�����ꂽ���Ƃ̂��郁���o�̏����i�[����
	// �h�����_�E���ɂ��X�V�����B
	// ��KEY���X�g��
	var viewedColSpreadKeyList = new Array(3);
		viewedColSpreadKeyList[0] = "";
		viewedColSpreadKeyList[1] = "";
		viewedColSpreadKeyList[2] = "";
	var viewedRowSpreadKeyList = new Array(3);
		viewedRowSpreadKeyList[0] = "";
		viewedRowSpreadKeyList[1] = "";
		viewedRowSpreadKeyList[2] = "";

	// ��SpreadIndex,KEY�̑g�ݍ��킹���X�g��
	var viewedColSpreadIndexKeyList = "";
	var viewedRowSpreadIndexKeyList = "";

	// ���݃E�C���h�E�ɕ\������Ă����/�s��SpreadIndex,KEY�̑g�ݍ��킹���
	var viewingColSpreadIndexKeysDict = new ActiveXObject("Scripting.Dictionary");
	var viewingRowSpreadIndexKeysDict = new ActiveXObject("Scripting.Dictionary");

	// �\���ς݂��ǂ����𒲂ׂ邽�߂̘A�z�z����쐬
	//  associationViewed[Col/Row]SpreadKey[x]: ��x�ł��\��������܂��͍s��x�Ԗڂ̒i�̎��������o��KEY�l��KEY�Ɏ��A�z�z����i�[����z��B
	//  �l�́u1�v�Œ�B
	//  associationViewed[Col/Row]SpreadIndex[x]: ��x�ł��\��������܂��͍s��SpreadIndex��KEY�Ɏ��A�z�z����i�[����z��B
	//  �� �A�z�z��̒l�́u1�v�Œ�B
	//  �� �A�z�z��ɃA�N�Z�X���A1���A��΁A�\���ς݂ł���B

	var associationViewedColSpreadKey    = new Array(3);
		associationViewedColSpreadKey[0] = new Array(3); // COL0�Ԗڂ̒i
		associationViewedColSpreadKey[1] = new Array(3); // COL1�Ԗڂ̒i
		associationViewedColSpreadKey[2] = new Array(3); // COL2�Ԗڂ̒i

	var associationViewedRowSpreadKey    = new Array(3); 
		associationViewedRowSpreadKey[0] = new Array(3); // ROW0�Ԗڂ̒i
		associationViewedRowSpreadKey[1] = new Array(3); // ROW1�Ԗڂ̒i
		associationViewedRowSpreadKey[2] = new Array(3); // ROW2�Ԗڂ̒i

	var associationViewedColSpreadIndex = new Array(3);
	var associationViewedRowSpreadIndex = new Array(3);

	// ����̃h���������ŕ\���ΏۂƂȂ郁���o�̏����i�[����ꎟ�ϐ�
	// ��KEY���X�g��
	var viewColSpreadKeyList = new Array(3);
		viewColSpreadKeyList[0] = "";
		viewColSpreadKeyList[1] = "";
		viewColSpreadKeyList[2] = "";
	var viewRowSpreadKeyList = new Array(3);
		viewRowSpreadKeyList[0] = "";
		viewRowSpreadKeyList[1] = "";
		viewRowSpreadKeyList[2] = "";
	// ��SpreadIndex,KEY�̑g�ݍ��킹���X�g��
	var viewColSpreadIndexKeyList = "";
	var viewRowSpreadIndexKeyList = "";


	var isDrillAgain = false;	// ��x�ڈȍ~�̃h�����_�E�����ǂ����B
								// ��x�ڈȍ~�̏ꍇ�A�f�[�^�͎擾���Ȃ��B


	// *****************************************************
	//  �h���������֐�
	// *****************************************************

	// �h�����_�E������
	// <Input> th:�s�E��w�b�_�̃h������Ԃ�\��IMG�I�u�W�F�N�g
	function drill(th) {

		// �h�����_�E�������ǂ����𔻒�
		if ( isDrillingFLG ) {
			showMessage("5");
			return "";
		} else {
			isDrillingFLG = true;
		}

		// �������@�ϐ��ݒ�@��������������������������������������������������
		var target   = "";	// �h�����Ώۃ����o���s���񂩁jCOL�AROW
		var hieIndex  = "";	// �h�����Ώۃ����o���sor��w�b�_�̉��Ԗڂ���ݒ肷��
							// (0 start)
		var objMemComboNum;		// �h�������삪�s�Ȃ�ꂽ�I�u�W�F�N�g��
								// ���i�ȍ~�̃����o�̑g�ݍ��킹��

			target = getCellPosition(th.parentNode.parentNode);
			hieIndex = getHieIndex(th.parentNode.parentNode);
			objMemComboNum = getLowerHieComboNum(th.parentNode.parentNode, target);

		// ����̃h���������ŕ\���ΏۂƂȂ郁���o�̏����i�[����ꎟ�ϐ���������
			// ��KEY���X�g��
			viewColSpreadKeyList[0] = "";
			viewColSpreadKeyList[1] = "";
			viewColSpreadKeyList[2] = "";
			viewRowSpreadKeyList[0] = "";
			viewRowSpreadKeyList[1] = "";
			viewRowSpreadKeyList[2] = "";
			// ��SpreadIndex,KEY�̑g�ݍ��킹���X�g��
			viewColSpreadIndexKeyList = "";
			viewRowSpreadIndexKeyList = "";

		// �h�����̍s��ꂽ�w�b�_�ɔz�u���ꂽ����
		var headerAxesNums  = getHeaderObjNum( target );

		// �h����������s��ꂽ�v�f�̃C���f�b�N�X
		var drilledNodeSpreadIndex = drilledNodeSpreadIndex = getSpreadIndexByTDObj(th.parentNode.parentNode); 

		// XML Index
		var xmlIndex = changeSpreadIndexToXMLIndex ( drilledNodeSpreadIndex, target, hieIndex );

		// �h����������s�Ȃ�ꂽ�����o�ɑΉ�����m�[�h�I�u�W�F�N�g��XML���擾
		var drillNode = getXMLMemberNode(axesXMLData,target,hieIndex,xmlIndex);


		// �h�������[�h�ݒ�A�X�e�[�^�X���X�V
		var drillMode;
			if ( th.parentNode.parentNode.internalDisp == "true" ) {
				drillMode = "UP";
				th.parentNode.parentNode.internalDisp = "false";
			} else if ( th.parentNode.parentNode.internalDisp == "false" ) {
				drillMode = "DOWN";
				th.parentNode.parentNode.internalDisp = "true";
			}

		isDrillAgain = false;	// ��x�ڈȍ~�̃h�����_�E������\���t���O�̏������B

		// ���������������������@�h���������@��������������������

		if ( hieIndex == headerAxesNums - 3 ) { // ��/�s�́u�ŏI�i-2�v�i�ڂ̃����o���h�������ꂽ

			// �h��������
			allLoop1(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

		} else if ( hieIndex == headerAxesNums - 2 ) { // ��/�s�́u�ŏI�i-1�v�i�ڂ̃����o���h�������ꂽ

			// �h��������
			allLoop2(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

			// �h�������ꂽ�����o���������ʒi�̃����o��\���Ώۃ��X�g�ɒǉ�
			if ( headerAxesNums == 3 ) {
				tmpHie = 0;
				tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
				setViewSpreadKeyList(tmpNode, target, tmpHie);
			}

		} else if ( hieIndex == headerAxesNums - 1 ) { // ��/�s�̍ŏI�i�̃����o���h�������ꂽ

			// �h��������
			allLoop3(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

			// �h�������ꂽ�����o���������ʒi�̃����o��\���Ώۃ��X�g�ɒǉ�
			var tmpHie;
			var tmpNode;
				if ( headerAxesNums == 2 ) {//�w�b�_��2�i
					// 0�i��
					tmpHie = 0;
					tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);
				} else if ( headerAxesNums == 3 ) { //�w�b�_��3�i
					// 1�i��
					tmpHie = 1;
					tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);

					// 0�i��
					tmpHie = 0;
					tmpNode = getUpperCellObject( tmpNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);
				}
		}

		// �s�w�b�_�̕\��(TABLE�\��)������Ȃ����߁ATD�I�u�W�F�N�g��RowSpan�𒲐�
		if ( target == "ROW" ) {
			modifyRowSpan( th.parentNode.parentNode );
		}

		// ===�@�h��������I�������@===

		// �摜�𔽓]�i�v���X�A�}�C�i�X�j
		if ( drillMode == "DOWN" ) {
			th.src="./images/minus.gif";

		} else if ( drillMode == "UP" ) {
			th.src="./images/plus.gif";
		}

		// �h�����ɂ��擾����s�������͗�̏����X�V
		if ( drillMode == "DOWN" ) {
			if ( !isDrillAgain ) {

				if ( target == "COL" ) {
					// COL�̎擾�����h�������(view**)�ōX�V
					document.SpreadForm.viewCol0KeyList_hidden.value  = viewColSpreadKeyList[0];
					document.SpreadForm.viewCol1KeyList_hidden.value  = viewColSpreadKeyList[1];
					document.SpreadForm.viewCol2KeyList_hidden.value  = viewColSpreadKeyList[2];
					document.SpreadForm.viewColIndexKey_hidden.value  = viewColSpreadIndexKeyList;

					// ROW�̎擾������x�ł��\�������s�̏��(viewed**)�ōX�V
					document.SpreadForm.viewRow0KeyList_hidden.value  = viewedRowSpreadKeyList[0];
					document.SpreadForm.viewRow1KeyList_hidden.value  = viewedRowSpreadKeyList[1];
					document.SpreadForm.viewRow2KeyList_hidden.value  = viewedRowSpreadKeyList[2];
					document.SpreadForm.viewRowIndexKey_hidden.value  = viewedRowSpreadIndexKeyList;
				} else if ( target == "ROW" ) {
					// COL�̎擾������x�ł��\��������̏��(viewed**)�ōX�V
					document.SpreadForm.viewCol0KeyList_hidden.value  = viewedColSpreadKeyList[0];
					document.SpreadForm.viewCol1KeyList_hidden.value  = viewedColSpreadKeyList[1];
					document.SpreadForm.viewCol2KeyList_hidden.value  = viewedColSpreadKeyList[2];
					document.SpreadForm.viewColIndexKey_hidden.value  = viewedColSpreadIndexKeyList;

					// ROW�̎擾�����h�������(view**)�ōX�V
					document.SpreadForm.viewRow0KeyList_hidden.value  = viewRowSpreadKeyList[0];
					document.SpreadForm.viewRow1KeyList_hidden.value  = viewRowSpreadKeyList[1];
					document.SpreadForm.viewRow2KeyList_hidden.value  = viewRowSpreadKeyList[2];
					document.SpreadForm.viewRowIndexKey_hidden.value  = viewRowSpreadIndexKeyList;
				}
			}
		}

		// �����f�[�^(XML)�̃h���������X�V
		if ( drillMode == "DOWN" ) {
			changeDrillStatToTrue(axesXMLData,target,hieIndex,xmlIndex);
		} else if ( drillMode == "UP" ) {
			changeDrillStatToFalse(axesXMLData,target,hieIndex,xmlIndex);
		}

		// �f�[�^�擾����яI������
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if ( drillMode == "DOWN" ) {
			if ( !isDrillAgain ) {
				refreshTableData();		// �T�[�o�[���Ƀ��|�[�g�ւ̃f�[�^�}����v��
										// finalyzeDrill()�́A�T�[�o�[�����肵���f�[�^�}���X�N���v�g�Ŏ��s
			} else {
				finalyzeDrill();		// �h�����I������
				if((node.text == "1")||(node.text == "2")) {	// �O���t�\����
					reloadChart(); 		// �O���t���X�V
				}
			}
		} else {
			finalyzeDrill();			// �h�����I������
			if((node.text == "1")||(node.text == "2")) {		// �O���t�\����			
				reloadChart(); 			// �O���t���X�V
			}
		}

		// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu�𒲐�����
		scrollView();

		return;
	}


	// *****************************************************
	//  �h�������f�����i�ċA�����j
	// *****************************************************

	function allLoop1( XMLNode,drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,startPoint ) {
	// all loop include node & child & Sibling
	// Input)
	//	XMLNode:�h�������ꂽ���������o�A�q���x���̍ŏ��̎��������o�A
	//			���i�̍ŏ��̎��������o�ɑΉ�����XML�I�u�W�F�N�g
	//	drillMode�FUP or DOWN
	//	target�FROW or COL
	//	drilledSpreadIndex:�h�������ꂽ����/���W���[�����o�̕\���ł�SpreadIndex(0 start)
	//	drilledHieIndex�F�h�������ꂽ����/���W���[�̒iIndex(0start)
	// hieIndex:�������̎���/���W���[�̎����ł̒iIndex(0start)
	//			�h�������ꂽ���́u����/���W���[�i���v�i-1�v�Ɠ������B
	// objMemComboNum:�h�������ꂽ����/���W���[�̎��i�ȍ~�̑g�ݍ��킹��
	// startPoint:allLoop�����s���ꂽ�ꏊ("drill" or "upperLoop" or "self")

		// ��������XML�m�[�h��ID���擾
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XML��ID��Spread��ID�֕ϊ�
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

		// �h�����ΏۃI�u�W�F�N�g���擾
		// (�s�̃h�������FTR�v�f�A��̃h�������FCOL�v�f)
		var targetNode = getSpreadNode( target,targetNodeSpreadIndex);

		// ���������������� �Ăяo���ꂽ�q�m�[�h�̏��� ����������������
		if ( startPoint != "drill" ) {

			// �h�����������s
			execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop1" );

		}

		while (true) {
			// ���������������� �q�m�[�h�̌Ăяo�� ����������������
			if (XMLNode.childNodes.length - (memberElementsNum-1) > 1) {
				var tmpCellObj = getCellObj(targetNode,target,hieIndex);
				if ( ( startPoint == "drill") || ( ( startPoint != "drill") && (tmpCellObj.internalDisp == 'true' ) ) ) {
					allLoop1(XMLNode.childNodes[memberElementsNum],drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,"self");
				}
			}

			// �h���������s���ꂽ�m�[�h�łȂ��Ȃ��
			if ( startPoint != "drill" ) {

			// ���������������� �Z��m�[�h�̏��� ����������������
				if (XMLNode.nextSibling != null) {

					// ��������XML�m�[�h�̎��m�[�h��ID���擾
					var targetNodeXMLIndex = parseInt(XMLNode.nextSibling.getAttributeNode("id").value);

					// �擾����ID��SpreadIndex�֕ϊ�
					var targetNodeSpreadIndex;
						targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

					// �I�u�W�F�N�g���擾����
					var targetNode;
						targetNode = getSpreadNode( target,targetNodeSpreadIndex);

					// �h�����������s
					execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop1" );

					XMLNode = XMLNode.nextSibling;
				} else {
					break;
				}
			} else {
				break;
			}
		}
	}

	function allLoop2( XMLNode,drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,startPoint ) {
	// all loop include node & child & Sibling
	// Input)
	//	XMLNode:�h�������ꂽ���������o�A�q���x���̍ŏ��̎��������o�A
	//			���i�̍ŏ��̎��������o�ɑΉ�����XML�I�u�W�F�N�g
	//	drillMode�FUP or DOWN
	//	target�FROW or COL
	//	drilledSpreadIndex:�h�������ꂽ����/���W���[�����o�̕\���ł�SpreadIndex(0 start)
	//	drilledHieIndex�F�h�������ꂽ����/���W���[�̒iIndex(0start)
	// hieIndex:�������̎���/���W���[�̎����ł̒iIndex(0start)
	//			�h�������ꂽ���́u����/���W���[�i���v�i-1�v�Ɠ������B
	// objMemComboNum:�h�������ꂽ����/���W���[�̎��i�ȍ~�̑g�ݍ��킹��
	// startPoint:allLoop�����s���ꂽ�ꏊ("drill" or "upperLoop" or "self")

		// ��������XML�m�[�h��ID���擾
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XML��ID��Spread��ID�֕ϊ�
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

		// �h�����ΏۃI�u�W�F�N�g���擾
		// (�s�̃h�������FTR�v�f�A��̃h�������FCOL�v�f)
		var targetNode = getSpreadNode( target,targetNodeSpreadIndex);

		if ( startPoint != "drill" ) {

			// �h�����������s
			execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop2" );

		}

		while (true) {
			// ���������������� �q�m�[�h�̌Ăяo�� ����������������
			if (XMLNode.childNodes.length - (memberElementsNum-1) > 1) {

				var tmpCellObj = getCellObj(targetNode,target,hieIndex);
				if ( ( startPoint == "drill") || ( ( startPoint != "drill") && (tmpCellObj.internalDisp == 'true' ) ) ) {
					allLoop2(XMLNode.childNodes[memberElementsNum],drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,"self");
				}
			}

			// �h���������s���ꂽ�m�[�h�łȂ��Ȃ��
			if ( startPoint != "drill" ) {

			// ���������������� �Z��m�[�h�̏��� ����������������
				if (XMLNode.nextSibling != null) {

					// ��������XML�m�[�h�̎��m�[�h��ID���擾
					targetNodeXMLIndex = parseInt(XMLNode.nextSibling.getAttributeNode("id").value);

					// �擾����ID��SpreadIndex�֕ϊ�
					targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

					// �I�u�W�F�N�g���擾����
					targetNode = getSpreadNode( target,targetNodeSpreadIndex);

					// �h�����������s
					execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop2" );

					XMLNode = XMLNode.nextSibling;
				} else {
					break;
				}
			} else {
				break;
			}
		}
	}


	function execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, calledLoop ) {

		var firstMemberXMLIndex = 0;	// ���i�̍ŏ��̎��������o�̃C���f�b�N�X�i���0�j
		var comboMemNum;				// ���i�ȍ~�̎����g�ݍ��킹��
			if ( calledLoop == "allLoop1" ) {
				if ( target == "COL" ) {
					comboMemNum = chMemNumList[2];
				} else if ( target == "ROW" ) {
					comboMemNum = rhMemNumList[2];
				}
			} else if ( calledLoop == "allLoop2" ) {
				comboMemNum = 1;			// (���i�͍ŏI�i�Ȃ̂ŁA���1)
			}

		var drillXMLNode = getXMLMemberNode( axesXMLData, target, hieIndex+1 ,firstMemberXMLIndex );

		// ���ύX�ΏۃI�u�W�F�N�g�ɑ�����ŏI�i��TD�v�f���擾
		var targetCell = getCellObj( targetNode, target, hieIndex );

		// �h�����Ŏ擾�ΏۂƂȂ�Key�̃��X�g��ݒ肷��
		setViewSpreadKeyList( targetCell, target, hieIndex );

		// �\���ς݂̍s/���KEY���X�g���X�V
		if ( drillMode == "DOWN" ) {
			renewViewedSpreadKeyList( targetCell, target, hieIndex);
		}

		// ���i�̏��������s
		if ( calledLoop == "allLoop1" ) {
			allLoop2( drillXMLNode, drillMode, target, targetNodeSpreadIndex, drilledHieIndex, hieIndex+1, comboMemNum, "upperLoop");
		} else if ( calledLoop == "allLoop2" ) {
			allLoop3( drillXMLNode, drillMode, target, targetNodeSpreadIndex, drilledHieIndex, hieIndex+1, comboMemNum, "upperLoop");
		}
	}

	function allLoop3(XMLNode,drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,startPoint) {
	// all loop include node & child & Sibling
	// �T�v�j�s�܂��͗��\��/��\���ɐݒ肷��
	// Input)
	//	XMLNode:�h�������ꂽ���������o�A�q���x���̍ŏ��̎��������o�A
	//			���i�̍ŏ��̎��������o�ɑΉ�����XML�I�u�W�F�N�g
	//	drillMode�FUP or DOWN
	//	target�FROW or COL
	//	drilledSpreadIndex:�h�������ꂽ����/���W���[�����o�̕\���ł�SpreadIndex(0 start)
	//	drilledHieIndex�F�h�������ꂽ����/���W���[�̒iIndex(0start)
	//	hieIndex:�������̎���/���W���[�̎����ł̒iIndex(0start)
	//			�h�������ꂽ���́u����/���W���[�i���v�i�v�Ɠ������Ȃ�B
	// objMemComboNum:�h�������ꂽ����/���W���[�̎��i�ȍ~�̑g�ݍ��킹��
	// startPoint:allLoop�����s���ꂽ�ꏊ("drill" or "upperLoop" or "self")

		// ��������XML�m�[�h��ID���擾
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XML��ID��Spread��ID�֕ϊ�
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID( targetNodeXMLIndex, target, drilledSpreadIndex, hieIndex, objMemComboNum ));

		// �h�����ΏۃI�u�W�F�N�g���擾
		// (�s�̃h�������FTR�v�f�A��̃h�������FCOL�v�f)
		var targetNode = getSpreadNode( target, targetNodeSpreadIndex );

		// �h���������s���ꂽ�m�[�h�łȂ��Ȃ��
		if ( startPoint != "drill" ) {

			// �h�����������s
			execDrill3( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex );

		}

		while (true) {
			// child
			if (XMLNode.childNodes.length - (memberElementsNum-1) > 1) {

				var tmpCellObj = getCellObj( targetNode, target, hieIndex );
				if ( ( startPoint == "drill") || ( ( startPoint != "drill") && ( tmpCellObj.internalDisp == 'true' ) ) ) {

					allLoop3(XMLNode.childNodes[memberElementsNum],drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,"self");
				}
			}

			// �h���������s���ꂽ�m�[�h�łȂ��Ȃ��
			if ( startPoint != "drill" ) {

				// Sibling
				if ( XMLNode.nextSibling != null ) {

					// ��������XML�m�[�h��ID���擾
					var targetNodeXMLIndex = parseInt( XMLNode.nextSibling.getAttributeNode("id").value );

					// XML��ID��Spread��ID�֕ϊ�
						targetNodeSpreadIndex = parseInt( changeNodeIDToSpreadID( targetNodeXMLIndex, target, drilledSpreadIndex, hieIndex, objMemComboNum ));

					// �h�����ΏۃI�u�W�F�N�g���擾
					// (�s�̃h�������FTR�v�f�A��̃h�������FCOL�v�f)
						targetNode = getSpreadNode( target, targetNodeSpreadIndex );

					// �h�����������s
					execDrill3( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex );

					XMLNode = XMLNode.nextSibling;
				} else {
					break;
				}
			} else {
				break;
			}
		}
	}



	function execDrill3( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex ) {

		// DISPLAY��ݒ肷��
		if ( drillMode == "UP" ) {
			setDisplayFalse( targetNode, target );
		} else if ( drillMode == "DOWN" ) {
			setDisplayTrue( targetNode, target );
		}

		// ���ύX�ΏۃI�u�W�F�N�g�ɑ�����ŏI�i��TD�v�f���擾
		var targetCell = getCellObj( targetNode, target, hieIndex );

		// �h�����Ŏ擾�ΏۂƂȂ�Key�̃��X�g��ݒ肷��
		setViewSpreadKeyList( targetCell, target, hieIndex );

		// �h�����Ŏ擾�ΏۂƂȂ�Index�AKey�̃��X�g��ݒ肷��
		setViewSpreadIndexKeyList ( targetNodeSpreadIndex, targetCell, target );

		// ���ݕ\�����̍s/���SpreadIndex,Key�̃��X�g��ݒ肷��
		adjustViewingSpreadIndexKeysDict ( targetNodeSpreadIndex, targetCell, target, drillMode );

		// �\���ς݂̍s/���Key���X�g�AIndexKey���X�g���X�V
		if ( drillMode == "DOWN" ) {
			renewViewedSpreadKeyList( targetCell, target, hieIndex );
			renewViewedSpreadIndexKeyList ( targetNodeSpreadIndex, targetCell, target, hieIndex );
		}

	}


	// *****************************************************
	//  ��ʕ\���A��\����؂�ւ�
	// *****************************************************
	function setDisplayTrue( node, targetString ) {
		// �w�肳�ꂽ�m�[�h��\��������
		// Input�jnode�F�\���Ώۃm�[�h
		//				�s�̃h�������́A�s�w�b�_�e�[�u����TR�I�u�W�F�N�g
		//				��̃h�������́A��w�b�_�e�[�u����COL�I�u�W�F�N�g
		//		  targetString�F�h�������s�A��̂ǂ���ɑ΂��čs��ꂽ�̂���\��

		var tmpNode = node;
		var target = targetString;

		if ( target == "COL" ) {
			// ��w�b�_�e�[�u���̗��\��
				var toWidth = 0;
					if ( tmpNode.preWidth == 0 ) {
						toWidth = defaultCellWidth;
					} else {
						toWidth = tmpNode.preWidth;
					}
				tmpNode.style.width = toWidth;

			// �f�[�^�e�[�u���̗��\��
				var tmpIndex = getCOLIndexByCOLObj( tmpNode );
				dataTable.all("DT_CG" + tmpIndex).style.width = toWidth;

		} else if ( target == "ROW" ) {
			// �s�w�b�_�e�[�u���̍s��\��
			tmpNode.style.display = '';

			// �f�[�^�e�[�u���̍s��\��
			var tmpIndex = getRowIndexByTRObj( tmpNode );
			dataTable.rows[tmpIndex].style.display = '';
		}
	}

	function setDisplayFalse( node, targetString ) {
		// �w�肳�ꂽ�m�[�h���\���ɂ���
		// Input�jnode�F�\���Ώۃm�[�h
		//				�s�̃h�������́A�s�w�b�_�e�[�u����TR�I�u�W�F�N�g
		//				��̃h�������́A��w�b�_�e�[�u����COL�I�u�W�F�N�g
		//		  targetString�F�h�������s�A��̂ǂ���ɑ΂��čs��ꂽ�̂���\��

		var tmpNode = node;
		var target = targetString;

		if ( target == "COL" ) {
			// ��w�b�_�e�[�u���̗��\��
				tmpNode.preWidth = tmpNode.offsetWidth;
				tmpNode.style.width = 0;

			// �f�[�^�e�[�u���̗��\��
				var tmpIndex = getCOLIndexByCOLObj( tmpNode );
				dataTable.all("DT_CG" + tmpIndex).style.width = 0;

		} else if ( target == "ROW" ) {
			// �s�w�b�_�e�[�u���̍s��\��
			tmpNode.style.display = "none";

			// �f�[�^�e�[�u���̍s��\��
			var tmpIndex = getRowIndexByTRObj( tmpNode );
			dataTable.rows[tmpIndex].style.display = "none";
		}
	}

	// ***********************************************************
	//  �s/��̕\���ςݍs/��E�����o���A�\�����̍s/������X�V
	// ***********************************************************

	// �h�����_�E���ɂ���x�ł��\�������s�������͗��KEY LIST���X�V����
	function renewViewedSpreadKeyList ( tmpObj, targetString, hierarchyIndex ) {
		var obj       = tmpObj;
		var key       = obj.key;
		var keyString = "" + key;
		var target    = targetString;
		var hieIndex  = hierarchyIndex;

		var tmpString;
		if ( target == "COL" ) {
			// �A�z�z����m�F���A�\���ς݂��ǂ������m�F
			if ( associationViewedColSpreadKey[hieIndex][keyString] == 1 ) {
				return;
			} else {
				// �A�z�z��̕\���ς݃��X�g���X�V�E�������s
				associationViewedColSpreadKey[hieIndex][keyString] = 1;
			}

			// �\���ς݂�COL��KEY���X�g���X�V
			tmpString = viewedColSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + keyString;
			} else {
				tmpString = tmpString + "," + keyString;
			}
			viewedColSpreadKeyList[hieIndex] = tmpString;
		} else if ( target == "ROW" ) {
			// �A�z�z����m�F���A�\���ς݂��ǂ������m�F

			if ( associationViewedRowSpreadKey[hieIndex][keyString] == 1 ) {
				return;
			} else {
				// �A�z�z��̕\���ς݃��X�g���X�V�E�������s
				associationViewedRowSpreadKey[hieIndex][keyString] = 1;
			}

			// �\���ς݂�COL��KEY���X�g���X�V
			tmpString = viewedRowSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + keyString;
			} else {
				tmpString = tmpString + "," + keyString;
			}

			viewedRowSpreadKeyList[hieIndex] = tmpString;
		}

	}

	// �h�����_�E���ɂ���x�ł��\�������s�������͗�̃C���f�b�N�X�EKey����ۑ�����
	function renewViewedSpreadIndexKeyList ( spreadIndex, tmpObj, targetString, hierarchyIndex) {
		var index       = spreadIndex;
		var indexString = "" + index;
		var obj         = tmpObj;
		var objKey      = obj.key;
		var target      = targetString;
		var hieIndex    = hierarchyIndex;


		if ( target == "COL" ) {
			// �A�z�z����m�F���A�\���ς݂��ǂ������m�F
			if ( associationViewedColSpreadIndex[indexString] == 1 ) {
				isDrillAgain = true;
				return;
			} else {
				// �A�z�z��̕\���ς݃��X�g���X�V�E�������s
				associationViewedColSpreadIndex[indexString] = 1;
			}
		} else if ( target == "ROW" ) {
			// �A�z�z����m�F���A�\���ς݂��ǂ������m�F
			if ( associationViewedRowSpreadIndex[indexString] == 1 ) {
				isDrillAgain = true;
				return;
			} else {
				// �A�z�z��̕\���ς݃��X�g���X�V�E�������s
				associationViewedRowSpreadIndex[indexString] = 1;
			}
		}

		var keyString = getKeyArray(obj).join(";");
		if ( target == "COL" ) {
			if ( viewedColSpreadIndexKeyList == "" ) {
				viewedColSpreadIndexKeyList += indexString + ":" + keyString;
			} else {
				viewedColSpreadIndexKeyList += "," + indexString + ":" + keyString;
			}

		} else if ( target == "ROW" ) {
			if ( viewedRowSpreadIndexKeyList == "" ) {
				viewedRowSpreadIndexKeyList += indexString + ":" + keyString;
			} else {
				viewedRowSpreadIndexKeyList += "," + indexString + ":" + keyString;
			}
		}

	}


	// �h�����_�E���ɂ��\������s�������͗��KEY����ۑ�����
	function setViewSpreadKeyList ( tmpObj, targetString, hierarchyIndex ) {

		var obj = tmpObj;
		var key = obj.key;
		var target = targetString;
		var hieIndex = hierarchyIndex;

		var tmpString;

		if ( target == "COL" ) {
			tmpString = viewColSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + key;
			} else {
				tmpString = tmpString + "," + key;
			}

			viewColSpreadKeyList[hieIndex] = tmpString;
		} else if ( target == "ROW" ) {
			tmpString = viewRowSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + key;
			} else {
				tmpString = tmpString + "," + key;
			}

			viewRowSpreadKeyList[hieIndex] = tmpString;
		}

	}

	// �h�����_�E���ɂ��\������s�������͗�̃C���f�b�N�X�EKey����ۑ�����
	// <Input>
	// index: spreadIndex
	// obj: TD�I�u�W�F�N�g
	// target: �s����
	function setViewSpreadIndexKeyList ( index, oTD, target ) {

		keyString = getKeyArray(oTD).join(";");
		if ( target == "COL" ) {
			if ( viewColSpreadIndexKeyList == "" ) {
				viewColSpreadIndexKeyList += index + ":" + keyString;
			} else {
				viewColSpreadIndexKeyList += "," + index + ":" + keyString;
			}

		} else if ( target == "ROW" ) {
			if ( viewRowSpreadIndexKeyList == "" ) {
				viewRowSpreadIndexKeyList += index + ":" + keyString;
			} else {
				viewRowSpreadIndexKeyList += "," + index + ":" + keyString;
			}
		}

	}


	// ���ݕ\�����̍s/���SpreadIndex,Key�̃��X�g��ݒ肷��
	function adjustViewingSpreadIndexKeysDict ( targetNodeSpreadIndex, targetCell, target, drillMode ) {

		var viewingEdgeSpreadIndexKeysDict = null;
			if ( target == "COL") {
				viewingEdgeSpreadIndexKeysDict = viewingColSpreadIndexKeysDict;
			} else if ( target == "ROW" ) {
				viewingEdgeSpreadIndexKeysDict = viewingRowSpreadIndexKeysDict;
			}

		// �h�����A�b�v
		if ( drillMode == "UP" ) {
			if ( viewingEdgeSpreadIndexKeysDict.Exists(targetNodeSpreadIndex) ) {
				viewingEdgeSpreadIndexKeysDict.Remove(targetNodeSpreadIndex);
			}

			return;

		// �h�����_�E��
		} else if ( drillMode == "DOWN" ) {
			// ���ł�SpreadIndex�����݂��邩
			if ( viewingEdgeSpreadIndexKeysDict.Exists(targetNodeSpreadIndex) ) {
				return;
			} else { // SpreadIndex�����݂��Ȃ��ꍇ�A�o�^����

				var obj = targetCell;
				viewingEdgeSpreadIndexKeysDict.Add(targetNodeSpreadIndex, getKeyArray(obj));
				return;
			}
		} else { // �h�����A�b�v�ł��h�����_�E���ł��Ȃ�
			return;
		}
	}

	// *****************************************************
	//  �h�������iXML�j�X�V
	// *****************************************************

	function changeDrillStatToTrue ( xmlDoc,target,hieIndex,nodeID ) {

		// Drill�_�E�����s�Ȃ�ꂽ���������o��XMLNode
		var targetNode = getXMLMemberNode(xmlDoc,target,hieIndex,nodeID);

		// Drill�_�E�����s�Ȃ�ꂽ���������o�̑c��Node��S�ēW�J��Ԃɂ���
		//  �i�N���X�W�v���ɂ����āA�قȂ��i����/���W���[�ɑ����鎟���c���[�ŁA
		//    �c��Node�������Ă���ꍇ������A������W�J����B�j
		var ancestorOrSelfNodes = targetNode.selectNodes("ancestor-or-self::Member");
		for ( var i = 0; i < ancestorOrSelfNodes.length; i++) {
			ancestorOrSelfNodes[i].childNodes.item(isDrilledPosition).text = "true";
		}
		return true;
	}

	function changeDrillStatToFalse ( xmlDoc,target,hieIndex,nodeID ) {

		var targetNode = getXMLMemberNode(xmlDoc,target,hieIndex,nodeID);

		targetNode.childNodes.item(isDrilledPosition).text = "false";
		return true;
	}

	// *****************************************************
	//  �I�������A����������
	// *****************************************************

	// === �I������ ===

    function refreshTableData() {
		// �T�[�o�ւ̃A�N�Z�X�󋵂�ݒ�(�C���[�W�𓮂���)
//		setLoadingStatus(true);

		document.SpreadForm.action = "Controller?action=loadDataAct";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();
    }

	function finalyzeDrill() {
		// �h�����_�E��/�A�b�v�̏I������

		// �����ɕ����̃h�����_�E���������s�Ȃ�Ȃ����߁A
		// �h���������ǂ�����\���ϐ���������
		isDrillingFLG = false;
		
		initializeViewColSpreadKeyList();
		initializeRowSpreadKeyList();
		initializeViewColSpreadIndexKeyList();
		initializeViewRowSpreadIndexKeyList();

	}

	// === ���������� ===

	function initializeViewColSpreadKeyList() {
		viewColSpreadKeyList[0] = "";
		viewColSpreadKeyList[1] = "";
		viewColSpreadKeyList[2] = "";
	}

	function initializeRowSpreadKeyList() {
		viewRowSpreadKeyList[0] = "";
		viewRowSpreadKeyList[1] = "";
		viewRowSpreadKeyList[2] = "";
	}

	function initializeViewColSpreadIndexKeyList() {
		viewColSpreadIndexKeyList = "";
	}

	function initializeViewRowSpreadIndexKeyList() {
		viewRowSpreadIndexKeyList = "";
	}

	// *****************************************************
	//  ��ʕ\���𐮂���
	// *****************************************************
	function modifyRowSpan( drilledTDObj ) {
		// Input:
		//	drilledTDObj�F�h�����������s��ꂽ���������o�̃I�u�W�F�N�g
		// ���T�v���h���������ɂ��A�h�������ꂽ���������o�̏�i�̎��������o��rowSpan���C������

		// �h�������ꂽ���������o�Ɠ�����i�̎��������o�����A�Ō�̎��������o�����߂�
		// �h�������ꂽ���������o�ŁA�Ō��display=''�ł��鎟�������o�����߂�
		// �h�������ꂽ���������o�Ɠ�����i�̎��������o�����A�ŏ��̎��������o����Ō��display=''�ł��郁���o�܂ł̃����o�������߂�
		// rowSpan��ݒ肷��
			// �h�������ꂽ���������o�̏�i�̎��������o���擾����
			// ���߂������o����ݒ肷��

		// �����@�ϐ��@����
		//  lastMemRowIndex:�h�������ꂽ���������o�Ɠ�����i�̎��������o�����A�Ō�̎��������o�̍s�ԍ�
		//  drilledCellRowIndex:�h�������ꂽ���������o�̍s�ԍ�
		var lastMemRowIndex;
		var drilledCellRowIndex = getRowIndexByTRObj(drilledTDObj.parentElement);
		var drilledCellHieIndex = getColIndexByTDObj(drilledTDObj);

		var comboNum;
		var startMemRowIndex;
		var lastDispMemRowIndex;
		var newSpanValue;

		if ( rowObjNum == 1 ) {
		// �s���P�i�̏ꍇ
			return;
		} else if ( rowObjNum == 2 ) {
		// �s���Q�i�̏ꍇ
			if ( drilledCellHieIndex == 0 ) {
				return;
			} else if ( drilledCellHieIndex == 1 ) {
				comboNum = rhMemNumList[1];
				startMemRowIndex = drilledCellRowIndex - ( drilledCellRowIndex % comboNum );
				lastMemRowIndex = startMemRowIndex + rhMemNumList[drilledCellHieIndex] - 1;
			}
		} else if ( rowObjNum == 3 ) {
		// �s���R�i�̏ꍇ
			if ( drilledCellHieIndex == 0 ) {
				return;
			} else if ( drilledCellHieIndex == 1 ) {
				comboNum = rhMemNumList[1] * rhMemNumList[2];
				startMemRowIndex = drilledCellRowIndex - ( drilledCellRowIndex % comboNum );
				lastMemRowIndex = startMemRowIndex + comboNum - 1;
			} else if ( drilledCellHieIndex == 2 ) {
				comboNum = rhMemNumList[2];
				startMemRowIndex = drilledCellRowIndex - ( drilledCellRowIndex % comboNum );
				lastMemRowIndex = startMemRowIndex + comboNum - 1;
			}
		}

		//������ʒi�̃����o�������̂̂Ȃ��ŁA�\�����ł����Ԍ��̍s�����߂�B
		var tmpRowIndex = lastMemRowIndex;
		for ( var i = 0; i < comboNum ;i++ ) {
			var tmpRowObj = rowHeader.firstChild.rows[tmpRowIndex];
			if ( tmpRowObj.style.display == "" ) {
				lastDispMemRowIndex = tmpRowIndex;
				break;
			}
			tmpRowIndex = tmpRowIndex - 1;
		}

		newSpanValue = tmpRowIndex - startMemRowIndex + 1;

		// rowSpan���X�V�i�\���𐮂��邽�߁j
		var targetObject = getCellObj(rowHeader.firstChild.rows[startMemRowIndex],"ROW",drilledCellHieIndex-1);
		targetObject.rowSpan = newSpanValue;

		// ��w�b�_�̎����C���f�b�N�X��2�ł������ꍇ�A��ʒi�ōēx���s
		if ( drilledCellHieIndex == 2 ) {
			modifyRowSpan( targetObject );
		}
	}

