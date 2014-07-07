<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="openolap.viewer.User"
%>
<%
	User user = (User) session.getAttribute("user");
	String spreadStyleFile = user.getSpreadStyleFile();
	String cellColorTableFile = user.getCellColorTableFile();
%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<TITLE>OpenOLAP</TITLE>
	<link rel="stylesheet" type="text/css" href="./css/common.css">
	<link rel="stylesheet" type="text/css" href="./css/dimList.css">
	<link rel="stylesheet" type="text/css" href="./css/<%= spreadStyleFile %>">
	<script type="text/javascript" src="./css/<%= cellColorTableFile %>"></script>
	<script type="text/javascript" src="./css/colorStyle.js"></script>
	<script type="text/javascript" src="./spread/js/spreadFunc.js"></script>
	<script type="text/javascript" src="./spread/js/spread.js"></script>
	<script type="text/javascript" src="./spread/js/colRange.js"></script>
	<script type="text/javascript" src="./spread/js/drill.js"></script>
	<script type="text/javascript" src="./spread/js/dice.js"></script>
	<script type="text/javascript" src="./spread/js/pageEdge.js"></script>
	<script type="text/javascript" src="./spread/js/toolBar.js"></script>
	<script type="text/javascript" src="./spread/js/cellColor.js"></script>
	<script type="text/javascript" src="./spread/js/chartMenu.js"></script>
	<style>
		html
		 {
			scrollbar-base-color:#F4F4FF;
		}
	</style>

</HEAD>
</HTML>

<script language="JavaScript">
	var axesXMLData = parent.info_area.axesXMLData;

	// ���|�[�g���ϊ��pXML�̃p�X
	var loadXMLPath = "./spread/spread.xsl";

	// �������֐�
	var objXSL = new ActiveXObject("MSXML2.DOMDocument");
	 
	// �����ݒ�
	objXSL.async = false;

	// XSLT�����̃��[�h
	var xsltLoadResult = objXSL.load(loadXMLPath);

		// XSLT�����̃��[�h�ɐ���
		if (xsltLoadResult) {

			// XSLT�ϊ�
			var strResult = axesXMLData.transformNode(objXSL);

			// �ϊ����ʂŁAHTML���X�V
			document.write(strResult);

		// XSLT�����̃��[�h�Ɏ��s
		} else {
		
			// �G���[���b�Z�[�W��\����A�G���[��ʂ�\���B
			showMessage("12", loadXMLPath);

			if(top.right_frm!=null) {
				top.right_frm.location.href="spread/error.jsp";
			} else {
				top.location.href="spread/error.jsp";
			}
		
		}

</script>
