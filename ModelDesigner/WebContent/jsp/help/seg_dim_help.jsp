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

<h4 class="Heading3">
  <a name="193995"> </a>3.2.2 セグメントディメンションを登録する
</h4>
<p class="Body">
  <a name="178253"> </a>ディメンションのメンバーを値によって分類したい場合に、セグメントディメンションを作成します。商品の値段による分類や（<a href="cust_seg_dim_help.jsp#178558"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.2.3 ディメンションから作成するセグメントディメンション』</span></a>参照してください）、ファクトテーブルのデータ（売上金額など）の値による分類（<a href="cust_seg_dim_help.jsp#231173"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.2.4 ファクトから作成するセグメントディメンション』</span></a>を参照してください）ができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_sample.jpg" height="180" width="474" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<h5 class="Heading4">
  <a name="276929"> </a>3.2.2.1 セグメントディメンション基本情報を登録する
</h5>
<ol type="1">
  <li class="SmartList1" value="1"><a name="326026"> </a>オブジェクトツリーの［オブジェクト定義］－［セグメントディメンション］－［（スキーマ名）］を選択して、［セグメントディメンション登録］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg_icon.jpg" height="67" width="172" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="326030"> </a>以下の情報を入力します。<span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326033"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326035"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326037"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンションID</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326039"> </a>OpenOLAP Model Designerが自動的に割り振ったディメンションIDが表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326040"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">*新規作成時は非表示となります。</span><br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326042"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンション名</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326044"> </a>セグメントディメンションの名前を入力します。(最大桁数：30)<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326047"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">コメント</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326049"> </a>セグメントディメンションに対するコメントを入力します。(最大桁数：250)<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326051"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">合計値</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326053"> </a>チェックをオンにした場合、ディメンションに［合計値］メンバーが追加されます。<br>
</div>
</td>
  </tr>
</table>



<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg1.jpg" height="58" width="491" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"></span>
  <li class="SmartList1" value="3"><a name="326057"> </a>［レベル定義］エリアに表示されている［セグメント］ボックスをクリックして、以下の項目を入力します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg264.gif" height="261" width="582" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326751"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326753"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326755"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">レベル名</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326757"> </a>レベル名を入力します。（最大桁数：30）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326760"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">コメント</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326762"> </a>このレベルに対するコメントを入力します。（最大桁数：250）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326764"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">テーブル</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326766"> </a>このレベルのデータソースとなるテーブルを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326780"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">キーカラム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326782"> </a>このレベルのキーとなるカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326784"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">データタイプ</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326790"> </a>キーカラムのデータタイプを選択します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326951"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［数値］<br></span>セグメントディメンションのメンバーは数値で区切られます。［セグメントディメンションパーツ登録/情報］画面でパーツを登録するときに、メンバーの最小値と最大値を指定します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="326986"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［文字列］<br></span>セグメントディメンションのメンバーは文字列の分類で区切られます。［セグメントディメンションパーツ登録/情報］画面でパーツを登録するときに、メンバーに対する絞込み文字列を指定します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="333351"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">「その他」メンバーの作成</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="333353"> </a>「その他」メンバーを作成する場合、チェックをします。<br>「その他」メンバーを作成すると、［セグメントディメンションパーツ情報］画面で作成したメンバーの範囲外になったメンバーをまとめることができます。<br>
</div>
</td>
  </tr>
</table>



</span>
  <li class="SmartList1" value="4"><a name="329444"> </a>ステップ3で作成したレベルの下に、さらにレベルを作成する場合は、［レベル作成］ボタンをクリックして［レベル定義］エリアに［レベル］ボックスを追加します。［レベル］ボックスをクリックして、以下の項目を入力します。

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329447"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329449"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329451"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">レベル名</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="351919"> </a>レベル名を入力します。（最大桁数：30）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329456"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">コメント</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329458"> </a>このレベルに対するコメントを入力します。（最大桁数：250）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329460"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">テーブル</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329462"> </a>このレベルのデータソースとなるテーブルを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329464"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ロングネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329466"> </a>OpenOLAP Viewerでロングネームとして表示したいカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329468"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ショートネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329470"> </a>OpenOLAP Viewerでショートネームとして表示したいカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329472"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ソートカラム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329474"> </a>ソートに使用するカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329476"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">キーカラム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="329478"> </a>このレベルのキーとなるカラムを選択します。<br>
</div>
</td>
  </tr>
</table>



<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg3.jpg" height="279" width="490" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="329494"> </a>レベルを設定したら次のレベルを同様に作成します。必要に応じて、レベル6まで作成することができます。
  <li class="SmartList1" value="6"><a name="326101"> </a>上位レベルと下位レベルのマッピングを行います。上位レベルのレベル名をクリックし、下位レベルのレベル名にドラッグします。上位レベルと下位レベルが点線で結ばれます。このようにレベル１から順に最下位レベルまでマッピングします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg4.jpg" height="105" width="489" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="339353"> </a>注記:   セグメントレベルは最上位レベルです。セグメントレベルを他のレベルの下位レベルにマッピングすることはできません。
  </dl>
  <li class="SmartList1" value="7"><a name="326102"> </a>上位レベルと下位レベルのリンクラインをクリックして、［レベルnリンクカラム］を設定します。［セグメント/レベルnキーカラム］は上位レベルのキーカラムが表示されています。上位レベルのキーカラムに対応するカラムを下位レベルの［レベルnリンクカラム］に指定します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg571.gif" height="273" width="535" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="339352"> </a>注記:   ［セグメント/レベルnキーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="8"><a name="338854"> </a>［作成］ボタンをクリックして、セグメントディメンション情報を保存します。
<p class="BodyRelative">
  <a name="326103"> </a>メモ:   アイコン追加
</p>
<p class="BodyRelative">
  <a name="326104"> </a>①	［オブジェクト定義］－［セグメントディメンション］－［（スキーマ名）］に、作成したセグメントディメンションのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg635.gif" height="110" width="197" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br>②［キューブモデリング］－［ディメンションのカスタマイズ］－［セグメントディメンション］－［（スキーマ名）］に、作成したセグメントディメンションのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_seg6_237.gif" height="159" width="206" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="326113"> </a>メモ:   削除ボタン<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_del.jpg" height="27" width="42" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="326137"> </a>［レベル］ボックスのレベルをクリックしてから［削除］ボタンをクリックすると、選択されたレベルを［レベル定義］エリアから削除できます。
</p>
</ol>



<h4 class="Heading3">
  <a name="172158"> </a>3.2.3 ディメンション/セグメントディメンションを編集する
</h4>
<ol type="1">
  <li class="SmartList1" value="1"><a name="259555"> </a>オブジェクトツリーの［オブジェクト定義］－［ディメンション/セグメントディメンション］－［（スキーマ名）]から、編集したいディメンション/セグメントディメンションを選択して、［ディメンション/セグメントディメンション情報］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_icon4.jpg" height="67" width="162" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="172167"> </a>項目を編集します。
  <dl>
    <dt class="Indented2"> <a name="324555"> </a>注記:   ［ディメンションID］は編集できません。
  </dl>
  <li class="SmartList1" value="3"><a name="125039"> </a>［更新］ボタンをクリックして、ディメンション/セグメントディメンション情報を保存します。
<p class="BodyRelative">
  <a name="125058"> </a>メモ:   ディメンション、レベルの編集について
</p>
  <dl>
    <dt class="Indented2"> <a name="247421"> </a>①ディメンション名を変更すると以下に変更が反映されます。<br>・［オブジェクト定義］－［メジャー］－［（スキーマ名）］－［（メジャー名）］、［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］／［セグメントディメンション］－［（スキーマ名）］－［（ディメンション名）]、それぞれのツリーアイコン<br>・［キューブモデリング］－［キューブ］－［キューブ構成］のディメンション名<br><br>②メジャーにマッピングされているディメンションのレベルを編集すると以下のように変更が反映されます。<br>・<span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">最下位レベルを追加</span>－［オブジェクト定義］－［メジャー情報］画面のディメンションのレベル名と［ディメンションボトムキーカラム］が最下位レベルのレベル名とキーカラムに自動更新されます。ただし、［ファクトリンクカラム］には前回指定されたカラムがそのまま残ります。<br>・<span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">レベルを削除</span>－［レベル定義］エリアでレベルを削除してから［更新］ボタンをクリックすると、レベルがメタデータから削除されます。<br>最下位レベルを削除すると、［オブジェクト定義］－［メジャー情報］画面のディメンションのレベルも削除され、新しく最下位レベルとなったレベルのレベル名と［ディメンションボトムキーカラム］に自動更新されます。ただし、［ファクトリンクカラム］には前回指定されたカラムがそのまま残ります。<br>*レベル１は削除できません。<br>・<span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">最下位レベルの［キーカラム］の変更</span>－最下位レベルの［キーカラム］を変更した場合、［オブジェクト定義］－［メジャー情報］画面のディメンションのレベルの［ディメンションボトムキーカラム］が自動更新されます。ただし、［ファクトリンクカラム］には前回指定されたカラムがそのまま残ります。
  </dl>
</ol>
<h4 class="Heading3">
  <a name="117267"> </a>3.2.4 ディメンション/セグメントディメンションを削除する
</h4>
<ol type="1">
  <li class="SmartList1" value="1"><a name="126222"> </a>オブジェクトツリーの［オブジェクト定義］－［ディメンション/セグメントディメンション］－［（スキーマ名）]から、削除したいディメンション/セグメントディメンションを選択して、［ディメンション/セグメントディメンション情報］画面を表示します。
  <li class="SmartList1" value="2"><a name="247635"> </a>［削除］ボタンをクリックします。ディメンション/セグメントディメンション情報が削除されます。削除後、画面は［ディメンション/セグメントディメンション登録］画面へ切り替わります。
  <dl>
    <dt class="Indented2"> <a name="247637"> </a>注記:   メジャーとマッピングされている場合、ディメンションは削除できません。
<p class="BodyRelative">
  <a name="126270"> </a>メモ:   アイコン削除
</p>
    <dt class="Indented2"> <a name="346278"> </a>①	［オブジェクト定義］－［ディメンション/セグメントディメンション］－［（スキーマ名）］から削除をしたディメンションのアイコンがツリーから削除されます。<br>②	［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション/セグメントディメンション］－［（スキーマ名）］から削除を行ったディメンション/セグメントディメンションが削除されます。
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