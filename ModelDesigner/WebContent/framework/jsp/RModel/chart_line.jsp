<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect.jsp"%>
<%
	String objId = request.getParameter("objId");
	String tableName1 = request.getParameter("tableName1");
	String tableName2 = request.getParameter("tableName2");

%>
<html>
<head>
<title>OpenOLAP Model Designer</title>
<link rel="stylesheet" type="text/css" href="../../../jsp/css/common.css">
<script language="javascript">





	var openerFrame = window.dialogArguments;

function regist(){


	var strJoin="";
	strJoin+="<join id='<%=tableName1%>,<%=tableName2%>'>";
	strJoin+="<table1 tablename='<%=tableName1%>' count='" + document.form_main.lst_table1_jointype.value + "'>";
	for(i=0;i<frm_chart.document.all("<%=tableName1%>").lastChild.childNodes.length;i++){
		var arrColumnId=frm_chart.document.all("<%=tableName1%>").lastChild.childNodes[i].jibun;
		strJoin+="<join_column>" + frm_chart.document.getElementById(arrColumnId).innerHTML + "</join_column>";
	}
	strJoin+="</table1>";
	strJoin+="<table2 tablename='<%=tableName2%>' count='" + document.form_main.lst_table2_jointype.value + "'>";
	for(i=0;i<frm_chart.document.all("<%=tableName2%>").lastChild.childNodes.length;i++){
		var arrColumnId=frm_chart.document.all("<%=tableName2%>").lastChild.childNodes[i].jibun;
		strJoin+="<join_column>" + frm_chart.document.getElementById(arrColumnId).innerHTML + "</join_column>";
	}
	strJoin+="</table2>";
	strJoin+="</join>";




	var addXMLDom = new ActiveXObject("MSXML2.DOMDocument");
	addXMLDom.async = false;
	addXMLDom.loadXML(strJoin);


	openerFrame.XMLDom.selectSingleNode("//joins").removeChild(openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']"));

	openerFrame.XMLDom.selectSingleNode("//joins").appendChild(addXMLDom.selectSingleNode("//"));
//	alert(openerFrame.XMLDom.selectSingleNode("//joins").xml);

	//点線実線の切り替え
	openerFrame.mappingCheck();

	parent.window.close();
}




</script>
</head>
<body>
<form name="form_main" id="form_main" method="post" action="">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">マッピング設定
			</td>
			<td class="HeaderTitleRight"></td>
		</tr>
	</table>

<center>
	<iframe name="frm_chart" src="chart_line_chart.jsp?objId=<%=objId%>&tableName1=<%=tableName1%>&tableName2=<%=tableName2%>" width="500" height="250" scrolling="no" frameborder="0"></iframe>

	<table style="border-collapse:collapse">
		<tr>
			<td align="center">
				<input type="button" value="" onclick="frm_chart.del()" class="normal_delete_mapping" onMouseOver="className='over_delete_mapping'" onMouseDown="className='down_delete_mapping'" onMouseUp="className='up_delete_mapping'" onMouseOut="className='out_delete_mapping'">
			</td>
		</tr>
		<tr>
			<td align="center" style="visibility:hidden;">
				<%=tableName1%>：
				<select name="lst_table1_jointype">
					<option value="one">1</option>
					<option value="plural">n</option>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%=tableName2%>：
				<select name="lst_table2_jointype">
					<option value="one">1</option>
					<option value="plural">n</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="button" value="" onclick="regist()" class="normal_ok" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'">
				<input type="button" value="" onclick="parent.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
			</td>
		</tr>
	</table>

</center>


</form>
</body>
</html>

