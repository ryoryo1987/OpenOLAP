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

<h5 class="Heading4">
  <a name="326143"> </a>3.2.2.2 パーツを新規に登録する
</h5>
<p class="Body">
  <a name="276930"> </a>新規にセグメントディメンションのパーツを作成します。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="288607"> </a>オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］からカスタマイズしたいセグメントディメンションを選択して、［セグメントディメンション登録］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_parts1.jpg" height="147" width="198" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="288623"> </a>以下の情報を入力してください。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_parts2.jpg" height="47" width="497" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="288616"> </a>項目名<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="288618"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="288620"> </a>パーツ名<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="288622"> </a>セグメントディメンションのパーツ名を入力します。（最大桁数：30）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="325683"> </a>コメント<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="325685"> </a>セグメントディメンションのパーツに対するコメントを入力します。(最大桁数：250)<br>
</div>
</td>
  </tr>
</table>




  <li class="SmartList1" value="3"><a name="276946"> </a>［作成］ボタンをクリックして、セグメントディメンションの情報を保存します。
  <dl>
    <dt class="Indented2"> <a name="276953"> </a>注記:   ［標準］パーツの下に、作成したパーツのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_parts344.gif" height="205" width="286" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  </dl>
</ol>
<h5 class="Heading4">
  <a name="178558"> </a>3.2.2.3 ディメンションから作成するセグメントディメンション
</h5>
<p class="Body">
  <a name="272379"> </a>商品を値段によって分類します。商品の合計値を格納する&quot;合計値&quot;メンバーを作成し、その中に価格を分類するための0円～1,000円未満の&quot;低価格&quot;のメンバー、1,000円～2,000円未満の&quot;中価格&quot;のメンバー、2,000～3,000円未満の&quot;高価格&quot;のメンバーを作成します。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="151552"> </a>オブジェクトツリーの［オブジェクト定義］－［セグメントディメンション］－［（スキーマ名）]を選択して、［セグメントディメンション登録］画面を表示します。
  <li class="SmartList1" value="2"><a name="340434"> </a><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg139.gif" height="97" width="571" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">［合計値］チェックボックスにチェックします。
  <li class="SmartList1" value="3"><a name="220716"> </a>［セグメント］ボックスをクリックして、［テーブル］に&quot;product&quot;、［キーカラム］に&quot;price&quot;を選択します。［データタイプ］は&quot;数値&quot;を選択します。［「その他」メンバーの作成］のチェックをはずします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg24.gif" height="263" width="585" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="247151"> </a>［レベル作成］ボタンをクリックして新しい［レベル]ボックスを表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim1.jpg" height="105" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="247155"> </a>［レベル］ボックスをクリックして、［テーブル］には&quot;product&quot;、［キーカラム］には&quot;prod_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim2.jpg" height="172" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="6"><a name="340630"> </a>セグメントレベルのレベル名をクリックし、レベル2のレベル名にドラッグします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg4.jpg" height="105" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="7"><a name="340635"> </a>セグメントレベルとレベル2のリンクラインをクリックして、［レベル2リンクカラム］を設定します。セグメントレベルのキーカラムである&quot;price&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg575.gif" height="273" width="535" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="248608"> </a>［作成］ボタンをクリックして、セグメントディメンション情報を保存します。
  <li class="SmartList1" value="9"><a name="306263"> </a>セグメントディメンションをカスタマイズします。オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］－［（ディメンション名）］－［標準］パーツを選択して、［セグメントディメンションパーツ情報］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim3.jpg" height="182" width="481" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="301166"> </a>注記:   ［標準］の場合、パーツ名は変更できません。
  </dl>
  <li class="SmartList1" value="10"><a name="256368"> </a>仮想メンバーを追加するために、［セグメントディメンションパーツ情報］画面の右エリアで右クリック－［追加］を選択して、［セグメントディメンション]サブ画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim431.gif" height="219" width="763" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br><br>以下の項目を入力して、［OK］ボタンをクリックします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim5.gif" height="306" width="665" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274360"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274362"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274364"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ロングネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274366"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">追加するメンバーのロングネームを入力します。（最大桁数：30）</span><br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274527"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ショートネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274529"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">追加するメンバーのショートネームを入力します。（最大桁数：30）</span><br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274368"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">最小値</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274370"> </a>［セグメントディメンション登録/情報］画面の［データタイプ］で［数値］を選択した場合に表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="330984"> </a>分類したい値の最小値を数値で入力します。（最大桁数：30）<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="356001"> </a>入力された値以上のメンバーが含まれます。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274372"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">最大値</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="330987"> </a>［セグメントディメンション登録/情報］画面の［データタイプ］で［数値］を選択した場合に表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="274374"> </a>分類したい値の最大値を数値で入力します。（最大桁数：30）<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="356076"> </a>入力された値未満のメンバーが含まれます。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="330995"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">LIKE</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="331011"> </a>［セグメントディメンション登録/情報］画面の［データタイプ］で［文字列］を選択した場合に表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="330997"> </a>分類したい値を絞り込む文字列を入力します。（最大桁数：30）<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="356148"> </a>ワイルドカードとして「*（複数文字列に対応）」、「_（１文字に対応）」を使用することができます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="331407"> </a>例）　Aから始まる文字列を分類したい　→　「A*」と入力<br>
</div>
</td>
  </tr>
</table>




<p class="BodyRelative">
  <a name="240810"> </a>メモ:   合計値について
</p>
  <dl>
    <dt class="Indented2"> <a name="247207"> </a>［セグメントディメンション登録/情報］画面の［合計値］チェックボックスにチェックをすると、&quot;合計&quot;という仮想メンバーを作成します。値の［最小値]、［最大値]には、nullが設定されます。
  </dl>
  <li class="SmartList1" value="11"><a name="173595"> </a>仮想メンバーを削除するには、右エリアで削除したい仮想メンバーを右クリックし、［削除］メニューを選択します。同様に右クリックから［編集］メニューを選択して、名前を変更をすることができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim7.jpg" height="83" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="12"><a name="173606"> </a>ディメンションの構成を変更するには、ドラッグ＆ドロップ、や右クリックメニューによる［切り取り］/［貼り付け］選択、を行ってください。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim67.gif" height="146" width="575" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="352098"> </a>注記:   仮想メンバーは15レベルまで作成することができます。
  </dl>
  <li class="SmartList1" value="13"><a name="173628"> </a>［更新］ボタンをクリックして、セグメントディメンションの情報を保存します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_dim8.jpg" height="84" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="343648"> </a>注記:   ［セグメントディメンションパーツ情報］画面は、［更新］ボタンをクリックしないでオブジェクトツリーをクリックすると、変更破棄のメッセージを表示せずに、そのまま画面遷移します。ディメンションメンバーの変更をした場合は、忘れずに［更新］ボタンをクリックするようにしてください。
  </dl>
</ol>
<h5 class="Heading4">
  <a name="231173"> </a>3.2.2.4 ファクトから作成するセグメントディメンション
</h5>
<p class="Body">
  <a name="277088"> </a>ファクトテーブルからセグメントディメンションを作成します。ファクトテーブルのデータを値によって分類し、ディメンション化します。今回は合計値メンバーは作成せず、「その他」メンバーを作成します。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="231381"> </a>オブジェクトツリーの［オブジェクト定義］－［セグメントディメンション］－［（スキーマ名）]を選択して、［セグメントディメンション登録］画面を表示します。
  <li class="SmartList1" value="2"><a name="258931"> </a>［合計値］チェックボックスのチェックをはずします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_fact178.gif" height="80" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="345130"> </a>［セグメント］ボックスをクリックして、［テーブル]にファクトテーブル&quot;fact_sales&quot;を選択します。［キーカラム］に、セグメント化したいカラム&quot;sales&quot;を選択します。［データタイプ］は"数値"を選択します。［「その他」メンバーの作成］をチェックします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_fact292.gif" height="249" width="591" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="262572"> </a>［作成］ボタンをクリックして、セグメントディメンションの情報を保存します。
  <li class="SmartList1" value="5"><a name="231777"> </a>セグメントディメンションをカスタマイズします。オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］－［（ディメンション名）］－［標準］パーツを選択して、［セグメントディメンションパーツ情報］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_fact3.jpg" height="231" width="487" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="6"><a name="231781"> </a>メンバーを追加して、分類したい値を設定します。メンバーの操作については、<a href="cust_seg_dim_help.jsp#178558"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.2.3 ディメンションから作成するセグメントディメンション』</span></a>を参照してください。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_fact491.gif" height="168" width="623" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="232558"> </a>注記:   ［標準］の場合、パーツ名は変更できません。
  </dl>
</ol>
<h5 class="Heading4">
  <a name="276995"> </a>3.2.2.5 セグメントディメンションのパーツを削除する
</h5>
<ol type="1">
  <li class="SmartList1" value="1"><a name="276996"> </a>作成したパーツを削除することができます。オブジェクトツリーの［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］－［（セグメントディメンション名）］から削除したいパーツを選択して、［セグメントディメンションパーツ情報］画面を表示します。
  <li class="SmartList1" value="2"><a name="276997"> </a>［削除］ボタンをクリックします。
  <dl>
    <dt class="Indented2"> <a name="276998"> </a>注記:   ［標準］パーツは削除できません。
    <dt class="Indented2"> <a name="358672"> </a>注記:   セグメントディメンションがキューブにマッピングされており、［キューブ構成］画面の［選択オブジェクト］にパーツが指定されている場合は削除できません。
<p class="BodyRelative">
  <a name="277000"> </a>メモ:   ［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］－［（ディメンション名）］に削除が反映されます。削除をしたパーツのアイコンがツリーから削除されます。
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