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
		<td class="HeaderTitleCenter">���[�U�[�ݒ�</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>
	</tr>
</table>
<p>
���[�U�[�̃p�X���[�h�A�G�N�X�|�[�g�`����ύX���܂��B</p>
<ul>
	<li class="item">�p�X���[�h�ύX
		<li class="exp">���[�U�[�̃p�X���[�h��ύX���܂��B
		</li>
	</li>
	<li class="item">�G�N�X�|�[�g�`��
		<li class="exp">���|�[�g�̃G�N�X�|�[�g�`����CSV�܂���XML Spreadsheet�`���̂����ꂩ�ɐݒ肵�܂��B
</li>
	</li>
</ul>


</form>
</body>
