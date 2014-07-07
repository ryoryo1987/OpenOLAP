
// ============== 共通関数 =========================================================================
// =================================================================================================
// =================================================================================================

	// ＝＝＝＝＝　レポート情報取得メソッド　＝＝＝＝＝

	// 行ヘッダ、列ヘッダ内の軸IDを求める
	// <Input>	hieIndex:	行ヘッダ、列ヘッダ内のインデックス(0start)
	// <Input>	target:		行ヘッダ、列ヘッダ名
	// <Output>	指定された場所に配置されている軸のID
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

	// エッジ内の軸数を求める
	// <Input>	targetString:行ヘッダか列ヘッダか(COLかROWかPAGEか)
	// <Output>	指定されたヘッダに配置された軸の数を返す
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

	// エッジ内の軸IDリストを求める
	// <Input>	edgeType:エッジのタイプ("COL","ROW","PAGE")
	// <Input>	axesXmlData:レポート情報XML
	// <Output>	指定されたエッジに配置されている軸IDリスト(カンマ区切り,段index順)
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

	// 軸があるエッジ名を求める
	// <Input>	axisID:軸ID
	// <Output>	指定された軸が配置されているエッジの名称を返す。
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

	// エッジが同一のColエッジ、Rowエッジの組み合わせを持つか
	// <Input>  targetArray:  比較対象となる軸IDの配列
	// <Input>	sourceArray1: 比較元の軸IDの配列
	// <Input>	sourceArray2: 比較元の軸IDの配列
	//						  この配列がnullの場合は、targetArrayとsourceArray1を比較
	//						  nullでない場合は、targetArrayとsourceArray1＋sourceArray2を比較
	// <Output>	同じ軸の組み合わせを持てばtrue、持たない場合はfalse
	// ColとRowで軸が入れ替わっていてもOK。
	// なお、各エッジの順序は考慮しない
	function hasSame2Axes(targetArray, sourceArray1, sourceArray2) {
		if( (targetArray == null) || (sourceArray1 == null) ) { return false; }

		var sourceArray = null;
			if ( sourceArray2 == null ) {
				sourceArray = sourceArray1;
			} else {
				sourceArray = sourceArray1.concat(sourceArray2);
			}

		// エッジの持つ軸数を比較
		if(targetArray.length != (sourceArray.length) ) {
			return false;
		}

		// エッジの持つ要素を比較し、同じ組み合わせであればtrue
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

	// ＝＝＝＝＝　軸メンバ数算出メソッド　＝＝＝＝＝

	// 指定された軸のメンバ数を求める
	// <Input>	targetString:行ヘッダか列ヘッダか(COLかROWか)
	// <Input>	hierarchyID:段のインデックス(1段目の場合=0,2段目の場合=1,3段目の場合=0)
	// <Output>	指定されたヘッダの指定された段インデックスに配置されている軸のメンバ数
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

	// 指定された軸のメンバ数を求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	// <Output>	指定された軸が持つ総メンバ数を返す
	function getAxisMemberNumber(oTD) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		var targetString = getCellPosition(oTD);
		var hierarchyID  = getHieIndex(oTD);;

		if ( ( targetString == null ) || ( hierarchyID == -1 ) ) { return null; }

		return getAxisMemNum( targetString, hierarchyID )
	}

	// 次段に配置された軸のメンバ数を求める
	// <Input>	hieIndex:段インデックス
	// <Input>	target:行ヘッダか列ヘッダか(COLかROWか)
	// <Output>	与えられた段インデックスの次段のメンバ数を返す。
	//			ヘッダの最終段であれば0を返す。
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


	// 指定されたセルの下段に配置された軸メンバの組み合わせ数を求める
	// Input)
	//  cell：行または列のTD要素
	//  target：TD要素が行ヘッダのものか、列ヘッダのものかを表す
	// Output)
	//  与えられたTD要素の段の、次段以降の次元/メジャーメンバの組み合わせ数を返す。
	//  列に設定された最後の次元/メジャーであった場合は、1を返す。
	function getLowerHieComboNum( cell, target ) {

		var hieIndex = getHieIndex(cell);
		if ( hieIndex == -1 ) {
			return -1;
		}

		var retComboNum = getLowerHieComboNumByIndex(target, hieIndex);
		return retComboNum;
	}

	// 指定された軸の下段に配置された軸メンバの組み合わせ数を求める
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


	// ＝＝＝＝＝　データテーブル関連メソッド　＝＝＝＝＝

	// データテーブルのtargetにより指定されたヘッダの行または列数
	// <Input>  target：行または列を表す
	// <Output> <target==列の時>１列に含まれるセルの数
	//          <target==行の時>１行に含まれるセルの数
	function getDataTableCellNumbers( target ) {

		if ( target == "COL" ) {
			return dataTable.rows.length;
		} else if ( target == "ROW" ) {
			return dataTable.rows[0].cells.length;
		} else {
			return null;
		}
	}

	// ＝＝＝＝＝　セルオブジェクト取得メソッド　＝＝＝＝＝

	// レポート情報XMLの軸メンバ要素を求める
	// <Input>	xmlDoc:レポート情報XML
	// <Input>	target:エッジの名称
	// <Input>	hieIndex:軸Index
	// <Input>	xmlIndex:XMLのIndex
	// <Output>	XMLノード
	function getXMLMemberNode (xmlDoc, target, hieIndex, xmlIndex) {
		var axisID = xmlDoc.selectSingleNode("/root/OlapInfo/AxesInfo/" + target +"/HierarchyID[" + (hieIndex+1) + "]").text;

		var targetNode = xmlDoc.selectSingleNode("/root/Axes/Members[@id=" + axisID + "]//Member[@id=" + xmlIndex + "]");
		return targetNode;
	}


	// 指定されたヘッダの指定されたSpreadIndexに対応するCOLもしくはROWのオブジェクトを取得
	// <Input> target:対象が行ヘッダか、列ヘッダか
	//		   nodeSpreadIndex:ノードのSpreadインデックス
	// <Output>行ヘッダの場合、TRオブジェクト
	//		   列ヘッダの場合、COLオブジェクト
	function getSpreadNode( target, spreadIndex ) {
		var spreadNode;

		if ( target == "COL" ) {
			spreadNode = colHeader.all("CH_CG").children(spreadIndex);
		} else if ( target == "ROW"){
			spreadNode = rowHeader.firstChild.rows[spreadIndex];
		}

		return spreadNode;
	}

	// 指定されたTDオブジェクトに対応するCOLもしくはROWのオブジェクトを取得
	// <Input> ele: 行ヘッダもしくは列ヘッダのTDオブジェクト
	// <Output>行ヘッダの場合、TRオブジェクト
	//		   列ヘッダの場合、COLオブジェクト
	function getSpreadNodeByTDObj( ele ) {

		if ( isCellInColHeader(ele) ) {
			return colHeader.all( "CH_CG" + getColIndexByTDObj(ele) );
		} else if ( isCellInRowHeader(ele) ) {
			return ele.parentNode;
		}
	}


	// TRもしくはCOLオブジェクトより行もしくは列のTDオブジェクトを取得する
	// Input）
	//   node:<target=="行"の場合>行ヘッダテーブルのTRオブジェクト
	//        <target=="列"の場合>列ヘッダテーブルのCOLオブジェクト
	//   target：行か列かを表す(COL or ROW)
	//   hieIndex：対象ヘッダの何番目の軸のオブジェクトを取得するか(0start)
	// Output)TDオブジェクト
	function getCellObj( node, target, hieIndex ) {

		var targetObjNum = getHeaderObjNum( target );

		var colIndex;
		var rowIndex;
		var targetRow;

		// 取得対象が列ヘッダのオブジェクトの場合
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
		// 取得対象が行ヘッダのオブジェクトの場合
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

		// 行もしくは列のTDオブジェクトを戻す
		return targetRow.cells(colIndex);
	}


	// ＝＝＝＝＝ セル配置位置取得メソッド ＝＝＝＝＝

	// セルの配置場所(COL,ROW,DATA)を求める
	// <Input>	oTD:行、列、データテーブルのTD
	// <Output>	行、列、データテーブルを表す文字列を返す（行：COL、列：ROW、データテーブル：DATA）
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

	// クロスヘッダー部のセルか
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

	// 列ヘッダ部のセルか
	// Input	:オブジェクト
	// Output	:eleが列ヘッダのTDオブジェクトであれば、trueを返す
	function isCellInColHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "COL") {
			return true;
		}
		return false;
	}

	// 行ヘッダ部のセルか
	// Input	:オブジェクト
	// Output	:eleが行ヘッダのTDオブジェクトであれば、trueを返す
	function isCellInRowHeader( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "ROW") {
			return true;
		}
		return false;
	}

	// データテーブル部のセルか
	// Input	:オブジェクト
	// Output	:eleがデータテーブルのTDオブジェクトであれば、trueを返す
	function isCellInDataTable( ele ) {
		if ( ele == null ) { return false; }
		if ( ele.tagName != "TD" ) { return false; }

		if ( getCellPosition(ele) == "DATA") {
			return true;
		}
		return false;
	}


	// ＝＝＝＝＝　セル情報取得メソッド　＝＝＝＝＝

	// セル座標を求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	//				（ID：RH_RxCy、CH_RxCy、DC_RxCy）
	// <Output>	行ヘッダ、列ヘッダ、データテーブル内の座標
	//			（書式：「x(col):y(row)」）
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

	// 軸メンバのSpreadIndexを求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	//				（ID：RH_RxCy、CH_RxCy）
	// <Output>	Spread Index(列/行内で一意になる0 startのindex(int))
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

	// セルの段インデックスを求める
	// <Input>	oTD:TD オブジェクト
	// <Output>	TDオブジェクトが属する行/列の次元/メジャーの行/列内での段数(0start)
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

	// セルが行/列の最下段か？
	// <Input>	oTDオブジェクト
	// <Output>	TDオブジェクトが行/列の最下段であれば、true
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

	// クロスヘッダー部の最終行か？
	// <Input>	ele: クロスヘッダ部のTD Object
	// <Output>	true / false
	// Note:	入力されたTDオブジェクトがクロスヘッダー部の
	//			最終行のオブジェクトかを調べ、正しい場合は「true」、異なる場合は「false」を返す。
	// Error:	・入力されたオブジェクトがTDオブジェクトでない場合
	//				⇒「false」を返す
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

	// セルが同じ上段列に属するメンバリストの先頭メンバか
	// <Input>	cell: 行/列エッジのTDオブジェクト
	// <Output>	セルが同じ上段列に属するメンバリストの先頭メンバであればtrue
	// 			（上段に軸が無い場合、その軸内の先頭メンバであればtrue）
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

	// セルが同じ上段列に属するメンバリストの最終メンバか
	// <Input>	cell: 行/列エッジのTDオブジェクト
	// <Output>	セルが同じ上段列に属するメンバリストの最終メンバであればtrue
	// 			（上段に軸が無い場合、その軸内の最終メンバであればfalse）
	function isEndPartCell(cell) {
	// <Input>cell: 行/列エッジのTDオブジェクト

		if (cell == null) { return false; }
		if (cell.tagName != "TD") { return false; }
		if ((!isCellInColHeader(cell)) && (!isCellInRowHeader(cell))) { return false; }

		var index = getSpreadIndexByTDObj(cell);
		var thisHieMemNum = parseInt(parent.display_area.getAxisMemNum( getCellPosition(cell), getHieIndex(cell) ));			var lowerComboNum = 1 * parseInt(parent.display_area.getLowerHieComboNum( cell, getCellPosition(cell) ));

		// 同じ上段に属するパート内の最終メンバか
		if ( ( index % (thisHieMemNum * lowerComboNum) ) == ( (thisHieMemNum - 1) * lowerComboNum ) ) {
			return true;
		} else {
			return false;
		}
	}


	// TDオブジェクトが属する上位段からの各軸のKey配列を求める
	// <Input>	oTD:与えられた最終段のTDオブジェクト
	// <Output>	各段のKey配列を返す。添え字が段Indexと対応する。
	//        	ただし、存在しないメンバの添え字には空文字を対応させる。
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


	// セルの列Indexを求める
	// <Input>	headerCOLObj:クロスヘッダ,列ヘッダのCOLオブジェクト
	//			（ID書式：CrossHeader_CGx、CH_CGx）
	// <Output>	何列目かを表すIndex
	function getCOLIndexByCOLObj( headerCOLObj ) {
		var strID     = headerCOLObj.id;
		var strGIndex = strID.lastIndexOf("G");
		var colIndex  = strID.substr(strGIndex + 1, strID.length - (strGIndex + 1));
		return colIndex;
	}

	// セルの列のIndexを求める
	// Input	:行、列ヘッダ、データテーブルのTDオブジェクト
	//			 (ID書式：RH_RxCy、CH_RxCy、DC_RxCy)
	// Output	:何列目かを表すIndex
	function getColIndexByTDObj( headerTDObj ) {
		var strID     = headerTDObj.id;
		var strCIndex = strID.lastIndexOf("C");
		var colIndex  = strID.substr(strCIndex + 1, strID.length - (strCIndex + 1));
		return colIndex;
	}

	// セルの行のインデックスを求める
	// Input	:行、列ヘッダ、データテーブルのTRオブジェクト
	//           (ID書式：RH_Rx、CH_Rx、DC_Rx)
	// Output	:何行目かを表すIndex
	function getRowIndexByTRObj( headerTRObj ) {
		var strID     = headerTRObj.id;
		var strRIndex = strID.lastIndexOf("R");
		var rowIndex  = strID.substr(strRIndex + 1, strID.length - (strRIndex + 1));
		return rowIndex;
	}

	// ＝＝＝＝＝　セル移動メソッド　＝＝＝＝＝

	// 同軸の次メンバセルを求める
	// <Input>	oTD:TD オブジェクト
	// <Output>	指定されたTDオブジェクトであらわされる軸メンバの次メンバをあらわすTDオブジェクト
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

	// 次のTDオブジェクトを求める
	// <Input>	node:TD オブジェクト
	// <Output>	親として上位段の同一の次元メンバを持つ範囲内で、次の次元メンバを返す。
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

	// セルが属する上位段のセルを求める
	// Input) 
	//	headerCellObject:TD要素
	//	targetString:COL or ROW
	// Output)
	//	cellが属する上位段の要素（TD要素）
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

	// 指定されたメンバに属する次段の軸メンバのうち、先頭メンバを求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	// <Output>	与えられた軸メンバ（TDオブジェクト）に属する
	//			次段のメンバのうち先頭メンバ(TDオブジェクト)を返す
	function getUnderHieFirstNode( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// 次段以降にメンバない場合nullを返す。
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


	// 指定されたメンバに属する次段のメンバリストを求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	// <Output>	次段のメンバリスト
	function getUnderHieNodes( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// 次段以降に軸がない場合nullを返す。
		if ( getNextAxisMemberNumber( getHieIndex(oTD), getCellPosition(oTD) ) == 0 ) { return null; }

		var underNodeArray = new Array();
		var underNode = getUnderHieFirstNode( oTD );
		for ( i = 0; i < getNextAxisMemberNumber( getHieIndex(oTD), getCellPosition(oTD) ); i++ ) {
			underNodeArray[i] = underNode;
			underNode = getNextCell(underNode);
		}

		return underNodeArray;
	}

	// 指定されたメンバに属する次次段のメンバリストを求める
	// <Input>	oTD:行ヘッダ,列ヘッダのTDオブジェクト
	// <Output>	次次段のメンバリスト
	function getUnder2HieNodes( oTD ) {
		if ( oTD == null ) { return null; }
		if ( oTD.tagName != "TD" ) { return null; }

		// 指定されたTDオブジェクトが、3段構成のヘッダの0段目でない場合、nullを返す
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

	// ＝＝＝＝＝　セル情報変換メソッド（XML）　＝＝＝＝＝

	// XMLインデックスよりUNameを求める
	// <Input>	axisID:軸ID
	// <Input>	xmlIndex:軸メンバのXMLのID(レポート情報XMLの「Member」要素の「id」属性の値)
	// <Output>	指定された軸メンバのUName(レポート情報XMLのMemberタグの要素)
	//			(ディメンション：key、メジャー：1startの昇順Index)
	function changeXMLIndexToUName (axisID, xmlIndex) {

		var UName = axesXMLData.axesXMLData.selectSingleNode("/root/Axes/Members[@id=" + axisID  + "]//Member[@id=" + xmlIndex + "]").text;

		return UName;
	}

	// UNameよりXMLインデックスを求める
	// <Input>	axisID:軸ID
	// <Input>	UName:軸メンバのXMLのID(レポート情報XMLの「Member」要素の「UName」属性の値)
	//				  (ディメンション：key、メジャー：1startの昇順Index)
	// <Output>	指定された軸メンバのXMLインデックス
	function changeUNameToXMLIndex (axisID, UName) {

		var xmlIndex = parseInt(axesXMLData.axesXMLData.selectSingleNode("/root/Axes/Members[@id = " + axisID  + "]//Member[./UName=" + xmlIndex + "]").text);

		return xmlIndex;
	}

	// SpreadIndexをXMLIndexへ変換
	// <Input>	spreadIndex:ドリル操作を行なわれたメンバの行/列インデックス
	// <Input>	target:COLかROWか
	// <Input>	hieIndex:段インデックス
	// <Output>	軸メンバ内で昇順に振られたインデックス(レポート情報XMLの「Member」要素の「id」属性の値)
	function changeSpreadIndexToXMLIndex ( spreadIndex, target, hieIndex ) {

		var headerMemNum1  = getNextAxisMemberNumber( 0, target );		// 1段目の軸の総メンバ数
		var headerMemNum2  = getNextAxisMemberNumber( 1, target );		// 2段目の軸の総メンバ数
		var lowerComboNum = getLowerHieComboNumByIndex(target, hieIndex);	// 以下の段のメンバの組み合わせ数

		var xmlIndex = -1;

		// 行/列が１つの次元/メジャーを持つ場合
		if ( getHeaderObjNum(target) == 1 ) {
			xmlIndex = spreadIndex;

		// 行/列が２つの次元/メジャーを持つ場合
		} else if ( getHeaderObjNum(target) == 2 ) {
			// 0段目のオブジェクトの場合
			if ( hieIndex == 0) {
				xmlIndex = Math.round((spreadIndex / lowerComboNum) - 0.5);

			// 1段目のオブジェクトの場合
			} else if ( hieIndex == 1 ) {
				xmlIndex = spreadIndex % headerMemNum1;
			}

		// 行/列が３段の場合
		} else if ( getHeaderObjNum(target) == 3 ) {
			// 0段目のオブジェクトの場合
			if ( hieIndex == 0) {
				xmlIndex = Math.round((spreadIndex / lowerComboNum) - 0.5);
			// 1段目のオブジェクトの場合
			} else if ( hieIndex == 1 ) {
				xmlIndex = ( spreadIndex / lowerComboNum ) % headerMemNum1;
			// 2段目のオブジェクトの場合
			} else if ( hieIndex == 2 ) {
				xmlIndex = spreadIndex % headerMemNum2;
			}
		}

		return parseInt(xmlIndex);
	}


	// XMLインデックスをSpreadインデックスへ変換
	// <Input>	axisIDList:列または行の全軸の軸IDの配列
	// <Input>	xmlIndexList:列または行の全軸の軸メンバのXMLのID(レポート情報XMLの「Member」要素の「id」属性の値)の配列
	//			※axisIDListとxmlIndexListは添字で対応づく。配列は段Indexの昇順とする。
	// <Output>	与えられた軸の組み合わせが行/列に配置されている場合、
	//			その組み合わせで一意になるSpreadインデックスを返す
	function changeXMLIndexesToSpreadIndex ( axisIDArray, xmlIndexArray ) {
		if ( ( axisIDList == null ) || ( xmlIndexList == null ) ) { return -1; }
		if ( axisIDList.length != xmlIndexList.length ) { return -1; }
		if ( axisIDArray.length != xmlIndexArray.length ) { return -1; }

		var targetObjNum  = getHeaderObjNum( target );	// ヘッダの軸数
		if ( axisIDArray.length != targetObjNum ) { return -1; }

		var spreadIndex = -1;			// Spread上での行/列インデックス

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


	// XMLインデックスをSpreadインデックスへ変換
	// <Input>	xmlIndex:軸メンバのXMLインデックス(レポート情報XMLの「Member」要素の「id」属性の値)
	// <Input>	target:COLかROWか
	// <Input>	startSpreadIndex:求める軸メンバと同じ上段メンバに属するメンバ集合の先頭メンバのSpreadインデックス
	// <Input>	hieIndex:段インデックス
	// <Input>	lowerHieComboNum:次段以降のメンバの組み合わせ数
	// <Output>	xmlIndexで与えられた軸メンバの、Spreadの行/列で一意になるインデックス
	function changeNodeIDToSpreadID ( xmlIndex, target, startSpreadIndex, hieIndex, lowerHieComboNum ){

		var spreadIndex;			// Spread上での行/列インデックス

		var drilledNodeSpreadIndex;	// ドリル操作を行われた要素のインデックス
			var headerMemNum1;		// ドリルの行われたヘッダの1行/列目の軸のメンバ数
			var headerMemNum2;		// ドリルの行われたヘッダの2行/列目の軸のメンバ数
			var targetObjNum;		// ドリルの行われたヘッダの軸数

			headerMemNum1 = getAxisMemNum( target, 1 );
			headerMemNum2 = getAxisMemNum( target, 2 );
			targetObjNum  = getHeaderObjNum( target );

		if ( targetObjNum == 1) {	// ヘッダに軸一つ
			spreadIndex = xmlIndex;
		} else if ( targetObjNum == 2 ) {	// ヘッダに軸二つ
			if ( hieIndex == 0) {	// 0段目
				spreadIndex = xmlIndex * lowerHieComboNum;
			} else if ( hieIndex == 1 ) {	// 1段目
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % headerMemNum1 ) ) + xmlIndex;
			}

		} else if ( targetObjNum == 3 ) {	// ヘッダに軸三つ
			if ( hieIndex == 0) {	// 0段目
				spreadIndex = xmlIndex * lowerHieComboNum;
			} else if ( hieIndex == 1 ) {	// 1段目
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % ( headerMemNum1 * headerMemNum2 ) ) ) + ( xmlIndex *  lowerHieComboNum);
			} else if ( hieIndex == 2 ) {	// 2段目
				spreadIndex = ( startSpreadIndex - ( startSpreadIndex % headerMemNum2 ) ) + xmlIndex;
			}
		}

		return spreadIndex;
	}


	// ＝＝＝＝＝　セル情報変換メソッド（タグ構成）　＝＝＝＝＝

	// 概要：    セルオブジェクトを戻す。
	//           引数で与えられたオブジェクトが、クロスヘッダー内の軸タイトル部
	//           DIVオブジェクトであった場合、そのセルオブジェクトに変更する。
	// 引数:     オブジェクト
	// 戻り値：  セルオブジェクト
	function getCellObjFromAxisImage(element) {

		var ele = element;
			if (ele == null) { return null; }

			// クロスヘッダ部のボタン(DIV)の場合、クロスヘッダを表すセルをeleに変更する。
			if (ele.tagName == "DIV") {
				ele = ele.parentNode.parentNode.parentNode;
			}

		return ele;

	}


