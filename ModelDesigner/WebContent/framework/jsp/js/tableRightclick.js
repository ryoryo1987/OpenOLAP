var widthMax;
var heightMax;
var xCoor;
var yCoor;
var sWidth;
var sHeight;
var xScroll;
var widthScroll;
var frontMenu;
var backMenu;
var tempMenu;
var tempMenu2;
var newWin;

var menu = new Array;
var divId = new Array;
var preRightClickObj;
var left_preClickObj;

/*
function rightClick()
{
  document.oncontextmenu = show;
  document.onclick = hideMenus;
}
*/

function popUpPos()
{

  widthMax = document.body.clientWidth;
  heightMax = document.body.clientHeight;
  xCoor = window.event.clientX;
  yCoor = window.event.clientY;
  sWidth = frontMenu.style.posWidth;
  sHeight = frontMenu.style.posHeight;
  xScroll = document.body.scrollTop;
  widthScroll = document.body.offsetWidth - widthMax;
  xWidth = xCoor + sWidth;
  yHeight = yCoor + sHeight;

//alert("widthMax"+widthMax);
//alert("heightMax"+heightMax);
//alert("xCoor"+xCoor);
//alert("yCoor"+yCoor);
//alert("sWidth"+sWidth);
//alert("sHeight"+sHeight);
//alert("xScroll"+xScroll);
//alert("widthScroll"+widthScroll);
//alert("xWidth"+xWidth);
//alert("yHeight"+yHeight);

  if (frontMenu.style.visibility == "hidden"){
      if (yHeight < (heightMax - 1))
        {
          frontMenu.style.posTop = yCoor + xScroll;
          backMenu.style.posTop = yCoor + xScroll;
        }
      else
        {
          if (yCoor < sHeight)
            {
              frontMenu.style.posTop = xScroll;
              backMenu.style.posTop = xScroll;            
            }
          else
            {
              frontMenu.style.posTop = yCoor - sHeight + xScroll - 2;
              backMenu.style.posTop = yCoor - sHeight + xScroll - 2;
              if ((frontMenu.style.posTop + frontMenu.style.posHeight - xScroll + 2) > heightMax)
                {
                  frontMenu.style.posTop = heightMax - frontMenu.style.posHeight + xScroll - 2;
                  backMenu.style.posTop = heightMax - frontMenu.style.posHeight + xScroll - 2;
                }
            }
        }

      if (xWidth < widthMax - 1)
        {
          frontMenu.style.posLeft = xCoor;
          backMenu.style.posLeft = xCoor;
        }
      else
        {
          if (xCoor == (widthMax + 1))
            {
              frontMenu.style.posLeft = xCoor - sWidth - 3;
              backMenu.style.posLeft = xCoor - sWidth - 3;
            }
          else
            {
              if (widthMax < xCoor)
                {
                  frontMenu.style.posLeft = xCoor - sWidth - widthScroll - 1;
                  backMenu.style.posLeft = xCoor - sWidth - widthScroll - 1;
                }
              else
                {
                  frontMenu.style.posLeft = xCoor - sWidth - 2;
                  backMenu.style.posLeft = xCoor - sWidth - 2;
                }
            }
        }
    }
	          frontMenu.style.visibility = "visible";
	          backMenu.style.visibility = "visible";

}


function clickMenu(menuList){

//右のテーブル
var imputStr;
var rootObj;
var tempObj1;
var tempObj2;
var tempObj3;
//var newWin;
	frontMenu.style.visibility = "hidden";
	backMenu.style.visibility = "hidden";

	// ツリーテーブル側
	if(menuList.url=="追加"){
	//	newWin = window.open("cust_dim_member.jsp?key=-999","_blank","menubar=no,toolbar=no,width=300px,height=200px,resizable");
	//	newWin.moveTo(500,300);
		var arrArgObjs = [window.document,parent.frames[1]];
		newWin = showModalDialog("cust_dim_member.jsp?key=-999",arrArgObjs,"status:false;dialogWidth:350px;dialogHeight:250px");

//		newWin = showModalDialog("rankingHie_member.jsp?mnu=add",window,"status:false;dialogWidth:380px;dialogHeight:250px");

	}else if(menuList.url=="編集"){
		renameItem();
	}else if(menuList.url=="削除"){
		deleteItem();
	} else if (menuList.url=="切り取り"){
		// Cut&Paste
		cutItem();
	} else if (menuList.url=="貼り付け"){
		// Cut&Paste
		pasteItem();
	} else {
	}
}

/////////////////////////////////////////////
// 別モジュール化 (addMember_customHie.js) //
/////////////////////////////////////////////

//***********************************************************
function hideMenus(){
	frontMenu.style.visibility = "hidden";
	backMenu.style.visibility = "hidden";
}

if (document.all) {
  document.onmousedown = mouse_down;
  document.onclick = hideMenus;
}

// マウスダウンイベントで呼出される関数
function mouse_down(e){
    if (event.button == 2){
		if(window.event.srcElement.tagName=='A'){
			if(window.event.srcElement.parentNode.parentNode.parentNode.selectflg=="0"){
				resetRow();
				window.event.srcElement.parentNode.parentNode.parentNode.selectflg="1";
				window.event.srcElement.style.backgroundColor="navy";
				window.event.srcElement.style.color="white";
			}
		}else{
			resetRow();
		}
	//表示可能なメニューのリストを作る。
	availableMenu();
//	showMenu11(); // メニューに Paste 表示
	}
}

function availableMenu(){
	var strAdd=false;
	var strCut=false;
	var strPaste=false;
	var strDelete=false;
	var strRename=false;

//***********Add
//alert(window.event.srcElement.outerHTML);
	if(window.event.srcElement.tagName!='A'){
		strAdd=true;
	}

//***********Cut
	if(window.event.srcElement.tagName=='A'){
		strCut=true;
	}
//***********Paste
	if(parent.navi_frm.getPasteAble()){
	if(window.event.srcElement.tagName!='A'){
		strPaste=true;
	}
	}

//***********Delete
	if(window.event.srcElement.tagName=='A'){
		strDelete=true;
	}

//***********Rename
	var selectedCount=0;
	if(window.event.srcElement.tagName=='A'){
		var DataTable = document.getElementById("DataTable");
		for(i=0;i<DataTable.rows.length;i++){
			if(DataTable.rows[i].selectflg=="1"){
				selectedCount++;
			}
		}
		if(selectedCount==1){
			strRename=true;
		}
	}
	showMenu(strAdd,strCut,strPaste,strDelete,strRename);

}

function showMenu(strAdd,strCut,strPaste,strDelete,strRename){
	i=0;
	var lineFlg=false;
	document.body.removeChild(frontMenu);
	document.body.removeChild(backMenu);

	//*********************** Menu List***********************
	frontMenu = createMenuOne('FIRSTMENU');

	if (strAdd==true){
		tempMenu= createMenuOne('追加');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}

	if ((strDelete==true || strRename==true) && lineFlg==true){
		tempMenu= createMenuOne('SEPARATE');
			frontMenu.appendChild(tempMenu);
		lineFlg=false;
	}
	if (strDelete==true){
		tempMenu= createMenuOne('削除');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}
	if (strRename==true){
		tempMenu= createMenuOne('編集');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}


	if ((strCut==true || strPaste==true) && lineFlg==true){
		tempMenu= createMenuOne('SEPARATE');
			frontMenu.appendChild(tempMenu);
		lineFlg=false;
	}
	if (strCut==true){
		tempMenu= createMenuOne('切り取り');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}
	if (strPaste==true){
		tempMenu= createMenuOne('貼り付け');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}

	backMenu=createMenuOne('BACKMENU');

	document.body.appendChild(frontMenu);
	document.body.appendChild(backMenu);
	//*********************** Menu List***********************
//if (source != "A" && source != "IMG" && source != "INPUT" && source != "SELECT" && source != "TEXTAREA"){

	if (frontMenu.style.visibility == "hidden"){
		popUpPos();
		return false;
	}else{
		hideMenus();
	}
}
var heightSize;
function createMenuOne(strMenuKind){
	var tempObj;
	var tempObj2;//Seprate用
	if(strMenuKind=='FIRSTMENU'){
		heightSize=0;
		tempObj = document.createElement('<DIV class=menuFront id=mainMenuFront style="VISIBILITY: hidden; WIDTH: 60px; HEIGHT: 10px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	}else if(strMenuKind=='SEPARATE'){
		tempObj= document.createElement('<DIV class=itemSep style="WIDTH: 56px; TOP: '+heightSize+'px"></DIV>');
		tempObj2= document.createElement('<HR class=sep align=center SIZE=1>');
		heightSize=heightSize+3;
		tempObj.appendChild(tempObj2);
	}else if(strMenuKind=='BACKMENU'){
		frontMenu.style.height=heightSize+"px";//最後に、サイズ調整をする。
		tempObj = document.createElement('<DIV class=menuBack id=mainMenuBack style="VISIBILITY: hidden; WIDTH: 62px; HEIGHT: '+heightSize-1+'px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	}else{
		tempObj=document.createElement('<DIV onClick="clickMenu(this);" class="item" style="WIDTH: 56px; TOP: '+heightSize+'px" url="'+strMenuKind+'" target="_top" onMouseOver="mOver(this);" onMouseOut="mOut(this);"></DIV>');
		heightSize=heightSize+15;
		tempObj.innerHTML=strMenuKind;
	}
	return tempObj;
}

//右クリックのメニューのスタイル。
function mOver(th){
	//th.style.color='blue';
	th.className='item_over';
}
function mOut(th){
	//th.style.color='black';
	th.className='item';
}


function cutItem() {
	var strSelectedKey="";

	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			if(strSelectedKey!=""){
				strSelectedKey+=",";
			}
			strSelectedKey+=DataTable.rows[i].id;
		}
	}
	// セレクションの保存
	parent.navi_frm.setCutObjects(strSelectedKey);
}

function renameItem(){
	var selectedKey;
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			selectedKey = DataTable.rows[i].id;
		}
	}



//	newWin = window.open("cust_dim_member.jsp?key=" + selectedKey,"_blank","menubar=no,toolbar=no,width=300px,height=200px,resizable");
//	newWin.moveTo(500,300);
	var arrArgObjs = [window.document,parent.frames[1]];
	newWin = showModalDialog("cust_dim_member.jsp?key=" + selectedKey,arrArgObjs,"status:false;dialogWidth:350px;dialogHeight:250px");

}

function deleteItem(){

	var strSelectedKey="";
	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			if(strSelectedKey!=""){
				strSelectedKey+=",";
			}
			strSelectedKey+=DataTable.rows[i].id;
		}
	}

	if(!confirm("削除します。よろしいですか？")){
		return;
	}

	document.SpreadForm.hid_delete_key.value = strSelectedKey;
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			DataTable.rows[i].parentNode.removeChild(DataTable.rows[i]);
			i--;
		}
	}


	//左のTreeから取り除く
	parent.navi_frm.rightObjDelete();


	document.SpreadForm.target="update_tree_frm";
	//階層カスタマイズ種別対応
	document.SpreadForm.action="../hidden/cust_dim_tree_regist.jsp?opr=delete";
	document.SpreadForm.submit();

}
function pasteItem() {

	var drop_id;//配列で、CutされたIDをいれておく。
	var temp_obj;//
	temp_selection_text = parent.navi_frm.getCutObjects();
	var drop_id_txt = temp_selection_text; //カンマ区切りのCut された DropID

	var j=0;//drop_idの配列のカウントする変数

	var folder_flg = false;
	drop_id = drop_id_txt.split(',');//配列で、格納


	var cutParentObject=parent.navi_frm.getCutParentObject();//cutObjの所属元
	var preClickObj=parent.navi_frm.getpreClickObj();//cutObjのpaste先

	var i=0;
	var childFolder;//移動するもの（ドラッグされたIDに対応するTree側のObject）
	for(j=0;j<drop_id.length;j++){
		if(cutParentObject.lastChild.childNodes.length>i){//fukai 2004 02
			if(drop_id[j]==cutParentObject.lastChild.childNodes[i].id){
				childFolder=cutParentObject.lastChild.childNodes[i];
				//Dropされた部分の最後の子供として、ただしい、Elementとして、挿入する。
				parent.navi_frm.insertAdjustPosition(preClickObj,childFolder);
			}else{
				i++;
				j--;//必要？
			}
		}
	}
	parent.navi_frm.allLoop(cutParentObject,'ALL');

	parent.navi_frm.allLoop(preClickObj,'ALL');

	//更新用hidden項目に、格納
	//更新されるべきレコード
	parent.navi_frm.document.navi_form.child_record.value = temp_selection_text;
	//更新されるべき親のレコード
	//要考察
	parent.navi_frm.document.navi_form.parent_record.value = preClickObj.id;
	parent.navi_frm.document.navi_form.target="update_tree_frm";
	//階層カスタマイズ種別対応
	parent.navi_frm.document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";
	parent.navi_frm.document.navi_form.submit();


//--右画面連携更新
	parent.right_frm.SpreadForm.target="_self"
//階層カスタマイズ種別対応
	parent.right_frm.SpreadForm.action="cust_dim_tree_table.jsp?id=" + preClickObj.id;
	parent.right_frm.SpreadForm.submit();
//--右画面連携更新


	// 初期化して終了
	parent.navi_frm.setCutObjects(null);
	return;
}

// ---- 下のメニューは使っていないが、ここだけコメントにしてはいけない、要注意
function createMenu(){
	frontMenu = document.createElement('<DIV class=menuFront id=mainMenuFront style="VISIBILITY: hidden; WIDTH: 50px; HEIGHT: 55px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	backMenu= document.createElement('<DIV class=menuBack id=mainMenuBack style="VISIBILITY: hidden; WIDTH: 52px; HEIGHT: 57px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	document.body.appendChild(frontMenu);
	document.body.appendChild(backMenu);
}