<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,java.util.Iterator,openolap.viewer.Report,openolap.viewer.common.Constants,openolap.viewer.Measure,openolap.viewer.MeasureMember"
%>
<%!

	public static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++){
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}
	private static String[] split(String strTarget, String strDelimiter){
	    String strResult[];
	    Vector objResult;
	    int intDelimiterLen;
	    int intStart;
	    int intEnd;

	    objResult = new java.util.Vector();
	    strTarget += strDelimiter;
	    intDelimiterLen = strDelimiter.length();
	    intStart = 0;
	    while ((intEnd = strTarget.indexOf(strDelimiter, intStart)) >= 0){
	        objResult.addElement(strTarget.substring(intStart, intEnd));
	        intStart = intEnd + intDelimiterLen;
	    }

	    strResult = new String[objResult.size()];
	    objResult.copyInto(strResult);
	    return strResult;
	}

%>
<html>
	<head>
		<title>ハイライト</title>
		<link rel="stylesheet" type="text/css" href="./css/common.css">
	</head>
	<body onload='load();' onselectstart="return false" bgcolor="red">
		<form name="frm_main" method="post" id="frm_main">


	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">ハイライト
			</td>
		</tr>
	</table>


<div style="margin:15">

<!--
※以下のラジオボタンはどちらも削除してください！<br>
<input type="radio" name="rdo_type" value="1" onclick="parent.frm_body.disableCheck();">個別設定
<br>
<br>
<input type="radio" name="rdo_type" value="2" onclick="parent.frm_body.disableCheck();">自動色分け設定
<br>
-->

<span class="title">メジャー：</span>
<select id='mesList' name='mesList' onchange='javaScript:changeDim("dimChange");'>

<%
	int i = 0;
	String measureID = Constants.MeasureID;

	Report report = (Report)session.getAttribute("report");


	String tempSelected="selected";
	Measure measure = report.getMeasure();
	Iterator nextAxisMemIt = measure.getAxisMemberList().iterator();
	while (nextAxisMemIt.hasNext()) {
		MeasureMember measureMember = (MeasureMember) nextAxisMemIt.next();
		out.println("<option value='" + measureMember.getMeasureSeq() + "' " + tempSelected + ">" + measureMember.getMeasureName() + "</option>");
		tempSelected="";
	}


%>
</select>


</div>

<!-- Selecter Body部に表示を要求する軸のID -->
<input type='hidden' name='dimNumber' value=''>

		</form>


		<!-- 「ディメンション/メジャー名」リストボックスの切り替え前の値（軸ID） -->
<!--
		<div id="beforeDimArea" style="display:none">
			<div id="beforeDimID"><%= measureID %></div>
		</div>
-->
		<!-- メジャータイプ -->
<!--
		<div id="measureTypeArea" style="display:none">
			<div id="measureType"></div>
		</div>
-->

	</body>
</html>
<script>

var measureID = <%= measureID %>



function load(){
/*
	if(XMLColorConfig.selectSingleNode("//ColorType").text=="1"){
		document.frm_main.rdo_type[0].checked=true;
	}else if(XMLColorConfig.selectSingleNode("//ColorType").text=="2"){
		document.frm_main.rdo_type[1].checked=true;
	}
*/

//	alert(XMLColorConfig.xml);

	document.frm_main.action = "Controller?action=displayHighLightBody&selectedMesSeq=" + document.frm_main.mesList.value;
	document.frm_main.target = "frm_body";
	document.frm_main.submit();

}


function changeDim( source ) {

	saveToXxml();

	document.frm_main.action = "Controller?action=displayHighLightBody&selectedMesSeq=" + document.frm_main.mesList.value;
	document.frm_main.target = "frm_body";
	document.frm_main.submit();

}


function saveToXxml(){


//		if(document.frm_main.rdo_type[0].checked==true){
//			XMLColorConfig.selectSingleNode("//ColorType").text="1";
//		}else if(document.frm_main.rdo_type[1].checked==true){
//			XMLColorConfig.selectSingleNode("//ColorType").text="2";
//		}


		var mesSeq=parent.frm_body.document.frm_main.hid_mes_seq.value;
	//	alert(mesSeq);


	//	var measureNode=XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']");


		if(parent.frm_body.document.frm_main.rdo_mode[0].checked==true){
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Mode").text="None";
		}else if(parent.frm_body.document.frm_main.rdo_mode[1].checked==true){
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Mode").text="HighLight";
		}else if(parent.frm_body.document.frm_main.rdo_mode[2].checked==true){
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Mode").text="Panel";
		}


		for(i=1;i<=5;i++){
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/HighLight/Condition" + i + "From").text=parent.frm_body.document.frm_main.elements["txt_highlight" + i + "_from"].value;
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/HighLight/Condition" + i + "To").text=parent.frm_body.document.frm_main.elements["txt_highlight" + i + "_to"].value;
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/HighLight/Condition" + i + "BackColor").text=parent.frm_body.document.all("color" + i).style.backgroundColor;
			XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/HighLight/Condition" + i + "TextColor").text=parent.frm_body.document.all("color" + i).firstChild.style.color;
		}


		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelGradeCount").text=parent.frm_body.document.frm_main.txt_grade_count.value;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelBackColor").text=parent.frm_body.document.all("color0").style.backgroundColor;
//	alert("save"+parent.frm_body.document.all("color0").outerHTML);
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelTextColor").text=parent.frm_body.document.all("color0").firstChild.style.color;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelOtherBackColor").text=parent.frm_body.document.all("color9").style.backgroundColor;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelOtherTextColor").text=parent.frm_body.document.all("color9").firstChild.style.color;

		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelGradeColors").text=parent.frm_body.document.all.hid_panel_color.value;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelMinValue").text=parent.frm_body.document.all.txt_panel_min.value;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelMaxValue").text=parent.frm_body.document.all.txt_panel_max.value;
		XMLColorConfig.selectSingleNode("//Measure[@id='" + mesSeq + "']/Panel/PanelOrder").text=parent.frm_body.document.all.lst_panel_order.value;

}





	var XMLColorConfig = new ActiveXObject("MSXML2.DOMDocument");
	XMLColorConfig.async = false;

	var strXml='<?xml version="1.0" encoding="Shift_JIS" ?>';

//	strXml+='<ColorConfig>';
//	strXml+='<ColorType>1</ColorType>';
//	strXml+='<Measures>';

<%
/*
	nextAxisMemIt = measure.getAxisMemberList().iterator();
	while (nextAxisMemIt.hasNext()) {
		MeasureMember measureMember = (MeasureMember) nextAxisMemIt.next();
		out.println("strXml+='<Measure id=\\'" + measureMember.getMeasureSeq() + "\\' name=\\'" + measureMember.getMeasureName() + "\\'>';");
		out.println("strXml+='<Mode>HighLight</Mode>';");
		out.println("strXml+='<HighLight>';");
		out.println("strXml+='<Condition1From></Condition1From>';");
		out.println("strXml+='<Condition1To></Condition1To>';");
		out.println("strXml+='<Condition1BackColor>#00ffff</Condition1BackColor>';");
		out.println("strXml+='<Condition1TextColor>#000000</Condition1TextColor>';");
		out.println("strXml+='<Condition2From></Condition2From>';");
		out.println("strXml+='<Condition2To></Condition2To>';");
		out.println("strXml+='<Condition2BackColor>#00ffff</Condition2BackColor>';");
		out.println("strXml+='<Condition2TextColor>#000000</Condition2TextColor>';");
		out.println("strXml+='<Condition3From></Condition3From>';");
		out.println("strXml+='<Condition3To></Condition3To>';");
		out.println("strXml+='<Condition3BackColor>#00ffff</Condition3BackColor>';");
		out.println("strXml+='<Condition3TextColor>#000000</Condition3TextColor>';");
		out.println("strXml+='<Condition4From></Condition4From>';");
		out.println("strXml+='<Condition4To></Condition4To>';");
		out.println("strXml+='<Condition4BackColor>#00ffff</Condition4BackColor>';");
		out.println("strXml+='<Condition4TextColor>#000000</Condition4TextColor>';");
		out.println("strXml+='<Condition5From></Condition5From>';");
		out.println("strXml+='<Condition5To></Condition5To>';");
		out.println("strXml+='<Condition5BackColor>#00ffff</Condition5BackColor>';");
		out.println("strXml+='<Condition5TextColor>#000000</Condition5TextColor>';");
		out.println("strXml+='</HighLight>';");
		out.println("strXml+='<Panel>';");
		out.println("strXml+='<PanelGradeCount>10</PanelGradeCount>';");
		out.println("strXml+='<PanelBackColor>#00ffff</PanelBackColor>';");
		out.println("strXml+='<PanelTextColor>#000000</PanelTextColor>';");
		out.println("strXml+='<PanelOtherBackColor>#808080</PanelOtherBackColor>';");
		out.println("strXml+='<PanelOtherTextColor>#000000</PanelOtherTextColor>';");
		out.println("strXml+='<PanelGradeColors></PanelGradeColors>';");
		out.println("strXml+='<PanelMinValue></PanelMinValue>';");
		out.println("strXml+='<PanelMaxValue></PanelMaxValue>';");
		out.println("strXml+='</Panel>';");
		out.println("strXml+='</Measure>';");
	}
*/
%>
//	strXml+='</Measures>';
//	strXml+='</ColorConfig>';

<%
	String highLightXML = report.getHighLightXML();
//	if((highLightXML!=null)&&(!"null".equals(highLightXML))){
		out.println("var strXml='" + replace(replace(highLightXML,"\n",""),"\r","") + "';");
//	}
%>

	XMLColorConfig.loadXML(strXml);



//	alert('<%=replace(replace(report.getHighLightXML(),"\n",""),"\r","")%>');
//	alert(XMLColorConfig.xml);


</script>
