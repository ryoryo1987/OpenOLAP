// ============== ドリルダウン関連 ============================================

	// *****************************************************
	//  ドリル処理変数、定数
	// *****************************************************

    // ドリルダウン関連
    var isDrillingFLG = false;		// drill中かどうかを表すフラグ
									// drill処理を完了するまでは、新たなドリル処理を受け付けない。

	// 初期表示もしくはドリルダウンで一度でも表示されたことのあるメンバの情報を格納する
	// ドリルダウンにより更新される。
	// ＜KEYリスト＞
	var viewedColSpreadKeyList = new Array(3);
		viewedColSpreadKeyList[0] = "";
		viewedColSpreadKeyList[1] = "";
		viewedColSpreadKeyList[2] = "";
	var viewedRowSpreadKeyList = new Array(3);
		viewedRowSpreadKeyList[0] = "";
		viewedRowSpreadKeyList[1] = "";
		viewedRowSpreadKeyList[2] = "";

	// ＜SpreadIndex,KEYの組み合わせリスト＞
	var viewedColSpreadIndexKeyList = "";
	var viewedRowSpreadIndexKeyList = "";

	// 現在ウインドウに表示されている列/行のSpreadIndex,KEYの組み合わせ情報
	var viewingColSpreadIndexKeysDict = new ActiveXObject("Scripting.Dictionary");
	var viewingRowSpreadIndexKeysDict = new ActiveXObject("Scripting.Dictionary");

	// 表示済みかどうかを調べるための連想配列を作成
	//  associationViewed[Col/Row]SpreadKey[x]: 一度でも表示した列または行のx番目の段の次元メンバのKEY値をKEYに持つ連想配列を格納する配列。
	//  値は「1」固定。
	//  associationViewed[Col/Row]SpreadIndex[x]: 一度でも表示した列または行のSpreadIndexをKEYに持つ連想配列を格納する配列。
	//  ※ 連想配列の値は「1」固定。
	//  ※ 連想配列にアクセスし、1が帰れば、表示済みである。

	var associationViewedColSpreadKey    = new Array(3);
		associationViewedColSpreadKey[0] = new Array(3); // COL0番目の段
		associationViewedColSpreadKey[1] = new Array(3); // COL1番目の段
		associationViewedColSpreadKey[2] = new Array(3); // COL2番目の段

	var associationViewedRowSpreadKey    = new Array(3); 
		associationViewedRowSpreadKey[0] = new Array(3); // ROW0番目の段
		associationViewedRowSpreadKey[1] = new Array(3); // ROW1番目の段
		associationViewedRowSpreadKey[2] = new Array(3); // ROW2番目の段

	var associationViewedColSpreadIndex = new Array(3);
	var associationViewedRowSpreadIndex = new Array(3);

	// 今回のドリル処理で表示対象となるメンバの情報を格納する一次変数
	// ＜KEYリスト＞
	var viewColSpreadKeyList = new Array(3);
		viewColSpreadKeyList[0] = "";
		viewColSpreadKeyList[1] = "";
		viewColSpreadKeyList[2] = "";
	var viewRowSpreadKeyList = new Array(3);
		viewRowSpreadKeyList[0] = "";
		viewRowSpreadKeyList[1] = "";
		viewRowSpreadKeyList[2] = "";
	// ＜SpreadIndex,KEYの組み合わせリスト＞
	var viewColSpreadIndexKeyList = "";
	var viewRowSpreadIndexKeyList = "";


	var isDrillAgain = false;	// 二度目以降のドリルダウンかどうか。
								// 二度目以降の場合、データは取得しない。


	// *****************************************************
	//  ドリル処理関数
	// *****************************************************

	// ドリルダウン処理
	// <Input> th:行・列ヘッダのドリル状態を表すIMGオブジェクト
	function drill(th) {

		// ドリルダウン中かどうかを判定
		if ( isDrillingFLG ) {
			showMessage("5");
			return "";
		} else {
			isDrillingFLG = true;
		}

		// ＝＝＝　変数設定　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
		var target   = "";	// ドリル対象メンバが行か列か）COL、ROW
		var hieIndex  = "";	// ドリル対象メンバが行or列ヘッダの何番目かを設定する
							// (0 start)
		var objMemComboNum;		// ドリル操作が行なわれたオブジェクトの
								// 次段以降のメンバの組み合わせ数

			target = getCellPosition(th.parentNode.parentNode);
			hieIndex = getHieIndex(th.parentNode.parentNode);
			objMemComboNum = getLowerHieComboNum(th.parentNode.parentNode, target);

		// 今回のドリル処理で表示対象となるメンバの情報を格納する一次変数を初期化
			// ＜KEYリスト＞
			viewColSpreadKeyList[0] = "";
			viewColSpreadKeyList[1] = "";
			viewColSpreadKeyList[2] = "";
			viewRowSpreadKeyList[0] = "";
			viewRowSpreadKeyList[1] = "";
			viewRowSpreadKeyList[2] = "";
			// ＜SpreadIndex,KEYの組み合わせリスト＞
			viewColSpreadIndexKeyList = "";
			viewRowSpreadIndexKeyList = "";

		// ドリルの行われたヘッダに配置された軸数
		var headerAxesNums  = getHeaderObjNum( target );

		// ドリル操作を行われた要素のインデックス
		var drilledNodeSpreadIndex = drilledNodeSpreadIndex = getSpreadIndexByTDObj(th.parentNode.parentNode); 

		// XML Index
		var xmlIndex = changeSpreadIndexToXMLIndex ( drilledNodeSpreadIndex, target, hieIndex );

		// ドリル操作を行なわれたメンバに対応するノードオブジェクトをXMLより取得
		var drillNode = getXMLMemberNode(axesXMLData,target,hieIndex,xmlIndex);


		// ドリルモード設定、ステータスを更新
		var drillMode;
			if ( th.parentNode.parentNode.internalDisp == "true" ) {
				drillMode = "UP";
				th.parentNode.parentNode.internalDisp = "false";
			} else if ( th.parentNode.parentNode.internalDisp == "false" ) {
				drillMode = "DOWN";
				th.parentNode.parentNode.internalDisp = "true";
			}

		isDrillAgain = false;	// 二度目以降のドリルダウンかを表すフラグの初期化。

		// ＝＝＝＝＝＝＝＝＝＝　ドリル処理　＝＝＝＝＝＝＝＝＝＝

		if ( hieIndex == headerAxesNums - 3 ) { // 列/行の「最終段-2」段目のメンバがドリルされた

			// ドリル処理
			allLoop1(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

		} else if ( hieIndex == headerAxesNums - 2 ) { // 列/行の「最終段-1」段目のメンバがドリルされた

			// ドリル処理
			allLoop2(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

			// ドリルされたメンバが属する上位段のメンバを表示対象リストに追加
			if ( headerAxesNums == 3 ) {
				tmpHie = 0;
				tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
				setViewSpreadKeyList(tmpNode, target, tmpHie);
			}

		} else if ( hieIndex == headerAxesNums - 1 ) { // 列/行の最終段のメンバがドリルされた

			// ドリル処理
			allLoop3(drillNode,drillMode,target,drilledNodeSpreadIndex,hieIndex,hieIndex,objMemComboNum,"drill");

			// ドリルされたメンバが属する上位段のメンバを表示対象リストに追加
			var tmpHie;
			var tmpNode;
				if ( headerAxesNums == 2 ) {//ヘッダが2段
					// 0段目
					tmpHie = 0;
					tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);
				} else if ( headerAxesNums == 3 ) { //ヘッダが3段
					// 1段目
					tmpHie = 1;
					tmpNode = getUpperCellObject( th.parentNode.parentNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);

					// 0段目
					tmpHie = 0;
					tmpNode = getUpperCellObject( tmpNode, target );
					setViewSpreadKeyList(tmpNode, target, tmpHie);
				}
		}

		// 行ヘッダの表示(TABLE構成)を崩さないため、TDオブジェクトのRowSpanを調整
		if ( target == "ROW" ) {
			modifyRowSpan( th.parentNode.parentNode );
		}

		// ===　ドリル操作終了処理　===

		// 画像を反転（プラス、マイナス）
		if ( drillMode == "DOWN" ) {
			th.src="./images/minus.gif";

		} else if ( drillMode == "UP" ) {
			th.src="./images/plus.gif";
		}

		// ドリルにより取得する行もしくは列の情報を更新
		if ( drillMode == "DOWN" ) {
			if ( !isDrillAgain ) {

				if ( target == "COL" ) {
					// COLの取得情報をドリル情報(view**)で更新
					document.SpreadForm.viewCol0KeyList_hidden.value  = viewColSpreadKeyList[0];
					document.SpreadForm.viewCol1KeyList_hidden.value  = viewColSpreadKeyList[1];
					document.SpreadForm.viewCol2KeyList_hidden.value  = viewColSpreadKeyList[2];
					document.SpreadForm.viewColIndexKey_hidden.value  = viewColSpreadIndexKeyList;

					// ROWの取得情報を一度でも表示した行の情報(viewed**)で更新
					document.SpreadForm.viewRow0KeyList_hidden.value  = viewedRowSpreadKeyList[0];
					document.SpreadForm.viewRow1KeyList_hidden.value  = viewedRowSpreadKeyList[1];
					document.SpreadForm.viewRow2KeyList_hidden.value  = viewedRowSpreadKeyList[2];
					document.SpreadForm.viewRowIndexKey_hidden.value  = viewedRowSpreadIndexKeyList;
				} else if ( target == "ROW" ) {
					// COLの取得情報を一度でも表示した列の情報(viewed**)で更新
					document.SpreadForm.viewCol0KeyList_hidden.value  = viewedColSpreadKeyList[0];
					document.SpreadForm.viewCol1KeyList_hidden.value  = viewedColSpreadKeyList[1];
					document.SpreadForm.viewCol2KeyList_hidden.value  = viewedColSpreadKeyList[2];
					document.SpreadForm.viewColIndexKey_hidden.value  = viewedColSpreadIndexKeyList;

					// ROWの取得情報をドリル情報(view**)で更新
					document.SpreadForm.viewRow0KeyList_hidden.value  = viewRowSpreadKeyList[0];
					document.SpreadForm.viewRow1KeyList_hidden.value  = viewRowSpreadKeyList[1];
					document.SpreadForm.viewRow2KeyList_hidden.value  = viewRowSpreadKeyList[2];
					document.SpreadForm.viewRowIndexKey_hidden.value  = viewRowSpreadIndexKeyList;
				}
			}
		}

		// 次元データ(XML)のドリル情報を更新
		if ( drillMode == "DOWN" ) {
			changeDrillStatToTrue(axesXMLData,target,hieIndex,xmlIndex);
		} else if ( drillMode == "UP" ) {
			changeDrillStatToFalse(axesXMLData,target,hieIndex,xmlIndex);
		}

		// データ取得および終了処理
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if ( drillMode == "DOWN" ) {
			if ( !isDrillAgain ) {
				refreshTableData();		// サーバー側にレポートへのデータ挿入を要求
										// finalyzeDrill()は、サーバーより入手したデータ挿入スクリプトで実行
			} else {
				finalyzeDrill();		// ドリル終了処理
				if((node.text == "1")||(node.text == "2")) {	// グラフ表示中
					reloadChart(); 		// グラフを更新
				}
			}
		} else {
			finalyzeDrill();			// ドリル終了処理
			if((node.text == "1")||(node.text == "2")) {		// グラフ表示中			
				reloadChart(); 			// グラフを更新
			}
		}

		// 行・列ヘッダ、データテーブルのスクロール位置を調整する
		scrollView();

		return;
	}


	// *****************************************************
	//  ドリル反映処理（再帰処理）
	// *****************************************************

	function allLoop1( XMLNode,drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,startPoint ) {
	// all loop include node & child & Sibling
	// Input)
	//	XMLNode:ドリルされた次元メンバ、子レベルの最初の次元メンバ、
	//			次段の最初の次元メンバに対応するXMLオブジェクト
	//	drillMode：UP or DOWN
	//	target：ROW or COL
	//	drilledSpreadIndex:ドリルされた次元/メジャーメンバの表内でのSpreadIndex(0 start)
	//	drilledHieIndex：ドリルされた次元/メジャーの段Index(0start)
	// hieIndex:処理中の次元/メジャーの軸内での段Index(0start)
	//			ドリルされた軸の「次元/メジャー段合計段-1」と等しい。
	// objMemComboNum:ドリルされた次元/メジャーの次段以降の組み合わせ数
	// startPoint:allLoopが実行された場所("drill" or "upperLoop" or "self")

		// 処理中のXMLノードのIDを取得
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XMLのIDをSpreadのIDへ変換
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

		// ドリル対象オブジェクトを取得
		// (行のドリル時：TR要素、列のドリル時：COL要素)
		var targetNode = getSpreadNode( target,targetNodeSpreadIndex);

		// ＝＝＝＝＝＝＝＝ 呼び出された子ノードの処理 ＝＝＝＝＝＝＝＝
		if ( startPoint != "drill" ) {

			// ドリル処理実行
			execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop1" );

		}

		while (true) {
			// ＝＝＝＝＝＝＝＝ 子ノードの呼び出し ＝＝＝＝＝＝＝＝
			if (XMLNode.childNodes.length - (memberElementsNum-1) > 1) {
				var tmpCellObj = getCellObj(targetNode,target,hieIndex);
				if ( ( startPoint == "drill") || ( ( startPoint != "drill") && (tmpCellObj.internalDisp == 'true' ) ) ) {
					allLoop1(XMLNode.childNodes[memberElementsNum],drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,"self");
				}
			}

			// ドリルが実行されたノードでないならば
			if ( startPoint != "drill" ) {

			// ＝＝＝＝＝＝＝＝ 兄弟ノードの処理 ＝＝＝＝＝＝＝＝
				if (XMLNode.nextSibling != null) {

					// 処理中のXMLノードの次ノードのIDを取得
					var targetNodeXMLIndex = parseInt(XMLNode.nextSibling.getAttributeNode("id").value);

					// 取得したIDをSpreadIndexへ変換
					var targetNodeSpreadIndex;
						targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

					// オブジェクトを取得する
					var targetNode;
						targetNode = getSpreadNode( target,targetNodeSpreadIndex);

					// ドリル処理実行
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
	//	XMLNode:ドリルされた次元メンバ、子レベルの最初の次元メンバ、
	//			次段の最初の次元メンバに対応するXMLオブジェクト
	//	drillMode：UP or DOWN
	//	target：ROW or COL
	//	drilledSpreadIndex:ドリルされた次元/メジャーメンバの表内でのSpreadIndex(0 start)
	//	drilledHieIndex：ドリルされた次元/メジャーの段Index(0start)
	// hieIndex:処理中の次元/メジャーの軸内での段Index(0start)
	//			ドリルされた軸の「次元/メジャー段合計段-1」と等しい。
	// objMemComboNum:ドリルされた次元/メジャーの次段以降の組み合わせ数
	// startPoint:allLoopが実行された場所("drill" or "upperLoop" or "self")

		// 処理中のXMLノードのIDを取得
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XMLのIDをSpreadのIDへ変換
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

		// ドリル対象オブジェクトを取得
		// (行のドリル時：TR要素、列のドリル時：COL要素)
		var targetNode = getSpreadNode( target,targetNodeSpreadIndex);

		if ( startPoint != "drill" ) {

			// ドリル処理実行
			execDrill1_2( drillMode, target, drilledHieIndex, hieIndex, targetNode, targetNodeSpreadIndex, targetNodeXMLIndex, "allLoop2" );

		}

		while (true) {
			// ＝＝＝＝＝＝＝＝ 子ノードの呼び出し ＝＝＝＝＝＝＝＝
			if (XMLNode.childNodes.length - (memberElementsNum-1) > 1) {

				var tmpCellObj = getCellObj(targetNode,target,hieIndex);
				if ( ( startPoint == "drill") || ( ( startPoint != "drill") && (tmpCellObj.internalDisp == 'true' ) ) ) {
					allLoop2(XMLNode.childNodes[memberElementsNum],drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,"self");
				}
			}

			// ドリルが実行されたノードでないならば
			if ( startPoint != "drill" ) {

			// ＝＝＝＝＝＝＝＝ 兄弟ノードの処理 ＝＝＝＝＝＝＝＝
				if (XMLNode.nextSibling != null) {

					// 処理中のXMLノードの次ノードのIDを取得
					targetNodeXMLIndex = parseInt(XMLNode.nextSibling.getAttributeNode("id").value);

					// 取得したIDをSpreadIndexへ変換
					targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID(targetNodeXMLIndex,target,drilledSpreadIndex,hieIndex,objMemComboNum));

					// オブジェクトを取得する
					targetNode = getSpreadNode( target,targetNodeSpreadIndex);

					// ドリル処理実行
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

		var firstMemberXMLIndex = 0;	// 次段の最初の次元メンバのインデックス（常に0）
		var comboMemNum;				// 次段以降の次元組み合わせ数
			if ( calledLoop == "allLoop1" ) {
				if ( target == "COL" ) {
					comboMemNum = chMemNumList[2];
				} else if ( target == "ROW" ) {
					comboMemNum = rhMemNumList[2];
				}
			} else if ( calledLoop == "allLoop2" ) {
				comboMemNum = 1;			// (次段は最終段なので、常に1)
			}

		var drillXMLNode = getXMLMemberNode( axesXMLData, target, hieIndex+1 ,firstMemberXMLIndex );

		// 幅変更対象オブジェクトに属する最終段のTD要素を取得
		var targetCell = getCellObj( targetNode, target, hieIndex );

		// ドリルで取得対象となるKeyのリストを設定する
		setViewSpreadKeyList( targetCell, target, hieIndex );

		// 表示済みの行/列のKEYリストを更新
		if ( drillMode == "DOWN" ) {
			renewViewedSpreadKeyList( targetCell, target, hieIndex);
		}

		// 次段の処理を実行
		if ( calledLoop == "allLoop1" ) {
			allLoop2( drillXMLNode, drillMode, target, targetNodeSpreadIndex, drilledHieIndex, hieIndex+1, comboMemNum, "upperLoop");
		} else if ( calledLoop == "allLoop2" ) {
			allLoop3( drillXMLNode, drillMode, target, targetNodeSpreadIndex, drilledHieIndex, hieIndex+1, comboMemNum, "upperLoop");
		}
	}

	function allLoop3(XMLNode,drillMode,target,drilledSpreadIndex,drilledHieIndex,hieIndex,objMemComboNum,startPoint) {
	// all loop include node & child & Sibling
	// 概要）行または列を表示/非表示に設定する
	// Input)
	//	XMLNode:ドリルされた次元メンバ、子レベルの最初の次元メンバ、
	//			次段の最初の次元メンバに対応するXMLオブジェクト
	//	drillMode：UP or DOWN
	//	target：ROW or COL
	//	drilledSpreadIndex:ドリルされた次元/メジャーメンバの表内でのSpreadIndex(0 start)
	//	drilledHieIndex：ドリルされた次元/メジャーの段Index(0start)
	//	hieIndex:処理中の次元/メジャーの軸内での段Index(0start)
	//			ドリルされた軸の「次元/メジャー段合計段」と等しくなる。
	// objMemComboNum:ドリルされた次元/メジャーの次段以降の組み合わせ数
	// startPoint:allLoopが実行された場所("drill" or "upperLoop" or "self")

		// 処理中のXMLノードのIDを取得
		var targetNodeXMLIndex = parseInt(XMLNode.getAttributeNode("id").value);

		// XMLのIDをSpreadのIDへ変換
		var targetNodeSpreadIndex = parseInt(changeNodeIDToSpreadID( targetNodeXMLIndex, target, drilledSpreadIndex, hieIndex, objMemComboNum ));

		// ドリル対象オブジェクトを取得
		// (行のドリル時：TR要素、列のドリル時：COL要素)
		var targetNode = getSpreadNode( target, targetNodeSpreadIndex );

		// ドリルが実行されたノードでないならば
		if ( startPoint != "drill" ) {

			// ドリル処理実行
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

			// ドリルが実行されたノードでないならば
			if ( startPoint != "drill" ) {

				// Sibling
				if ( XMLNode.nextSibling != null ) {

					// 処理中のXMLノードのIDを取得
					var targetNodeXMLIndex = parseInt( XMLNode.nextSibling.getAttributeNode("id").value );

					// XMLのIDをSpreadのIDへ変換
						targetNodeSpreadIndex = parseInt( changeNodeIDToSpreadID( targetNodeXMLIndex, target, drilledSpreadIndex, hieIndex, objMemComboNum ));

					// ドリル対象オブジェクトを取得
					// (行のドリル時：TR要素、列のドリル時：COL要素)
						targetNode = getSpreadNode( target, targetNodeSpreadIndex );

					// ドリル処理実行
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

		// DISPLAYを設定する
		if ( drillMode == "UP" ) {
			setDisplayFalse( targetNode, target );
		} else if ( drillMode == "DOWN" ) {
			setDisplayTrue( targetNode, target );
		}

		// 幅変更対象オブジェクトに属する最終段のTD要素を取得
		var targetCell = getCellObj( targetNode, target, hieIndex );

		// ドリルで取得対象となるKeyのリストを設定する
		setViewSpreadKeyList( targetCell, target, hieIndex );

		// ドリルで取得対象となるIndex、Keyのリストを設定する
		setViewSpreadIndexKeyList ( targetNodeSpreadIndex, targetCell, target );

		// 現在表示中の行/列のSpreadIndex,Keyのリストを設定する
		adjustViewingSpreadIndexKeysDict ( targetNodeSpreadIndex, targetCell, target, drillMode );

		// 表示済みの行/列のKeyリスト、IndexKeyリストを更新
		if ( drillMode == "DOWN" ) {
			renewViewedSpreadKeyList( targetCell, target, hieIndex );
			renewViewedSpreadIndexKeyList ( targetNodeSpreadIndex, targetCell, target, hieIndex );
		}

	}


	// *****************************************************
	//  画面表示、非表示を切り替え
	// *****************************************************
	function setDisplayTrue( node, targetString ) {
		// 指定されたノードを表示させる
		// Input）node：表示対象ノード
		//				行のドリル時は、行ヘッダテーブルのTRオブジェクト
		//				列のドリル時は、列ヘッダテーブルのCOLオブジェクト
		//		  targetString：ドリルが行、列のどちらに対して行われたのかを表す

		var tmpNode = node;
		var target = targetString;

		if ( target == "COL" ) {
			// 列ヘッダテーブルの列を表示
				var toWidth = 0;
					if ( tmpNode.preWidth == 0 ) {
						toWidth = defaultCellWidth;
					} else {
						toWidth = tmpNode.preWidth;
					}
				tmpNode.style.width = toWidth;

			// データテーブルの列を表示
				var tmpIndex = getCOLIndexByCOLObj( tmpNode );
				dataTable.all("DT_CG" + tmpIndex).style.width = toWidth;

		} else if ( target == "ROW" ) {
			// 行ヘッダテーブルの行を表示
			tmpNode.style.display = '';

			// データテーブルの行を表示
			var tmpIndex = getRowIndexByTRObj( tmpNode );
			dataTable.rows[tmpIndex].style.display = '';
		}
	}

	function setDisplayFalse( node, targetString ) {
		// 指定されたノードを非表示にする
		// Input）node：表示対象ノード
		//				行のドリル時は、行ヘッダテーブルのTRオブジェクト
		//				列のドリル時は、列ヘッダテーブルのCOLオブジェクト
		//		  targetString：ドリルが行、列のどちらに対して行われたのかを表す

		var tmpNode = node;
		var target = targetString;

		if ( target == "COL" ) {
			// 列ヘッダテーブルの列を表示
				tmpNode.preWidth = tmpNode.offsetWidth;
				tmpNode.style.width = 0;

			// データテーブルの列を表示
				var tmpIndex = getCOLIndexByCOLObj( tmpNode );
				dataTable.all("DT_CG" + tmpIndex).style.width = 0;

		} else if ( target == "ROW" ) {
			// 行ヘッダテーブルの行を表示
			tmpNode.style.display = "none";

			// データテーブルの行を表示
			var tmpIndex = getRowIndexByTRObj( tmpNode );
			dataTable.rows[tmpIndex].style.display = "none";
		}
	}

	// ***********************************************************
	//  行/列の表示済み行/列・メンバ情報、表示中の行/列情報を更新
	// ***********************************************************

	// ドリルダウンにより一度でも表示した行もしくは列のKEY LISTを更新する
	function renewViewedSpreadKeyList ( tmpObj, targetString, hierarchyIndex ) {
		var obj       = tmpObj;
		var key       = obj.key;
		var keyString = "" + key;
		var target    = targetString;
		var hieIndex  = hierarchyIndex;

		var tmpString;
		if ( target == "COL" ) {
			// 連想配列を確認し、表示済みかどうかを確認
			if ( associationViewedColSpreadKey[hieIndex][keyString] == 1 ) {
				return;
			} else {
				// 連想配列の表示済みリストを更新・処理続行
				associationViewedColSpreadKey[hieIndex][keyString] = 1;
			}

			// 表示済みのCOLのKEYリストを更新
			tmpString = viewedColSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + keyString;
			} else {
				tmpString = tmpString + "," + keyString;
			}
			viewedColSpreadKeyList[hieIndex] = tmpString;
		} else if ( target == "ROW" ) {
			// 連想配列を確認し、表示済みかどうかを確認

			if ( associationViewedRowSpreadKey[hieIndex][keyString] == 1 ) {
				return;
			} else {
				// 連想配列の表示済みリストを更新・処理続行
				associationViewedRowSpreadKey[hieIndex][keyString] = 1;
			}

			// 表示済みのCOLのKEYリストを更新
			tmpString = viewedRowSpreadKeyList[hieIndex];
			if ( tmpString == "" ) {
				tmpString = tmpString + keyString;
			} else {
				tmpString = tmpString + "," + keyString;
			}

			viewedRowSpreadKeyList[hieIndex] = tmpString;
		}

	}

	// ドリルダウンにより一度でも表示した行もしくは列のインデックス・Key情報を保存する
	function renewViewedSpreadIndexKeyList ( spreadIndex, tmpObj, targetString, hierarchyIndex) {
		var index       = spreadIndex;
		var indexString = "" + index;
		var obj         = tmpObj;
		var objKey      = obj.key;
		var target      = targetString;
		var hieIndex    = hierarchyIndex;


		if ( target == "COL" ) {
			// 連想配列を確認し、表示済みかどうかを確認
			if ( associationViewedColSpreadIndex[indexString] == 1 ) {
				isDrillAgain = true;
				return;
			} else {
				// 連想配列の表示済みリストを更新・処理続行
				associationViewedColSpreadIndex[indexString] = 1;
			}
		} else if ( target == "ROW" ) {
			// 連想配列を確認し、表示済みかどうかを確認
			if ( associationViewedRowSpreadIndex[indexString] == 1 ) {
				isDrillAgain = true;
				return;
			} else {
				// 連想配列の表示済みリストを更新・処理続行
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


	// ドリルダウンにより表示する行もしくは列のKEY情報を保存する
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

	// ドリルダウンにより表示する行もしくは列のインデックス・Key情報を保存する
	// <Input>
	// index: spreadIndex
	// obj: TDオブジェクト
	// target: 行か列か
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


	// 現在表示中の行/列のSpreadIndex,Keyのリストを設定する
	function adjustViewingSpreadIndexKeysDict ( targetNodeSpreadIndex, targetCell, target, drillMode ) {

		var viewingEdgeSpreadIndexKeysDict = null;
			if ( target == "COL") {
				viewingEdgeSpreadIndexKeysDict = viewingColSpreadIndexKeysDict;
			} else if ( target == "ROW" ) {
				viewingEdgeSpreadIndexKeysDict = viewingRowSpreadIndexKeysDict;
			}

		// ドリルアップ
		if ( drillMode == "UP" ) {
			if ( viewingEdgeSpreadIndexKeysDict.Exists(targetNodeSpreadIndex) ) {
				viewingEdgeSpreadIndexKeysDict.Remove(targetNodeSpreadIndex);
			}

			return;

		// ドリルダウン
		} else if ( drillMode == "DOWN" ) {
			// すでにSpreadIndexが存在するか
			if ( viewingEdgeSpreadIndexKeysDict.Exists(targetNodeSpreadIndex) ) {
				return;
			} else { // SpreadIndexが存在しない場合、登録する

				var obj = targetCell;
				viewingEdgeSpreadIndexKeysDict.Add(targetNodeSpreadIndex, getKeyArray(obj));
				return;
			}
		} else { // ドリルアップでもドリルダウンでもない
			return;
		}
	}

	// *****************************************************
	//  ドリル情報（XML）更新
	// *****************************************************

	function changeDrillStatToTrue ( xmlDoc,target,hieIndex,nodeID ) {

		// Drillダウンが行なわれた次元メンバのXMLNode
		var targetNode = getXMLMemberNode(xmlDoc,target,hieIndex,nodeID);

		// Drillダウンが行なわれた次元メンバの祖先Nodeを全て展開状態にする
		//  （クロス集計時において、異なる上段次元/メジャーに属する次元ツリーで、
		//    祖先Nodeが閉じられている場合があり、これらを展開する。）
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
	//  終了処理、初期化処理
	// *****************************************************

	// === 終了処理 ===

    function refreshTableData() {
		// サーバへのアクセス状況を設定(イメージを動かす)
//		setLoadingStatus(true);

		document.SpreadForm.action = "Controller?action=loadDataAct";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();
    }

	function finalyzeDrill() {
		// ドリルダウン/アップの終了処理

		// 同時に複数のドリルダウン処理を行なわないため、
		// ドリル中かどうかを表す変数を初期化
		isDrillingFLG = false;
		
		initializeViewColSpreadKeyList();
		initializeRowSpreadKeyList();
		initializeViewColSpreadIndexKeyList();
		initializeViewRowSpreadIndexKeyList();

	}

	// === 初期化処理 ===

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
	//  画面表示を整える
	// *****************************************************
	function modifyRowSpan( drilledTDObj ) {
		// Input:
		//	drilledTDObj：ドリル処理が行われた次元メンバのオブジェクト
		// ＜概要＞ドリル処理により、ドリルされた次元メンバの上段の次元メンバのrowSpanを修正する

		// ドリルされた次元メンバと同じ上段の次元メンバを持つ、最後の次元メンバを求める
		// ドリルされた次元メンバで、最後にdisplay=''である次元メンバを求める
		// ドリルされた次元メンバと同じ上段の次元メンバを持つ、最初の次元メンバから最後にdisplay=''であるメンバまでのメンバ数を求める
		// rowSpanを設定する
			// ドリルされた次元メンバの上段の次元メンバを取得する
			// 求めたメンバ数を設定する

		// ＝＝　変数　＝＝
		//  lastMemRowIndex:ドリルされた次元メンバと同じ上段の次元メンバを持つ、最後の次元メンバの行番号
		//  drilledCellRowIndex:ドリルされた次元メンバの行番号
		var lastMemRowIndex;
		var drilledCellRowIndex = getRowIndexByTRObj(drilledTDObj.parentElement);
		var drilledCellHieIndex = getColIndexByTDObj(drilledTDObj);

		var comboNum;
		var startMemRowIndex;
		var lastDispMemRowIndex;
		var newSpanValue;

		if ( rowObjNum == 1 ) {
		// 行が１段の場合
			return;
		} else if ( rowObjNum == 2 ) {
		// 行が２段の場合
			if ( drilledCellHieIndex == 0 ) {
				return;
			} else if ( drilledCellHieIndex == 1 ) {
				comboNum = rhMemNumList[1];
				startMemRowIndex = drilledCellRowIndex - ( drilledCellRowIndex % comboNum );
				lastMemRowIndex = startMemRowIndex + rhMemNumList[drilledCellHieIndex] - 1;
			}
		} else if ( rowObjNum == 3 ) {
		// 行が３段の場合
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

		//同じ上位段のメンバを持つもののなかで、表示中である一番後ろの行を求める。
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

		// rowSpanを更新（表示を整えるため）
		var targetObject = getCellObj(rowHeader.firstChild.rows[startMemRowIndex],"ROW",drilledCellHieIndex-1);
		targetObject.rowSpan = newSpanValue;

		// 列ヘッダの次元インデックスが2であった場合、上位段で再度実行
		if ( drilledCellHieIndex == 2 ) {
			modifyRowSpan( targetObject );
		}
	}

