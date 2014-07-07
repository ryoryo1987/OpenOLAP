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
		<td class="HeaderTitleCenter" style="filter:Blur(strength=0)"><%=(String)session.getValue("aplName")%>へようこそ</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>

	</tr>
</table>

<p>
<%=(String)session.getValue("aplName")%>はOpenOLAP Model Designerで生成されたキューブを対象とした強力なレポーティングツールです。 <br>
<%=(String)session.getValue("aplName")%>はビジネスインテリジェンスを導き出すまでの過程である
多次元データ分析を、直感的で使いやすくし、分析作業を強力にサポートします。
</p>
</form>
</body>

