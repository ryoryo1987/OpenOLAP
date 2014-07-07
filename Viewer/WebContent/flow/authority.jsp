<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" href="../css/common.css" type="text/css">
	<script type="text/javascript" src="../spread/js/spreadFunc.js"></script>

</head>
<body class="topPage">
<form>
<!-- ページヘッダー -->
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">権限設定</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
<p>
OpenOLAP Viewerのグループに対して、レポートごとに以下の設定をすることができます。
</p>
<ul>
	<li class="item">レポート参照権限
	</li>
	<li class="item">エクスポート権限
	</li>
</ul>


</form>
</body>

