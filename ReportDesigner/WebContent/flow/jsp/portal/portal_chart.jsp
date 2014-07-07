<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String Sql="";

	String seqId = request.getParameter("seqId");


	String reportName="";
	String portalXML="";
	Sql = "SELECT report_name,screen_xml FROM oo_v_report WHERE report_id = " + seqId;

	rs = stmt.executeQuery(Sql);
	if(rs.next()) {
		reportName=rs.getString("report_name");
		portalXML=rs.getString("screen_xml");
	}
	rs.close();


//	out.println(Sql);
%>



<html xmlns:v="urn:schemas-microsoft-com:vml"> 
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link REL="stylesheet" TYPE="text/css" HREF="../../../css/window.css">
<script type="text/javascript" src="../js/registration.js"></script>
<title><%=(String)session.getValue("aplName")%></title>
	<style>
	v\:* { behavior: url(#default#VML); }
	* { 
		font-style:Arial 'MS UI Gothic';
		font-size:12px;
	}
	.divObj{
		position:absolute;
	}
	.selectedDivObj{
		position:absolute;
	}

	.rectTitle{
		OVERFLOW: hidden;
		TEXT-OVERFLOW: ellipsis;
		VERTICAL-ALIGN: middle;
		font-size:10px;
		white-space:nowrap;
		cursor:hand;
		width:150;
		height:10;
	}
	.imgTitle{
		position:relative;
		top:2;
		left:2;
		width:10;
		height:10;
	}
	.divContents{
		position:absolute;
		top:11;
		left:0;
	}
	.rectContents{
		width:150;
		height:100;
	}
	.imgContents{
		background-image:url(co.png);
		background-repeat:no-repeat;
		position:relative;
		top:0;
		left:0;
		width:30;
		height:20
	}
	.divContentsText{
		position:relative;top:0;left:10;
		overflow:auto;
		font-size:12px;
		width:140;
		height:80;
	}

	.GamenText{
		position:relative;top:10;left:10;
		overflow:auto;
		font-size:20px;
		width:100;
		height:50;
	}



	</style>


<script language="JavaScript">




var XMLDoc = new ActiveXObject("MSXML2.DOMDocument");
XMLDoc.async = false;
var strLoadXML="";
<%out.println("strLoadXML=\"" + replace(replace(replace(portalXML,"\n",""),"\r",""),"\"","'") + "\";");%>




var arrRmodelName = new Array();

<%
	Sql="";
	Sql += " SELECT report_id,report_name from oo_v_report where kind_flg='R' and report_type='R' order by report_id";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		out.println("arrRmodelName[" + rs.getString("report_id") + "]='" + rs.getString("report_name") + "';");
	}
	rs.close();

%>










var target;//マウスダウン時のオブジェクト
var target2;//マウスアップ時のオブジェクト
var targetbox;//マウスダウン時のオブジェクトの親レイヤー
var mydrag=0;//ドラッグフラグ
var currentX=0;//現在のX座標
var currentY=0;//現在のY座標

function mymousedown(){

/*	//全ての反転状態をリセット
	if(event.srcElement.id!="delete_btn"){
		if(event.shiftKey==false){
			for(var ob=0;ob<document.all.length;ob++){
			//	document.all(ob).style.filter='none()';
				document.all(ob).strokecolor=lineColor;
			}
		}
	}
*/

	mydrag=1;
	target=event.srcElement;

	targetbox = target.parentNode.parentNode;
//	if(target.className==undefined){mydrag=0;return;}
//	if(event.srcElement.tagName=="IMG"){mydrag=0;return;}
//	if(event.srcElement.tagName=="IMG"){mydrag=0;return;}
//	if(event.srcElement.tagName=="A"){mydrag=0;return;}
//	if(target.tagName=="BODY"){mydrag=0;return;}
	if((target.className.indexOf("window_title_name")==-1)&&(target.className.indexOf("window_footer_right")==-1)){mydrag=0;return;}





//	while(target.parentNode.movable=="yes"){
//		target=target.parentNode;
//	}
//	if(target.movable!="yes"){mydrag=0;return;}

	document.all.moveDiv.style.display="block";
//	document.all.moveDiv2.style.display="block";
	document.all.divCoverScreen.style.display="block";
	document.all.moveDiv.style.pixelLeft=targetbox.style.pixelLeft;
	document.all.moveDiv.style.pixelTop=targetbox.style.pixelTop;
	document.all.moveDiv.style.width=targetbox.offsetWidth;
	document.all.moveDiv.style.height=targetbox.offsetHeight;
//	document.all.moveDiv2.style.pixelLeft=targetbox.style.pixelLeft;
//	document.all.moveDiv2.style.pixelTop=targetbox.style.pixelTop;
//	document.all.moveDiv2.style.width=targetbox.offsetWidth;
//	document.all.moveDiv2.style.height=targetbox.offsetHeight;






	//現在の座標を取得
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 


}


//ドラッグ中に動くモジュール
function mymousemove(){


	if(resizeFlg){


/*
		if((event.clientX - (resizeObj.style.pixelLeft + resizeSaX))<100){
			return;
		}
		if((event.clientY - (resizeObj.style.pixelTop + resizeSaY))<60){
			return;
		}
*/

		if((event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX))<100){
			return;
		}
		if((event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY))<60){
			return;
		}

		if(event.srcElement.tagName!="TD"){
			return;
		}

	//	mydrag=false;

	//	document.form_main.a.value=event.clientX;

	//	resizeObj.originalWidth = event.clientX - (resizeObj.style.pixelLeft + resizeSaX);
	//	resizeObj.originalHeight = event.clientY - (resizeObj.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計
	//	resizeObj.originalWidth = event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX);
	//	resizeObj.originalHeight = event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計



	//	changeWindowSize(resizeObj,(event.clientX - (resizeObj.style.pixelLeft + resizeSaX)),(event.clientY - (resizeObj.style.pixelTop + resizeSaY)))

		document.all.moveDiv.style.width = event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX);
		document.all.moveDiv.style.height = event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計

	}else if(mydrag){





		//ドラッグ中の座標
		newX = (event.clientX + document.body.scrollLeft);
		newY = (event.clientY + document.body.scrollTop);

		//クリック時の座標との差を算出する
		distanceX = (newX - currentX);
		distanceY = (newY - currentY);
		currentX = newX;
		currentY = newY;

		//実際にエレメントを移動する。
	//	targetbox.style.pixelLeft += distanceX;
	//	targetbox.style.pixelTop += distanceY;

		document.all.moveDiv.style.pixelLeft += distanceX;
		document.all.moveDiv.style.pixelTop += distanceY;








	}

}


//ドロップ時に動くモジュール
function mymouseup(){


	if(resizeFlg){
		changeWindowSize(resizeObj,document.all.moveDiv.offsetWidth,document.all.moveDiv.offsetHeight)
		resizeObj.originalWidth = resizeObj.offsetWidth;
		resizeObj.originalHeight = resizeObj.offsetHeight;
		resizeFlg=false;

	}



	if(targetbox.style!=undefined){
		targetbox.style.pixelLeft = document.all.moveDiv.style.pixelLeft;
		targetbox.style.pixelTop = document.all.moveDiv.style.pixelTop;
		targetbox.originalLeft = targetbox.style.pixelLeft;
		targetbox.originalTop = targetbox.style.pixelTop;
	}

	document.all.moveDiv.style.display="none";
//	document.all.moveDiv2.style.display="none";
	document.all.divCoverScreen.style.display="none";

	//ドラッグフラグの初期化
	mydrag=0;


}



function mouseOver(obj){

/*
	if(((obj.offsetWidth-event.offsetX)<=50)&&((obj.offsetHeight-event.offsetY)<=10)){
	//	obj.style.cursor="nw-resize";
		obj.style.cursor="hand";
	}else{
alert(obj.offsetWidth+","+event.offsetX+"----"+(obj.offsetWidth-event.offsetX)+"  "+event.srcElement.outerHTML);
		obj.style.cursor="crosshair";
	}
*/


	if(event.srcElement.className.indexOf("window_footer_right")!=-1){
		obj.style.cursor="nw-resize";
	}else if(event.srcElement.className.indexOf("window_title_name")!=-1){
		obj.style.cursor="hand";
	}else{
		obj.style.cursor="auto";
	}

}



var resizeObj = null;
var resizeFlg = false;
var resizeSaX = null;
var resizeSaY = null;
//var resizeFromX = null;
//var resizeFromY = null;
function resizemousedown(obj){
	//if(event.srcElement.className=="window_footer_right"){
	if(event.srcElement.className.indexOf("window_footer_right")!=-1){
	//	resizeObj=obj.parentNode.parentNode.parentNode.parentNode;
		resizeObj=obj.parentNode.parentNode;
		resizeFlg=true;
		resizeSaX=(obj.offsetWidth-event.offsetX);
		resizeSaY=(obj.offsetHeight-event.offsetY);
	//	clickWindow(resizeObj);
	}else{
		resizeFlg=false;
	}
}


function resizemousemove(){
	if(resizeFlg){


/*
		if((event.clientX - (resizeObj.style.pixelLeft + resizeSaX))<100){
			return;
		}
		if((event.clientY - (resizeObj.style.pixelTop + resizeSaY))<60){
			return;
		}
*/

		if((event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX))<100){
			return;
		}
		if((event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY))<60){
			return;
		}

		if(event.srcElement.tagName!="TD"){
			return;
		}

		mydrag=false;

	//	document.form_main.a.value=event.clientX;

	//	resizeObj.originalWidth = event.clientX - (resizeObj.style.pixelLeft + resizeSaX);
	//	resizeObj.originalHeight = event.clientY - (resizeObj.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計
	//	resizeObj.originalWidth = event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX);
	//	resizeObj.originalHeight = event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計



	//	changeWindowSize(resizeObj,(event.clientX - (resizeObj.style.pixelLeft + resizeSaX)),(event.clientY - (resizeObj.style.pixelTop + resizeSaY)))

		document.all.moveDiv.style.width = event.clientX - (document.all.moveDiv.style.pixelLeft + resizeSaX);
		document.all.moveDiv.style.height = event.clientY - (document.all.moveDiv.style.pixelTop + resizeSaY);//52=上のバーと下のバーの縦幅計

	}

}


function changeWindowSize(divWindowObj,x,y){
	divWindowObj.style.width = x;
	divWindowObj.style.height = y;
//	divWindowObj.originalWidth = x;
//	divWindowObj.originalHeight = y;
//	divWindowObj.childNodes[0].childNodes[1].style.width = x-57;//52=左上と右上部分の横幅計
//	divWindowObj.childNodes[2].childNodes[1].style.width = x-72;//72=左下と右下部分の横幅計
	divWindowObj.childNodes[0].childNodes[1].style.width = Math.max(x-57,0);//52=左上と右上部分の横幅計
//	divWindowObj.childNodes[2].childNodes[1].style.width = Math.max(x-72,0);//72=左下と右下部分の横幅計
	divWindowObj.childNodes[2].childNodes[1].style.width = Math.max(x-27,0);
	divWindowObj.childNodes[1].style.height = Math.max(y-52,0);
}



function resizemouseup(){
	if(resizeFlg){
		changeWindowSize(resizeObj,document.all.moveDiv.offsetWidth,document.all.moveDiv.offsetHeight)
		resizeObj.originalWidth = resizeObj.offsetWidth;
		resizeObj.originalHeight = resizeObj.offsetHeight;
		resizeFlg=false;
	}

}






function load(){
	//データXMLからオブジェクトアイコンの生成
//	for(i=0;i<XMLDom.selectSingleNode("//data").childNodes.length;i++){
//		displayObject(XMLDom.selectSingleNode("//data").childNodes[i]);
//	}

	if(strLoadXML!=""){
		XMLDoc.loadXML(strLoadXML);

		for(i=0;i<XMLDoc.selectSingleNode("Windows").childNodes.length;i++){
			var tempLeft=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//left").text;
			var tempTop=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//top").text;
			var tempWidth=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//width").text;
			var tempHeight=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//height").text;
			var tempUrl=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//url").text;
			var tempWindowType=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//windowtype").text;
			var tempRmodelId=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//rmodelid").text;
			var tempPortalColor=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//portalcolor").text;
			var tempSelectedFlg=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//selectedflg").text;
			var tempOriginalLeft=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//originalleft").text;
			var tempOriginalTop=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//originaltop").text;
			var tempOriginalWidth=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//originalwidth").text;
			var tempOriginalHeight=XMLDoc.selectSingleNode("Windows").childNodes[i].selectSingleNode(".//originalheight").text;

			displayObject(tempLeft,tempTop,tempWidth,tempHeight,tempUrl,tempWindowType,tempRmodelId,tempPortalColor,tempSelectedFlg,tempOriginalLeft,tempOriginalTop,tempOriginalWidth,tempOriginalHeight);
		}
	}


	top.frames[1].document.navi_form.change_flg.value = 0;

		//	displayObject(500,200);

}


function checkVacantPixel(pixX,pixY){

	if((pixX==0)&&(pixY==0)){
		return false;
	}else{
		for(x=0;x<document.all.allObjDiv.childNodes.length;x++){
			if((document.all.allObjDiv.childNodes[x].style.pixelLeft==pixX)&&(document.all.allObjDiv.childNodes[x].style.pixelTop==pixY)){
				return false;
			}
		}
	}
	return true;
}


function getVacantPixel(){
	var tempX=0;
	var tempY=0;
	while(checkVacantPixel(tempX,tempY)==false){
		tempX+=60;
		tempY+=30;
	}
	return tempX+","+tempY;
}



function clickOpenClose(obj){
	var divWindow=obj.parentNode.parentNode.parentNode;
	if(divWindow.openflg=="1"){
	//	divWindow.childNodes[1].style.display="none";
	//	divWindow.childNodes[2].style.display="none";
	//	divWindow.style.height="28";
	//	obj.src=obj.src.replace("window_no_disp","window_disp");
		controlWindow(divWindow,"close");
	}else if(divWindow.openflg=="0"){
	//	divWindow.childNodes[1].style.display="block";
	//	divWindow.childNodes[2].style.display="block";
	//	divWindow.style.height=divWindow.originalHeight;
	//	obj.src=obj.src.replace("window_disp","window_no_disp");
		controlWindow(divWindow,"open");
	}
}


function controlWindow(divWindow,controlType){
	if(controlType=="close"){
		divWindow.childNodes[1].style.display="none";
		divWindow.childNodes[2].style.display="none";
		divWindow.style.height="28";
		divWindow.childNodes[0].childNodes[2].childNodes[0].src=divWindow.childNodes[0].childNodes[2].childNodes[0].src.replace("window_no_disp","window_disp");
		divWindow.childNodes[0].childNodes[2].childNodes[0].title="表示";
		divWindow.openflg="0";
	}else if(controlType=="open"){
		divWindow.childNodes[1].style.display="block";
		divWindow.childNodes[2].style.display="block";
		divWindow.style.height=divWindow.originalHeight;
		divWindow.childNodes[0].childNodes[2].childNodes[0].src=divWindow.childNodes[0].childNodes[2].childNodes[0].src.replace("window_disp","window_no_disp");
		divWindow.childNodes[0].childNodes[2].childNodes[0].title="非表示";
		divWindow.openflg="1";
	}
}




function clickWindowSizeChange(obj){



	var divWindow=obj.parentNode.parentNode.parentNode;
	if(divWindow.magnifyflg=="0"){
	//	divWindow.style.width = document.body.clientWidth;
	//	divWindow.style.height = document.body.clientHeight;
		changeWindowSize(divWindow,document.body.clientWidth,document.body.clientHeight);
		divWindow.style.pixelLeft = 0;
		divWindow.style.pixelTop = 0;
		divWindow.magnifyflg="1";
		if(divWindow.childNodes[0].childNodes[2].childNodes[0].title=="表示"){
			clickOpenClose(divWindow.childNodes[0].childNodes[2].childNodes[1]);
		}


	}else if(divWindow.magnifyflg=="1"){
	//	divWindow.style.width = divWindow.originalWidth;
	//	divWindow.style.height = divWindow.originalHeight;
		changeWindowSize(divWindow,divWindow.originalWidth,divWindow.originalHeight);
		divWindow.style.pixelLeft = divWindow.originalLeft;
		divWindow.style.pixelTop = divWindow.originalTop;
		divWindow.magnifyflg="0";
		if(divWindow.childNodes[0].childNodes[2].childNodes[0].title=="表示"){
			clickOpenClose(divWindow.childNodes[0].childNodes[2].childNodes[1]);
		}

	}


}


function clickWindow(divWindow){


/*
	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		if(document.all.allObjDiv.childNodes[i].selectedFlg=="1"){
		//	document.all.allObjDiv.childNodes[i].innerHTML=document.all.allObjDiv.childNodes[i].innerHTML.replace(/_1/g,"_2");
			changeWindowColor(document.all.allObjDiv.childNodes[i],false);
			document.all.allObjDiv.childNodes[i].style.zIndex="1";
			document.all.allObjDiv.childNodes[i].selectedFlg="0";
		}
	}
*/

	if(document.form_main.currentWindowId.value!=""){
		if(document.form_main.currentWindowId.value!=divWindow.id){
			changeWindowColor(document.all(document.form_main.currentWindowId.value),false);
			document.all(document.form_main.currentWindowId.value).selectedFlg="0";
			document.all(document.form_main.currentWindowId.value).style.zIndex="1";
		}
	}

	//windowを選択状態にする
	if(divWindow.selectedFlg=="0"){
		divWindow.selectedFlg="1";
	//	divWindow.innerHTML=divWindow.innerHTML.replace(/_2/g,"_1");
		changeWindowColor(divWindow,true);
		divWindow.style.zIndex="2";
		document.form_main.currentWindowId.value=divWindow.id;
	}


	setChangeFlg();


}



function changeWindowColor(divWindow,selectedFlg){
	if(selectedFlg){
	//	divWindow.childNodes[0].childNodes[1].className=divWindow.childNodes[0].childNodes[1].className.replace(/_2/g,"_1");
		divWindow.childNodes[0].childNodes[0].style.filter="";
		divWindow.childNodes[0].childNodes[1].style.filter="";
		divWindow.childNodes[0].childNodes[2].style.filter="";
		divWindow.childNodes[0].childNodes[3].style.filter="";
		divWindow.childNodes[1].childNodes[0].childNodes[0].childNodes[0].style.filter="";
		divWindow.childNodes[1].childNodes[0].childNodes[0].childNodes[2].style.filter="";
		divWindow.childNodes[2].childNodes[0].style.filter="";
		divWindow.childNodes[2].childNodes[1].style.filter="";
		divWindow.childNodes[2].childNodes[2].style.filter="";
	}else{
	//	divWindow.childNodes[0].childNodes[1].className=divWindow.childNodes[0].childNodes[1].className.replace(/_1/g,"_2");
		divWindow.childNodes[0].childNodes[0].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[0].childNodes[1].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[0].childNodes[2].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[0].childNodes[3].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[1].childNodes[0].childNodes[0].childNodes[0].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[1].childNodes[0].childNodes[0].childNodes[2].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[2].childNodes[0].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[2].childNodes[1].style.filter="Alpha(style=0,opacity=30)";
		divWindow.childNodes[2].childNodes[2].style.filter="Alpha(style=0,opacity=30)";
	}

/*
	startNode=divWindow;
	while (true) {


		// child
		if (startNode.hasChildNodes()) {
			changeWindowColor(startNode.firstChild,selectedFlg);
		}


		// Sibling
		if (startNode.nextSibling != null) {
//alert(startNode.outerHTML);
//			if(selectedFlg){
//				if(startNode.className!=undefined){
//					startNode.className=startNode.className.replace(/_2/g,"_1");
//				}
//			}else{
//				if(startNode.className!=undefined){
//					startNode.className=startNode.className.replace(/_1/g,"_2");
//				}
//			}

			startNode = startNode.nextSibling;

		} else {
			break;
		}
	}
*/


}

function popupProperty(obj){

	if(event.srcElement.tagName=="IMG"){mydrag=0;return;}

//	newWin = window.open("portal_prpt.jsp?objId=" + obj.id,"_blank","menubar=no,toolbar=no,width=500px,height=200px,resizable");
	window.showModalDialog("portal_prpt.jsp?objId=" + obj.id,self,"dialogHeight:230px; dialogWidth:500px;");
}


function changeWindow(){
	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		if(document.all.allObjDiv.childNodes[i].selectedFlg=="1"){
			var nextWindow;
			if(document.all.allObjDiv.childNodes[i+1]!=undefined){
				nextWindow=document.all.allObjDiv.childNodes[i+1]
			}else{
				nextWindow=document.all.allObjDiv.childNodes[0]
			}
			clickWindow(nextWindow);
			return;
		}
	}
	
	//選択されているWindowがない場合は、最初のWindowを選択状態にする
	if(document.all.allObjDiv.childNodes[0]!=undefined){
		clickWindow(document.all.allObjDiv.childNodes[0]);
	}

}



var divId=0;
function displayObject(argLeft,argTop,argWidth,argHeight,argUrl,argWindowType,argRmodelId,argPortalColor,argSelectedFlg,argOriginalLeft,argOriginalTop,argOriginalWidth,argOriginalHeight){



	if((argLeft=="-999")&&(argTop=="-999")){
		var tempArr = new Array();
		tempArr = getVacantPixel().split(",");
		argLeft=tempArr[0];
		argTop=tempArr[1];
	}


	var displayUrl;
	var displayTitle;
	if(argWindowType=="internet"){
		displayUrl=argUrl;
		displayTitle=argUrl;
	}else{
		displayUrl="../Rreport/dispFrm.jsp?kind=db&rId="+argRmodelId;
		displayTitle=arrRmodelName[argRmodelId];
	}



	var strDiv="";
	strDiv+="<div id='window" + divId + "' style='position:absolute;background-Color:white;width:0;height:0;' url='"+argUrl+"' windowType='"+argWindowType+"' rmodelId='"+argRmodelId+"' portalColor='"+argPortalColor+"' selectedFlg='0' openflg='1' magnifyflg='0' originalWidth='' originalHeight='' originalLeft='' originalTop='' onmouseover='mouseOver(this)' onmousedown='clickWindow(this)' ondblclick='popupProperty(this)'>";
	strDiv+="	<nobr height='28'>";
	strDiv+="		<div class='window_title_left_" + argPortalColor + "'></div>";
	strDiv+="		<div class='window_title_name_" + argPortalColor + "' style='width:0;overflow:hidden;'>"+displayTitle+"</div>";
	strDiv+="		<div class='window_title_button_" + argPortalColor + "'>";
	strDiv+="<img src='../../../images/portal/window_no_disp_" + argPortalColor + ".gif' title='非表示' style='cursor:hand;' onclick='clickOpenClose(this)'>";
	strDiv+="<img src='../../../images/portal/window_full_screen_" + argPortalColor + ".gif' title='最大化' style='cursor:hand;' onclick='clickWindowSizeChange(this)'>";
	strDiv+="		</div>";
	strDiv+="		<div class='window_title_right_" + argPortalColor + "'></div>";
	strDiv+="	</nobr>";
	strDiv+="	<table style='display:block;' border='0' width='100%' height='0' style='border-collapse:collapse;'>";
	strDiv+="		<tr>";
	strDiv+="			<td class='window_contents_frame_" + argPortalColor + "'></td>";
	strDiv+="			<td width='100%'><iframe name='frm_window" + divId + "' src='" + displayUrl + "' width='100%' height='100%'></iframe></td>";
	strDiv+="			<td class='window_contents_frame_" + argPortalColor + "'></td>";
	strDiv+="		</tr>";
	strDiv+="	</table>";
	strDiv+="	<nobr style='display:block;' style='hieght:24;'>";
	strDiv+="		<div class='window_footer_left_" + argPortalColor + "'></div>";
	strDiv+="		<div class='window_footer_center_" + argPortalColor + "' style='width:0;overflow:hidden;'>";
	strDiv+="			<div style='display:block;'>　</div>";
//	strDiv+="			<div style='display:block;'>";
//	strDiv+="				<a class='active_" + argPortalColor + "' href='#' onclick='history.back(); return false;' target='frm_window" + divId + "'>Back</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href='#' onclick='history.forward(); return false;' target='frm_window" + divId + "'>Next</a> ";
//	strDiv+="			</div>";
//	strDiv+="			<div style='display:none;'>";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>1</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>2</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>3</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>4</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>5</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>6</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>7</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>8</a> ";
//	strDiv+="				<a class='active_" + argPortalColor + "' href=''>9</a> ";
//	strDiv+="			</div>";
	strDiv+="		</div>";
	strDiv+="		<div class='window_footer_right_" + argPortalColor + "' onmousedown='resizemousedown(this)'></div>";
	strDiv+="	</nobr>";
	strDiv+="</div>";




//	alert(strDiv);
	document.all.allObjDiv.innerHTML+=strDiv;

	changeWindowSize(document.all("window" + divId),argWidth,argHeight);
	document.all("window" + divId).style.pixelLeft=argLeft;
	document.all("window" + divId).style.pixelTop=argTop;

	if(argOriginalLeft==null){
		document.all("window" + divId).originalLeft=argLeft;
		document.all("window" + divId).originalTop=argTop;
		document.all("window" + divId).originalWidth=argWidth;
		document.all("window" + divId).originalHeight=argHeight;
	}else{
		document.all("window" + divId).originalLeft=argOriginalLeft;
		document.all("window" + divId).originalTop=argOriginalTop;
		document.all("window" + divId).originalWidth=argOriginalWidth;
		document.all("window" + divId).originalHeight=argOriginalHeight;
	}

	if((argSelectedFlg=="1")||(argSelectedFlg==null)){
		clickWindow(document.all("window" + divId));
	}




	divId++;

}





function save(){

	var strXML="<?xml version='1.0' encoding='Shift_JIS' ?>";
	strXML+="<Windows>";
	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		var objectID=document.all.allObjDiv.childNodes[i].id;
		var left=document.all.allObjDiv.childNodes[i].style.pixelLeft;
		var top=document.all.allObjDiv.childNodes[i].style.pixelTop;
		var width=document.all.allObjDiv.childNodes[i].offsetWidth;
		var height=document.all.allObjDiv.childNodes[i].offsetHeight;
		var originalleft=document.all.allObjDiv.childNodes[i].originalLeft;
		var originaltop=document.all.allObjDiv.childNodes[i].originalTop;
		var originalwidth=document.all.allObjDiv.childNodes[i].originalWidth;
		var originalheight=document.all.allObjDiv.childNodes[i].originalHeight;
		var selectedflg=document.all.allObjDiv.childNodes[i].selectedFlg;
		var url=document.all.allObjDiv.childNodes[i].url;
		var windowtype=document.all.allObjDiv.childNodes[i].windowType;
		var rmodelid=document.all.allObjDiv.childNodes[i].rmodelId;
		var portalcolor=document.all.allObjDiv.childNodes[i].portalColor;

	//	strXML+="<Window id='" + objectID + "'>";
		strXML+="<Window>";
		strXML+="<Position>";
		strXML+="<left>" + left + "</left>";
		strXML+="<top>" + top + "</top>";
		strXML+="<width>" + width + "</width>";
		strXML+="<height>" + height + "</height>";
		strXML+="<originalleft>" + originalleft + "</originalleft>";
		strXML+="<originaltop>" + originaltop + "</originaltop>";
		strXML+="<originalwidth>" + originalwidth + "</originalwidth>";
		strXML+="<originalheight>" + originalheight + "</originalheight>";
		strXML+="<selectedflg>" + selectedflg + "</selectedflg>";
		strXML+="<url>" + url + "</url>";
		strXML+="<windowtype>" + windowtype + "</windowtype>";
		strXML+="<rmodelid>" + rmodelid + "</rmodelid>";
		strXML+="<portalcolor>" + portalcolor + "</portalcolor>";
		strXML+="</Position>";
		strXML+="</Window>";
	}
	strXML+="</Windows>";
//	alert(strXML);


	<%if("null".equals(request.getParameter("seqId"))){%>
	//	parent.parent.document.form_main.hid_xml.value=strXML;
		parent.document.form_main.hid_xml.value=strXML;
	<%}else{%>
		document.form_main.hid_xml.value=strXML;
		document.form_main.strReportOwnerFlg.value=parent.document.form_main.strReportOwnerFlg.value;
		document.form_main.target="frm_hidden";
		document.form_main.action="portal_regist.jsp";
		document.form_main.submit();
	<%}%>


}

function del(){
	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		if(document.all.allObjDiv.childNodes[i].selectedFlg=="1"){
			document.all.allObjDiv.childNodes[i].parentNode.removeChild(document.all.allObjDiv.childNodes[i]);
			document.form_main.currentWindowId.value="";
			i=i-1;
		}
	}



}


function controlAllWindow(tempFlg){

	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		controlWindow(document.all.allObjDiv.childNodes[i],tempFlg);
	}

}
function displayLineUp(tempFlg){

	var oneWindowHeight;
	var oneWindowWidth;


	var chousei=document.all.allObjDiv.childNodes.length+5;

	if(tempFlg=="crosswise"){
		oneWindowHeight=document.body.offsetHeight-chousei;
		oneWindowWidth=Math.round((document.body.offsetWidth-chousei)/document.all.allObjDiv.childNodes.length);
	}else if(tempFlg=="lengthwise"){
		oneWindowHeight=Math.round((document.body.offsetHeight-chousei)/document.all.allObjDiv.childNodes.length);
		oneWindowWidth=document.body.offsetWidth-chousei;
	}


	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		changeWindowSize(document.all.allObjDiv.childNodes[i],oneWindowWidth,oneWindowHeight);
		controlWindow(document.all.allObjDiv.childNodes[i],"open");

		if(tempFlg=="crosswise"){
			document.all.allObjDiv.childNodes[i].style.pixelLeft = oneWindowWidth*i;
			document.all.allObjDiv.childNodes[i].style.pixelTop = 0;
		}else if(tempFlg=="lengthwise"){
			document.all.allObjDiv.childNodes[i].style.pixelLeft = 0;
			document.all.allObjDiv.childNodes[i].style.pixelTop = oneWindowHeight*i;
		}

	}

}




</script>

</head>
<!--
<body onload="load()" kind='body' onselectstart="return false;" onmousemove='mymousemove();' onmouseup='mymouseup();' onmousedown='mymousedown()'>
-->
<body onload="load()" kind='body' background="../../../images/portal/bg.gif" onselectstart="return false;" onmousemove='mymousemove();' onmouseup='mymouseup();' onmousedown='mymousedown()'>
	<div>


		<div id="moveDiv" style="position:absolute;top:0;left:0;display:none;filter:alpha(opacity=80);border:3 solid blue;z-Index:9;"><table width="100%" height="100%"><tr><td></td></tr></table></div>
		<div id="divCoverScreen" style="position:absolute;top:0;left:0;display:none;filter:alpha(opacity=80);z-Index:10;width:100%;height:100%;"><table width="100%" height="100%"><tr><td></td></tr></table></div>

		<div id="allObjDiv" style="position:absolute;top:0;left:0;"></div>




	</div>


	<form name="form_main" id="form_main" method="post" action="">
		<input type="hidden" name="currentWindowId" value="">
		<input type="hidden" name="hid_report_name" value="<%=reportName%>">
		<input type="hidden" name="seqId" value="<%=seqId%>">
<!--	<input type="text" id="a" name="a" style="position:absolute;top:0;left:600;" value="">-->

		<input type="hidden" name="hid_xml" value="">
		<input type="hidden" name="strReportOwnerFlg" value="">

	</form>
</body>
</html>

<%@ include file="../../connect_close.jsp"%>

