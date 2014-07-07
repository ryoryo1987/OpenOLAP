<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect_rmodel.jsp"%>


<html>
<head>
<title></title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<script language="JavaScript" src="../js/registration.js"></script>
<script language="JavaScript" src="../../../jsp/js/common.js"></script>

	<style>
		/********************* ツールバー *********************/
		.toolbar_left
		{
			height:38;
			width:5;
		}

		.toolbar_center
		{
			text-align:right;
			background-color:#EDECE8;
			vertical-align:middle;
		}

		/********************* ツールバーボタン *********************/

		input.normal_toolbar_add,.input.up_toolbar_add,.input.out_toolbar_add
		{
			width:60;
			height:30;
			background:url("../../images/toolbar_add.gif") no-repeat;
			border-style : none;
		}

		input.over_toolbar_add, input.down_toolbar_add {
			width:60;
			height:30;
			background:url("../../images/toolbar_add_r.gif") no-repeat;
			border-style : none;
		}

		input.normal_toolbar_delete,.input.up_toolbar_delete,.input.out_toolbar_delete
		{
			width:60;
			height:30;
			background:url("../../images/toolbar_delete.gif") no-repeat;
			border-style : none;
		}

		input.over_toolbar_delete, input.down_toolbar_delete {
			width:60;
			height:30;
			background:url("../../images/toolbar_delete_r.gif") no-repeat;
			border-style : none;
		}

		input.normal_toolbar_sql,.input.up_toolbar_sql,.input.out_toolbar_sql
		{
			width:60;
			height:30;
			background:url("../../images/toolbar_sql.gif") no-repeat;
			border-style : none;
		}

		input.over_toolbar_sql, input.down_toolbar_sql {
			width:60;
			height:30;
			background:url("../../images/toolbar_sql_r.gif") no-repeat;
			border-style : none;
		}

		input.normal_toolbar_save,.input.up_toolbar_save,.input.out_toolbar_save
		{
			width:60;
			height:30;
			background:url("../../images/toolbar_save.gif") no-repeat;
			border-style : none;
		}

		input.over_toolbar_save, input.down_toolbar_save {
			width:60;
			height:30;
			background:url("../../images/toolbar_save_r.gif") no-repeat;
			border-style : none;
		}

		input.normal_toolbar_back_model,.input.up_toolbar_back_model,.input.out_toolbar_back_model
		{
			width:140;
			height:30;
			background:url("../../images/toolbar_back_model.gif") no-repeat;
			border-style : none;
		}

		input.over_toolbar_back_model, input.down_toolbar_back_model {
			width:140;
			height:30;
			background:url("../../images/toolbar_back_model_r.gif") no-repeat;
			border-style : none;
		}


	</style>

<script language="javascript">






function outputTable(){

	if(document.form_main.lst_table.value==""){
		alert("テーブルを選択してください。");
		return;
	}


	var allObj=parent.frm_main1.document.getElementById("allObjDiv");
	for(var i=0;i<allObj.childNodes.length;i++){
		if(allObj.childNodes[i].tablename==document.form_main.lst_table.value){
			alert("テーブルは既に存在します。");
			return;
		}
	}



	document.form_main.action = "outputTable.jsp";
	document.form_main.target = "frm_hidden";
	document.form_main.submit();


}




function regist(){



	//座標情報をセット
	for(i=0;i<parent.frm_main1.document.all.allObjDiv.childNodes.length;i++){
		var tableName=parent.frm_main1.document.all.allObjDiv.childNodes[i].tablename;
		parent.frm_main1.XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/left").text=parent.frm_main1.document.all.allObjDiv.childNodes[i].style.pixelLeft;
		parent.frm_main1.XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/top").text=parent.frm_main1.document.all.allObjDiv.childNodes[i].style.pixelTop;
		parent.frm_main1.XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/height").text=parent.frm_main1.document.all.allObjDiv.childNodes[i].childNodes[1].childNodes[0].offsetHeight;
		parent.frm_main1.XMLDom.selectSingleNode("//db_table[@name='" + tableName + "']/position/width").text=parent.frm_main1.document.all.allObjDiv.childNodes[i].childNodes[1].childNodes[0].offsetWidth;
	}


	document.form_main.hid_xml.value=parent.frm_main1.XMLDom.xml;



	if(confirm("<%=session.getValue("RModelName")%>を保存します。よろしいですか？")){
		document.form_main.action = "chart_regist.jsp";
		document.form_main.target = "frm_hidden";
		document.form_main.submit();
	}
	

}


function sql(){
//	var newWin = window.open("model/model_all.jsp","_blank","menubar=no,toolbar=no,width=1000px,height=650px,resizable");
//	var newWin = window.open("model/model.jsp","_blank","menubar=no,toolbar=no,width=830px,height=650px,resizable");
	window.showModalDialog("model/model.jsp",self,"dialogHeight:710px; dialogWidth:900px;");

}


function backToMenu(){
	if(confirm("モデル一覧に戻ります。よろしいですか？")){
		window.open('../intro/frm_menu.jsp','_top');
	}
}


</script>
</head>
<body topmargin="0" leftmargin="0">
<form name="form_main" id="form_main" method="post" action="">
<table class="Header">
	<!--画面タイトル-->
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter"><%=session.getValue("RModelName")%></td>
		<td class="HeaderTitleRight"><a class="logout" onclick="logout('rmodel')" onmouseover="this.style.cursor='hand'">ログアウト</a>
		</td>
	</tr>
</table>
<table style="width:100%;border-collapse:collapse">
	<!--ツールバー-->
	<tr>
		<td class="toolbar_left"></td>
		<td class="toolbar_center">
			<select name="lst_table" style="margin-bottom:4">
				<option value=''>---テーブルを選択してください---</option>
			<%
/*
				String schemaName="";

				Sql = " SELECT schema FROM oo_r_model";
				Sql += " WHERE model_seq = '" + (String)session.getValue("modelSeq") + "'";
				rs = stmt.executeQuery(Sql);
				if (rs.next()) {
					schemaName=rs.getString("schema");
				}
				rs.close();

				session.putValue("strSchemaName",schemaName);
*/
				String Sql="";
				Sql="";
			//	Sql = Sql + "SELECT tablename";
			//	Sql = Sql + " FROM pg_tables";
			//	Sql = Sql + " WHERE schemaname  = '" + session.getValue("RModelSchema") + "'";
			//	Sql = Sql + " ORDER BY tablename";

				Sql = Sql + "SELECT tablename as tablename";
				Sql = Sql + " FROM pg_tables";
				Sql = Sql + " WHERE schemaname = '" + session.getValue("RModelSchema") + "'";
				Sql = Sql + " UNION ";
				Sql = Sql + "SELECT viewname as tablename";
				Sql = Sql + " FROM pg_views";
				Sql = Sql + " WHERE schemaname = '" + session.getValue("RModelSchema") + "'";
				Sql = Sql + " ORDER BY tablename";

				rsRModel = stmtRModel.executeQuery(Sql);
				while(rsRModel.next()){
					out.println("<option value='" + rsRModel.getString("tablename") + "'>" + rsRModel.getString("tablename") + "</option>");
				}
				rsRModel.close();
			%>
			</select>
			<input type="button" class="normal_toolbar_add" onMouseOver="className='over_toolbar_add'" onMouseDown="className='down_toolbar_add'" onMouseUp="className='up_toolbar_add'" onMouseOut="className='out_toolbar_add'" onclick="outputTable()">
			<input type="button" class="normal_toolbar_delete" onMouseOver="className='over_toolbar_delete'" onMouseDown="className='down_toolbar_delete'" onMouseUp="className='up_toolbar_delete'" onMouseOut="className='out_toolbar_delete'" onclick="parent.frm_main1.del()">
			<input type="button" class="normal_toolbar_sql" onMouseOver="className='over_toolbar_sql'" onMouseDown="className='down_toolbar_sql'" onMouseUp="className='up_toolbar_sql'" onMouseOut="className='out_toolbar_sql'" onclick="sql()">
			<img src="../../images/Line.gif">
			<input type="button" value="" onclick="regist()" class="normal_toolbar_save" onMouseOver="className='over_toolbar_save'" onMouseDown="className='down_toolbar_save'" onMouseUp="className='up_toolbar_save'" onMouseOut="className='out_toolbar_save'">
			<img src="../../images/Line.gif">
			<input type="button" value="" onclick="backToMenu()" class="normal_toolbar_back_model" onMouseOver="className='over_toolbar_back_model'" onMouseDown="className='down_toolbar_back_model'" onMouseUp="className='up_toolbar_back_model'" onMouseOut="className='out_toolbar_back_model'">
		</td>
	</tr>
</table>

<input type="hidden" name="hid_xml" value="0">


</form>
</body>
</html>

