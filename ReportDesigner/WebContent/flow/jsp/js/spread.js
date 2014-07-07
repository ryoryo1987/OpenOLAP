	// =====================================================
	// 共通変数部
	// =====================================================
	// Object 格納用
	var spreadTable   = null;	// Spread配置用のTABLE要素
	var dataTableArea = null;	// データ表示部を囲むDIV要素
	var dataTable     = null;	// データ表示部のTABLE要素
	var colHeader     = null;	// 列ヘッダ表示部を囲むSPAN要素
	var rowHeader     = null;	// 行ヘッダ表示部を囲むSPAN要素

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

	// ============= 関数 =============================
	// 初期化関数
	function loadSpread() {

		// ======== 変数の初期化(全般) ========
		// オブジェクト
		spreadTable   = document.all("SpreadTable");
		dataTableArea = document.all("DataTableArea");
		dataTable     = dataTableArea.firstChild;
		colHeader     = document.all("ColumnHeaderArea");


		// ===== スクロールイベントとscrollView()との対応付け =====
		dataTableArea.onscroll = scrollView;

		// ===== 行ヘッダ、列ヘッダ、データ表示部の幅、高さを調整 =====
		resizeArea();
	}

	function scrollView() {
	//	rowHeader.scrollTop = dataTableArea.scrollTop;
		colHeader.scrollLeft= dataTableArea.scrollLeft;
	}

	function resizeArea() {
	// 行ヘッダ、列ヘッダ、データ表示部の幅をBODYサイズに合わせて変更する。

		if ( document.body.clientWidth != 0 ) {

		//	var newWidth  = ( document.body.clientWidth - rowHeader.offsetWidth ) * 0.9;
			var newWidth  = ( document.body.clientWidth);
//			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight - document.all("pageEdgeTable").offsetHeight - spreadTable.rows[0].offsetHeight - spreadTable.rows[1].offsetHeight ) * 0.9;
			var newHeight = ( document.body.clientHeight - colHeader.offsetHeight );

			// 行ヘッダ、データ表示部の幅および列ヘッダ、データ表示部の高さが
			// 負になった場合は、補正は行なわない
			if ( newWidth <= 0 ) {
				return;
			} else if ( newHeight <= 0 ) {
				return;
			}

			colHeader.style.width      = newWidth;
			dataTableArea.style.width  = newWidth;

		//	rowHeader.style.height     = newHeight;
			dataTableArea.style.height = newHeight;

			// 行・列ヘッダ、データテーブルのスクロール位置(X軸、Y軸)をあわせる
			scrollView();
		}
	}



// ============== 共通関数 ==================================================
	function getCOLIndexByCOLObj( headerCOLObj ) {
	// Input	:クロスヘッダ,列ヘッダのCOLオブジェクト
	//			（ID書式：CrossHeader_CGx,CH_CGx）
	// Output	：何列目かを表すIndex
		var strID     = headerCOLObj.id;
		var strGIndex = strID.lastIndexOf("G");
		var colIndex  = strID.substr(strGIndex + 1, strID.length - (strGIndex + 1));
		return colIndex;
	}

	function getColIndexByTDObj( headerTDObj ) {
	// Input	:行、列ヘッダのTDオブジェクト
	//			 (ID書式：RH_Rx_Cy、CH_Rx_Cy)
	// Output	:何列目かを表すIndex
		var strID     = headerTDObj.id;
		var strCIndex = strID.lastIndexOf("C");
		var colIndex  = strID.substr(strCIndex + 1, strID.length - (strCIndex + 1));
		return colIndex;
	}


