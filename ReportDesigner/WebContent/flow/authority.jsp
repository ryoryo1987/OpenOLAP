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
		<td class="HeaderTitleCenter">�����ݒ�</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>
	</tr>
</table>
<p>
OpenOLAP Viewer�̃O���[�v�ɑ΂��āA���|�[�g���ƂɈȉ��̐ݒ�����邱�Ƃ��ł��܂��B
</p>
<ul>
	<li class="item">���|�[�g�Q�ƌ���
	</li>
	<li class="item">�G�N�X�|�[�g����
	</li>
</ul>


</form>
</body>

