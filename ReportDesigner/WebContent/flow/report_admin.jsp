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
		<td class="HeaderTitleCenter">レポート管理</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
<p>
レポートを管理します。
</p>
<ul>
	<li class="item">レポートの新規作成
		<li class="exp">レポートを新規に作成することができます。
		</li>
	</li>
	<li class="item">フォルダ・レポート管理
		<li class="exp">レポート検索を効率的にするフォルダを作成したり、レポートをフォルダに割り当てなおすなど、エクスプローラ風の操作でフォルダとレポートを管理することができます。


</li>
	</li>
</ul>


</form>
</body>

