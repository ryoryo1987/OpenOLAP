<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect.jsp"%>
<%

	String objId = request.getParameter("objId");
	String tableName1 = request.getParameter("tableName1");
	String tableName2 = request.getParameter("tableName2");
	String Sql="";
	int i;
	String schemaName=(String)session.getValue("RModelSchema");


	String arrColumnName1[] = new String[1000];
	String arrColumnName2[] = new String[1000];

	Sql = "";
	Sql += " SELECT";
	Sql += " oo_fun_columnList('" + tableName1 + "','" + schemaName + "') AS columnlist";
	rs = stmt.executeQuery(Sql);
	i=0;
	while(rs.next()){
		StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
		while(st.hasMoreTokens()) {
			String columnText = st.nextToken();
			StringTokenizer st2 = new StringTokenizer(columnText," ");
			String columnName = st2.nextToken();
			arrColumnName1[i]=columnName;
			i++;
		}
	}
	rs.close();

	Sql = "";
	Sql += " SELECT";
	Sql += " oo_fun_columnList('" + tableName2 + "','" + schemaName + "') AS columnlist";
	rs = stmt.executeQuery(Sql);
	i=0;
	while(rs.next()){
		StringTokenizer st = new StringTokenizer(rs.getString("columnlist"),",");
		while(st.hasMoreTokens()) {
			String columnText = st.nextToken();
			StringTokenizer st2 = new StringTokenizer(columnText," ");
			String columnName = st2.nextToken();
			arrColumnName2[i]=columnName;
			i++;
		}
	}
	rs.close();




%>



<html xmlns:v="urn:schemas-microsoft-com:vml"> 
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">

<title>VML</title>
	<style>
	v\:* { behavior: url(#default#VML); }
	* { 
		font-style:Arial 'MS UI Gothic';
		font-size:12px;
	}
	.divObj{
		position:absolute;
	}
	.selectedDivObj{
		position:absolute;
	}

	.rectTitle{
		OVERFLOW: hidden;
		TEXT-OVERFLOW: ellipsis;
		VERTICAL-ALIGN: middle;
		font-size:10px;
		white-space:nowrap;
		cursor:hand;
		width:150;
		height:10;
	}
	.divContents{
		position:relative;
		border:0 solid black;
		border-width : 0 0 0 0;
		white-space:nowrap;
		cursor:default;
		padding-left:10;
	}
	.rectContents{
		width:150;
		height:100;
	}
	.imgContents{
		background-image:url(co.png);
		background-repeat:no-repeat;
		position:relative;
		top:0;
		left:0;
		width:30;
		height:20
	}
	.divContentsText{
		position:relative;top:0;left:10;
		overflow:auto;
		font-size:12px;
		width:140;
		height:80;
	}

	.GamenText{
		position:relative;top:10;left:10;
		overflow:auto;
		font-size:20px;
		width:100;
		height:50;
	}
	</style>
</head>

<script language="JavaScript" src="../js/chart_line.js"></script>

<script language="JavaScript">

	var openerFrame = window.dialogArguments;



//オブジェクト削除
function del(){
	for(var ob=0;ob<document.all.length;ob++){
		var obj=document.all(ob);
	//	if(obj.style.filter=="invert()"){
		if(obj.selectedflg=='1'){
			document.getElementById("f," + obj.id).parentNode.removeChild(document.getElementById("f," + obj.id));
			document.getElementById("t," + obj.id).parentNode.removeChild(document.getElementById("t," + obj.id));
			obj.parentNode.removeChild(obj);
			ob=0;//一度にひもづくオブジェクトがいくつ消えるかわからないので繰り返しチェックするようにしている
		}
	}
}


function scroll(thisObj){
//	var a = document.getElementById("obj1");
//	var b = document.getElementById("obj2");
//	a.scrollLeft=th.scrollLeft;
//	b.scrollTop=th.scrollTop;


	var lineSource=document.all.lineSource;

	for(i=0;i<lineSource.childNodes.length;i++){
		if(lineSource.childNodes[i].id!="dashline"){
			var arrId=lineSource.childNodes[i].id.split(",");
			var tempNo;

			if(document.getElementById("f," + lineSource.childNodes[i].id).parentNode.parentNode==thisObj){
				var arrXY=(lineSource.childNodes[i].from+"").split(",");
				tempNo=0;
			}else{
				var arrXY=(lineSource.childNodes[i].to+"").split(",");
				tempNo=1;
			}

			var x=arrXY[0];
			var y=document.getElementById(arrId[tempNo]).parentNode.offsetTop + document.getElementById(arrId[tempNo]).offsetTop + (document.getElementById(arrId[tempNo]).offsetHeight/2)-document.all(thisObj.id).scrollTop;

			if(document.getElementById("f," + lineSource.childNodes[i].id).parentNode.parentNode==thisObj){
				lineSource.childNodes[i].from=x+","+y;
			}else{
				lineSource.childNodes[i].to=x+","+y;
			}
		}
	}

}


function chouseiScroll(line){//ラインマッピング時のスクロール分調整
	scroll(document.getElementById("f," + line.id).parentNode.parentNode);
	scroll(document.getElementById("t," + line.id).parentNode.parentNode);
}


function load(){
	//joinマッピング作成
	for(m=0;m<openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']//table1").childNodes.length;m++){
		var column1name = openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']//table1").childNodes[m].text;
		var column2name = openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']//table2").childNodes[m].text;
//	alert(document.getElementById("table1_" + column1name).outerHTML);
//	alert(document.getElementById("table2_" + column2name).outerHTML);
		makeLine(document.getElementById("table1_" + column1name),document.getElementById("table2_" + column2name));
	}


	//join(1/n)の設定
	var table1count = openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']//table1").getAttribute("count");
	var table2count = openerFrame.XMLDom.selectSingleNode("//join[@id='<%=tableName1%>,<%=tableName2%>']//table2").getAttribute("count");
	if(table1count=="plural"){
		parent.document.form_main.lst_table1_jointype.options[1].selected=true;
	}
	if(table2count=="plural"){
		parent.document.form_main.lst_table2_jointype.options[1].selected=true;
	}

}



</script>


</head>
<body onload="load()" kind='body' onselectstart="return false;" onmousemove=';mymousemove();' onmouseup=';mymouseup();' onmousedown='mymousedown()'>
<div id='a' style='position:absolute;top:0;left:0;width:100%;height:50;background-color:white;z-index:100;padding-top:10'>
左のテーブルのカラムから右のテーブルのカラムへマウスをドラッグして、カラムをマッピングしてください。
</div>
<!--
<div class='divObj' id='obj1' style='top:100;left:100;'>
	<div class='divTitle' id='T1' kind='title' onDblClick='openTableInfo()'>
		<v:rect class='rectTitle' endarrow='classic' >
			<v:stroke opacity='0.5'/>
			<v:fill type='gradient' color='white' color2='red' opacity='0.5' />
			<img src='../../images/co.png' class='imgTitle'>
			sales_fact テーブル
		</v:rect >
	</div>
	<div class='divContents' id='C1' kind='contents'>
		<v:rect class='rectContents' onmouseover='mouseOver(this)' onmousedown='resizemousedown(this)'>
			<v:stroke opacity='0.2' />
			<v:fill type='gradient' color='red' color2='white' opacity='0.2' />
			<div class='imgContents'></div>
			<div class='divContentsText'>
				sum(sales) (売上げ)<br>
				sum(cost) (コスト)<br>
			</div>
		</v:rect >
	</div>
	<div></div>
</div>
-->

<div id='allObjDiv' style="position:absolute;top:0;left:0;">



	<div id='T1' kind='title' onDblClick='openTableInfo()' style='position:absolute;top:50;left:20;width:150;height:20;z-index:100;'>
		<table style="border-collapse:collapse">
			<tr>
				<td>
					<img src='../../images/gamen2.gif'>
				</td>
				<td style="padding-left:5;padding-bottom:4;white-space:nowrap">
					<%=tableName1%>
				</td>
			</tr>
		</table>
	</div>
	<div class='divObj' id='<%=tableName1%>' style='border:1 solid gray;position:absolute;top:70;left:20;width:150;height:180;overflow-y:scroll;' onscroll='scroll(this)'>
		<%
		for(i=0;i<arrColumnName1.length;i++){
			if(arrColumnName1[i]!=null){
				out.println("<div class='divContents' id='table1_" + arrColumnName1[i] + "' kind='contents' onmouseover='this.style.backgroundColor=\"#C3F096\"' onmouseout='this.style.backgroundColor=\"white\"'>" + arrColumnName1[i] + "</div>");
			}
		}
		%>
		<div></div>
	</div>

	<div id='T2' kind='title' onDblClick='openTableInfo()' style='position:absolute;top:50;left:300;width:150'>
		<table style="border-collapse:collapse">
			<tr>
				<td>
					<img src='../../images/gamen2.gif' valign='middle'>
				</td>
				<td style="padding-left:5;padding-bottom:4;white-space:nowrap">
					 <%=tableName2%>
				</td>
			</tr>
		</table>
	</div>
	<div class='divObj' id='<%=tableName2%>' style='border:1 solid gray;position:absolute;top:70;left:300;width:150;height:180;overflow-y:scroll;' onscroll='scroll(this)'>
		<%
		for(i=0;i<arrColumnName2.length;i++){
			if(arrColumnName2[i]!=null){
				out.println("<div class='divContents' id='table2_" + arrColumnName2[i] + "' kind='contents' onmouseover='this.style.backgroundColor=\"#C3F096\"' onmouseout='this.style.backgroundColor=\"white\"'>" + arrColumnName2[i] + "</div>");
			}
		}
		%>
		<div></div>
	</div>
</div>



<div name='lineSource' id='lineSource' style='position:absolute;top:0;left0;z-index:99;'>
	<v:line name='dashline' id='dashline' style='position:absolute;' from='0,0' to='0,0' strokecolor='green' strokeweight='1pt'/>
</div>


<!--線を見えなくするレイヤー領域-->
<div id='b' style='position:absolute;top:250;left:0;width:100%;height:100%;background-color:white;z-index:100;'>
</div>


</body>
</html>

