var target;//マウスダウン時のオブジェクト
var target2;//マウスアップ時のオブジェクト
var targetbox;//マウスダウン時のオブジェクトの親レイヤー
var mydrag=0;//ドラッグフラグ
var currentX=0;//現在のX座標
var currentY=0;//現在のY座標
var mouseLine;//Mouseでひく線（仮線）

var linkLine=new Array();//線を入れるObject変数
var linkPosition=new Array();//線のFromかToを入れておく変数
var linkJibun=new Array();//自分のIDを入れておく変数
var linkAite=new Array();//相手のIDを入れておく変数
var lineNum = 0;//線が何本あるかを入れておく。

var from_x;//線の座標を入れる変数
var from_y;//線の座標を入れる変数
var to_x;//線の座標を入れる変数
var to_y;//線の座標を入れる変数


//２つのオブジェクトの座標を比較して最短の座標をセットするモジュール
function autoLineChart(obj1,obj2){

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


//マウス押下時に動くモジュール
function mymousedown(){

	//全ての反転状態をリセット
	if(event.srcElement.id!="delete_btn"){
		if(event.shiftKey==false){
			for(var ob=0;ob<document.all.length;ob++){
				document.all(ob).style.filter='none()';
			}
		}
	}

	if(parent.showPpty!=undefined){
		parent.showPpty(0);
	}


	mydrag=1;
	target=event.srcElement;
	targetbox = target.parentElement;
	if(target.move==undefined){mydrag=0;return;}

	//現在の座標を取得
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 

	//開始位置をセット
	fromX = currentX;
	fromY = currentY;

	//オブジェクトにひもづく線情報を変数に格納する
	if(target.move==1){
		if(target.parentNode.lastChild.hasChildNodes()){
			for(lineNum=0;lineNum<target.parentNode.lastChild.childNodes.length;lineNum++){
				linkLine[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].name);
				linkPosition[lineNum]=target.parentNode.lastChild.childNodes[lineNum].position;
				linkJibun[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].jibun);
				linkAite[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].aite);
			}
		}else{
			lineNum=0;//紐づいている線はなし
		}
	}

	//仮線オブジェクトを作成
	if(target.move==2){
		mouseLine=document.getElementById("dashline");
		mouseLine.from=fromX + "," + fromY;
		mouseLine.to=fromX + "," + fromY;
	}

}


//ドラッグ中に動くモジュール
function mymousemove(){

	//仮線ではないオブジェクトを取得する
	if(event.srcElement.id!="dashline"){
		target2=event.srcElement;
	}

	if(mydrag){
		//ドラッグ中の座標
		newX = (event.clientX + document.body.scrollLeft);
		newY = (event.clientY + document.body.scrollTop);

		//クリック時の座標との差を算出する
		distanceX = (newX - currentX);
		distanceY = (newY - currentY);
		currentX = newX;
		currentY = newY;

		if(target.move==1){
			//実際にエレメントを移動する。
			targetbox.style.pixelLeft += distanceX;
			targetbox.style.pixelTop += distanceY;

			//連なる線も移動する。
			for(var i=0;i<lineNum;i++){
				if(linkPosition[i]=="from"){
					autoLineChart(linkJibun[i],linkAite[i]);
				}else if(linkPosition[i]=="to"){
					autoLineChart(linkAite[i],linkJibun[i]);
				}
				linkLine[i].from=from_x + "," + from_y;
				linkLine[i].to=to_x + "," + to_y;
			}

		}else if(target.move==2){
			//仮線を移動する
			mouseLine.to=currentX + "," + currentY;
		}

	}

}


//ドロップ時に動くモジュール
function mymouseup(){

	//ドラッグフラグの初期化
	mydrag=0;

	//仮線の初期化
	if(mouseLine!=null){
		mouseLine.from="0,0";
		mouseLine.to="0,0";
	}

	if((target.move==2)&&(target2.move==2)&&(target!=target2)&&(target.parentElement!=target2.parentElement)){
		makeLine(target,target2);
		parent.showPpty(0);
	}

}



//マッピングラインを作成
function makeLine(fromObj,toObj,showPrpyNum){
	if(showPrpyNum==undefined){showPrpyNum=11;}


	if(document.getElementById(fromObj.id+","+toObj.id)!=null){
		showMsg("CHT1");
		return;
	}
	if(document.getElementById(toObj.id+","+fromObj.id)!=null){
		showMsg("CHT1");
		return;
	}


	//各画面固有のマッピングライン作成チェック
	if(mappingErrCheck(fromObj,toObj)){return;}

	//線の所属情報を両オブジェクトに格納
	tempSize=document.createElement("<div id='f,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+fromObj.id+"' aite='"+toObj.id+"' position='from' top='"+from_y+"' left='"+from_x+"'>");
	fromObj.parentNode.lastChild.appendChild(tempSize);
	tempSize=document.createElement("<div id='t,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+toObj.id+"' aite='"+fromObj.id+"' position='to' top='"+to_y+"' left='"+to_x+"'>");
	toObj.parentNode.lastChild.appendChild(tempSize);

	//線オブジェクトの作成
	createLine=document.createElement("<v:line name='"+fromObj.id+","+toObj.id+"' id='"+fromObj.id+","+toObj.id+"' style='position:absolute;' from='0,0' to='0,0' strokecolor='"+lineColor+"' strokeweight='"+lineWeight+"'  onclick='objectSelected(this);parent.showPpty("+showPrpyNum+",this);'>")
	createLine2=document.createElement("<v:stroke dashstyle='"+lineDashStyle+"' joinstyle='round' opacity='1' startarrow='"+beginLineType+"' endarrow='"+endLineType+"' style='z-index:99;'/>")
	createLine.appendChild(createLine2);
	autoLineChart(fromObj,toObj);
	createLine.from=from_x + "," + from_y;
	createLine.to=to_x + "," + to_y;

	//線を作成
	mouseLine=document.getElementById("dashline");
	mouseLine.parentNode.appendChild(createLine);

}


//オブジェクト反転処理
function objectSelected(obj){
	//オブジェクトを反転処理
	obj.style.filter='invert()';
}
