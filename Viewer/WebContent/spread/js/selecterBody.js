
// セレクタボディ部の初期化
function initialize() {

	// ===== 変数群初期設定 =====

	// ディメンション情報XMLのパス
	var loadXMLPath = "Controller?action=getAxisMemberInfoByAxisID&axisID=" + dimNumber;

// Modal Dialog
//	spreadXMLData = parent.window.opener.parent.info_area.axesXMLData;
	spreadXMLData = window.dialogArguments[1];
	if ( dimNumber!=16 ) {
		axisMemberXMLData =  new ActiveXObject("MSXML2.DOMDocument");
		axisMemberXMLData.async = false;
		var result = axisMemberXMLData.load(loadXMLPath);

		if (!result) {
		
			// エラーメッセージを表示
			showSelecterMessage('1', loadXMLPath);
			
			// セレクタウインドウをクローズ
			parent.window.close();
		
		}

	}

	// 設定中の軸のメンバ情報(選択されたか、ドリル状態)
	var statusArea = parent.frm_header.document.all("statusArea");

	// メンバのスタイルを調整(表示・非表示、ドリル)

	// メンバとそのドリルステータスを格納する連想配列を生成
	var selectedInfoList = statusArea.all( dimNumber ).innerText;
	settingArray = selectedInfoList.split(",");
	associationKeyDrill = new Array();
	for ( var i = 0; i < settingArray.length; i++ ) {
		var tmpArray  = settingArray[i].toString().split(":");
		// tmpArray[0]: KEY
		// tmpArray[1]: ドリルステータス
		associationKeyDrill[tmpArray[0]] = tmpArray[1];
	}

	adjustMemberStyle(tab1, associationKeyDrill, "selectable");
	adjustMemberStyle(tab2, associationKeyDrill, "selected");

	// メジャーメンバータイプのイメージを設定
	if ( dimNumber == "16" ) {	// メジャー
		if ( parent.frm_header.document.all("measureTypeArea").firstChild.innerText != "" ) {

			var measureTypeArray = parent.frm_header.document.all("measureTypeArea").firstChild.innerText.split(",");
			for(i=0;i<tab2.childNodes.length;i++){
				node = tab2.childNodes[i];
				// measureTypeArray[i].split(":")[0]: メジャーID
				// measureTypeArray[i].split(":")[1]: メジャータイプID

				node.firstChild.firstChild.style.backgroundImage = getMeasureTypeImageURLByID( measureTypeArray[i].split(":")[1] );
				var measureTypeNameArray = getMeasureTypeNameArray();
				node.firstChild.firstChild.title = measureTypeNameArray[getMeasureTypeIndexByID(measureTypeArray[i].split(":")[1])];
			}
		}
	}


	// 初期化処理が終わったのでメンバー選択欄を表示状態にする
	tab1.style.visibility = "visible";
	tab2.style.visibility = "visible";


}

// メンバースタイルを調整(表示・非表示、ドリル)
function adjustMemberStyle( tab, associationKeyDrill, target ) {
	for(i=0;i<tab.childNodes.length;i++){

		var sourceNode = tab.childNodes[i];
		var sourceNodeKey   = sourceNode.id;	// sourceNode のID(XML:UName)

		// 今回起動されたセレクタで既に設定されたメンバの状態をもとに、メンバのスタイルを決定する

		// 対応するメンバーが存在する
		if ( associationKeyDrill[sourceNodeKey] != null ) {

			if ( ( associationKeyDrill[sourceNodeKey] == "1" && sourceNode.firstChild.firstChild.toggle == "p" ) ||
				 ( associationKeyDrill[sourceNodeKey] == "0" && sourceNode.firstChild.firstChild.toggle == "m" )
			   ) {

				setCellDrillStatusUp(sourceNode);
			}

		// 対応するメンバーが存在しない
		} else {
			if ( target == "selectable" ) {
				// ドリル未の状態とする
				setCellDrillStatusUp(sourceNode);
			} else if ( target == "selected" ) {
				// 非表示にする
				removeNode(sourceNode);
			}
		}

		// メンバのドリルによる表示/非表示を調整
		dispCheck(sourceNode);

	}
}

// =============================================================================
//  メンバ操作（ドリル）
// =============================================================================
//トグルボタン押下処理
function clickToggle(th){
	var thisTr = th.parentNode.parentNode;
	var tbl = thisTr.parentNode;

	//子孫を全て取得する
	var arrChildIndex = getDescendantIndexes(dimNumber,thisTr.id,"all");

	if(th.toggle=="p"){
		th.toggle="m";
		th.innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
		for(i=0;i<arrChildIndex.length;i++){
		//	tbl.childNodes[arrChildIndex[i]].dispflg="1";
			dispCheck(tbl.childNodes[arrChildIndex[i]]);
		}
	}else if(th.toggle=="m"){
		th.toggle="p";
		th.innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
		for(i=0;i<arrChildIndex.length;i++){
		//	tbl.childNodes[arrChildIndex[i]].dispflg="0";
			dispCheck(tbl.childNodes[arrChildIndex[i]]);
		}
	}else if(th.toggle=="n"){
		return;
	}
}

// セルをドリルアップにする
function setCellDrillStatusUp(sourceNode) {
	if(sourceNode.firstChild.childNodes[0].toggle=="m"){
		sourceNode.firstChild.childNodes[0].toggle="p";
		sourceNode.firstChild.childNodes[0].innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
	}
}

// =============================================================================
//  メンバ操作（ドリルダウン関連、メンバ取得)
// =============================================================================

	// 子孫のインデックスリストを取得
	function getDescendantIndexes(dimID, memberID, flg) {
		var indexArray = new Array();

		if (axisMemberXMLData != null) {
			var targetNode = axisMemberXMLData.selectSingleNode("/Members[@id = " + dimID + "]//Member[./UName=" + memberID + "]");
			if (targetNode != null) {
				if(flg=="all"){
					var childNodes = targetNode.selectNodes(".//Member");
				}else if(flg=="child"){
					var childNodes = targetNode.selectNodes("./Member");
				}
				for(var i = 0; i < childNodes.length; i++ ) {
					var node = childNodes[i];
					indexArray[i] = node.selectSingleNode("@id").value;
				}
			}
		}

		return indexArray;
	}


	// 親のインデックスリストを取得
	function getParentIndex(dimID, memberID) {
		var parentIndex = null;

		if (axisMemberXMLData != null) {
			var targetNode = axisMemberXMLData.selectSingleNode("/Members[@id = " + dimID + "]//Member[./UName=" + memberID + "]");
			if (targetNode == null) { return null; }
			var parentNode = targetNode.parentNode;
			if ( parentNode == null ) { return null; }

			if ( parentNode.nodeName == "Members" ) { // 最上位レベルのノード
				parentIndex = null;
			} else { // 最上位レベル以外のノード
				parentIndex = parentNode.selectSingleNode("@id").value;
			}
		}

		return parentIndex;
	}


// =============================================================================
//  メンバ操作（メンバ選択）
// =============================================================================
//クリックされたメンバーを選択状態にする

var preClickTr;

function clickName( th ) {
	var thisTr = th.parentNode.parentNode;
	var tbl = thisTr.parentNode;

	//SHIFTキーが押下されている場合の処理
	if ( event.shiftKey == true ) {
		if(preClickTr==null){return;};
		var preNum  = preClickTr.index;
		var nodeNum = thisTr.index;
		if ( preNum == nodeNum ) {//プレobjとクリックobjが同じ場合
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;
		}else{//プレobjとクリックobjが異なる場合はその範囲を取得
			if ( parseInt(preNum) < parseInt(nodeNum) ) {
				fromNum=parseInt(preNum);
				toNum=parseInt(nodeNum);
			} else {
				fromNum=parseInt(nodeNum);
				toNum=parseInt(preNum);
			}
		}

		for(i=fromNum;i<=toNum;i++){
			if(tbl.childNodes[i].exist=="1"){//メンバーとして存在するかをチェック
				//セレクト状態にする
				tbl.childNodes[i].selected="1";
				tbl.childNodes[i].style.background = selectedMemberColor;
			}
		}

		//Toobjがプラスの場合は子供も選択状態にする
		if(tbl.childNodes[toNum].firstChild.childNodes[0].toggle=="p"){
			var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[toNum].id,"all");
			for(i=0;i<arrChildIndex.length;i++){
				if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//メンバーとして存在するかをチェック
					if(tbl.childNodes[arrChildIndex[i]].selected=="0"){;
						tbl.childNodes[arrChildIndex[i]].selected="1";
						tbl.childNodes[arrChildIndex[i]].style.background = selectedMemberColor;
					}
				}
			}
		}


		return;

	//SHIFTキーが押下されていない場合の処理
	}else{

		preClickTr = thisTr;//プレobjをセット



		var arrChildIndex = getDescendantIndexes(dimNumber,thisTr.id,"all");

		//メンバーとして持つ子供の数を調べる
		var childCount=0;
		for(i=0;i<arrChildIndex.length;i++){
			if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//メンバーとして存在するかをチェック
				childCount++;
			}
		}


		if((thisTr.selected=="0")&&(thisTr.firstChild.childNodes[0].toggle!="p")){//未選択かつプラス以外の場合は②③の処理を行わない
			//①セレクト状態にする
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;
		}else if((thisTr.selected=="0")&&(thisTr.firstChild.childNodes[0].toggle=="p")&&(childCount==0)){//未選択かつプラスかつ子供メンバー数が0の場合は②③の処理を行わない
			//①セレクト状態にする
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;

		}else{
			//①セレクト状態にする
			thisTr.selected="1";
			thisTr.style.background = selectedMemberColor;


			var colorChangeCount=0;
			if(arrChildIndex.length!=0){
				//②色がついていない子供がいる場合は、色を付ける
				for(i=0;i<arrChildIndex.length;i++){
					if(tbl.childNodes[arrChildIndex[i]].exist=="1"){//メンバーとして存在するかをチェック
						if(tbl.childNodes[arrChildIndex[i]].selected=="0"){;
							tbl.childNodes[arrChildIndex[i]].selected="1";
							tbl.childNodes[arrChildIndex[i]].style.background = selectedMemberColor;
							colorChangeCount++;
						}
					}
				}
			}


			if(colorChangeCount==0){//③色がつかなければ全選択をリセット
				thisTr.selected="0";
				thisTr.style.background = unSelectedMemberColor;
				//子供がある場合は子供も色を消す
				if(arrChildIndex.length!=0){
					for(i=0;i<arrChildIndex.length;i++){
						tbl.childNodes[arrChildIndex[i]].selected="0";
						tbl.childNodes[arrChildIndex[i]].style.background = unSelectedMemberColor;
					}
				}
			}

		}

	}

}

// =============================================================================
//  メンバ操作（表示・非表示の切り替え）
// =============================================================================

//表示・非表示を切り替える
function dispCheck(trObj){

//	if(trObj.exist==1&&trObj.dispflg=="1"){//表示する為には「メンバーが存在」＆「展開されている」が前提条件
	if(trObj.exist==1){//表示する為には「メンバーが存在」が前提条件
		var parentPlusFlg=false;

		//親が展開されていない場合は表示してはいけないので、さかのぼって先祖に表示されている「+」メンバーがあるかどうかを取得する
		if(getParentIndex(dimNumber,trObj.id)!=null){
			var parentTr=trObj.parentNode.childNodes[getParentIndex(dimNumber,trObj.id)];
			var k=0;
			while(true){
				k++;
				if(parentTr==null){
					break;
				}
				if((parentTr.firstChild.childNodes[0].toggle=="p")&&(parentTr.style.display=="block")){
					parentPlusFlg=true;
					break;
				}
				if(getParentIndex(dimNumber,parentTr.id)!=null){
					parentTr=parentTr.parentNode.childNodes[getParentIndex(dimNumber,parentTr.id)];
				}else{
					break;
				}
			}
		}

		if(parentPlusFlg){
			trObj.style.display="none";//非表示（先祖に表示されている「+」メンバーあり）
		}else{
			trObj.style.display="block";//表示（先祖に表示されている「+」メンバーなし）

			//追加されるメンバーの親メンバーをマイナスに切り替える
			if(getParentIndex(dimNumber,trObj.id)!=null){
				var parentObj = trObj.parentNode.childNodes[getParentIndex(dimNumber,trObj.id)];
				parentObj.firstChild.childNodes[0].toggle="m";
			//	parentObj.firstChild.childNodes[0].innerHTML="-";
				parentObj.firstChild.childNodes[0].innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
			}
		}
//	}else{//「メンバーが存在」＆「展開されている」前提条件を満たせていない場合
	}else{//「メンバーが存在」前提条件を満たせていない場合
		trObj.style.display="none";//非表示
	}

}

// =============================================================================
//  メンバ操作（置換）
// =============================================================================
//置換ボタン
function replace(){
	var selectedRowNum=0;
	for(i=0;i<tab1.childNodes.length;i++){
		if(tab1.childNodes[i].selected=="1"){
			selectedRowNum++;
		}
	}
	if(selectedRowNum==0){//左側に選択メンバーがいなければ何も行わない
		return;
	}

	remove(2);
	add();
}

// =============================================================================
//  メンバ操作（追加）
// =============================================================================

//追加ボタン
function add() {
	for(i=0;i<tab1.childNodes.length;i++){
		if(tab1.childNodes[i].selected=="1"){
			tab2.childNodes[i].exist="1";
		//	tab2.childNodes[i].selected="1";
			dispCheck(tab2.childNodes[i]);
			tab1.childNodes[i].selected="0";
			tab1.childNodes[i].style.background=unSelectedMemberColor;

		}
	}
}

// =============================================================================
//  メンバ操作（削除）
// =============================================================================

//削除ボタン
function remove(mode){
	if(mode==1){
		for(i=0;i<tab2.childNodes.length;i++){
			if(tab2.childNodes[i].selected=="1"){
				removeNode(tab2.childNodes[i]);
			}
		}
	}else if(mode==2){
		for(i=0;i<tab2.childNodes.length;i++){
			removeNode(tab2.childNodes[i]);
		}
	}
}

//削除処理
function removeNode(node) {
	//	node.dispflg="0";
		node.exist="0";
		node.selected="0";
		node.style.background=unSelectedMemberColor;
		dispCheck(node);
}


// =============================================================================
//  メンバ操作（メジャータイプの変更）
// =============================================================================

// メジャータイプ選択ボックスの表示
function makeMeasureTypeSelecter( imgNode ) {
	if ( imgNode.nextSibling.tagName == "SELECT" ) { 
		removeSelecter( imgNode );
		return; 
	}

	if (document.frm_main.measureType != null) { // 既にメジャータイプ選択ボックスが表示中 ならば、終了
		return;
	}

	var oSelect = document.createElement("<select id='measureType' onchange='changeMeasureType(this)'>");
	var measureTypeNameArray = getMeasureTypeNameArray();
	var oOption;

// previousSibling のIMG URLよりIDを取得
// getMeasureTypeIndex(imgNode.previousSibling.style.backgroundImage)
// selected=true を付与
	var currentMeasureTypeID = getMeasureTypeIndex(imgNode.style.backgroundImage);
	for ( var i = 0; i < measureTypeNameArray.length; i++ ) {
		var selectedString = "";
		if ( i == currentMeasureTypeID) {
			selectedString = " selected=true";
		}
		oOption = document.createElement("<option" + selectedString + ">");
		oOption.innerText = measureTypeNameArray[i];
		oSelect.appendChild(oOption);
	}
	imgNode.insertAdjacentElement('afterEnd',oSelect);
}

// メジャータイプが変更された
function changeMeasureType( oSelect ) {
	// メジャータイプのイメージ,タイトルを変更
	var measureIMGArray = getMeasureIMGArray();
	var measureTypeNameArray = getMeasureTypeNameArray();
	oSelect.previousSibling.style.backgroundImage = measureIMGArray[document.frm_main.measureType.selectedIndex];
	oSelect.previousSibling.title = measureTypeNameArray[document.frm_main.measureType.selectedIndex];

	// メジャータイプのセレクトボックスを削除
	removeSelecter( oSelect.previousSibling );
}

// メジャータイプ選択ボックスを削除
function removeSelecter( imgNode ) {
	if ( imgNode == null ) { return; }
	if ( imgNode.nextSibling == null ) { return; }
	if ( imgNode.nextSibling.tagName != "SELECT" ) { return; }

	imgNode.parentNode.removeChild( imgNode.nextSibling );
}

// メジャーメンバータイプのIDリスト
function getMeasureIDArray() {
	var measureIDArray = measureMemTypeIDListString.split(",");
	return measureIDArray;
}

// メジャーメンバータイプのイメージURの配列を取得する
function getMeasureIMGArray() {
	var measureIMGArray = measureMemTypeIMGListString.split(",");
	return measureIMGArray;
}

// メジャータイプの名称の配列を取得する
function getMeasureTypeNameArray() {
	var measureTypeNameArray = measureMemTypeNameListString.split(",");
	return measureTypeNameArray;
}

function getMeasureTypeIDByIndex( index ) {
	var measureIDArray = getMeasureIDArray();
	return measureIDArray[i];
}

function getMeasureTypeIDByImage( imageURL ) {
	var measureIDArray = getMeasureIDArray();
	var measureMemberTypeIndex = getMeasureTypeIndex( imageURL );
	return measureIDArray[measureMemberTypeIndex];
}

function getMeasureTypeIndex( imageURL ) {
	var measureIMGArray = getMeasureIMGArray();
	for ( var i = 0; i < measureIMGArray.length; i++ ) {
		if ( measureIMGArray[i] == imageURL ) {
			return i;
		}
	}
	return null;
}

function getMeasureTypeIndexByID( ID ) {
	var measureIDArray = getMeasureIDArray();
	for ( var i = 0; i < measureIDArray.length; i++ ){
		if ( measureIDArray[i] == ID ) {
			return i;
		}
	}
	return null;
}

function getMeasureTypeImageURLByID( ID ) {
	var measureIMGArray = getMeasureIMGArray();
	var measureIndex = getMeasureTypeIndexByID(ID);

	return measureIMGArray[measureIndex];
}


function getMeasureTypeImageURL( index ) {
	var measureIMGArray = getMeasureIMGArray();

	return measureIMGArray(index);
}

// =============================================================================
//  メンバ操作（ディメンションメンバ名表示タイプの変更）
// =============================================================================

	// 与えられたタイプの名称を設定する
	function changeDisplayName (dispNameType) {
		for(i=0;i<tab1.childNodes.length;i++){
			tab1.childNodes[i].firstChild.childNodes[1].innerHTML=tab1.childNodes[i].firstChild.childNodes[1].getAttribute(dispNameType);
		}
		for(i=0;i<tab2.childNodes.length;i++){
			tab2.childNodes[i].firstChild.childNodes[1].innerHTML=tab2.childNodes[i].firstChild.childNodes[1].getAttribute(dispNameType);
		}
	}

	// 与えられた軸IDのメンバ名称表示タイプを取得(セレクタヘッダより)
	function getSelectedMemberDispType() {

		var thisDispNameType = "";
		var thisDispNameTypeArray = parent.frm_header.document.all("dimMemDispTypeArea").firstChild.innerText.split(",");
		for ( var i = 0; i < thisDispNameTypeArray.length; i++ ) {
			// thisDispNameTypeArray[i].split(":")[0]: ディメンションID
			// thisDispNameTypeArray[i].split(":")[1]: ディメンションのメンバ表示名タイプ

			var thisDispNameTypeIDValue = thisDispNameTypeArray[i].split(":")
			if ( dimNumber == thisDispNameTypeIDValue[0] ) {
				thisDispNameType = thisDispNameTypeIDValue[1];
				break;
			}
		}

		return thisDispNameType;
	}

// =============================================================================
//  検索処理
// =============================================================================

// サーバーで、メンバー名・レベルによるディメンションメンバ検索を実行
function searchList() {

	// 入力チェック
	if(!checkData()){return;}

	document.frm_main.action = "Controller?action=searchDimensionMember";
	document.frm_main.target = "frm_data";
	document.frm_main.submit();
}

//メンバーの絞込み
function memberFocus(arrId){
	for(i=0;i<tab1.childNodes.length;i++){
		tab1.childNodes[i].exist="0";
	}
	for(i=0;i<arrId.length;i++){
		tab1.all(arrId[i]).exist="1";
	}
	for(i=0;i<tab1.childNodes.length;i++){
		dispCheck(tab1.childNodes[i]);
	}
}

// =============================================================================
//  メンバ操作（一括ドリル処理）
// =============================================================================
//全ドリルダウン・全ドリルアップ
function setTree(table,flg){
	var tbl = document.getElementById(table).firstChild;


	if(flg==1){//全ドリルアップ
		for(i=0;i<tbl.childNodes.length;i++){
			if(tbl.childNodes[i].firstChild.childNodes[0].toggle=="m"){
				tbl.childNodes[i].firstChild.childNodes[0].toggle="p";
				tbl.childNodes[i].firstChild.childNodes[0].innerHTML="<img src='" + treePlusImage + "' style='cursor:hand;'>";
				var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[i].id,"child");
				for(j=0;j<arrChildIndex.length;j++){
				//	tbl.childNodes[arrChildIndex[j]].dispflg="0";
					dispCheck(tbl.childNodes[arrChildIndex[j]]);
				}
			}
		}
	}else if(flg==2){//全ドリルダウン
		for(i=0;i<tbl.childNodes.length;i++){
			if(tbl.childNodes[i].firstChild.childNodes[0].toggle=="p"){
				tbl.childNodes[i].firstChild.childNodes[0].toggle="m";
				tbl.childNodes[i].firstChild.childNodes[0].innerHTML="<img src='" + treeMinusImage + "' style='cursor:hand;'>";
				var arrChildIndex = getDescendantIndexes(dimNumber,tbl.childNodes[i].id,"child");
				for(j=0;j<arrChildIndex.length;j++){
				//	tbl.childNodes[arrChildIndex[j]].dispflg="1";
					dispCheck(tbl.childNodes[arrChildIndex[j]]);
				}
			}
		}
	}

}

// =============================================================================
//  選択内容の確定処理
// =============================================================================
function setSelecterStatus() {

// 設定情報を取得

	// 現在、設定中のディメンション/メジャーのメンバ状態を保存
	var ret = setSelectedList( dimNumber, "submit" );
	if (ret == -1 ) {
		return false;
	}

}

// レポートを更新し、セレクタ自身をクローズする
// レポート情報更新後、サーバー側から送信されたJavaスクリプトにより実行される
function executeLoadSpread() {

	// レポートを更新
	document.frm_main.action = "Controller?action=loadClientInitAct";
	document.frm_main.target = "info_area";	
	document.frm_main.submit();

	// セレクタウインドウをクローズ
	parent.window.close();

}

// =============================================================================
//  セレクタ情報の保存
// =============================================================================
function setSelectedList( dimNum, mode ) {
	// セレクタによる設定情報の保持、Sessionへの登録

	var selecterInfo = getSelectedMemberList();
	if (selecterInfo == "") {	// 選択済みのメンバー欄が空欄
// Modal Dialog
		window.dialogArguments[0].showMessage( "6" );
//		parent.window.opener.showMessage( "6" );
		return -1;
	}

	// ===== 設定をセレクタヘッダに一時的に保存 =====
	// ディメンション/メジャーの選択されたメンバのKey・ドリル情報
	var statusArea = parent.frm_header.document.all("statusArea");
	var dimArea = statusArea.all( dimNum );
	dimArea.innerText = selecterInfo;

	// メジャータイプ
	var measureArea = parent.frm_header.document.all("measureTypeArea");
	if ( dimNumber == "16" ) {

		var measureTypeString = "";
		for(i=0;i<tab2.childNodes.length;i++){
			var node = tab2.childNodes[i];
			if ( measureTypeString == "" ) {
				measureTypeString = node.id + ":" + getMeasureTypeIDByImage( node.firstChild.firstChild.style.backgroundImage );
			} else {
				measureTypeString += "," + node.id + ":" + getMeasureTypeIDByImage( node.firstChild.firstChild.style.backgroundImage );
			}
		}
		measureArea.firstChild.innerText = measureTypeString;
	}

	// ===== 設定をセッションに保存 =====
	if ( mode == "submit" ) {

		// メジャータイプ
		document.frm_main.measureTypes.value = measureArea.firstChild.innerText;

		// メンバ名の表示タイプ
		var dimMemDispArea = parent.frm_header.document.all("dimMemDispTypeArea");
		document.frm_main.dimMemDispTypes.value = dimMemDispArea.firstChild.innerText;

		// ディメンション/メジャー毎の選択されたメンバのKey・ドリル情報
		document.frm_main.dim1.value = statusArea.all("1").innerText;
		document.frm_main.dim2.value = statusArea.all("2").innerText;
		document.frm_main.dim3.value = statusArea.all("3").innerText;
		document.frm_main.dim4.value = statusArea.all("4").innerText;
		document.frm_main.dim5.value = statusArea.all("5").innerText;
		document.frm_main.dim6.value = statusArea.all("6").innerText;
		document.frm_main.dim7.value = statusArea.all("7").innerText;
		document.frm_main.dim8.value = statusArea.all("8").innerText;
		document.frm_main.dim9.value = statusArea.all("9").innerText;
		document.frm_main.dim10.value = statusArea.all("10").innerText;
		document.frm_main.dim11.value = statusArea.all("11").innerText;
		document.frm_main.dim12.value = statusArea.all("12").innerText;
		document.frm_main.dim13.value = statusArea.all("13").innerText;
		document.frm_main.dim14.value = statusArea.all("14").innerText;
		document.frm_main.dim15.value = statusArea.all("15").innerText;
		document.frm_main.dim16.value = statusArea.all("16").innerText;

		// セルの色
// Modal Dialog
//		var colorArray = parent.window.opener.parent.display_area.getColorArray();
		var colorArray = window.dialogArguments[0].parent.display_area.getColorArray();
		if(colorArray != null) {
			document.frm_main.hdrColorInfo.value = colorArray[0];
			document.frm_main.dtColorInfo.value = colorArray[1];
		}

		// === セッションへ登録 ===
		document.frm_main.action = "Controller?action=registClientReportStatus";
		document.frm_main.target = "frm_data";	
		document.frm_main.submit();
	}
}

	//「選択済みのメンバー」欄に存在するメンバを配列で返す
	function getSelectedMemberList(){
		var arrSelectedMember = new Array();
		var count = 0;
		for(i=0;i<tab2.childNodes.length;i++){
			if(tab2.childNodes[i].exist=="1"){
				var tempString = "";
				//Idをセット
				tempString=tab2.childNodes[i].id;
				tempString+=":";
				//ドリル状態をセット（マイナス:1、それ以外:0）
				if(tab2.childNodes[i].firstChild.childNodes[0].toggle=="m"){
					tempString+="1";
				}else{
					tempString+="0";
				}
				arrSelectedMember[count]=tempString;
				count++;
			}
		}

		return arrSelectedMember;
	}

