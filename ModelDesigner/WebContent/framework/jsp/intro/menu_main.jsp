<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "designer.XMLConverter"%>
<%@ include file="../../../connect.jsp" %>

<html>
<head>
<title>OpenOLAP Model Desinger</title>

<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<script language="JavaScript" src="../js/registration.js"></script>
<script language="JavaScript" src="../../../jsp/js/common.js"></script>
<script language="JavaScript">
function load(){
<%
	if((session.getValue("modelSeq")!=null)&&(!"".equals((String)session.getValue("modelSeq")))){
		out.println("document.all('rdo_model_" + (String)session.getValue("modelSeq") + "').checked=true;");
		out.println("document.all('rdo_model_" + (String)session.getValue("modelSeq") + "').focus();");
	}
%>
}


function clickRdo(obj){
	document.form_main.modelSeq.value=obj.value;
}


function modelCheck(){
	var radio_flg=false;

	if(document.form_main.rdo_model[1]==undefined){
		if(document.form_main.rdo_model.checked){
			radio_flg=true;
			document.form_main.modelSeq.value=document.form_main.rdo_model.id.replace("rdo_model_","");
		}
	}else{
		for(i=0;i<document.form_main.rdo_model.length;i++){
			if(document.form_main.rdo_model[i].checked){
				radio_flg=true;
				document.form_main.modelSeq.value=document.form_main.rdo_model[i].id.replace("rdo_model_","");
			}
		}
	}

	return radio_flg;
}


function dispModel(){

	if(!modelCheck()){
		alert("�\�����郂�f����I�����Ă��������B ");
		return;
	}

	document.form_main.action="../RModel/frm_chart.jsp";
	document.form_main.target="_self";
	document.form_main.submit();
}

function delModel(){

	if(!modelCheck()){
		alert("�폜���郂�f����I�����Ă��������B ");
		return;
	}

	if(confirm(document.all("td_" + document.form_main.modelSeq.value).innerHTML + "���폜���܂��B��낵���ł����H")){
		document.form_main.action="create_model_regist.jsp?tp=2";
		document.form_main.target="frm_hidden";
		document.form_main.submit();
	}
}


var editFlg = false;
function rename(obj){
	if(!editFlg){
		obj.innerHTML="<input type='text' name='txt_model_name' mON='���f����' value='" + obj.innerHTML + "' maxlength='30' onblur='renameUpdate(this)'>";
		obj.firstChild.select();
		obj.firstChild.focus();
		editFlg=true;
	}

	document.form_main.modelSeq.value=obj.id.replace("td_","");
}

function renameUpdate(obj){

	//���ʃG���[�`�F�b�N���ɍs��
	if(!checkData()){return;}

	document.form_main.action="create_model_regist.jsp?tp=1&modelName=" + obj.value;
	document.form_main.target="frm_hidden";
	document.form_main.submit();

	obj.parentNode.innerHTML=obj.value;

	editFlg=false;

}


function createModel(){
//	window.open('frm_create_model.jsp','','width=600,height=365,menubar=no,location=no,resizable=no,status=no,toolbar=no')
	window.showModalDialog("frm_create_model.jsp",self,"dialogHeight:420px; dialogWidth:630px;");
}



</script>
</head>
<body onload="load()">
<!-- �y�[�W�w�b�_�[ -->
<form name="form_main" id="form_main" method="post" action="">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				ROLAP���f���̑I��
			</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout('rmodel')" onmouseover="this.style.cursor='hand'">���O�A�E�g</a>
			</td>
		</tr>
	</table>

				<div style="margin:20">
				
				<table style="border-collapse:collapse">
				<tr>
				<td>
				�V�K���f�����쐬�F
				</td>
				<td valign="middle">
				<input type="button" value="" onclick="createModel()" class="normal_create_mini" onMouseOver="className='over_create_mini'" onMouseDown="className='down_create_mini'" onMouseUp="className='up_create_mini'" onMouseOut="className='out_create_mini'">
				</td>
				</tr>
				<tr>
				<td>
				�������f����I���F
				</td>
				<td>
				<input type="button" value="" onclick="dispModel()" class="normal_display_mini" onMouseOver="className='over_display_mini'" onMouseDown="className='down_display_mini'" onMouseUp="className='up_display_mini'" onMouseOut="className='out_display_mini'">
				<input type="button" value="" onclick="delModel()" class="normal_delete_mini" onMouseOver="className='over_delete_mini'" onMouseDown="className='down_delete_mini'" onMouseUp="className='up_delete_mini'" onMouseOut="className='out_delete_mini'">
				</td>
				</tr>
				</table>
				<table width="95%">
					<tr>
						<th class="standard" style="white-space:nowrap">�I��</th>
						<th class="standard">���O</th>
						<th class="standard">�R�l�N�g�\�[�X�ƃ��[�U�[</th>
						<th class="standard">�X�L�[�}</th>
						<th class="standard">�g�p�e�[�u��</th>
					</tr>

				<%
					String Sql;

					boolean modelExistFlg=false;

					Sql = "select model_seq,name,dsn,db_user,schema,model_xml,last_update from oo_r_model order by model_seq";
					rs = stmt.executeQuery(Sql);
					while (rs.next()) {
						modelExistFlg=true;

						String strTables="";
						String tempXML=rs.getString("model_xml");
						XMLConverter xmlCon = new XMLConverter();
						Document doc = xmlCon.toXMLDocument(tempXML);
						Element root = doc.getDocumentElement();
						NodeList list = root.getElementsByTagName("db_table");
						if(list.getLength()==0){
							strTables="���f�����ݒ�";
						}
						for(int i=0;i<list.getLength();i++){
							Element rowElement = (Element)list.item(i);
							if(!"".equals(strTables)){strTables+=", ";}
							strTables+=rowElement.getAttribute("name");
						}

						out.println("<tr>");
						out.println("<td class='standard' align='center'><input type='radio' name='rdo_model' id='rdo_model_" + rs.getString("model_seq") + "' value='" + rs.getString("model_seq") + "' onclick='clickRdo(this)'></td>");
						out.println("<td id='td_" + rs.getString("model_seq") + "' class='standard' ondblclick='rename(this)' style='white-space:normal'>" + rs.getString("name") + "</td>");
						out.println("<td class='standard'>" + rs.getString("dsn") + "," + rs.getString("db_user") + "</td>");
						out.println("<td class='standard'>" + rs.getString("schema") + "</td>");
						out.println("<td class='standard' style='white-space:normal'>" + strTables + "</td>");
						out.println("</tr>");
					}
					rs.close();

				%>



				</table>

				<%
					if(modelExistFlg==false){
						out.println("<BR>�������f���͂���܂���");
					}
				%>

				</div>

				<input type="hidden" name="modelSeq" value="">
</form>
</body>
</html>