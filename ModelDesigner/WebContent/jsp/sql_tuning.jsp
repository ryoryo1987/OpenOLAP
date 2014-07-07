<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="css/common.css">
	<link REL="stylesheet" TYPE="text/css" HREF="css/explain.css">
	<script language="JavaScript" src="js/registration.js"></script>
	<script language="JavaScript" src="js/common.js"></script>
</head>

<body>


	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">SQLチューニング</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">ログアウト</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			キューブを作成するためのSQLをカスタマイズして、
			キューブの構成やメジャーの集計方法を変更できます。
			また、SQL文をカスタマイズしてデータソースからのデータ抽出方法を変更できます。
		</p>
	</div>

</body>
</html>
