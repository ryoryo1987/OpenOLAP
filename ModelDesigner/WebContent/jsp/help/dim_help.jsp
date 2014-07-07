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
			<td class="main" style="padding-left:10px;padding-right:10px;background-color:white;text-align:left;width:600">

<blockquote>

<h3 class="Heading2">
  <a name="251163"> </a>3.2 ステップ１：ディメンションを登録する
</h3>
<p class="Body">
  <a name="286928"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンション</span>とは、キューブの分析データを分析する視点のことです。時間、製品、地域、顧客、販売チャネルなどがこれにあたります。一般的に「データの切り口」、「軸」、と呼ばれる場合もあります。
</p>
<p class="Body">
  <a name="313314"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンションでは集計レベルを定義し、このレベルを使ってキューブデータのドリルダウンを行うことができます。たとえば、組織ディメンションは、事業部、部、課、グループと4レベルで構成することができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/1_hierarchy.jpg" height="144" width="292" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"></span>
</p>
<p class="Body">
  <a name="286935"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">パーツ</span>とは、ディメンションのツリー構造を定義した部品のことです。ディメンションは［標準]パーツというツリー構造を必ず1つ持ちます。OpenOLAP Model Designerではこの［標準]パーツをもとにしてパーツをカスタマイズすることができます。これらのパーツを入れ替えて使用することで柔軟に集計レベルの定義を変更することが可能です。<br>この項では初めにディメンション作成の概略を、次にスノーフレーク、スター、フラットなど各スキーマごとのレベル作成方法をご説明します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_null.jpg" height="277" width="484" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<h4 class="Heading3">
  <a name="251166"> </a>3.2.1 標準ディメンションを登録する
</h4>
<ol type="1">
  <li class="SmartList1" value="1"><a name="333779"> </a>オブジェクトツリーの［オブジェクト定義］－［ディメンション］－［（スキーマ名）］を選択して、［ディメンション登録］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_icon.jpg" height="48" width="149" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="333809"> </a>以下の情報を入力します。
<br clear="all" />
<table align="center"><tr><td>
<img src="../../images/help/3_dim1.jpg" height="59" width="461" align="center" border="0" hspace="0" vspace="0">
</td></tr></table>
<br clear="all">
<span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

	<table border="1" cellpadding="5" cellspacing="0">
	  <caption></caption>
	  <tr bgcolor="#CCCCCC">
	    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333785"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
	</div>
	</th>
	    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333787"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
	</div>
	</th>
	  </tr>
	  <tr>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333789"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンションID</span><br>
	</div>
	</td>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333791"> </a>OpenOLAP Model Designerが自動的に割り振ったディメンションIDが表示されます。<br>
	</div>
	<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333792"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">*新規作成時は非表示となります。</span><br>
	</div>
	</td>
	  </tr>
	  <tr>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333794"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ディメンション名</span><br>
	</div>
	</td>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333796"> </a>ディメンションの名前を入力します。(最大桁数：30)<br>
	</div>
	</td>
	  </tr>
	  <tr>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333799"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">コメント</span><br>
	</div>
	</td>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333801"> </a>ディメンションに対するコメントを入力します。(最大桁数：250)<br>
	</div>
	</td>
	  </tr>
	  <tr>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333803"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">合計値</span><br>
	</div>
	</td>
	    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
	<a name="333805"> </a>チェックをオンにした場合、ディメンションに［合計値］メンバーが追加されます<span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">（</span><a href="cust_dim_help.jsp#279934"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.3.1 ディメンションをカスタマイズする』</span></a>を参照してください）。デフォルトではチェックはオンになっています。<br>
	</div>
	</td>
	  </tr>
	</table>



</span>
<br clear="all">

  <li class="SmartList1" value="3"><a name="315820"> </a>［レベル作成］ボタンをクリックして［レベル定義］エリアに［レベル］ボックスを追加します。［レベル］ボックスをクリックして、以下の項目を入力します。

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315777"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315779"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">入力内容</span><br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315781"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">レベル名</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315783"> </a>レベル名を入力します。（最大桁数：30）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315786"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">コメント</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315788"> </a>このレベルに対するコメントを入力します。（最大桁数：250）<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315790"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">テーブル</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315792"> </a>このレベルのデータソースとなるテーブルを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315794"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ロングネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315796"> </a>OpenOLAP Viewerでロングネームとして表示したいカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315799"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ショートネーム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315801"> </a>OpenOLAP Viewerでショートネームとして表示したいカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315804"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">ソートカラム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315806"> </a>ソートに使用するカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315809"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">キーカラム</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315811"> </a>このレベルのキーとなるカラムを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315813"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">WHERE句</span><br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315815"> </a>絞り込みたい条件を入力します。<br>カラム名には、必ずテーブル名を含めてください。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="315819"> </a>詳細は<a href="dim_help.jsp#253271"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.1.5 ［WHERE句]を指定した場合』</span></a>を参照してください。<br>例）<span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">produt.short_name=&#39;TextBook&#39; and (produt.long_name = &#39;Note&#39; or produt.long_name=&#39;Pen&#39;)</span><br>
</div>
</td>
  </tr>
</table>



<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_level20.gif" height="342" width="578" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="315161"> </a>レベルを設定したら次のレベルを同様に作成します。必要に応じて、レベル6まで作成することができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_level2.jpg" height="122" width="487" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="317169"> </a>上位レベルと下位レベルのマッピングを行います。上位レベルのレベル名をクリックし、下位レベルのレベル名にドラッグします。上位レベルと下位レベルが点線で結ばれます。このようにレベル１から順に最下位レベルまでマッピングします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_level3.jpg" height="118" width="486" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="6"><a name="336245"> </a>上位レベルと下位レベルのリンクラインをクリックして、［レベルnリンクカラム］を設定します。［レベルnキーカラム］は上位レベルのキーカラムが表示されています。上位レベルのキーカラムに対応するカラムを下位レベルの［レベルnリンクカラム］に指定します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single553.gif" height="235" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="336785"> </a>注記:   ［レベルnキーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="7"><a name="265438"> </a>［作成］ボタンをクリックして、ディメンション情報を保存します。
<p class="BodyRelative">
  <a name="237229"> </a>メモ:   アイコン追加
</p>
<p class="BodyRelative">
  <a name="334447"> </a>①	［オブジェクト定義］－［ディメンション］－［（スキーマ名）］に、作成したディメンションのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_icon26.gif" height="91" width="184" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br>②［キューブモデリング］－［ディメンションのカスタマイズ］－［ディメンション］－［（スキーマ名）］に、作成したディメンションのアイコンが追加されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_icon38.gif" height="141" width="217" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="266272"> </a>メモ:   削除ボタン<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_del.jpg" height="27" width="42" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="266317"> </a>［レベル］ボックスのレベルをクリックしてから［削除］ボタンをクリックすると、選択されたレベルを［レベル定義］エリアから削除できます。
</p>
<p class="BodyRelative">
  <a name="286977"> </a>メモ:   SQLビューアボタン<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_sqlviewer.jpg" height="27" width="82" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<p class="BodyRelative">
  <a name="287707"> </a>［SQLビューア]ボタンをクリックして、［ディメンション登録]画面で設定したディメンションのサンプルデータを［SQLビューア]サブ画面で表示することができます。詳細は<a href="dim_help.jsp#346280"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.5 作成したディメンションを確認する』</span></a>を参照してください。
</p>
</ol>
<h5 class="Heading4">
  <a name="287709"> </a>3.2.1.1 スノーフレークスキーマ(シングルリンク)の場合
</h5>
<p class="Body">
  <a name="300500"> </a>スノーフレークスキーマ（シングルリンク）のディメンションを作成する場合の、ディメンションのレベル作成方法についてご説明します。ここでは下図のスキーマの［prod_class]、［prod_family]、［produt]テーブルをもとに、ディメンションを作成します。このディメンションは、製品クラス→製品ファミリー→製品の3レベルで構成されます。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_hie_snow74.gif" height="478" width="762" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="300501"> </a>［レベル作成］ボタンをクリックして、［レベル］ボックスを追加します。
  <li class="SmartList1" value="2"><a name="320007"> </a>ディメンションのトップレベルとして、レベル1を作成します。［レベル定義]エリアで［テーブル]は&quot;prod_class&quot;を選択します。［キーカラム］はこのレベルのキーで、レベル2とマッピングされるカラムです。&quot;class_id&quot;を選択します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single140.gif" height="319" width="783" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="266472"> </a>［レベル作成］ボタンをクリックして、レベル2のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="4"><a name="266473"> </a>トップレベルとマッピングするための中間層を選択します。［テーブル]に&quot;prod_family&quot;を選択します。［キーカラム］はレベル2のキーとなり、レベル3とマッピングされるカラムです。&quot;family_id&quot;を選択します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single277.gif" height="326" width="698" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="266479"> </a>［レベル作成］ボタンをクリックして、レベル3のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="6"><a name="266480"> </a>ディメンションの最下層となるレベルを作成します。ディメンションの最下位レベルのテーブルは、ファクトテーブルとマッピングされます。［テーブル］に&quot;produt&quot;を選択します。［キーカラム］は、ファクトテーブルとマッピングするためのカラムです。&quot;prod_id&quot;を選択します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single385.gif" height="324" width="655" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="7"><a name="266486"> </a>レベル1のレベル名をクリックしてレベル2のレベル名へドラッグします。さらに、レベル2のレベル名をクリックしてレベル3のレベル名へドラッグします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single4.jpg" height="83" width="475" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="319287"> </a>レベル１とレベル2のリンクラインをクリックして、［レベル2リンクカラム］を設定します。［レベル１キーカラム］はレベル１のキーである"class_id"が表示されています。［レベル2リンクカラム］にも&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single547.gif" height="235" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="335967"> </a>注記:   ［レベル1キーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="9"><a name="334867"> </a>同様にして、レベル2とレベル3のリンクを設定します。リンクカラムは&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single649.gif" height="241" width="589" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="10"><a name="335420"> </a>［作成］ボタンをクリックして、ディメンション情報を保存します。
  <li class="SmartList1" value="11"><a name="268483"> </a>［キューブモデリング]－［ディメンションのカスタマイズ]－［ディメンション]－［（スキーマ名）］－［（ディメンション名）]の［ディメンションパーツ情報]画面で、ディメンションの構造を確認します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_prod_tree.jpg" height="151" width="470" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</ol>
<h5 class="Heading4">
  <a name="134298"> </a>3.2.1.2 スタースキーマ(シングルリンク)の場合
</h5>
<p class="Body">
  <a name="269166"> </a>スタースキーマ（シングルリンク）のディメンションを作成する場合の、ディメンションのレベル作成方法についてご説明します。ここでは下図のスキーマの［prod_star]テーブルをもとに、ディメンションを作成します。このディメンションは、製品クラス→製品ファミリー→製品の3レベルで構成されます。
</p>
<p class="Body">
  <a name="269233"> </a><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_hie_star10.gif" height="306" width="812" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="269234"> </a>［レベル作成］ボタンをクリックして、［レベル］ボックスを追加します。
  <li class="SmartList1" value="2"><a name="320037"> </a>ディメンションのトップレベルとなるレベル1を作成します。［テーブル]は&quot;prod_star&quot;を選択します。［キーカラム］はこのレベルのキーで、レベル2とマッピングされるカラムです。&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_star125.gif" height="351" width="589" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="255572"> </a>［レベル作成］ボタンをクリックして、レベル2のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="4"><a name="190997"> </a>スタースキーマなので、［テーブル］はレベル1と同じ&quot;prod_star&quot;を選択します。［キーカラム］はレベル2のキーとなり、レベル3とマッピングされるカラムです。&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_star268.gif" height="333" width="635" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="208168"> </a>［レベル作成］ボタンをクリックして、レベル3のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="6"><a name="191002"> </a>ディメンションの最下層となるレベルを作成します。ディメンションの最下位レベルのテーブルは、ファクトテーブルとマッピングされます。スタースキーマなので、［テーブル]はレベル1、レベル2と同じ&quot;prod_star&quot;を選択します。［キーカラム］は、ファクトテーブルとマッピングするためのカラムです。&quot;prod_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_star370.gif" height="304" width="638" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="7"><a name="337514"> </a>レベル1のレベル名をクリックしてレベル2のレベル名へドラッグします。さらに、レベル2のレベル名をクリックしてレベル3のレベル名へドラッグします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single4.jpg" height="83" width="475" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="337518"> </a>レベル１とレベル2のリンクラインをクリックして、［レベル2リンクカラム］を設定します。［レベル１キーカラム］はレベル１のキーである"class_id"が表示されています。［レベル2リンクカラム］にも&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single551.gif" height="235" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="337523"> </a>注記:   ［レベル1キーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="9"><a name="337524"> </a>同様にして、レベル2とレベル3のリンクを設定します。リンクカラムは&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single655.gif" height="241" width="589" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="10"><a name="337529"> </a>［作成］ボタンをクリックして、ディメンション情報を保存します。
  <li class="SmartList1" value="11"><a name="337530"> </a>［キューブモデリング]－［ディメンションのカスタマイズ]－［ディメンション]－［（スキーマ名）］－［（ディメンション名）]の［ディメンションパーツ情報]画面で、ディメンションの構造を確認します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_prod_tree.jpg" height="151" width="470" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</ol>
<h5 class="Heading4">
  <a name="151094"> </a>3.2.1.3 フラットスキーマ(シングルリンク)の場合
</h5>
<p class="Body">
  <a name="191101"> </a>フラットスキーマ（シングルリンク）のディメンションを作成する場合の、ディメンションのレベル作成方法についてご説明します。ここでは下図のスキーマの［prod_flat]テーブルをもとに、ディメンションを作成します。このディメンションは、製品クラス→製品ファミリー→製品の3レベルで構成されます。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_hie_flat.jpg" height="139" width="573" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="300837"> </a>［レベル作成]ボタンをクリックして、［レベル]ボックスを追加します。
  <li class="SmartList1" value="2"><a name="320726"> </a>ディメンションのトップレベルとして、レベル1を作成します。［テーブル]は&quot;prod_flat&quot;を選択します。［キーカラム］はこのレベルのキーで、レベル2とマッピングされるカラムです。&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_flat154.gif" height="330" width="599" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="300843"> </a>［レベル作成］ボタンをクリックして、レベル2のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="4"><a name="207347"> </a>フラットスキーマなので、［テーブル］はレベル1と同じ&quot;prod_flat&quot;を選択します。［キーカラム］はレベル2のキーとなり、レベル3とマッピングされるカラムです。&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_flat259.gif" height="330" width="608" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="207069"> </a>［レベル作成］ボタンをクリックして、レベル3のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="6"><a name="252001"> </a>ディメンションの最下層となるレベルを作成します。ディメンションの最下位レベルのテーブルは、ファクトテーブルとマッピングされます。フラットスキーマなので、［テーブル]はレベル1、レベル2と同じ&quot;prod_flat&quot;を選択します。［キーカラム］は、ファクトテーブルとマッピングするためのカラムです。&quot;prod_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_flat383.gif" height="327" width="602" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="7"><a name="338194"> </a>［レベル1のレベル名をクリックしてレベル2のレベル名へドラッグします。さらに、レベル2のレベル名をクリックしてレベル3のレベル名へドラッグします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single4.jpg" height="83" width="475" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="338198"> </a>レベル１とレベル2のリンクラインをクリックして、［レベル2リンクカラム］を設定します。［レベル１キーカラム］はレベル１のキーである"class_id"が表示されています。［レベル2リンクカラム］にも&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single586.gif" height="235" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="338203"> </a>注記:   ［レベル1キーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="9"><a name="338204"> </a>同様にして、レベル2とレベル3のリンクを設定します。リンクカラムは&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single687.gif" height="241" width="589" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="10"><a name="338209"> </a>［作成］ボタンをクリックして、ディメンション情報を保存します。
  <li class="SmartList1" value="11"><a name="338210"> </a>［キューブモデリング]－［ディメンションのカスタマイズ]－［ディメンション]－［（スキーマ名）］－［（ディメンション名）]の［ディメンションパーツ情報]画面で、ディメンションの構造を確認します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_prod_tree.jpg" height="151" width="470" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</ol>
<h5 class="Heading4">
  <a name="134651"> </a>3.2.1.4 スノーフレークスキーマ（マルチリンク）の場合
</h5>
<p class="Body">
  <a name="337795"> </a>スノーフレークスキーマ（マルチリンク）のディメンションを作成する場合の、ディメンションのレベル作成方法についてご説明します。ここでは下図のスキーマの［prod_class_multi]、［prod_family_multi]、［produt_multi]テーブルをもとに、ディメンションを作成します。このディメンションは、製品クラス→製品ファミリー→製品の3レベルで構成されます。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_hie_SNOWmulti56.gif" height="550" width="793" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="204012"> </a>［レベル作成］ボタンをクリックして、［レベル］ボックスを追加します。
  <li class="SmartList1" value="2"><a name="322044"> </a>ディメンションのトップレベルとして、レベル1を作成します。［テーブル]に&quot;prod_class_multi&quot;を選択します。［キーカラム］はこのレベルのキーで、レベル2とマッピングされるカラムです。&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_multi179.gif" height="339" width="582" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="270926"> </a>［レベル作成］ボタンをクリックして、レベル2のための［レベル］ボックスを表示します。
  <li class="SmartList1" value="4"><a name="270927"> </a>トップレベルとマッピングするための中間層を選択します。［テーブル]は&quot;prod_family_multi&quot;を選択します。［キーカラム］はレベル2のキーとなり、レベル3とマッピングされるカラムです。&quot;class_id&quot;、&quot;family_id&quot;を選択します。マルチリンクなので、レベル1のキーも、レベル2のキーに含めます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_multi280.gif" height="328" width="614" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="5"><a name="216741"> </a>［レベル作成］ボタンをクリックして、レベル3のための［レベル］ボックスを追加します。
  <li class="SmartList1" value="6"><a name="216781"> </a>ディメンションの最下層となるレベルを作成します。ディメンションの最下位レベルのテーブルは、ファクトテーブルとマッピングされます。［テーブル］は&quot;produt_multi&quot;を選択します。［キーカラム］は、ファクトテーブルとマッピングするためのカラムです。&quot;class_id&quot;、&quot;family_id&quot;、&quot;prod_id&quot;を選択します。マルチリンクなので、レベル1、レベル2のキーも［キーカラム］に含めます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_multi381.gif" height="330" width="606" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="7"><a name="338334"> </a>［レベル1のレベル名をクリックしてレベル2のレベル名へドラッグします。さらに、レベル2のレベル名をクリックしてレベル3のレベル名へドラッグします。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single4.jpg" height="83" width="475" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="8"><a name="338338"> </a>レベル１とレベル2のリンクラインをクリックして、［レベル2リンクカラム］を設定します。［レベル１キーカラム］はレベル１のキーである"class_id"が表示されています。［レベル2リンクカラム］にも&quot;class_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_single582.gif" height="235" width="584" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <dl>
    <dt class="Indented2"> <a name="338343"> </a>注記:   ［レベル1キーカラム］は変更できません。
  </dl>
  <li class="SmartList1" value="9"><a name="338344"> </a>同様にして、レベル2とレベル3のリンクを設定します。リンクカラムは&quot;class_id&quot;には&quot;class_id&quot;を、&quot;family_id&quot;には&quot;family_id&quot;を選択します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_snow_multi460.gif" height="271" width="589" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="10"><a name="338349"> </a>［作成］ボタンをクリックして、ディメンション情報を保存します。
  <li class="SmartList1" value="11"><a name="338350"> </a>［キューブモデリング]－［ディメンションのカスタマイズ]－［ディメンション]－［（スキーマ名）］－［（ディメンション名）]の［ディメンションパーツ情報]画面で、ディメンションの構造を確認します。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_prod_tree.jpg" height="151" width="470" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</ol>
<h5 class="Heading4">
  <a name="253271"> </a>3.2.1.5 ［WHERE句]を指定した場合
</h5>
<p class="Body">
  <a name="191762"> </a>WHERE句を指定すると、キューブを作成するメンバーを絞り込むことができます。特定のメンバーのみでキューブを作成したい場合などに使用します。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="192692"> </a>［WHERE句]に条件文を入力します。カラム名には必ず、テーブル名を指定してください。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_hie_Where.jpg" height="44" width="499" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="192696"> </a>絞り込んだ結果のサンプルデータを［SQLビューア]により確認できます。［SQLビューア]ボタンをクリックして［SQLビューア]サブ画面を表示します。［SQLビューア]画面の詳細については、<a href="dim_help.jsp#346280"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.2.5 作成したディメンションを確認する』</span></a>を参照してください。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_sql_viewer63.gif" height="405" width="610" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="3"><a name="193993"> </a>ディメンションのカスタマイズ画面からも、絞込みの結果を確認できます。［オブジェクトツリー]の［キューブモデリング]－［ディメンションのカスタマイズ]－［ディメンション]－［（スキーマ名）］－［（ディメンション名）]－［標準]パーツを選択して、［ディメンションパーツ情報]画面を表示します（［ディメンションパーツ情報]画面については、<a href="cust_dim_help.jsp#279934"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.3.1 ディメンションをカスタマイズする』</span></a>を参照してください）。
  <li class="SmartList1" value="4"><a name="194167"> </a>&quot;ハードウェア&quot;のメンバーだけが表示されます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_dim_where65.gif" height="179" width="613" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
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
<h4 class="Heading3">
  <a name="346280"> </a>3.2.5 作成したディメンションを確認する
</h4>
<p class="Body">
  <a name="150258"> </a>ディメンションは、［ディメンション登録/情報]画面の［SQLビューア]サブ画面で、データを確認できます。
</p>
<dl>
  <dl>
    <dt class="Indented2"> <a name="332873"> </a>注記:   セグメントディメンションのデータを確認することはできません。
  </dl>
</dl>
<h5 class="Heading4">
  <a name="126828"> </a>3.2.5.1 作成したディメンションのデータを確認する
</h5>
<ol type="1">
  <li class="SmartList1" value="1"><a name="126412"> </a>オブジェクトツリーの［オブジェクト定義]－［ディメンション]－［（スキーマ名）]から確認したいディメンションを選択して、［ディメンション情報］画面を表示します。または、オブジェクトツリーの［オブジェクト定義]－［ディメンション]－［（スキーマ名）]を選択して、［ディメンション登録]画面を表示し、ディメンションの情報を入力します。
  <li class="SmartList1" value="2"><a name="260478"> </a>［SQLビューア］ボタンをクリックして、［SQLビューア］サブ画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_sql_viewer_btn11.gif" height="345" width="594" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_sql_viewer293.gif" height="356" width="688" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><br>
  <li class="SmartList1" value="3"><a name="126414"> </a>ディメンションを作るためのSQL文とサンプルデータが確認できます。
  <dl>
    <dt class="Indented2"> <a name="126940"> </a>注記:   ディメンションが正しく作成されていない状態で［SQLビューア］ボタンをクリックすると、［SQLビューア］サブ画面に「SQL文が不正です。」というメッセージが表示されます。
  </dl>
</ol>
<h5 class="Heading4">
  <a name="126757"> </a>3.2.5.2 SQLを編集する
</h5>
<ol type="1">
  <li class="SmartList1" value="1"><a name="126949"> </a>［SQL］のSQL文を書き換えます。
  <li class="SmartList1" value="2"><a name="126950"> </a>［実行］ボタンをクリックします。
  <li class="SmartList1" value="3"><a name="126951"> </a>書き換えた内容でSQL文が実行され、結果の一覧が表示されます。
  <dl>
    <dt class="Indented2"> <a name="126971"> </a>注記:   SQL文
    <dt class="Indented2"> <a name="249143"> </a>①	書き換えたSQL文が間違っていた場合、「SQL文が不正です。」というメッセージが表示されます。<br>②		書き換えたSQL文は［ディメンション登録/情報］画面には反映されません。必要に応じて、検討したSQL文のWHERE句を［ディメンション登録／情報]画面の［WHERE句]に入力してください。
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