<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<%
int maxDim = Integer.parseInt(request.getParameter("maxDim"));
int i;
%>




<html xmlns:v="urn:schemas-microsoft-com:vml"> 
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<title>OpenOLAP Model Designer</title>
<style>
v\:* { behavior: url(#default#VML); }
* { 
	font-style:Arial 'MS UI Gothic';
	font-size:12px;
}
</style>

<script languge="JavaScript">
<!--

//�}�b�s���O���C���̐ݒ�
var beginLineType="diamond";
var endLineType="diamond";
var lineColor="#ff9933";
var lineWeight="2pt";
var lineDashStyle="dash";









//�I�u�W�F�N�g�폜
function del(){
	for(var ob=0;ob<document.all.length;ob++){
		if(document.all(ob).style.filter=="invert()"){
			if(document.all(ob).tagName=="line"){
			//	alert("�t�@�N�g�Ƃ̃}�b�s���O�͍폜�ł��܂���B");
			//	document.all(ob).style.filter='none()';
			}else{
				if(document.all(ob).id=="head_fact"){
					alert("�t�@�N�g�͍폜�ł��܂���B");
					document.all(ob).style.filter='none()';
				}else{
					deleteObj(document.all(ob).id);
				}
				ob=0;//��x�ɂЂ��Â��I�u�W�F�N�g�����������邩�킩��Ȃ��̂ŌJ��Ԃ��`�F�b�N����悤�ɂ��Ă���
			}
		//	ob=0;//��x�ɂЂ��Â��I�u�W�F�N�g�����������邩�킩��Ȃ��̂ŌJ��Ԃ��`�F�b�N����悤�ɂ��Ă���
		}
	}
}


//�}�b�s���O���C���폜����
function deleteLine(delLineId){
	//���̍폜
	mouseLine=document.getElementById("dashline");
	var deleteLine=document.getElementById(delLineId);
	mouseLine.parentNode.removeChild(deleteLine);

//	document.getElementById("f,"+delLineId).parentNode.parentNode.lastChild.removeChild(document.getElementById("f,"+delLineId));
	document.getElementById("t,"+delLineId).parentNode.parentNode.lastChild.removeChild(document.getElementById("t,"+delLineId));

	if(parent.document.getElementById("tbl_mapping1").style.display=="block"){
		parent.showPpty(0);
	}
	if(parent.document.getElementById("tbl_mapping2").style.display=="block"){
		parent.showPpty(0);
	}
	var arr = delLineId.split(',');
	if(arr[0].replace("body_","")=="time"){
		parent.document.form_main.hid_time_col.value="";
		parent.document.form_main.hid_time_format.value="";
	}
}



//�����E���Ԏ����폜����
function deleteObj(delObjId){

	var deleteObj=document.getElementById(delObjId);
	if(deleteObj.parentElement.tagName!="BODY"){
		deleteObj=deleteObj.parentElement;
	}

	//�I�u�W�F�N�g�ɂЂ��Â������폜
	loop_count=deleteObj.lastChild.childNodes.length;
	for(j=0;j<loop_count;j++){
		arr = deleteObj.lastChild.childNodes[0].id.split(',');//�ЂƂÂq���������Ă����̂ŁA��Ƀm�[�h�ԍ��́u0�v�ƂȂ�
		deleteLine(arr[1]+","+arr[2]);
	}


	//�I�u�W�F�N�g�̍폜
	loop_count=deleteObj.childNodes.length;
	for(j=0;j<loop_count;j++){
		deleteObj.removeChild(deleteObj.childNodes[0]);
	}

	deleteObj.objId="0";
	deleteObj.style.display="none";


//	deleteObj.parentNode.removeChild(deleteObj);

}


//��ʌŗL�̃}�b�s���O���C���쐬�`�F�b�N
function mappingErrCheck(fromObj,toObj){
	if(fromObj.type=="dimension"){
		if(toObj.type!="fact"){
			showMsg("CHT2");
			return true;
		}
	}
	if(fromObj.type=="time"){
		if(toObj.type!="fact"){
			showMsg("CHT2");
			return true;
		}
	}

	return false;
}





//-->
</script>
	<script language="JavaScript" src="../js/chart.js"></script>
	<script language="JavaScript" src="../js/registration.js"></script>
</head>

<body onmousemove="mymousemove()" onmouseup="mymouseup()" onmousedown="mymousedown()" bgcolor="#F4FCF1" onselectstart="return false;">
<div name='lineSource' id='lineSource' style='position : absolute;top : 0px;left : 0px;z-index:99;'>
	<v:line name='dashline' id = 'dashline' style='position:absolute;' from='0,0' to='0,0' strokecolor='red' strokeweight='1pt'/>
</div>


<%for(i=1;i<=maxDim;i++){%>
<div id="div_dimension<%=i%>" objId="0" style="position:absolute;font-size:12px;border-right:2 solid #0e559c;border-bottom:2 solid #0e559c;display:none;"></div>
<%}%>


<div id="div_fact" objId="0" style="position:absolute;font-size:12px;border-right:2 solid #0e559c;border-bottom:2 solid #0e559c;display:none;"></div>
<div id="div_time" objId="0" style="position:absolute;font-size:12px;border-right:2 solid #0e559c;border-bottom:2 solid #0e559c;display:none;"></div>




</body>
</html>


