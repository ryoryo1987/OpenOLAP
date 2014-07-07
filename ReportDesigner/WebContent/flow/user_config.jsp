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
		<td class="HeaderTitleCenter">ユーザー設定</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
<p>
ユーザーのパスワード、エクスポート形式を変更します。</p>
<ul>
	<li class="item">パスワード変更
		<li class="exp">ユーザーのパスワードを変更します。
		</li>
	</li>
	<li class="item">エクスポート形式
		<li class="exp">レポートのエクスポート形式をCSVまたはXML Spreadsheet形式のいずれかに設定します。
</li>
	</li>
</ul>


</form>
</body>

