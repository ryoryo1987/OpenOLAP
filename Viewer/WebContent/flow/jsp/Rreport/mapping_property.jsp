<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<link rel="stylesheet" type="text/css" href="../../../css/window.css">

</head>
<body>

<!--��ʃv���p�e�B�E�B���h�E-->
<div style="margin-left:5;margin-top:7">
	<div>
		<div class="window_title_left_4"> </div>
		<div class="window_title_name_4" style="width:250">��ʃv���p�e�B</div>
		<div class="window_title_button_4" style="display:none"> <!--���̃o�[�W�����ł͔�\��-->
			<img src="../../../images/portal/window_no_disp_4.gif"><img src="../../../images/portal/window_full_screen_4.gif">
		</div>
		<div class="window_title_right_4"></div>
	</div>
	<div style="height:100">
		<div class="window_contents_frame_4"></div>
		<div class="window_contents_center" style="width:257;vertical-align:top;text-align:right">
			<!--�R���e���c�pDIV-->
			<input type='button' value='' name='dispSQL' onclick='clickDisplaySQL()' class="normal_sql" onMouseOver="className='over_sql'" onMouseDown="className='down_sql'" onMouseUp="className='up_sql'" onMouseOut="className='out_sql'">
			<div id="screenContents" class='contents' style='display:block'>
			</div>
		</div>
		<div class="window_contents_frame_4"></div>
	</div>
	<div>
		<div class="window_footer_left_4"></div>
		<div class="window_footer_center_4" style="width:240"></div>
		<div class="window_footer_right_nomark_4"></div>
	</div>
</div>


</body>
</html>

<script>
function setDisplay(dispName){
	var dispObj= document.getElementById(dispName);
	if(dispObj.style.display=='none'){
		dispObj.style.display='block';
	}else{
		dispObj.style.display='none';
	};

}

var xmlData;
function displayScreenProperty(){
	xmlData = parent.parent.frm_backNext.getScreenXML();
	var propertyXML = xmlData.selectNodes("//*[@rewrite='true']");
	var setName="";

	var strHTML="";
	var setKindHTML="";
	var propertyId="";
	var selectedFlg="";
	var propKind="";

	strHTML+="<table style='width:95%;margin:0 3'>";
	for(i=0;i<propertyXML.length;i++){
		setName=propertyXML.item(i).getAttribute("setName");//���ۂɒl�������Ă��鑮���������߂�
		propertyId=propertyXML.item(i).getAttribute("propertyId");//��ӂ�ID
		setVal=propertyXML.item(i).getAttribute(setName);//�ݒ肳��Ă���l
		propKind=propertyXML.item(i).getAttribute("propKind");//���

		//**************Text******************
		if(propertyXML.item(i).getAttribute("setKind")=='text'){
			setKindHTML="<input type='text' propKind='"+propKind+"' value='"+setVal+"' onChange='changeProperty(this.value,"+propertyId+");'>";
			strHTML+="	<tr class='standard'>";
			strHTML+="		<th class='standard'>"+propertyXML.item(i).getAttribute("dispStr")+"</th>";
			strHTML+="		<td class='standard'>"+setKindHTML+"</td>";
			strHTML+="	</tr>";
		//**************List******************
		}else if(propertyXML.item(i).getAttribute("setKind")=='list'){
			var listValKind = propertyXML.item(i).getAttribute("listValKind");
			if(listValKind=='fix'){
				var selList = propertyXML.item(i).getAttribute("listVal");
				var listArray=selList.split(";");
				var valName;
				setKindHTML ="<select name='lst_right' propKind='"+propKind+"'  onChange='changeProperty(this.value,"+propertyId+");'>";
				for(j=0;j<listArray.length;j++){
					valName=listArray[j].split(":");
					if(valName[0]==setVal){
						selectedFlg="selected";
					}else{
						selectedFlg="";
					}
					setKindHTML+="<option value='"+valName[0]+"' "+selectedFlg+">"+valName[1]+"</option>";
				}
				setKindHTML+="</select>";
			}else if(listValKind=='xmlNode'){
				xmlData.setProperty("SelectionLanguage", "XPath");
				var xpath = propertyXML.item(i).getAttribute("listVal");
				var listNodes = xmlData.selectNodes(xpath);
//alert(listNodes.item(0).xml)
				setKindHTML ="<select name='lst_right' propKind='"+propKind+"'  onChange='changeProperty(this.value,"+propertyId+");'>";
				setKindHTML+="<option value='0'>���I��</option>";
				var resetFlg=false;//�������pFLG
				for(j=0;j<listNodes.length;j++){
					if(listNodes.item(j).text==setVal){
						selectedFlg="selected";
						resetFlg=true;
					}else{
						selectedFlg="";
					}
					setKindHTML+="<option value='"+listNodes.item(j).text+"' "+selectedFlg+">"+listNodes.item(j).text+"</option>";
				}
				//�\�蓙�Őݒ肵�Ă��������̂��A�}�b�s���O�ŏ������ꍇ�̏�����
				if(resetFlg==false){
					var setPropertyNode = xmlData.selectSingleNode("//*[@propertyId='"+propertyId+"']");
					var setAttributeName = setPropertyNode.getAttribute("setName");
					setPropertyNode.setAttribute(setAttributeName,'0');
				}
				setKindHTML+="</select>";
//alert(setKindHTML)
			}
			strHTML+="	<tr class='standard'>";
			strHTML+="		<th class='standard'>"+propertyXML.item(i).getAttribute("dispStr")+"</th>";
			strHTML+="		<td class='standard'>"+setKindHTML+"</td>";
			strHTML+="	</tr>";
		}else if(propertyXML.item(i).getAttribute("setKind")=='child'){

			setKindHTML="";
			setKindHTML+="<table>";
			for(var x=0;x<propertyXML.item(i).childNodes.length;x++){
				setName=propertyXML.item(i).childNodes[x].getAttribute("setName");//���ۂɒl�������Ă��鑮���������߂�
				propertyId=propertyXML.item(i).childNodes[x].getAttribute("propertyId");//��ӂ�ID
				setVal=propertyXML.item(i).childNodes[x].getAttribute(setName);//�ݒ肳��Ă���l
				propKind=propertyXML.item(i).childNodes[x].getAttribute("propKind");//���

				var node=propertyXML.item(i).childNodes[x];
				xmlData.setProperty("SelectionLanguage", "XPath");
				var xpath = node.getAttribute("listVal");
				var listNodes = xmlData.selectNodes(xpath);
				setKindHTML+="<tr><td>";
				setKindHTML+=node.getAttribute("dispStr");
				setKindHTML+="</td>";
				setKindHTML+="<td>";
				setKindHTML+="<select name='lst_right' propKind='"+propKind+"'  onChange='changeProperty(this.value,"+propertyId+");'>";
				setKindHTML+="<option value='0'>���I��</option>";
				var resetFlg=false;//�������pFLG
				for(j=0;j<listNodes.length;j++){
					if(listNodes.item(j).text==setVal){
						selectedFlg="selected";
						resetFlg=true;
					}else{
						selectedFlg="";
					}
					setKindHTML+="<option value='"+listNodes.item(j).text+"' "+selectedFlg+">"+listNodes.item(j).text+"</option>";
				}
				//�\�蓙�Őݒ肵�Ă��������̂��A�}�b�s���O�ŏ������ꍇ�̏�����
				if(resetFlg==false){
					var setPropertyNode = xmlData.selectSingleNode("//*[@propertyId='"+propertyId+"']");
					var setAttributeName = setPropertyNode.getAttribute("setName");
					setPropertyNode.setAttribute(setAttributeName,'0');
				}
			//	setKindHTML+="</select></br>";
				setKindHTML+="</select>";
				setKindHTML+="</td></tr>";
			}
			setKindHTML+="</table>";
			strHTML+="	<tr class='standard'>";
			strHTML+="		<th class='standard'>"+propertyXML.item(i).getAttribute("dispStr")+"</th>";
			strHTML+="		<td class='standard'>"+setKindHTML+"</td>";
			strHTML+="	</tr>";
		}
	}
	strHTML+="</table>";

	var setArea = document.getElementById("screenContents");
	setArea.innerHTML=strHTML;

}
function changeProperty(th,id){
	var setPropertyNode = xmlData.selectSingleNode("//*[@propertyId='"+id+"']");
	var setAttributeName = setPropertyNode.getAttribute("setName");
	setPropertyNode.setAttribute(setAttributeName,th);
//alert(xmlData.xml);

	parent.parent.frm_backNext.mappingScreenDisplay();

}

function clickDisplaySQL(){
	parent.parent.frm_backNext.setDbXML("sql");

//Submit wait
var a="";
for(var i=0;i<10000;i++){
	a=a+"a"
}

	var sqlObj = new Array(2);
	var reportId=parent.parent.frm_backNext.form_main.report_id.value;
	sqlObj[0]=parent.parent.frm_backNext.form_main.sql_customized_flg;
	sqlObj[1]=parent.parent.frm_backNext.form_main.strSQL;

window.showModalDialog("sql_disp.jsp?rId="+reportId,sqlObj,"dialogHeight:600px; dialogWidth:570px;");
//	newWin = window.open("sql_disp.jsp?rId="+reportId,"_blank","menubar=no,toolbar=no,width=650px,height=650px,resizable");

}

function checkScreenProperty(){
	var allObj=document.all;
	for(var i=0;i<allObj.length;i++){
		if(allObj[i].propKind != undefined){
			if(allObj[i].propKind=='null'){
			}else if(allObj[i].propKind=='int3'){//����0�`1000�܂�
				if((0<=allObj[i].value && allObj[i].value<=1000)==false){
					alert("0�`1000�ł�");
					return false;
				}
			}
		}
	}
	return true;
}
</script>
