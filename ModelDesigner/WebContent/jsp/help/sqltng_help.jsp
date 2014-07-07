<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>


<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<link rel="stylesheet" type="text/css" href="../css/help.css">
</head>
<body bgcolor="#B8CCEF">


	<div class="main" id="dv_main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left" style="background-color:white"></td>
			<td class="main" style="padding-left:10px;padding-right:10px;background-color:white;text-align:left">

<blockquote>

<h3 class="Heading2">
  <a name="155596"> </a>4.1 SQL文を変更する
</h3>
<p class="Body">
  <a name="117474"> </a>キューブモデリングの［キューブ構成］画面でキューブ情報を設定すると、OpenOLAP Model Designerはデータ抽出するためのSQL文を自動的に生成します。
</p>
<p class="Body">
  <a name="141735"> </a>この自動生成されたSQL文をカスタマイズすることで、集計時間の高速化や複雑なメジャーの条件指定などを行うことが可能となります。 <br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning1.jpg" height="374" width="483" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="139863"> </a>［キューブマネージャー］－［SQLチューニング］－［（キューブ名）］から変更したいSQL文のステップを選択して、［SQLチューニング］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning_icon.jpg" height="139" width="195" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
<p class="BodyRelative">
  <a name="143903"> </a>メモ:   SQLステップの処理内容

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146256"> </a>ステップ名<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146258"> </a>処理内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146260"> </a>キューブ定義<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146262"> </a>キューブ生成の定義をします。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146264"> </a>データロード<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146266"> </a>データマートからメタデータへデータをロードします。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146268"> </a>集計<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="146270"> </a>メタデータのデータを集計します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="156426"> </a>カスタムメジャー<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="156428"> </a>カスタムメジャーの処理を行います。<br>
</div>
</td>
  </tr>
</table>




</p>
  <dl>
    <dt class="Indented2"> <a name="145017"> </a>注記:   キューブ名アイコンをクリックして表示される［SQLチューニング］画面はすべてのOpenOLAP Model Designerが生成するSQL文の確認ができますが、SQL文をカスタマイズすることはできません。カスタマイズするには、必ず変更したいステップのアイコンをクリックしてください。、<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning25.gif" height="327" width="593" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  </dl>
  <li class="SmartList1" value="2"><a name="139867"> </a>［カスタマイズ］のチェックをオンにして、上段に表示されているデフォルトのスクリプトを下段へコピーします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning42.gif" height="346" width="595" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="142790"> </a>注記:   上段のスクリプトに対してカスタマイズはできません。
  </dl>
  <li class="SmartList1" value="3"><a name="117483"> </a>下段に表示されたスクリプトをカスタマイズします。下段に文字を入力すると背景がピンク色に変わり、スクリプトがカスタマイズされていることがわかるようになっています。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/4_tuning33.gif" height="356" width="627" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="117485"> </a>［保存］ボタンをクリックして、SQL文を保存します。
<p class="BodyRelative">
  <a name="117779"> </a>メモ:   変更したスクリプトを標準に戻したいときは、［カスタマイズ］のチェックをオフにします。
</p>
  <dl>
    <dt class="Indented2"> <a name="155066"> </a>注記:   スクリプトをカスタマイズした場合、［カスタマイズ］チェックをオフにして標準に戻すまで、カスタマイズしたスクリプトが優先されます。スクリプトのカスタマイズ後に、ディメンション、メジャーの追加や修正を行った場合は、［カスタマイズ］のチェックをオフにしてスクリプトを標準に戻し、変更の結果を反映させてください。その後、必要に応じてスクリプトをカスタマイズしてください。変更結果が反映されないまま［キューブ作成］画面でキューブを作成すると、エラーの原因となります。
  </dl>
</ol>
<p class="Body">
  <a name="143527"> </a>
</p>

</blockquote>

			</td>
			<td class="right" style="background-color:white"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>

</body>
</html>