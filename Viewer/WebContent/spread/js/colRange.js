// ============== ���ύX�֘A ==================================================

	// ���ύX�֘A
	var target = null;
	var activation = null;
	var mouseX = -1;			// �}�E�X�|�C���^�ړ��O��X���W�i���ύX�Ŏg�p�j
	var mouseY = -1;			// �}�E�X�|�C���^�ړ��O��Y���W�i�����ύX�Ŏg�p�j
	var selectedCellInitialValue = 0;	// �N���X�w�b�_�Ńh���b�N���ꂽ�Z���̕��������͍����̏����l
	var changedColRange = false;		// ���ύX��mouseUp�����̏I�����ɁAtrue��ݒ�B
										// true�̏ꍇ��

	// Spread�\���G���A(BODY)�̃h���b�O�\�̈�ɂ��߂�A�N���X�w�b�_�̈�̕�/�����̍ő�l(����)
	var crossHeaderMaxWidthRate  = 0.8;	// ��
	var crossHeaderMaxHeightRate = 0.8;	// ����


	// Input(cell): ��w�b�_��̃Z���I�u�W�F�N�g�i<TD>�j
	// Input(slideNum): ���͂��󂯂��Z���I�u�W�F�N�g��O��ɒ�������
	//					�i���͂��󂯂��Z���I�u�W�F�N�g�ɑΉ�����<COL>�̃C���f�b�N�X��
	//					�@���̂܂܏o�͂���ꍇ�́A0�j
	// Input(position): ���͂��󂯂��Z���I�u�W�F�N�g�̍����̃J�����ɑΉ�����COL��
	//					�C���f�b�N�X��Ԃ���(LEFT)�A�E���̃J�����ɑΉ�����COL��
	//					�C���f�b�N�X��Ԃ���(RIGHT)
	// Output:�Ή������w�b�_�̃C���f�b�N�X�i<COL>�j
	function changeCellIndexToCHCOL( cell,slideNum,position) {
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

	// �N���X�w�b�_�A��w�b�_�̕��ύX�Ɠ��������āA�s�w�b�_�A�f�[�^�\�����̗񕝂�ύX
	function changeCellWidth(target,delt,activation,method) {
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
		} else if ( activation == "modifyCrossHeaderWidth" ) { 

			// �N���X�w�b�_�\���G���A�̕���ύX
			CRSHeaderObject.style.width = CRSHeaderObject.offsetWidth + delt;

			// �N���X�w�b�_��COL�̕���ύX
			target.style.width = width;

			if ( method == "UP" ) {
				// �X�v���b�h�z�u�p�e�[�u����CrossHeader,RowHeader�z�u���
				// �Ή�����COL����ύX
				var crossRHObj = document.all("CROSS_RH");
				crossRHObj.style.width = CRSHeaderObject.offsetWidth;

				// �s�w�b�_�z�u�G���A�̕���ύX
				rowHeader.style.width = CRSHeaderObject.offsetWidth;

				// �h���b�O���ꂽ�Z���ɑΉ�����A�s�w�b�_��COL�̕���ύX
				var cgColIndex = getCOLIndexByCOLObj(target);
				var rowCOLObj = document.all( "RH_CG" + cgColIndex );
				rowCOLObj.style.width = width;

				// �N���X�w�b�_�\���G���A�̕��{��w�b�_�\���G���A�̕������ɕۂ��߁A
				// ��w�b�_�\���G���A�E�f�[�^�e�[�u���\���G���A����
				// �s�w�b�_��̑����݌v������
				var totalChangedWidth = target.offsetWidth - selectedCellInitialValue;
				dataTableArea.style.width = dataTableArea.offsetWidth - totalChangedWidth;
				colHeader.style.width = colHeader.offsetWidth - totalChangedWidth;
			}
		}

		// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu(X���AY��)�����킹��
		scrollView();
		return;
	}

	// �s�̍�����ύX
	function changeRowHeight(target,delt,activation,method) {
		var height = target.offsetHeight + delt;
		if (height <= 0) {
			// height ��0�ȉ��ɂȂ����ꍇ�ɂ́Aheight="1px"�Ƃ���B
			// height��0�ȉ��ɐݒ肷�邱�Ƃ͂ł��Ȃ��i�G���[�ɂȂ�j���߁B
			height = "1px";
			target.style.height = height;
			scrollView();

			return;
		}

		// �I���s�̍�����ύX
		target.style.height = height;
		if ( method == "UP" ) {

			// �I���s�ɑΉ�����A�s�w�b�_�������̓f�[�^�e�[�u���̍s�̍�����ύX
			if ( activation == "modifyRowHeaderHeight" ) {
				// �f�[�^�\���e�[�u����TR�I�u�W�F�N�g���擾
				var tmpRowIndex = parseInt(getRowIndexByTRObj(target));
				var dataRow = dataTable.rows(tmpRowIndex);
				
				// ������ύX
				dataRow.style.height = height;

			} else if ( activation == "modifyCrossHeaderHeight" ) {
				// ��w�b�_��TR�I�u�W�F�N�g���擾
				var tmpCHRowIndex = target.rowIndex;
				var colHeaderRow = colHeader.firstChild.rows(tmpCHRowIndex);

				// �h���b�O���ꂽ�Z���ɑΉ�����A��w�b�_�̍�����ύX
				colHeaderRow.style.height = height;

				// �N���X�w�b�_�\���G���A�̍����{�s�w�b�_�\���G���A�̍���������
				// �ۂ��߁A�s�w�b�_�\���G���A�E�f�[�^�e�[�u���\���G���A����
				// �s�w�b�_��̑����݌v������

				var totalChangedHeight = target.offsetHeight - selectedCellInitialValue;

				rowHeader.style.height = rowHeader.offsetHeight - totalChangedHeight;
				dataTableArea.style.height = dataTableArea.offsetHeight - totalChangedHeight;
			}
		}
		// �s�E��w�b�_�A�f�[�^�e�[�u���̃X�N���[���ʒu(X���AY��)�����킹��
		scrollView();
		return;
	}


	function mouseDown() {

		// ���[�J���ϐ�

		// �Z���I�u�W�F�N�g�̎擾���s�Ȃ�
		var srcEle = getCellObjFromAxisImage( window.event.srcElement );
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
			} else if ( onCrossHeaderCellVLine(window.event) ) {
				mousePosition = "crossHeaderCellVLine";
			} else if ( onRowHeaderCellHLine(window.event) ) {
				mousePosition = "rowHeaderCellHLine";
			} else if ( onCrossHeaderCellHLine(window.event) ) {
				mousePosition = "crossHeaderCellHLine";
			} else {
				return;
			}

		// X���W�i�␳�ρj�̎擾���s�Ȃ�
		var x = getAxisTitleX(srcEle, event);

		// ���ʕϐ��̏�����
		target = null;
		activation = null;
		mouseX = -1;
		mouseY = -1;
		selectedCellInitialValue = 0;

		// ����
		if ( ( mousePosition == "columnHeaderCellVLine" ) || ( mousePosition == "crossHeaderCellVLine" ) ) {
			if ( x < 3 ) {

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
				if ( tmpObj == null ) {
					if ( mousePosition == "columnHeaderCellVLine" ) {
						var crossHeaderLastColIndex = 0;
						if ( !isLastHie(srcEle) ) {
							crossHeaderLastColIndex = rowObjNum-1;
						} else {
							selectedCell = document.all("CrossHeader_R" + srcEle.parentNode.rowIndex).lastChild;
							crossHeaderLastColIndex = getColIndexByTDObj( selectedCell );
						}
						activation = "modifyCrossHeaderWidth";	// ����̐ݒ�
						// ���ύX���s�Ȃ��I�u�W�F�N�g��������
						// ���̑�\�I�u�W�F�N�g��ݒ�
						target = document.all( "CrossHeader_CG" + crossHeaderLastColIndex );
						mouseX = event.clientX;					// X���W��o�^
						selectedCellInitialValue = target.offsetWidth;
						return;
					}
				}

				// �I�����ꂽ�Z���ɑΉ�����COL�I�u�W�F�N�g�����߂�
				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,-1,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);
					// ���ׂ̗񂪔�\����Ԃ̏ꍇ�A���̗���X�L�b�v���A�\����ō��ׂ̗��T��
					if ( tmpObj != null ) {
						if ( tmpObj.offsetWidth == 0 ) {
							while( targetIndex != 0) {
								targetIndex = targetIndex -1;
								tmpObj = tmpObj.previousSibling;
								if ( tmpObj.offsetWidth != 0 ) {
									break;
								}
							}
						}
					}
				} else if ( mousePosition == "crossHeaderCellVLine" ) {
					targetIndex = getColIndexByTDObj(srcEle) - 1;
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );

				} else {
					return;
				}
			} else if ( x > srcEle.offsetWidth - 4) {

				if ( mousePosition == "columnHeaderCellVLine" ) {
					// �N���b�N���ꂽ�Z���ɑΉ�����ACOL�I�u�W�F�N�g��Index�����߂�B
					// for (�����̗�ԍ� < ��̑���-1)
					// ***** ��w�b�_�Z�������̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
					// 	��w�b�_�Z���̍Ō�̗�������͂���ȑO�̓W�J��̃Z����
					//	�I�����ꂽ���̂Ƃ݂Ȃ��B
					// 	�i�h�������ꂸ�ɏW�񂳂�Ă���Z���̓X�L�b�v����j

					// �I�����ꂽ�Z���ɑΉ�����COL�I�u�W�F�N�g�����߂�
					targetIndex = changeCellIndexToCHCOL(srcEle,0,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);

					if ( tmpObj.offsetWidth == 0 ) {
						while( targetIndex != getColIndexByTDObj(srcEle) ) {
							targetIndex = targetIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.offsetWidth != 0 ) {
								break;
							}
						}
					}

				} else if ( mousePosition == "crossHeaderCellVLine" ) {

					if ( !isInCrossHeaderLastRow(srcEle) ) {
						targetIndex = rowObjNum-1;
					} else {
						targetIndex = getColIndexByTDObj(srcEle);
					}
					tmpObj = document.all( "CrossHeader_CG" + targetIndex );
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

		if ( ( mousePosition == "rowHeaderCellHLine" ) || ( mousePosition == "crossHeaderCellHLine" ) ) {
			if ( window.event.offsetY < 3 ) {
			// ***** �s�w�b�_�Z���㕔�̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
			// 	�s�w�b�_�̈�ȏ��̓W�J�s�̃Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// 	�i�h�������ꂸ�ɏW�񂳂�Ă���Z���̓X�L�b�v����j
			// 	�܂��A�s�w�b�_�P�s��(index=0)�̃Z���㕔���N���b�N���ꂽ�ꍇ�́A
			// 	���̃N���X�w�b�_�[���̃Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// ***** �N���X�w�b�_�Z���㕔�̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
			// 	���̃w�b�_�Z�����I�����ꂽ���̂Ƃ݂Ȃ��B
			// 	�܂��A�N���X�w�b�_�P�s�ڂ̃Z���㕔���N���b�N���ꂽ�ꍇ�́A
			// 	���삵�Ȃ��B
				tmpObj = srcEle.parentNode.previousSibling;
				if ( tmpObj == null ) {
					if ( mousePosition == "rowHeaderCellHLine" ) {
						// �s�w�b�_�P�s��(index=0)�̃Z���㕔���N���b�N���ꂽ

						tmpObj = document.all("CrossHeaderArea").firstChild.lastChild.lastChild;
						activation = "modifyCrossHeaderHeight";	// ����̐ݒ�
						target = tmpObj;			// ���ύX���s�Ȃ��I�u�W�F�N�g��������
													// ���̑�\�I�u�W�F�N�g

						selectedCellInitialValue = target.offsetHeight;	// �����l��o�^
						mouseY = event.clientY;		// Y���W��o�^

						return;
					} else if ( mousePosition == "crossHeaderCellHLine" ) {
						return null;
					} else {
						return null;
					}
				}
				// ��ׂ̍s����\����Ԃ̏ꍇ�A���̍s���X�L�b�v���A�\���s�ŏ�ׂ̍s��T��
				if ( mousePosition == "rowHeaderCellHLine" ) {
					var tmpRowIndex = tmpObj.rowIndex;
					if ( tmpObj.style.display == 'none' ) {
						while( tmpRowIndex != 0) {
							tmpRowIndex = tmpRowIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.style.display != 'none' ) {
								break;
							}
						}
					}
				}

			} else if ( window.event.offsetY > srcEle.offsetHeight - 4) {
			// ***** �s�w�b�_�Z�������̃h���b�O�\�̈悪�N���b�N���ꂽ�ꍇ *****
			// 	�s�w�b�_�Z���̍Ō�̍s�������͂���ȑO�̓W�J�s�̃Z����
			//	�I�����ꂽ���̂Ƃ݂Ȃ��B
			// 	�i�h�������ꂸ�ɏW�񂳂�Ă���Z���̓X�L�b�v����j

				if ( mousePosition == "rowHeaderCellHLine" ) {
					// �I�����ꂽ�Z���I�u�W�F�N�g�̍ŉ���ɑΉ�����TR�I�u�W�F�N�g�����߂�
					comboNum = getLowerHieComboNum(srcEle,"ROW");
					targetIndex = srcEle.parentNode.rowIndex + comboNum -1;
					tmpObj = srcEle.parentNode.parentNode.rows[targetIndex];

					var tmpRowIndex = tmpObj.rowIndex;
					if ( tmpObj.style.display == 'none' ) {
						while( tmpRowIndex != srcEle.parentNode.rowIndex) {
							tmpRowIndex = tmpRowIndex -1;
							tmpObj = tmpObj.previousSibling;
							if ( tmpObj.style.display != 'none' ) {
								break;
							}
						}
					}

				} else if ( mousePosition == "crossHeaderCellHLine" )  {
					tmpObj = srcEle.parentNode;			// TR Object
				} else {
					return null;
				}
			} else {
				return null;
			}

			// �}�E�X�_�E�����̏󋵂̕ۑ�����
			target = tmpObj;
			if ( mousePosition == "rowHeaderCellHLine" ) {
				activation = "modifyRowHeaderHeight";
			} else if ( mousePosition == "crossHeaderCellHLine" )  {
				activation = "modifyCrossHeaderHeight";
				selectedCellInitialValue = target.offsetHeight;
			} else {
				return null;
			}
			mouseY = event.clientY
			return;
		}

		event.cancelBubble = true;

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
			
			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
			// �h���b�O���ɍs�w�b�_�̍����𓮓I�ɕύX
				var delt = window.event.clientY - mouseY;

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + document.all("pageEdgeTable").offsetHeight + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					// �N���X�w�b�_���̕��̏���𒴂��Ă��Ȃ���
					// �i���h���b�O�s�\�̈�͏��O�F�y�[�W�G�b�W�{innerHTML�{�񎟌����\�����j
					return;
				}

				var method = "MOVE";
				retCode = changeRowHeight(target,delt,activation,method);

				mouseY = window.event.clientY;
				return;
			}

		} else {
		// �s�w�b�_�A��w�b�_���̃h���b�O�\�̈��
		// �}�E�X�|�C���^���������ꂽ�ꍇ�A�}�E�X�A�C�R����
		// �h���b�O�p�̃A�C�R���֕ύX����

			var pointedCell = window.event.srcElement;
			if ( onColumnHeaderCellVLine(window.event) == true ) {
				pointedCell.style.cursor = "col-resize";
			} else if ( onRowHeaderCellHLine(window.event) == true ) {
					pointedCell.style.cursor = "row-resize";
			} else if ( onCrossHeaderCellVLine(window.event) == true ) {
					pointedCell.style.cursor = "col-resize";
			} else if ( onCrossHeaderCellHLine(window.event) == true ) {
					pointedCell.style.cursor = "row-resize";

			} else if (window.event.srcElement.tagName=='IMG' || 
					   window.event.srcElement.tagName=='DIV' ) {
			// �h���b�O�\�̈�ɂ͖������A
			// �}�E�X�|�C���^���h�����C���[�W�iIMG)��ɂ��邩�A
			// �_�C�X�C���[�W�iDIV�̃o�b�N�O���E���h�C���[�W�j��ɂ���ꍇ


				if (window.event.srcElement.style.cursor == "") {
				// �|�C���^�̃J�[�\�����f�t�H���g�ɂ���
					pointedCell.style.cursor = "default";
				} else {
				// �|�C���^�̃J�[�\�����ɕύX����

					// �C���[�W�̈�Ȃ̂ŁA"hand"
					if ( window.event.srcElement.id == "axisLeft") {
						pointedCell.style.cursor = "hand";

					// ���̗̈�Ȃ̂ŁA"default"(���ɂ��ǂ�)
					} else {
						pointedCell.style.cursor = "default";
					}
				}

			} else {
			// �}�E�X�|�C���^���Z���̒������ɂ���ꍇ�A�J�[�\���A�C�R�����f�t�H���g�ɖ߂�
				pointedCell.style.cursor = "default";
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
				changedColRange = true;

				return;
			}

			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
				var delt = window.event.clientY - mouseY;
				var method = "UP";

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + document.all("pageEdgeTable").offsetHeight + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					// ���N���X�w�b�_���̍����̏���𒴉߁�
					// �i���h���b�O�s�\�̈�͏��O�F�y�[�W�G�b�W�{innerHTML�{�񎟌����\�����j
					// ��w�b�_���̍������N���X�w�b�_���̍����ɍ��킹��
					retCode = changeRowHeight(target,0,activation,method);
				} else {

					// ������ύX
					retCode = changeRowHeight(target,delt,activation,method);
				}

				// ���ʕϐ��̏�����
				target = null;
				activation = null;
				mouseX = -1;
				mouseY = -1;
				selectedCellInitialValue = 0;
				changedColRange = true;

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

		if (ele.id=="adjustCell") {	// adjustCell��ł���΁A�I������
			return;
		}

		// X���W�i�␳�ρj�̎擾���s�Ȃ�
		var x = getAxisTitleX(ele, event);

		// �Z���������̌r���t�߂ł��邩�A�Z�����E���̌r���t�߂ł����
		// �utrue�v��Ԃ�
		if ( x < 3 ) {
			return true;
		} else if ( x > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}


	function onRowHeaderCellHLine( thisEvent ) {
	// ����:     �C�x���g�I�u�W�F�N�g
	// �߂�l�F  true / false
	// �T�v�F    �C�x���g���s�w�b�_�Z���̉��̌r���t��
	//           (offset�ŋ��߂��鐔�l�ŁA3����)��
	//           ���������ꍇ�ɂ́utrue�v����ȊO�̏ꍇ�ɂ́ufalse�v��Ԃ��B
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ele.parentElement.Spread != "RowHeaderRow" ) {
			return false;
		}

		// �Z�����㕔�̌r���t�߂ł��邩�A�Z���������̌r���t�߂ł����
		// �utrue�v��Ԃ�
		if ( thisEvent.offsetY < 3 ) {
			return true;
		} else if ( thisEvent.offsetY > ele.offsetHeight - 4) {
			return true;
		}
		return false;
	}

	function onCrossHeaderCellHLine( thisEvent ) {
	// ����:     �C�x���g�I�u�W�F�N�g
	// �߂�l�F  true / false
	// �T�v�F    �C�x���g���N���X�w�b�_�[�Z���̉��̌r���t��
	//           (offset�ŋ��߂��鐔�l�ŁA3����)��
	//           ���������ꍇ�ɂ́utrue�v����ȊO�̏ꍇ�ɂ́ufalse�v��Ԃ��B
	//           �A���A�P�s�ڂ̃Z���㕔�̉��̌r���t�߂́ufalse�v�Ƃ���B

		var ele = thisEvent.srcElement;
		if ( ele.tagName == "DIV" ) {
			ele = ele.parentElement;
		}
		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		// �Z�����㕔�̌r���t�߂ł��邩�A�Z���������̌r���t�߂ł����
		// �utrue�v��Ԃ�
		if ( thisEvent.offsetY < 3 ) {
			//��s�ڂ̃Z���㕔�̏ꍇ�́A�ufalse�v��Ԃ�
			if ( ele.parentNode.rowIndex == 0 ) {
				return false;
			}
			return true;
		} else if ( thisEvent.offsetY > ele.offsetHeight - 4) {
			return true;
		}
		return false;
	}

	function onCrossHeaderCellVLine( thisEvent ) {
	// ����:     �C�x���g�I�u�W�F�N�g
	// �߂�l�F  true / false
	// �T�v�F    �C�x���g���N���X�w�b�_�[�Z���̏c�̌r���t��
	//           (offset�ŋ��߂��鐔�l�ŁA3����)��
	//           ���������ꍇ�ɂ́utrue�v����ȊO�̏ꍇ�ɂ́ufalse�v��Ԃ��B
	//           �A���A�P�s�ڂ̃Z�������̏c�̌r���t�߂́ufalse�v�Ƃ���B

		// �Z���I�u�W�F�N�g�̎擾���s�Ȃ�
		var ele = getCellObjFromAxisImage( thisEvent.srcElement );
			if (ele == null) { return false; }

		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		// X���W�i�␳�ρj�̎擾���s�Ȃ�
		var x = getAxisTitleX(ele, event);

		// �Z���������̌r���t�߂ł��邩�A�Z�����E���̌r���t�߂ł����
		// �utrue�v��Ԃ�
		if ( x < 3 ) {
			//���ڂ̃Z�������̏ꍇ�́A�ufalse�v��Ԃ�
			if ( ele.cellIndex == 0 ) {
				return false;
			}
			return true;
		} else if ( x > ele.offsetWidth - 4) {
			return true;
		}
		return false;

	}
