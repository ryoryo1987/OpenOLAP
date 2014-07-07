var target;//�}�E�X�_�E�����̃I�u�W�F�N�g
var target2;//�}�E�X�A�b�v���̃I�u�W�F�N�g
var targetbox;//�}�E�X�_�E�����̃I�u�W�F�N�g�̊O��Div
var mydrag=false;//�h���b�O�t���O
var currentX=0;//���݂�X���W
var currentY=0;//���݂�Y���W
var mouseLine;//Mouse�łЂ����i�����j

//���I�u�W�F�N�g�̍쐬
var lineColor='green';
var selctedLineColor='red';
var lineWeight='2px';
var lineDashStyle='solid';
var beginLineType='diamond';
var endLineType='diamond';

var linkLine=new Array();//��������Object�ϐ�
var linkPosition=new Array();//����From��To�����Ă����ϐ�
var linkJibun=new Array();//������ID�����Ă����ϐ�
var linkAite=new Array();//�����ID�����Ă����ϐ�

var from_x;//���̍��W������ϐ�
var from_y;//���̍��W������ϐ�
var to_x;//���̍��W������ϐ�
var to_y;//���̍��W������ϐ�



//�Q�̃I�u�W�F�N�g�̍��W���r���čŒZ�̍��W���Z�b�g���郂�W���[��
function autoLineChart(obj1,obj2){
//obj1,obj2=��ԊO����Div

	//X���W�������v�Z
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

	//X���W���Z�b�g
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

	//Y���W���Z�b�g
	obj1_top = obj1.parentNode.offsetTop + obj1.offsetTop + (obj1.offsetHeight/2)
	obj2_top = obj2.parentNode.offsetTop + obj2.offsetTop + (obj2.offsetHeight/2)
	from_y=obj1_top;
	to_y=obj2_top;

}


//Contents��MouseDown�����ꍇ����
function setDashLine(){
	mouseLine=document.getElementById("dashline");
	mouseLine.from=fromX + "," + fromY;
	mouseLine.to=fromX + "," + fromY;
}

//�I�����ꂽObject�ɔ���Â��Ă��������ϐ��ɕۑ��B
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
		setSelectedLine(targetbox);//�����I��
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

//�}�E�X�������ɓ������W���[��
function mymousedown(){
	target=event.srcElement;
	mydrag=true;

	//���݂̍��W���擾
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 

	//�J�n�ʒu���Z�b�g
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


//�h���b�O���ɓ������W���[��
function mymousemove(){



	//MouseUp���ɐ��̏ゾ�ƃC�x���g���������Ȃ����߁A
	//MouseMove���ɉ����ł͂Ȃ��I�u�W�F�N�g���擾���Ă���
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


		//�h���b�O���̍��W
		newX = (event.clientX + document.body.scrollLeft) - 10;
		newY = (event.clientY + document.body.scrollTop);

		//�N���b�N���̍��W�Ƃ̍����Z�o����
		distanceX = (newX - currentX);
		distanceY = (newY - currentY);
		currentX = newX;
		currentY = newY;


		if(target.kind=='title'){
			//���ۂɃG�������g���ړ�����B
			var moveObjId=selectedObjName.split("-");
			for(var i=0;i<moveObjId.length;i++){
				if(moveObjId[i]!=''){
					selectedObj[moveObjId[i]].style.pixelLeft += distanceX;
					selectedObj[moveObjId[i]].style.pixelTop += distanceY;
				}
			}

			//�A�Ȃ�����ړ�����B
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
			//�������ړ�����
			mouseLine.to=currentX + "," + currentY;
		}else if(target.kind=='body'){
		}
	}
}


//�h���b�v���ɓ������W���[��
function mymouseup(){
	var objX,objXX;
	var objY,objYY;
	var insideX;
	var insideY;


	//�h���b�O�t���O�̏�����
	mydrag=false;
	clearSelectedColor();



	if(target.kind=='body'){
	}else if(target.kind=='contents'){
		//�����̏�����
		if(mouseLine!=null){
			mouseLine.from="0,0";
			mouseLine.to="0,0";
		}

		if((target.kind=='contents')&&(target2.kind=='contents')&&(target!=target2)&&(target.parentElement!=target2.parentElement)){
			makeLine(target,target2);
		}

	}

}

//�}�b�s���O���C�����쐬
function makeLine(fromObj,toObj){
	if((document.all(fromObj.id+","+toObj.id)!=undefined)||(document.all(toObj.id+","+fromObj.id)!=undefined)){
	//	alert("���������");
		return;
	}


	//���̏������𗼃I�u�W�F�N�g�Ɋi�[
	tempSize=document.createElement("<div id='f,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+fromObj.id+"' aite='"+toObj.id+"' position='from' top='"+from_y+"' left='"+from_x+"'>");
	fromObj.parentNode.lastChild.appendChild(tempSize);
	tempSize=document.createElement("<div id='t,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+toObj.id+"' aite='"+fromObj.id+"' position='to' top='"+to_y+"' left='"+to_x+"'>");
	toObj.parentNode.lastChild.appendChild(tempSize);

	//���I�u�W�F�N�g�̍쐬

	createLine=document.createElement("<v:line name='"+fromObj.id+","+toObj.id+"' id='"+fromObj.id+","+toObj.id+"' style='position:absolute;' from='0,0' to='0,0' selectedflg='0' strokecolor='"+lineColor+"' strokeweight='"+lineWeight+"' onclick='objectSelected(this);'>")
	createLine2=document.createElement("<v:stroke dashstyle='"+lineDashStyle+"' joinstyle='round' opacity='1' startarrow='"+beginLineType+"' endarrow='"+endLineType+"' style='z-index:99;'/>")
	createLine.appendChild(createLine2);
	autoLineChart(fromObj,toObj);
	createLine.from=from_x + "," + from_y;
	createLine.to=to_x + "," + to_y;

	//�����쐬
	mouseLine=document.getElementById("dashline");
	mouseLine.parentNode.appendChild(createLine);

	//�I������Ă���Obj�ɐ����������ꍇ�́A���̐������Ɉ�������K�v������̂ŁA
	//setSelectLine��Obj���킽���Đݒ肷��B
	if(fromObj.parentElement.className=='selectedDivObj'){
		setSelectedLine(fromObj.parentElement);//�����I��
	}
	if(toObj.parentElement.className=='selectedDivObj'){
		setSelectedLine(toObj.parentElement);//�����I��
	}

	chouseiScroll(createLine);
//	addJoinToDom(fromObj.parentNode.tablename,toObj.parentNode.tablename);

}



function allRelease(){
	if(!(event.shiftKey==true || event.ctrlKey==true)){

		//���܂őI������Ă�������������
		var allObj=document.getElementById("lineSource");
		for(var i=0;i<allObj.childNodes.length;i++){
		//	allObj.childNodes[i].style.filter='';
			allObj.childNodes[i].strokecolor=lineColor;
			allObj.childNodes[i].selectedflg='0';
		}

	}

}



//�I�u�W�F�N�g���]����
function objectSelected(obj){
	//�I�u�W�F�N�g�𔽓]����
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