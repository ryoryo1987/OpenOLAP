<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="css/common.css">
	<link REL="stylesheet" TYPE="text/css" HREF="css/explain.css">
	<script language="JavaScript" src="js/registration.js"></script>
	<script language="JavaScript" src="js/common.js"></script>
</head>

<body>
	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">�L���[�u�}�l�[�W���[</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">���O�A�E�g</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
		�L���[�u�}�l�[�W���[��PostgreSQL���ɉ��z�L���[�u���쐬���A
		�f�[�^�\�[�X����f�[�^�𒊏o���ďW�v���܂��B
		�쐬���ꂽ�L���[�u��OpenOLAP Viewer�ŎQ�Ƃ��邱�Ƃ��ł��܂��B
		
		<ul>
			<li class="item">SQL�`���[�j���O
				<li class="exp">
					�L���[�u���쐬���邽�߂�SQL���J�X�^�}�C�Y���āA
					�L���[�u�̍\���⃁�W���[�̏W�v���@��ύX�ł��܂��B
					�܂��ASQL�����J�X�^�}�C�Y���ăf�[�^�\�[�X����̃f�[�^���o���@��ύX�ł��܂��B
				</li>
			</li>
			<li class="item">�L���[�u�쐬
				<li class="exp">
					�L���[�u�쐬�A�폜���s���܂��B
				</li>
			</li>
		</ul>
		</p>
	</div>

</body>
</html>
