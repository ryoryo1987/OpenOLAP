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
		<td class="HeaderTitleCenter">���[�U�[�ƃO���[�v</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">���O�A�E�g</a>
		</td>
	</tr>
</table>
<p>
���[�U�[�ƃO���[�v�ł́AOpenOLAP Viewer���g�p���郆�[�U�[��O���[�v���쐬���邱�Ƃ��ł��܂��B
���[�U�[����уO���[�v�ɂ̓��|�[�g�̎Q�ƌ�����G�N�X�|�[�g�`�����ʂɎw�肷�邱�Ƃ��ł��A���[�U�[���O���[�v�ɏ��������Ĉꌳ�Ǘ����邱�Ƃ��ł��܂��B
</p>
<ul>
	<li class="item">���[�U�[
		<li class="exp">���[�U�[�ɂ́A�ȉ���3��ނ�����܂��B
			<table style="border-collapse:collapse;margin-top:10px;">
				<tr>
					<td></td>
					<td class="expTitle" width="65" align="center">�Ǘ���</td>
					<td class="expTitle" width="65" align="center">��ʃ��[�U�[</td>
					<td class="expTitle" width="65" align="center">�Q�X�g</td>
				</tr>
				<tr>
					<td class="expTitle">���[�U�[�A�O���[�v�̍쐬</td>
					<td class="expDataCell">��</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">�O���[�v�̌����ݒ�</td>
					<td class="expDataCell">��</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">���ʃ��|�[�g�A���ʃt�H���_�̍쐬</td>
					<td class="expDataCell">��</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">���ʃ��|�[�g�̎Q��</td>
					<td class="expDataCell">��</td>
					<td class="expDataCell">��</td>
					<td class="expDataCell">��</td>
				</tr>
				<tr>
					<td class="expTitle">�l���|�[�g�A�l�t�H���_�̍쐬</td>
					<td class="expDataCell"></td>
					<td class="expDataCell">��</td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">�O���[�v�ւ̏���</td>
					<td class="expDataCell"></td>
					<td class="expDataCell">��</td>
					<td class="expDataCell">��</td>
				</tr>
			</table>
		</li>
	</li>
	<li class="item">�O���[�v
		<li class="exp">�O���[�v�ɂ̓��|�[�g�̎Q�ƌ�����G�N�X�|�[�g������ݒ肷�邱�Ƃ��ł��A���[�U�[���O���[�v�ɏ��������āA�ꌳ�Ǘ����܂��B
</li>
	</li>
</ul>


</form>
</body>

