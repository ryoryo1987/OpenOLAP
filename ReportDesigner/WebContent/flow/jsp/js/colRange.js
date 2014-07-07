

// ============== 幅変更関連 ==================================================

	// 幅変更関連
	var target = null;
	var activation = null;
	var mouseX = -1;			// マウスポインタ移動前のX座標（幅変更で使用）
	var mouseY = -1;			// マウスポインタ移動前のY座標（高さ変更で使用）
	var selectedCellInitialValue = 0;	// クロスヘッダでドラックされたセルの幅もしくは高さの初期値

	// Spread表示エリア(BODY)のドラッグ可能領域にしめる、クロスヘッダ領域の幅/高さの最大値(割合)
	var crossHeaderMaxWidthRate  = 0.8;	// 幅
	var crossHeaderMaxHeightRate = 0.8;	// 高さ

	var CRSHeaderObject = document.all("CrossHeaderArea");

	function getNextAxisMemNum( hieIndex, target ) {
		// 行ヘッダで次の段の次元/メジャーのメンバ数を返す
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
		//  cell：行または列のTD要素
		//  target：TD要素が行ヘッダのものか、列ヘッダのものかを表す
		// Output)
		//  与えられたTD要素の段の、次段以降の次元/メジャーメンバの組み合わせ数を返す。
		//  列に設定された最後の次元/メジャーであった場合は、1を返す。

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
	// Input(cell): 列ヘッダ上のセルオブジェクト（<TD>）
	// Input(slideNum): 入力を受けたセルオブジェクトを前後に調整する
	//					（入力を受けたセルオブジェクトに対応する<COL>のインデックスを
	//					　そのまま出力する場合は、0）
	// Input(position): 入力を受けたセルオブジェクトの左側のカラムに対応するCOLの
	//					インデックスを返すか(LEFT)、右側のカラムに対応するCOLの
	//					インデックスを返すか(RIGHT)
	// Output:対応する列ヘッダのインデックス（<COL>）
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
	// クロスヘッダ、列ヘッダの幅変更と同期させて、行ヘッダ、データ表示部の列幅を変更
		var width = target.offsetWidth + delt;
		if (width <= 0) {
			// width が0以下になった場合には、width="1px"とする。
			// widthを0以下に設定することはできない（エラーになる）ため。
			width = "1px";
			target.style.width = width;
			scrollView();	// スクロール位置を合わせる
			return;
		}

		if ( activation == "modifyColHeaderWidth" ) {
			target.style.width = width;
			if ( method == "UP" ) {
				// データ表示テーブルのCOLオブジェクトの幅を変更する
				var tmpColIndex = getCOLIndexByCOLObj(target);
				var dataColumn = dataTable.all("DT_CG" + tmpColIndex);
				dataColumn.style.width = width;
			}
		} 

		// 行・列ヘッダ、データテーブルのスクロール位置(X軸、Y軸)をあわせる
		scrollView();
		return;
	}

	function mouseDown() {
		// ローカル変数
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

		// 共通変数の初期化
		target = null;
		activation = null;
		mouseX = -1;
		mouseY = -1;
		selectedCellInitialValue = 0;

		// 処理
		if ( ( mousePosition == "columnHeaderCellVLine" ) || ( mousePosition == "crossHeaderCellVLine" ) ) {
			if ( window.event.offsetX < 3 ) {
			// ***** 列ヘッダセル左部のドラッグ可能領域がクリックされた場合 *****
			// 列ヘッダの一つ以上左の展開列のセルが選択されたものとみなす。
			// （ドリルされずに集約されているセルはスキップする）
			// また、列ヘッダ１列目(index=0)のセル左部がクリックされた場合は、
			// 一つ左のクロスヘッダー部のセルが選択されたものとみなす。
			// ***** クロスヘッダセル左部のドラッグ可能領域がクリックされた場合 *****
			// 一つ左のヘッダセルが選択されたものとみなす。
			// また、クロスヘッダ１列目のセル左部がクリックされた場合は、
			// 動作しない。
				tmpObj = srcEle.previousSibling;	// TR Object

				// 選択されたセルに対応するCOLオブジェクトを求める
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
					// クリックされたセルに対応する、COLオブジェクトのIndexを求める。
					targetIndex = changeCellIndexToCHCOL(srcEle,0,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);

				} else {
					return null;
				}
			} else {
				return;
			}
			target = tmpObj;			// 幅変更を行なうオブジェクトもしくは
										// その代表オブジェクト
			if ( mousePosition == "columnHeaderCellVLine" ) {
				activation = "modifyColHeaderWidth";	// 動作の設定
			} else if ( mousePosition == "crossHeaderCellVLine" ) {
				activation = "modifyCrossHeaderWidth";
				selectedCellInitialValue = target.offsetWidth;
			} else {
				return;
			}
			mouseX = event.clientX;					// X座標を登録
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
					// クロスヘッダ部の幅の上限を超えていないか

					return;
				}

				var method = "MOVE";
				var retCode = changeCellWidth(target,delt,activation,method);

				mouseX = window.event.clientX;
				return;
			}

		} else {
		// 行ヘッダ、列ヘッダ内のドラッグ可能領域に
		// マウスポインタが動かされた場合、マウスアイコンを
		// ドラッグ用のアイコンへ変更する
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
					// ＜クロスヘッダの幅の上限を超過＞
					// 行ヘッダ部の幅をクロスヘッダ部の幅に合わせる
					retCode = changeCellWidth(target,0,activation,method);

				} else {

					// 幅を変更
					retCode = changeCellWidth(target,delt,activation,method);
				}

				// 共通変数の初期化
				target = null;
				activation = null;
				mouseX = -1;
				mouseY = -1;
				selectedCellInitialValue = 0;

				return;
			}
		}
	}

// ============== マウス位置判定関数 ============================================

	function onColumnHeaderCellVLine( thisEvent ) {
	// 引数:     イベントオブジェクト
	// 戻り値：  true / false
	// 概要：    イベントが列ヘッダセルの縦の罫線付近
	//           (offsetで求められる数値で、3未満)で
	//           発生した場合には「true」それ以外の場合には「false」を返す。
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ( ele.parentElement.Spread != "ColumnHeaderRow" ) &&
			 ( ele.parentElement.Spread != "ColumnHeaderMeasureRow" ) ) {
			return false;
		}

		// セル内左部の罫線付近であるか、セル内右部の罫線付近であれば
		// 「true」を返す
	//	if ( thisEvent.offsetX < 3 ) {
		if ( thisEvent.offsetX < 3 && ele.cellIndex!=0) {
			return true;
		} else if ( thisEvent.offsetX > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}

