//Toggle() の代替 
function navi_click(kind,node) {
	document.navi_form.seqId.value=node.id;
	document.navi_form.objKind.value=node.objkind;

	//子供のIDをすべて入れておく。!!! CURRENT SET (NOT ALL SET) for right table !!!
	var childLen = node.parentNode.lastChild.childNodes.length;
	var childValRight = "";
	for (i=0;i<childLen;i++){
		if(i==0){
			childValRight = node.parentNode.lastChild.childNodes[i].id;
		}else{
			childValRight = childValRight + "," + node.parentNode.lastChild.childNodes[i].id;
		}
	}
	document.navi_form.childId.value=childValRight;

	divNode = node.parentNode;

	// Unfold the branch if it isn't visible
	if(node.tagName=='IMG'){
		if(kind=='f' || kind=='0'){
			reversePreNextImage(divNode);
			reversePM(divNode);
			reverseDisplay(divNode);
		}else if(kind=='r'){//ROOT
			reversePreNextImage(divNode);
			reverseDisplay(divNode);
		}else{//プラスマイナスクリック
			reversePM(divNode);
			reverseDisplay(divNode);
			return;
		}
		node.nextSibling.focus();
	}else{// A href
		reversePreNextImage(divNode);
	}

	//if preClickNode == clickNode then none
	if(preClickObj!=divNode){
		preClickObj = divNode;

		var folderName;
	//	if(document.URL.indexOf("objects.jsp")==-1){
			folderName="";
	//	}else{
	//		folderName="jsp/";
	//	}

		// 候補リスト・設定リストの表示
		cube_set_display();
	}
}

//ToggleDblClick() の代替
function navi_dbl_click(kind,node){
	divNode = node.parentNode;
	preClickObj = divNode;
	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
}

// 候補リスト（左）・設定リスト（右）の表示
function cube_set_display() {

	// 右側リストのHTMLの作成
	right_bdy_load();

	// 左側リストのHTMLの作成
	left_bdy_load();
}

// 右側リストのHTMLの作成
function right_bdy_load() {
	var myNode = preClickObj;
	var strrightTHTML = "<select name='lst_right' id='lst_right' size='7' multiple style='width:250;margin:0'>\n";
	if(myNode.lastChild.hasChildNodes()){
		for (iCount=0; iCount<myNode.lastChild.childNodes.length; iCount++) {
			strrightTHTML=strrightTHTML + "<option value='";
			strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].id + "'>";
			strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].lastChild.previousSibling.innerText + "</option>";
		}
	}
	strrightTHTML=strrightTHTML + "<select>";
	parent.parent.frm_main.document.form_main.all.div_right_move.innerHTML = strrightTHTML;


}

// 左側リストのHTMLの作成
function left_bdy_load() {
	//現在のobjKind, seqIdを取得
	var reqKind = document.navi_form.objKind.value;
	var reqId = document.navi_form.seqId.value;

	//既に選択されたもの
	var reqChildId = document.navi_form.childId.value;

	//Available Objectのノードを探す
	var myNode = searchNode(reqKind, reqId);

	// HTMLの作成
	var strrightTHTML = "";
	// 種類によって、複数選択できるか１つかにする。
	if(reqKind=='Dimension' || reqKind=='TimeDim'){
		strrightTHTML="<select name='lst_left' id='lst_left' size='7' style='width:250;margin:0'>\n";
	}else{
		strrightTHTML="<select name='lst_left' id='lst_left' size='7' multiple style='width:250;margin:0'>\n";
	}
	var arrChildId = reqChildId.split(',');
	if(myNode!=null){
		if(myNode.lastChild.hasChildNodes()){
			for (iCount=0; iCount<myNode.lastChild.childNodes.length; iCount++) {
				var match_flag = 0;
				for (jCount=0; jCount<arrChildId.length; jCount++) {
					if (myNode.lastChild.childNodes[iCount].id == arrChildId[jCount]) {
						// 一致したら
						match_flag = 1;
						break;
					}
				}
				if (match_flag == 0) {
					strrightTHTML=strrightTHTML + "<option value='";
					strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].id + "'>";
					strrightTHTML=strrightTHTML + myNode.lastChild.childNodes[iCount].lastChild.previousSibling.innerText + "</option>";
				}
			}
		}
	}
	strrightTHTML=strrightTHTML + "<select>";
	parent.parent.frm_main.document.form_main.all.div_left_move.innerHTML = strrightTHTML;

}

function searchNode(sOBJKIND, sID) {
	// Measure, Dimension(Time Dimension),Parts の基準ノードを戻す
	// selectedNode.parentNode.parentNode ;上位ノードへ
	// selectedNode.lastChild.lastChild   ;下位ノードへ
	// パーツの探索はしない（メジャー、次元まで）
	// 該当するノードが無い場合、null を返す

	var iCount = 0;
	var jCount = 0;
	var selectedNode;

	// Measure(objkind), x(id) 基準ノード初期化
	selectedNode = allIncRootNode;

	// Measure 判定(sOBJKIND = "Measure")
	if (sOBJKIND == "Measure") {
		return selectedNode;
	}

	// Dimension 判定
	if (sOBJKIND == "Dimension" || sOBJKIND == "TimeDim") {
		if (!selectedNode.lastChild.hasChildNodes()) {
			// Dimension が無い場合は null を返す
			return null;
		}

		for (iCount=0; iCount<selectedNode.lastChild.childNodes.length; iCount++) {
			if (selectedNode.lastChild.childNodes[iCount].id == sID) {
				selectedNode = selectedNode.lastChild.childNodes[iCount];
				return selectedNode;
			}
		}

	}

// 漏れ検出
//*alert("[ALL] (該当無し) "+selectedNode.objkind+" : "+selectedNode.id+" の中です");
	return null;
}



//ツリー初期表示
function init() {

	// クローン作成後に削除するノード
	var allRemRootNode = new Object;
	allRemRootNode = document.getElementById("cloneNode");

	// その親
	var thisRootNode = new Object;
	thisRootNode = allRemRootNode.parentNode;

	// 表示調整先ノード
	var siblingNode = new Object;
	siblingNode = allRemRootNode.previousSibling;
//alert(siblingNode.outerHTML);

	// すべての候補オブジェクトを含むノードを設定
	allIncRootNode = allRemRootNode.lastChild.lastChild.cloneNode(true);//全ノード

	// 表示に不要なノードを削除
	thisRootNode.removeChild(allRemRootNode);

	// 表示調整
	allLoop(siblingNode,'ALL')

}
