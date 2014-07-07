<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<%
int maxLevel = Integer.parseInt(request.getParameter("maxLevel"));
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
var beginLineType="none";
var endLineType="open";
var lineColor="#ff9933";
var lineWeight="2pt";
var lineDashStyle="dash";





//�I�u�W�F�N�g�폜
function del(){
	for(var ob=0;ob<document.all.length;ob++){
		if(document.all(ob).style.filter=="invert()"){
			if(document.all(ob).tagName=="line"){
				deleteLine(document.all(ob).id);
			}else{
				if(document.all(ob).type=="seg"){
					alert("�Z�O�����g���x���͍폜�ł��܂���B");
					document.all(ob).style.filter='none()';
				}else{
					deleteObj(document.all(ob).id);
				}
			}
			ob=0;//��x�ɂЂ��Â��I�u�W�F�N�g�����������邩�킩��Ȃ��̂ŌJ��Ԃ��`�F�b�N����悤�ɂ��Ă���
		}
	}
	
	parent.levelCheck();
}


//�}�b�s���O���C���폜����
function deleteLine(delLineId){
	//���̍폜
	mouseLine=document.getElementById("dashline");
	var deleteLine=document.getElementById(delLineId);
	mouseLine.parentNode.removeChild(deleteLine);

	document.getElementById("f,"+delLineId).parentNode.parentNode.lastChild.removeChild(document.getElementById("f,"+delLineId));
	document.getElementById("t,"+delLineId).parentNode.parentNode.lastChild.removeChild(document.getElementById("t,"+delLineId));

	if(parent.document.getElementById("tbl_mapping").style.display=="block"){
		parent.showPpty(0);
	}
	var arr = delLineId.split(',');
	parent.document.form_main.elements["hid_lv" + arr[1].replace("body_","") + "_m_linkcol1"].value="";
	parent.document.form_main.elements["hid_lv" + arr[1].replace("body_","") + "_m_linkcol2"].value="";
	parent.document.form_main.elements["hid_lv" + arr[1].replace("body_","") + "_m_linkcol3"].value="";
	parent.document.form_main.elements["hid_lv" + arr[1].replace("body_","") + "_m_linkcol4"].value="";
	parent.document.form_main.elements["hid_lv" + arr[1].replace("body_","") + "_m_linkcol5"].value="";

}



//���x���폜����
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

	if(parent.document.getElementById("tbl_level").style.display=="block"){
		parent.showPpty(0);
	}

	//�I�u�W�F�N�g�̍폜
	loop_count=deleteObj.childNodes.length;
	for(j=0;j<loop_count;j++){
		deleteObj.removeChild(deleteObj.childNodes[0]);
	}


	//�B���I�u�W�F�N�g���폜�i�]�v�ȃG���[�`�F�b�N���������ׁj
	for(j=0;j<parent.document.all.div_hid.childNodes.length;j++){
		if(parent.document.all.div_hid.childNodes[j].name.indexOf("hid_lv"+deleteObj.objId+"_")!=-1){
			parent.document.all.div_hid.removeChild(parent.document.all.div_hid.childNodes[j]);
			j--;
		}
	}

	deleteObj.objId="0";
	deleteObj.style.display="none";


}



//��ʌŗL�̃}�b�s���O���C���쐬�`�F�b�N
function mappingErrCheck(fromObj,toObj){

	for(lineNum=0;lineNum<fromObj.parentNode.lastChild.childNodes.length;lineNum++){
		var arr = fromObj.parentNode.lastChild.childNodes[lineNum].id.split(',');
		if(arr[0] == "f"){
			showMsg("CHT2");
			return true;
		} 
	}
	for(lineNum=0;lineNum<toObj.parentNode.lastChild.childNodes.length;lineNum++){
		var arr = toObj.parentNode.lastChild.childNodes[lineNum].id.split(',');
		if(arr[0] == "t"){
			showMsg("CHT2");
			return true;
		} 
	}

	if(toObj.type=="seg"){
		alert("�Z�O�����g���x���͍ŏ�ʃ��x���łȂ���΂Ȃ�܂���B");
		return true;
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


<%for(i=1;i<=maxLevel;i++){%>
<div id="div_level<%=i%>" objId="0" level="" style="position:absolute;font-size:12px;border-right:2 solid #C2AC74;border-bottom:2 solid #C2AC74;display:none;"></div>
<%}%>



</body>
</html>


