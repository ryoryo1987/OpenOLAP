<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<%
	String selectedMesSeq = (String)request.getParameter("selectedMesSeq");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title>ハイライト</title>
		<script type="text/javascript" src="./spread/js/spread.js"></script>
		<script type="text/javascript" src="./spread/js/selecterBody.js"></script>
		<script type="text/javascript" src="./flow/jsp/js/registration.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/common.css">
	<!--	<link rel="stylesheet" type="text/css" href="./css/spreadStyle.css">-->
	</head>

	<script language="JavaScript">
		var bcolor;
		var tcolor;
		function changeColor(no){
			document.frm_main.hid_no.value=no;
			document.frm_main.hid_bcolor.value=document.all("color" + no).style.backgroundColor;
			document.frm_main.hid_tcolor.value=document.all("color" + no).style.color;
			var newWin = window.open("spread/color.html","_blank","menubar=no,toolbar=no,width=450px,height=320px,resizable");
		}



function grade(){

	if(document.all.txt_grade_count.value!=""){
		var errFlg=false;
		if((isNaN(document.all.txt_grade_count.value))||(document.all.txt_grade_count.value.indexOf(".")!=-1)){
			errFlg=true;
		}else{
			if((1>document.all.txt_grade_count.value)||(100<document.all.txt_grade_count.value)){
				errFlg=true;
			}
		}
		if(errFlg){
			alert("この欄は1～100までの整数値を入力してください。");
			document.all.txt_grade_count.focus();
			document.all.txt_grade_count.select();
			return;
		}
	}


	var colorCode = document.all.color0.style.backgroundColor;


	var arrRed = new Array();
	var arrGreen = new Array();
	var arrBlue = new Array();

	for(x=0;x<document.all.txt_grade_count.value;x++){
		arrRed[x]=255-Math.round((255-parseInt(colorCode.substring(1,3),16))/document.all.txt_grade_count.value*x);
		arrGreen[x]=255-Math.round((255-parseInt(colorCode.substring(3,5),16))/document.all.txt_grade_count.value*x);
		arrBlue[x]=255-Math.round((255-parseInt(colorCode.substring(5,7),16))/document.all.txt_grade_count.value*x);
	}


	var tableHTML="";
	tableHTML+="<table>";
	tableHTML+="<tr>";

		for(x=0;x<document.all.txt_grade_count.value;x++){

			var tempNo = x;
			if(document.all.lst_panel_order.value=="Desc"){
				tempNo = ((document.all.txt_grade_count.value-1) - x);
			}

			arrRed[tempNo]=arrRed[tempNo].toString(16);
			arrGreen[tempNo]=arrGreen[tempNo].toString(16);
			arrBlue[tempNo]=arrBlue[tempNo].toString(16);

			if(arrRed[tempNo].toString().length==1){arrRed[tempNo]="0"+arrRed[tempNo];}
			if(arrGreen[tempNo].toString().length==1){arrGreen[tempNo]="0"+arrGreen[tempNo];}
			if(arrBlue[tempNo].toString().length==1){arrBlue[tempNo]="0"+arrBlue[tempNo];}


				if((x!=0)&&(x%25==0)){
					tableHTML+="</tr><tr>";
				}

				tdColor="#" + arrRed[tempNo] + "" + arrGreen[tempNo] + "" + arrBlue[tempNo];
				tableHTML+="<td style='cursor:default;width:12px;height:12px;font-size:10px;text-align:center;background-Color:" + tdColor + ";color:" + document.all.color0.style.color + ";' code='" + tdColor + "'>";
				tableHTML+=x+1;
				tableHTML+="</td>";

				//パネルの色情報をhiddenに持たせておく（あとでXMLに格納）
				if(x==0){
					document.all.hid_panel_color.value="";
				}else{
					document.all.hid_panel_color.value+=",";
				}
				document.all.hid_panel_color.value+=tdColor;


		}

	tableHTML+="</tr>";
	tableHTML+="</table>";


	document.all.div_grade.innerHTML=tableHTML;

}


function clearPalette(){
//	alert(event.srcElement.tagName);
//	if((event.srcElement.tagName!="TD")&&(event.srcElement.tagName!="A")){
	if((event.srcElement.onclick==null)||(event.srcElement.tagName=="BODY")){

		if(clickedDiv!=null){
			if(clickedDivType==1){
				clickedDiv.style.backgroundColor=clickDivBColor;
				clickedDiv.style.color=clickDivTColor;
				clickedDiv.firstChild.style.color=clickDivTColor;
			}else if(clickedDivType==2){
				clickedDiv.parentNode.style.backgroundColor=clickDivBColor;
				clickedDiv.parentNode.style.color=clickDivTColor;
				clickedDiv.style.color=clickDivTColor;
			}
		}

		document.all.div_palette.style.display="none";
		clickedDiv=null;//初期化
	}
}

	</script>
<body onload="load()" onclick="clearPalette()">

<div id="div_palette" style="position:absolute;top:0;left:0;display:none;">
<table border="0" style="border-collapse:collapse;border:1 solid gray;">
<tr>
<td id="td_defalut_color" align="center" colspan="7" height="15" style="cursor:hand;" onclick="clickDefaultPalette(this)">デフォルト色に戻す</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#FFFFFF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFCCCC" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFCC99" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFFFCC" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#99FF99" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#CCFFFF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFCCFF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#CCCCCC" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FF6666" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFCC33" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFFF99" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#66FF99" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#66FFFF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FF99FF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#C0C0C0" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FF0000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FF9900" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFFF00" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#33FF33" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#33CCFF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#CC66CC" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#999999" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#CC0000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FF6600" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#FFCC00" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#00CC00" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#3366FF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#CC33CC" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#666666" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#990000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#CC6600" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#999900" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#009900" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#3333FF" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#993366" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#333333" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#660000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#993300" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#666600" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#006600" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#000099" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#663366" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
<tr>
<td width="15" height="15" bgcolor="#000000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#330000" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#663300" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#333300" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#003300" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#000066" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
<td width="15" height="15" bgcolor="#330033" onclick="clickPalette(this)" onmouseover="overPalette(this)">&nbsp;</td>
</tr>
</table>
</div>

<!--
<div id="testArea1" style="display:inline;"></div>
<div id="testArea2" style="display:inline;"></div>
-->
<form name="frm_main" method="post" id="Form1">
<div style="margin-left:15;margin-top:0;margin-right:15">

	<div style="margin-left:7">
		<input type="radio" name="rdo_mode" value="1" onclick="disableCheck()"><span class="title">設定しない</span>
	</div>
	<div style="position:absolute;left:20;top:25;width:105;text-align:center;background-color:white">
		<input type="radio" name="rdo_mode" value="1" onclick="disableCheck()"><span class="title">ハイライトモード</span>
	</div>
	<div style="border:1 solid gray;padding:20 10;margin-top:15">
	<table style="margin-left:10;border-collapse:collapse">
		<tr>
			<td></td>
			<td><span class="title">最小値</span></td>
			<td><span class="title">最大値</span></td>
			<td style="width:20"></td>
			<td><span class="title">色設定</span></td>
		</tr>
		<tr>
			<td>
				<span class="title">条件1：</span>
			</td>
			<td>
				<input type="text" name="txt_highlight1_from" value="" maxlength="15">～
			</td>
			<td>
				<input type="text" name="txt_highlight1_to" value="" maxlength="15">
			</td>
			<td></td>
			<td>
				<table id="DataTable">
					<tr>
						<td id="color1" style="width:60;height:21;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,1)"><a href="javascript:;" onclick="clickDiv(this,2,1)">12345</a></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<span class="title">条件2：</span>
			</td>
			<td>
				<input type="text" name="txt_highlight2_from" value="" maxlength="15">～
			</td>
			<td>
				<input type="text" name="txt_highlight2_to" value="" maxlength="15">
			</td>
			<td></td>
			<td>
				<table id="DataTable">
					<tr>
						<td id="color2" style="width:60;height:21;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,1)"><a href="javascript:;" onclick="clickDiv(this,2,1)">12345</a></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<span class="title">条件3：</span>
			</td>
			<td>
				<input type="text" name="txt_highlight3_from" value="" maxlength="15">～
			</td>
			<td>
				<input type="text" name="txt_highlight3_to" value="" maxlength="15">
			</td>
			<td></td>
			<td>
				<table id="DataTable">
					<tr>
						<td id="color3" style="width:60;height:21;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,1)"><a href="javascript:;" onclick="clickDiv(this,2,1)">12345</a></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<span class="title">条件4：</span>
			</td>
			<td>
				<input type="text" name="txt_highlight4_from" value="" maxlength="15">～
			</td>
			<td>
				<input type="text" name="txt_highlight4_to" value="" maxlength="15">
			</td>
			<td></td>
			<td>
				<table id="DataTable">
					<tr>
						<td id="color4" style="width:60;height:21;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,1)"><a href="javascript:;" onclick="clickDiv(this,2,1)">12345</a></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<span class="title">条件5：</span>
			</td>
			<td>
				<input type="text" name="txt_highlight5_from" value="" maxlength="15">～
			</td>
			<td>
				<input type="text" name="txt_highlight5_to" value="" maxlength="15">
			</td>
			<td></td>
			<td>
				<table id="DataTable">
					<tr>
						<td id="color5" style="width:60;height:21;border:1 solid gray;;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,1)"><a href="javascript:;" onclick="clickDiv(this,2,1)">12345</a></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</div>

	<div style="position:absolute;left:20;top:247;width:90;text-align:center;background-color:white">
		<input type="radio" name="rdo_mode" value="1" onclick="disableCheck()"><span class="title">パネルモード</span>
	</div>
	<div style="border:1 solid gray;padding:10;margin-top:30">
	<table style="width:450;margin-left:10;border-collapse:collapse">
		<tr>
			<td></td>
			<td><span class="title">最小値</span></td>
			<td><span class="title">最大値</span></td>
		</tr>
		<tr>
			<td width="67">
				<span class="title">適用範囲：</span>
			</td>
			<td>
				<input type="text" name="txt_panel_min" value="" maxlength="15">～
			</td>
			<td width="250">
				<input type="text" name="txt_panel_max" value="" maxlength="15">
			</td>
		</tr>
		<tr>
			<td colspan="3" align="right">
				<table style="border-collapse:collapse">
					<tr>
						<td>
							<input type="text" name="txt_grade_count" size="3" value="" onblur="grade();" maxlength="3"><span class="title">段階にグラデーション：</span>
						</td>
						<td>
							<table id="DataTable" style="display:inline;">
								<tr>
									<td id="color0" style="width:60;height:22;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,2)"><a href="javascript:;" onclick="clickDiv(this,2,2)">12345</a>
									</td>
								</tr>
							</table>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<table style="display:inline;">
								<tr>
									<td>パターン：
										<select name="lst_panel_order" onchange="grade();">
											<option value="Asc">□□□■■■</option>
											<option value="Desc">■■■□□□</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="left">
				　
			</td>
		</tr>
		<tr>
			<td colspan="3" align="left">
				<div id="div_grade"></div>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="left">
				<table style="border-collapse:collapse">
					<tr>
						<td>
							<span class="title">範囲外：</span></td>
						</td>
						<td>
							<table id="DataTable">
								<tr>
									<td id="color9" style="width:60;height:22;border:1 solid gray;background-Color:;color:;cursor:hand;" onclick="clickDiv(this,1,3)"><a href="javascript:;" onclick="clickDiv(this,2,3)">12345</a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</div>

	<input type="hidden" name="hid_bcolor" value="">
	<input type="hidden" name="hid_tcolor" value="">
	<input type="hidden" name="hid_no" value="">
	<input type="hidden" name="hid_panel_color" value="">
	<input type="hidden" name="hid_mes_seq" value="">
	<input type="hidden" name="hid_xml" value="">

	<div class="cmdBtnCenter" style="width:100%;text-align:center;margin:15">
		<input type="button" value="" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'" onclick="setHighLightStatus();">
		<input type="button" value="" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'" onclick="parent.window.close()">
	</div>


	</div>
	</form>
	</body>
</html>

<script>

var DefaultHighLightBackColor;
var DefaultHighLightTextColor;
var DefaultPanelBackColor;
var DefaultPanelTextColor;
var DefaultPanelOtherBackColor;
var DefaultPanelOtherTextColor;


function load(){

//	var measureNode=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']");
	var mode=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Mode");

	if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Mode").text=="None"){
		document.frm_main.rdo_mode[0].checked=true;
	}else if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Mode").text=="HighLight"){
		document.frm_main.rdo_mode[1].checked=true;
	}else if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Mode").text=="Panel"){
		document.frm_main.rdo_mode[2].checked=true;
	}



	document.frm_main.hid_mes_seq.value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']").getAttribute("id");


	//デフォルト色を取得
	DefaultHighLightBackColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/DefaultHighLightBackColor").text;
	DefaultHighLightTextColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/DefaultHighLightTextColor").text;
	DefaultPanelBackColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/DefaultPanelBackColor").text;
	DefaultPanelTextColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/DefaultPanelTextColor").text;
	DefaultPanelOtherBackColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/DefaultPanelOtherBackColor").text;
	DefaultPanelOtherTextColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/DefaultPanelOtherTextColor").text;
	//色が未設定の場合は、デフォルト色をセット
	for(i=1;i<=5;i++){
		if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "BackColor").text==""){
			parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "BackColor").text=DefaultHighLightBackColor;
		}
		if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "TextColor").text==""){
			parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "TextColor").text=DefaultHighLightTextColor;
		}
	}
	if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelBackColor").text==""){
		parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelBackColor").text=DefaultPanelBackColor;
	}
	if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelTextColor").text==""){
		parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelTextColor").text=DefaultPanelTextColor;
	}
	if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherBackColor").text==""){
		parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherBackColor").text=DefaultPanelOtherBackColor;
	}
	if(parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherTextColor").text==""){
		parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherTextColor").text=DefaultPanelOtherTextColor;
	}




	for(i=1;i<=5;i++){
		document.frm_main.elements["txt_highlight" + i + "_from"].value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "From").text;
		document.frm_main.elements["txt_highlight" + i + "_to"].value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "To").text;
		document.all("color" + i).style.backgroundColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "BackColor").text;
		document.all("color" + i).firstChild.style.color=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/HighLight/Condition" + i + "TextColor").text;
	}

	document.frm_main.txt_grade_count.value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelGradeCount").text;
	document.all("color0").style.backgroundColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelBackColor").text;
//	document.all("color0").style.color=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelTextColor").text;
	document.all("color0").firstChild.style.color=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelTextColor").text;
	document.all("color9").style.backgroundColor=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherBackColor").text;
//	document.all("color9").style.color=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherTextColor").text;
	document.all("color9").firstChild.style.color=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOtherTextColor").text;
	document.all("hid_panel_color").value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelGradeColors").text;
	document.frm_main.txt_panel_min.value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelMinValue").text;
	document.frm_main.txt_panel_max.value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelMaxValue").text;
	document.frm_main.lst_panel_order.value=parent.frm_header.XMLColorConfig.selectSingleNode("//Measure[@id='<%=selectedMesSeq%>']/Panel/PanelOrder").text;





	grade();

	disableCheck();

}




function setHighLightStatus(){

	
	parent.frm_header.saveToXxml();

	document.frm_main.hid_xml.value=parent.frm_header.XMLColorConfig.xml;
//	alert(document.frm_main.hid_xml.value);




	//エラーチェック
	var errNum=0;
	var highLightXml=parent.frm_header.XMLColorConfig;

	var measures = highLightXml.selectSingleNode("//Measures");

	for(m=0;m<measures.childNodes.length;m++){
		var tempMesSeq = measures.childNodes[m].getAttribute("id");


		if(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Mode").text=="HighLight"){

		for(i=1;i<=5;i++){

			var errNum=IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "From").text);
			if((errNum!=0)&&(IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "To").text)==0)){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のハイライトモード条件" + i + "（最小値）");return;}
			var errNum=IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "To").text);
			if((errNum!=0)&&(IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "From").text)==0)){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のハイライトモード条件" + i + "（最大値）");return;}

			var errNum=IntNumCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "From").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のハイライトモード条件" + i + "（最小値）");return;}
			var errNum=IntNumCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "To").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のハイライトモード条件" + i + "（最大値）");return;}

			if(parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "From").text)>parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/HighLight/Condition" + i + "To").text)){
				alert(measures.childNodes[m].getAttribute("name")+"のハイライトモード条件" + i + "の最小値と最大値の範囲設定が不正です。最大値は最小値以上の数値を入力してください。");
				return;
			}
		}




		}else if(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Mode").text=="Panel"){



			var errNum=IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMinValue").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード適用範囲（最小値）");return;}
			var errNum=IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMaxValue").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード適用範囲（最大値）");return;}
			var errNum=IsNullChar(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelGradeCount").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード段階設定");return;}


			var errNum=IntNumCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMinValue").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード適用範囲（最小値）");return;}
			var errNum=IntNumCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMaxValue").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード適用範囲（最大値）");return;}


			var errNum=DecimalCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelGradeCount").text);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード段階設定");return;}
			var errNum=MinMaxCheck(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelGradeCount").text,1,100);
			if(errNum!=0){showMsg("ERR"+errNum,measures.childNodes[m].getAttribute("name")+"のパネルモード段階設定");return;}
		

			if(parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMinValue").text)>parseFloat(highLightXml.selectSingleNode("//Measure[@id='" + tempMesSeq + "']/Panel/PanelMaxValue").text)){
				alert(measures.childNodes[m].getAttribute("name")+"のパネルモードの最小値と最大値の範囲設定が不正です。最大値は最小値以上の数値を入力してください。");
				return;
			}

		}


	}




	document.frm_main.action = "spread/HighLightRegist.jsp";
	document.frm_main.target = "frm_hidden";	
	document.frm_main.submit();

}




function disableCheck(){
	var temp1;
	var temp2;

	parent.frm_header.document.frm_main.mesList.disabled=false;
	document.frm_main.rdo_mode[0].disabled=false;
	document.frm_main.rdo_mode[1].disabled=false;
	document.frm_main.rdo_mode[2].disabled=false;
	if(document.frm_main.rdo_mode[0].checked==true){
		temp1=true;
		temp2=true;
	}else if(document.frm_main.rdo_mode[1].checked==true){
		temp1=false;
		temp2=true;
	}else if(document.frm_main.rdo_mode[2].checked==true){
		temp1=true;
		temp2=false;
	}


	for(i=1;i<=5;i++){
		document.frm_main.elements["txt_highlight" + i + "_from"].disabled=temp1;
		document.frm_main.elements["txt_highlight" + i + "_to"].disabled=temp1;
	}

	document.frm_main.txt_panel_min.disabled=temp2;
	document.frm_main.txt_panel_max.disabled=temp2;
	document.frm_main.txt_grade_count.disabled=temp2;
	document.frm_main.lst_panel_order.disabled=temp2;

}



var clickedDiv=null;
var clickedDivType=null;
var clickDivBColor=null;
var clickDivTColor=null;

function clickDiv(divObj,type,defaultColorType){

	if(document.frm_main.rdo_mode[0].checked==true){
		return;
	}else if((document.frm_main.rdo_mode[1].checked==true)&&((defaultColorType!=1))){
		return;
	}else if((document.frm_main.rdo_mode[2].checked==true)&&((defaultColorType==1))){
		return;
	}


	if(document.all.div_palette.style.display=="block"){
		return;
	}
	clickedDiv=event.srcElement;
	clickedDivType=type;
	document.all.div_palette.style.top=event.clientY;
	document.all.div_palette.style.left=event.clientX;
	document.all.div_palette.style.display="block";

	if(clickedDivType==1){
		clickDivBColor=clickedDiv.style.backgroundColor;
		clickDivTColor=clickedDiv.firstChild.style.color;
	}else if(clickedDivType==2){
		clickDivBColor=clickedDiv.parentNode.style.backgroundColor;
		clickDivTColor=clickedDiv.style.color;
	}


	//デフォルトカラーをセット
	var defaultBackColor=null;
	var defaultTextColor=null;
	if(defaultColorType==1){
		defaultBackColor=DefaultHighLightBackColor;
		defaultTextColor=DefaultHighLightTextColor;
	}else if(defaultColorType==2){
		defaultBackColor=DefaultPanelBackColor;
		defaultTextColor=DefaultPanelTextColor;
	}else if(defaultColorType==3){
		defaultBackColor=DefaultPanelOtherBackColor;
		defaultTextColor=DefaultPanelOtherTextColor;
	}
	document.all.td_defalut_color.style.backgroundColor=defaultBackColor;
	document.all.td_defalut_color.style.color=defaultTextColor;


}

function overPalette(obj){
	if(clickedDivType==1){
		clickedDiv.style.backgroundColor=obj.bgColor;
	}else if(clickedDivType==2){
		clickedDiv.style.color=obj.bgColor;
		clickedDiv.parentNode.style.color=obj.bgColor;
	}
}
function clickPalette(obj){
	if(clickedDivType==1){
		clickedDiv.style.backgroundColor=obj.bgColor;
	}else if(clickedDivType==2){
		clickedDiv.style.color=obj.bgColor;
		clickedDiv.parentNode.style.color=obj.bgColor;
	}
	document.all.div_palette.style.display="none";
	clickedDiv=null;//初期化
	grade();

}


function clickDefaultPalette(obj){
	if(clickedDivType==1){
	}else if(clickedDivType==2){
		clickedDiv=clickedDiv.parentNode;
	}

	clickedDiv.style.backgroundColor=obj.style.backgroundColor;
	clickedDiv.style.color=obj.style.color;
	clickedDiv.firstChild.style.color=obj.style.color;


	document.all.div_palette.style.display="none";
	clickedDiv=null;//初期化

	grade();

}

</script>

