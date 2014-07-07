<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "openolap.viewer.XMLConverter"%>

<%@ include file="../../connect.jsp"%>



<%

	int i=0;
	int j=0;

	String Sql="";
	int objSeq = Integer.parseInt(request.getParameter("objId"));

	String listHTML="";
	listHTML+="<select id=\"list%divNo%\" onchange=\"changeReport(this,%divNo%)\">";
	listHTML+="<option value=\"\">------------</option>";
	Sql = "SELECT report_id,report_name from oo_v_report where kind_flg='R' and report_type='R' order by report_id";
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		listHTML+="<option value=\"" + rs.getString("report_id") + "\">" + rs.getString("report_name") + "</option>";
	}
	rs.close();
	listHTML+="</select>";












	String reportType="";
	String screenXml="";
	Sql = " select report_type,screen_xml from oo_v_report";
	Sql += " where report_id='"+objSeq+"'";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		reportType=rs.getString("report_type"); 
		screenXml=rs.getString("screen_xml"); 
	}
	rs.close();







	String arrDimensionId[] = new String[15];
	String arrDimensionName[] = new String[15];
	i=0;

	if("M".equals(reportType)){
		Sql = " select '2',oo_dimension.dimension_seq,oo_dimension.name from oo_info_dim,oo_dimension";
		Sql += " where oo_info_dim.dimension_seq=oo_dimension.dimension_seq";
		Sql += " and oo_info_dim.cube_seq = (select cube_seq from oo_v_report where report_id='" + objSeq + "')";
		Sql += " union ";
		Sql += " select '1',oo_time.time_seq as dimension_seq,oo_time.name from oo_info_dim,oo_time";
		Sql += " where oo_info_dim.dimension_seq=oo_time.time_seq";
		Sql += " and oo_info_dim.cube_seq = (select cube_seq from oo_v_report where report_id='" + objSeq + "')";
		Sql += " order by 1,2";
		rs = stmt.executeQuery(Sql);
		while(rs.next()){
			arrDimensionId[i]=rs.getString("dimension_seq"); 
			arrDimensionName[i]=rs.getString("name"); 
			i++;

		//	out.println("/*" + rs.getString("dimension_seq") + "," + rs.getString("name") + "*/");
		}
		rs.close();

	}else if("R".equals(reportType)){

		XMLConverter xmlCon = new XMLConverter();
		Document doc = xmlCon.toXMLDocument(screenXml);

		NodeList conditionList=xmlCon.selectNodes(doc,"//listbox");

		j=0;
		for(i=0;i<conditionList.getLength();i++){
			String listId=((Element)xmlCon.selectSingleNode(conditionList.item(i),"./listId")).getAttribute("listId");
			String listPK=((Element)conditionList.item(i)).getAttribute("propertyId");
			String listName=((Element)xmlCon.selectSingleNode(conditionList.item(i),"./listName")).getAttribute("listName");
			if(!"0".equals(listId)){
			//	arrDimensionId[i]=listId; 
				arrDimensionId[j]=listPK; 
				arrDimensionName[j]=listId; 
				j++;
			}
		}
	}






	String reportName="";
	String drillXML="";
	Sql = "SELECT report_name,drill_xml from oo_v_report where report_id='" +objSeq+"'";
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		reportName=rs.getString("report_name");
		drillXML=rs.getString("drill_xml");
	}
	rs.close();


%>

<html>
<head>
	<title>OpenOLAP Report Designer</title>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<link rel="stylesheet" type="text/css" href="../../../css/window.css">
	<style>

		td {
			white-space:nowrap;
		}

		.window {
			border:3 solid white;
		}

		.windowTitle {
			border-bottom:1 solid #EEEEEE;
			background-color:#EEF2FF;
			width:100%;
		}

		.titleTable{
			border-collapse:collapse;
			width:100%;
			margin:0;
		}

		.titleString {
			font-weight:bold;
			//padding:3;
		}

		.contents{
			margin:10 20 20 20;
			overflow:auto;
			width:700;
			height:220;
		}

		.movePage{
			border-top:1 solid #EEEEEE;
		}

		.footerTable{
			border-collapse:collapse;
			width:100%;
			margin:0;
			background-color:#DDDEE4;
		}

		a:link {
			color:blue;
		}

		a:hover {
			color:red;
		}

	</style>


<script language="JavaScript">


	var openerFrame = window.dialogArguments;

<%
//ディメンション配列を作成
out.println("var arrDimensionId = new Array();");
out.println("var arrDimensionName = new Array();");
for(i=0;i<arrDimensionId.length;i++){
	if(arrDimensionId[i]!=null){
		out.println("arrDimensionId[" + i + "]='" + arrDimensionId[i] + "';");
		out.println("arrDimensionName[" + i + "]='" + arrDimensionName[i] + "';");
	}
}
%>




	function load(){

		//ドリルスルー設定XMLを読み取り、HTMLを作成する
		var strLoadXML="";
		<%out.println("strLoadXML=\"" + replace(replace(replace(drillXML,"\n",""),"\r",""),"\"","'") + "\";");%>
		if(strLoadXML!="null"){
			XMLDoc.loadXML(strLoadXML);
		//	document.all.txt_report_name.value=XMLDoc.selectSingleNode("property/report_name").text;

			for(var d=0;d<XMLDoc.selectSingleNode("property/drills").childNodes.length;d++){
				var drillDom=XMLDoc.selectSingleNode("property/drills").childNodes[d];
				displayDrillDiv(true);
				for(var op=0;op<document.all("list"+d).length;op++){
					if(document.all("list"+d).options[op].value==drillDom.selectSingleNode("./@target_report_id").text){
						document.all("list"+d).options[op].selected=true;
						changeReport(document.all("list"+d).options[op],d);
					}
				}

				for(j=0;j<drillDom.selectSingleNode("./dimensions").childNodes.length;j++){
					var dimDom=drillDom.selectSingleNode("./dimensions").childNodes[j];
					for(var op=0;op<document.all("list"+d+"-"+j).length;op++){
						if((document.all("list"+d+"-"+j)!=undefined)&&(dimDom.selectSingleNode("./logical_condition")!=null)){
							if(document.all("list"+d+"-"+j).options[op].value==dimDom.selectSingleNode("./logical_condition").text){
								document.all("list"+d+"-"+j).options[op].selected=true;
							}
						}
					}

				}
			}
		}else{
			displayDrillDiv();//ドリルスルー設定XMLがない場合は、ドリルスルー設定をひとつのみ表示する
		}

	}

	function dispContent(Num){//設定詳細画面の表示の切り替え
		if(document.all("content"+Num).style.display=="none"){
			document.all("content"+Num).style.display="block";
			document.all("img"+Num).src=document.all("img"+Num).src.replace("window_disp","window_no_disp");
			document.all("img"+Num).title="非表示";
		}else{
			document.all("content"+Num).style.display="none";
			document.all("img"+Num).src=document.all("img"+Num).src.replace("window_no_disp","window_disp");
			document.all("img"+Num).title="表示";
		}
	}


	function del(){//ドリルスルー設定の削除

		for(i=0;i<document.all.divArea.childNodes.length;i++){
			var tempDivID=document.all.divArea.childNodes[i].id;
			if(document.all(tempDivID).selectedFlg=="1"){
				document.all.divArea.removeChild(document.all(tempDivID));
				i++;
			}
		}

		sortNo();//タイトル部分の数字を振り直す。

	}

	function clickDrillDiv(obj){//ドリルスルー設定を選択状態にする
		for(i=0;i<document.all.divArea.childNodes.length;i++){
			var tempDivID=document.all.divArea.childNodes[i].id;
			document.all(tempDivID).selectedFlg="0";
			document.all(tempDivID).style.borderColor="";
			document.all(tempDivID).style.borderWidth="3";
		}
		obj.selectedFlg="1";
		obj.style.borderColor="red";
		obj.style.borderWidth="3";
		obj.style.borderStyle="solid";
	}


	//「ドリルスルー先レポート」リストボックス切り替え時に、「ドリルスルーで使用する条件」リストボックスを生成する
	function changeReport(obj,tempDivID){

		var listHTML="";
		listHTML+='<select id="list'+tempDivID+'-%dimNo%">';
		listHTML+='<option value="">----------</option>';

		//SQL作成用XMLのlogical_conditionを読み取りリストボックスを作成
		var RmodelXMLDoc = new ActiveXObject("MSXML2.DOMDocument");
		RmodelXMLDoc.async = false;
		RmodelXMLDoc.load("dispXml.jsp?report_id="+obj.value);
	//	var sqlNodes=RmodelXMLDoc.selectNodes("//where_clause/logical_condition[@use_flg='1']/sql")
		var conditionNodes=RmodelXMLDoc.selectNodes("//where_clause/logical_condition[@use_flg='1']")
		for(k=0;k<conditionNodes.length;k++){
			var conditionId=conditionNodes.item(k).getAttribute("id");
			var conditionName=conditionNodes.item(k).selectSingleNode("./name").text
			var conditionSql=conditionNodes.item(k).selectSingleNode("./sql").text
		//	listHTML+='<option value="'+sqlNodes.item(k).text+'">'+sqlNodes.item(k).text+'</option>';
			listHTML+='<option value="'+conditionId+'">'+conditionName+'</option>';
		}
		listHTML+='</select>';



		for(j=0;j<document.all("dimensionarea"+tempDivID).childNodes.length;j++){
			document.all("sql"+tempDivID+"-"+j).innerHTML=listHTML.replace("%dimNo%",j);
		}

	}


	var divNo=0;

	function displayDrillDiv(){//ドリルスルー設定DIVを作成・表示する
<%	if("M".equals(reportType)){%>

		if(document.all.divArea.childNodes.length>=5){
			alert("ドリルスルー設定は５つまでしか作成できません。");
			return;
		}

<%	}else if("R".equals(reportType)){//条件設定画面%>

		if(document.all.divArea.childNodes.length>=1){
			alert("ドリルスルー設定は複数作成することはできません。");
			return;
		}

<%	}%>

		var tempHTML="";
	//	tempHTML+='<!--Window大枠用DIV-->';
		tempHTML+='<div class="window" id="'+divNo+'" onclick="clickDrillDiv(this)" ondblclick="dispContent('+divNo+')" selectedFlg="0" style="margin-bottom:10">';
		tempHTML+='	<div>';
		tempHTML+='		<table class="titleTable">';
		tempHTML+='			<tr>';
		tempHTML+='				<td class="window_title_left_4" style="width:9"></td>';
		tempHTML+='				<td class="window_title_name_4" id="name'+divNo+'"></td>';
		tempHTML+='				<td class="window_title_button_4" style="width:9">';
		tempHTML+='					<img src="../../../images/portal/window_no_disp_4.gif" id="img'+divNo+'" title="非表示" style="margin-right:10" onclick="dispContent('+divNo+')">';
		tempHTML+='				</td>';
		tempHTML+='				<td class="window_title_right_4"></td>';
		tempHTML+='			</tr>';
		tempHTML+='		</table>';
		tempHTML+='	</div>';

	//	tempHTML+='	<!--コンテンツ用DIV-->';
		tempHTML+='	<div id="content'+divNo+'" style="display:block;">';
		tempHTML+='		<table style="border-collapse:collapse;width:100%">';
		tempHTML+='			<tr>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='				<td class="title" style="padding-left:10;padding-top:10">ドリルスルー先レポート：<%=listHTML%></td>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='			</tr>';
		tempHTML+='			<tr>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='				<td style="padding-left:10;padding-top:10">';
		tempHTML+='					<span class="title" style="width:200;">引き渡すことができるパラメータ：</span>';
		tempHTML+='					<span style="width:40;">&nbsp;</span>';
		tempHTML+='					<span class="title" style="width:200;">ドリルスルーで使用する条件：</span>';
		tempHTML+='				</td>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='			</tr>';
		tempHTML+='			<tr>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='				<td style="padding-left:10;padding-top:10;padding-bottom:10">';
		tempHTML+='		<div id="dimensionarea'+divNo+'">';

		//ディメンション数
		for(i=0;i<arrDimensionId.length;i++){
			if(arrDimensionId[i]!=null){
				tempHTML+='			<div>';
				tempHTML+='				<div style="display:inline;width:200;height:20">'+arrDimensionName[i]+'</div>';
				tempHTML+='				<div style="display:inline;width:50;height:20;vertical-align:middle">----&gt;</div>';
				tempHTML+='				<div style="display:inline;width:200;height:20;padding:" id="sql'+divNo+'-'+i+'" dimension_id="'+arrDimensionId[i]+'">';
				tempHTML+='				</div>';
				tempHTML+='			</div>';
			}
		}



		tempHTML+='		</div>';

		tempHTML+='				</td>';
		tempHTML+='				<td class="window_contents_frame_4"></td>';
		tempHTML+='			</tr>';
		tempHTML+='		</table>';
		tempHTML+='		<table style="border-collapse:collapse;width:100%">';
		tempHTML+='			<tr>';
		tempHTML+='				<td class="window_footer_left_4" style="width:9"></td>';
		tempHTML+='				<td class="window_footer_center_4"></td>';
		tempHTML+='				<td class="window_footer_right_nomark_4"></td>';
		tempHTML+='			</tr>';
		tempHTML+='		</table>';
		tempHTML+='';
		tempHTML+='';
		tempHTML+='		';
		tempHTML+='</div>';
		tempHTML+='</div>';

		tempHTML=tempHTML.replace(/%divNo%/g,divNo)

		document.all.divArea.innerHTML+=tempHTML;



		sortNo();

		divNo++;
	}


	var XMLDoc = new ActiveXObject("MSXML2.DOMDocument");
	XMLDoc.async = false;

	function cancel(){
		self.window.close();
	}

	function regist(){

		//登録用にXMLを作成する
		var strXML="<?xml version='1.0' encoding='Shift_JIS' ?>";
		strXML+="<property>";
	//	strXML+="	<report_name>"+document.all.txt_report_name.value+"</report_name>";
		strXML+="	<drills>";

		var tempString="";
		for(i=0;i<document.all.divArea.childNodes.length;i++){
			var tempDivID=document.all.divArea.childNodes[i].id;

			if(document.all("list"+tempDivID).value==""){
				alert("ドリルスルー設定"+(i+1)+"のドリルスルー先レポートが未設定です。");
				return;
			}

			//ターゲットレポートが重複しないようにチェックする
			if(tempString.indexOf("*"+document.all("list"+tempDivID).value+"*")!=-1){
				alert("複数のドリルスルー設定で同じドリルスルー先レポートを指定することはできません。");
				return;
			}else{
				tempString+="*"+document.all("list"+tempDivID).value+"*";
			}

			strXML+="		<drill target_report_id='"+document.all("list"+tempDivID).value+"'>";
		//	strXML+="			<target_report_id>"+document.all("list"+tempDivID).value+"</target_report_id>";
			strXML+="			<dimensions>";
			for(j=0;j<document.all("dimensionarea"+tempDivID).childNodes.length;j++){
				;
				strXML+="				<dimension>";
				strXML+="					<dimension_id>"+document.all("sql"+tempDivID+"-"+j).dimension_id+"</dimension_id>";
					strXML+="<logical_condition>";
					if(document.all("list"+tempDivID+"-"+j)!=undefined){
						strXML+=document.all("list"+tempDivID+"-"+j).value;
					}
					strXML+="</logical_condition>";
				strXML+="				</dimension>";
			}
			strXML+="			</dimensions>";
			strXML+="		</drill>";
		}

		strXML+="	</drills>";
		strXML+="</property>";

		document.form_main.hid_xml.value=strXML;

		if(confirm("ドリルスルー設定を登録します。よろしいですか？")){
			document.form_main.action="drill_regist.jsp";
			document.form_main.target="frm_hidden2";
			document.form_main.submit();
		}


	}


	function sortNo(){//ドリルスルー設定タイトル部分の数字を振り直す
		var sortId=1;
		for(i=0;i<document.all.divArea.childNodes.length;i++){
			var tempDivID=document.all.divArea.childNodes[i].id;
			document.all("name"+tempDivID).innerHTML="ドリルスルー設定 "+sortId;
			sortId++;
		}
		
	}



</script>
</head>
<body onload="load()">
<form id="form_main" method="post" name="form_main">
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">ドリルスルー設定</td>
	</tr>
</table>

<div style="diplay:inline">
<!--	<span class="title">レポート名：</span><input type="text" id="txt_report_name" value="">-->
<table style="margin-top:15px;margin-left:10px;width:800;border-collpase:collapse">
	<tr>
		<td class="title">ドリルスルー元のレポート：<%=reportName%></td>
		<td align="right">
			<input type="button" value="" onclick="displayDrillDiv()" class="normal_add_drill" onMouseOver="className='over_add_drill'" onMouseDown="className='down_add_drill'" onMouseUp="className='up_add_drill'" onMouseOut="className='out_add_drill'">
			<input type="button" value="" onclick="del()" class="normal_del_drill" onMouseOver="className='over_del_drill'" onMouseDown="className='down_del_drill'" onMouseUp="className='up_del_drill'" onMouseOut="className='out_del_drill'">
		</td>
	</tr>
</table>

	<div style="margin:10;height:450px;width:800px;z-index:0;border:1 solid gray;padding:15px 10px 10px 10px;overflow-y:scroll;">
		<div style="position:relative" id="divArea">






		</div>
	</div>
	<div class="command" style="width:800px;text-align:center;">
		<input type="button" name="allcrt_btn" value="" onClick="regist()" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'">
		<input type="button" name="allcrt_btn" value="" onClick="cancel()" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
	</div>
	<iframe name="frm_hidden2" src="blank.html" style="display:none;"></iframe>
</div>


<input type="hidden" name="objSeq" value="<%=objSeq%>">
<input type="hidden" name="hid_xml" value="">

</form>
</body>
</html>


<%@ include file="../../connect_close.jsp"%>
