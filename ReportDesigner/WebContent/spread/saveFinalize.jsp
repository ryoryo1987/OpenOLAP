<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
<script language="JavaScript">

	function init() {
		// セレクタの終了処理実行
		parent.parent.display_area.showMessage( "7" );

		<%
			if ( ( request.getAttribute("mode") != null ) && 
				 ( ((String)request.getAttribute("mode")).equals("saveNewReport") ) ){
		%>
			//	document.form_main.action = "./OpenOLAP.html";
				document.form_main.action = "./OpenOLAP.jsp";
				document.form_main.target = "_top";
				document.form_main.submit();
		<%
			}

			// 新規個人レポート作成の場合、作成完了で左側のツリーを更新させる
			Boolean isCreatingNewPersonalReport = (Boolean)request.getAttribute("isCreatingNewPersonalReport");
			if ( isCreatingNewPersonalReport != null ) {
				if( isCreatingNewPersonalReport.booleanValue() ) {
		%>
					document.form_main.target="navi_frm";
					document.form_main.action="./flow/objects.jsp";
					document.form_main.submit();
		<%	
				}
			}

		%>
//		parent.parent.display_area.setLoadingStatus(false);
	}

</script>
</HEAD>
<BODY onload="init();" style="background-color:#EFECE7;margin:0;padding:0;">
	<FORM name="form_main" method="POST" action="#">
	</FORM>
</BODY>
