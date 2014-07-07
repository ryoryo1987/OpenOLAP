
// ＝＝＝＝＝＝＝＝ ツールバースタイル関連定数 ＝＝＝＝＝＝＝＝

	// 画面分割表示（表、グラフ）へ切り替え時のグラフ表示用フレームの縦幅
	var chartSubAreaInitialHeight = 300;

// ＝＝＝＝＝ ツールバーのスタイル調整関数 ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

var selectedButton = null; // プルダウンメニュー表示中のボタン

// カラーパレット表示ボタンの選択状態スタイルをクリア
function clearColorButton() {
	document.all("divPallet").style.display='none'
}

// ********************************************************
// ツールバーボタンのイベント
// ********************************************************
function tbMouseOver(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // ツールバーのボタンが利用不能

	tbButton.className = 'over_toolicon';
}

function tbMouseDown(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // ツールバーのボタンが利用不能

	tbButton.className = 'down_toolicon';
}

function tbMouseUp(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // ツールバーのボタンが利用不能

	tbButton.className = 'up_toolicon';
}

function tbMouseOut(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // ツールバーのボタンが利用不能

	tbButton.className = 'out_toolicon';
}

function tbClick(tbButton) {
	if (tbButton == null) { return; }
	if (!isButtonEnable(tbButton)) { return; } // ツールバーのボタンが利用不能

	var tbTable = null;
		if ( tbButton.tagName == "IMG" ) {
			tbTable = tbButton.parentNode.parentNode.parentNode.parentNode.parentNode;
		} else {
			return false;
		}

	// カラーパレット表示ボタンがクリックされた
	if ( tbTable.id == "tblColorBtn" ) {
		showColorPallet(tbTable);
	}
}

// ツールバーボタンの有効性をチェックする
function isButtonEnable(tbButton) {
//alert(tbButton.outerHTML);
	var tbTable = null;
		if ( tbButton.tagName == "IMG" ) {
			tbTable = tbButton.parentNode.parentNode.parentNode.parentNode.parentNode;
		} else {
			return false;
		}

//alert(tbTable.outerHTML);
	// 全画面表示（表）の場合は、チャートボタン上でイベントを発生させない
	if ( (tbTable.id == "tblChartBtn") && (isChartTblWithOnlySpread(tbTable)) ) {
			return false;
	} else {
		return true;
	}

}

// ============== サブウインドウ関連（色関連、画面分割スタイル関連） ===================================

// ============== 共通 ==================================================

// サブウインドウで、選択された
function subWindowButton_up(eButton) {
	if ( eButton.parentNode.parentNode.parentNode.parentNode.id != "tblColorPallet" ) { return; }

	// カラーパレットで色が選択された
	if ( eButton.parentNode.parentNode.parentNode.parentNode.id == "tblColorPallet" ) {

		// 選択済みのセルを色付けする
		setColorToSelectedCell( eButton.colorStyle );
	}
}


// チャート表示領域（Framesetの最後のFrameタグ）を更新する
function dispChartSubArea(toSize) {

	var frameRows = parent.document.getElementsByTagName('frameset')[0].rows;
	var frameRowsArray = frameRows.split(",");

	// チャート表示領域を表示状態に設定（toSize !=0 かつ、フレームサイズ !=0) の場合は
	// 処理を終了しチャート表示領域の初期化は行なわない
	if ((toSize != 0 ) && (frameRowsArray[frameRowsArray.length - 1] != 0)) {
		return;
	}

	frameRowsArray[frameRowsArray.length - 1] = toSize;
	parent.document.getElementsByTagName('frameset')[0].rows = frameRowsArray.join();

}

// ============== 色関連 ==================================================

// カラーパレットを表示
function showColorPallet(eButtonTable) {
	selectedButton = eButtonTable;							// ボタンを選択状態に設定
	document.all("divPallet").style.display='block';		// パレット表示
	document.attachEvent('onmouseup', mouse_up_for_menu);	// mouse_up_for_menuイベントをdocumentにセット
}

// document内のマウスアップでカラーボタンのスタイルを初期化し、パレットを非表示にする
function mouse_up_for_menu() {
	selectedButton = null;							// 選択状態のボタンを初期化
	clearColorButton();								// カラーボタンの書式をクリア
	document.all("divPallet").style.display='none';	// パレットの非表示化
	document.detachEvent('onmouseup', mouse_up_for_menu);	// イベントのクリア
}

// ============== 画面分割スタイル関連 ==================================================

// 画面分割スタイルのタイプを表示
function showWindowDivisionType(eButtonTable) {

	selectedButton = eButtonTable;									// ボタンを選択状態に設定
	document.all("divWindowDivisionType").style.display='block';	// パレット表示
	document.attachEvent('onmouseup', mouse_up_for_win_div_menu);	// mouse_up_for_win_div_menuイベントをdocumentにセット
}

// document内のマウスアップで画面分割スタイルのスタイルを初期化し、画面分割タイプを非表示にする
function mouse_up_for_win_div_menu() {

	selectedButton = null;											// 選択状態のボタンを初期化
	document.all("divWindowDivisionType").style.display='none';		// 画面分割タイプの非表示化
	document.detachEvent('onmouseup', mouse_up_for_win_div_menu);	// イベントのクリア
}

// ============== 画面分割スタイル,チャートタイプ関連=====================================

// 全画面表示（表）の場合は、チャートボタン上でイベントを発生させない
function isChartTblWithOnlySpread(eButtonTable) {
	if(eButtonTable.id == "tblChartBtn") {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (node.text == "0") { // 0:全画面表示（表）
			return true;
		}
	}
	return false;
}

// ============== セレクタ関連 ==================================================

	// セレクタウインドウ Open
	function openSelector(targetAxisID, clickType) {

		// クリックされたマウスボタンのタイプと、指定されたclickTypeが一致しない場合、終了
		// clickType=1: 左クリック 、clickType=2: 右クリック
		if(event.type!="click") { // onclickの場合はツールバーボタンのonclickイベントからであり、onclickでは常にevent.buttonが「0」となるためチェックしない
			if(event.button!=clickType) {
				return;
			}
		}

//		window.open('Controller?action=displaySelecter','_blank','width=500px,height=580px,statusbar=no,toolbar=no');

//	モーダルセレクタ
		var args = new Array();
		args[0] = window;
		args[1] = axesXMLData;
		var ret = showModalDialog('Controller?action=displaySelecter&targetAxisID='+targetAxisID,args,'dialogHeight:580px;dialogWidth:500px;toolbar=no;status:no;');
	}

// ============== ハイライト関連 ==================================================

	// ハイライトウインドウ Open
	function openHighLight() {

		// 色情報を取得し、hiddenに登録
		var colorInfoArray = getColorArray();
		if( colorInfoArray != null ) {
			document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// ヘッダー部の色情報
			document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// データテーブルの色情報
		}
		document.SpreadForm.action = "Controller?action=registColorOnly";
		document.SpreadForm.target = "silentAccess";
		document.SpreadForm.submit();

	//	window.open('Controller?action=displayHighLight&mode=registColorOnly','_blank','width=600px,height=600px,statusbar=no,toolbar=no');
	//	showModalDialog("Controller?action=displayHighLight&mode=registColorOnly",self,"dialogHeight:650px;dialogWidth:550px;");
		showModalDialog("Controller?action=displayHighLight",self,"dialogHeight:720px;dialogWidth:550px;");
	}

// ============== レポートのエクスポート ===============================

	//エクスポートボタンクリック
	function export_button_click() {

		// サーバへのアクセス状況を設定(イメージを動かす)
//		setLoadingStatus(true);

		// 現在表示されている行/列の情報を取得し、hiddenに保存する
		// （親メンバがドリル未で非表示となっているメンバは含めない。）
		setViewingColRowInfo();

		// 色情報を取得し、hiddenに保存する
		setColorInfo();

		// サーバーへ送信
		document.SpreadForm.action = "Controller?action=exportReport";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();

	}

	// 現在表示されている行/列の情報を取得し、hiddenに保存する
	function setViewingColRowInfo() {

		// 重複しているKeyを除外するためにDictionaryを使用する
		var viewCol0KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewCol1KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewCol2KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow0KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow1KeyDict = new ActiveXObject("Scripting.Dictionary");
		var viewRow2KeyDict = new ActiveXObject("Scripting.Dictionary");

		var viewColIndexKey_hidden = "";
		var viewRowIndexKey_hidden = "";

		// 行・列ヘッダの表示中のSpreadIndexリスト
		var colSpreadIndexArray = (new VBArray(viewingColSpreadIndexKeysDict.Keys())).toArray();
		var rowSpreadIndexArray = (new VBArray(viewingRowSpreadIndexKeysDict.Keys())).toArray();

		for ( var i = 0; i < colSpreadIndexArray.length; i++ ) {
			var colSpreadIndex = colSpreadIndexArray[i];
			var colKeyArray = viewingColSpreadIndexKeysDict.Item(colSpreadIndex);

			// Keyリスト(COL)
			if ( !viewCol0KeyDict.Exists(colKeyArray[0]) ) {
				viewCol0KeyDict.Add(colKeyArray[0], 1);
			}
			if ( colKeyArray[1] != "" ) {
				if ( !viewCol1KeyDict.Exists(colKeyArray[1]) ) {
					viewCol1KeyDict.Add(colKeyArray[1], 1);
				}
			}
			if ( colKeyArray[2] != "" ) {
				if ( !viewCol2KeyDict.Exists(colKeyArray[2]) ) {
					viewCol2KeyDict.Add(colKeyArray[2], 1);
				}
			}

			// SpreadIndex,Keyリスト(COL)
			if ( viewColIndexKey_hidden != "" ) {
				viewColIndexKey_hidden += ",";
			}
			viewColIndexKey_hidden += colSpreadIndex + ":" + colKeyArray.join(";");
		}

		for ( var i = 0; i < rowSpreadIndexArray.length; i++ ) {
			var rowSpreadIndex = rowSpreadIndexArray[i];
			var rowKeyArray = viewingRowSpreadIndexKeysDict.Item(rowSpreadIndex);

			// Keyリスト(ROW)
			if ( !viewRow0KeyDict.Exists(rowKeyArray[0]) ) {
				viewRow0KeyDict.Add(rowKeyArray[0], 1);
			}
			if ( rowKeyArray[1] != "" ) {
				if ( !viewRow1KeyDict.Exists(rowKeyArray[1]) ) {
					viewRow1KeyDict.Add(rowKeyArray[1], 1);
				}
			}
			if ( rowKeyArray[2] != "" ) {
				if ( !viewRow2KeyDict.Exists(rowKeyArray[2]) ) {
					viewRow2KeyDict.Add(rowKeyArray[2], 1);
				}
			}

			// SpreadIndex,Keyリスト(ROW)
			if ( viewRowIndexKey_hidden != "" ) {
				viewRowIndexKey_hidden += ",";
			}
			viewRowIndexKey_hidden += rowSpreadIndex + ":" + rowKeyArray.join(";");
		}


		// Dictionary よりKeyリストを取得
		var viewColKeyArray = new Array(3);
			viewColKeyArray[0] = (new VBArray(viewCol0KeyDict.Keys())).toArray();
			viewColKeyArray[1] = (new VBArray(viewCol1KeyDict.Keys())).toArray();
			viewColKeyArray[2] = (new VBArray(viewCol2KeyDict.Keys())).toArray();

		var viewRowKeyArray = new Array(3);
			viewRowKeyArray[0] = (new VBArray(viewRow0KeyDict.Keys())).toArray();
			viewRowKeyArray[1] = (new VBArray(viewRow1KeyDict.Keys())).toArray();
			viewRowKeyArray[2] = (new VBArray(viewRow2KeyDict.Keys())).toArray();

		// hidden へ登録
		document.SpreadForm.viewCol0KeyList_hidden.value  = viewColKeyArray[0];
		document.SpreadForm.viewCol1KeyList_hidden.value  = viewColKeyArray[1];
		document.SpreadForm.viewCol2KeyList_hidden.value  = viewColKeyArray[2];
		document.SpreadForm.viewRow0KeyList_hidden.value  = viewRowKeyArray[0];
		document.SpreadForm.viewRow1KeyList_hidden.value  = viewRowKeyArray[1];
		document.SpreadForm.viewRow2KeyList_hidden.value  = viewRowKeyArray[2];

		document.SpreadForm.viewColIndexKey_hidden.value = viewColIndexKey_hidden;
		document.SpreadForm.viewRowIndexKey_hidden.value = viewRowIndexKey_hidden;

	}

	// 色情報をhiddenに設定
	function setColorInfo() {

		var colorIndexInfoArray = getColorIndexInfoArray();
		if ( colorIndexInfoArray != null ) {
			document.SpreadForm.colHdrColor.value = colorIndexInfoArray[0];	// 列ヘッダー部の色情報
			document.SpreadForm.rowHdrColor.value = colorIndexInfoArray[1];	// 行ヘッダー部の色情報
			document.SpreadForm.dataHdrColor.value = colorIndexInfoArray[2];// データテーブル部の色情報

//alert("colValue:" + document.SpreadForm.colHdrColor.value);
//alert("rowValue:" + document.SpreadForm.rowHdrColor.value);
//alert("pageValue:" + document.SpreadForm.dataHdrColor.value);

		}
	}

// ============== レポート保存 ================================================

	// レポート情報を保存する
	function saveReportInfo(reportName, folderID) {

		// サーバへのアクセス状況を設定(イメージを動かす)
//		setLoadingStatus(true);

		// ドリル情報を保存
		var axes = axesXMLData.selectNodes("/root/Axes/Members");
		for ( var i = 0; i < axes.length; i++ ) {
			var drillStatString = "";
			var axisID = axes[i].getAttributeNode("id").value;
			var members = axes[i].selectNodes(".//Member");
//alert(members.length);

			for ( var j = 0; j < members.length; j++ ) {
				var thisNode = members[j];
				var uName = thisNode.selectSingleNode("UName").text;
				var isDrilled = thisNode.selectSingleNode("isDrilled").text;
				if ( isDrilled == "true" ) {
					isDrilled = "1";
				} else {
					isDrilled = "0";
				}
				if(drillStatString != "" ) {
					drillStatString += ",";
				}
				drillStatString += uName + ":" + isDrilled;
			}

			document.getElementById("dim" + axisID).value = drillStatString;
		}


		// 色情報を取得
		var colorInfoArray = getColorArray();

		// 色情報をhiddenに登録
		if( colorInfoArray != null ) {
			document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// ヘッダー部の色情報
			document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// データテーブルの色情報
		}

		// サーバーへ送信
		document.SpreadForm.action = "Controller?action=saveClientReportStatus&reportName=" + reportName + "&folderID=" + folderID;
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();

	}

// ============== ログアウト ================================================

	// ログアウト実行
	function logout() {

		if ( showConfirm("CFM4") ) {
			document.SpreadForm.action = "Controller?action=logout";
			document.SpreadForm.target = "_top";
			document.SpreadForm.submit();
		}

	}

//********************************************************************
//********************************************************************
//********************************************************************

	// 塗りつぶし、ハイライト切り替えボタンがクリックされた
	function clickColorButton(event){

		var button;
		button = window.event.srcElement;

		clickButtonNode=button;//クリックしたボタンをいれておく。
		button.blur();//選択囲みをなくす。

		button.dimList = document.createElement("<div id='toolsdimList' class='dimList' onmouseover='dimListMouseover(event)'>");

		// 軸の表示名称タイプを取得
			var memberNode;
			var memberHTML="";
			var tempAhrefElement;
			var tempElement;
			var tempParentNode;
			var firstChildNodes;

			//一つめ
			tempAhrefElement=document.createElement("<a class='dimListItem' style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickColor(1)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

			//image
			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="<image src='./images/paint.gif' style='margin-left:5;margin-right:5'></image>";
			tempAhrefElement.appendChild(tempElement);

			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="塗りつぶし";

			tempAhrefElement.appendChild(tempElement);

			button.dimList.appendChild(tempAhrefElement);

			//２つめ
			tempAhrefElement=document.createElement("<a class='dimListItem'  style='padding-top:0;padding-left:2;padding-right:2' onclick=\"clickColor(2)\" onmouseover=\"chartListItemMouseover(event,null,null,0);\">");

			//image
			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="<image src='./images/highlight.gif' style='margin-left:5;margin-right:5'></image>";
			tempAhrefElement.appendChild(tempElement);

			tempElement=document.createElement("<span class='dimListItemText'></span>");
			tempElement.innerHTML="ハイライト";

			tempAhrefElement.appendChild(tempElement);

			button.dimList.appendChild(tempAhrefElement);



			bodyNode.appendChild(button.dimList);
			if (button.dimList.isInitialized == null){
				initializeDimList(button.dimList);
			}
//		}

		// 初期化
		if (activeSlicer != null){
			resetSlicer(activeSlicer);
		}

		// クリックされたスライサーボタンをアクティブに設定
		if (button != activeSlicer) {
			changeSlicerStyle(button,40);
			activeSlicer = button;
		}else{
			activeSlicer = null;
		}

		// スタイルの初期化イベントを追加
		document.attachEvent( "onmouseup", sliceStatusClear );

		return false;

	}

	// 塗りつぶし、ハイライト切り替えボタンで、引数として渡された番号(1、2)のボタンがクリックされた
	function clickColor(no){
		if(activeSlicer!=null){
			resetSlicer(activeSlicer);
		}
		activeSlicer = null;

		// レポート情報XML更新
		var colorTypeObj = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/colorType");
		if (no != colorTypeObj.text) { // レポート情報XMLが既存の設定と異なる場合、更新する。
			colorTypeObj.text = no;
		} else {
			if(no == "1"){ // 塗りつぶしの状態で、塗りつぶしが選択された場合、処理終了
				return;
			}
		}

		if(no=="1"){ // 塗りつぶし

			// 色情報を取得し、hiddenに登録
//			var colorInfoArray = getColorArray();
//			if( colorInfoArray != null ) {
//				document.SpreadForm.hdrColorInfo.value = colorInfoArray[0];	// ヘッダー部の色情報
//				document.SpreadForm.dtColorInfo.value  = colorInfoArray[1];	// データテーブルの色情報
//			}

			document.all.tblColorBtn.style.display="block";
			document.all.tblHigtLightBtn.style.display="none";

			// サーバーへ送信・再表示処理呼び出し
//			document.SpreadForm.action="Controller?action=renewHtmlAct&mode=registColorOnly&newColorType=" + no;
			document.SpreadForm.action="Controller?action=renewHtmlAct&newColorType=" + no;
			document.SpreadForm.target='display_area';
//			document.SpreadForm.action="Controller?action=loadClientInitAct&newColorType=" + no;
//			document.SpreadForm.target='info_area';
			document.SpreadForm.submit();

		}else if(no=="2"){ // ハイライト
			document.all.tblColorBtn.style.display="none";
			document.all.tblHigtLightBtn.style.display="block";
			openHighLight();

			// HighLight の「OK」ボタンでセッションへ登録する
		}
		
	}

