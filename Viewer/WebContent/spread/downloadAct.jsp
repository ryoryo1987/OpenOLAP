<%@ page language="java"
	contentType="text/html;charset=Shift_JIS"
	import="java.util.*,java.io.*"
%>
	<HTML>
		<HEAD>
			<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
			<title><%=(String)session.getValue("aplName")%></title>
		</HEAD>

		<BODY onload="initialize()"; style="background-color:#EFECE7;margin:0;padding:0;">
			<FORM name='form_main' method="post">

			</FORM>
		</BODY>
	
	</HTML>

	<script language="JavaScript">
		function initialize() {
			window.open('<%= (String)request.getAttribute("downloadURL") %>','_blank');
//			parent.parent.display_area.setLoadingStatus(false);
		}
	</script>

