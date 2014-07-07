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
			<td class="HeaderTitleCenter">オブジェクト定義</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">ログアウト</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			OpenOLAPのメタデータを使い、データウェアハウスとキューブオブジェクト(ディメンション、メジャー)をマッピングします。
			<ul>
				<li class="item">ディメンション
					<li class="exp">
					データウェアハウス内のマスターテーブルをマッピングして、ディメンションをキューブオブジェクトとして定義します。
					</li>
				</li>
				<li class="item">メジャー
					<li class="exp">
						データウェアハウス内のファクトテーブルをマッピングして、メジャーをキューブオブジェクトとして定義します。
					</li>
				</li>
			</ul>
		</p>
	</div>
</body>
</html>
