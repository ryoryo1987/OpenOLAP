<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	Sql = "SELECT ";
	Sql = Sql + "  r.report_id";
	Sql = Sql + " ,r.report_name";
	Sql = Sql + " ,r.report_type";
	Sql = Sql + " ,r.screen_id  ";
	Sql = Sql + " ,r.screen_name";
	Sql = Sql + " ,r.style_id   ";
	Sql = Sql + " ,r.style_name ";
	Sql = Sql + " ,r.model_seq  ";
	Sql = Sql + " ,m.name as model_name  ";
	Sql = Sql + " ,m.schema";
	Sql = Sql + " FROM oo_v_report r";
	Sql = Sql + " ,oo_r_model m";
	Sql = Sql + " WHERE r.model_seq=m.model_seq";
	Sql = Sql + " AND r.report_type='R'";
	Sql = Sql + " ORDER BY r.report_id";
//out.println(Sql);

	rs = stmt.executeQuery(Sql);
%>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<script type="text/javascript" src="../js/registration.js"></script>
</head>
<script>
	var objN,objT;
	function load(){
		objT=document.getElementById("T0");
	}
	function updateReport(th){
		if(objN!=null){
		//	objN.innerText=objN.firstChild.preName;
			objN.innerText=objN.lastChild.preName;
			objN=null;
		}
		if(objT!=null){
			objT.innerText="";
			objT=null;
		}
		var id=th.value.split(":");
		objN = document.getElementById("Name"+id[0]);
	//	objN.innerHTML="<input type='text' name='reportName' id='reportName' value='"+objN.outerText+"' preName='"+objN.outerText+"' maxlength='30' size='40' mON='���|�[�g��' onchange='setChangeFlg();'>";
		objN.innerHTML+="<input type='hidden' name='reportName' id='reportName' value='"+objN.outerText+"' preName='"+objN.outerText+"'>";

	}



	function copyReport(th){
		if(objN!=null){
		//	objN.innerText=objN.firstChild.preName;
			objN.innerText=objN.lastChild.preName;
			objN=null;
		}
		if(objT!=null){
			objT.innerText="";
			objT=null;
		}
		var id=th.value.split(":");
		objT = document.getElementById("T"+id[0]);
		objT.innerHTML="&nbsp;&nbsp;&nbsp;&nbsp;�V�K���|�[�g���F<input type='text' name='reportName' id='reportName' value='"+objT.outerText+"' preName='"+objT.outerText+"' maxlength='30' size='40' mON='�V�K���|�[�g��' onchange='setChangeFlg();'>";
	}

	function delReport(reportId,reportName){
		if(confirm(reportName+"���폜���܂��B��낵���ł����H")){
			var delXML= new ActiveXObject("MSXML2.DOMDocument");
				delXML.async = false;
			delXML.load("rReport_delete.jsp?rId="+reportId);
//alert(delXML.xml);
			alert(delXML.selectSingleNode("//result").getAttribute("result"));
			document.form_main.target = "_self";
			document.form_main.action = "r_report_start.jsp";
			document.form_main.submit();
		}
	}
</script>

<body onload='load()'>
<form name="form_main" id="form_main" method="post" action="">

<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">ROLAP���|�[�g�쐬�@-�@���|�[�g�I��(1/4)</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>
	</tr>
</table>
<div style="height:500px;margin:10px">
	<input type="radio" name="report_id" checked='true' value='0:new' onclick='copyReport(this);setChangeFlg();'>�V�K���f�����쐬&nbsp;&nbsp;&nbsp;
	<div style='display:inline' id='T0'>�V�K���|�[�g���F<input type='text' name='reportName' id='reportName' value='' maxlength='30' size='40' mON='�V�K���|�[�g��' onchange='setChangeFlg();'></div>

	<table style="border-collapse:collapse;margin-top:10px;">
		<tr>
			<td class="simpleTableTitle" width="30"style="text-align:center">�ҏW</td>
			<td class="simpleTableTitle" width="30" style="text-align:center">��߰����<br>�쐬</td>
			<td class="simpleTableTitle" style="text-align:center">ID</td>
			<td class="simpleTableTitle" width="300" style="text-align:center">���O</td>
			<td class="simpleTableTitle" style="text-align:center">�X�L�[�}</td>
			<td class="simpleTableTitle" style="text-align:center">�_�����f��</td>
			<td class="simpleTableTitle" style="text-align:center">��ʂ̎��</td>
			<td class="simpleTableTitle" style="text-align:center">�X�^�C��</td>
		<!--	<td class="simpleTableTitle" style="text-align:center">�폜</td>-->
		</tr>
<%
	String strScript="";
	while(rs.next()){
		out.println("<tr>");
			out.println("<td class='simpleTableDataCell' style='text-align:center'><input type='radio' name='report_id' value='"+rs.getString("report_id")+":update' onclick='updateReport(this);setChangeFlg();'></td>");
			out.println("<td class='simpleTableDataCell' style='text-align:center'><input type='radio' name='report_id' value='"+rs.getString("report_id")+":new' onclick='copyReport(this);setChangeFlg();'></td>");
			out.println("<td class='simpleTableDataCell'>"+rs.getString("report_id")+"</td>");
			out.println("<td class='simpleTableDataCell'><div style='display:inline' id='Name"+rs.getString("report_id")+"'>"+rs.getString("report_name")+"</div><div style='display:inline' id='T"+rs.getString("report_id")+"'></div></td>");
			out.println("<td class='simpleTableDataCell'>"+rs.getString("schema")+"</td>");
			out.println("<td class='simpleTableDataCell'>"+rs.getString("model_name")+"</td>");
			out.println("<td class='simpleTableDataCell'>"+rs.getString("screen_name")+"</td>");
			out.println("<td class='simpleTableDataCell'>"+rs.getString("style_name")+"</td>");
				strScript="delReport(\""+rs.getString("report_id")+"\",\""+rs.getString("report_name")+"\")";
		//	out.println("<td class='simpleTableDataCell'><input type='button' value='�폜' onclick='"+strScript+";setChangeFlg();'></td>");
		out.println("</tr>");
	}
	rs.close();
%>
	</table>
</div>

</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>

