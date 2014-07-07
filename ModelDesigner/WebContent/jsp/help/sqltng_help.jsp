<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>


<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<link rel="stylesheet" type="text/css" href="../css/help.css">
</head>
<body bgcolor="#B8CCEF">


	<div class="main" id="dv_main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left" style="background-color:white"></td>
			<td class="main" style="padding-left:10px;padding-right:10px;background-color:white;text-align:left">

<blockquote>

<h3 class="Heading2">
  <a name="155596"> </a>4.1 SQL����ύX����
</h3>
<p class="Body">
  <a name="117474"> </a>�L���[�u���f�����O�́m�L���[�u�\���n��ʂŃL���[�u����ݒ肷��ƁAOpenOLAP Model Designer�̓f�[�^���o���邽�߂�SQL���������I�ɐ������܂��B
</p>
<p class="Body">
  <a name="141735"> </a>���̎����������ꂽSQL�����J�X�^�}�C�Y���邱�ƂŁA�W�v���Ԃ̍������╡�G�ȃ��W���[�̏����w��Ȃǂ��s�����Ƃ��\�ƂȂ�܂��B <br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning1.jpg" height="374" width="483" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="139863"> </a>�m�L���[�u�}�l�[�W���[�n�|�mSQL�`���[�j���O�n�|�m�i�L���[�u���j�n����ύX������SQL���̃X�e�b�v��I�����āA�mSQL�`���[�j���O�n��ʂ�\�����܂��B<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning_icon.jpg" height="139" width="195" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
<p class="BodyRelative">
  <a name="143903"> </a>����:   SQL�X�e�b�v�̏������e

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146256"> </a>�X�e�b�v��<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146258"> </a>�������e<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146260"> </a>�L���[�u��`<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146262"> </a>�L���[�u�����̒�`�����܂��B<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146264"> </a>�f�[�^���[�h<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146266"> </a>�f�[�^�}�[�g���烁�^�f�[�^�փf�[�^�����[�h���܂��B<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146268"> </a>�W�v<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146270"> </a>���^�f�[�^�̃f�[�^���W�v���܂��B<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="156426"> </a>�J�X�^�����W���[<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="156428"> </a>�J�X�^�����W���[�̏������s���܂��B<br>
</div>
</td>
  </tr>
</table>




</p>
  <dl>
    <dt class="Indented2"> <a name="145017"> </a>���L:   �L���[�u���A�C�R�����N���b�N���ĕ\�������mSQL�`���[�j���O�n��ʂ͂��ׂĂ�OpenOLAP Model Designer����������SQL���̊m�F���ł��܂����ASQL�����J�X�^�}�C�Y���邱�Ƃ͂ł��܂���B�J�X�^�}�C�Y����ɂ́A�K���ύX�������X�e�b�v�̃A�C�R�����N���b�N���Ă��������B�A<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning25.gif" height="327" width="593" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  </dl>
  <li class="SmartList1" value="2"><a name="139867"> </a>�m�J�X�^�}�C�Y�n�̃`�F�b�N���I���ɂ��āA��i�ɕ\������Ă���f�t�H���g�̃X�N���v�g�����i�փR�s�[���܂��B<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning42.gif" height="346" width="595" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="142790"> </a>���L:   ��i�̃X�N���v�g�ɑ΂��ăJ�X�^�}�C�Y�͂ł��܂���B
  </dl>
  <li class="SmartList1" value="3"><a name="117483"> </a>���i�ɕ\�����ꂽ�X�N���v�g���J�X�^�}�C�Y���܂��B���i�ɕ�������͂���Ɣw�i���s���N�F�ɕς��A�X�N���v�g���J�X�^�}�C�Y����Ă��邱�Ƃ��킩��悤�ɂȂ��Ă��܂��B<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning33.gif" height="356" width="627" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="117485"> </a>�m�ۑ��n�{�^�����N���b�N���āASQL����ۑ����܂��B
<p class="BodyRelative">
  <a name="117779"> </a>����:   �ύX�����X�N���v�g��W���ɖ߂������Ƃ��́A�m�J�X�^�}�C�Y�n�̃`�F�b�N���I�t�ɂ��܂��B
</p>
  <dl>
    <dt class="Indented2"> <a name="155066"> </a>���L:   �X�N���v�g���J�X�^�}�C�Y�����ꍇ�A�m�J�X�^�}�C�Y�n�`�F�b�N���I�t�ɂ��ĕW���ɖ߂��܂ŁA�J�X�^�}�C�Y�����X�N���v�g���D�悳��܂��B�X�N���v�g�̃J�X�^�}�C�Y��ɁA�f�B�����V�����A���W���[�̒ǉ���C�����s�����ꍇ�́A�m�J�X�^�}�C�Y�n�̃`�F�b�N���I�t�ɂ��ăX�N���v�g��W���ɖ߂��A�ύX�̌��ʂ𔽉f�����Ă��������B���̌�A�K�v�ɉ����ăX�N���v�g���J�X�^�}�C�Y���Ă��������B�ύX���ʂ����f����Ȃ��܂܁m�L���[�u�쐬�n��ʂŃL���[�u���쐬����ƁA�G���[�̌����ƂȂ�܂��B
  </dl>
</ol>
<p class="Body">
  <a name="143527"> </a>
</p>

</blockquote>

			</td>
			<td class="right" style="background-color:white"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>

</body>
</html>