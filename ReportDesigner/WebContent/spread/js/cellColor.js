
// *************************************************************************************************
// 色づけのデータ構造
//	・セル(TDオブジェクト)の属性
//		<TD object>.selected: セルが選択されていれば"1"、選択されていなければ"0"。初期状態では属性なし。
//		<TD object>.colorName: セルにつけられている色の名称(例：「Red」,「Purple」etc)
//		<TD object>.style.backgroundColor: 実際にセルについている色（連想配列より取得） 
//	・連想配列
//		－associationColorArray[]
//			Key:css/cellColorTable*.jsで定義されたセル色のID。(例:hdrRed、hdrRedSelected)
//			Value:色の値(例:#ffffff)
// *************************************************************************************************

// ============== セル選択 ==================================================
	var previousClickedCell = null;		// 前回選択されたセルのオブジェクト
	var coloredCellList  = new ActiveXObject("Scripting.Dictionary"); // 色づけ済みのセルリスト(Key:id,Value:Object)
	var selectedCellList = new ActiveXObject("Scripting.Dictionary"); // 選択状態のセルリスト(Key:id,Value:Object)

	// レポートにセルが存在しないため色づけできないセル情報を格納。
	// （セレクタで外された、軸移動でレポート構成が変化したなどの場合に発生）
	var disableHdrColorString = "";	// ヘッダ部
	var disableDtColorString  = "";	// Spreadテーブル部

//	var selectedPrefix = "selected"; 	// 選択中を表すスタイルにつく接頭語
	var selectedSuffix = "Selected";	// 選択中を表すスタイルにつく接尾語

	// *********************************************************
	//  メイン処理関数
	// *********************************************************

	// セルが選択された(セルクリックイベント)
	function cellClicked() {

		//ハイライトの場合は色づけできない
		if(parent.display_area.document.all.tblHigtLightBtn.style.display=="block"){
			return;
		}



		var node = null;// 行・列ヘッダのセル(TD)
		if ( event.srcElement.tagName == "TD" ) {
			node = event.srcElement;
		} else if ( event.srcElement.tagName == "NOBR" ) {
			node = event.srcElement.parentNode;
		} else {
			return; 
		}

		if ( node.id == "adjustCell" ) { return; }	// adjustCellの場合は処理しない

		// 幅変更の場合、セル選択処理は実行しない
		if ( changedColRange ) { 
			changedColRange = false;
			return; 
		}

		// 前回クリックされたセルと同じセルがクリック：選択済セルをクリアし、終了
		// 前回クリックされたセルと違うセルがクリック：選択済セルをクリアし、今回クリックされたセルを選択する
		if ( previousClickedCell != null ) {
			if ( previousClickedCell.id == node.id ) {
				clearSelectedCell();
				return;
			} else {
				clearSelectedCell();
			}
		}

		// 選択状態にするセルのスタイルを変更
		applyColorStyleToCell ( node );

		// クリックされたセルを次回選択まで仮保存
		previousClickedCell = node;

	}


	// 選択済みのセルに指定された色スタイルを設定する
	// input: colorStyle : 色を表すスタイル名
	function setColorToSelectedCell ( colorName ) {
		if ( previousClickedCell == null ) { return; }

		var dicArray = (new VBArray(selectedCellList.Keys())).toArray();
		if ( dicArray.length == 0 ) { return; }

		var node;
		for( var i = 0; i < dicArray.length; i++) {

			node = selectedCellList.Item(dicArray[i]);

			// 色づけ
			paintCellColor( node, colorName );

			// 色づけ済みのセルidリストを更新
			if( coloredCellList.Exists(node.id) ) { //色づけされている
				if ( colorName == "" ) { //パレットで「塗りつぶしなし」を選択された
					coloredCellList.Remove( node.id );
				}
			} else { // 色づけされていない
				if ( colorName != "" ) { // 色スタイルを設定
					coloredCellList.add( node.id, node );
				}
			}

		}

		// 初期化
		previousClickedCell = null;
		selectedCellList = new ActiveXObject("Scripting.Dictionary");
	}

	// *********************************************************
	//  スタイル操作関数（ヘッダ、データテーブル）
	// *********************************************************

	// クリックされたセルにより、変更対象セルのスタイル変更を行う
	function applyColorStyleToCell( ele ) {

		// ＜クリックされたセル：データテーブルのセル＞セルの色を変更
		if ( getCellPosition( ele ) == "DATA" ) {
			setColorStyle( ele );
			return;
		}

		// ＜クリックされたセル：列・行ヘッダーのセル＞ヘッダ部、対応するデータテーブルの列・行の色を変更
		changeHeaderCellsStyle(ele);		// ヘッダ部
		changeDataTableCellsStyle( ele );	// データテーブル部
	}

	// ヘッダセルのスタイルを変更
	function changeHeaderCellsStyle( node ) {

		var hieIndex = getHieIndex(node);

		// 自分の段
		setColorStyle(node);

		// 自分－１段
		if (( getHeaderObjNum(getCellPosition(node)) >= 2 ) && ( !isLastHie(node) )) {
			var childCells = getUnderHieNodes(node);
			for ( var i = 0; i < childCells.length; i++ ) {
				setColorStyle(childCells[i]);
			}

			// 自分－２段
			if (( getHeaderObjNum(getCellPosition(node)) == 3 ) && ( hieIndex == 0 )) {
				var grandChilds = getUnder2HieNodes(node);
				for ( var i = 0; i < grandChilds.length; i++ ) {
					setColorStyle(grandChilds[i]);
				}
			}
		}
	}

	// データテーブルセルのスタイルを変更
	// 	targetNode: 列：COLオブジェクト、行：TRオブジェクト
	// 	ele:  クリックされたオブジェクト（行/列のセルTD）
	function changeDataTableCellsStyle( ele ) {
		var target = getSpreadNodeByTDObj( ele );
		var loopMax = getDataTableCellNumbers( getCellPosition ( ele ) ); // 処理中の列/行が持つセル数
		var targetEdge = getCellPosition(ele); // COL or ROW

		for ( var i = 0; i < getLowerHieComboNum( ele, getCellPosition(ele) ); i++ ) {//選択された列/行のループ
			var index = 0;	// 処理中の列/行のIndex
			if ( isCellInColHeader(ele) ) {
				index = parseInt( getCOLIndexByCOLObj(target) );
			} else if ( isCellInRowHeader(ele) ) {
				index = parseInt( getRowIndexByTRObj(target) );
			}

			var x,y;
			for ( var j = 0; j < loopMax; j++ ) {	//処理中の列/行が持つセル数だけ回るループ
				// セル座標の算出
				if ( targetEdge == "COL" ) {
					x = index;
					y = j;
				} else if ( targetEdge == "ROW" ) {
					x = j;
					y = index;
				}
				// セルの色づけ
				setColorStyle ( dataTable.rows(y).cells(x) );
			}

			target = target.nextSibling;
		}
	}

	// *********************************************************
	//  スタイル操作関数（セル）
	// *********************************************************

	// 選択済みセルのスタイルを消去する
	function clearSelectedCell ( ) {

		if ( previousClickedCell == null ) { return; }
		var dicArray = (new VBArray(selectedCellList.Keys())).toArray();
		if ( dicArray.length == 0 ) { return; }

		var node;
		for( var i = 0; i < dicArray.length; i++) {
			node = selectedCellList(dicArray[i]);
			makeUnSelectedColor(node);
		}

		// 初期化
		previousClickedCell = null;
		selectedCellList.RemoveAll();
	}


	// 色のスタイルを設定する
	function setColorStyle( node ) {

		makeSelectedColor( node );
		if( !selectedCellList.Exists(node.id) ) {
			selectedCellList.add( node.id, node );	// 選択済みのセルidリストに追加
		}
	}

	// *********************************************************
	//  セルスタイル変更関数
	// *********************************************************

	// 与えられたセルのスタイルを選択状態へ変更する
	// 	input	: オブジェクト(行、列、データテーブルのセル（TD))
	function makeSelectedColor( ele ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( ele.selected == "1" ) { return; } // 選択状態のセルであればreturn

		var prefix = null;
		if (getCellPosition(ele) == "DATA") {
			prefix = "dt";
		} else {
			prefix = "hdr";
		}

		// 色づいていないセルを選択状態にする
		ele.selected  = "1";
		if ( ele.colorName == null ) { 
			ele.style.backgroundColor = associationColorArray[prefix + selectedSuffix];

		// 色づいているセルを選択状態にする
		} else {
			ele.style.backgroundColor = associationColorArray[prefix + ele.colorName + selectedSuffix];
		}

	}

	// 与えられたセルのスタイルを非選択状態へ変更する
	function makeUnSelectedColor( ele ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( ele.selected == "0" ) { return; } // 未選択状態のセルでなければreturn

		var prefix = null;
		if (getCellPosition(ele) == "DATA") {
			prefix = "dt";
		} else {
			prefix = "hdr";
		}

		// 選択済みの色→未選択の色
		ele.selected = "0";
		if ( ele.colorName == null ) { // 色づいていないセル
			ele.style.backgroundColor = "";
		} else {// 色づいているセル
			ele.style.backgroundColor = associationColorArray[prefix + ele.colorName];
		}
	}

	// セルを色付けする
	function paintCellColor( ele, colorName ) {
		if ( ele == null ) { return; }
		if ( ele.tagName != "TD") { return; }
		if ( colorName == null ) { return; }

		// 色づけ処理
		ele.selected = "0";
		if ( colorName == "" ) { //パレットで「塗りつぶしなし」を選択された
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
	//  色づけ情報取得関数
	// *********************************************************

	// 現在の色設定を取得する（セル選択はクリアする）
	// return:	String[]
	//        	String[0]:ヘッダ部の色情報 , String[1]:ボディ部の色情報
	// 			書式：id.key:id.key:id.key:id.key:id.key:id.key;color
	//			※ id.keyはヘッダセル：３個以内、データセル：６個以内
	function getColorArray() {

		// 選択状態のセルの選択を解除し、色を選択前の色に戻す。
		if ( previousClickedCell != null ) {
			clearSelectedCell();
		}

		var dtColorInfo = "";
		var hdrColorInfo = "";

		var dicArray = ( new VBArray( coloredCellList.Keys() )).toArray();	// 色づいているセルリスト
		var disableHdrColor = disableHdrColorString;	//色づけ不能であったヘッダーセル
		var disableDtColor  = disableDtColorString;		//色づけ不能であったテーブルセル

		if ( ( dicArray.length == 0 ) && ( disableHdrColorString == "" ) && ( disableDtColorString == "" ) ) { return null; }

		var node;
		var str;
		for( var i = 0; i < dicArray.length; i++ ) {
			node = coloredCellList( dicArray[i] );
			str = "";
			if ( isCellInDataTable(node) ) { // データテーブル部の色
				str = getIdKeyList( node, "COL" ) + ":" + getIdKeyList( node, "ROW" ) + ";" + node.colorName;
				if ( dtColorInfo == "" ) {
					dtColorInfo = str;
				} else {
					dtColorInfo += "," + str;
				}
			} else { // ヘッダの色

				if ( isLastHie(node) ) { // 列or行最下段のオブジェクト
					if ( isCellInColHeader( node ) ) {
						str = getIdKeyList( node, "COL" ) + ";" + node.colorName;
					} else if ( isCellInRowHeader( node ) ) {
						str = getIdKeyList( node, "ROW" ) + ";" + node.colorName;
					}
				} else { // 列or行の最下段以外の色情報は保存しない（色づけ時にロジックで生成する）
					continue;
				}

				if ( hdrColorInfo == "" ) {
					hdrColorInfo = str;
				} else {
					hdrColorInfo += "," + str;
				}
			}
		}


		// disable情報の追加(色づけされたセルが無くなったため)
			if ( (hdrColorInfo != "")  && (disableHdrColor != "") ) {
				disableHdrColor = "," + disableHdrColor;
			}
			if ( (dtColorInfo != "") && (disableDtColor != "") ) {
				disableDtColor = "," + disableDtColor;
			}

		var returnArray = new Array(1);
		returnArray[0] = hdrColorInfo + disableHdrColor;
		returnArray[1] = dtColorInfo  + disableDtColor;

		// disable情報の初期化
		disableHdrColorString = "";
		disableDtColorString  = "";

		return returnArray;
	}

	// 色情報を取得
	function getColorIndexInfoArray () {

		// 選択状態のセルの選択を解除し、色を選択前の色に戻す。
		if ( previousClickedCell != null ) {
			clearSelectedCell();
		}

		var dicArray = ( new VBArray( coloredCellList.Keys() )).toArray();	// 色づいているセルリスト
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
	//  セル情報取得関数
	// *********************************************************


	// 指定されたヘッダの軸ID,メンバーキーの組み合わせの組み合わせ情報を取得する
	// <Input>  node  : 行/列ヘッダの TDオブジェクト
	//          target: COL or ROW
	// <Output> 行/列の段毎のID・KEYの組み合わせ
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
			if ( i == 0 ) { // 最下段
				oAxis = getCellObj( indexNode, target, (objNum - 1) );
			} else {
				oAxis = getUpperCellObject( oAxis, target );
			}
			idKeyArray[i] = getHieID( (objNum - 1 - i), target) + "." + oAxis.key;
		}

		idKeyArray.reverse();
		return idKeyArray.join(":");
	}

