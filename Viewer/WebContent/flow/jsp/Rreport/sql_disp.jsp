<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*" %>
<%@ page import="openolap.viewer.PostgreSqlGenerator" %>
<%@ include file="../../connect.jsp"%>

<%
	String rId=request.getParameter("rId");
	String SQL = "select * from oo_v_report where report_id="+rId;
	rs = stmt.executeQuery(SQL);
	String strSQL="";
	String sqlCustomFlg="0";
	if(rs.next()){
		sqlCustomFlg=rs.getString("customized_flg");
		strSQL=rs.getString("sql_text");
	}
	rs.close();
%>

<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS" />
<title><%=(String)session.getValue("aplName")%></title>
<link rel="stylesheet" type="text/css" href="../../../css/common.css">
<script language="JavaScript" src="../js/registration.js"></script>
<script type="text/JavaScript1.2">
function load(){
	if(window.dialogArguments[0].value=="1"){
		var checkB = document.getElementById("custCheck");
		checkB.checked=true;
		var textArea = document.getElementById("customSQL");
		textArea.innerText=window.dialogArguments[1].value;
	}


	sqlDisabledCheck();

}


function sqlDisabledCheck(){
	if(document.all.custCheck.checked){
		document.all.customSQL.disabled=false;
	}else{
		document.all.customSQL.disabled=true;
	}
}


function clickCheckbox(th){
	var textArea = document.getElementById("customSQL");
	var strSql = document.getElementById("strSQL").outerText;
	if(th.checked==true){
		textArea.innerText=strSql;
	}else{
		textArea.innerText="";
	}

	sqlDisabledCheck();

}

function setSql(arg){
	if(arg=='Cancel'){
		window.close();
		return;
	}else{

		//共通エラーチェックを先に行う
		if(!checkData()){return;}

		var checkB = document.getElementById("custCheck");
		if(checkB.checked==true){
			window.dialogArguments[0].value="1";
			window.dialogArguments[1].value=document.getElementById("customSQL").outerText;
		}else{
			window.dialogArguments[0].value="0";
		}
		window.close();
	}
}
</script>
</head>
<body onload='load()'>
<form name="form_main" id="form_main" target="navi_frm" method="post" action="">
<a href='#'></a><!--スクロールさせないために必要-->
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">SQLの確認とカスタマイズ</td>
	</tr>
</table>

<pre id='strSQL' style="margin-left:15">
<%out.println(request.getSession().getAttribute("Rsql"));%>
</pre>

<input type="checkbox" value="1" id="custCheck" onclick="clickCheckbox(this)" style="margin-left:15" />
カスタマイズ

<br>
<textarea name="customSQL" id='customSQL' cols="100" rows="15" mON="カスタマイズSQL" style="margin-left:15">
</textarea>

<div class="command">
	<input type="button" value='' name='OK' onclick="setSql('OK')" class="normal_ok_mini" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'" />
	<input type="button" value='' name='Cancel' onclick="setSql('Cancel')" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'" />
</div>

</form>
</body>
</html>

<%@ include file="../../connect_close.jsp" %>
