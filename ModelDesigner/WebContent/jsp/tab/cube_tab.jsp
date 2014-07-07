<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));
%>
<html>

<head>
<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js" ></script>
	<script language="JavaScript" src="../js/common.js" ></script>
	<link REL="stylesheet" TYPE="text/css" HREF="../css/common.css">
</head>

<body>


	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">
				<%if(objSeq==0){%>
					キューブ登録
				<% } else { %>
					キューブ情報
				<% } %>
			</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout('tab')" onmouseover="this.style.cursor='hand'">ログアウト</a>
			</td>
		</tr>
	</table>
</body>
</html>