<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../jsp/css/common.css">
	<link REL="stylesheet" TYPE="text/css" HREF="../jsp/css/explain.css">
	<script language="JavaScript" src="js/registration.js"></script>
	<script language="JavaScript" src="js/common.js"></script>
</head>

<body>
	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">OpenOLAP Model Designer�ւ悤����</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">���O�A�E�g</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			OpenOLAP Model Designer��PostgreSQL��ɑ������f�[�^�x�[�X���\�z���܂��BDBA�╪�͎҂���Ƃ̃f�[�^�E�F�A�n�E�X�\����ύX�����ɁA
			���͂��������f���̍쐬�y�ъǗ����ł��܂��B
			�_��ȃ��f�����O�@�\�⋭�͂ȃZ�O�����e�|�V�����@�\�̂悤�ȃe�N�m���W�[�̗L�����p���\�ɂȂ�A
			OLAP���̓��f���̃f�U�C���ƊǗ����}���ɓW�J�ł��܂��B
		</p>
		<p>
			OpenOLAP Model Designer�̎�ȋ@�\�͈ȉ��̂Ƃ���ł��F<br>
			<ul>
				<li class="item">���ݒ�
					<li class="exp">�f�[�^�E�F�A�n�E�X�̃X�L�[�}��ݒ肵�܂��B</li>
				</li>
				<li class="item">�I�u�W�F�N�g��`
					<li class="exp">				OpenOLAP Model Designer�̃��^�f�[�^���g���A�f�[�^�E�F�A�n�E�X�ƃL���[�u�I�u�W�F�N�g(�f�B�����V�����A���W���[)���}�b�s���O���܂��B </li>
				</li>
				<li class="item">�L���[�u���f�����O</li>
					<li class="exp">
				�J�X�^���f�B�����V�����A�Z�O�����g�f�B�����V�����A�J�X�^�����W���[�̂悤�ȏ_��ȋ@�\���g���A�L���[�u�̕����\�����`���܂��B </li>
				</li>
				<li class="item">�L���[�u�}�l�[�W���[</li>
					<li class="exp">
						OpenOLAP Model Designer�̃��^�f�[�^���g��, �L���[�u���ɕ����L���[�u���f�����쐬���A���̊Ǘ����s���܂��B
				�L���[�u�}�l�[�W���[��PostgreSQL���ɘ_���I�ȃL���[�u���쐬���A�f�[�^�\�[�X����f�[�^�𒊏o���ďW�v���܂��B
				�쐬���ꂽ�L���[�u��OpenOLAP Viewer�ŎQ�Ƃ��邱�Ƃ��ł��܂��B</li>
				</li>
		</p>
	</div>
</body>
</html>


