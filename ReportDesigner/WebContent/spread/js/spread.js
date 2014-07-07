
// ============== ���ʊ֐� =========================================================================
// =================================================================================================
// =================================================================================================

	// �����������@���|�[�g���擾���\�b�h�@����������

	// �s�w�b�_�A��w�b�_���̎�ID�����߂�
	// <Input>	hieIndex:	�s�w�b�_�A��w�b�_���̃C���f�b�N�X(0start)
	// <Input>	target:		�s�w�b�_�A��w�b�_��
	// <Output>	�w�肳�ꂽ�ꏊ�ɔz�u����Ă��鎲��ID
	function getHieID( hieIndex, target ) {
		if ( ( hieIndex == null ) || ( target == null ) ) { return null; }
		if ( ( target != "COL" ) && ( target != "ROW" ) ) { return null; }

		var idList;
		if ( target == "COL" ) {
			idList = document.SpreadForm.colEdgeIDList_hidden.value.split(",");
		} else if ( target == "ROW" ) {
			idList = document.SpreadForm.rowEdgeIDList_hidden.value.split(",");
		}

		return idList[hieIndex];
	}

	// �G�b�W���̎��������߂�
	// <Input>	targetString:�s�w�b�_����w�b�_��(COL��ROW��PAGE��)
	// <Output>	�w�肳�ꂽ�w�b�_�ɔz�u���ꂽ���̐���Ԃ�
	function getHeaderObjNum( targetString ) {
		if ( targetString == "COL" ) {
			return colObjNum;
		} else if ( targetString == "ROW" ) {
			return rowObjNum;
		} else if ( targetString == "PAGE" ) {
			var pageAxisCount = 0;
			var pageAxisIDs = getAxisIdListInEdge( targetString, axesXmlData );
			if (pageAxisIDs != null) {
				var pageAxisIDArray = pageAxisIDs.split(",");
				pageAxisCount = pageAxisIDArray.length;
			}
			return pageAxisCount;
		} else {
			return null;
		}
	}

	// �G�b�W���̎�ID���X�g�����߂�
	// <Input>	edgeType:�G�b�W�̃^�C�v("COL","ROW","PAGE")
	// <Input>	axesXmlData:���|�[�g���XML
	// <Output>	�w�肳�ꂽ�G�b�W�ɔz�u����Ă��鎲ID���X�g(�J���}��؂�,�iindex��)
	function getAxisIdListInEdge( edgeType, axesXmlData ) {
		if ( ( edgeType != "COL" ) && ( edgeType != "ROW" ) && ( edgeType != "PAGE" ) ) {
			return "";
		}
		if ( axesXmlData == null ) { return ""; }

		var axisIDString = "";
		var axisIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/" + edgeType + "/HierarchyID")
		for ( i = 0; i < axisIDs.length ; i++ ) {
			if ( i > 0 ) {
				axisIDString += ","
			}
			axisIDString += axisIDs[i].text;
		}

		return axisIDString;
	}

	// ��������G�b�W�������߂�
	// <Input>	axisID:��ID
	// <Output>	�w�肳�ꂽ�����z�u����Ă���G�b�W�̖��̂�Ԃ��B
	function getAxisPosition(axisID) {
		if (axisID == null) { return null; }

		var colEdgeAxisList = getAxisIdListInEdge("COL", axesXmlData);
		var colEdgeAxisArray = colEdgeAxisList.split(",");
		for (var i = 0; i < colEdgeAxisArray.length; i++) {
			if (colEdgeAxisArray[i] == axisID) {
				return "COL";
			}
		}

		var rowEdgeAxisList = getAxisIdListInEdge("ROW", axesXmlData);
		var rowEdgeAxisArray = rowEdgeAxisList.split(",");
		for (var i = 0; i < rowEdgeAxisArray.length; i++) {
			if (rowEdgeAxisArray[i] == axisID) {
				return "ROW";
			}
		}

		var pageEdgeAxisList = getAxisIdListInEdge("PAGE", axesXmlData);
		var pageEdgeAxisArray = pageEdgeAxisList.split(",");
		for (var i = 0; i < pageEdgeAxisArray.length; i++) {
			if (pageEdgeAxisArray[i] == axisID) {
				return "PAGE";
			}
		}

		return null;
	}

	// �G�b�W�������Col�G�b�W�ARow�G�b�W�̑g�ݍ��킹������
	// <Input>  targetArray:  ��r�ΏۂƂȂ鎲ID�̔z��
	// <Input>	sourceArray1: ��r���̎�ID�̔z��
	// <Input>	sourceArray2: ��r���̎�ID�̔z��
	//						  ���̔z��null�̏ꍇ�́AtargetArray��sourceArray1���r
	//						  null�łȂ��ꍇ�́AtargetArray��sourceArray1�{sourceArray2���r
	// <Output>	�������̑g�ݍ��킹�����Ă�true�A�����Ȃ��ꍇ��false
	// Col��Row�Ŏ�������ւ���Ă��Ă�OK�B
	// �Ȃ��A�e�G�b�W�̏����͍l�����Ȃ�
	function hasSame2Axes(targetArray, sourceArray1, sourceArray2) {
		if( (targetArray == null) || (sourceArray1 == null) ) { return false; }

		var sourceArray = null;
			if ( sourceArray2 == null ) {
				sourceArray = sourceArray1;
			} else {
				sourceArray = sourceArray1.concat(sourceArray2);
			}

		// �G�b�W�̎��������r
		if(targetArray.length != (sourceArray.length) ) {
			return false;
		}

		// �G�b�W�̎��v�f���r���A�����g�ݍ��킹�ł����true
		for(var i = 0; i < targetArray.length; i++ ) {
			var findFLG = false;
			for ( var j = 0; j < sourceArray.length; j++ ) {
				if( targetArray[i] == sourceArray[j] ) {
					findFLG = true;
					break;
				}
			}
			if ( findFLG == false ) {
				return false;
			}
		}
		return true;
	}

	// �����������@�������o���Z�o���\�b�h�@����������

	// �w�肳�ꂽ���̃����o�������߂�
	// <Input>	targetString:�s�w�b�_����w�b�_��(COL��ROW��)
	// <Input>	hierarchyID:�i�̃C���f�b�N�X(1�i�ڂ̏ꍇ=0,2�i�ڂ̏ꍇ=1,3�i�ڂ̏ꍇ=0)
	// <Output>	�w�肳�ꂽ�w�b�_�̎w�肳�ꂽ�i�C���f�b�N�X�ɔz�u����Ă��鎲�̃����o��
	function getAxisMemNum( targetString, hierarchyID ) {

		if ( targetString == "COL" ) {
			if ( hierarchyID == 0 ) {
				return chMemNumList[0];
			} else if ( hierarchyID == 1 ) {
				return chMemNumList[1];
			} else if ( hierarchyID == 2 ) {
				return chMemNumList[2];
			}
		} else if ( targetString == "ROW" ) {
			if ( hierarchyID == 0 ) {
				return rhMemNumList[0];
			} else if ( hierarchyID == 1 ) {
				return rhMemNumList[1];
			} else if ( hierarchyID == 2 ) {
				return rhMemNumList[2];
			}
		}
		return null;
	}

	// �w�肳�ꂽ���̃����o�������߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	// <Output>	�w�肳�ꂽ�������������o����Ԃ�
	function getAxisMemberNumber(oTD) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		var targetString = getCellPosition(oTD);
		var hierarchyID  = getHieIndex(oTD);;

		if ( ( targetString == null ) || ( hierarchyID == -1 ) ) { return null; }

		return getAxisMemNum( targetString, hierarchyID )
	}

	// ���i�ɔz�u���ꂽ���̃����o�������߂�
	// <Input>	hieIndex:�i�C���f�b�N�X
	// <Input>	target:�s�w�b�_����w�b�_��(COL��ROW��)
	// <Output>	�^����ꂽ�i�C���f�b�N�X�̎��i�̃����o����Ԃ��B
	//			�w�b�_�̍ŏI�i�ł����0��Ԃ��B
	function getNextAxisMemberNumber( hieIndex, target ) {
		if ( hieIndex == null ) { return null; }
		if ( target == null ) { return null; }
		if ( hieIndex > 2 || hieIndex < 0 ) {	// �C���f�b�N�X�͈̔̓`�F�b�N
			return -1;
		}

		if ( target == "COL" ) {
			if ( hieIndex + 1 >= colObjNum ) {
				return 0;
			} else {
				return chMemNumList[hieIndex + 1];
			}
		} else if ( target == "ROW" ) {
			if ( hieIndex + 1 >= rowObjNum ) {
				return 0;
			} else {
				return rhMemNumList[hieIndex + 1];
			}
		} else {
			return -1;
		}
	}


	// �w�肳�ꂽ�Z���̉��i�ɔz�u���ꂽ�������o�̑g�ݍ��킹�������߂�
	// Input)
	//  cell�F�s�܂��͗��TD�v�f
	//  target�FTD�v�f���s�w�b�_�̂��̂��A��w�b�_�̂��̂���\��
	// Output)
	//  �^����ꂽTD�v�f�̒i�́A���i�ȍ~�̎���/���W���[�����o�̑g�ݍ��킹����Ԃ��B
	//  ��ɐݒ肳�ꂽ�Ō�̎���/���W���[�ł������ꍇ�́A1��Ԃ��B
	function getLowerHieComboNum( cell, target ) {

		var hieIndex = getHieIndex(cell);
		if ( hieIndex == -1 ) {
			return -1;
		}

		var retComboNum = getLowerHieComboNumByIndex(target, hieIndex);
		return retComboNum;
	}

	// �w�肳�ꂽ���̉��i�ɔz�u���ꂽ�������o�̑g�ݍ��킹�������߂�
	function getLowerHieComboNumByIndex( target, hieIndex ) {

		var nextAxisMemNum = -1;
		var retComboNum    = 1;
		var hieMaxIndex    = 0;
		if ( target == "COL" ) {
			hieMaxIndex = colObjNum;
		} else if ( target == "ROW" ) {
			hieMaxIndex = rowObjNum;
		}

		for ( var i = hieIndex; i < hieMaxIndex; i++ ) {
			nextAxisMemNum = getNextAxisMemberNumber(i,target);
			if ( nextAxisMemNum != 0 ) {	// �ŉ��i�ł�getNextAxisMemberNumber��0��Ԃ�����
				retComboNum = retComboNum * nextAxisMemNum;
			}
		}
		return retComboNum;
	}


	// �����������@�f�[�^�e�[�u���֘A���\�b�h�@����������

	// �f�[�^�e�[�u����target�ɂ��w�肳�ꂽ�w�b�_�̍s�܂��͗�
	// <Input>  target�F�s�܂��͗��\��
	// <Output> <target==��̎�>�P��Ɋ܂܂��Z���̐�
	//          <target==�s�̎�>�P�s�Ɋ܂܂��Z���̐�
	function getDataTableCellNumbers( target ) {

		if ( target == "COL" ) {
			return dataTable.rows.length;
		} else if ( target == "ROW" ) {
			return dataTable.rows[0].cells.length;
		} else {
			return null;
		}
	}

	// �����������@�Z���I�u�W�F�N�g�擾���\�b�h�@����������

	// ���|�[�g���XML�̎������o�v�f�����߂�
	// <Input>	xmlDoc:���|�[�g���XML
	// <Input>	target:�G�b�W�̖���
	// <Input>	hieIndex:��Index
	// <Input>	xmlIndex:XML��Index
	// <Output>	XML�m�[�h
	function getXMLMemberNode (xmlDoc, target, hieIndex, xmlIndex) {
		var axisID = xmlDoc.selectSingleNode("/root/OlapInfo/AxesInfo/" + target +"/HierarchyID[" + (hieIndex+1) + "]").text;

		var targetNode = xmlDoc.selectSingleNode("/root/Axes/Members[@id=" + axisID + "]//Member[@id=" + xmlIndex + "]");
		return targetNode;
	}


	// �w�肳�ꂽ�w�b�_�̎w�肳�ꂽSpreadIndex�ɑΉ�����COL��������ROW�̃I�u�W�F�N�g���擾
	// <Input> target:�Ώۂ��s�w�b�_���A��w�b�_��
	//		   nodeSpreadIndex:�m�[�h��Spread�C���f�b�N�X
	// <Output>�s�w�b�_�̏ꍇ�ATR�I�u�W�F�N�g
	//		   ��w�b�_�̏ꍇ�ACOL�I�u�W�F�N�g
	function getSpreadNode( target, spreadIndex ) {
		var spreadNode;

		if ( target == "COL" ) {
			spreadNode = colHeader.all("CH_CG").children(spreadIndex);
		} else if ( target == "ROW"){
			spreadNode = rowHeader.firstChild.rows[spreadIndex];
		}

		return spreadNode;
	}

	// �w�肳�ꂽTD�I�u�W�F�N�g�ɑΉ�����COL��������ROW�̃I�u�W�F�N�g���擾
	// <Input> ele: �s�w�b�_�������͗�w�b�_��TD�I�u�W�F�N�g
	// <Output>�s�w�b�_�̏ꍇ�ATR�I�u�W�F�N�g
	//		   ��w�b�_�̏ꍇ�ACOL�I�u�W�F�N�g
	function getSpreadNodeByTDObj( ele ) {

		if ( isCellInColHeader(ele) ) {
			return colHeader.all( "CH_CG" + getColIndexByTDObj(ele) );
		} else if ( isCellInRowHeader(ele) ) {
			return ele.parentNode;
		}
	}


	// TR��������COL�I�u�W�F�N�g���s�������͗��TD�I�u�W�F�N�g���擾����
	// Input�j
	//   node:<target=="�s"�̏ꍇ>�s�w�b�_�e�[�u����TR�I�u�W�F�N�g
	//        <target=="��"�̏ꍇ>��w�b�_�e�[�u����COL�I�u�W�F�N�g
	//   target�F�s���񂩂�\��(COL or ROW)
	//   hieIndex�F�Ώۃw�b�_�̉��Ԗڂ̎��̃I�u�W�F�N�g���擾���邩(0start)
	// Output)TD�I�u�W�F�N�g
	function getCellObj( node, target, hieIndex ) {

		var targetObjNum = getHeaderObjNum( target );

		var colIndex;
		var rowIndex;
		var targetRow;

		// �擾�Ώۂ���w�b�_�̃I�u�W�F�N�g�̏ꍇ
		if ( target == "COL" ) {
			colIndex  = parseInt(getCOLIndexByCOLObj(node));
			targetRow = colHeader.firstChild.rows(hieIndex); 

			var headerMemNum1 = getAxisMemNum( target, 1 );
			var headerMemNum2 = getAxisMemNum( target, 2 );

			if ( targetObjNum == 1 ) {
				colIndex = colIndex;
			} else if ( targetObjNum == 2 ) {
				if ( hieIndex == 0 ) {
					colIndex = Math.round((colIndex/headerMemNum1) - 0.5);
				} else if ( hieIndex == 1 ) {
					colIndex = colIndex;
				}
			} else if ( targetObjNum == 3 ) {
				if ( hieIndex == 0 ) {
					colIndex = Math.round((colIndex / (headerMemNum1*headerMemNum2)) - 0.5);
				} else if ( hieIndex == 1 ) {
					colIndex = Math.round((colIndex / headerMemNum2) - 0.5);
				} else if ( hieIndex == 2 ) {
					colIndex = colIndex;
				}
			}

		} else if ( target == "ROW" ) {
		// �擾�Ώۂ��s�w�b�_�̃I�u�W�F�N�g�̏ꍇ
			colIndex  = hieIndex;
			targetRow = node; 

			if ( targetObjNum == 1 ) {
				colIndex = colIndex;
			} else if ( targetObjNum == 2 ) {
				if ( hieIndex == 1 ) {
					if ( node.cells.length == 1 ) {
						colIndex = colIndex-1;
					} else if ( node.cells.length == 2 ) {
						colIndex = colIndex;
					}
				} else if ( hieIndex == 0 ) {
					colIndex = colIndex;
				}
			} else if ( targetObjNum == 3 ) {
				if ( hieIndex == 2 ) {
					if ( node.cells.length == 1 ) {
						colIndex = colIndex-2;
					} else if ( node.cells.length == 2 ) {
						colIndex = colIndex-1;
					} else if ( node.cells.length == 3 ) {
						colIndex = colIndex;
					}
				} else if ( hieIndex == 1 ) {
					if ( node.cells.length == 2 ) {
						colIndex = colIndex-1;
					} else if ( node.cells.length == 3 ) {
						colIndex = colIndex;
					}
				} else if ( hieIndex == 0 ) {
					if ( node.cells.length == 3 ) {
						colIndex = colIndex;
					}
				}
			}
		}

		// �s�������͗��TD�I�u�W�F�N�g��߂�
		return targetRow.cells(colIndex);
	}


	// ���������� �Z���z�u�ʒu�擾���\�b�h ����������

	// �Z���̔z�u�ꏊ(COL,ROW,DATA)�����߂�
	// <Input>	oTD:�s�A��A�f�[�^�e�[�u����TD
	// <Output>	�s�A��A�f�[�^�e�[�u����\���������Ԃ��i�s�FCOL�A��FROW�A�f�[�^�e�[�u���FDATA�j
	function getCellPosition ( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		var strID = oTD.id;

		if ( strID.split("_")[0] == "CH" ) {
			return "COL";
		} else if ( strID.split("_")[0] == "RH" ) {
			return "ROW";
		} else if ( strID.split("_")[0] == "DC" ) {
			return "DATA";
		}

		return null;
	}

	// �N���X�w�b�_�[���̃Z����
	// <Input>	ele:TD Object
	// <Output>	true / false
	function isInCrossHeaderAreaByTDObj(ele) {
		var t = ele;
		var objID = "";
		var tSPANObj = null;
		if ( t.tagName == "TD" ) {
			tSPANObj = t.parentNode.parentNode.parentNode.parentNode;

			if ( tSPANObj != null ) {
				if ( tSPANObj.id == "CrossHeaderArea" ) {
					return true;
				}
			}
		} else {
			return false;
		}
		return false;
	}

	// ��w�b�_���̃Z����
	// Input	:�I�u�W�F�N�g
	// Output	:ele����w�b�_��TD�I�u�W�F�N�g�ł���΁Atrue��Ԃ�
	function isCellInColHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "COL") {
			return true;
		}
		return false;
	}

	// �s�w�b�_���̃Z����
	// Input	:�I�u�W�F�N�g
	// Output	:ele���s�w�b�_��TD�I�u�W�F�N�g�ł���΁Atrue��Ԃ�
	function isCellInRowHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "ROW") {
			return true;
		}
		return false;
	}

	// �f�[�^�e�[�u�����̃Z����
	// Input	:�I�u�W�F�N�g
	// Output	:ele���f�[�^�e�[�u����TD�I�u�W�F�N�g�ł���΁Atrue��Ԃ�
	function isCellInDataTable( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "DATA") {
			return true;
		}
		return false;
	}


	// �����������@�Z�����擾���\�b�h�@����������

	// �Z�����W�����߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	//				�iID�FRH_RxCy�ACH_RxCy�ADC_RxCy�j
	// <Output>	�s�w�b�_�A��w�b�_�A�f�[�^�e�[�u�����̍��W
	//			�i�����F�ux(col):y(row)�v�j
	function getSpreadCoordinate( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		var coordinate = "";
		if ( getCellPosition( oTD ) == "COL" ) {
			coordinate = getSpreadIndexByTDObj(oTD) + ":" + getHieIndex(oTD);
		} else if ( getCellPosition( oTD ) == "ROW" ) {
			coordinate = getHieIndex(oTD) + ":" + getSpreadIndexByTDObj(oTD);
		} else if ( getCellPosition( oTD ) == "DATA" ) {
			coordinate = oTD.cellIndex + ":" + oTD.parentNode.rowIndex;
		}
		return coordinate;
	}

	// �������o��SpreadIndex�����߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	//				�iID�FRH_RxCy�ACH_RxCy�j
	// <Output>	Spread Index(��/�s���ň�ӂɂȂ�0 start��index(int))
	function getSpreadIndexByTDObj( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		if ( getCellPosition( oTD ) == "COL" ) {
			return parseInt(getColIndexByTDObj(oTD));
		} else if ( getCellPosition( oTD ) == "ROW" ) {
			return parseInt(getRowIndexByTRObj(oTD.parentNode));
		} else {
			return null;
		}
	}

	// �Z���̒i�C���f�b�N�X�����߂�
	// <Input>	oTD:TD �I�u�W�F�N�g
	// <Output>	TD�I�u�W�F�N�g��������s/��̎���/���W���[�̍s/����ł̒i��(0start)
	function getHieIndex( oTD ) {
		if ( oTD == null ) { return -1; }
		if ( oTD.tagName != "TD" ) { return -1; }
		if ( isCellInDataTable(oTD) ) { return -1; }

		if ( isCellInColHeader(oTD) ) {
			return oTD.parentNode.rowIndex;
		}

		if ( isCellInRowHeader(oTD) ) {
			return parseInt(getColIndexByTDObj(oTD));
		}

	}

	// �Z�����s/��̍ŉ��i���H
	// <Input>	oTD�I�u�W�F�N�g
	// <Output>	TD�I�u�W�F�N�g���s/��̍ŉ��i�ł���΁Atrue
	function isLastHie( oTD ) {
		if ( oTD == null ) { return false; }
		if ( oTD.tagName != "TD" ) { return false; }

		var objNum;
		if ( isCellInColHeader( oTD ) ) {
			objNum = colObjNum;
		} else if ( isCellInRowHeader( oTD ) ) {
			objNum = rowObjNum;
		}

		if ( getHieIndex( oTD ) == (objNum-1) ) {
			return true;
		} else {
			return false;
		}
	}

	// �N���X�w�b�_�[���̍ŏI�s���H
	// <Input>	ele: �N���X�w�b�_����TD Object
	// <Output>	true / false
	// Note:	���͂��ꂽTD�I�u�W�F�N�g���N���X�w�b�_�[����
	//			�ŏI�s�̃I�u�W�F�N�g���𒲂ׁA�������ꍇ�́utrue�v�A�قȂ�ꍇ�́ufalse�v��Ԃ��B
	// Error:	�E���͂��ꂽ�I�u�W�F�N�g��TD�I�u�W�F�N�g�łȂ��ꍇ
	//				�ˁufalse�v��Ԃ�
	function isInCrossHeaderLastRow(ele) {

		var isInCrossHeaderFLG = isInCrossHeaderAreaByTDObj(ele);
		if ( ele.tagName == "TD" ) {
			if ( isInCrossHeaderFLG ) {
				var currentRowIndex = ele.parentNode.rowIndex;
				var lastCrossHeaderRowIndex = ele.parentNode.parentNode.lastChild.rowIndex;
				if ( currentRowIndex == lastCrossHeaderRowIndex ) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	// �Z����������i��ɑ����郁���o���X�g�̐擪�����o��
	// <Input>	cell: �s/��G�b�W��TD�I�u�W�F�N�g
	// <Output>	�Z����������i��ɑ����郁���o���X�g�̐擪�����o�ł����true
	// 			�i��i�Ɏ��������ꍇ�A���̎����̐擪�����o�ł����true�j
	function isStartPartCell(cell) {
		if (cell == null) { return false; }
		if (cell.tagName != "TD") { return false; }
		if ((!isCellInColHeader(cell)) && (!isCellInRowHeader(cell))) { return false; }

		var index = getSpreadIndexByTDObj(cell);
		var thisHieMemNum = parseInt(parent.display_area.getAxisMemNum( getCellPosition(cell), getHieIndex(cell) ));			var lowerComboNum = 1 * parseInt(parent.display_area.getLowerHieComboNum( cell, getCellPosition(cell) ));

		if ( ( index % (thisHieMemNum * lowerComboNum) ) == 0 ) {
			return true;
		} else {
			return false;
		}
	}

	// �Z����������i��ɑ����郁���o���X�g�̍ŏI�����o��
	// <Input>	cell: �s/��G�b�W��TD�I�u�W�F�N�g
	// <Output>	�Z����������i��ɑ����郁���o���X�g�̍ŏI�����o�ł����true
	// 			�i��i�Ɏ��������ꍇ�A���̎����̍ŏI�����o�ł����false�j
	function isEndPartCell(cell) {
	// <Input>cell: �s/��G�b�W��TD�I�u�W�F�N�g

		if (cell == null) { return false; }
		if (cell.tagName != "TD") { return false; }
		if ((!isCellInColHeader(cell)) && (!isCellInRowHeader(cell))) { return false; }

		var index = getSpreadIndexByTDObj(cell);
		var thisHieMemNum = parseInt(parent.display_area.getAxisMemNum( getCellPosition(cell), getHieIndex(cell) ));			var lowerComboNum = 1 * parseInt(parent.display_area.getLowerHieComboNum( cell, getCellPosition(cell) ));

		// ������i�ɑ�����p�[�g���̍ŏI�����o��
		if ( ( index % (thisHieMemNum * lowerComboNum) ) == ( (thisHieMemNum - 1) * lowerComboNum ) ) {
			return true;
		} else {
			return false;
		}
	}


	// TD�I�u�W�F�N�g���������ʒi����̊e����Key�z������߂�
	// <Input>	oTD:�^����ꂽ�ŏI�i��TD�I�u�W�F�N�g
	// <Output>	�e�i��Key�z���Ԃ��B�Y�������iIndex�ƑΉ�����B
	//        	�������A���݂��Ȃ������o�̓Y�����ɂ͋󕶎���Ή�������B
	function getKeyArray( oTD ) {

		var target = getCellPosition(oTD);
		var targetObjNum = getHeaderObjNum( target );

		var keyArray = new Array(3);
				keyArray[0] = "";
				keyArray[1] = "";
				keyArray[2] = "";
			if ( targetObjNum == 1 ) {
				keyArray[0] = oTD.key;

			} else if ( targetObjNum == 2 ) {
				keyArray[0] = getUpperCellObject( oTD, target ).key;
				keyArray[1] = oTD.key;
				keyArray[2] = "";
			} else if ( targetObjNum == 3 ) {

				keyArray[0] = getUpperCellObject ( getUpperCellObject( oTD, target ), target ).key;
				keyArray[1] = getUpperCellObject( oTD, target ).key;
				keyArray[2] = oTD.key;
			}

		return keyArray;
	}


	// �Z���̗�Index�����߂�
	// <Input>	headerCOLObj:�N���X�w�b�_,��w�b�_��COL�I�u�W�F�N�g
	//			�iID�����FCrossHeader_CGx�ACH_CGx�j
	// <Output>	����ڂ���\��Index
	function getCOLIndexByCOLObj( headerCOLObj ) {
		var strID     = headerCOLObj.id;
		var strGIndex = strID.lastIndexOf("G");
		var colIndex  = strID.substr(strGIndex + 1, strID.length - (strGIndex + 1));
		return colIndex;
	}

	// �Z���̗��Index�����߂�
	// Input	:�s�A��w�b�_�A�f�[�^�e�[�u����TD�I�u�W�F�N�g
	//			 (ID�����FRH_RxCy�ACH_RxCy�ADC_RxCy)
	// Output	:����ڂ���\��Index
	function getColIndexByTDObj( headerTDObj ) {
		var strID     = headerTDObj.id;
		var strCIndex = strID.lastIndexOf("C");
		var colIndex  = strID.substr(strCIndex + 1, strID.length - (strCIndex + 1));
		return colIndex;
	}

	// �Z���̍s�̃C���f�b�N�X�����߂�
	// Input	:�s�A��w�b�_�A�f�[�^�e�[�u����TR�I�u�W�F�N�g
	//           (ID�����FRH_Rx�ACH_Rx�ADC_Rx)
	// Output	:���s�ڂ���\��Index
	function getRowIndexByTRObj( headerTRObj ) {
		var strID     = headerTRObj.id;
		var strRIndex = strID.lastIndexOf("R");
		var rowIndex  = strID.substr(strRIndex + 1, strID.length - (strRIndex + 1));
		return rowIndex;
	}

	// �����������@�Z���ړ����\�b�h�@����������

	// �����̎������o�Z�������߂�
	// <Input>	oTD:TD �I�u�W�F�N�g
	// <Output>	�w�肳�ꂽTD�I�u�W�F�N�g�ł���킳��鎲�����o�̎������o������킷TD�I�u�W�F�N�g
	function getNextCell ( oTD ) {
		if ( oTD == null ) { return false; }
		if ( oTD.tagName != "TD" ) { return false; }

		if ( isCellInColHeader(oTD) ) {
			if ( oTD.nextSibling != null ) {
				if ( oTD.className != "adjustCell" ) {
					return oTD.nextSibling;
				} else {
					return null;
				}
			} else {
				return null;
			}
		} else if ( isCellInRowHeader(oTD) ) {
			var r,c;
				r = parseInt(getRowIndexByTRObj(oTD.parentNode)) + parseInt(getLowerHieComboNum( oTD, getCellPosition(oTD) ));
				c = parseInt(getColIndexByTDObj(oTD));

			var nextNode = oTD.parentNode.parentNode.all( "RH_R" + r + "C" + c );
			if ( nextNode != null ) {
				return nextNode;
			} else {
				return null;
			}
		}
	}

	// ����TD�I�u�W�F�N�g�����߂�
	// <Input>	node:TD �I�u�W�F�N�g
	// <Output>	�e�Ƃ��ď�ʒi�̓���̎��������o�����͈͓��ŁA���̎��������o��Ԃ��B
	function getNextCellWithinUpperCellRange ( node ) {
		if ( isCellInColHeader(node) ) {
			if ( node.parentNode.previousSibling == null ) { return null }

			if ( node.nextSibling != null ) {

				var upperHieNodeRange = parseInt(getLowerHieComboNum( node.parentNode.previousSibling.firstChild, getCellPosition(node)));
				var nodeRangeIndex = Math.floor( parseInt(getColIndexByTDObj( node )) / upperHieNodeRange );
				var nextNodeRangeIndex = Math.floor( parseInt(getColIndexByTDObj( node.nextSibling )) / upperHieNodeRange );

				if ( nodeRangeIndex == nextNodeRangeIndex ) {
					return node.nextSibling;
				} else {
					return null;
				}
			} else {
				return null;
			}
		} else if ( isCellInRowHeader( node ) ) {
			var r,c;
				r = parseInt(getRowIndexByTRObj(node.parentNode)) + parseInt(getLowerHieComboNum( node, getCellPosition(node) ));
				c = parseInt(getColIndexByTDObj(node));

			var upperHieNodeRange = parseInt(getLowerHieComboNum( node.parentNode.parentNode.firstChild.all("RH_R0" + "C" + (c-1)), getCellPosition(node)));
			var nodeRangeIndex = Math.floor( parseInt(getRowIndexByTRObj( node.parentNode )) / upperHieNodeRange );
			var nextNodeRangeIndex = Math.floor( (parseInt(getRowIndexByTRObj( node.parentNode ))+1) / upperHieNodeRange );

			if ( nodeRangeIndex == nextNodeRangeIndex ) {
				return node.parentNode.parentNode.all( "RH_R" + r + "C" + c );
			} else {
				return;
			}
		}
	}

	// �Z�����������ʒi�̃Z�������߂�
	// Input) 
	//	headerCellObject:TD�v�f
	//	targetString:COL or ROW
	// Output)
	//	cell���������ʒi�̗v�f�iTD�v�f�j
	function getUpperCellObject( headerCellObject, targetString ) {

		var cell   = headerCellObject;
		var target = targetString;

		var targetObjNum = getHeaderObjNum( target );
		var spreadIndex;	// �Z���̃C���f�b�N�X�i�s�������͎��ɑ΂��Ĉ�ӁB0start�j
		var hieIndex;		// ���͂��ꂽ�Z�������i�ڂ�(0start)
			if ( target == "COL" ) {
				spreadIndex = getColIndexByTDObj(cell);
				hieIndex    = getRowIndexByTRObj(cell.parentElement);
			} else if ( target == "ROW" ) {
				spreadIndex = getRowIndexByTRObj(cell.parentElement);
				hieIndex    = getColIndexByTDObj(cell);
			}

		headerMemNum1 = getAxisMemNum( target, 1 );
		headerMemNum2 = getAxisMemNum( target, 2 );

		var comboNum;
		var upperCellSpreadIndex;

		if ( targetObjNum == 1 ) {
		// �s/�񂪂P�i�̏ꍇ
			return;
		} else if ( targetObjNum == 2 ) {
		// �s/�񂪂Q�i�̏ꍇ
			if ( hieIndex == 0 ) {
				return;
			} else if ( hieIndex == 1 ) {
				comboNum = headerMemNum1;
				upperCellSpreadIndex = spreadIndex - ( spreadIndex % comboNum );
			}
		} else if ( targetObjNum == 3 ) {
		// �s/�񂪂R�i�̏ꍇ
			if ( hieIndex == 0 ) {
				return;
			} else if ( hieIndex == 1 ) {
				comboNum = headerMemNum1 * headerMemNum2;
				upperCellSpreadIndex = spreadIndex - ( spreadIndex % comboNum );
			} else if ( hieIndex == 2 ) {
				comboNum = headerMemNum2;
				upperCellSpreadIndex = spreadIndex - ( spreadIndex % comboNum );
			}
		}

		// �I�u�W�F�N�g����
		var targetObj;
		if ( target == "COL" ) {
			targetObj = colHeader.all("CH_R" + (hieIndex-1) + "C" + upperCellSpreadIndex );
		} else if ( target == "ROW" ) {
			targetObj = rowHeader.all("RH_R" + upperCellSpreadIndex + "C" + (hieIndex-1));
		}

		return targetObj;

	}

	// �w�肳�ꂽ�����o�ɑ����鎟�i�̎������o�̂����A�擪�����o�����߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	// <Output>	�^����ꂽ�������o�iTD�I�u�W�F�N�g�j�ɑ�����
	//			���i�̃����o�̂����擪�����o(TD�I�u�W�F�N�g)��Ԃ�
	function getUnderHieFirstNode( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// ���i�ȍ~�Ƀ����o�Ȃ��ꍇnull��Ԃ��B
		if ( getNextAxisMemberNumber( getHieIndex(oTD), getCellPosition(oTD) ) == 0 ) { return null; }

		if ( isCellInColHeader( oTD ) ) {
			if ( oTD.parentNode.nextSibling == null ) { return null; }

			var r,c;
				r = oTD.parentNode.rowIndex+1;
				c = parseInt(getColIndexByTDObj( oTD ));

			return oTD.parentNode.nextSibling.all( "CH_R" + r + "C" + c );

		} else if ( isCellInRowHeader( oTD ) ) {
			if ( oTD.nextSibling == null ) { return null; }

			var r,c;
				r = oTD.parentNode.rowIndex;
				c = parseInt(getColIndexByTDObj(oTD))+1;
			return oTD.parentNode.all( "RH_R" + r + "C" + c );
		} else {
			return null;
		}
	}


	// �w�肳�ꂽ�����o�ɑ����鎟�i�̃����o���X�g�����߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	// <Output>	���i�̃����o���X�g
	function getUnderHieNodes( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// ���i�ȍ~�Ɏ����Ȃ��ꍇnull��Ԃ��B
		if ( getNextAxisMemberNumber( getHieIndex(oTD), getCellPosition(oTD) ) == 0 ) { return null; }

		var underNodeArray = new Array();
		var underNode = getUnderHieFirstNode( oTD );
		for ( i = 0; i < getNextAxisMemberNumber( getHieIndex(oTD), getCellPosition(oTD) ); i++ ) {
			underNodeArray[i] = underNode;
			underNode = getNextCell(underNode);
		}

		return underNodeArray;
	}

	// �w�肳�ꂽ�����o�ɑ����鎟���i�̃����o���X�g�����߂�
	// <Input>	oTD:�s�w�b�_,��w�b�_��TD�I�u�W�F�N�g
	// <Output>	�����i�̃����o���X�g
	function getUnder2HieNodes( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// �w�肳�ꂽTD�I�u�W�F�N�g���A3�i�\���̃w�b�_��0�i�ڂłȂ��ꍇ�Anull��Ԃ�
		if ( getHeaderObjNum( getCellPosition(oTD) ) != 3 ) { return null; }
		if ( getHieIndex(oTD) != 0 ) { return null; }

		var under2NodeArray = new Array();
		var underNodes = getUnderHieNodes(oTD);
		for ( var i = 0; i < underNodes.length; i++ ) {
			var underNode = underNodes[i];
			var under2NodeArrayList = getUnderHieNodes(underNode);
			var under2Num = under2NodeArrayList.length;
			for ( var j = 0; j < under2Num; j++ ) {
				under2NodeArray[(i*under2Num) + j] = under2NodeArrayList[j];
			}
		}

		return under2NodeArray;
	}

	// �����������@�Z�����ϊ����\�b�h�iXML�j�@����������

	// XML�C���f�b�N�X���UName�����߂�
	// <Input>	axisID:��ID
	// <Input>	xmlIndex:�������o��XML��ID(���|�[�g���XML�́uMember�v�v�f�́uid�v�����̒l)
	// <Output>	�w�肳�ꂽ�������o��UName(���|�[�g���XML��Member�^�O�̗v�f)
	//			(�f�B�����V�����Fkey�A���W���[�F1start�̏���Index)
	function changeXMLIndexToUName (axisID, xmlIndex) {

		var UName = axesXMLData.axesXMLData.selectSingleNode("/root/Axes/Members[@id=" + axisID  + "]//Member[@id=" + xmlIndex + "]").text;

		return UName;
	}

	// UName���XML�C���f�b�N�X�����߂�
	// <Input>	axisID:��ID
	// <Input>	UName:�������o��XML��ID(���|�[�g���XML�́uMember�v�v�f�́uUName�v�����̒l)
	//				  (�f�B�����V�����Fkey�A���W���[�F1start�̏���Index)
	// <Output>	�w�肳�ꂽ�������o��XML�C���f�b�N�X
	function changeUNameToXMLIndex (axisID, UName) {

		var xmlIndex = parseInt(axesXMLData.axesXMLData.selectSingleNode("/root/Axes/Members[@id = " + axisID  + "]//Member[./UName=" + xmlIndex + "]").text);

		return xmlIndex;
	}

	// SpreadIndex��XMLIndex�֕ϊ�
	// <Input>	spreadIndex:�h����������s�Ȃ�ꂽ�����o�̍s/��C���f�b�N�X
	// <Input>	target:COL��ROW��
	// <Input>	hieIndex:�i�C���f�b�N�X
	// <Output>	�������o���ŏ����ɐU��ꂽ�C���f�b�N�X(���|�[�g���XML�́uMember�v�v�f�́uid�v�����̒l)
	function changeSpreadIndexToXMLIndex ( spreadIndex, target, hieIndex ) {

		var headerMemNum1  = getNextAxisMemberNumber( 0, target );		// 1�i�ڂ̎��̑������o��
		var headerMemNum2  = getNextAxisMemberNumber( 1, target );		// 2�i�ڂ̎��̑������o��
		var lowerComboNum = getLowerHieComboNumByIndex(target, hieIndex);	// �ȉ��̒i�̃����o�̑g�ݍ��킹��

		var xmlIndex = -1;

		// �s/�񂪂P�̎���/���W���[�����ꍇ
		if ( getHeaderObjNum(target) == 1 ) {
			xmlIndex = spreadIndex;

		// �s/�񂪂Q�̎���/���W���[�����ꍇ
		} else if ( getHeaderObjNum(target) == 2 ) {
			// 0�i�ڂ̃I�u�W�F�N�g�̏ꍇ
			if ( hieIndex == 0) {
				xmlIndex = Math.round((spreadIndex / lowerComboNum) - 0.5);

			// 1�i�ڂ̃I�u�W�F�N�g�̏ꍇ
			} else if ( hieIndex == 1 ) {
				xmlIndex = spreadIndex % headerMemNum1;
			}

		// �s/�񂪂R�i�̏ꍇ
		} else if ( getHeaderObjNum(target) == 3 ) {
			// 0�i�ڂ̃I�u�W�F�N�g�̏ꍇ
			if ( hieIndex == 0) {
				xmlIndex = Math.round((spreadIndex / lowerComboNum) - 0.5);
			// 1�i�ڂ̃I�u�W�F�N�g�̏ꍇ
			} else if ( hieIndex == 1 ) {
				xmlIndex = ( spreadIndex / lowerComboNum ) % headerMemNum1;
			// 2�i�ڂ̃I�u�W�F�N�g�̏ꍇ
			} else if ( hieIndex == 2 ) {
				xmlIndex = spreadIndex % headerMemNum2;
			}
		}

		return parseInt(xmlIndex);
	}


	// XML�C���f�b�N�X��Spread�C���f�b�N�X�֕ϊ�
	// <Input>	axisIDList:��܂��͍s�̑S���̎�ID�̔z��
	// <Input>	xmlIndexList:��܂��͍s�̑S���̎������o��XML��ID(���|�[�g���XML�́uMember�v�v�f�́uid�v�����̒l)�̔z��
	//			��axisIDList��xmlIndexList�͓Y���őΉ��Â��B�z��͒iIndex�̏����Ƃ���B
	// <Output>	�^����ꂽ���̑g�ݍ��킹���s/��ɔz�u����Ă���ꍇ�A
	//			���̑g�ݍ��킹�ň�ӂɂȂ�Spread�C���f�b�N�X��Ԃ�
	function changeXMLIndexesToSpreadIndex ( axisIDArray, xmlIndexArray ) {
		if ( ( axisIDList == null ) || ( xmlIndexList == null ) ) { return -1; }
		if ( axisIDList.length != xmlIndexList.length ) { return -1; }
		if ( axisIDArray.length != xmlIndexArray.length ) { return -1; }

		var targetObjNum  = getHeaderObjNum( target );	// �w�b�_�̎���
		if ( axisIDArray.length != targetObjNum ) { return -1; }

		var spreadIndex = -1;			// Spread��ł̍s/��C���f�b�N�X

		var colAxisListString  = getAxisIdListInEdge( "COL", axesXMLData );
		var rowAxisListString  = getAxisIdListInEdge( "ROW", axesXMLData );

		var target = "";
			if ( hasSame2Axes(axisIDArray, colAxisListString.split(","), null) ) {
				target = "COL";
			} else if ( hasSame2Axes(axisIDArray, rowAxisListString.split(","), null) ) {
				target = "ROW";
			}

		var spreadIndex = 0;
		for ( var i = 0; i < axisIDArray.length; i++ ) {
			var axisID = axisIDArray[i];
			var xmlIndex = xmlIndexArray[i];
			var lowerHieComboNum = lowerComboNum = getLowerHieComboNumByIndex(target, i);

			spreadIndex += xmlIndex * lowerHieComboNum;
		}

		return spreadIndex;
	}


	// XML�C���f�b�N�X��Spread�C���f�b�N�X�֕ϊ�
	// <Input>	xmlIndex:�������o��XML�C���f�b�N�X(���|�[�g���XML�́uMember�v�v�f�́uid�v�����̒l)
	// <Input>	target:COL��ROW��
	// <Input>	startSpreadIndex:���߂鎲�����o�Ɠ�����i�����o�ɑ����郁���o�W���̐擪�����o��Spread�C���f�b�N�X
	// <Input>	hieIndex:�i�C���f�b�N�X
	// <Input>	lowerHieComboNum:���i�ȍ~�̃����o�̑g�ݍ��킹��
	// <Output>	xmlIndex�ŗ^����ꂽ�������o�́ASpread�̍s/��ň�ӂɂȂ�C���f�b�N�X
	function changeNodeIDToSpreadID ( xmlIndex, target, startSpreadIndex, hieIndex, lowerHieComboNum ){

		var spreadIndex;			// Spread��ł̍s/��C���f�b�N�X

		var drilledNodeSpreadIndex;	// �h����������s��ꂽ�v�f�̃C���f�b�N�X
			var headerMemNum1;		// �h�����̍s��ꂽ�w�b�_��1�s/��ڂ̎��̃����o��
			var headerMemNum2;		// �h�����̍s��ꂽ�w�b�_��2�s/��ڂ̎��̃����o��
			var targetObjNum;		// �h�����̍s��ꂽ�w�b�_�̎���

			headerMemNum1 = getAxisMemNum( target, 1 );
			headerMemNum2 = getAxisMemNum( target, 2 );
			targetObjNum  = getHeaderObjNum( target );

		if ( targetObjNum == 1) {	// �w�b�_�Ɏ����
			spreadIndex = xmlIndex;
		} else if ( targetObjNum == 2 ) {	// �w�b�_�Ɏ����
			if ( hieIndex == 0) {	// 0�i��
				spreadIndex = xmlIndex * lowerHieComboNum;
			} else if ( hieIndex == 1 ) {	// 1�i��
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % headerMemNum1 ) ) + xmlIndex;
			}

		} else if ( targetObjNum == 3 ) {	// �w�b�_�Ɏ��O��
			if ( hieIndex == 0) {	// 0�i��
				spreadIndex = xmlIndex * lowerHieComboNum;
			} else if ( hieIndex == 1 ) {	// 1�i��
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % ( headerMemNum1 * headerMemNum2 ) ) ) + ( xmlIndex *  lowerHieComboNum);
			} else if ( hieIndex == 2 ) {	// 2�i��
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % headerMemNum2 ) ) + xmlIndex;
			}
		}

		return spreadIndex;
	}


	// �����������@�Z�����ϊ����\�b�h�i�^�O�\���j�@����������

	// �T�v�F    �Z���I�u�W�F�N�g��߂��B
	//           �����ŗ^����ꂽ�I�u�W�F�N�g���A�N���X�w�b�_�[���̎��^�C�g����
	//           DIV�I�u�W�F�N�g�ł������ꍇ�A���̃Z���I�u�W�F�N�g�ɕύX����B
	// ����:     �I�u�W�F�N�g
	// �߂�l�F  �Z���I�u�W�F�N�g
	function getCellObjFromAxisImage(element) {

		var ele = element;
			if (ele == null) { return null; }

			// �N���X�w�b�_���̃{�^��(DIV)�̏ꍇ�A�N���X�w�b�_��\���Z����ele�ɕύX����B
			if (ele.tagName == "DIV") {
				ele = ele.parentNode.parentNode.parentNode;
			}

		return ele;

	}


