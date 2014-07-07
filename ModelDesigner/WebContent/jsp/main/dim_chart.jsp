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

//マッピングラインの設定
var beginLineType="none";
var endLineType="open";
var lineColor="#ff9933";
var lineWeight="2pt";
var lineDashStyle="dash";





//オブジェクト削除
function del(){
	for(var ob=0;ob<document.all.length;ob++){
		if(document.all(ob).style.filter=="invert()"){
			if(document.all(ob).tagName=="line"){
				deleteLine(document.all(ob).id);
			}else{
				if(document.all(ob).type=="seg"){
					alert("セグメントレベルは削除できません。");
					document.all(ob).style.filter='none()';
				}else{
					deleteObj(document.all(ob).id);
				}
			}
			ob=0;//一度にひもづくオブジェクトがいくつ消えるかわからないので繰り返しチェックするようにしている
		}
	}
	
	parent.levelCheck();
}


//マッピングライン削除処理
function deleteLine(delLineId){
	//線の削除
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



//レベル削除処理
function deleteObj(delObjId){

	var deleteObj=document.getElementById(delObjId);
	if(deleteObj.parentElement.tagName!="BODY"){
		deleteObj=deleteObj.parentElement;
	}

	//オブジェクトにひもづく線を削除
	loop_count=deleteObj.lastChild.childNodes.length;
	for(j=0;j<loop_count;j++){
		arr = deleteObj.lastChild.childNodes[0].id.split(',');//ひとつづつ子供が消えていくので、常にノード番号は「0」となる
		deleteLine(arr[1]+","+arr[2]);
	}

	if(parent.document.getElementById("tbl_level").style.display=="block"){
		parent.showPpty(0);
	}

	//オブジェクトの削除
	loop_count=deleteObj.childNodes.length;
	for(j=0;j<loop_count;j++){
		deleteObj.removeChild(deleteObj.childNodes[0]);
	}


	//隠しオブジェクトも削除（余計なエラーチェックを回避する為）
	for(j=0;j<parent.document.all.div_hid.childNodes.length;j++){
		if(parent.document.all.div_hid.childNodes[j].name.indexOf("hid_lv"+deleteObj.objId+"_")!=-1){
			parent.document.all.div_hid.removeChild(parent.document.all.div_hid.childNodes[j]);
			j--;
		}
	}

	deleteObj.objId="0";
	deleteObj.style.display="none";


}



//画面固有のマッピングライン作成チェック
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
		alert("セグメントレベルは最上位レベルでなければなりません。");
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


