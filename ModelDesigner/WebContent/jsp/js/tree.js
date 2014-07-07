//********画面右操作用保存Obj*************
	// 右クリックメニュー「Cut」で選択されたオブジェクトのセレクション
	var cutObjectsId = null;
	// 右クリック時の親オブジェクト
	var cutParentObject = null;

// ドラッグ開始オブジェクトの所属オブジェクト id(judge navi_form or else)
var strDragStart = "";

//Clickされたイメージのオブジェクトを入れておく。
var preClickObj = null;
var preClickParentObj = null;
var preRightClickObj = new Object;

//preClickObj.src = "null";

//********* キューブカスタマイズ用ALLオブジェクト格納 ********* (cubeSet.js)
var allIncRootNode = new Object;

// tree.js が呼ばれた場所から"images"ディレクトリへの相対パス
var strImages = getImagesPath();

// Determinate reletive path for "images" folder.
function getImagesPath() {
	var strLoc = location.pathname;
	var strPath = "images";

//	var iPos = 1;							// except document root (/)
//	iPos = strLoc.indexOf("/",iPos) + 1;	// except context root (/OpenOLAP/)

//	while (true) {
//		iPos = strLoc.indexOf("/",iPos);
//		if (iPos<0) {
//			break;
//		} else {
//			strPath = "../" + strPath;
//			iPos++;
//		}
//	}

	//Objects.jspだったら、Root
	if(strLoc.indexOf("objects.jsp")!=-1){
		strPath="images";
	}else{
		strPath="../../images";
	}
	return strPath;
}

function addMember(arg1,arg2,maxVal) {
var tempObj;
var addObj;

// Notice : "arg2" is not referenced now.
	addObj=createDivObj(maxVal);
	tempObj=document.createElement("<img id='5' src='"+strImages+"/L.gif' onclick=JavaScript:Toggle('TP',this,'');>");
		addObj.appendChild(tempObj);
	tempObj=createImageObj(maxVal);
		addObj.appendChild(tempObj);
	tempObj=createAhrefObj(maxVal,arg1);
		addObj.appendChild(tempObj);
	tempObj=createDivC_Obj(maxVal);
		addObj.appendChild(tempObj);
		preClickObj.lastChild.appendChild(addObj);
	allLoop(preClickObj,'ALL');
}

function renMember(key,arg1,arg2) {
var tempObj;
var workObj;
var iCount = 0;

	// not use 'arg2'

	tempObj = preClickObj;
	if (tempObj.lastChild.hasChildNodes()) {
		workObj = tempObj.lastChild.firstChild;
		while (true) {
			if (workObj.id==key) {
				// rename "innerHTML" - cube name
				workObj.lastChild.previousSibling.innerHTML = arg1;
				break;
			}
			if (workObj.id==tempObj.lastChild.lastChild.id) {
				break;
			} else {
				workObj = workObj.nextSibling;
			}
		}
	}
	return;
}



//**********************************************************************
//******************************* Drag & Drop (Tree -> Table )
//**********************************************************************
var srcObj = new Object;

// string to hold source of object being dragged:
var dummyObj;

var startDragNodeObj;//左から右へのドラッグドロップで使用

function startDrag(){
//	document.activeElement.className = "selected";

	strDragStart = "TREE_FRAME";
	startDragNodeObj = window.event.srcElement.parentNode;

	// get what is being dragged:
//	srcObj = window.event.srcElement;
    // store the source of the object into a string acting as a dummy object so we don't ruin the original object:
//    dummyObj = srcObj.outerHTML;
    // post the data for Windows:
    var dragData = window.event.dataTransfer;

    // set the type of data for the clipboard:
    dragData.setData('Text', window.event.srcElement.id);

    // allow only dragging that involves moving the object:
    dragData.effectAllowed = 'linkMove';

    // use the special 'move' cursor when dragging:
    dragData.dropEffect = 'move';

}

function enterDrag() {
    // allow target object to read clipboard:
    window.event.dataTransfer.getData('Text');
}

function endDrag() {

    // when done remove clipboard data
    window.event.dataTransfer.clearData();
}

function overDrag() {
    // tell onOverDrag handler not to do anything:
	window.event.srcElement.className = 'dragOver';
}
function leaveDrag() {
	//window.event.srcElement.style.color = 'black';
	window.event.srcElement.className = 'dragEnd';
}

function drop() {

if (strDragStart == "") {
//	alert("cannot drop.");
	return;
}

var drop_id;//配列で、ドロップされたIDをいれておく。
var temp_obj;//
var drop_id_txt = window.event.dataTransfer.getData('Text');//カンマ区切りのDropID
//alert(drop_id_txt);
var len_cnt = parent.right_frm.document.all.length - 0;//右側のドキュメントのすべての数。（※len_cnt：このtree.xslの中では利用されていない変数）
var j=0;//drop_idの配列のカウントする変数
var iCount=0;//drop_idの配列のカウントする変数

var folder_flg = false;
	if(drop_id_txt==null){
		return;
	}
	drop_id = drop_id_txt.split(',');//配列で、格納

if (id_check1(drop_id, window.event.srcElement.parentNode)) {
	//	alert("OK - id_check1");
} else {
	//alert("NG - id_check1");


//	alert("Cannot move to " + window.event.srcElement.id + " : The source can't be dropped within source itself.");

	window.event.srcElement.className = 'dragEnd';
	return;
}

if (id_check2(drop_id, window.event.srcElement.parentNode)) {
	//	alert("OK - id_check2");
} else {
	//alert("NG - id_check2");

//	alert("Cannot move to " + window.event.srcElement.id + " : The source can't be dropped within souce itself.");

	window.event.srcElement.className = 'dragEnd';
	return;
}


if (!is_from_navi_form()) { // 右テーブルからのドラッグ＆ドロップの場合
	var rightTempObj;//右のDragされたもの
	var rightTempImg;//右のDragされたImage（そこに、属性がある。）
	var addNodeObj;
	for(j=0;j<drop_id.length;j++){
		rightTempObj=parent.right_frm.document.getElementById(drop_id[j]);
	//	if (rightTempObj.kind=="D"){//Dirだったら削除の前に左のTreeを操作。
		if (rightTempObj.kind=="D"||rightTempObj.kind=="V"){//Dirだったら削除の前に左のTreeを操作。
			var childFolder;//移動するもの（ドラッグされたIDに対応するTree側のObject）
			for(x=0;x<preClickObj.lastChild.childNodes.length;x++){
				if (preClickObj.lastChild.childNodes[x].id==drop_id[j]){
					childFolder = preClickObj.lastChild.childNodes[x];

//alert("childFolder.id : "+childFolder.id);

					//Dropされた部分の最後の子供として、ただしい、Elementとして、挿入する。
					insertAdjustPosition(window.event.srcElement.parentNode,childFolder);

		//			preClickObj.lastChild.removeChild(childFolder);//前の場所から取り除く
		//			//Dropされた部分の最後の子供として、ただしい、Elementとして、挿入する。
		//			insertAdjustPosition(window.event.srcElement.parentNode,childFolder);

				}
			}
		}//ここまでで、フォルダ特有の処理が終了。********************************************************

		//左から、削除する。
		rightTempObj.parentNode.removeChild(rightTempObj);
	}

/////*******************モジュール化***************************
	allLoop(window.event.srcElement.parentNode,'ALL');//付け足す側
	allLoop(preClickObj,'ALL');//取り除かれる側
/////**********************************************************

//***********************************
	//更新用hidden項目に、格納
	//更新されるべきレコード
	document.navi_form.child_record.value = drop_id_txt;
	//更新されるべき親のコード
	document.navi_form.parent_record.value = window.event.srcElement.id;

//alert("子　"+document.navi_form.child_record.value);
//alert("親　"+document.navi_form.parent_record.value);

	document.navi_form.target="update_tree_frm";
	//document.navi_form.action="update_tree_data.jsp";
	document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";

//	//Tree種別対応
//	if (document.navi_form.typ.value == "1") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** customized hierarchy ****
//		// *********************************************************************
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else if (document.navi_form.typ.value == "2") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** segmentation hierarchy ****
//		// *********************************************************************
//		//まだ未対応
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** その他 ****
//		// *********************************************************************
//		//まだ未対応
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	}

	document.navi_form.submit();
//***********************************

} else { // 右テーブルからのドラッグ＆ドロップの場合(end)

	// 左側ツリー内でのドラッグ＆ドロップの場合
	leftTreeMove(window.event.srcElement.parentNode);

}	// 左側ツリー内でのドラッグ＆ドロップの場合(end)

	window.event.srcElement.className = 'dragEnd';


} 
//**************************************** drop() end

function leftTreeMove(dropNode){
	// startDragNodeObj; //::ドロップ元ノード（ドラッグしてきたもの）
	var srcParentNode = startDragNodeObj.parentNode.parentNode; //::ドロップ元（ドラッグしてきたもの）の親ノード
	var dstObj = dropNode; //::ドロップ先
	srcParentNode.lastChild.removeChild(startDragNodeObj);//前の場所から取り除く
	//Dropされた部分の最後の子供として、ただしい、Elementとして、挿入する。
	insertAdjustPosition(dstObj,startDragNodeObj);

	allLoop(dstObj,'ALL');//付け足す側
	allLoop(srcParentNode,'ALL');//取り除かれる側

	document.navi_form.child_record.value = startDragNodeObj.id;
	//更新されるべき親のコード
	document.navi_form.parent_record.value = dropNode.id;

	document.navi_form.target="update_tree_frm";
	//document.navi_form.action="update_tree_data.jsp";
	document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";

//	//Tree種別対応
//	if (document.navi_form.typ.value == "1") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** customized hierarchy ****
//		// *********************************************************************
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else if (document.navi_form.typ.value == "2") {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** segmentation hierarchy ****
//		// *********************************************************************
//		//まだ未対応
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	} else {
//alert("document.navi_form.typ.value = "+document.navi_form.typ.value);
//		// *********************************************************************
//		// **** その他 ****
//		// *********************************************************************
//		//まだ未対応
//		document.navi_form.action="cust_dim_setTreeData.jsp?opr=update";
//	}

	document.navi_form.submit();
////////

//--右画面連携更新
	parent.right_frm.SpreadForm.target="_self"
	//parent.right_frm.tree_table_form.action="treeTable.jsp?id=" + preClickObj.id;
//	//Tree種別対応
//	parent.right_frm.tree_table_form.action="cust_dim_tree_table.jsp?typ=" + document.navi_form.typ.value + "&id=" + preClickObj.id;
	parent.right_frm.SpreadForm.action="cust_dim_tree_table.jsp?id=" + preClickObj.id;
//alert(parent.right_frm.SpreadForm.action);
	parent.right_frm.SpreadForm.submit();
}

function mouseDown() {
//	document.activeElement.className = "selected";
}

/////rightClick*********************************
//////右側で消された場合、左のTreeからも削除する。（右から呼ばれる。）
function rightObjDelete() {
var deleteId;
var i,j;

	deleteId = parent.right_frm.SpreadForm.hid_delete_key.value.split(",");
	for (i=0; deleteId.length>i ;i++){
		if(preClickObj.lastChild.hasChildNodes()){

			for(j=0;preClickObj.lastChild.childNodes.length>j;j++){
				if(deleteId[i]==preClickObj.lastChild.childNodes[j].id){
					//削除
					preClickObj.lastChild.removeChild(preClickObj.lastChild.childNodes[j]);
				}
			}
		}
	}

	allLoop(preClickObj,'ALL');
}

//*******************************************共通変数を渡す
function getpreClickObj() {
	return preClickObj;
}
// Cut されたオブジェクトを含むツリーノードの取得と設定
function setCutObjects(SeleText) {
	cutObjectsId=SeleText;
	cutParentObject=preClickObj;
}
function getCutObjects() {
	return cutObjectsId;
}
function getCutParentObject() {
	return cutParentObject;
}

function getPasteAble(){
	if (cutObjectsId!=null && cutParentObject!=null && cutParentObject!=preClickObj){
		return true;
	}else{
		return false;
	}
}

function is_from_navi_form() {
	if (strDragStart == "TREE_FRAME") {
		strDragStart = "";
		return true;
	} else if (strDragStart == "TABLE_FRAME") {
		strDragStart = "";
		return false;
	} else {
		// error trap

//alert("is_from_navi_from() error.");

	}
}


// チェック１：destination が source の子孫であることは禁じる
function id_check1(drop_ids, evt_srcElmnt_pNode) {
	//drop_ids は "ドロップ元(src)" の id
	var work_obj = evt_srcElmnt_pNode;		// "ドロップ先(src)" のオブジェクト(Div) ノード
	var work_id = evt_srcElmnt_pNode.id;	// "ドロップ先(src)" の id = "ドロップ先(src)" の (Div) の id
	var jCount;
	while (work_id != "root") {
		// "ドロップ元のID"=="ドロップ先のID" の場合は何もしない
		for (jCount=0; jCount<drop_ids.length; jCount++) {
			//alert("drop_id["+jCount+"]="+drop_ids[jCount]);
			if (drop_ids[jCount] == work_id) {
				//alert("[id_check] Cannot move " + drop_ids[jCount] + ": The source and destination id is the same.");
				return false;	// NG
			}
		}
		work_obj = work_obj.parentNode.parentNode;	// 次の親オブジェクト (Div)
		work_id = work_obj.id;
	}
	return true;	// OK
}

// チェック２：destination と source が同じになる（移動しても変わらない）ことは禁じる
function id_check2(drop_ids, evt_srcElmnt_pNode) {
//alert(drop_ids);

//	if(evt_srcElmnt_pNode==preClickObj){
//		alert("同じ場所");
//		return;
//	}

	//drop_ids は "ドロップ元(src)" の id
	var work_obj2 = evt_srcElmnt_pNode;		// "ドロップ先(src)" のオブジェクト(Div) ノード
	var work_id2 = evt_srcElmnt_pNode.id;	// "ドロップ先(src)" の id = "ドロップ先(src)" の (Div) の id
	var workobj3;
	var firstChildObj;
	var lastChildObj;
	var kCount;
	var lCount;

	if (!work_obj2.lastChild.hasChildNodes()) {
		// ドロップ先の最後の子ノードの子ノードが無い場合は、ドロップ元が重ならないので、ＯＫ
		return true; // OK
	} else {
		// ドロップ先の最後の子ノードの子ノードがある場合は、ドロップ元が重なる可能性を判定
		firstChildObj = work_obj2.lastChild.firstChild;
		lastChildObj = work_obj2.lastChild.lastChild;
		work_obj3 = firstChildObj;
		lCount = 0; // 子ノードの数
		while (true) { // 無限ループ作成
			lCount++;
			for (kCount=0; kCount<drop_ids.length; kCount++) {
				if (drop_ids[kCount] == work_obj3.id) {
					// ドロップ元とドロップ先のIDが重なる場合はＮＧ
					return false;	// NG
				}
			}
			if (work_obj3.id == lastChildObj.id) {
				return true; // LOOP OUT (OK)
			} else {
				work_obj3 = work_obj3.nextSibling; // NEXT TRY
			}
		}
	}
}



//***************** Module
// public variable
//************Loop Module**************
function allLoop(node,proc) {
	// all loop include node & child & Sibling
	var startNode = node;

	if(proc=='ALL'){
		levelAdjust(startNode);
		pmLTAdjust(startNode);
	}else if(proc=='LEVEL'){
		levelAdjust(startNode);
	}else if(proc=='PMLT'){
		pmLTAdjust(startNode);
	}

	while (true) {
		// child
		if (startNode.lastChild.hasChildNodes()) {
			allLoop(startNode.lastChild.firstChild,proc);
		}

		// Sibling
		if (startNode.nextSibling != null) {
			startNode = startNode.nextSibling;
				if(proc=='ALL'){
					levelAdjust(startNode);
					pmLTAdjust(startNode);
				}else if(proc=='LEVEL'){
					levelAdjust(startNode);
				}else if(proc=='PMLT'){
					pmLTAdjust(startNode);
				}

		} else {
			break;
		}
	}
}


function thisAndPreviousNode(node,proc) {
	var startNode = node;

	//親のPlusMinusも変更する。
	pmLTAdjust(startNode.parentNode.parentNode);

	allLoop(startNode,proc);
	if (startNode.previousSibling!=null){
		startNode=startNode.previousSibling;
	}else{
		return;
	}
	allLoop(startNode,proc);

}
//自分と、その最後の子供を書き換える。
function thisAndLastChildNode(node,proc) {

	var startNode = node;
	//親のPlusMinusも変更する。
	if(proc=='ALL'){
//alert(startNode.outerHTML);
		levelAdjust(startNode);
		pmLTAdjust(startNode);
	}else if(proc=='LEVEL'){
		levelAdjust(startNode);
	}else if(proc=='PMLT'){
		pmLTAdjust(startNode);
	}

//alert("start");
//alert(startNode.outerHTML);
	if(startNode.lastChild.hasChildNodes()){
//alert(startNode.outerHTML);
		startNode = startNode.lastChild.lastChild;
//alert(startNode.outerHTML);
		allLoop(startNode,proc);
	}
}

//************adjust node**************
function levelAdjust(node) {
	var oDiv;
	var clcLevelNode;
	var Cnode=node;

	for(x=0;x<Cnode.childNodes.length;x++){///階層分をとりのぞく。
		if(Cnode.childNodes[0].id=="root"){
			break;
		}else if(Cnode.childNodes[0].id=="H"){//ID=H → blank or I gif
			Cnode.removeChild(Cnode.childNodes[0]);//取り除いていくので、インデックスは常に最初のもの＝０
			x--;//////Cnode.childNodes.lengthの数が取り除くと変わるため。
		}else{
			break;
		}
	}
	//階層の深さを求める処理
	clcLevelNode = node.parentNode.parentNode;//最初に親(ID='番号-C')の親(Id='番号')に移る。
	oDiv=document.createElement("<img id='dummy' src='"+strImages+"/I.gif'/>");
	while(clcLevelNode.tagName=="DIV" && clcLevelNode.id!="root"){
		if(clcLevelNode.nextSibling == null){
			oDiv = document.createElement("<img id='H' src='"+strImages+"/blank.gif'/>");
		}else{
			oDiv = document.createElement("<img id='H' src='"+strImages+"/I.gif'/>");
		}
		node.firstChild.insertAdjacentElement('BeforeBegin',oDiv);
		clcLevelNode = clcLevelNode.parentNode.parentNode;
	}
}


function pmLTAdjust(node) {//Plus Minus L T Adjust
	if(node.id=='root'){
		return;
	}

	var pmLTimage = node.lastChild.previousSibling.previousSibling.previousSibling;
    //                  .-C       .A              .image          .pmLTimage

	if (node.nextSibling == null) { //L
		if(node.lastChild.hasChildNodes()==true){
			pmLTimage.src=strImages+'/Lplus.gif';
		}else{
			pmLTimage.src=strImages+'/L.gif';
		}
	}else{ //T
		if(node.lastChild.hasChildNodes()==true){
			pmLTimage.src=strImages+'/Tplus.gif';
		}else{
			pmLTimage.src=strImages+'/T.gif';
		}
	}

	if(node.lastChild.style.display=='none'){
		pmLTimage.src=pmLTimage.src.replace('minus.gif','plus.gif');
	}else{
		pmLTimage.src=pmLTimage.src.replace('plus.gif','minus.gif');
	}

}
//Nodeの名称（A Href）の部分を書き換える。
function updateNodeName(node,objId,objName,kind){
	if (kind=='THIS'){
		node.lastChild.previousSibling.innerHTML=objName;
	}else if(kind=='CHILD'){
		for(i=0;i<node.lastChild.childNodes.length;i++){
//alert(node.outerHTML);
//alert('objid'+objId);
//alert('nodeId'+node.lastChild.childNodes[i].id);
			if(node.lastChild.childNodes[i].id==objId){
				node.lastChild.childNodes[i].lastChild.previousSibling.innerHTML=objName;
				return;
			}
		}
	}
}

function reverseImage(node) {
	var nodeImage = node.lastChild.previousSibling.previousSibling;
    //                  .-C       .A              .image
	if(node.lastChild.style.display=='none'){//show child ?
		nodeImage.src = nodeImage.src.replace('2.gif','1.gif');
	}else{
		nodeImage.src = nodeImage.src.replace('1.gif','2.gif');
	}
}

function reversePM(node) {//Plus Minus change//未使用
	var pmLTimage = node.lastChild.previousSibling.previousSibling.previousSibling;
    //                  .-C       .A              .image          .pmLTimage
	if(node.lastChild.style.display=='none'){//show child ?
		pmLTimage.src=pmLTimage.src.replace('plus.gif','minus.gif');
	}else{
		pmLTimage.src=pmLTimage.src.replace('minus.gif','plus.gif');
	}
}

function reverseDisplay(node) {//style.display change
	if(node.lastChild.style.display=='none'){//show child ?
		node.lastChild.style.display='block';
	}else{
		node.lastChild.style.display='none';
	}
}

function reversePreNextImage(th){

	if(preClickObj!=th){//最初は、PreClickに何も入っていない。
		if(preClickObj!=null){
			var preImage = preClickObj.lastChild.previousSibling.previousSibling;
		    //                 .-C       .A              .image
			preImage.src=preImage.src.replace('1.gif','2.gif');
		}

		var thImage = th.lastChild.previousSibling.previousSibling;
	    //                 .-C       .A              .image
		thImage.src=thImage.src.replace('2.gif','1.gif');
	}
}

//*************** Sort *******************
function insertAdjustPosition(addNode,node) {
var preNode=null;
	for (i=0;i<addNode.lastChild.childNodes.length;i++) {
		if(addNode.lastChild.childNodes[i].id>node.id){
			break;
			//return preNode;//この前につける。
		}
		preNode = addNode.lastChild.childNodes[i];
	}

	if(preNode==null){
		if (addNode.lastChild.hasChildNodes()){
			addNode.lastChild.firstChild.insertAdjacentElement("beforeBegin",node);
		}else{
			addNode.lastChild.appendChild(node);
		}
	}else{
		preNode.insertAdjacentElement("afterEnd",node);
	}
}

//Treeの更新時に、無理やりClickさせる。（右画面の更新終了後呼ばれる）
function updateTreeObjToggle(tp){
	var upClickObj=null
	if(tp==0){//Insert
		upClickObj=preClickObj;
		preClickObj=null;//一度クリアしないと同じ場所は、右のファイルを更新できない。（tp==0用）
	}else if(tp==1){//Update
		return;//none
	}else if(tp==2){//Delete
		upClickObj=preClickParentObj;
	}
	upClickObj.lastChild.previousSibling.click();
	upClickObj.lastChild.previousSibling.focus();
}

//******************************************
function Toggle(kind,node,file_name){

	
// エラー処理追加(登録前に左ツリー操作禁止)
	if (location.pathname.indexOf("objects.jsp")!=-1 && kind!='TP'){//ObjectsJSPの時だけ。かつ右画面が変わるときだけ。
		var ret;
		if (document.navi_form.change_flg.value == 1) {
			//破棄確認メッセージ表示
			ret = showConfirm("CFM1");
// メッセージ共通化のため使用しない
//			ret = confirm("Are you sure you want to cancel the changes you made?");

			//破棄します=Yesの時,画面制御用フラグ=0にResetする
			if (ret == true) {
				document.navi_form.change_flg.value = 0;
			} else {
				//破棄しない場合処理抜ける
				return;
			}
		}
	}

	document.navi_form.seqId.value=node.id;
	document.navi_form.objKind.value=node.objkind;

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
		preClickParentObj = preClickObj.parentNode.parentNode;

		var folderName;
		if(document.URL.indexOf("objects.jsp")==-1){
			folderName="";
		}else{
			folderName="jsp/";
		}
		document.navi_form.target = "right_frm";
		document.navi_form.action = folderName + file_name;
		document.navi_form.submit();
	}

}

function ToggleDblClick(kind,node,file_name){
return;

/*
//DEBUG  エラー処理追加(登録前に左ツリー操作禁止)
	if (location.pathname.indexOf("objects.jsp")!=-1){//ObjectsJSPの時だけ。
		if (document.navi_form.change_flg.value == 1) {

// DebugMessageとめる(このfunction使ってない?)
//			alert("Error!--Error!--Error!");
//			return;
		}
	}

	divNode = node.parentNode;
	preClickObj = divNode;
	preClickParentObj = preClickObj.parentNode.parentNode;

	reversePreNextImage(divNode);
	reversePM(divNode);
	reverseDisplay(divNode);
*/
}

