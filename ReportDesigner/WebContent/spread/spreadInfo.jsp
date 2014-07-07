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

	// 初期化関数
	function initialize() {

		// レポート情報XMLのパス
		var loadXMLPath = "Controller?action=getReportInfo";

		// オブジェクト生成
		axesXMLData = new ActiveXObject("MSXML2.DOMDocument");
		 
		// 初期設定
		axesXMLData.async = false;
		axesXMLData.setProperty("SelectionLanguage", "XPath");

		// Spread情報（XML）のロード
		var xmlLoadResult = axesXMLData.load(loadXMLPath);

		// Spread情報（XML）が整形式
		if (xmlLoadResult) {

			var isError = axesXMLData.selectSingleNode("//isError");
			if ((isError != null) && (isError.text == 1)) {
				showErrorPage(loadXMLPath);
			} else {

				// Spread表示エリアの更新
				document.form_main.action="Controller?action=renewHtmlAct";
				document.form_main.target="display_area";
				document.form_main.submit();

			}

		// Spread情報（XML）が非整形式
		} else {
			showErrorPage(loadXMLPath);
		}
	}

	function showErrorPage(loadXMLPath) {

		// エラーメッセージを表示後、エラー画面を表示。
		showMessage("11", loadXMLPath);

		document.form_main.action="spread/error.jsp";
		document.form_main.target="right_frm";
		document.form_main.submit();

	}

</script>
