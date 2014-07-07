<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title><%=(String)session.getValue("aplName")%></title>

		<script type="text/javascript" src="./spread/js/spreadFunc.js"></script>

	</HEAD>

	<BODY onLoad="initialize();">
		<FORM name='form_main' method="POST">
		</FORM>
	</BODY>

</HTML>


<script language="JavaScript">

	var axesXMLData = null;

	// �������֐�
	function initialize() {

		// ���|�[�g���XML�̃p�X
		var loadXMLPath = "Controller?action=getReportInfo";

		// �I�u�W�F�N�g����
		axesXMLData = new ActiveXObject("MSXML2.DOMDocument");
		 
		// �����ݒ�
		axesXMLData.async = false;
		axesXMLData.setProperty("SelectionLanguage", "XPath");

		// Spread���iXML�j�̃��[�h
		var xmlLoadResult = axesXMLData.load(loadXMLPath);

		// Spread���iXML�j�����`��
		if (xmlLoadResult) {

			var isError = axesXMLData.selectSingleNode("//isError");
			if ((isError != null) && (isError.text == 1)) {
				showErrorPage(loadXMLPath);
			} else {

				// Spread�\���G���A�̍X�V
				document.form_main.action="Controller?action=renewHtmlAct";
				document.form_main.target="display_area";
				document.form_main.submit();

			}

		// Spread���iXML�j���񐮌`��
		} else {
			showErrorPage(loadXMLPath);
		}
	}

	function showErrorPage(loadXMLPath) {

		// �G���[���b�Z�[�W��\����A�G���[��ʂ�\���B
		showMessage("11", loadXMLPath);

		document.form_main.action="spread/error.jsp";
		document.form_main.target="right_frm";
		document.form_main.submit();

	}

</script>
