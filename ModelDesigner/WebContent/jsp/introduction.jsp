<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../jsp/css/common.css">
	<link REL="stylesheet" TYPE="text/css" HREF="../jsp/css/explain.css">
	<script language="JavaScript" src="js/registration.js"></script>
	<script language="JavaScript" src="js/common.js"></script>
</head>

<body>
	<form name="form_main" id="form_main" method="post" action=""></form>
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">OpenOLAP Model Designerへようこそ</td>
			<td class="HeaderTitleRight"><a class="logout" onclick="logout()" onmouseover="this.style.cursor='hand'">ログアウト</a>
			<td>
		</tr>
	</table>
	<div class="content" id="text">
		<p>
			OpenOLAP Model DesignerはPostgreSQL上に多次元データベースを構築します。DBAや分析者が企業のデータウェアハウス構成を変更せずに、
			分析したいモデルの作成及び管理ができます。
			柔軟なモデリング機能や強力なセグメンテ－ション機能のようなテクノロジーの有効活用が可能になり、
			OLAP分析モデルのデザインと管理を急速に展開できます。
		</p>
		<p>
			OpenOLAP Model Designerの主な機能は以下のとおりです：<br>
			<ul>
				<li class="item">環境設定
					<li class="exp">データウェアハウスのスキーマを設定します。</li>
				</li>
				<li class="item">オブジェクト定義
					<li class="exp">				OpenOLAP Model Designerのメタデータを使い、データウェアハウスとキューブオブジェクト(ディメンション、メジャー)をマッピングします。 </li>
				</li>
				<li class="item">キューブモデリング</li>
					<li class="exp">
				カスタムディメンション、セグメントディメンション、カスタムメジャーのような柔軟な機能を使い、キューブの物理構成を定義します。 </li>
				</li>
				<li class="item">キューブマネージャー</li>
					<li class="exp">
						OpenOLAP Model Designerのメタデータを使い, キューブ内に物理キューブモデルを作成し、その管理を行います。
				キューブマネージャーはPostgreSQL内に論理的なキューブを作成し、データソースからデータを抽出して集計します。
				作成されたキューブはOpenOLAP Viewerで参照することができます。</li>
				</li>
		</p>
	</div>
</body>
</html>


