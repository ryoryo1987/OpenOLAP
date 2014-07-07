<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
		<script type="text/javascript" src="../js/registration.js"></script>
</head>
<body>
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter" id="HeaderTitleCenter">ROLAPレポート作成</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
</body>
</html>