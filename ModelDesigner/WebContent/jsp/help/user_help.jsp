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
  <a name="155801"> </a>2.1 スキーマを登録する
</h3>
<ol type="1">
  <li class="SmartList1" value="1"><a name="150133"> </a>オブジェクトツリーの［環境設定］－［スキーマ］を選択して［スキーマ登録］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/2_schema_null.jpg" height="48" width="118" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="150138"> </a>以下の情報を入力します。<br><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline"><br clear="all" /><table align="center"><tr><td><img src="../../images/help/2_schema.jpg" height="109" width="501" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150141"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150143"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150145"> </a>スキーマ名<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150147"> </a>データソースが格納されているスキーマ名を入力します。(最大桁数：30)<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150153"> </a>コメント<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="166283"> </a>スキーマに対するコメントを入力します。(最大桁数：250)<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150157"> </a>使用可能なソース<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150159"> </a>ディメンションやメジャーを作成するときに使用する分析データのPostgreSQL上のオブジェクト種類を以下から選択します（複数可能）。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150160"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［テーブル］<br></span><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">スキーマ上のテーブルを使用できます。</span><br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150161"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［ビュー］<br></span><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">スキーマ上のビューを使用できます。</span><br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150163"> </a>ここでオブジェクト種類を選択すると、［ディメンション登録/情報］画面、［セグメントディメンション登録/情報］画面、［メジャー登録/情報］画面で使用可能テーブルが表示されるようになります。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="150164"> </a>（例）テーブルとビューにチェック<br>［ディメンション登録/情報］画面のレベルの［テーブル］リストボックスにテーブル名とビュー名がリストされる。<br>
</div>
</td>
  </tr>
</table>



</span>
  <li class="SmartList1" value="3"><a name="155941"> </a>［作成］ボタンをクリックして、スキーマ情報を保存します。
<p class="BodyRelative">
  <a name="160180"> </a>メモ:   アイコン追加
</p>
<p class="BodyRelative">
  <a name="160233"> </a>①［環境設定］－［スキーマ］に作成したスキーマのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/2_schema_createdicon3.gif" height="80" width="157" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="160264"> </a>②［オブジェクト定義］－［ディメンション］、［オブジェクト定義］－［セグメントディメンション］、［オブジェクト定義］－［メジャー］、［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］、［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］に、作成したスキーマのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/2_schema_create2icon5.gif" height="417" width="258" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
</ol>
<h3 class="Heading2">
  <a name="126670"> </a>2.2 スキーマを編集する
</h3>
<ol type="1">
  <li class="SmartList1" value="1"><a name="117372"> </a>オブジェクトツリーの［環境設定］－ ［スキーマ］から編集したいスキーマを選択して、［スキーマ情報］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/2_schema_editicon.jpg" height="63" width="115" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="117373"> </a>項目を編集します。
  <dl>
    <dt class="Indented2"> <a name="165013"> </a>注記:   ［スキーマID］は編集できません。
  </dl>
  <li class="SmartList1" value="3"><a name="146537"> </a>［更新］ボタンをクリックして、スキーマ情報を保存します。
  <dl>
    <dt class="Indented2"> <a name="146538"> </a>注記:   ［スキーマ名］の変更について
<p class="BodyRelative">
  <a name="146539"> </a>［スキーマ名］を変更して、既に作成しているディメンションやメジャーなどのオブジェクトを他のスキーマへ移行させたい場合、<span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">変更前と変更後のスキーマで同じオブジェクト（テーブル/ビュー）が参照可能になっていること</span>を確認してください。<br>同じオブジェクトが参照可能になっていないと、［ディメンション情報］画面、［セグメントディメンション情報］画面、［メジャー情報］画面の［テーブル］やその他関連する項目が正しく表示されません。この場合、変更後のスキーマに対して、変更前のスキーマと同じオブジェクトにアクセスできるよう設定を変更するか、変更前の［スキーマ名］に戻して、ディメンション情報やメジャー情報が正しく表示されるようにしてください。
</p>
  </dl>
</ol>
<h3 class="Heading2">
  <a name="117370"> </a>2.3 スキーマを削除する
</h3>
<ol type="1">
  <li class="SmartList1" value="1"><a name="117532"> </a>オブジェクトツリーの［環境設定］－ ［スキーマ］から削除したいスキーマを選択して、［スキーマ情報］画面を表示します。
  <li class="SmartList1" value="2"><a name="117533"> </a>［削除］ボタンをクリックして、スキーマ情報をメタデータから削除します。削除後、画面は［スキーマ登録］画面へ切り替わります。
  <dl>
    <dt class="Indented2"> <a name="117769"> </a>注記:   以下の状況の場合、スキーマ情報を削除することはできません。すべてを削除してから、スキーマを削除するようにしてください。<br><br>・ディメンションが作成されている<br>・セグメントディメンションが作成されている
<p class="BodyRelative">
  <a name="167538"> </a>メモ:   削除したスキーマのアイコンがツリーから削除されます。
</p>
  </dl>
</ol>
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