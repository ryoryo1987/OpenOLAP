<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" href="../css/common.css" type="text/css">
	<script type="text/javascript" src="../spread/js/spreadFunc.js"></script>

</head>
<body class="topPage">
<form>

<!-- �y�[�W�w�b�_�[ -->
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter" style="filter:Blur(strength=0)"><%=(String)session.getValue("aplName")%>�ւ悤����</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>

	</tr>
</table>

<p>
<%=(String)session.getValue("aplName")%>��OpenOLAP Model Designer�Ő������ꂽ�L���[�u��ΏۂƂ������͂ȃ��|�[�e�B���O�c�[���ł��B <br>
<%=(String)session.getValue("aplName")%>�̓r�W�l�X�C���e���W�F���X�𓱂��o���܂ł̉ߒ��ł���
�������f�[�^���͂��A�����I�Ŏg���₷�����A���͍�Ƃ����͂ɃT�|�[�g���܂��B
</p>
</form>
</body>

