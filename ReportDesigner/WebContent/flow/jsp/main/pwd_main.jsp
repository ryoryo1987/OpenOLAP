<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>

<%@ include file="../../connect.jsp"%>
<%
	String seqId = request.getParameter("seqId");
%>


<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">

		function regist(){

			//���ʃG���[�`�F�b�N���ɍs��
			if(!checkData()){return;}

			if(document.form_main.txt_new_pwd1.value!=document.form_main.txt_new_pwd2.value){
				alert("�p�X���[�h��������x�m�F���Ă��������B");
				document.form_main.txt_new_pwd1.focus();
				document.form_main.txt_new_pwd1.select();
				return;
			}

			document.form_main.action = "../hidden/pwd_regist.jsp";
			document.form_main.target = "frm_hidden";
			document.form_main.submit();

		}

	</script>








</head>

<body>
	<form id="form_main" method="post" name="form_main">

	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">�p�X���[�h�ύX</td>
			<td class="HeaderTitleRight">
				<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
			</td>
		</tr>
	</table>

	<div style="margin:15">



				<table>
					<tr>
						<td align="right"><span class="title">���݂̃p�X���[�h�F</span></td>
						<td>
							<input type="password" name="txt_old_pwd" size="60" value="" mON="���݂̃p�X���[�h" maxlength="30" onchange="setChangeFlg();">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">�V�����p�X���[�h�F</span></td>
						<td>
							<input type="password" name="txt_new_pwd1" size="60" value="" mON="�V�����p�X���[�h" maxlength="30" onchange="setChangeFlg();">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">�m�F�p�p�X���[�h�F</span></td>
						<td>
							<input type="password" name="txt_new_pwd2" size="60" value="" mON="�m�F�p�p�X���[�h" maxlength="30" onchange="setChangeFlg();">
						</td>
					</tr>
				</table>
			

<BR>


				<div class="command">
						<!-- **************************  �X�V�@�{�^�� ***************************** -->
						<input type="button" name="edi_btn" value="" class="normal_update" onClick="javaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
				</div>


				<input type="hidden" name="hid_user_id" value="<%=seqId%>">

	</div>
	</form>
</body>
</html>
<%@ include file="../../connect_close.jsp" %>
