

// ============== ���ύX�֘A ==================================================

	// ���ύX�֘A
	var target = null;
	var activation = null;
	var mouseX = -1;			// �}�E�X�|�C���^�ړ��O��X���W�i���ύX�Ŏg�p�j
	var mouseY = -1;			// �}�E�X�|�C���^�ړ��O��Y���W�i�����ύX�Ŏg�p�j
	var selectedCellInitialValue = 0;	// �N���X�w�b�_�Ńh���b�N���ꂽ�Z���̕��������͍����̏����l

	// Spread�\���G���A(BODY)�̃h���b�O�\�̈�ɂ��߂�A�N���X�w�b�_�̈�̕�/�����̍ő�l(����)
	var crossHeaderMaxWidthRate  = 0.8;	// ��
	var crossHeaderMaxHeightRate = 0.8;	// ����

	var CRSHeaderObject = document.all("CrossHeaderArea");

	function getNextAxisMemNum( hieIndex, target ) {
		// �s�w�b�_�Ŏ��̒i�̎���/���W���[�̃����o����Ԃ�
		if ( hieIndex > 1 || hieIndex < 0 ) {
			return null;
		}

		if ( target == "COL" ) {
			return chMemNumList[hieIndex + 1];
		} else if ( target == "ROW" ) {
			return rhMemNumList[hieIndex + 1];
		}
	}

	function getLowerHieComboNum( cell, target ) {
		// Input)
		//  cell�F�s�܂��͗��TD�v�f
		//  target�FTD�v�f���s�w�b�_�̂��̂��A��w�b�_�̂��̂���\��
		// Output)
		//  �^����ꂽTD�v�f�̒i�́A���i�ȍ~�̎���/���W���[�����o�̑g�ݍ��킹����Ԃ��B
		//  ��ɐݒ肳�ꂽ�Ō�̎���/���W���[�ł������ꍇ�́A1��Ԃ��B

		var nextAxisMemNum = -1;
		var retComboNum    = 1;
		var hieIndex       = 0;
		var hieMaxIndex    = 0;

		if ( target == "COL" ) {
			hieIndex       = cell.parentNode.rowIndex;
			hieMaxIndex    = cell.parentNode.parentNode.rows.length-1;
		} else if ( target == "ROW" ) {
			hieIndex       = parseInt(getColIndexByTDObj(cell));
			hieMaxIndex    = cell.parentNode.parentNode.rows(0).cells.length-1;
		}

		for ( var i = hieIndex; i < hieMaxIndex; i++ ) {
			nextAxisMemNum = getNextAxisMemNum(i,target);
			retComboNum = retComboNum * nextAxisMemNum;
		}
		return retComboNum;
	}

	function changeCellIndexToCHCOL( cell,slideNum,position) {
	// Input(cell): ��w�b�_��̃Z���I�u�W�F�N�g�i<TD>�j
	// Input(slideNum): ���͂��󂯂��Z���I�u�W�F�N�g��O��ɒ�������
	//					�i���͂��󂯂��Z���I�u�W�F�N�g�ɑΉ�����<COL>�̃C���f�b�N�X��
	//					�@���̂܂܏o�͂���ꍇ�́A0�j
	// Input(position): ���͂��󂯂��Z���I�u�W�F�N�g�̍����̃J�����ɑΉ�����COL��
	//					�C���f�b�N�X��Ԃ���(LEFT)�A�E���̃J�����ɑΉ�����COL��
	//					�C���f�b�N�X��Ԃ���(RIGHT)
	// Output:�Ή������w�b�_�̃C���f�b�N�X�i<COL>�j
		var toIDX = -1;
		var comboNum = 1;
		comboNum = getLowerHieComboNum(cell,"COL");
		if ( position == "LEFT" ) {
			toIDX = ( (cell.cellIndex + slideNum ) * comboNum );
		} else if ( position == "RIGHT" ) {
			toIDX = ( (cell.cellIndex + 1 + (slideNum) ) * comboNum ) -1;
		}
		return toIDX;
	}

	function changeCellWidth(target,delt,activation,method) {
	// �N���X�w�b�_�A��w�b�_�̕��ύX�Ɠ��������āA�s�w�b�_�A�f�[�^�\�����̗񕝂�ύX
		var width = target.offsetWidth + delt;
		if (width <= 0) {
			// width ��0�ȉ��ɂȂ����ꍇ�ɂ́Awidth="1px"�Ƃ���B
			// width��0�ȉ��ɐݒ肷�邱�Ƃ͂ł��Ȃ��i�G���[�ɂȂ�j���߁B
			width = "1px";
			target.style.width = width;
			scrollView();	// �X�N���[���ʒu�����킹��
			return;
		}

		if ( activation == "modifyColHeaderWidth" ) {
			target.style.width = width;
			if ( method == "UP" ) {
				// �f�[�^�\���e�[�u����COL�I�u�W�F�N�g�̕���ύX����
				var tmpColIndex = getCOLIndexByCOLObj(target);
				var dataColumn = dataTable.all("DT_CG" + tmpColIndex);
				dataColumn.style.width = width;
			}
		} 

		// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu(X���AY��)�����킹��
		scrollView();
		return;
	}

	function mouseDown() {
		// ���[�J���ϐ�
		var srcEle = window.event.srcElement;
			if ( srcEle.tagName == "DIV" ) {
				srcEle = srcEle.parentElement;
			}
			if ( srcEle == null ) {
				return;
			}
		var selectedCell = null;
		var tmpObj = null;
		var comboNum = 1;
		var targetIndex = -1;

		var mousePosition = null;
			if ( onColumnHeaderCellVLine(window.event) ) {
				mousePosition = "columnHeaderCellVLine";
			} else {
				return;
			}

		// ���ʕϐ��̏�����
		target = null;
		activation = null;
		mouseX = -1;
		mouseY = -1;
		selectedCellInitialValue = 0;

		// ����
		if ( ( mousePosition == "columnHeaderCellVLine" ) || ( mousePosition == "crossHeaderCellVLine" ) ) {
			if ( window.event.offsetX < 3 ) {
			// ***** ��w�b�_�Z�������̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
			// ��w�b�_�̈�ȏ㍶�̓W�J��̃Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// �i�h�������ꂸ�ɏW�񂳂�Ă���Z���̓X�L�b�v����j
			// �܂��A��w�b�_�P���(index=0)�̃Z���������N���b�N���ꂽ�ꍇ�́A
			// ����̃N���X�w�b�_�[���̃Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// ***** �N���X�w�b�_�Z�������̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
			// ����̃w�b�_�Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// �܂��A�N���X�w�b�_�P��ڂ̃Z���������N���b�N���ꂽ�ꍇ�́A
			// ���삵�Ȃ��B
				tmpObj = srcEle.previousSibling;	// TR Object

				// �I�����ꂽ�Z���ɑΉ�����COL�I�u�W�F�N�g�����߂�
				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,-1,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);
				} else if ( mousePosition == "crossHeaderCellVLine" ) {
					targetIndex = getColIndexByTDObj(srcEle) - 1;
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );
				} else {
					return;
				}
			} else if ( window.event.offsetX > srcEle.offsetWidth - 4) {
				if ( mousePosition == "columnHeaderCellVLine" ) {
					// �N���b�N���ꂽ�Z���ɑΉ�����ACOL�I�u�W�F�N�g��Index�����߂�B
					targetIndex = changeCellIndexToCHCOL(srcEle,0,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);

				} else {
					return null;
				}
			} else {
				return;
			}
			target = tmpObj;			// ���ύX���s�Ȃ��I�u�W�F�N�g��������
										// ���̑�\�I�u�W�F�N�g
			if ( mousePosition == "columnHeaderCellVLine" ) {
				activation = "modifyColHeaderWidth";	// ����̐ݒ�
			} else if ( mousePosition == "crossHeaderCellVLine" ) {
				activation = "modifyCrossHeaderWidth";
				selectedCellInitialValue = target.offsetWidth;
			} else {
				return;
			}
			mouseX = event.clientX;					// X���W��o�^
			return;
		}

	}

	function mouseMove() {
		var retCode;
		if ( target != null && activation != null ) {
			if ( ( activation == "modifyColHeaderWidth" ) || ( activation == "modifyCrossHeaderWidth" ) ) {

				var delt = window.event.clientX - mouseX;

				if ( ( activation == "modifyCrossHeaderWidth" ) && 
                     ( document.body.clientWidth * crossHeaderMaxWidthRate ) < parseInt(CRSHeaderObject.offsetWidth + delt) ) {
					// �N���X�w�b�_���̕��̏���𒴂��Ă��Ȃ���

					return;
				}

				var method = "MOVE";
				var retCode = changeCellWidth(target,delt,activation,method);

				mouseX = window.event.clientX;
				return;
			}

		} else {
		// �s�w�b�_�A��w�b�_���̃h���b�O�\�̈��
		// �}�E�X�|�C���^���������ꂽ�ꍇ�A�}�E�X�A�C�R����
		// �h���b�O�p�̃A�C�R���֕ύX����
			var pointedCell = window.event.srcElement;
			if ( onColumnHeaderCellVLine(window.event) == true ) {
				pointedCell.style.cursor = "col-resize";
			} else {
					pointedCell.style.cursor = "auto";
			}
		}
	}

	function mouseUp() {
		var retCode;

		if ( target != null && activation != null ) {
			if ( ( activation == "modifyColHeaderWidth" ) || ( activation == "modifyCrossHeaderWidth" ) ) {

				var delt = window.event.clientX - mouseX;
				var method = "UP";

				if ( ( activation == "modifyCrossHeaderWidth" ) && 
                     ( document.body.clientWidth * crossHeaderMaxWidthRate ) < parseInt(CRSHeaderObject.offsetWidth + delt) ) {
					// ���N���X�w�b�_�̕��̏���𒴉߁�
					// �s�w�b�_���̕����N���X�w�b�_���̕��ɍ��킹��
					retCode = changeCellWidth(target,0,activation,method);

				} else {

					// ����ύX
					retCode = changeCellWidth(target,delt,activation,method);
				}

				// ���ʕϐ��̏�����
				target = null;
				activation = null;
				mouseX = -1;
				mouseY = -1;
				selectedCellInitialValue = 0;

				return;
			}
		}
	}

// ============== �}�E�X�ʒu����֐� ============================================

	function onColumnHeaderCellVLine( thisEvent ) {
	// ����:     �C�x���g�I�u�W�F�N�g
	// �߂�l�F  true / false
	// �T�v�F    �C�x���g����w�b�_�Z���̏c�̌r���t��
	//           (offset�ŋ��߂��鐔�l�ŁA3����)��
	//           ���������ꍇ�ɂ́utrue�v����ȊO�̏ꍇ�ɂ́ufalse�v��Ԃ��B
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ( ele.parentElement.Spread != "ColumnHeaderRow" ) &&
			 ( ele.parentElement.Spread != "ColumnHeaderMeasureRow" ) ) {
			return false;
		}

		// �Z���������̌r���t�߂ł��邩�A�Z�����E���̌r���t�߂ł����
		// �utrue�v��Ԃ�
	//	if ( thisEvent.offsetX < 3 ) {
		if ( thisEvent.offsetX < 3 && ele.cellIndex!=0) {
			return true;
		} else if ( thisEvent.offsetX > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}

