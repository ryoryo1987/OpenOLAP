var target;//�}�E�X�_�E�����̃I�u�W�F�N�g
var target2;//�}�E�X�A�b�v���̃I�u�W�F�N�g
var targetbox;//�}�E�X�_�E�����̃I�u�W�F�N�g�̐e���C���[
var mydrag=0;//�h���b�O�t���O
var currentX=0;//���݂�X���W
var currentY=0;//���݂�Y���W
var mouseLine;//Mouse�łЂ����i�����j

var linkLine=new Array();//��������Object�ϐ�
var linkPosition=new Array();//����From��To�����Ă����ϐ�
var linkJibun=new Array();//������ID�����Ă����ϐ�
var linkAite=new Array();//�����ID�����Ă����ϐ�
var lineNum = 0;//�������{���邩�����Ă����B

var from_x;//���̍��W������ϐ�
var from_y;//���̍��W������ϐ�
var to_x;//���̍��W������ϐ�
var to_y;//���̍��W������ϐ�


//�Q�̃I�u�W�F�N�g�̍��W���r���čŒZ�̍��W���Z�b�g���郂�W���[��
function autoLineChart(obj1,obj2){

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


//�}�E�X�������ɓ������W���[��
function mymousedown(){

	//�S�Ă̔��]��Ԃ����Z�b�g
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

	//���݂̍��W���擾
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 

	//�J�n�ʒu���Z�b�g
	fromX = currentX;
	fromY = currentY;

	//�I�u�W�F�N�g�ɂЂ��Â�������ϐ��Ɋi�[����
	if(target.move==1){
		if(target.parentNode.lastChild.hasChildNodes()){
			for(lineNum=0;lineNum<target.parentNode.lastChild.childNodes.length;lineNum++){
				linkLine[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].name);
				linkPosition[lineNum]=target.parentNode.lastChild.childNodes[lineNum].position;
				linkJibun[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].jibun);
				linkAite[lineNum]=document.getElementById(target.parentNode.lastChild.childNodes[lineNum].aite);
			}
		}else{
			lineNum=0;//�R�Â��Ă�����͂Ȃ�
		}
	}

	//�����I�u�W�F�N�g���쐬
	if(target.move==2){
		mouseLine=document.getElementById("dashline");
		mouseLine.from=fromX + "," + fromY;
		mouseLine.to=fromX + "," + fromY;
	}

}


//�h���b�O���ɓ������W���[��
function mymousemove(){

	//�����ł͂Ȃ��I�u�W�F�N�g���擾����
	if(event.srcElement.id!="dashline"){
		target2=event.srcElement;
	}

	if(mydrag){
		//�h���b�O���̍��W
		newX = (event.clientX + document.body.scrollLeft);
		newY = (event.clientY + document.body.scrollTop);

		//�N���b�N���̍��W�Ƃ̍����Z�o����
		distanceX = (newX - currentX);
		distanceY = (newY - currentY);
		currentX = newX;
		currentY = newY;

		if(target.move==1){
			//���ۂɃG�������g���ړ�����B
			targetbox.style.pixelLeft += distanceX;
			targetbox.style.pixelTop += distanceY;

			//�A�Ȃ�����ړ�����B
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
			//�������ړ�����
			mouseLine.to=currentX + "," + currentY;
		}

	}

}


//�h���b�v���ɓ������W���[��
function mymouseup(){

	//�h���b�O�t���O�̏�����
	mydrag=0;

	//�����̏�����
	if(mouseLine!=null){
		mouseLine.from="0,0";
		mouseLine.to="0,0";
	}

	if((target.move==2)&&(target2.move==2)&&(target!=target2)&&(target.parentElement!=target2.parentElement)){
		makeLine(target,target2);
		parent.showPpty(0);
	}

}



//�}�b�s���O���C�����쐬
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


	//�e��ʌŗL�̃}�b�s���O���C���쐬�`�F�b�N
	if(mappingErrCheck(fromObj,toObj)){return;}

	//���̏������𗼃I�u�W�F�N�g�Ɋi�[
	tempSize=document.createElement("<div id='f,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+fromObj.id+"' aite='"+toObj.id+"' position='from' top='"+from_y+"' left='"+from_x+"'>");
	fromObj.parentNode.lastChild.appendChild(tempSize);
	tempSize=document.createElement("<div id='t,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+toObj.id+"' aite='"+fromObj.id+"' position='to' top='"+to_y+"' left='"+to_x+"'>");
	toObj.parentNode.lastChild.appendChild(tempSize);

	//���I�u�W�F�N�g�̍쐬
	createLine=document.createElement("<v:line name='"+fromObj.id+","+toObj.id+"' id='"+fromObj.id+","+toObj.id+"' style='position:absolute;' from='0,0' to='0,0' strokecolor='"+lineColor+"' strokeweight='"+lineWeight+"'  onclick='objectSelected(this);parent.showPpty("+showPrpyNum+",this);'>")
	createLine2=document.createElement("<v:stroke dashstyle='"+lineDashStyle+"' joinstyle='round' opacity='1' startarrow='"+beginLineType+"' endarrow='"+endLineType+"' style='z-index:99;'/>")
	createLine.appendChild(createLine2);
	autoLineChart(fromObj,toObj);
	createLine.from=from_x + "," + from_y;
	createLine.to=to_x + "," + to_y;

	//�����쐬
	mouseLine=document.getElementById("dashline");
	mouseLine.parentNode.appendChild(createLine);

}


//�I�u�W�F�N�g���]����
function objectSelected(obj){
	//�I�u�W�F�N�g�𔽓]����
	obj.style.filter='invert()';
}
