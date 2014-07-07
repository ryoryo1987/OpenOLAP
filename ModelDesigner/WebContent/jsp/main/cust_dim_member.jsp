<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%//@ include file="../../connect_session.jsp"%>
<%
request.setCharacterEncoding("Shift_JIS");
response.setHeader("Cache-Control", "no-cache");//キャッシュさせない


Connection connMeta = null;
Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
connMeta = (Connection)session.getValue(session.getId()+"Conn");
stmt     = (Statement) session.getValue(session.getId()+"Stmt");
stmt2     = (Statement) session.getValue(session.getId()+"Stmt2");
stmt3     = (Statement) session.getValue(session.getId()+"Stmt3");
%>

<%



	String Sql="";
	String strKey=request.getParameter("key");
	String addFlg="";
	if(strKey.equals("-999")){
		addFlg="1";
	}else{
		addFlg="0";
	}
	
	String strLongName="";
	String strShortName="";
	String strMinVal="";
	String strMaxVal="";
	String strLike="";

	Sql = "SELECT long_name,short_name,replace(min_val,'.00','') AS min_val,replace(max_val,'.00','') AS max_val,calc_text ";
	Sql = Sql + " FROM " + session.getValue("CustomTableName") + " WHERE key = " + strKey;
	rs = stmt.executeQuery(Sql);
	if(rs.next()) {
		strLongName=rs.getString("long_name");
		strShortName=rs.getString("short_name");
		strMinVal=rs.getString("min_val");
		strMaxVal=rs.getString("max_val");
		strLike=rs.getString("calc_text");
	}
	rs.close();


	if(addFlg.equals("1")){
		Sql = "SELECT NEXTVAL('" + session.getValue("CustomTableSequence") + "') AS new_seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			strKey=rs.getString("new_seq");
		}
		rs.close();
	}

%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../css/common.css">
	<link rel="stylesheet" type="text/css" href="../css/member.css">
	<script language="JavaScript" src="../js/registration.js"></script>
</head>

<body class="sub" onload="changefocus()" style="background-color:white">
	<form id="form_main" method="post" name="form_main">
		ロングネーム: <input type='text' name='txt_long_name' value='<%=strLongName%>' size='30' maxlength='30' mON='ロングネーム' onblur="copyText();">
		<p>
		ショートネーム: <input type='text' name='txt_short_name' value='<%=strShortName%>' size='30' maxlength='30' mON='ショートネーム'>
		<p>
	

<%if(!strKey.equals("-1")){%>
<%if("2".equals(session.getValue("dimType"))){%>
<%if("1".equals(session.getValue("strSegDataType"))){%>
		最小値:<input type='text' name='txt_min_numeric' size='10' maxlength='30' value='<%=strMinVal%>' mON='最小値'>
&nbsp;&nbsp;----&nbsp;&nbsp;最大値:<input type='text' name='txt_max_numeric' size='10' maxlength='30' value='<%=strMaxVal%>' mON='最大値'>
		<p>
<%}else if("2".equals(session.getValue("strSegDataType"))){%>
		LIKE:<input type='text' name='txt_like' value='<%=strLike%>' size='30' maxlength='30' mON='LIKE'>
		</p>
<%}%>
<%}%>
<%}else{%>
		<input type = 'hidden' name = 'txt_min_numeric' value=''>
		<input type = 'hidden' name = 'txt_max_numeric' value=''>
		<input type = 'hidden' name = 'txt_like' value=''>
<%}%>
		<input type = 'button' value='' onclick="regist();" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'" >
		<input type = 'button' value='' onclick="cancel();" class="normal_cancel_mini" onMouseOver="className='over_cancel_mini'" onMouseDown="className='down_cancel_mini'" onMouseUp="className='up_cancel_mini'" onMouseOut="className='out_cancel_mini'">
		<input type = 'hidden' name = 'hid_key' value='<%=strKey%>'>
	</form>
</body>
</html>

<script language="JavaScript">
var arrArg;

function changefocus(){

	arrArg = dialogArguments;

//	window.focus();
	document.form_main.txt_long_name.focus();
	document.form_main.txt_long_name.select();
}

function copyText(){
	if(document.form_main.txt_short_name.value==""){
		document.form_main.txt_short_name.value=document.form_main.txt_long_name.value;
	}

}


function regist(){

		//共通エラーチェックを先に行う
		if(!checkData()){return;}

		if(showConfirm("CFM4","ショートネーム:" + document.form_main.txt_short_name.value)){
			<%if(addFlg.equals("1")){%>//追加
			arrArg[0].SpreadForm.action = "../hidden/cust_dim_tree_regist.jsp?opr=add&key=" + document.form_main.hid_key.value + "&par_key=" + arrArg[0].SpreadForm.hid_par_key.value + "&long_name=" + document.form_main.txt_long_name.value + "&short_name=" + document.form_main.txt_short_name.value;
			<%}else{%>//編集
			arrArg[0].SpreadForm.action = "../hidden/cust_dim_tree_regist.jsp?opr=rename&key=" + document.form_main.hid_key.value + "&long_name=" + document.form_main.txt_long_name.value + "&short_name=" + document.form_main.txt_short_name.value;
			<%}%>
			<%if("2".equals(session.getValue("dimType"))){%>
				<%if("1".equals(session.getValue("strSegDataType"))){%>
				arrArg[0].SpreadForm.action += "&min_val=" + document.form_main.txt_min_numeric.value + "&max_val=" + document.form_main.txt_max_numeric.value;
				<%}else if("2".equals(session.getValue("strSegDataType"))){%>
				arrArg[0].SpreadForm.action += "&like=" + document.form_main.txt_like.value;
				<%}%>
			<%}%>
		//	arrArg[0].SpreadForm.target = arrArg[0].parentNode.parent.frames[0].name;
			arrArg[0].SpreadForm.target = "update_tree_frm";
			arrArg[0].SpreadForm.submit();
		}else{
			return;
		}



		<%if(addFlg.equals("1")){%>//追加
		var newRow = arrArg[0].getElementById("DataTable").rows[0].cloneNode(true);
		arrArg[0].getElementById("DataTable").childNodes[1].appendChild(newRow);
		var selectedRow = arrArg[0].getElementById("DataTable").childNodes[1].lastChild;
		selectedRow.style.display="block";
		selectedRow.id="<%=strKey%>";
		selectedRow.cells[0].firstChild.childNodes[1].innerHTML=document.form_main.txt_short_name.value;
		selectedRow.cells[1].firstChild.innerHTML="<%=strKey%>";
		selectedRow.cells[2].firstChild.innerHTML="V<%=strKey%>";
		selectedRow.cells[3].firstChild.innerHTML=document.form_main.txt_long_name.value;
		<%if("2".equals(session.getValue("dimType"))){%>
			<%if("1".equals(session.getValue("strSegDataType"))){%>
				selectedRow.cells[4].firstChild.innerHTML=document.form_main.txt_min_numeric.value;
				selectedRow.cells[5].firstChild.innerHTML=document.form_main.txt_max_numeric.value;
			<%}else if("2".equals(session.getValue("strSegDataType"))){%>
				selectedRow.cells[4].firstChild.innerHTML=document.form_main.txt_like.value;
			<%}%>
		<%}%>

		//左側ツリーへメンバ追加
	//	arrArg[0].parentNode.parent.frames[1].addMember(document.form_main.txt_short_name.value,document.form_main.txt_long_name.value,<%=strKey%>);
		arrArg[1].addMember(document.form_main.txt_short_name.value,document.form_main.txt_long_name.value,<%=strKey%>);


		<%}else{%>//編集
		var selectedRow = arrArg[0].getElementById("<%=strKey%>");
		selectedRow.cells[0].firstChild.childNodes[1].innerHTML=document.form_main.txt_short_name.value;
		selectedRow.cells[3].firstChild.innerHTML=document.form_main.txt_long_name.value;
		<%if("2".equals(session.getValue("dimType"))){%>
			<%if("1".equals(session.getValue("strSegDataType"))){%>
				selectedRow.cells[4].firstChild.innerHTML=document.form_main.txt_min_numeric.value;
				selectedRow.cells[5].firstChild.innerHTML=document.form_main.txt_max_numeric.value;
			<%}else if("2".equals(session.getValue("strSegDataType"))){%>
				selectedRow.cells[4].firstChild.innerHTML=document.form_main.txt_like.value;
			<%}%>
		<%}%>

		arrArg[1].renMember(<%=strKey%>,document.form_main.txt_short_name.value);

		<%}%>



		//Window Close
		self.window.close();


}

function cancel(){
	self.window.close();
}


</script>
