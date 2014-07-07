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
			<td class="HeaderTitleCenter">ディメンションのカスタマイズ</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">ログアウト</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			データウェアハウスの構成を全く変更せずに, “カスタムディメンション”や”セグメントディメンション”を作成することができます。

			<ul>
				<li style="list-style:none;">(1)カスタムディメンション
					<li class="exp">
						データウェアハウスの構成を全く変更せずに, カスタムディメンションを作成することができます。
		カスタムディメンションでは、カテゴリーの新規追加ができるだけでなく、
		メンバーを自由に別のレベルに移動でき、さらに既存のカテゴリーの名前も変更できます。 
					</li>
				</li>
				<li style="list-style:none">(2)セグメントディメンション
					 <li class="exp" style="">
		メンバーの属性値を使って、メンバーを指定した値でクラス分けできます。 
					</li>
				</li>
			</ul>
		</p>
	</div>

</body>
</html>
