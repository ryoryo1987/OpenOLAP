<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.ArrayList,java.util.Iterator,openolap.viewer.Report,openolap.viewer.Dimension,openolap.viewer.common.Constants"
%><html>
	<head>
		<title>セレクタ</title>
		<link rel="stylesheet" type="text/css" href="./css/common.css">
	</head>
	<body onload='changeDim("onload")' onselectstart="return false">
		<form name="frm_main" method="post" id="frm_main">
	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">セレクタ
			</td>
		</tr>
	</table>
<div style="margin:15">
<span class="title">ﾃﾞｨﾒﾝｼｮﾝ/ﾒｼﾞｬｰ名：</span>
<select id='dimList' name='dimList' onchange='javaScript:changeDim("dimChange");'>

<%
	int i = 0;
	String measureID = Constants.MeasureID;

	Report report = (Report)session.getAttribute("report");
	String targetAxisID = (String)request.getParameter("targetAxisID");

	// 要求された軸IDをデフォルト選択として、ディメンション/メジャー選択リストを作成
	String selectedString = "";
	if ( measureID.equals(targetAxisID) ) {
		selectedString = "selected=true";
	}
	out.println("<option value=''  id='" + measureID + "' " +selectedString+ ">メジャー</option>");
	for ( i=0; i < report.getTotalDimensionNumber(); i++ ) {
		Dimension dim = (Dimension) report.getAxisByID(Integer.toString(i+1));
		selectedString = "";
		if ( String.valueOf(i+1).equals(targetAxisID) ) {
			selectedString = "selected=true";
		}
		out.println("<option value='' id='" + (i+1) + "'" +selectedString+ ">" + dim.getName() + "</option>");
	}
%>
</select>

<span id="dimMemberNameTypeArea" style="display:none">
	<span class="title">メンバー名表示：</span>
	<select id="dimMemberNameType" onchange='javaScript:changeDimMemNameType(this)'>
<%

		// ディメンションのメンバ状況表示情報を生成
		ArrayList dimMemberDispTypeList = new ArrayList();
		for ( i=0; i < report.getTotalDimensionNumber(); i++ ) {
			Dimension dim = (Dimension) report.getAxisByID(Integer.toString(i+1));
			dimMemberDispTypeList.add(dim.getId() + ":" + dim.getDispMemberNameType());
		}
		String dimMemberDispTypesString = "";
		Iterator it = dimMemberDispTypeList.iterator();
		i = 0;
		while (it.hasNext()) {
			if ( i > 0 ) {
				dimMemberDispTypesString += ",";
			}
			dimMemberDispTypesString += (String) it.next();
			i++;
		}

		out.println("<option name='" + Dimension.DISP_SHORT_NAME + "'>ショートネーム</option>");
		out.println("<option name='" + Dimension.DISP_LONG_NAME + "'>ロングネーム</option>");

%>
	</select>
</span>

</div>

<!-- Selecter Body部に表示を要求する軸のID -->
<input type='hidden' name='dimNumber' value=''>

		</form>

		<!-- ディメンション/メジャー毎のメンバのKEY・ドリル情報格納用エリア -->
		<div id="statusArea" style="display:none">
			<div id="1"></div>
			<div id="2"></div>
			<div id="3"></div>
			<div id="4"></div>
			<div id="5"></div>
			<div id="6"></div>
			<div id="7"></div>
			<div id="8"></div>
			<div id="9"></div>
			<div id="10"></div>
			<div id="11"></div>
			<div id="12"></div>
			<div id="13"></div>
			<div id="14"></div>
			<div id="15"></div>
			<div id="16"></div>
		</div>

		<!-- 「ディメンション/メジャー名」リストボックスの切り替え前の値（軸ID） -->
		<div id="beforeDimArea" style="display:none">
			<div id="beforeDimID"><%= measureID %></div>
		</div>

		<!-- メジャータイプ -->
		<div id="measureTypeArea" style="display:none">
			<div id="measureType"></div>
		</div>

		<!-- ディメンションのメンバー名の表示タイプ -->
		<div id="dimMemDispTypeArea" style="display:none">
			<div id="dimMemDispTypes"><%= dimMemberDispTypesString %></div>
		</div>

	</body>
</html>
<script>

var measureID = <%= measureID %>

function changeDim( source ) {

	// 軸ID
	var dimID = document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id;

	// ディメンションメンバ表示名称タイプ選択欄を初期化
	if ( dimID != measureID ) {	// メジャー
		initDimMemDispTypeSelection();
	}

	// ディメンションメンバの表示名選択欄の表示/非表示切替
	if ( dimID == measureID ) {	// メジャー
		document.all("dimMemberNameTypeArea").style.display = "none";
	} else {	// ディメンション
		document.all("dimMemberNameTypeArea").style.display = "";
	}

	if ( source == "dimChange" ) {

		// 現在、設定中のディメンション/メジャーのメンバ状態を保存
		var ret = parent.frm_body.setSelectedList( document.all("beforeDimID").innerText, "dimChange" );
		if ( ret == -1 ) {
			// ディメンション/メジャー選択欄の選択を元に戻す
			var dimListOptionArray = document.frm_main.dimList.options;
			for ( var i = 0; i < dimListOptionArray.length; i++ ) {
				if ( dimListOptionArray[i].id == document.all("beforeDimID").innerText ) {
					dimListOptionArray[i].selected = true;
				} else {
					dimListOptionArray[i].selected = false;
				}
			}
			return false;
		}

	} else if ( source == "onload" ) {

		// ディメンションメンバの表示名選択欄の表示/非表示切替
		if ( dimID == measureID ) {	// メジャー
			document.all("dimMemberNameTypeArea").style.display = "none";
		} else {	// ディメンション
			document.all("dimMemberNameTypeArea").style.display = "";
		}

		// エッジ配置情報を取得
		// （行･列･ページに配置されたディメンション/メジャーIDリスト）

// Modal Dialog
//		var axesXMLData = parent.window.opener.parent.info_area.axesXMLData;
		var axesXMLData = window.dialogArguments[1];

		var colIDString = "";
		var rowIDString = "";
		var pageIDString = "";

		var colIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/COL/HierarchyID");
		for ( i = 0; i < colIDs.length ; i++ ) {
			if ( colIDString == "" ) {
				colIDString =  colIDs[i].text;
			} else {
				colIDString += "," + colIDs[i].text;
			}
		}
		var rowIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/ROW/HierarchyID");
		for ( i = 0; i < rowIDs.length ; i++ ) {
			if ( rowIDString == "" ) {
				rowIDString =  rowIDs[i].text;
			} else {
				rowIDString += "," + rowIDs[i].text;
			}
		}
		var pageIDs = axesXMLData.selectNodes("/root/OlapInfo/AxesInfo/PAGE/HierarchyID");
		for ( i = 0; i < pageIDs.length ; i++ ) {
			if ( pageIDString == "" ) {
				pageIDString =  pageIDs[i].text;
			} else {
				pageIDString += "," + pageIDs[i].text;
			}
		}

		// 現在表示中の軸メンバのIDとドリル状態を設定
		var axes = axesXMLData.selectNodes("/root/Axes/Members");
		var statusArea = document.all("statusArea");
		for ( i = 0; i < axes.length; i++ ) {
			var axisInfo = "";
			var axisMembers = axes[i].selectNodes(".//Member");
			for ( var j = 0; j < axisMembers.length; j++ ) {
				var key = axisMembers[j].selectSingleNode("UName").text;
				var isDrilledString = axisMembers[j].selectSingleNode("isDrilled").text;
				var isDrilled = null;
				if ( isDrilledString == "true" ) {
					isDrilled = "1";
				} else {
					isDrilled = "0";
				}

				if ( j > 0 ) {
					axisInfo += ",";
				}
				axisInfo += key + ":" + isDrilled;
//alert("axis" + i + "," + key + "," + isDrilledString + "," + isDrilled);
			}

			var axisIndex = null;
			if ( i != axes.length-1 ) {
				axisIndex = i;
			} else {
				axisIndex = 15;
			}
			statusArea.childNodes[axisIndex].innerText = axisInfo;
		}
	}

    // 現在のdimIDを保存
	document.frm_main.dimNumber.value = dimID;

	// 現在のdimIDを次回のディメンション/メジャー名切り替え時に使用するために一時保存
	document.all("beforeDimID").innerText = dimID;

	document.frm_main.action = "Controller?action=displaySelecterBody&dispMemNameType=" + getDimMemNameTypeByDimID( dimID );
	document.frm_main.target = "frm_body";
	document.frm_main.submit();

}

// ディメンションのメンバ名の表示タイプ選択欄のデフォルト表示値を設定
function initDimMemDispTypeSelection() {

	var dimMemDispType = getDimMemNameTypeByDimID( document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id );

	var dimMemOptionArray = document.frm_main.dimMemberNameType.options;
	for ( var i = 0; i < dimMemOptionArray.length; i++ ) {
		if ( dimMemOptionArray[i].name == dimMemDispType ) {
			dimMemOptionArray[i].selected = true;
		} else {
			dimMemOptionArray[i].selected = false;
		}
	}
}

function changeDimMemNameType( obj ) {
// ディメンションのメンバの表示名タイプが変更された時に呼び出され、
// セレクタで表示されているメンバの表示名タイプを変更し、選択された値をDIVに仮保存

	var dimMemDispTypeArray = document.getElementById("dimMemDispTypeArea").firstChild.innerText.split(",");
	var selectedDimID = document.frm_main.dimList.options[document.frm_main.dimList.selectedIndex].id;
	var selectedDimMemDispType = document.frm_main.dimMemberNameType.options[document.frm_main.dimMemberNameType.selectedIndex].name;

	// 選択されたメンバの表示名タイプに従い、メンバ表示名を切り替え
	parent.frm_body.changeDisplayName(selectedDimMemDispType);

	// 選択されたメンバの表示名タイプをDIVに仮保存
	for ( var i = 0; i < dimMemDispTypeArray.length; i++ ) {
		// dimMemDispTypeArray[i].split(":")[0]: ディメンションID
		// dimMemDispTypeArray[i].split(":")[1]: ディメンションのメンバ表示名タイプ

		var dimMemDispTypeIDValue = dimMemDispTypeArray[i].split(":")
		if ( selectedDimID == dimMemDispTypeIDValue[0] ) {
			dimMemDispTypeIDValue[1] = selectedDimMemDispType;
			dimMemDispTypeArray[i] = dimMemDispTypeIDValue.join(":");
		}
	}

	document.getElementById("dimMemDispTypeArea").firstChild.innerText = dimMemDispTypeArray.join(",");
}

function getDimMemNameTypeByDimID( dimId ) {
// 与えられたディメンションIDに対する表示名タイプを返す
// (クライアント側で仮設定(DIV)されている値)

	var dimMemDispTypeArray = document.getElementById("dimMemDispTypeArea").firstChild.innerText.split(",");
	for ( var i = 0; i < dimMemDispTypeArray.length; i++ ) {
		// dimMemDispTypeArray[i].split(":")[0]: ディメンションID
		// dimMemDispTypeArray[i].split(":")[1]: ディメンションのメンバ表示名タイプ

		var dimMemDispTypeIDValue = dimMemDispTypeArray[i].split(":")
		if ( dimId == dimMemDispTypeIDValue[0] ) {
			return dimMemDispTypeIDValue[1];
		}
	}
}

</script>
