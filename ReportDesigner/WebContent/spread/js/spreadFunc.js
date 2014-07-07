	// =====================================================
	// 共通変数部
	// =====================================================
	// Object 格納用
	var spreadTable   = null;	// Spread配置用のTABLE要素
	var dataTableArea = null;	// データ表示部を囲むDIV要素
	var dataTable     = null;	// データ表示部のTABLE要素
	var colHeader     = null;	// 列ヘッダ表示部を囲むSPAN要素
	var rowHeader     = null;	// 行ヘッダ表示部を囲むSPAN要素
	var CRSHeaderObject = null;	// クロスヘッダー部を囲むSAPN要素

	// Spread 表示関連
	var defaultCellWidth  = 100;	// 初期表示時の列ヘッダの幅
	var defaultCellHeight = 22; 	// 初期表示時の行ヘッダの高さ

	// 次元情報格納用
	var axesXMLData;

	// 行ヘッダ、列ヘッダにセットされた次元/メジャー数
	var rowObjNum = 0;
	var colObjNum = 0;

	// 行ヘッダ、列ヘッダの各段の次元/メジャーのメンバ数
	var chMemNumList = new Array(3);
		chMemNumList[0] = 0;
		chMemNumList[1] = 0;
		chMemNumList[2] = 0;

	var rhMemNumList = new Array(3);
		rhMemNumList[0] = 0;
		rhMemNumList[1] = 0;
		rhMemNumList[2] = 0;

	// XMLの設定
	var memberElementsNum = 7;		// XMLの次元メンバが持つ要素数
	var isDrilledPosition = 5;		// XMLの「isDrilled」のindex(0 start)


	// ** 画面内の各エリアサイズの調整用 **
	// 幅変更用のドラッグエリアとして、Spread表の右端もしくは下端とブラウザ枠間に残す余白
	var emptyWidth  = 20;
	var emptyHeight = 20;


	// ===================================================================================
	// 関数
	// ===================================================================================

	// ===== 初期化関数 ==================================================================

	// Spreadの初期化
	function loadSpread() {
		axesXMLData = parent.info_area.axesXMLData;

		//PageEdgeに次元/メジャーのスライスボタンを生成、表示(visibilityをvisibleに変更)
		showSlicerButton();

		// ======== 変数の初期化(全般) ========
		// オブジェクト
		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");
		rowHeader     = document.all("RowHeaderArea");
		CRSHeaderObject = document.all("CrossHeaderArea");


		// 行ヘッダ、列ヘッダにセットされた次元/メジャー数
		var metaDataArea = document.all("metaDataArea");
		colObjNum = parseInt(metaDataArea.all("colHiesCount").innerText);
		rowObjNum = parseInt(metaDataArea.all("rowHiesCount").innerText);

		// 行ヘッダ、列ヘッダにセットされた次元/メジャーのメンバ数
		chMemNumList[0] = parseInt(metaDataArea.all("colHie0Count").innerText);
		chMemNumList[1] = parseInt(metaDataArea.all("colHie1Count").innerText);
		chMemNumList[2] = parseInt(metaDataArea.all("colHie2Count").innerText);

		rhMemNumList[0] = parseInt(metaDataArea.all("rowHie0Count").innerText);
		rhMemNumList[1] = parseInt(metaDataArea.all("rowHie1Count").innerText);
		rhMemNumList[2] = parseInt(metaDataArea.all("rowHie2Count").innerText);

		// ======== 変数の初期化(ドリル処理用) ========
		viewedColSpreadKeyList[0] = document.SpreadForm.viewCol0KeyList_hidden.value;
		viewedColSpreadKeyList[1] = document.SpreadForm.viewCol1KeyList_hidden.value;
		viewedColSpreadKeyList[2] = document.SpreadForm.viewCol2KeyList_hidden.value;

		viewedRowSpreadKeyList[0] = document.SpreadForm.viewRow0KeyList_hidden.value;
		viewedRowSpreadKeyList[1] = document.SpreadForm.viewRow1KeyList_hidden.value;
		viewedRowSpreadKeyList[2] = document.SpreadForm.viewRow2KeyList_hidden.value;

		viewedColSpreadIndexKeyList = document.SpreadForm.viewColIndexKey_hidden.value;
		viewedRowSpreadIndexKeyList = document.SpreadForm.viewRowIndexKey_hidden.value;

		// 現在ウインドウに表示されている列/行のSpreadIndex,KEYの組み合わせ情報を初期化
		var colIndexKeysStringArray = viewedColSpreadIndexKeyList.split(",");
		for ( var i = 0; i < colIndexKeysStringArray.length; i++ ) {
			var indexKeysString = colIndexKeysStringArray[i];
			var indexKeysArray = indexKeysString.split(":");

			var spreadIndex = parseInt(indexKeysArray[0]);
			var keyArray = indexKeysArray[1].split(";");

			viewingColSpreadIndexKeysDict.add(spreadIndex, keyArray);
		}

		var rowIndexKeysStringArray = viewedRowSpreadIndexKeyList.split(",");
		for ( var i = 0; i < rowIndexKeysStringArray.length; i++ ) {
			var indexKeysString = rowIndexKeysStringArray[i];
			var indexKeysArray = indexKeysString.split(":");

			var spreadIndex = parseInt(indexKeysArray[0]);
			var keyArray = indexKeysArray[1].split(";");

			viewingRowSpreadIndexKeysDict.add(spreadIndex, keyArray);
		}

		// 連想配列の初期化(COL KEY)
		for ( var i = 0; i < viewedColSpreadKeyList.length; i++) {
			var tmpKeyArray = viewedColSpreadKeyList[i].split(",");

			for ( var j = 0; j < tmpKeyArray.length; j++ ) {
				var tmpKey = tmpKeyArray[j].toString();

				associationViewedColSpreadKey[i][tmpKey] = 1;
			}
		}

		// 連想配列の初期化(COL Index)
		var tmpIndexKeyArray = viewedColSpreadIndexKeyList.split(",");

		for ( var j = 0; j < tmpIndexKeyArray.length; j++ ) {
			var tmpIndexKey = tmpIndexKeyArray[j].toString();
			var tmpIndex = tmpIndexKey.split(":")[0].toString();

			associationViewedColSpreadIndex[tmpIndex] = 1;
		}

		// 連想配列の初期化(ROW KEY)
		for ( var i = 0; i < viewedRowSpreadKeyList.length; i++) {
			var tmpKeyArray = viewedRowSpreadKeyList[i].split(",");

			for ( var j = 0; j < tmpKeyArray.length; j++ ) {
				var tmpKey = tmpKeyArray[j].toString();

				associationViewedRowSpreadKey[i][tmpKey] = 1;
			}
		}

		// 連想配列の初期化(ROW Index)
		var tmpIndexKeyArray = viewedRowSpreadIndexKeyList.split(",");

		for ( var j = 0; j < tmpIndexKeyArray.length; j++ ) {
			var tmpIndexKey = tmpIndexKeyArray[j].toString();
			var tmpIndex = tmpIndexKey.split(":")[0].toString();

			associationViewedRowSpreadIndex[tmpIndex] = 1;
		}

		// ===== 行ヘッダが多段の場合、あらかじめヘッダセルの幅を広げてメンバ名が見えるようにしておく =====
//		if ( getHeaderObjNum("ROW") > 1 ) {
			for ( var j = 0; j < getHeaderObjNum("ROW"); j++ ) {
				changeCellWidth(document.all("CrossHeader_CG" + j), 40, "modifyCrossHeaderWidth", "UP");
			}
//		}

		// ===== ツールバーのチャート表示ボタンのカーソルスタイルを設定する =====
		setChartBtnCursorStyle();

		// ===== ツールバーの色設定タイプ切り替えボタンを設定する =====
		setColorTypeStyle();

		// ===== 行ヘッダ、列ヘッダ、データ表示部の幅、高さを調整 =====
		resizeArea();

		// ===== スクロールイベントとscrollView()との対応付け =====
		dataTableArea.onscroll = scrollView;

		// ===== Spreadテーブルの色、データ情報読み込み、Spreadの表示処理(visibilityをvisibleに変更) =====
		refreshTableColor();


		// セル上の右クリック処理の初期化を行なう
		initializeRightClickSettings();

		// ===== チャート表示エリアを表示 =====
		displayChartArea();

	}

	// チャート表示ボタンを含むTABLE要素のスタイルを設定する
	function setChartBtnCursorStyle() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		
		if(node.text == "0") { // 全画面表示（表）

			// カーソルスタイルを設定
			document.all("tblChartBtn").style.cursor = "default"; // デフォルト（矢印）

			// スタイルをgray()に設定
			document.all("chartKindArea").style.filter = chartButtonDisableFilterStyle;

		} else if ( (node.text == "1") || (node.text == "2") ) { // グラフ表示中
			document.all("tblChartBtn").style.cursor = ""; // 未設定（内部に持つDIVにより、handになる）
		}
	}

	// ツールバーの色設定タイプ切り替えボタンを設定する
	function setColorTypeStyle() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/colorType");
		if(node.text == "1") {
			document.all("tblColorBtn").style.display = "block";
			document.all("tblHigtLightBtn").style.display = "none";
		} else if (node.text == "2") {
			document.all("tblColorBtn").style.display = "none";
			document.all("tblHigtLightBtn").style.display = "block";
		}
		
	}

	// チャート表示エリアを表示
	function displayChartArea() {
		var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");

		// 全画面表示（表）のときは、グラフ種類アイコンを変更
		if (node.text == "0") {
			var selectedChartNo = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID").text;
			changeChartKindButton(selectedChartNo);
		}

		if ((node.text == "1")||(node.text == "2")) { // グラフ表示中
			document.all("chartAreaDIV").style.visibility = "visible";
		}

		// 全画面表示（グラフ）のときは、Spreadを表示せず、グラフのみを表示する
		if (node.text == "1") { // 全画面表示（グラフ）
			clickDisplayStyleMenu(1); // 1:全画面表示（グラフ）

		// 縦分割表示（表・グラフ）のときは、Spreadを表示せず、グラフのみを表示する
		} else if (node.text == "2") { // 分割表示（表・グラフ）
			clickDisplayStyleMenu(2);  // 2:全画面表示（グラフ）
		}

	}
	

	// HTMLのテーブルに色設定を適用し、完了後にデータ挿入処理を呼び出す
	function refreshTableColor() {
		document.SpreadForm.action = "Controller?action=loadColorAct";
		document.SpreadForm.target = "loadingStatus";
		document.SpreadForm.submit();
	}


	// ===== サーバへのアクセスかどうかを設定 ========================================
	function setLoadingStatus(status) {
alert("setLoadingStatus start");

		if ( (status != true) && (status != false) ) {
			return;
		}

//		if (status == true) { // サーバーへアクセス中
//			parent.spread_header.loadingStatus.loadingIMG.src = "./images/logo_anime.gif";
//		} else { // サーバーへのアクセス終了
//			parent.spread_header.loadingStatus.loadingIMG.src = "./images/logo_anime_stop.gif";
//		}
	}

	// ============= スタイル調整関連関数 =====================================

	// 行･列ヘッダとデータテーブル部のスクロール位置を合わせる
	function scrollView() {
		rowHeader.scrollTop = dataTableArea.scrollTop;
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	// 行ヘッダ、列ヘッダ、データ表示部の幅をBODYサイズに合わせて変更する。
	function resizeArea() {

		var modifyWidth = 8;

		if ( document.body.clientWidth != 0 ) {

			// ページエッジに配置された軸が多く、表示幅が足りなくてスクロールバーで表示される場合に、
			// スクロールバーの高さだけページエッジ表示部の高さを増やす
			var pageEdgeTable = document.all("tblPageEdge");
			if (pageEdgeTable.parentElement.clientHeight == pageEdgeTable.parentElement.scrollHeight ) {
				pageEdgeTable.height = "";
			} else {
				if (pageEdgeTable.height == "") {
					pageEdgeTable.height = pageEdgeTable.parentElement.scrollHeight + 
											(pageEdgeTable.parentElement.scrollHeight - pageEdgeTable.parentElement.clientHeight); 
				}
			}

			// 幅変更用のドラッグエリアであるSPANのサイズを設定
			var spreadSpan = document.all("SpreadSpan");
			spreadSpan.style.width = document.body.clientWidth;
			spreadSpan.style.height = document.body.clientHeight;

			// 行・列ヘッダ・データテーブル部のサイズを設定
			var node = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
			var newWidth  = ( document.body.clientWidth 
								- rowHeader.offsetWidth 
								- modifyWidth ) - emptyWidth;
			var areaHeight;
				if ((node.text=="0") || (node.text=="2")) { // 表部分はフレーム「display_area」内で完結
					areaHeight = ( getHeaderHeight() + getSpreadHeight() );
				} else if (node.text=="1") { // 「display_area」にはグラフが表示されるため
					areaHeight = getHeaderHeight();
				}
			var newHeight = ( document.body.clientHeight 
			                   - areaHeight - emptyHeight
			                 );
			// 行ヘッダ、データ表示部の幅および列ヘッダ、データ表示部の高さが
			// 負になった場合は、補正は行なわない
			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}
			colHeader.style.width      = newWidth;
			dataTableArea.style.width  = newWidth;
			rowHeader.style.height     = newHeight;
			dataTableArea.style.height = newHeight;

			// 行・列ヘッダ、データテーブルのスクロール位置(X軸、Y軸)をあわせる
			scrollView();

		}
	}

// ===== 表示領域の高さ、幅取得 =============================================

	// スプレッド表示フレーム内の上部エリア(スプレッド部分より上)の高さを求める。
	function getHeaderHeight() {

		// 求める高さ ＝ レポートタイトル、ツールバー表示部 ＋
		//				 ページエッジ表示部
		var headerHeight = document.all("spreadHeader").offsetHeight
							 + document.all("tblPageEdge").offsetHeight;

		return headerHeight;
	}


	// スプレッド表示フレーム内のスプレッドエリアの高さを求める。
	function getSpreadHeight() {

		// 求める高さ ＝ 列ヘッダー軸のタイトル部 ＋ 列ヘッダー部 ＋ 
		//				 行ヘッダおよびデータテーブル表示部
		var spreadHeight = colHeader.offsetHeight
							+ spreadTable.rows[0].offsetHeight
							+ spreadTable.rows[1].offsetHeight;

		return spreadHeight;
	}

// ===== メッセージ表示 =============================================

	// ユーザーにメッセージを表示
	function showMessage( id,arg1,arg2,arg3,arg4,arg5 ) {

		var message    = "";
		var arg1String = "";
		var arg2String = "";
		var arg3String = "";
		var arg4String = "";
		var arg5String = "";

		switch ( id ) {
		
			case "1" :
				if ( arg1 == "COL" ) {
					arg1String = "列ヘッダ";
				} else if ( arg1 == "ROW" ) {
					arg1String = "行ヘッダ";
				}
				message = arg1String + "には１段以上のディメンションまたはメジャーが必要です。";
				break;

			case "2" :
				if ( arg1 == "COL" ) {
					arg1String = "列ヘッダ";
				} else if ( arg1 == "ROW" ) {
					arg1String = "行ヘッダ";
				}
				message = arg1String + "には３段以上のディメンションまたはメジャーは設定できません。";
				break;

			case "3" :
				if ( arg2 == "COL" ) {
					arg2String = "列ヘッダ";
				} else if ( arg2 == "ROW" ) {
					arg2String = "行ヘッダ";
				}
				message = arg2String + "に表示できるセルの最大値は" + arg1 + "です。";
				break;

			case "4" :
				message = "レポートに表示できるセルの最大値は" + arg1 + "です。";
				break;

			case "5" :
				message = "ドリル処理を実行しています。少々お持ちください。";
				break;

			// セレクタ
			case "6" :
				message = "選択済みのメンバー欄にメンバーがありません。";
				break;

			// レポート保存
			case "7" :
				message = "レポートを保存しました。";
				break;

			// ログイン入力チェック（ユーザー名＆パスワード）
			case "8" :
				message = "ユーザー名およびパスワードを入力してください。";
				break;

			// ログイン入力チェック（ユーザー名）
			case "9" :
				message = "ユーザー名を入力してください。";
				break;

			// ログイン入力チェック（パスワード）
			case "10" :
				message = "パスワードを入力してください。";
				break;

			// レポート情報ＸＭＬが非整形である
			case "11" :
				message = "レポート情報ＸＭＬの取得に失敗しました。\n" + arg1;
				break;

			// レポート情報ＸＭＬ変換用のＸＳＬＴが非整形である
			case "12" :
				message = "レポート情報変換用ＸＳＬＴの取得に失敗しました。\n" + arg1;
				break;

			// Color情報ＸＭＬが非整形である
			case "13" :
				message = "レポートカラー情報ＸＭＬの取得に失敗しました。\n" + arg1;
				break;

			// セルデータ情報ＸＭＬが非整形である
			case "14" :
				message = "セルデータ情報ＸＭＬの取得に失敗しました。\n" + arg1;
				break;

		}

		alert( message );
	}


	// ユーザーに確認を求めるメッセージを表示
	function showConfirm(msgId,arg1){
		var msg=new Array();
		msg["CFM4"] = "ログアウトします。よろしいですか？";
		return confirm(msg[msgId]);
	}

// ====================================================================================

	// 画面フローでログアウト時に使用
	function logout_flow(element, contextPath) {
		if ( showConfirm("CFM4") ) {
			element.href = contextPath + "/Controller?action=logout";
			element.target="_top";
		} else {
			return;
		}
	}

// ===== チャート表示関連 ==============================================================

	// チャート表示を更新	
	function reloadChart() {
	
		// サーバへのアクセス状況を設定(イメージを動かす)
//		setLoadingStatus(true);

		// 現在表示されている行/列の情報を取得し、hiddenに保存する
		// （親メンバがドリル未で非表示となっているメンバは含めない。）
		setViewingColRowInfo();

		// グラフ情報を取得
		var currentChartIDNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID");

		// グラフ表示対象となるフレーム、グラフ表示エリアのサイズを設定
		var targetFrame = null; // グラフ表示対象となるフレーム
		var chartWidth;			// グラフ（イメージファイル）の幅
		var chartHeight;		// グラフ（イメージファイル）の高さ

		var displayScreenTypeNode = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/displayScreenType");
		if (displayScreenTypeNode.text == "0") { // 全画面表示（表）の場合、インナーフレームをターゲットに設定(グラフを表示させるわけではないので、実際には表示されないダミーのフレーム)
			targetFrame = "chart_area";
		} else if (displayScreenTypeNode.text == "1") { // 全画面表示（グラフ）の場合、インナーフレームにグラフを表示
			targetFrame = "chart_area";
			chartWidth = document.body.clientWidth-3;
			chartHeight = document.body.clientHeight - getHeaderHeight() -40;
//alert(chartWidth + "\n" + chartHeight);
			
			// iframeの高さを変更
			document.all("chart_area").height = chartHeight;

		} else if (displayScreenTypeNode.text == "2") { // 分割表示（表、グラフ）の場合、下部フレームにグラフを表示
			targetFrame = "chart_sub_area";

			dispChartSubArea(chartSubAreaInitialHeight); // 表示エリアを作成し、表示エリアのサイズにより、イメージを作成
			chartWidth = parent.chart_sub_area.document.body.clientWidth;
			chartHeight = parent.chart_sub_area.document.body.clientHeight;
		}

		// チャートの種類ボタン表示部のボタンを変更
		var memNo = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/currentChartID").text;
		changeChartKindButton(memNo);

		// サーバーへ送信し、画面タイプ、デフォルトチャートタイプを更新するとともに、クライアントのチャートを更新する
		document.SpreadForm.action = "Controller?action=getChartInfo&chartID=" + currentChartIDNode.text + "&displayScreenType=" + displayScreenTypeNode.text + "&chartWidth=" + chartWidth + "&chartHeight=" + chartHeight;
		document.SpreadForm.target = targetFrame;
		document.SpreadForm.submit();
	}










// =============================================================================

// ドリルスルー用変数

	// 右クリックで表示されるメニューの名称リスト
	var menuText = new Array();

	// 右クリックで表示されるメニュークリックで実行されるファンクションのリスト
	var menuAction = new Array();

	// 右クリックされたセルを格納するオブジェクト
	var rightClickedCell = null;

	// ポップアップメニューの文字列
	var divMenu = "";

	// ポップアップメニューのオブジェクト
	var oPopup = null;

// ドリルスルー用情報の初期設定
function initializeRightClickSettings(){

	var targetRepIDs = axesXMLData.selectNodes("/root/OlapInfo/ReportInfo/Report/DrillThrowInfo/TargetReports/TargetReport//TargetRepID");
	var targetRepNames = axesXMLData.selectNodes("/root/OlapInfo/ReportInfo/Report/DrillThrowInfo/TargetReports/TargetReport//TargetRepName");

	for(var i=0; i<targetRepIDs.length; i++) {
		menuText[i]   = targetRepNames[i].text;
		menuAction[i] = "drillThrough(" + targetRepIDs[i].text + ")";
	}

	if(window.createPopup) {

		oPopup = window.createPopup();       //ポップアップオブジェクト作成
		divMenu = '<DIV STYLE="border-top:1px solid #333333;border-left:1px solid #333333;background:' + popBGNormalColor + ';">';

			//メニュー内容作成
		for(count = 0; count < menuText.length; count++){
			divMenu +='<DIV onmouseover="this.style.background=\'' + popBGOverColor + '\';" onmouseout="this.style.background=\'' + popBGNormalColor + '\';" onclick="parent.' + menuAction[count] + '" style="font-size:11px; height:20px; padding-left:3px;padding-top:5px; cursor:hand; border-bottom:1px solid #333333; border-right:1px solid #333333;">' + menuText[count] + '</DIV>';
		}
		divMenu += '</DIV>';

		document.oncontextmenu = ContextMenu;                 //右クリックイベント発生時

	}

}


// マウスイベント
// 右クリック
function ContextMenu(){

	if(window.createPopup) {

		// データ入力セル以外であれば、終了
		if ( getCellPosition(event.srcElement) != "DATA" ) {
			return(false);
		}

		// ドリルスルー可能レポートが無いならば、終了
		if (menuText.length==0) {
			return(false);
		}

		rightClickedCell = null;
		rightClickedCell = event.srcElement;

		//ポップアップに表示する内容を設定
		oPopup.document.body.innerHTML = divMenu;


		// ポップアップのスタイル設定
		var popTopper = event.clientX + 0;              //ポップアップを表示するX座標を取得
		var popLefter = event.clientY + 0;              //ポップアップを表示するY座標を取得

		//ポップアップの幅
		var popWidth  = 0;
			var maxString = 0;
			for (var i=0; i<menuText.length; i++) {
				if(maxString < menuText[i].length) {
					maxString = menuText[i].length;
				}
			}
			popWidth = maxString * 16;

		//ポップアップの高さ
		var popHight  = null;
			var heightString = oPopup.document.body.firstChild.firstChild.style.height;
			popHight = (heightString.replace("px","") * menuText.length) + 1;

		//ポップアップを表示するメソッドをcall
		oPopup.show(popTopper, popLefter, popWidth, popHight, document.body);

		return(false);
	}

}

// ドリルスルーが選択された
function drillThrough(targetRepID) {

//alert("ドリルスルーが選択された");
//alert(rightClickedCell.outerHTML);

	// ＝＝＝＝＝ レポート情報生成部 ＝＝＝＝＝
	var reportID = axesXMLData.selectSingleNode("/root/OlapInfo/ReportInfo/Report/ReportID").text;
	var cubeSeq  = axesXMLData.selectSingleNode("/root/OlapInfo/CubeInfo/Cube/CubeSeq").text;

	var xmlString = "";
	xmlString += "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>";
	xmlString += "<OpenOLAP>";
	xmlString += "<report_info report_type='M' report_id='" + reportID + "' cube_seq='" + cubeSeq + "'/>";

	// ＝＝＝＝＝ 軸情報生成部 ＝＝＝＝＝ 
	xmlString += "<args>";

//<arg dim_seq='' key='' position='col1' dim_type='D'/>
//<arg dim_seq='' key='' position='edge1' dim_type='M'/> MはメジャーSeq（16でないやつ）

	// 列ヘッダ、行ヘッダ
	var colIdKeyArray = getIdKeyList( rightClickedCell, "COL" ).split(":");
	xmlString += getAxisInfoString("col", colIdKeyArray);

	var rowIdKeyArray = getIdKeyList( rightClickedCell, "ROW" ).split(":");
	xmlString += getAxisInfoString("row", rowIdKeyArray);

	// ページエッジで設定されているKeyリスト
	var pageAxes = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/PAGE/HierarchyID");
	var selectedMemberID = null;

	var tmpString = "";
	for ( var i=0; i<pageAxes.length; i++ ) {
		var axisID = pageAxes[i].text;
		var axis = axesXMLData.selectSingleNode("/root/OlapInfo/AxesInfo/HierarchyInfo[@id=\"" + axisID + "\"]");
		selectedMemberID = axis.selectSingleNode("DefaultMemberKey").text;
		if ( selectedMemberID == "NA" ) {
			selectedMemberID = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + axisID + "\"]//Member[1]/UName").text;
		}

		if ( i > 0 ) {
			tmpString += ":"
		}
		tmpString += axisID + "." + selectedMemberID;
	}
	var pageIdKeyArray = tmpString.split(":");
	xmlString += getAxisInfoString("page", pageIdKeyArray);

	xmlString += "</args>";

	// ＝＝＝＝＝ ドリル先レポート情報生成部 ＝＝＝＝＝
	xmlString += "<TargetReportInfo>";
		xmlString += "<TargetReportID>";
			xmlString += targetRepID;
		xmlString += "</TargetReportID>";
	xmlString += "</TargetReportInfo>";

	xmlString += "</OpenOLAP>";

//alert("ドリル先 レポートID:" + targetRepID + "\n" + xmlString);
	document.SpreadForm.argXmlHidden.value = xmlString;	// ドリルスルー情報XMLをhiddenに登録
	var newWin = window.open("flow/jsp/main/drill_arg.jsp?load=first","_blank","menubar=no,toolbar=no,width=700px,height=450px,resizable");


}


// ドリルスルー情報XMLの軸情報部の文字列を生成する
// 	targetEdge：対象とするエッジ（col,row,page）
// 	idKeyArray：軸IDおよびそのメンバーKey
//				軸				ディメンション もしくは メジャー）
//				軸				ID1～15：ディメンション、 16:メジャー
//				メンバーKey		ディメンションの場合：ディメンションメンバーのkey
//								メジャーの場合：メジャーメンバーのインデックス（1start）
function getAxisInfoString(targetEdge, idKeyArray) {

	var infoString = "";

	for ( var i=0; i<idKeyArray.length; i++){
		var pairArray = idKeyArray[i].split(".");
		var id  = pairArray[0];
		var key = pairArray[1];
		
		var type = "";
		var seq = "";
		if ( id == "16") {
			type = "M";

			var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + id + "\"]//Member[./UName=\"" + key + "\"]");
			seq = node.getAttribute("measureSeq");

		} else {
			type = "D";
			var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id=\"" + id + "\"]")
			seq = node.getAttribute("dimensionSeq");

		}

		infoString += "<arg dim_seq='" + seq + "' key='" + key + "' position='" + targetEdge + i + "' dim_type='" + type + "'/>"

	}
	return infoString;
}





