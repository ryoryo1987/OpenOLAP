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

	function getNextAxisMemberNumber( hieIndex, target ) {
		if ( hieIndex == null ) { return null; }
		if ( target == null ) { return null; }
		if ( hieIndex > 2 || hieIndex < 0 ) {	// インデックスの範囲チェック
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


	function getLowerHieComboNum( cell, target ) {

		var hieIndex = getHieIndex(cell);
		if ( hieIndex == -1 ) {
			return -1;
		}

		var retComboNum = getLowerHieComboNumByIndex(target, hieIndex);
		return retComboNum;
	}

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
			if ( nextAxisMemNum != 0 ) {	// 最下段ではgetNextAxisMemberNumberが0を返すため
				retComboNum = retComboNum * nextAxisMemNum;
			}
		}
		return retComboNum;
	}

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

	function isCellInColHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "COL") {
			return true;
		}
		return false;
	}

	function isCellInRowHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "ROW") {
			return true;
		}
		return false;
	}

	function isCellInDataTable( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "DATA") {
			return true;
		}
		return false;
	}

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

	function getCOLIndexByCOLObj( headerCOLObj ) {
		var strID     = headerCOLObj.id;
		var strGIndex = strID.lastIndexOf("G");
		var colIndex  = strID.substr(strGIndex + 1, strID.length - (strGIndex + 1));
		return colIndex;
	}

	function getColIndexByTDObj( headerTDObj ) {
		var strID     = headerTDObj.id;
		var strCIndex = strID.lastIndexOf("C");
		var colIndex  = strID.substr(strCIndex + 1, strID.length - (strCIndex + 1));
		return colIndex;
	}

	function getRowIndexByTRObj( headerTRObj ) {
		var strID     = headerTRObj.id;
		var strRIndex = strID.lastIndexOf("R");
		var rowIndex  = strID.substr(strRIndex + 1, strID.length - (strRIndex + 1));
		return rowIndex;
	}

	function getUpperCellObject( headerCellObject, targetString ) {

		var cell   = headerCellObject;
		var target = targetString;

		var targetObjNum = getHeaderObjNum( target );
		var spreadIndex;	// セルのインデックス（行もしくは軸に対して一意。0start）
		var hieIndex;		// 入力されたセルが何段目か(0start)
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
		// 行/列が１段の場合
			return;
		} else if ( targetObjNum == 2 ) {
		// 行/列が２段の場合
			if ( hieIndex == 0 ) {
				return;
			} else if ( hieIndex == 1 ) {
				comboNum = headerMemNum1;
				upperCellSpreadIndex = spreadIndex - ( spreadIndex % comboNum );
			}
		} else if ( targetObjNum == 3 ) {
		// 行/列が３段の場合
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

		// オブジェクト生成
		var targetObj;
		if ( target == "COL" ) {
			targetObj = colHeader.all("CH_R" + (hieIndex-1) + "C" + upperCellSpreadIndex );
		} else if ( target == "ROW" ) {
			targetObj = rowHeader.all("RH_R" + upperCellSpreadIndex + "C" + (hieIndex-1));
		}

		return targetObj;

	}

