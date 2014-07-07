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

	// レポート情報変換用XMLのパス
	var loadXMLPath = "./spread/spread.xsl";

	// 初期化関数
	var objXSL = new ActiveXObject("MSXML2.DOMDocument");
	 
	// 初期設定
	objXSL.async = false;

	// XSLT文書のロード
	var xsltLoadResult = objXSL.load(loadXMLPath);

		// XSLT文書のロードに成功
		if (xsltLoadResult) {

			// XSLT変換
			var strResult = axesXMLData.transformNode(objXSL);

			// 変換結果で、HTMLを更新
			document.write(strResult);

		// XSLT文書のロードに失敗
		} else {
		
			// エラーメッセージを表示後、エラー画面を表示。
			showMessage("12", loadXMLPath);

			if(top.right_frm!=null) {
				top.right_frm.location.href="spread/error.jsp";
			} else {
				top.location.href="spread/error.jsp";
			}
		
		}

</script>
