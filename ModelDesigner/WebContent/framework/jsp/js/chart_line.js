var target;//マウスダウン時のオブジェクト
var target2;//マウスアップ時のオブジェクト
var targetbox;//マウスダウン時のオブジェクトの外側Div
var mydrag=false;//ドラッグフラグ
var currentX=0;//現在のX座標
var currentY=0;//現在のY座標
var mouseLine;//Mouseでひく線（仮線）

//線オブジェクトの作成
var lineColor='green';
var selctedLineColor='red';
var lineWeight='2px';
var lineDashStyle='solid';
var beginLineType='diamond';
var endLineType='diamond';

var linkLine=new Array();//線を入れるObject変数
var linkPosition=new Array();//線のFromかToを入れておく変数
var linkJibun=new Array();//自分のIDを入れておく変数
var linkAite=new Array();//相手のIDを入れておく変数

var from_x;//線の座標を入れる変数
var from_y;//線の座標を入れる変数
var to_x;//線の座標を入れる変数
var to_y;//線の座標を入れる変数



//２つのオブジェクトの座標を比較して最短の座標をセットするモジュール
function autoLineChart(obj1,obj2){
//obj1,obj2=一番外側のDiv

	//X座標を自動計算
	obj1_l=obj1.parentNode.offsetLeft;
	obj1_r=obj1.parentNode.offsetLeft+obj1.offsetWidth;
	obj2_l=obj2.parentNode.offsetLeft;
	obj2_r=obj2.parentNode.offsetLeft+obj2.offsetWidth;

	type1=Math.abs(obj1_l-obj2_l);
	type2=Math.abs(obj1_l-obj2_r);
	type3=Math.abs(obj1_r-obj2_l);
	type4=Math.abs(obj1_r-obj2_r);

	minValue=Math.min(Math.min(Math.min(type1,type2),type3),type4);

	var type;
	if(minValue==type1){type=1};
	if(minValue==type2){type=2};
	if(minValue==type3){type=3};
	if(minValue==type4){type=4};

	//X座標をセット
	if(type==1){
		from_x=obj1_l;
		to_x=obj2_l;
	}
	if(type==2){
		from_x=obj1_l;
		to_x=obj2_r;
	}
	if(type==3){
		from_x=obj1_r;
		to_x=obj2_l;
	}
	if(type==4){
		from_x=obj1_r;
		to_x=obj2_r;
	}

	//Y座標をセット
	obj1_top = obj1.parentNode.offsetTop + obj1.offsetTop + (obj1.offsetHeight/2)
	obj2_top = obj2.parentNode.offsetTop + obj2.offsetTop + (obj2.offsetHeight/2)
	from_y=obj1_top;
	to_y=obj2_top;

}


//ContentsをMouseDownした場合動作
function setDashLine(){
	mouseLine=document.getElementById("dashline");
	mouseLine.from=fromX + "," + fromY;
	mouseLine.to=fromX + "," + fromY;
}

//選択されたObjectに緋もづいている線情報を変数に保存。
var selectedLineName="";
function setSelectedLine(targetbox){
	var tempLineId;
	if(targetbox.lastChild.hasChildNodes()){
		for(var i=0;i<targetbox.lastChild.childNodes.length;i++){
			tempLineObj=targetbox.lastChild.childNodes[i];

			linkLine[tempLineObj.name]=document.getElementById(tempLineObj.name);
			linkPosition[tempLineObj.name]=tempLineObj.position;
			linkJibun[tempLineObj.name]=document.getElementById(tempLineObj.jibun);
			linkAite[tempLineObj.name]=document.getElementById(tempLineObj.aite);

			if(selectedLineName.indexOf(tempLineObj.name)){
				if(selectedLineName==''){
					selectedLineName=tempLineObj.name
				}else{
					selectedLineName=selectedLineName+'-'+tempLineObj.name
				}
			}
		}
	}
}

var selectedObjName="";
var selectedObj=new Array();
function setSelectObj(targetbox,kind){
	if(kind=='select'){

		targetbox.selectedflg='1';

		targetbox.style.zIndex='99';
		targetbox.firstChild.firstChild.childNodes[1].color='black';
	if(targetbox.childNodes[1].firstChild.childNodes[1].color=='red'){
		targetbox.childNodes[1].firstChild.childNodes[1].color2='#FFCCCC';
	}else{
		targetbox.childNodes[1].firstChild.childNodes[1].color2='#CCCCFF';
	}
		targetbox.childNodes[1].firstChild.childNodes[1].opacity='0.5';
		targetbox.className='selectedDivObj';
		if(selectedObjName.indexOf(targetbox.id)==-1){
			if(selectedObjName==''){
				selectedObjName=targetbox.id;
			}else{
				selectedObjName=selectedObjName+'-'+targetbox.id;
			}
		}
		selectedObj[targetbox.id]=targetbox;
		setSelectedLine(targetbox);//線も選択
	}else if(kind='release'){

		targetbox.selectedflg='0';

		targetbox.firstChild.firstChild.childNodes[1].color='white';
		targetbox.style.zIndex='1';
		targetbox.childNodes[1].firstChild.childNodes[1].color2='white';
		targetbox.childNodes[1].firstChild.childNodes[1].opacity='0.2';
		targetbox.className='divObj';
		if(selectedObjName.indexOf(targetbox.id)!=-1){
			selectedObjName=selectedObjName.replace(targetbox.id,'');
			selectedObjName=selectedObjName.replace('--','-');
		}
		selectedObj[targetbox.id]=null;
	}
}

//マウス押下時に動くモジュール
function mymousedown(){
	target=event.srcElement;
	mydrag=true;

	//現在の座標を取得
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 

	//開始位置をセット
	fromX = currentX;
	fromY = currentY;

	if(event.srcElement.tagName=='BODY'){
		targetbox = null;
	}else{
	//	target=target.parentElement;
	//	targetbox = target.parentElement;
		setDashLine();
	}



	allRelease();



}


//ドラッグ中に動くモジュール
function mymousemove(){



	//MouseUp時に線の上だとイベントが発生しないため、
	//MouseMove時に仮線ではないオブジェクトを取得しておく
	if(event.srcElement.id!="dashline"){
		target2=event.srcElement;
	}



	if(mydrag){

		clearSelectedColor();

		var leftDiv = document.all.allObjDiv.childNodes[1];
		var rightDiv = document.all.allObjDiv.childNodes[3];

		if((target.parentNode==leftDiv)||(target.parentNode==rightDiv)){
			target.style.backgroundColor="C3F096";
		}
		if((target2.parentNode==leftDiv)||(target2.parentNode==rightDiv)){
			target2.style.backgroundColor="C3F096";
		}


		//ドラッグ中の座標
		newX = (event.clientX + document.body.scrollLeft) - 10;
		newY = (event.clientY + document.body.scrollTop);

		//クリック時の座標との差を算出する
		distanceX = (newX - currentX);
		distanceY = (newY - currentY);
		currentX = newX;
		currentY = newY;


		if(target.kind=='title'){
			//実際にエレメントを移動する。
			var moveObjId=selectedObjName.split("-");
			for(var i=0;i<moveObjId.length;i++){
				if(moveObjId[i]!=''){
					selectedObj[moveObjId[i]].style.pixelLeft += distanceX;
					selectedObj[moveObjId[i]].style.pixelTop += distanceY;
				}
			}

			//連なる線も移動する。
			if(selectedLineName!=""){
				var moveLineName=selectedLineName.split("-");
				for(var i=0;i<moveLineName.length;i++){
					if(linkPosition[moveLineName[i]]=="from"){
						autoLineChart(linkJibun[moveLineName[i]],linkAite[moveLineName[i]]);
					}else if(linkPosition[moveLineName[i]]=="to"){
						autoLineChart(linkAite[moveLineName[i]],linkJibun[moveLineName[i]]);
					}
					linkLine[moveLineName[i]].from=from_x + "," + from_y;
					linkLine[moveLineName[i]].to=to_x + "," + to_y;
				}
			}
		}else if(target.kind=='contents'){
			//仮線を移動する
			mouseLine.to=currentX + "," + currentY;
		}else if(target.kind=='body'){
		}
	}
}


//ドロップ時に動くモジュール
function mymouseup(){
	var objX,objXX;
	var objY,objYY;
	var insideX;
	var insideY;


	//ドラッグフラグの初期化
	mydrag=false;
	clearSelectedColor();



	if(target.kind=='body'){
	}else if(target.kind=='contents'){
		//仮線の初期化
		if(mouseLine!=null){
			mouseLine.from="0,0";
			mouseLine.to="0,0";
		}

		if((target.kind=='contents')&&(target2.kind=='contents')&&(target!=target2)&&(target.parentElement!=target2.parentElement)){
			makeLine(target,target2);
		}

	}

}

//マッピングラインを作成
function makeLine(fromObj,toObj){
	if((document.all(fromObj.id+","+toObj.id)!=undefined)||(document.all(toObj.id+","+fromObj.id)!=undefined)){
	//	alert("もうあるよ");
		return;
	}


	//線の所属情報を両オブジェクトに格納
	tempSize=document.createElement("<div id='f,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+fromObj.id+"' aite='"+toObj.id+"' position='from' top='"+from_y+"' left='"+from_x+"'>");
	fromObj.parentNode.lastChild.appendChild(tempSize);
	tempSize=document.createElement("<div id='t,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+toObj.id+"' aite='"+fromObj.id+"' position='to' top='"+to_y+"' left='"+to_x+"'>");
	toObj.parentNode.lastChild.appendChild(tempSize);

	//線オブジェクトの作成

	createLine=document.createElement("<v:line name='"+fromObj.id+","+toObj.id+"' id='"+fromObj.id+","+toObj.id+"' style='position:absolute;' from='0,0' to='0,0' selectedflg='0' strokecolor='"+lineColor+"' strokeweight='"+lineWeight+"' onclick='objectSelected(this);'>")
	createLine2=document.createElement("<v:stroke dashstyle='"+lineDashStyle+"' joinstyle='round' opacity='1' startarrow='"+beginLineType+"' endarrow='"+endLineType+"' style='z-index:99;'/>")
	createLine.appendChild(createLine2);
	autoLineChart(fromObj,toObj);
	createLine.from=from_x + "," + from_y;
	createLine.to=to_x + "," + to_y;

	//線を作成
	mouseLine=document.getElementById("dashline");
	mouseLine.parentNode.appendChild(createLine);

	//選択されているObjに線を引いた場合は、その線も次に引っ張る必要があるので、
	//setSelectLineにObjをわたし再設定する。
	if(fromObj.parentElement.className=='selectedDivObj'){
		setSelectedLine(fromObj.parentElement);//線も選択
	}
	if(toObj.parentElement.className=='selectedDivObj'){
		setSelectedLine(toObj.parentElement);//線も選択
	}

	chouseiScroll(createLine);
//	addJoinToDom(fromObj.parentNode.tablename,toObj.parentNode.tablename);

}



function allRelease(){
	if(!(event.shiftKey==true || event.ctrlKey==true)){

		//今まで選択されていた線を初期化
		var allObj=document.getElementById("lineSource");
		for(var i=0;i<allObj.childNodes.length;i++){
		//	allObj.childNodes[i].style.filter='';
			allObj.childNodes[i].strokecolor=lineColor;
			allObj.childNodes[i].selectedflg='0';
		}

	}

}



//オブジェクト反転処理
function objectSelected(obj){
	//オブジェクトを反転処理
//	if(obj.style.filter!='invert()'){
		allRelease();
	//	obj.style.filter='invert()';
		obj.strokecolor=selctedLineColor;
		obj.selectedflg='1';
//	}else{
//		obj.style.filter='';
//		obj.selectedflg='0';
//	}
}



function clearSelectedColor(){
	var leftDiv = document.all.allObjDiv.childNodes[1];
	var rightDiv = document.all.allObjDiv.childNodes[3];

	for(x=0;x<leftDiv.childNodes.length;x++){
		leftDiv.childNodes[x].style.backgroundColor="white";
	}
	for(x=0;x<rightDiv.childNodes.length;x++){
		rightDiv.childNodes[x].style.backgroundColor="white";
	}
}