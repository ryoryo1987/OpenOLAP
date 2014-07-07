<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="openolap.viewer.User"
%>
<%
	User user = (User) session.getAttribute("user");
	String cellColorTableFile = user.getCellColorTableFile();
%>
	<HTML>
		<HEAD>
			<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
			<title><%=(String)session.getValue("aplName")%></title>
			<script type="text/javascript" src="./css/<%= cellColorTableFile %>"></script>
			<script type="text/javascript" src="./spread/js/spread.js"></script>
			<script type="text/javascript" src="./spread/js/spreadFunc.js"></script>
		</HEAD>
	
		<BODY onLoad="initialize();" style="background-color:#EFECE7;margin:0;padding:0;">
			<FORM name='form_main' method="post">
			</FORM>
		</BODY>
	
	</HTML>

	<script language="JavaScript">

	// �f�[�^�\��

	// �����|�[�g�f�[�^XML���擾����f�[�^��
	// colIDArray: ��ɔz�u���ꂽ��ID���X�g�@��F1,3�i�j
	// rowIDArray: �s�ɔz�u���ꂽ��ID���X�g�@��F2	�i���|�[�g�f�[�^XML���擾�j

	// ���F�Â��f�[�^XML���擾��
	// axisIdArray�F�Z���I�u�W�F�N�g�̈ʒu���鎲��ID���X�g ��F1,2,3
	// memberKeyArray:�Z���I�u�W�F�N�g�̈ʒu���鎲�����o�[��Key���X�g�B
	// 				  axisIdArray�̊i�[����e���̃����o�[�B	��F0,0,1
	//				  ���Ƃ̑Ή��t���́A�����Y����axisIdArray�̗v�f�ōs���B
	// 				 �i���|�[�g�f�[�^XML�ł́uMember�v�v�f�̎��uUName�v�v�f�̒l�j

	// �����|�[�g�f�[�^XML�A�F�Â��f�[�^XML���擾��
	// xmlIndexArray:memberKeyArray��index�ɕϊ��������́B	��F0,0,1
	// 				 �i���|�[�g�f�[�^XML�ł́uMember�v�v�f�́uid�v�����̒l�j
	//				  ���Ƃ̑Ή��t���́A�����Y����axisIdArray�̗v�f�ōs���B

	var axesXMLData = parent.parent.info_area.axesXMLData;	// ���|�[�g���
	var colorXMLData = null;	// �F���

	// *********************************************************
	//  �������֐�
	// *********************************************************

	// �F�ݒ�����s
	function initialize() {

		// �F���XML�̃p�X
		var loadXMLPath = "Controller?action=getColorInfo";

		// �F���iXML�j�̃��[�h
		colorXMLData = new ActiveXObject("MSXML2.DOMDocument");
		colorXMLData.async = false;
		colorXMLData.setProperty("SelectionLanguage", "XPath");
		var colorXMLResult = colorXMLData.load(loadXMLPath);


		// XML�����̃��[�h�ɐ���
		if (colorXMLResult) {

			// �w�b�_�[���̐F�Â�
			var hdrColors = colorXMLData.selectNodes("/ColorInfo/HeaderColor/Color");
			setColor(hdrColors, "header");
	
			// Spread���̐F�Â�
			var spreadColors = colorXMLData.selectNodes("/ColorInfo/SpreadColor/Color");
			setColor(spreadColors, "spread");
	
			// Spread���ɒl��}��
			parent.parent.display_area.document.SpreadForm.action = "Controller?action=loadDataAct";
			parent.parent.display_area.document.SpreadForm.target = "loadingStatus";
			parent.parent.display_area.document.SpreadForm.submit();

		// XML�����̃��[�h�Ɏ��s
		} else {
		
			// �G���[���b�Z�[�W��\����A�G���[��ʂ�\���B
			showMessage("13", loadXMLPath);

			if(top.right_frm!=null) {
				top.right_frm.location.href="spread/error.jsp";
			} else {
				top.location.href="spread/error.jsp";
			}
		
		}

	}

	// *********************************************************
	//  �F�ݒ�֐�
	// *********************************************************

	function setColor(oColors, type) {
		// oColors: �F�Â��f�[�^XML��Color�m�[�h�̔z��
		// type: header, spread

		// oColors �̃��[�v start
		for(var i = 0; i < oColors.length; i++ ) {

			var oAColor = oColors[i];

			var axes= oAColor.selectNodes("Coordinates/Axis");
			var axisIdArray = new Array();
			var memberKeyArray = new Array();
			for ( var j = 0; j < axes.length; j++ ) {
				var axis = axes[j];
				axisIdArray[j] = axis.attributes[0].value;
				memberKeyArray[j] = axis.firstChild.text;
			}

			var colorName = oAColor.selectSingleNode("HTMLColor").text;


			// �F�Â�XML���擾�����Z�������A���̃Z���I�u�W�F�N�g�����߂�
			// �Ή�����Z���I�u�W�F�N�g�����݂��Ȃ��ꍇ�́Anull��Ԃ�
			//   function: TD�I�u�W�F�N�g or null
			var oTD = getCellByAxisIDAndMemKey(axisIdArray, memberKeyArray, type);

			// �F�Â�
			if ( oTD != null ) {

				// �F�Â�
				var target = getCellPosition(oTD);
				var prefix = null;
				if (target == "DATA") {
					prefix = "dt";
				} else {
					prefix = "hdr";
				}
				oTD.colorName = colorName;
				oTD.style.backgroundColor = associationColorArray[prefix + colorName];
				if (target == "DATA") {
					oTD.orgBColor = associationColorArray[prefix + colorName];
				}
				parent.parent.display_area.coloredCellList.add( oTD.id, oTD );	// �F�Â��Z�����X�g���X�V
			} else {
				// �F�Â��s�\�Z�����X�g���X�V

				var addString = "";
				for ( var j = 0; j < axisIdArray.length; j++ ) {
					if ( j > 0 ) {
						addString += ":";
					}
					addString += axisIdArray[j] + ".";
					addString += memberKeyArray[j];
				}
				addString += ";" + colorName;

				if ( type == "header" ) {
					if ( parent.parent.display_area.disableHdrColorString != "" ) {
						parent.parent.display_area.disableHdrColorString += ",";
					}
					parent.parent.display_area.disableHdrColorString += addString;
				} else if ( type == "spread") {
					if ( parent.parent.display_area.disableDtColorString != "" ) {
						parent.parent.display_area.disableDtColorString += ",";
					}
					parent.parent.display_area.disableDtColorString  += addString;
				}
			}
		}

		// �G�b�W�̍ŉ��i�ȊO�̒i�ɐF����ݒ�
		if ( type == "header" ) {
			setUpperHieColor("COL");
			setUpperHieColor("ROW");
		}

	}

	// �G�b�W�̍ŉ��i�ȊO�̒i�ɐF����ݒ�
	function setUpperHieColor(target) {
	// <input>  target:"COL" or "ROW"
	// <output> void

		var colHie0Cells = null;	// ��̒i�C���f�b�N�X0�̐F�Â��ΏۃZ�����X�g
		var rowHie0Cells = null;	// �s�̒i�C���f�b�N�X0�̐F�Â��ΏۃZ�����X�g
		var colHie1Cells = null;	// ��̒i�C���f�b�N�X1�̐F�Â��ΏۃZ�����X�g
		var rowHie1Cells = null;	// �s�̒i�C���f�b�N�X1�̐F�Â��ΏۃZ�����X�g

		// �i�����P�̏ꍇ�Areturn
		if ( parent.parent.display_area.getHeaderObjNum(target) == 1 ) { return; }

		// �i�����Q�ȏ�̏ꍇ
		if ( parent.parent.display_area.getHeaderObjNum(target) >= 2 ) {

			// �F�Â��ς݂̃Z�����X�g��spread index���Ɏ擾����
			var edgeColoredCellArray = sortCellsByIndex(parent.parent.display_area.coloredCellList, target);

//var str = "";
//for ( var i = 0; i < edgeColoredCellArray.length; i++ ) {
//	str += edgeColoredCellArray[i].id + "\n";
//}
//alert(str);

			// �F�Â����s
			var edgeHie1Cells = setColorToUpperCell(target, edgeColoredCellArray);

			// �i�����R�̏ꍇ
			if ( parent.parent.display_area.getHeaderObjNum(target) == 3 ) {
				// �F�Â����s
				if (edgeHie1Cells != null) {
					if (edgeHie1Cells.length != 0) {
						var edgeHie0Cells = setColorToUpperCell(target, edgeHie1Cells);
					}
				}
			}
		}
	}

	// �^����ꂽ�����K�w�̃Z�����X�g�ɑ΂��A���̕����W����������i�Z���������A����
	// �����F�ł���ꍇ�A���̏�i�Z���̐F�Â����s���A���̃��X�g��Ԃ�
	function setColorToUpperCell(target, cellArray) {
	// <Input>  target:COL or ROW
	//			cellArray:spread index�ŏ����Ƀ\�[�g���ꂽ�Z�����X�g
	// <Output> �w�b�_�[�Z����TD�I�u�W�F�N�g�̔z��

		if ( cellArray == null ) { return null; }

		var upperCellArray = new Array();	// ��i�Z���̏W��
		var startColor = null;	// �����i�ɑ�����̈���ŁA�擪�Z�����F�Â����ꂽ�Z���̐F
								// �F�Â�����Ă��Ȃ��Z��������A�قȂ�F�Â�������Ă����ꍇ��null
		var beforeIndex = -1;	// ��O�Ɏ��s�����F�Â��Z���̃C���f�b�N�X
								// ��O�Ɏ��s�����Z���ƌ��ݎ��s���̃Z���̊ԂɃZ�����������Ƃ��m�F����
		var beforeCell = null;

		var upperCellArrayIndex = 0;

		for ( var i = 0; i < cellArray.length; i++ ) {
			var cell = cellArray[i];

			// �����i�ɑ�����̈���ŘA�������Z���������F�ł��邩�ǂ������m�F
			if ( parent.parent.display_area.isStartPartCell(cell) ) {	// �����i�ɑ�����̈���̊J�n�Z��

				startColor = cell.colorName;
				beforeIndex = getSpreadIndexByTDObj(cell);
				beforeCell = cell;
			} else { // �����i�ɑ�����̈���̊J�n�Z���ł͂Ȃ�
				if ( startColor == null ) { // �̈���̊J�n�Z�����珇�Ɋm�F���ł͂Ȃ�
					continue;
				} else { // �̈���ŊJ�n�Z�����珇�Ɋm�F��

					var lowerComboNum = parent.parent.display_area.getLowerHieComboNumByIndex(target, getHieIndex(cell));

					if ( (beforeIndex + (1*lowerComboNum)) != getSpreadIndexByTDObj(cell) ) {	// �O����s�Z���̒���łȂ�
						startColor = null;
						beforeIndex = -1;
						beforeCell = null;
						continue;
					} else {	// �O����s�Z���̒���(���A��)
						if ( startColor != cell.colorName ) { 	// ���s���̃Z���F���Ⴄ�F
							startColor = null;
							beforeIndex = -1;
							beforeCell = null;
							continue;
						} else {	// ���s���̃Z���F�������F
							beforeIndex = getSpreadIndexByTDObj(cell);
							beforeCell = cell;
						}
					}
				}
			}

			//���s���̃Z���������i�ɑ�����̈���̍ŏI�Z���̏ꍇ�A��i�̃I�u�W�F�N�g���擾���A�F�Â�
			if ( ( startColor != null ) && (parent.parent.display_area.isEndPartCell(cell)) ) {
				var upperCell = parent.parent.display_area.getUpperCellObject(cell, target);

				// �F�Â�
				upperCell.colorName = startColor;
				upperCell.style.backgroundColor = associationColorArray["hdr" + startColor];

				// �F�Â��Z�����X�g���X�V
				parent.parent.display_area.coloredCellList.add( upperCell.id, upperCell );

				upperCellArray[upperCellArrayIndex] = upperCell;	// �F�Â������Z����z��Ɋi�[
				upperCellArrayIndex++;

				// ������
				startColor = null;
				beforeIndex = -1;
			}
		}

		return upperCellArray;
	}




	// �Z�����X�g���w�肳�ꂽ�G�b�W�ɂ��i���݁Aspread index���Ƀ\�[�g����
	function sortCellsByIndex(cellObjDic, target) {
	// <input>  cellObjDic:�G�b�W�Z��(TD)��id�ƃI�u�W�F�N�g���i�[����Dictionary�I�u�W�F�N�g
	//			target:"COL" or "ROW" or null
	//			       ��null�̏ꍇ�A�G�b�W�ɂ��i���݂��s��Ȃ�
	// <output> �Z���I�u�W�F�N�g���i�荞�݁A�\�[�g�����z��

		if (cellObjDic == null) { return null; }
		if (cellObjDic.Count == 0) { return null; }

		var edgeCellArray = new Array();

		var cellObjArray = (new VBArray(cellObjDic.Items())).toArray();
		var edgeCellIndexIdDic = new ActiveXObject("Scripting.Dictionary");

		for ( var i = 0; i < cellObjArray.length; i++ ) {
			var oCell = cellObjArray[i];

			if ((!isCellInColHeader(oCell)) && (!isCellInRowHeader(oCell))) { return null; }

			if ( target != null ) {	// target���w�肳��Ă����ꍇ�A�i�荞��
				if ( getCellPosition(oCell) == target ) {
					edgeCellIndexIdDic.add(parseInt(getSpreadIndexByTDObj(oCell)), oCell.id);
				}
			} else {
				edgeCellIndexIdDic.add(parseInt(getSpreadIndexByTDObj(oCell)), oCell.id);
			}

		}

		var edgeIndexArray = (new VBArray(edgeCellIndexIdDic.Keys())).toArray();
		edgeIndexArray.sort(sortAsNumberASC);	// �z��𐔒l�̏����Ń\�[�g


		for ( var i = 0; i < edgeIndexArray.length; i++ ) {
			var id = edgeCellIndexIdDic.Item(edgeIndexArray[i]);	// id
			edgeCellArray[i] = cellObjDic.Item(id);	// node�̔z��𐶐�
		}

		return edgeCellArray;
	}


	// *********************************************************
	//  �����f�[�^�\���{���֐�
	// *********************************************************

	// ��ID�ƁA���̎������o��Key(UName)�ɑΉ�����A�s/��G�b�W�Z���̃I�u�W�F�N�g��Ԃ�
	// �i�w�b�_�[���̃I�u�W�F�N�g��v������A���w�b�_�[�������i����ꍇ�͍ŉ��w��Ԃ��j
	// <Input>  axisIdArray:����ID
	//		    memberKeyArray:���̃����o��Key(UName)
	//		    type: "header" or "spread"
	// <Output> oTD: �擾����TD�I�u�W�F�N�g
	function getCellByAxisIDAndMemKey(axisIdArray, memberKeyArray, type) {

		// �s�E��̎�ID���X�g
		var colIDArray = new Array();
		var rowIDArray = new Array();
			var colIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/COL/HierarchyID");
			var rowIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/ROW/HierarchyID");
			for ( var i = 0; i < colIDs.length; i++ ) {
				colIDArray[i] = colIDs[i].text;
			}
			for ( var i = 0; i < rowIDs.length; i++ ) {
				rowIDArray[i] = rowIDs[i].text;
			}

		// �����o�[Key(UName)��XML�C���f�b�N�X(id)�ɕϊ�
		var xmlIndexArray = new Array();
			for ( var i = 0; i < axisIdArray.length; i++ ) {
				var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id = " + axisIdArray[i]  + "]//Member[./UName=" + memberKeyArray[i] + "]");
				if ( node == null ) {	// �F�Â���v�����ꂽ�m�[�h���A���|�[�g����ێ�����XML���ɑ��݂��Ȃ�
										// �i�Z���N�^�g�p���j
					return null;
				}
				xmlIndexArray[i] = node.attributes[0].value;
			}

		var oTD = null;
		if ( type == "header" ) {
			// �F�\���̑ΏۃG�b�W�����߂�
			var target = null;
			var idArray = null;
			if( hasSame2Axes(axisIdArray, colIDArray, null) ) {
				target = "COL";
				idArray = colIDArray;
			} else if( hasSame2Axes(axisIdArray, rowIDArray, null) ) {
				target = "ROW";
				idArray = rowIDArray;
			} else {	// �F�\���ΏۃG�b�W������
				return null;
			}

			// �F�Â��ΏۂƂȂ�Z���I�u�W�F�N�g�����߂�
			var targetHdr = "";
			var colSpreadIndex = null;
			var rowSpreadIndex = null;
				if ( target == "COL" ) {
					targetHdr = "CH";
					colSpreadIndex = getSpreadIndex(target, colIDArray, axisIdArray, xmlIndexArray);
					rowSpreadIndex = colIDArray.length-1;	// ��̍ŏI�i��hieIndex
				} else if ( target == "ROW" ) {
					targetHdr = "RH";
					colSpreadIndex = rowIDArray.length-1;	// �s�̍ŏI�i��hieIndex
					rowSpreadIndex = getSpreadIndex(target, rowIDArray, axisIdArray, xmlIndexArray);
				}
			oTD = parent.parent.display_area.document.getElementById(targetHdr + "_R" + rowSpreadIndex + "C" + colSpreadIndex);
		} else if ( type == "spread" ) {

			// Col�G�b�W�ARow�G�b�W�̑g�ݍ��킹���m�F����
			if( !hasSame2Axes(axisIdArray, colIDArray, rowIDArray ) ) {
				return null;
			}

			// Col�ARow ��SpreadIndex�����߂�
			var colSpreadIndex = getSpreadIndex("COL", colIDArray, axisIdArray, xmlIndexArray);
			var rowSpreadIndex = getSpreadIndex("ROW", rowIDArray, axisIdArray, xmlIndexArray);

			// �Z�������߂�
			oTD = parent.parent.display_area.document.getElementById("DC_R" + rowSpreadIndex +"C" + colSpreadIndex );
			
		}

		return oTD;
	}

	// �G�b�W�̎���ID���X�g(edgeIDs)�����ɁA���̃G�b�W��SpreadIndex�����߂�
	function getSpreadIndex(target, edgeIDs, axisIdArray, xmlIndexArray) {
		var spreadIndex = 0;
		for ( var i = 0; i < edgeIDs.length; i++ ) {
			var edgeID = edgeIDs[i];
			var xmlIndex = getXMLIndex(edgeID, axisIdArray, xmlIndexArray);
			var lowerHieComboNum = parent.parent.display_area.getLowerHieComboNumByIndex(target, i);
			spreadIndex += xmlIndex * lowerHieComboNum;
		}
		return spreadIndex;
	}

	// edgeID�ɑΉ������AXMLIndex���擾���Ԃ�
	function getXMLIndex(edgeID, axisIdArray, xmlIndexArray) {
		var arrayIndex;
		for ( var i = 0; i < axisIdArray.length; i++ ) {
			if ( axisIdArray[i] == edgeID) {
				arrayIndex = i;
				break;
			}
		}
		return xmlIndexArray[arrayIndex];
	}

	// *********************************************************
	//  ���[�e�B���e�B�֐�
	// *********************************************************

	// Array�I�u�W�F�N�g�̐��l���Ń\�[�g���邽�߂̃��\�b�h
	function sortAsNumberASC(a, b) {
		return a-b;
	}


</script>
