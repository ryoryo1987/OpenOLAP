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
		<td class="HeaderTitleCenter">���|�[�g�Ǘ�</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>
	</tr>
</table>
<p>
���|�[�g���Ǘ����܂��B
</p>
<ul>
	<li class="item">���|�[�g�̐V�K�쐬
		<li class="exp">���|�[�g��V�K�ɍ쐬���邱�Ƃ��ł��܂��B
		</li>
	</li>
	<li class="item">�t�H���_�E���|�[�g�Ǘ�
		<li class="exp">���|�[�g�����������I�ɂ���t�H���_���쐬������A���|�[�g���t�H���_�Ɋ��蓖�ĂȂ����ȂǁA�G�N�X�v���[�����̑���Ńt�H���_�ƃ��|�[�g���Ǘ����邱�Ƃ��ł��܂��B


</li>
	</li>
</ul>


</form>
</body>

