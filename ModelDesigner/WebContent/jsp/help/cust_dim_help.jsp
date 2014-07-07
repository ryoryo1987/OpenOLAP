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
			<td class="main" style="padding-left:10px;padding-right:10px;background-color:white;text-align:left;width:700">

<blockquote>

<h4 class="Heading3">
  <a name="279934"> </a>3.3.1 ディメンションをカスタマイズする
</h4>
<p class="Body">
  <a name="279935"> </a>仮想ディメンションを作成するためのパーツを登録します。マスターテーブルからロードされる集計順序をそのまま使用せずに加工したい場合、ディメンションのカスタマイズを行います。例えば「ソフトウェア」だけの売上金額合計を出したいが、マスターテーブルでは「ソフトウェア+その他」という分類で登録されている、というような場合です。そのままのディメンションでキューブを作成すると、「ソフトウェア」＋「その他」の売上金額を合計した値しか見ることができません。これを「ソフトウェア」と「その他」に分類し、「その他」に属するメンバーを新規に追加したメンバー「その他」に移します。このようにカスタマイズしたディメンションを使用すると、要望どおりの「ソフトウェア」だけの売上金額を加算したキューブを作成することができます。
</p>
<p class="Body">
  <a name="184040"> </a>この節では、ディメンションのメンバーを仮想的に追加、編集、分類するカスタマイズ方法をご説明します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim_sample.jpg" height="251" width="501" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="151897"> </a>オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］から、カスタマイズしたいディメンションを選択して、［ディメンションパーツ登録］画面を表示します。
  <li class="SmartList1" value="2"><a name="151904"> </a>［パーツ名]を入力します。［マスターテーブルと同期]については、後述します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim1.jpg" height="104" width="432" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="286454"> </a>項目名<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="286456"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="286458"> </a>パーツ名<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="286460"> </a>ディメンションのパーツ名を入力します。（最大桁数：30）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="347097"> </a>コメント<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="347099"> </a>ディメンションのパーツに対するコメントを入力します。（最大桁数：250）<br>
</div>
</td>
  </tr>
</table>



</span>
  <li class="SmartList1" value="3"><a name="159853"> </a>［作成］ボタンをクリックして、パーツ情報を保存します。作成したパーツがオブジェクトツリーに追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim_icon28.gif" height="135" width="202" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="161629"> </a>注記:   ディメンションが登録されると［標準］のパーツが用意されます。［標準］パーツや新規作成したパーツで、作成したディメンションのデータを視覚的に確認できます。［ディメンション登録/情報]画面で［合計値を追加する］のチェックをオンにしてディメンションを作成した場合、「合計」メンバーが追加されています。［標準］パーツでは、メンバーの追加、編集（名前の変更）、削除、切り取り／貼り付けなどは行えません。
  </dl>
  <li class="SmartList1" value="4"><a name="171303"> </a>作成したパーツを編集します。オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］－［（ディメンション名）］）から、新しく作成されたパーツを選択して、［ディメンションパーツ情報］画面を表示します。［標準]パーツと同じメンバーが表示されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim15.jpg" height="286" width="474" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="154559"> </a>仮想メンバーを追加するために、［ディメンションパーツ情報］画面の右エリアで右クリックし［追加］を選択して、サブ画面を表示します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim2.jpg" height="231" width="459" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="6"><a name="155400"> </a>メンバーをロングネーム、ショートネームに入力して、［OK］ボタンをクリックします。
  <li class="SmartList1" value="7"><a name="179531"> </a>同様に右クリックから［編集］メニューを選択して、名前を変更をすることができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim348.gif" height="154" width="450" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="224169"> </a>ディメンションの構成を変更するには、ドラッグ＆ドロップ、や右クリックメニューによる［削除］/［切り取り］/［貼り付け］選択、を行ってください。<br><br clear="all" /><table><tr><td><img src="../../images/help/3_CreateCube_1_time32.gif" height="294" width="773" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br>
  <dl>
    <dt class="Indented2"> <a name="224183"> </a>注記:   仮想メンバーは15レベルまで作成することができます。
  </dl>
  <li class="SmartList1" value="9"><a name="354747"> </a>マスターテーブルと同期を取るには、［マスターテーブルと同期］項目でマスターテーブルとの同期方法を設定できます。メンバーの編集を行ったので、［メンバー名の変更］に&quot;Off&quot;を選択します。［同期を取る］ボタンをクリックします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim694.gif" height="314" width="764" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="354817"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th colspan="2" rowspan="1"><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354790"> </a>項目名<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354794"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td colspan="1" rowspan="3"><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354796"> </a>マスターテーブルと<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354797"> </a>同期<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354799"> </a>メンバーの追加<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354801"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［On］<br></span>マスターテーブルに新しくメンバーが追加された場合、このパーツにもメンバーが追加されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354802"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［Off］<br></span>マスターテーブルに追加されたメンバーは、このパーツには追加されません。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354806"> </a>メンバーの削除<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354808"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［On］<br></span>マスターテーブルのメンバーが削除された場合、このパーツのメンバーも削除されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354809"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［Off］<br></span>マスターテーブルから削除されたメンバーは、このパーツからは削除されません。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354813"> </a>メンバー名の変更<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354815"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［On］<br></span>マスターテーブルのメンバーと同じ名前に変更されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="354816"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［Off］<br></span>マスターテーブルのメンバーの名前は反映されません。メンバー名の変更をした場合は、この設定にすることをお薦めします。<br>
</div>
</td>
  </tr>
</table>



</span>
    <dt class="Indented2"> <a name="280239"> </a>注記:   同期を取る
<p class="BodyRelative">
  <a name="280248"> </a>①［同期を取る］ボタンをクリックすると、［更新］ボタンをクリックしなくても、ディメンション構成は保存されます。<br>②［キューブ作成］でキューブを作成する時には、 ［同期を取る］ボタンをクリックしなくても［マスターテーブルと同期］の指定がキューブに反映されます。また、キューブ作成後に［ディメンションパーツ情報］ 画面を開いた場合、［マスターテーブルと同期］の指定が反映されています。
</p>
  </dl>
  <li class="SmartList1" value="10"><a name="166901"> </a>［更新］ボタンをクリックして、ディメンションパーツの情報を保存します。
  <li class="SmartList1" value="11"><a name="233181"> </a>オブジェクトツリーから更新したディメンションパーツを選択して、更新したパーツの［ディメンションパーツ情報］画面を表示します。名前の変更が反映されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim62.gif" height="359" width="673" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</ol>
<h4 class="Heading3">
  <a name="280287"> </a>3.3.2 カスタムディメンションを編集する
</h4>
<p class="Body">
  <a name="280342"> </a>作成したディメンションパーツを編集します。ただし、［標準]パーツは編集できません。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="280715"> </a>オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］－［（ディメンション名）］から削除したいパーツを選択して、［ディメンションパーツ情報］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_custom_dim_icon2.jpg" height="147" width="195" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="280724"> </a>項目を編集します。
  <li class="SmartList1" value="3"><a name="349447"> </a>［更新]ボタンをクリックして、ディメンションパーツの情報を保存します。
<p class="BodyRelative">
  <a name="349685"> </a>メモ:   ［キューブモデリング］－［ディメンションのカスタマイズ］－［ムディメンション］－［（スキーマ名）］－［（ディメンション名）］に名前の変更が反映されます。
</p>
</ol>
<h4 class="Heading3">
  <a name="349686"> </a>3.3.3 カスタムディメンションを削除する
</h4>
<p class="Body">
  <a name="167395"> </a>作成したディメンションのパーツを削除します。ただし、［標準］パーツは削除できません。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="167786"> </a>オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］－［（ディメンション名）］から削除したいパーツを選択して、［ディメンションパーツ情報］画面を表示します。
  <li class="SmartList1" value="2"><a name="167998"> </a>［削除］ボタンをクリックします。
  <dl>
    <dt class="Indented2"> <a name="249496"> </a>注記:   ［標準］パーツは削除できません。
    <dt class="Indented2"> <a name="359306"> </a>注記:   ディメンションがキューブにマッピングされており、［キューブ構成］画面の［選択オブジェクト］にパーツが指定されている場合は削除できません。
<p class="BodyRelative">
  <a name="249593"> </a>メモ:   ［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］－［（ディメンション名）］に削除が反映されます。削除したパーツのアイコンがツリーから削除されます。
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