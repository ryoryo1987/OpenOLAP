

	var XMLDom = new ActiveXObject("MSXML2.DOMDocument");
	XMLDom.async = false;
//	XMLDom.load("data.xml");
	XMLDom=parent.getXMLData();
	var divId=0;

	var modifyXML = new ActiveXObject("MSXML2.DOMDocument");
	modifyXML.async = false;

	if(parent.getReportId!=undefined){
		var strSql=XMLDom.selectSingleNode("OpenOLAP/property/selectSql").getAttribute("sql");
		strSql=strSql.replace("%%report_id%%",parent.getReportId());
		modifyXML.load("chart_load.jsp?hid_sql="+strSql);
	}

//	alert(modifyXML.xml);

var id_Attr;
var par_id_Attr;
var name_Attr;
var type_Attr;
var measure_Attr;
var segmentPoint1;
var segmentPoint2;
var arr_popup_Attr = new Array();


function load(){
	id_Attr=XMLDom.selectSingleNode("OpenOLAP/property/obj_id").getAttribute("value");
	par_id_Attr=XMLDom.selectSingleNode("OpenOLAP/property/par_id").getAttribute("value");
	name_Attr=XMLDom.selectSingleNode("OpenOLAP/property/name").getAttribute("value");
	type_Attr=XMLDom.selectSingleNode("OpenOLAP/property/type").getAttribute("value");
	measure_Attr=XMLDom.selectSingleNode("OpenOLAP/property/measure").getAttribute("value");
	segmentPoint1=parseInt(XMLDom.selectSingleNode("OpenOLAP/property/point1").getAttribute("value"));
	segmentPoint2=parseInt(XMLDom.selectSingleNode("OpenOLAP/property/point2").getAttribute("value"));
	var junjo;
	if(segmentPoint1<=segmentPoint2){
		junjo=true;
	}else{
		junjo=false;
	}
	for(i=0;i<5;i++){
		arr_popup_Attr[i]=XMLDom.selectSingleNode("OpenOLAP/property/popup"+(i+1)).getAttribute("value");
	}


	if((id_Attr=="0")||(par_id_Attr=="0")||(name_Attr=="0")||(measure_Attr=="0")){
		return;
	}




	//�f�[�^XML����I�u�W�F�N�g�A�C�R���̐���
	for(i=0;i<XMLDom.selectSingleNode("//data").childNodes.length;i++){

		//type���J�����w��łȂ��ꍇ�́A�v�Z����type�����肷��
		if(type_Attr=="0"){
			var typeValue;

			var mesValue=parseInt(XMLDom.selectSingleNode("//data").childNodes[i].getAttribute(measure_Attr));

			if(junjo){
				if(mesValue<segmentPoint1){
					typeValue="NG";
				}else if(segmentPoint2<mesValue){
					typeValue="OK";
				}else{
					typeValue="warning";
				}
			}else{
				if(mesValue>segmentPoint1){
					typeValue="NG";
				}else if(segmentPoint2>mesValue){
					typeValue="OK";
				}else{
					typeValue="warning";
				}
			}
			XMLDom.selectSingleNode("//data").childNodes[i].setAttribute("type",typeValue);
		}

		displayObject(XMLDom.selectSingleNode("//data").childNodes[i]);
	}

	//�C��XML����I�u�W�F�N�g�A�C�R���̈ړ�
	modifyObjectPosition();

	//�f�[�^XML����}�b�s���O�̐���
	for(i=0;i<XMLDom.selectSingleNode("//data").childNodes.length;i++){
		if(XMLDom.selectSingleNode("//data").childNodes[i].getAttribute(par_id_Attr)!=""){

			//row��ID
			var thisId=XMLDom.selectSingleNode("//data").childNodes[i].getAttribute(id_Attr);
			var parId=XMLDom.selectSingleNode("//data").childNodes[i].getAttribute(par_id_Attr);



			//�I�u�W�F�N�gID�ƂȂ�row��PK�J�����A��
		//	var thisObjectID=getObjectID(XMLDom.selectSingleNode("//row[@id='" + thisId + "']"));
		//	var parObjectID=getObjectID(XMLDom.selectSingleNode("//row[@id='" + parId + "']"));

			//���C���̍쐬
			makeLine(document.all("icon" + parId),document.all("icon" + thisId),"original");

		}
	}

	//�C��XML����}�b�s���O�̒ǉ��E�폜
	modifyLine();

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




var divId=0;

/*
function getObjectID(rowObject){
	var tempObjectID="";
	for(pk=0;pk<XMLDom.selectSingleNode("//pkColumns").childNodes.length;pk++){
		if(tempObjectID!=""){tempObjectID+="-";}
		tempObjectID+=rowObject.getAttribute(XMLDom.selectSingleNode("//pkColumns").childNodes[pk].text);
	}
	return tempObjectID;
}
*/

function displayObject(rowObject){

//	var objectID=getObjectID(rowObject);
//	var objectID=rowObject.getAttribute("id");
	var objectID=rowObject.getAttribute(id_Attr);


//	var objectName=rowObject.getAttribute("nm");
	var objectName=rowObject.getAttribute(name_Attr);

	var objType=rowObject.getAttribute("type");








//	var pix_x=XMLDom.selectSingleNode("//Object[@nm='" + objectName + "']/position/left").text;
//	var pix_y=XMLDom.selectSingleNode("//Object[@nm='" + objectName + "']/position/top").text;
	var pix_x="0";
	var pix_y="0";

	if((pix_x=="0")&&(pix_y=="0")){
		var tempArr = new Array();
		tempArr = getVacantPixel().split(",");
		pix_x=tempArr[0];
		pix_y=tempArr[1];
	}

	var strDiv="";
	strDiv+="<div class='divObj' id='" + objectID + "' style='top:" + pix_y + ";left:" + pix_x + ";'>";
	strDiv+="	<div movable class='" + objType + "' id='icon" + objectID + "' objectName='" + objectName + "' style='width:32;height:32;' onmouseover='dispInfo(this)' onmouseout='clearInfo(this);'></div>";
	strDiv+="	<div style='position:relative;top:5;left:-32;width:96;text-align:center;'>" + objectName + "</div>";
	strDiv+="	<div></div>";
	strDiv+="</div>";

//	alert(strDiv);
	document.all.allObjDiv.innerHTML+=strDiv;

	divId++;

}



function pinClick(obj){
	if(obj.className=="popup_title_hall1"){
		obj.className=obj.className.replace("popup_title_hall1","popup_title_pin");
	}else{
		obj.className=obj.className.replace("popup_title_pin","popup_title_hall1");
	}
}


function dispInfo(obj){

	if(parent.document.all.hid_mode.value!='Look'){
		return;
	}
	if(mydrag==1){
		return;
	}

	var objectName=obj.objectName;
	var rowId=obj.parentNode.id;


	var mokuhyou="mokuhyou";
	var jisseki="jisseki";
	var sai="sai";
	var koushinbi="koushinbi";
	var comment="comment";

	var strDivInfo="";
	strDivInfo+="<div id='" + objectName + "_info" + "' objectName='" + objectName + "' style='position:absolute;top:" + obj.parentNode.offsetTop + ";left:" + (obj.parentNode.offsetLeft+10) + ";z-index:9999;' onmouseout='clearInfo(this)'>";
	strDivInfo+="	<nobr>";
	strDivInfo+="		<div class='popup_title_hall1' onclick='pinClick(this)'>&nbsp;</div>";
	strDivInfo+="		<div class='popup_title_name' style='overflow-x:hidden;'>" + XMLDom.selectSingleNode("//data/row[@"+id_Attr+"='"+rowId+"']").getAttribute(name_Attr) + "</div>";
	strDivInfo+="		<div class='popup_title_right'></div>";
	strDivInfo+="	</nobr>";
	strDivInfo+="	<div class='popup_data_table'>";

	for(i=0;i<arr_popup_Attr.length;i++){
		if(arr_popup_Attr[i]!="0"){
			strDivInfo+="		<div>";
			strDivInfo+="			<nobr>";
			strDivInfo+="				<div class='popup_title' style='overflow-x:hidden;'>"+arr_popup_Attr[i]+"</div>";
			strDivInfo+="				<div class='popup_data'>" + XMLDom.selectSingleNode("//data/row[@"+id_Attr+"='"+rowId+"']").getAttribute(arr_popup_Attr[i]) + "</div>";
			strDivInfo+="			</nobr>";
			strDivInfo+="		</div>";
		}
	}


/*
	strDivInfo+="	<table>";
	for(i=0;i<arr_popup_Attr.length;i++){
		if(arr_popup_Attr[i]!="0"){
			strDivInfo+="		<tr>";
			strDivInfo+="			<td class='popup_title'>" + arr_popup_Attr[i] + "</td>";
			strDivInfo+="			<td class='popup_data'>" + XMLDom.selectSingleNode("//data/row[@"+id_Attr+"='"+rowId+"']").getAttribute(arr_popup_Attr[i]) + "</td>";
			strDivInfo+="		</tr>";
		}
	}
	strDivInfo+="		</table>";
*/

	strDivInfo+="		<div class='popup_bottom'>";
	strDivInfo+="		</div>";

	strDivInfo+="	</div>";
//	strDivInfo+="	<div class='popup_data_table'>";
//	strDivInfo+="		<div class='popup_comment'>" + comment + "</div>";
//	strDivInfo+="		<div class='popup_link'><a href='aaa'>�ڍ�...</a></div>";
//	strDivInfo+="	</div>";
	strDivInfo+="</div>";


	if(document.all(objectName+"_info")==undefined){
		document.all.allObjDiv2.innerHTML+=strDivInfo;//allObjDiv2�ł͂Ȃ�allObjDiv���g����onmouseout�C�x���g�����܂����Ȃ�
	}
}


function clearInfo(obj){

	if(parent.document.all.hid_mode.value!='Look'){
		return;
	}

	var objectName=obj.objectName;

	var tempObj=event.toElement;

//	if(tempObj==undefined){
//		return;
//	}

	while(tempObj.tagName!="BODY"){
		if(tempObj.objectName!=undefined){
			return;
		}
		tempObj=tempObj.parentNode;
	}

//	if(event.toElement.objectName!=undefined){
//		return;
//	}
	if(document.all(objectName+"_info")==undefined){
		return;
	}
	if(document.all(objectName+"_info").firstChild.firstChild.className=="popup_title_pin"){
		return;
	}
	if(mydrag==1){
		return;
	}
//	if(document.all(objectName+"_info")!=undefined){
		document.all.allObjDiv2.removeChild(document.all(objectName+"_info"));
//	}
}




function save(){

	var strXML="<?xml version='1.0' encoding='Shift_JIS' ?>";
	strXML+="<Modify>";
	strXML+="<Objects>";
	for(i=0;i<document.all.allObjDiv.childNodes.length;i++){
		var objectID=document.all.allObjDiv.childNodes[i].id;
		var left=document.all.allObjDiv.childNodes[i].style.pixelLeft;
		var top=document.all.allObjDiv.childNodes[i].style.pixelTop;
		strXML+="<Object id='" + objectID + "'>";
		strXML+="<Position>";
		strXML+="<left>" + left + "</left>";
		strXML+="<top>" + top + "</top>";
		strXML+="</Position>";
		strXML+="</Object>";
	}
	strXML+="</Objects>";
	strXML+="<Lines>";
	strXML+="<addLines>";
	for(i=0;i<document.all.lineSource.childNodes.length;i++){
		if(document.all.lineSource.childNodes[i].flg=="add"){
			strXML+="<Line>" + document.all.lineSource.childNodes[i].id + "</Line>";
		}
	}
	strXML+="</addLines>";
	strXML+="<delLines>";
	for(i=0;i<document.all.lineSource.childNodes.length;i++){
		if((document.all.lineSource.childNodes[i].flg=="original")&&(document.all.lineSource.childNodes[i].style.display=="none")){
			strXML+="<Line>" + document.all.lineSource.childNodes[i].id + "</Line>";
		}
	}
	strXML+="</delLines>";
	strXML+="</Lines>";

	strXML+="</Modify>";



	var strSql=XMLDom.selectSingleNode("OpenOLAP/property/saveSql").getAttribute("sql");
	var tempSql=strXML.replace(/'/g,"''");
	strSql=strSql.replace("%%data%%",tempSql);
	strSql=strSql.replace("%%report_id%%",parent.getReportId());

	document.form_main.hid_sql.value=strSql;


	if(confirm("���|�[�g��ۑ����܂��B��낵���ł����H")){
		document.form_main.target="frm_hidden";
		document.form_main.action="chart_regist.jsp";
		document.form_main.submit();
	}



}




function modifyObjectPosition(){
	if(modifyXML.selectSingleNode("//Modify")==null){return;}

	for(x=0;x<modifyXML.selectSingleNode("//Objects").childNodes.length;x++){
		var objectID=modifyXML.selectSingleNode("//Objects").childNodes[x].getAttribute("id");
		var thisObject=modifyXML.selectSingleNode("//Objects").childNodes[x];
		document.all(objectID).style.pixelLeft=thisObject.selectSingleNode("./Position/left").text;
		document.all(objectID).style.pixelTop=thisObject.selectSingleNode("./Position/top").text;
	}

}


function modifyLine(){
	if(modifyXML.selectSingleNode("//Modify")==null){return;}

	for(x=0;x<modifyXML.selectSingleNode("//addLines").childNodes.length;x++){
		var tempArr = new Array();
		tempArr = modifyXML.selectSingleNode("//addLines").childNodes[x].text.split(",");
		makeLine(document.all(tempArr[0]),document.all(tempArr[1]),"add")
	}

	for(x=0;x<modifyXML.selectSingleNode("//delLines").childNodes.length;x++){
		document.all(modifyXML.selectSingleNode("//delLines").childNodes[x].text).style.display="none";
	}
}




//�I�u�W�F�N�g�폜
function del(){

	if(parent.document.all.hid_mode.value!='Line'){
		return;
	}

//	alert('del');
	for(var ob=0;ob<document.all.length;ob++){
		var obj=document.all(ob);
		if(obj.tagName=="line"){
			if(obj.strokecolor==selectedLineColor){
				if(obj.flg=="original"){
					obj.style.display="none";
				}else if(obj.flg=="add"){
					deleteLine(obj);
					ob=0;//��x�ɂЂ��Â��I�u�W�F�N�g�����������邩�킩��Ȃ��̂ŌJ��Ԃ��`�F�b�N����悤�ɂ��Ă���
				}
			}
		}
	}
}

function deleteLine(delObj){
	document.getElementById("f," + delObj.id).parentNode.removeChild(document.getElementById("f," + delObj.id));
	document.getElementById("t," + delObj.id).parentNode.removeChild(document.getElementById("t," + delObj.id));

	//���C�����폜
	delObj.parentNode.removeChild(delObj);

}




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

	var objPx=30;//�I�u�W�F�N�g�̈�ӂ̒���/2

	var obj1X=obj1.parentNode.offsetLeft+(obj1.offsetWidth/2);
	var obj1Y=obj1.parentNode.offsetTop+(obj1.offsetHeight/2);
	var obj2X=obj2.parentNode.offsetLeft+(obj2.offsetWidth/2);
	var obj2Y=obj2.parentNode.offsetTop+(obj2.offsetHeight/2);


	//���ꂼ��̒���
	var Xline=Math.abs(obj1X-obj2X);
	var Yline=Math.abs(obj1Y-obj2Y);

	if(Xline>Yline){//X�i�����C���j�̕�������
		if(obj1X<=obj2X){
			from_x=obj1X+objPx;
			to_x=obj2X-objPx;
		}else if(obj1X>obj2X){
			from_x=obj1X-objPx;
			to_x=obj2X+objPx;
		}
		if(obj1Y<=obj2Y){
			from_y=obj1Y+(Yline/Xline*objPx);
			to_y=obj2Y-(Yline/Xline*objPx);
		}else if(obj1Y>obj2Y){
			from_y=obj1Y-(Yline/Xline*objPx);
			to_y=obj2Y+(Yline/Xline*objPx);
		}
	}else if(Yline>Xline){//Y�i�c���C���j�̕�������
		if(obj1X<=obj2X){
			from_x=obj1X+(Xline/Yline*objPx);
			to_x=obj2X-(Xline/Yline*objPx);
		}else if(obj1X>obj2X){
			from_x=obj1X-(Xline/Yline*objPx);
			to_x=obj2X+(Xline/Yline*objPx);
		}
		if(obj1Y<=obj2Y){
			from_y=obj1Y+objPx;
			to_y=obj2Y-objPx;
		}else if(obj1Y>obj2Y){
			from_y=obj1Y-objPx;
			to_y=obj2Y+objPx;
		}
	}else{
		if(obj1X<=obj2X){
			from_x=obj1X+objPx;
			to_x=obj2X-objPx;
		}else if(obj1X>obj2X){
			from_x=obj1X-objPx;
			to_x=obj2X+objPx;
		}
		if(obj1Y<=obj2Y){
			from_y=obj1Y+objPx;
			to_y=obj2Y-objPx;
		}else if(obj1Y>obj2Y){
			from_y=obj1Y-objPx;
			to_y=obj2Y+objPx;
		}
	}

}





//�}�E�X�������ɓ������W���[��
function mymousedown(){


	//�S�Ă̔��]��Ԃ����Z�b�g
	if(event.srcElement.id!="delete_btn"){
		if(event.shiftKey==false){
			for(var ob=0;ob<document.all.length;ob++){
			//	document.all(ob).style.filter='none()';
				document.all(ob).strokecolor=lineColor;
			}
		}
	}


	target=event.srcElement;
	if(target.tagName=="BODY"||target.tagName=="line"||target.movable==undefined){
		mydrag=0;
		return;
	}else{
		mydrag=1;
	}


	if(parent.document.all.hid_mode.value=='Move'){
		targetbox = target.parentNode;
	}else if(parent.document.all.hid_mode.value=='Look'){
		targetbox = target.parentNode.parentNode;
	}

	if(target.className==undefined){mydrag=0;return;}

	//���݂̍��W���擾
	currentX = (event.clientX + document.body.scrollLeft);
	currentY = (event.clientY + document.body.scrollTop); 

	//�J�n�ʒu���Z�b�g
	fromX = currentX;
	fromY = currentY;

	//�I�u�W�F�N�g�ɂЂ��Â�������ϐ��Ɋi�[����
	if(parent.document.all.hid_mode.value=='Move'){
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
	if((parent.document.all.hid_mode.value=='Line')&&((target2.className=='OK')||(target2.className=='warning')||(target2.className=='NG'))){
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

		if((parent.document.all.hid_mode.value=='Move')&&(target.tagName=="DIV")){
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
				if(linkLine[i]!=null){
					linkLine[i].from=from_x + "," + from_y;
					linkLine[i].to=to_x + "," + to_y;
				}
			}

	//	}else if((parent.document.all.hid_mode.value=='Line')&&((target2.className=='OK')||(target2.className=='warning')||(target2.className=='NG'))){
		}else if(parent.document.all.hid_mode.value=='Line'){
			//�������ړ�����
			mouseLine.to=currentX + "," + currentY;

		}else if((parent.document.all.hid_mode.value=='Look')&&(target.className=="popup_title_name")){
			//���ۂɃG�������g���ړ�����B
			targetbox.style.pixelLeft += distanceX;
			targetbox.style.pixelTop += distanceY;

		//	if(target.parentNode!=undefined){
				target.parentNode.parentNode.firstChild.firstChild.className=target.parentNode.parentNode.firstChild.firstChild.className.replace("popup_title_pin","popup_title_hall2");
		//	}
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

	if(target.tagName=="BODY"){
		return;
	}


	if((parent.document.all.hid_mode.value=='Line')&&((target2.className=='OK')||(target2.className=='warning')||(target2.className=='NG'))&&(target!=target2)&&(target.parentElement!=target2.parentElement)){
		makeLine(target,target2,"add");
	//	parent.showPpty(0);
	}

	if((parent.document.all.hid_mode.value=='Look')&&(target.className=="popup_title_name")){
	//	if(target.parentNode!=undefined){
			target.parentNode.parentNode.firstChild.firstChild.className=target.parentNode.parentNode.firstChild.firstChild.className.replace("popup_title_hall2","popup_title_pin");
	//	}
	}

}


//���I�u�W�F�N�g�̍쐬
var lineColor='gray';
var selectedLineColor='red';
var lineWeight='2px';
var lineDashStyle='solid';
var beginLineType='none';
var endLineType='open';

//�}�b�s���O���C�����쐬
function makeLine(fromObj,toObj,flg){
	if(fromObj==null){
		return;
	}

	if(document.getElementById(fromObj.id+","+toObj.id)!=null){
		if(document.getElementById(fromObj.id+","+toObj.id).flg=="original"){
			document.getElementById(fromObj.id+","+toObj.id).style.display="block";
		}
		return;
	}
	if(document.getElementById(toObj.id+","+fromObj.id)!=null){
		if(document.getElementById(toObj.id+","+fromObj.id).flg=="original"){
			document.getElementById(toObj.id+","+fromObj.id).style.display="block";
		}
		return;
	}



	//�e��ʌŗL�̃}�b�s���O���C���쐬�`�F�b�N
//	if(mappingErrCheck(fromObj,toObj)){return;}

	//���̏������𗼃I�u�W�F�N�g�Ɋi�[
	tempSize=document.createElement("<div id='f,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+fromObj.id+"' aite='"+toObj.id+"' position='from' top='"+from_y+"' left='"+from_x+"'>");
	fromObj.parentNode.lastChild.appendChild(tempSize);
	tempSize=document.createElement("<div id='t,"+fromObj.id+","+toObj.id+"' name='"+fromObj.id+","+toObj.id+"' jibun='"+toObj.id+"' aite='"+fromObj.id+"' position='to' top='"+to_y+"' left='"+to_x+"'>");
	toObj.parentNode.lastChild.appendChild(tempSize);


	createLine=document.createElement("<v:line flg='"+flg+"' name='"+fromObj.id+","+toObj.id+"' id='"+fromObj.id+","+toObj.id+"' style='position:absolute;display:block;' from='0,0' to='0,0' strokecolor='"+lineColor+"' strokeweight='"+lineWeight+"'  onclick='objectSelected(this);'>")
	createLine2=document.createElement("<v:stroke dashstyle='"+lineDashStyle+"' joinstyle='round' opacity='1' startarrow='"+beginLineType+"' endarrow='"+endLineType+"' style='z-index:0;'/>")
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
	if(parent.document.all.hid_mode.value=='Line'){

		if(obj.strokecolor==lineColor){
			obj.strokecolor=selectedLineColor;
		}else{
			obj.strokecolor=lineColor;
		}
	//	obj.style.filter='invert()';
	}
}
