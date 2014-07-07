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
var copyObj=null;
var copyParentObj=null;


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
	if(menuList.url=="コピー"){
		copyItem();
	} else {

//		alert(menuList.url + ": NOT DEFINED INNER INNERHTML.");
	}
}

function copyItem(){
	copyObj=preRightClickObj;
	copyParentObj=copyObj.parentNode.parentNode;

	document.navi_form.copyObj_objKind.value=copyObj.objkind;
	document.navi_form.copyObj_id.value=copyObj.id;
	document.navi_form.copyParentObj_objKind.value=copyParentObj.objkind;
	document.navi_form.copyParentObj_id.value=copyParentObj.id;

	//コピー確認メッセージ表示

	if(showConfirm("CFM3")){
		document.navi_form.action = "jsp/hidden/tree_copy_regist.jsp";
		document.navi_form.target = "frm_hidden";	
		document.navi_form.submit();
	}
//	}



}


/////////////////////////////////////////////
// 別モジュール化 (addMember_customHie.js) //
/////////////////////////////////////////////

//***********************************************************
function hideMenus(){
	frontMenu.style.visibility = "hidden";
	backMenu.style.visibility = "hidden";
}

function rightClick(){
  document.onmousedown = mouse_down;
  document.onclick = hideMenus;
}

// マウスダウンイベントで呼出される関数
function mouse_down(e){
    if (event.button == 2){
		if(window.event.srcElement.tagName=='A'){
			//表示可能なメニューのリストを作る。
			availableMenu();
		}else{
			hideMenus();
		}
	}
}

function availableMenu(){
	var strCopy=false;
	var strPaste=false;

//***********Copy
	preRightClickObj = window.event.srcElement.parentNode;
var objTagName = preRightClickObj.objkind;

	if(window.event.srcElement.tagName=='A'){
		if( objTagName=='Dimension' ||
			objTagName=='SegmentDimension' ||
			objTagName=='TimeDimension' ||
			objTagName=='Measure' ||
			objTagName=='Cube' ||
			objTagName=='DimParts' ||
			objTagName=='SegmentParts'){
			strCopy=true;
		}
	}
//***********Paste//A or Body 両方可 Aの場合は、その子供にデータができる。
	showMenu(strCopy,strPaste);

}

function showMenu(strCopy,strPaste){

	if (strCopy==false && strPaste==false){
		return;//何もしない。
	}
	i=0;
	var lineFlg=false;
	document.body.removeChild(frontMenu);
	document.body.removeChild(backMenu);

	//*********************** Menu List***********************
	frontMenu = createMenuOne('FIRSTMENU');


	if (strCopy==true){
		tempMenu= createMenuOne('コピー');
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


// ---- 下のメニューは使っていないが、ここだけコメントにしてはいけない、要注意
function createMenu(){
	frontMenu = document.createElement('<DIV class=menuFront id=mainMenuFront style="VISIBILITY: hidden; WIDTH: 50px; HEIGHT: 55px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	backMenu= document.createElement('<DIV class=menuBack id=mainMenuBack style="VISIBILITY: hidden; WIDTH: 52px; HEIGHT: 57px; BACKGROUND-COLOR: #c0c0c0"></DIV>');
	document.body.appendChild(frontMenu);
	document.body.appendChild(backMenu);
	rightClick();//Onloadで、右クリックのイベントを発生可能にする。
}