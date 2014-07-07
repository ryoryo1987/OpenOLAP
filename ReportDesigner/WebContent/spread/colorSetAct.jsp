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

	// データ構造

	// ＜レポートデータXMLより取得するデータ＞
	// colIDArray: 列に配置された軸IDリスト　例：1,3（）
	// rowIDArray: 行に配置された軸IDリスト　例：2	（レポートデータXMLより取得）

	// ＜色づけデータXMLより取得＞
	// axisIdArray：セルオブジェクトの位置する軸のIDリスト 例：1,2,3
	// memberKeyArray:セルオブジェクトの位置する軸メンバーのKeyリスト。
	// 				  axisIdArrayの格納する各軸のメンバー。	例：0,0,1
	//				  軸との対応付けは、同じ添字のaxisIdArrayの要素で行う。
	// 				 （レポートデータXMLでは「Member」要素の持つ「UName」要素の値）

	// ＜レポートデータXML、色づけデータXMLより取得＞
	// xmlIndexArray:memberKeyArrayをindexに変換したもの。	例：0,0,1
	// 				 （レポートデータXMLでは「Member」要素の「id」属性の値）
	//				  軸との対応付けは、同じ添字のaxisIdArrayの要素で行う。

	var axesXMLData = parent.parent.info_area.axesXMLData;	// レポート情報
	var colorXMLData = null;	// 色情報

	// *********************************************************
	//  初期化関数
	// *********************************************************

	// 色設定を実行
	function initialize() {

		// 色情報XMLのパス
		var loadXMLPath = "Controller?action=getColorInfo";

		// 色情報（XML）のロード
		colorXMLData = new ActiveXObject("MSXML2.DOMDocument");
		colorXMLData.async = false;
		colorXMLData.setProperty("SelectionLanguage", "XPath");
		var colorXMLResult = colorXMLData.load(loadXMLPath);


		// XML文書のロードに成功
		if (colorXMLResult) {

			// ヘッダー部の色づけ
			var hdrColors = colorXMLData.selectNodes("/ColorInfo/HeaderColor/Color");
			setColor(hdrColors, "header");
	
			// Spread部の色づけ
			var spreadColors = colorXMLData.selectNodes("/ColorInfo/SpreadColor/Color");
			setColor(spreadColors, "spread");
	
			// Spread部に値を挿入
			parent.parent.display_area.document.SpreadForm.action = "Controller?action=loadDataAct";
			parent.parent.display_area.document.SpreadForm.target = "loadingStatus";
			parent.parent.display_area.document.SpreadForm.submit();

		// XML文書のロードに失敗
		} else {
		
			// エラーメッセージを表示後、エラー画面を表示。
			showMessage("13", loadXMLPath);

			if(top.right_frm!=null) {
				top.right_frm.location.href="spread/error.jsp";
			} else {
				top.location.href="spread/error.jsp";
			}
		
		}

	}

	// *********************************************************
	//  色設定関数
	// *********************************************************

	function setColor(oColors, type) {
		// oColors: 色づけデータXMLのColorノードの配列
		// type: header, spread

		// oColors のループ start
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


			// 色づけXMLより取得したセル情報より、そのセルオブジェクトを求める
			// 対応するセルオブジェクトが存在しない場合は、nullを返す
			//   function: TDオブジェクト or null
			var oTD = getCellByAxisIDAndMemKey(axisIdArray, memberKeyArray, type);

			// 色づけ
			if ( oTD != null ) {

				// 色づけ
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
				parent.parent.display_area.coloredCellList.add( oTD.id, oTD );	// 色づけセルリストを更新
			} else {
				// 色づけ不能セルリストを更新

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

		// エッジの最下段以外の段に色情報を設定
		if ( type == "header" ) {
			setUpperHieColor("COL");
			setUpperHieColor("ROW");
		}

	}

	// エッジの最下段以外の段に色情報を設定
	function setUpperHieColor(target) {
	// <input>  target:"COL" or "ROW"
	// <output> void

		var colHie0Cells = null;	// 列の段インデックス0の色づけ対象セルリスト
		var rowHie0Cells = null;	// 行の段インデックス0の色づけ対象セルリスト
		var colHie1Cells = null;	// 列の段インデックス1の色づけ対象セルリスト
		var rowHie1Cells = null;	// 行の段インデックス1の色づけ対象セルリスト

		// 段数＝１の場合、return
		if ( parent.parent.display_area.getHeaderObjNum(target) == 1 ) { return; }

		// 段数＝２以上の場合
		if ( parent.parent.display_area.getHeaderObjNum(target) >= 2 ) {

			// 色づけ済みのセルリストをspread index順に取得する
			var edgeColoredCellArray = sortCellsByIndex(parent.parent.display_area.coloredCellList, target);

//var str = "";
//for ( var i = 0; i < edgeColoredCellArray.length; i++ ) {
//	str += edgeColoredCellArray[i].id + "\n";
//}
//alert(str);

			// 色づけ実行
			var edgeHie1Cells = setColorToUpperCell(target, edgeColoredCellArray);

			// 段数＝３の場合
			if ( parent.parent.display_area.getHeaderObjNum(target) == 3 ) {
				// 色づけ実行
				if (edgeHie1Cells != null) {
					if (edgeHie1Cells.length != 0) {
						var edgeHie0Cells = setColorToUpperCell(target, edgeHie1Cells);
					}
				}
			}
		}
	}

	// 与えられた同じ階層のセルリストに対し、その部分集合が同じ上段セルを持ち、かつ
	// 同じ色である場合、その上段セルの色づけを行い、そのリストを返す
	function setColorToUpperCell(target, cellArray) {
	// <Input>  target:COL or ROW
	//			cellArray:spread indexで昇順にソートされたセルリスト
	// <Output> ヘッダーセルのTDオブジェクトの配列

		if ( cellArray == null ) { return null; }

		var upperCellArray = new Array();	// 上段セルの集合
		var startColor = null;	// ある上段に属する領域内で、先頭セルより色づけされたセルの色
								// 色づけされていないセルがある、異なる色づけがされていた場合はnull
		var beforeIndex = -1;	// 一つ前に実行した色づけセルのインデックス
								// 一つ前に実行したセルと現在実行中のセルの間にセルが無いことを確認する
		var beforeCell = null;

		var upperCellArrayIndex = 0;

		for ( var i = 0; i < cellArray.length; i++ ) {
			var cell = cellArray[i];

			// ある上段に属する領域内で連続したセルかつ同じ色であるかどうかを確認
			if ( parent.parent.display_area.isStartPartCell(cell) ) {	// ある上段に属する領域内の開始セル

				startColor = cell.colorName;
				beforeIndex = getSpreadIndexByTDObj(cell);
				beforeCell = cell;
			} else { // ある上段に属する領域内の開始セルではない
				if ( startColor == null ) { // 領域内の開始セルから順に確認中ではない
					continue;
				} else { // 領域内で開始セルから順に確認中

					var lowerComboNum = parent.parent.display_area.getLowerHieComboNumByIndex(target, getHieIndex(cell));

					if ( (beforeIndex + (1*lowerComboNum)) != getSpreadIndexByTDObj(cell) ) {	// 前回実行セルの直後でない
						startColor = null;
						beforeIndex = -1;
						beforeCell = null;
						continue;
					} else {	// 前回実行セルの直後(＝連番)
						if ( startColor != cell.colorName ) { 	// 実行中のセル色が違う色
							startColor = null;
							beforeIndex = -1;
							beforeCell = null;
							continue;
						} else {	// 実行中のセル色が同じ色
							beforeIndex = getSpreadIndexByTDObj(cell);
							beforeCell = cell;
						}
					}
				}
			}

			//実行中のセルがある上段に属する領域内の最終セルの場合、上段のオブジェクトを取得し、色づけ
			if ( ( startColor != null ) && (parent.parent.display_area.isEndPartCell(cell)) ) {
				var upperCell = parent.parent.display_area.getUpperCellObject(cell, target);

				// 色づけ
				upperCell.colorName = startColor;
				upperCell.style.backgroundColor = associationColorArray["hdr" + startColor];

				// 色づけセルリストを更新
				parent.parent.display_area.coloredCellList.add( upperCell.id, upperCell );

				upperCellArray[upperCellArrayIndex] = upperCell;	// 色づけしたセルを配列に格納
				upperCellArrayIndex++;

				// 初期化
				startColor = null;
				beforeIndex = -1;
			}
		}

		return upperCellArray;
	}




	// セルリストを指定されたエッジにより絞込み、spread index順にソートする
	function sortCellsByIndex(cellObjDic, target) {
	// <input>  cellObjDic:エッジセル(TD)のidとオブジェクトを格納したDictionaryオブジェクト
	//			target:"COL" or "ROW" or null
	//			       ※nullの場合、エッジによる絞込みを行わない
	// <output> セルオブジェクトを絞り込み、ソートした配列

		if (cellObjDic == null) { return null; }
		if (cellObjDic.Count == 0) { return null; }

		var edgeCellArray = new Array();

		var cellObjArray = (new VBArray(cellObjDic.Items())).toArray();
		var edgeCellIndexIdDic = new ActiveXObject("Scripting.Dictionary");

		for ( var i = 0; i < cellObjArray.length; i++ ) {
			var oCell = cellObjArray[i];

			if ((!isCellInColHeader(oCell)) && (!isCellInRowHeader(oCell))) { return null; }

			if ( target != null ) {	// targetが指定されていた場合、絞り込む
				if ( getCellPosition(oCell) == target ) {
					edgeCellIndexIdDic.add(parseInt(getSpreadIndexByTDObj(oCell)), oCell.id);
				}
			} else {
				edgeCellIndexIdDic.add(parseInt(getSpreadIndexByTDObj(oCell)), oCell.id);
			}

		}

		var edgeIndexArray = (new VBArray(edgeCellIndexIdDic.Keys())).toArray();
		edgeIndexArray.sort(sortAsNumberASC);	// 配列を数値の昇順でソート


		for ( var i = 0; i < edgeIndexArray.length; i++ ) {
			var id = edgeCellIndexIdDic.Item(edgeIndexArray[i]);	// id
			edgeCellArray[i] = cellObjDic.Item(id);	// nodeの配列を生成
		}

		return edgeCellArray;
	}


	// *********************************************************
	//  内部データ構造捜査関数
	// *********************************************************

	// 軸IDと、その軸メンバのKey(UName)に対応する、行/列エッジセルのオブジェクトを返す
	// （ヘッダー部のオブジェクトを要求され、かつヘッダーが複数段ある場合は最下層を返す）
	// <Input>  axisIdArray:軸のID
	//		    memberKeyArray:軸のメンバのKey(UName)
	//		    type: "header" or "spread"
	// <Output> oTD: 取得したTDオブジェクト
	function getCellByAxisIDAndMemKey(axisIdArray, memberKeyArray, type) {

		// 行・列の軸IDリスト
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

		// メンバーKey(UName)をXMLインデックス(id)に変換
		var xmlIndexArray = new Array();
			for ( var i = 0; i < axisIdArray.length; i++ ) {
				var node = axesXMLData.selectSingleNode("/root/Axes/Members[@id = " + axisIdArray[i]  + "]//Member[./UName=" + memberKeyArray[i] + "]");
				if ( node == null ) {	// 色づけを要求されたノードが、レポート情報を保持するXML中に存在しない
										// （セレクタ使用時）
					return null;
				}
				xmlIndexArray[i] = node.attributes[0].value;
			}

		var oTD = null;
		if ( type == "header" ) {
			// 色表示の対象エッジを求める
			var target = null;
			var idArray = null;
			if( hasSame2Axes(axisIdArray, colIDArray, null) ) {
				target = "COL";
				idArray = colIDArray;
			} else if( hasSame2Axes(axisIdArray, rowIDArray, null) ) {
				target = "ROW";
				idArray = rowIDArray;
			} else {	// 色表示対象エッジが無い
				return null;
			}

			// 色づけ対象となるセルオブジェクトを求める
			var targetHdr = "";
			var colSpreadIndex = null;
			var rowSpreadIndex = null;
				if ( target == "COL" ) {
					targetHdr = "CH";
					colSpreadIndex = getSpreadIndex(target, colIDArray, axisIdArray, xmlIndexArray);
					rowSpreadIndex = colIDArray.length-1;	// 列の最終段のhieIndex
				} else if ( target == "ROW" ) {
					targetHdr = "RH";
					colSpreadIndex = rowIDArray.length-1;	// 行の最終段のhieIndex
					rowSpreadIndex = getSpreadIndex(target, rowIDArray, axisIdArray, xmlIndexArray);
				}
			oTD = parent.parent.display_area.document.getElementById(targetHdr + "_R" + rowSpreadIndex + "C" + colSpreadIndex);
		} else if ( type == "spread" ) {

			// Colエッジ、Rowエッジの組み合わせを確認する
			if( !hasSame2Axes(axisIdArray, colIDArray, rowIDArray ) ) {
				return null;
			}

			// Col、Row のSpreadIndexを求める
			var colSpreadIndex = getSpreadIndex("COL", colIDArray, axisIdArray, xmlIndexArray);
			var rowSpreadIndex = getSpreadIndex("ROW", rowIDArray, axisIdArray, xmlIndexArray);

			// セルを求める
			oTD = parent.parent.display_area.document.getElementById("DC_R" + rowSpreadIndex +"C" + colSpreadIndex );
			
		}

		return oTD;
	}

	// エッジの持つ軸IDリスト(edgeIDs)を元に、そのエッジのSpreadIndexを求める
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

	// edgeIDに対応した、XMLIndexを取得し返す
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
	//  ユーティリティ関数
	// *********************************************************

	// Arrayオブジェクトの数値順でソートするためのメソッド
	function sortAsNumberASC(a, b) {
		return a-b;
	}


</script>
