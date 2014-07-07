// ============== 幅変更関連 ==================================================

	// 幅変更関連
	var target = null;
	var activation = null;
	var mouseX = -1;			// マウスポインタ移動前のX座標（幅変更で使用）
	var mouseY = -1;			// マウスポインタ移動前のY座標（高さ変更で使用）
	var selectedCellInitialValue = 0;	// クロスヘッダでドラックされたセルの幅もしくは高さの初期値
	var changedColRange = false;		// 幅変更のmouseUp処理の終了時に、trueを設定。
										// trueの場合は

	// Spread表示エリア(BODY)のドラッグ可能領域にしめる、クロスヘッダ領域の幅/高さの最大値(割合)
	var crossHeaderMaxWidthRate  = 0.8;	// 幅
	var crossHeaderMaxHeightRate = 0.8;	// 高さ


	// Input(cell): 列ヘッダ上のセルオブジェクト（<TD>）
	// Input(slideNum): 入力を受けたセルオブジェクトを前後に調整する
	//					（入力を受けたセルオブジェクトに対応する<COL>のインデックスを
	//					　そのまま出力する場合は、0）
	// Input(position): 入力を受けたセルオブジェクトの左側のカラムに対応するCOLの
	//					インデックスを返すか(LEFT)、右側のカラムに対応するCOLの
	//					インデックスを返すか(RIGHT)
	// Output:対応する列ヘッダのインデックス（<COL>）
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

	// クロスヘッダ、列ヘッダの幅変更と同期させて、行ヘッダ、データ表示部の列幅を変更
	function changeCellWidth(target,delt,activation,method) {
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
		} else if ( activation == "modifyCrossHeaderWidth" ) { 

			// クロスヘッダ表示エリアの幅を変更
			CRSHeaderObject.style.width = CRSHeaderObject.offsetWidth + delt;

			// クロスヘッダのCOLの幅を変更
			target.style.width = width;

			if ( method == "UP" ) {
				// スプレッド配置用テーブルのCrossHeader,RowHeader配置列に
				// 対応するCOL幅を変更
				var crossRHObj = document.all("CROSS_RH");
				crossRHObj.style.width = CRSHeaderObject.offsetWidth;

				// 行ヘッダ配置エリアの幅を変更
				rowHeader.style.width = CRSHeaderObject.offsetWidth;

				// ドラッグされたセルに対応する、行ヘッダのCOLの幅を変更
				var cgColIndex = getCOLIndexByCOLObj(target);
				var rowCOLObj = document.all( "RH_CG" + cgColIndex );
				rowCOLObj.style.width = width;

				// クロスヘッダ表示エリアの幅＋列ヘッダ表示エリアの幅を一定に保つため、
				// 列ヘッダ表示エリア・データテーブル表示エリアから
				// 行ヘッダ列の増分累計を引く
				var totalChangedWidth = target.offsetWidth - selectedCellInitialValue;
				dataTableArea.style.width = dataTableArea.offsetWidth - totalChangedWidth;
				colHeader.style.width = colHeader.offsetWidth - totalChangedWidth;
			}
		}

		// 行・列ヘッダ、データテーブルのスクロール位置(X軸、Y軸)をあわせる
		scrollView();
		return;
	}

	// 行の高さを変更
	function changeRowHeight(target,delt,activation,method) {
		var height = target.offsetHeight + delt;
		if (height <= 0) {
			// height が0以下になった場合には、height="1px"とする。
			// heightを0以下に設定することはできない（エラーになる）ため。
			height = "1px";
			target.style.height = height;
			scrollView();

			return;
		}

		// 選択行の高さを変更
		target.style.height = height;
		if ( method == "UP" ) {

			// 選択行に対応する、行ヘッダもしくはデータテーブルの行の高さを変更
			if ( activation == "modifyRowHeaderHeight" ) {
				// データ表示テーブルのTRオブジェクトを取得
				var tmpRowIndex = parseInt(getRowIndexByTRObj(target));
				var dataRow = dataTable.rows(tmpRowIndex);
				
				// 高さを変更
				dataRow.style.height = height;

			} else if ( activation == "modifyCrossHeaderHeight" ) {
				// 列ヘッダのTRオブジェクトを取得
				var tmpCHRowIndex = target.rowIndex;
				var colHeaderRow = colHeader.firstChild.rows(tmpCHRowIndex);

				// ドラッグされたセルに対応する、列ヘッダの高さを変更
				colHeaderRow.style.height = height;

				// クロスヘッダ表示エリアの高さ＋行ヘッダ表示エリアの高さを一定に
				// 保つため、行ヘッダ表示エリア・データテーブル表示エリアから
				// 行ヘッダ列の増分累計を引く

				var totalChangedHeight = target.offsetHeight - selectedCellInitialValue;

				rowHeader.style.height = rowHeader.offsetHeight - totalChangedHeight;
				dataTableArea.style.height = dataTableArea.offsetHeight - totalChangedHeight;
			}
		}
		// 行・列ヘッダ、データテーブルのスクロール位置(X軸、Y軸)をあわせる
		scrollView();
		return;
	}


	function mouseDown() {

		// ローカル変数

		// セルオブジェクトの取得を行なう
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

		// X座標（補正済）の取得を行なう
		var x = getAxisTitleX(srcEle, event);

		// 共通変数の初期化
		target = null;
		activation = null;
		mouseX = -1;
		mouseY = -1;
		selectedCellInitialValue = 0;

		// 処理
		if ( ( mousePosition == "columnHeaderCellVLine" ) || ( mousePosition == "crossHeaderCellVLine" ) ) {
			if ( x < 3 ) {

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
				if ( tmpObj == null ) {
					if ( mousePosition == "columnHeaderCellVLine" ) {
						var crossHeaderLastColIndex = 0;
						if ( !isLastHie(srcEle) ) {
							crossHeaderLastColIndex = rowObjNum-1;
						} else {
							selectedCell = document.all("CrossHeader_R" + srcEle.parentNode.rowIndex).lastChild;
							crossHeaderLastColIndex = getColIndexByTDObj( selectedCell );
						}
						activation = "modifyCrossHeaderWidth";	// 動作の設定
						// 幅変更を行なうオブジェクトもしくは
						// その代表オブジェクトを設定
						target = document.all( "CrossHeader_CG" + crossHeaderLastColIndex );
						mouseX = event.clientX;					// X座標を登録
						selectedCellInitialValue = target.offsetWidth;
						return;
					}
				}

				// 選択されたセルに対応するCOLオブジェクトを求める
				if ( mousePosition == "columnHeaderCellVLine" ) {
					targetIndex = changeCellIndexToCHCOL(srcEle,-1,"RIGHT");
					tmpObj = colHeader.all("CH_CG" + targetIndex);
					// 左隣の列が非表示状態の場合、その列をスキップし、表示列で左隣の列を探す
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
					// クリックされたセルに対応する、COLオブジェクトのIndexを求める。
					// for (自分の列番号 < 列の総数-1)
					// ***** 列ヘッダセル下部のドラッグ可能領域がクリックされた場合 *****
					// 	列ヘッダセルの最後の列もしくはそれ以前の展開列のセルが
					//	選択されたものとみなす。
					// 	（ドリルされずに集約されているセルはスキップする）

					// 選択されたセルに対応するCOLオブジェクトを求める
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

		if ( ( mousePosition == "rowHeaderCellHLine" ) || ( mousePosition == "crossHeaderCellHLine" ) ) {
			if ( window.event.offsetY < 3 ) {
			// ***** 行ヘッダセル上部のドラッグ可能領域がクリックされた場合 *****
			// 	行ヘッダの一つ以上上の展開行のセルが選択されたものとみなす。
			// 	（ドリルされずに集約されているセルはスキップする）
			// 	また、行ヘッダ１行目(index=0)のセル上部がクリックされた場合は、
			// 	一つ上のクロスヘッダー部のセルが選択されたものとみなす。
			// ***** クロスヘッダセル上部のドラッグ可能領域がクリックされた場合 *****
			// 	一つ上のヘッダセルが選択されたものとみなす。
			// 	また、クロスヘッダ１行目のセル上部がクリックされた場合は、
			// 	動作しない。
				tmpObj = srcEle.parentNode.previousSibling;
				if ( tmpObj == null ) {
					if ( mousePosition == "rowHeaderCellHLine" ) {
						// 行ヘッダ１行目(index=0)のセル上部がクリックされた

						tmpObj = document.all("CrossHeaderArea").firstChild.lastChild.lastChild;
						activation = "modifyCrossHeaderHeight";	// 動作の設定
						target = tmpObj;			// 幅変更を行なうオブジェクトもしくは
													// その代表オブジェクト

						selectedCellInitialValue = target.offsetHeight;	// 初期値を登録
						mouseY = event.clientY;		// Y座標を登録

						return;
					} else if ( mousePosition == "crossHeaderCellHLine" ) {
						return null;
					} else {
						return null;
					}
				}
				// 上隣の行が非表示状態の場合、その行をスキップし、表示行で上隣の行を探す
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
			// ***** 行ヘッダセル下部のドラッグ可能領域がクリックされた場合 *****
			// 	行ヘッダセルの最後の行もしくはそれ以前の展開行のセルが
			//	選択されたものとみなす。
			// 	（ドリルされずに集約されているセルはスキップする）

				if ( mousePosition == "rowHeaderCellHLine" ) {
					// 選択されたセルオブジェクトの最下列に対応するTRオブジェクトを求める
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

			// マウスダウン時の状況の保存処理
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
					// クロスヘッダ部の幅の上限を超えていないか

					return;
				}

				var method = "MOVE";
				var retCode = changeCellWidth(target,delt,activation,method);

				mouseX = window.event.clientX;
				return;
			}
			
			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
			// ドラッグ中に行ヘッダの高さを動的に変更
				var delt = window.event.clientY - mouseY;

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + document.all("pageEdgeTable").offsetHeight + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					// クロスヘッダ部の幅の上限を超えていないか
					// （※ドラッグ不能領域は除外：ページエッジ＋innerHTML＋列次元名表示部）
					return;
				}

				var method = "MOVE";
				retCode = changeRowHeight(target,delt,activation,method);

				mouseY = window.event.clientY;
				return;
			}

		} else {
		// 行ヘッダ、列ヘッダ内のドラッグ可能領域に
		// マウスポインタが動かされた場合、マウスアイコンを
		// ドラッグ用のアイコンへ変更する

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
			// ドラッグ可能領域には無いが、
			// マウスポインタがドリルイメージ（IMG)上にあるか、
			// ダイスイメージ（DIVのバックグラウンドイメージ）上にある場合


				if (window.event.srcElement.style.cursor == "") {
				// ポインタのカーソルをデフォルトにする
					pointedCell.style.cursor = "default";
				} else {
				// ポインタのカーソルをに変更する

					// イメージ領域なので、"hand"
					if ( window.event.srcElement.id == "axisLeft") {
						pointedCell.style.cursor = "hand";

					// 名称領域なので、"default"(矢印にもどす)
					} else {
						pointedCell.style.cursor = "default";
					}
				}

			} else {
			// マウスポインタがセルの中央部にある場合、カーソルアイコンをデフォルトに戻す
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
				changedColRange = true;

				return;
			}

			if ( ( activation == "modifyRowHeaderHeight" ) || ( activation == "modifyCrossHeaderHeight" ) ) {
				var delt = window.event.clientY - mouseY;
				var method = "UP";

				if ( ( activation == "modifyCrossHeaderHeight" ) && 
                     ( document.body.clientHeight * crossHeaderMaxHeightRate ) < parseInt(CRSHeaderObject.offsetHeight + delt + document.all("pageEdgeTable").offsetHeight + spreadTable.rows[0].offsetHeight + spreadTable.rows[1].offsetHeight ) ) {
					// ＜クロスヘッダ部の高さの上限を超過＞
					// （※ドラッグ不能領域は除外：ページエッジ＋innerHTML＋列次元名表示部）
					// 列ヘッダ部の高さをクロスヘッダ部の高さに合わせる
					retCode = changeRowHeight(target,0,activation,method);
				} else {

					// 高さを変更
					retCode = changeRowHeight(target,delt,activation,method);
				}

				// 共通変数の初期化
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

		if (ele.id=="adjustCell") {	// adjustCell上であれば、終了する
			return;
		}

		// X座標（補正済）の取得を行なう
		var x = getAxisTitleX(ele, event);

		// セル内左部の罫線付近であるか、セル内右部の罫線付近であれば
		// 「true」を返す
		if ( x < 3 ) {
			return true;
		} else if ( x > ele.offsetWidth - 4) {
			return true;
		}
		return false;
	}


	function onRowHeaderCellHLine( thisEvent ) {
	// 引数:     イベントオブジェクト
	// 戻り値：  true / false
	// 概要：    イベントが行ヘッダセルの横の罫線付近
	//           (offsetで求められる数値で、3未満)で
	//           発生した場合には「true」それ以外の場合には「false」を返す。
		var ele = thisEvent.srcElement;
		if ( ( ele.tagName != "TD" ) || ( ele.parentElement.tagName != "TR" ) ) {
			return false;
		}
		if ( ele.parentElement.Spread != "RowHeaderRow" ) {
			return false;
		}

		// セル内上部の罫線付近であるか、セル内下部の罫線付近であれば
		// 「true」を返す
		if ( thisEvent.offsetY < 3 ) {
			return true;
		} else if ( thisEvent.offsetY > ele.offsetHeight - 4) {
			return true;
		}
		return false;
	}

	function onCrossHeaderCellHLine( thisEvent ) {
	// 引数:     イベントオブジェクト
	// 戻り値：  true / false
	// 概要：    イベントがクロスヘッダーセルの横の罫線付近
	//           (offsetで求められる数値で、3未満)で
	//           発生した場合には「true」それ以外の場合には「false」を返す。
	//           但し、１行目のセル上部の横の罫線付近は「false」とする。

		var ele = thisEvent.srcElement;
		if ( ele.tagName == "DIV" ) {
			ele = ele.parentElement;
		}
		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		// セル内上部の罫線付近であるか、セル内下部の罫線付近であれば
		// 「true」を返す
		if ( thisEvent.offsetY < 3 ) {
			//一行目のセル上部の場合は、「false」を返す
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
	// 引数:     イベントオブジェクト
	// 戻り値：  true / false
	// 概要：    イベントがクロスヘッダーセルの縦の罫線付近
	//           (offsetで求められる数値で、3未満)で
	//           発生した場合には「true」それ以外の場合には「false」を返す。
	//           但し、１行目のセル左部の縦の罫線付近は「false」とする。

		// セルオブジェクトの取得を行なう
		var ele = getCellObjFromAxisImage( thisEvent.srcElement );
			if (ele == null) { return false; }

		if ( !isInCrossHeaderAreaByTDObj( ele ) ) {
			return false;
		}

		// X座標（補正済）の取得を行なう
		var x = getAxisTitleX(ele, event);

		// セル内左部の罫線付近であるか、セル内右部の罫線付近であれば
		// 「true」を返す
		if ( x < 3 ) {
			//一列目のセル左部の場合は、「false」を返す
			if ( ele.cellIndex == 0 ) {
				return false;
			}
			return true;
		} else if ( x > ele.offsetWidth - 4) {
			return true;
		}
		return false;

	}
