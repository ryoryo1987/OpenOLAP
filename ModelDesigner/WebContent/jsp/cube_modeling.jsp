<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<LINK REL="stylesheet" TYPE="text/css" HREF="css/common.css">
	<LINK REL="stylesheet" TYPE="text/css" HREF="css/explain.css">
	<script language="JavaScript" src="js/registration.js"></script>
	<script language="JavaScript" src="js/common.js"></script>
</head>

<body>
	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">キューブモデリング</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">ログアウト</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			カスタムディメンション、セグメントセグメントディメンション、カスタムメジャーのような柔軟な機能を使い、キューブの物理構成を定義します。

	<ul>
		<li class="item">カスタムメジャー
			<li class="exp">
			カスタムメジャーとは、メジャー×メジャー、メジャー×係数など、任意の計算式を作成したメジャーのことです。「フォーミュラ」と呼ばれる場合もあります。ユーザー独自の計算式を使ってカスタムメジャーを定義できます。
			</li>
		</li>
		<li class="item">ディメンションのカスタマイズ 
			<li class="exp">
			データウェアハウスの構成を全く変更せずに, “カスタムディメンション”や”セグメントディメンション”を作成することができます。
			</li> 
			<li style="list-style:none;margin-left:2em">(1)カスタムディメンション
				<li class="exp" style="margin-left:4.5em">
					データウェアハウスの構成を全く変更せずに, カスタムディメンションを作成することができます。
	カスタムディメンションでは、カテゴリーの新規追加ができるだけでなく、
	メンバーを自由に別のレベルに移動でき、さらに既存のカテゴリーの名前も変更できます。 
				</li>
			</li>
			<li style="list-style:none;margin-left:2em">(2)セグメントディメンション
				 <li class="exp" style="margin-left:4.5em">
	メンバーの属性値を使って、メンバーを指定した値でクラス分けできます。 
				</li>
			</li>
		</li>
	</ul>
		</p>
	</div>

</body>
</html>
