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
		<td class="HeaderTitleCenter">ユーザーとグループ</td>
		<td class="HeaderTitleRight">
			<a class="logout" href="#" onclick="logout_flow(this, '<%= request.getContextPath() %>');">ログアウト</a>
		</td>
	</tr>
</table>
<p>
ユーザーとグループでは、OpenOLAP Viewerを使用するユーザーやグループを作成することができます。
ユーザーおよびグループにはレポートの参照権限やエクスポート形式を個別に指定することができ、ユーザーをグループに所属させて一元管理することもできます。
</p>
<ul>
	<li class="item">ユーザー
		<li class="exp">ユーザーには、以下の3種類があります。
			<table style="border-collapse:collapse;margin-top:10px;">
				<tr>
					<td></td>
					<td class="expTitle" width="65" align="center">管理者</td>
					<td class="expTitle" width="65" align="center">一般ユーザー</td>
					<td class="expTitle" width="65" align="center">ゲスト</td>
				</tr>
				<tr>
					<td class="expTitle">ユーザー、グループの作成</td>
					<td class="expDataCell">○</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">グループの権限設定</td>
					<td class="expDataCell">○</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">共通レポート、共通フォルダの作成</td>
					<td class="expDataCell">○</td>
					<td class="expDataCell"></td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">共通レポートの参照</td>
					<td class="expDataCell">○</td>
					<td class="expDataCell">○</td>
					<td class="expDataCell">○</td>
				</tr>
				<tr>
					<td class="expTitle">個人レポート、個人フォルダの作成</td>
					<td class="expDataCell"></td>
					<td class="expDataCell">○</td>
					<td class="expDataCell"></td>
				</tr>
				<tr>
					<td class="expTitle">グループへの所属</td>
					<td class="expDataCell"></td>
					<td class="expDataCell">○</td>
					<td class="expDataCell">○</td>
				</tr>
			</table>
		</li>
	</li>
	<li class="item">グループ
		<li class="exp">グループにはレポートの参照権限やエクスポート権限を設定することができ、ユーザーをグループに所属させて、一元管理します。
</li>
	</li>
</ul>


</form>
</body>

