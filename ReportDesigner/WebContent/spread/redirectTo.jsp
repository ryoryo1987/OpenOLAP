<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
%>
<%
	String redirectTo = (String)request.getAttribute("redirectTo");
	String targetFrame = (String)request.getAttribute("targetFrame");

	String errorMessage = "";
	if (request.getAttribute("errorMessage") != null) {
		errorMessage = "?errorMessage=" + ((String) request.getAttribute("errorMessage"));
	}

	String backButtonDisableFLG = (String) request.getAttribute("backButtonDisableFLG");
	if ("1".equals(backButtonDisableFLG)) {
		if ("".equals(errorMessage)) {
			errorMessage += "?backButtonDisableFLG=1";
		} else {
			errorMessage += "&backButtonDisableFLG=1";
		}
	}
		// Rレポート用のXML作成でエラーが発生した場合、自フレームを強制的にリダイレクト対象とする
		if ("1".equals(backButtonDisableFLG) ) {
			targetFrame = "SELF";
		}


	String URL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + redirectTo + errorMessage;

%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
</HEAD>

<BODY onload="redirect();">
</BODY>
</HTML>

<script language="JavaScript">

	function redirect() {
<%
		// ウインドウの最上位のフレームをリダイレクトする
		if ("TOP".equals(targetFrame)){
			out.println("top.location.href=\"" + URL +"\";");

		// Spread表示部（ウインドウの右側エリア）をリダイレクトする
		} else if ("VIEW".equals(targetFrame)) {
%>
			if(top.right_frm!=null) {
				top.right_frm.location.href="<%=URL%>";
			} else {
				top.location.href="<%=URL%>";
			}
<%
		// 自分のフレームをリダイレクトする
		} else if ("SELF".equals(targetFrame)) {
			out.println("location.replace(\"" + URL +"\");");
		}
%>
	}

</script>
