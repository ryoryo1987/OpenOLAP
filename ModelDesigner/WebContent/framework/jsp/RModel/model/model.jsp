<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<%
String sqlLevel="";
if(request.getParameter("tablename")==null){
	sqlLevel="AllTables";
}else{
	sqlLevel="Table";
}

%>


<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../../../../jsp/css/common.css">
	<script language="JavaScript" src="../../js/registration.js"></script>

	<script language="JavaScript">

	var openerFrame = window.dialogArguments;

		<%if(sqlLevel.equals("AllTables")){%>
		var openerXMLDom=openerFrame.parent.frm_main1.XMLDom;
		<%}else if(sqlLevel.equals("Table")){%>
		var openerXMLDom=openerFrame.XMLDom;
		<%}%>



		var RmodelXML = new ActiveXObject("MSXML2.DOMDocument");
		RmodelXML.setProperty("SelectionLanguage", "XPath");

		RmodelXML.loadXML(openerXMLDom.xml);


		<%if(sqlLevel.equals("Table")){%>
		var tableType=RmodelXML.selectSingleNode("RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']").getAttribute("table_type");
		<%}%>




		function getTableName(){
			return "<%=request.getParameter("tablename")%>";
		}

		function regist(){
		//	var tempNode = parent.openerXMLDom.selectSingleNode("/RDBModel/db_tables/db_table[@name='" + getTableName() + "']/logical_model");
		<%if(sqlLevel.equals("AllTables")){%>
			openerXMLDom.loadXML(RmodelXML.xml);
		<%}else if(sqlLevel.equals("Table")){%>
			//テーブルタイプ（dim or fact）の書き換え
			openerXMLDom.selectSingleNode("RDBModel/db_tables/db_table[@name='" + getTableName() + "']").setAttribute("table_type",tableType);
			//テーブルタイプ毎の表示切替
			openerFrame.changeDivColor(tableType,openerFrame.document.all(openerFrame.getTableId(getTableName())).parentNode);
			//logical_modelの書き換え
			var tempNode = openerXMLDom.selectSingleNode("/RDBModel/db_tables/db_table[@name='" + getTableName() + "']/logical_model");
			tempNode.parentNode.replaceChild(frm_model.RmodelXML2,tempNode);
		<%}%>



		//	alert(openerXMLDom.xml);


			document.all.div_test.innerHTML=openerXMLDom.xml.replace(/</g,"&lt;").replace(/>/g,"&gt;<br>");
			self.window.close();
		}




	</script>
</head>

<body onload="clickTab(1);">

<form name="form_main" id="form_main" method="post" action="">
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">カラムの設定
			</td>
			<td class="HeaderTitleRight"></td>
		</tr>
	</table>

	<!-- レイアウト用 -->
	<div id="dv_main" style="margin-top:20">

	<table>
		<tr>

		<%if(sqlLevel.equals("Table")){%>

					<td style="padding-left:10" width="200">
						<table>
							<tr><td>
								データベースカラム：
<!--
								<iframe src="db_column.jsp" name='frm_db' width="200" height="270"></iframe>
-->

								<div style="width:200;height:270;;overflow:auto;border:1 solid gray" onclick='clickDiv()'>


<script>

	function clickDiv(){
		if(event.srcElement.tagName=="DIV"){
			lastSelectRow=null;
			resetRow();
		}
	}


	var RmodelXML1 = new ActiveXObject("MSXML2.DOMDocument");
	RmodelXML1.setProperty("SelectionLanguage", "XPath");
	RmodelXML1 = parent.RmodelXML.selectSingleNode("/RDBModel/db_tables/db_table[@name='" + parent.getTableName() + "']/physical_model");

	var imgFile="";
	var dbHTML="<table id='DataTable' width='100%' style='BORDER-COLLAPSE:collapse;'>";
	for(i=0;i<RmodelXML1.childNodes.length;i++){
		var fileName="";
		if(RmodelXML1.childNodes[i].text.indexOf("char")!=-1){
			fileName="text_dark";
		}else if(RmodelXML1.childNodes[i].text.indexOf("varchar")!=-1){
			fileName="text_dark";
		}else if(RmodelXML1.childNodes[i].text.indexOf("text")!=-1){
			fileName="text_dark";
		}else if(RmodelXML1.childNodes[i].text.indexOf("numeric")!=-1){
			fileName="number_dark";
		}else if(RmodelXML1.childNodes[i].text.indexOf("date")!=-1){
			fileName="date_dark";
		}else if(RmodelXML1.childNodes[i].text.indexOf("timestamp")!=-1){
			fileName="date_dark";
		}else{
			fileName="text_dark";
		} 
		imgFile="<img src='../../../images/" + fileName + ".gif' style='vertical-align:middle;'/>";

		var columnName="<A href='javascript:return false;' style='color:black;' onmouseover='this.style.cursor=\"hand\";' onmousedown='objClick(this);' onclick='return false;'>"+RmodelXML1.childNodes[i].getAttribute("id")+"</A>";
		var tempArr=RmodelXML1.childNodes[i].childNodes[1].text.split(" ");
		var columnDataType=RmodelXML1.childNodes[i].childNodes[1].text.replace(tempArr[0],"");

		dbHTML+="<tr selectflg='0'><td style='height:18;vertical-align:middle;'><nobr>"+imgFile+" "+columnName+"</nobr></td><td valign='bottom'><nobr>"+columnDataType+"</nobr></td></tr>";
	}
	dbHTML+="</table>";
	document.write(dbHTML);


function clickTR(obj){
	if(obj.style.backgroundColor!="#33CC00"){
		obj.style.backgroundColor="#33CC00";
		obj.childNodes[0].style.color="white";
		obj.childNodes[1].style.color="white";
	}else if(obj.style.backgroundColor=="#33CC00"){
		obj.style.backgroundColor="white";
		obj.childNodes[0].style.color="black";
		obj.childNodes[1].style.color="black";
	}
}

var lastSelectRow;
function objClick(obj){
	if(!window.event.ctrlKey){
		resetRow();
	}
	if((window.event.shiftKey)&&(lastSelectRow!=null)){
		var DataTable = document.getElementById("DataTable");
		for(i=lastSelectRow;i<=obj.parentNode.parentNode.parentNode.rowIndex;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[2].style.backgroundColor="#33CC00";
			DataTable.rows[i].cells[0].firstChild.childNodes[2].style.color="white";
		}
		for(i=obj.parentNode.parentNode.parentNode.rowIndex;i<=lastSelectRow;i++){
			DataTable.rows[i].selectflg="1";
			DataTable.rows[i].cells[0].firstChild.childNodes[2].style.backgroundColor="#33CC00";
			DataTable.rows[i].cells[0].firstChild.childNodes[2].style.color="white";
		}
	}else{
		obj.parentNode.parentNode.parentNode.selectflg="1";
		obj.style.backgroundColor="#33CC00";
		obj.style.color="white";
	}
	lastSelectRow=obj.parentNode.parentNode.parentNode.rowIndex;

}


function resetRow(){
	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		DataTable.rows[i].selectflg="0";
		DataTable.rows[i].cells[0].firstChild.childNodes[2].style.backgroundColor="white";
		DataTable.rows[i].cells[0].firstChild.childNodes[2].style.color="black";
	}
}

</script>


								</div>




							</td><td style="padding-left:10px">
								<input type='button' value='抽出項目
に追加' onclick="addButton('select_clause')">
								<br>
								<input type='button' value='条件項目
に追加' onclick="addButton('where_clause')">
							</td></tr></table>
					</td>


		<%}%>



					<td style="padding-left:10px" width="200">
						モデルツリー：
		<%if(sqlLevel.equals("AllTables")){%>
						<table>
						<tr>
						<td>
							<iframe src="all_db_model.jsp" name='frm_model' width="300" height="270"></iframe>
						</td>
						<td>
							<input type='button' value='↑' onclick='frm_model.moveNode("+")'/>
							<input type='button' value='↓' onclick='frm_model.moveNode("-")'/>
						</td>
						</tr>
						</table>
		<%}else if(sqlLevel.equals("Table")){%>
						<iframe src="db_model.jsp" name='frm_model' width="200" height="270"></iframe>
		<%}%>

					</td>

					<td style="padding-left:5px;padding-top:0px" width="200">
		<%if(sqlLevel.equals("Table")){%>
						プロパティ：
						<div id='attributeDispDiv' style='height:270;width=200'>
						</div>
		<%}%>


					</td>
				</tr>
				<tr>
					<td class="main">
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td colspan="3">
						<!--SQLタブ-->
						<div id="div_tab1" style="position:absolute;top:369px;left:15px;z-index:3;display:inline;width:60px;height:20px;text-align:center;background-color:#EBF8DC;border-style:outset;border-width:2 2 0 2;border-color:#CCCCCC gray gray #CCCCCC;padding:5px;font-weight:bold" onclick="clickTab(1)">
							SQL
						</div>
						<!--表タブ-->
						<div id="div_tab2" style="position:absolute;top:369px;left:75px;z-index:1;display:inline;width:60px;height:20px;text-align:center;background-color:#dddddd;padding:5;border-style:outset;border-width:2 2 0 0;border-color:#CCCCCC gray #CCCCCC #CCCCCC;border-bottom-style:inset" onclick="clickTab(2)">
							表
						</div>
						<!--枠-->
						<div style="position:absolute;top:393px;left:15px;z-index:2;width:800;height:186;vertical-align:top;background-color:#EBF8DC;border-style:outset;border-width:2 2 2 2;border-color:#CCCCCC gray gray #CCCCCC;padding:20px;overflow:hidden">
							<iframe name="frm_output1" width="100%" height="140px" style="display:block;"></iframe>
							<iframe name="frm_output2" width="100%" height="140px" style="display:none;"></iframe>
							<div id="div_comment" style="display:none;"></div>
						</div>
					</td>
				</tr>

				</table>

				<div id="div_test">
				</div>

				<div class="command" style="position:absolute;top:580px;left:15px;width:850px;">
					<input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(0);" class="normal_ok" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'">
					<input type="button" value="" onclick="parent.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
				</div>


	</div>


<!--隠しオブジェクト-->
<input type="hidden" name="hid_xml" id="hid_xml" value="">


</form>

</body>
</html>


<!--*********************************************************************-->
<!--*********************************************************************-->
<!--*********************************************************************-->
<!--*********************************************************************-->
<!--*********************************************************************-->
<!--*********************************************************************-->
<script>



function clickTab(no){

	document.all("div_comment").innerHTML="検索中・・・";
	document.all("frm_output1").src="blank.html";
	document.all("frm_output2").src="blank.html";

	for(i=1;i<=2;i++){
		document.all("div_tab" + i).style.backgroundColor="#dddddd";
		document.all("div_tab" + i).style.borderBottomStyle="inset";
		document.all("div_tab" + i).style.borderBottomWidth="0";
	//	document.all("div_tab" + i).style.borderBottomColor="#CCCCCC";
		document.all("div_tab" + i).style.fontWeight="normal";
	}
	var i=no;
	document.all("div_tab" + i).style.backgroundColor="#EBF8DC";
	document.all("div_tab" + i).style.borderBottomStyle="none";
	document.all("div_tab" + i).style.borderBottomWidth="2";
//	document.all("div_tab" + i).style.borderBottomColor="gray";
	document.all("div_tab" + i).style.fontWeight="bold";



	<%if(sqlLevel.equals("AllTables")){%>
	document.all.hid_xml.value=RmodelXML.selectSingleNode("*").xml;
	<%}else if(sqlLevel.equals("Table")){%>
	document.all.hid_xml.value=RmodelXML.selectSingleNode("/RDBModel/db_tables/db_table[@name='" + getTableName() + "']").xml;
	<%}%>
//alert(document.all.hid_xml.value);
	if(no==1){
		document.all("frm_output1").style.display="block";
		document.all("frm_output2").style.display="none";
		document.all("div_comment").style.display="none";
		document.all("div_tab1").style.zIndex="3";
		document.all("div_tab2").style.zIndex="1";

		document.form_main.action="sqlviewer_sql.jsp?sqlLevel=<%=sqlLevel%>";
		document.form_main.target="frm_output1";
		document.form_main.submit();
	}else if(no==2){
		document.all("frm_output1").style.display="none";
		document.all("frm_output2").style.display="block";
		document.all("div_comment").style.display="block";
		document.all("div_tab1").style.zIndex="1";
		document.all("div_tab2").style.zIndex="3";

		document.form_main.action="sqlviewer_table.jsp?sqlLevel=<%=sqlLevel%>";
		document.form_main.target="frm_output2";
		document.form_main.submit();
	}

	


}







function addButton(locationKind){
	frm_model.dropNode=frm_model.document.getElementById(locationKind);
	var DataTable = document.getElementById("DataTable");
	for(i=0;i<DataTable.rows.length;i++){
		if(DataTable.rows[i].selectflg=="1"){
			var  newXMLNode= frm_model.addLogicalModel(locationKind,DataTable.rows[i].cells[0].firstChild.childNodes[2].innerHTML,DataTable.rows[i].cells[1].firstChild.innerHTML);
		}
	}

	if(newXMLNode!=null){

		var dropNode;
		if(locationKind=="select_clause"){
			dropNode=frm_model.document.getElementById("select");
		}else if(locationKind=="where_clause"){
			dropNode=frm_model.document.getElementById("where");
		}
		frm_model.reloadTree(newXMLNode,dropNode);
		resetRow();
	}

}
</script>
