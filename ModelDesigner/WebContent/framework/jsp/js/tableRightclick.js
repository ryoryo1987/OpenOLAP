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

//�E�̃e�[�u��
var imputStr;
var rootObj;
var tempObj1;
var tempObj2;
var tempObj3;
//var newWin;
	frontMenu.style.visibility = "hidden";
	backMenu.style.visibility = "hidden";

	// �c���[�e�[�u����
	if(menuList.url=="�ǉ�"){
	//	newWin = window.open("cust_dim_member.jsp?key=-999","_blank","menubar=no,toolbar=no,width=300px,height=200px,resizable");
	//	newWin.moveTo(500,300);
		var arrArgObjs = [window.document,parent.frames[1]];
		newWin = showModalDialog("cust_dim_member.jsp?key=-999",arrArgObjs,"status:false;dialogWidth:350px;dialogHeight:250px");

//		newWin = showModalDialog("rankingHie_member.jsp?mnu=add",window,"status:false;dialogWidth:380px;dialogHeight:250px");

	}else if(menuList.url=="�ҏW"){
		renameItem();
	}else if(menuList.url=="�폜"){
		deleteItem();
	} else if (menuList.url=="�؂���"){
		// Cut&Paste
		cutItem();
	} else if (menuList.url=="�\��t��"){
		// Cut&Paste
		pasteItem();
	} else {
	}
}

/////////////////////////////////////////////
// �ʃ��W���[���� (addMember_customHie.js) //
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

// �}�E�X�_�E���C�x���g�Ōďo�����֐�
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
	//�\���\�ȃ��j���[�̃��X�g�����B
	availableMenu();
//	showMenu11(); // ���j���[�� Paste �\��
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
		tempMenu= createMenuOne('�ǉ�');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}

	if ((strDelete==true || strRename==true) && lineFlg==true){
		tempMenu= createMenuOne('SEPARATE');
			frontMenu.appendChild(tempMenu);
		lineFlg=false;
	}
	if (strDelete==true){
		tempMenu= createMenuOne('�폜');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}
	if (strRename==true){
		tempMenu= createMenuOne('�ҏW');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}


	if ((strCut==true || strPaste==true) && lineFlg==true){
		tempMenu= createMenuOne('SEPARATE');
			frontMenu.appendChild(tempMenu);
		lineFlg=false;
	}
	if (strCut==true){
		tempMenu= createMenuOne('�؂���');
			frontMenu.appendChild(tempMenu);
		lineFlg=true;
	}
	if (strPaste==true){
		tempMenu= createMenuOne('�\��t��');
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
	var tempObj2;//Seprate�p
	if(strMenuKind=='FIRSTMENU'){
		heightSize=0;
		tempObj = document.createElement('<DIV class=menuFront id=mainMenuFront style="VISIBILITY: hidden; WIDTH: 60px; HEIGHT: 10px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	}else if(strMenuKind=='SEPARATE'){
		tempObj= document.createElement('<DIV class=itemSep style="WIDTH: 56px; TOP: '+heightSize+'px"></DIV>');
		tempObj2= document.createElement('<HR class=sep align=center SIZE=1>');
		heightSize=heightSize+3;
		tempObj.appendChild(tempObj2);
	}else if(strMenuKind=='BACKMENU'){
		frontMenu.style.height=heightSize+"px";//�Ō�ɁA�T�C�Y����������B
		tempObj = document.createElement('<DIV class=menuBack id=mainMenuBack style="VISIBILITY: hidden; WIDTH: 62px; HEIGHT: '+heightSize-1+'px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	}else{
		tempObj=document.createElement('<DIV onClick="clickMenu(this);" class="item" style="WIDTH: 56px; TOP: '+heightSize+'px" url="'+strMenuKind+'" target="_top" onMouseOver="mOver(this);" onMouseOut="mOut(this);"></DIV>');
		heightSize=heightSize+15;
		tempObj.innerHTML=strMenuKind;
	}
	return tempObj;
}

//�E�N���b�N�̃��j���[�̃X�^�C���B
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
	// �Z���N�V�����̕ۑ�
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

	if(!confirm("�폜���܂��B��낵���ł����H")){
		return;
	}

	document.SpreadForm.hid_delete_key.value = strSelectedKey;
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			DataTable.rows[i].parentNode.removeChild(DataTable.rows[i]);
			i--;
		}
	}


	//����Tree�����菜��
	parent.navi_frm.rightObjDelete();


	document.SpreadForm.target="update_tree_frm";
	//�K�w�J�X�^�}�C�Y��ʑΉ�
	document.SpreadForm.action="../hidden/cust_dim_tree_regist.jsp?opr=delete";
	document.SpreadForm.submit();

}
function pasteItem() {

	var drop_id;//�z��ŁACut���ꂽID������Ă����B
	var temp_obj;//
	temp_selection_text = parent.navi_frm.getCutObjects();
	var drop_id_txt = temp_selection_text; //�J���}��؂��Cut ���ꂽ DropID

	var j=0;//drop_id�̔z��̃J�E���g����ϐ�

	var folder_flg = false;
	drop_id = drop_id_txt.split(',');//�z��ŁA�i�[


	var cutParentObject=parent.navi_frm.getCutParentObject();//cutObj�̏�����
	var preClickObj=parent.navi_frm.getpreClickObj();//cutObj��paste��

	var i=0;
	var childFolder;//�ړ�������́i�h���b�O���ꂽID�ɑΉ�����Tree����Object�j
	for(j=0;j<drop_id.length;j++){
		if(cutParentObject.lastChild.childNodes.length>i){//fukai 2004 02
			if(drop_id[j]==cutParentObject.lastChild.childNodes[i].id){
				childFolder=cutParentObject.lastChild.childNodes[i];
				//Drop���ꂽ�����̍Ō�̎q���Ƃ��āA���������AElement�Ƃ��āA�}������B
				parent.navi_frm.insertAdjustPosition(preClickObj,childFolder);
			}else{
				i++;
				j--;//�K�v�H
			}
		}
	}
	parent.navi_frm.allLoop(cutParentObject,'ALL');

	parent.navi_frm.allLoop(preClickObj,'ALL');

	//�X�V�phidden���ڂɁA�i�[
	//�X�V�����ׂ����R�[�h
	parent.navi_frm.document.navi_form.child_record.value = temp_selection_text;
	//�X�V�����ׂ��e�̃��R�[�h
	//�v�l�@
	parent.navi_frm.document.navi_form.parent_record.value = preClickObj.id;
	parent.navi_frm.document.navi_form.target="update_tree_frm";
	//�K�w�J�X�^�}�C�Y��ʑΉ�
	parent.navi_frm.document.navi_form.action="../hidden/cust_dim_tree_regist.jsp?opr=update";
	parent.navi_frm.document.navi_form.submit();


//--�E��ʘA�g�X�V
	parent.right_frm.SpreadForm.target="_self"
//�K�w�J�X�^�}�C�Y��ʑΉ�
	parent.right_frm.SpreadForm.action="cust_dim_tree_table.jsp?id=" + preClickObj.id;
	parent.right_frm.SpreadForm.submit();
//--�E��ʘA�g�X�V


	// ���������ďI��
	parent.navi_frm.setCutObjects(null);
	return;
}

// ---- ���̃��j���[�͎g���Ă��Ȃ����A���������R�����g�ɂ��Ă͂����Ȃ��A�v����
function createMenu(){
	frontMenu = document.createElement('<DIV class=menuFront id=mainMenuFront style="VISIBILITY: hidden; WIDTH: 50px; HEIGHT: 55px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	backMenu= document.createElement('<DIV class=menuBack id=mainMenuBack style="VISIBILITY: hidden; WIDTH: 52px; HEIGHT: 57px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	document.body.appendChild(frontMenu);
	document.body.appendChild(backMenu);
}