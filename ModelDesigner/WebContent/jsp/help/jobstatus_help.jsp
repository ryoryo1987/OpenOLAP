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
  <a name="120359"> </a>3.9 ステップ８：キューブを生成する
</h3>
<p class="Body">
  <a name="153600"> </a>キューブモデリングで設定したキューブ情報を元にキューブを生成します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_create_cube1.jpg" height="382" width="484" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="164375"> </a>オブジェクトツリーの［キューブマネージャー］－［キューブ作成］を選択して、［キューブ作成］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_create_icon.jpg" height="57" width="159" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="164416"> </a>以下の情報を入力します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_create_cube2.jpg" height="136" width="476" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164385"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">項目名</span><br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164387"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164389"> </a>キューブ<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164391"> </a>処理対象のキューブを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164393"> </a>プロセス<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164395"> </a>実行するプロセスを選択します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164757"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［0: 削除＆新規作成］<br></span>作成済みのキューブを一度削除してからキューブを生成します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164758"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［9: キューブの削除］<br></span>作成済みのキューブを削除します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164398"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［1: キューブ定義］<br></span>キューブ生成の定義情報を作成します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164399"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［2: データロード］<br></span>データマートからメタデータへデータをロードします。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="165517"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［3: 集計］<br></span>メタデータのデータを集計します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="168896"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">[4:カスタムメジャー]<br></span>カスタムメジャーの処理を行います。［カスタムメジャー登録/情報］画面の［データの持ち方］で「フォーミュラ形式」を選択した場合は、カスタムメジャーのファンクションを生成します。「実データ形式」を選択した場合は、カスタムメジャー値を計算します。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="165686"> </a>プロセスを個別に指定するときは、Shift（シフト）キーまたはCtrl（コントロール）キーを押して実行したいプロセスを選択します。<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164404"> </a>最近実行されたジョブ<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="164415"> </a>［キューブ作成］画面やバッチで既に実行したジョブ（プロセスの組み合わせ）がある場合、リストからそのジョブを選択して実行できます。リストには最近実行されたジョブ10個が表示されます（※キューブが削除されるとジョブは表示されなくなります）。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="166442"> </a>*リストのフォーマット<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 8pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: -8pt; text-transform: none; vertical-align: baseline">
<a name="166824"> </a>［キューブ番号］:［キューブ名］（プロセス［プロセス番号］）<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="166823"> </a>例）19:売上キューブ(プロセス0)<br>
</div>
</td>
  </tr>
</table>




  <li class="SmartList1" value="3"><a name="136548"> </a>［実行］ボタンをクリックして、プロセスを［実行リスト］欄へ追加します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_create_cube35.gif" height="256" width="630" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all"><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="167666"> </a>項目名<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="167668"> </a>入力内容<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="167670"> </a>ジョブ<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="172389"> </a>実行ボタンをクリックされたキューブのプロセス名が表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="172390"> </a>*フォーマット<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 8pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: -8pt; text-transform: none; vertical-align: baseline">
<a name="172391"> </a>［キューブ番号］:［キューブ名］（プロセス［プロセス番号］）<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="172376"> </a>例）19:売上キューブ(プロセス0)<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="167674"> </a>ステータス<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="167683"> </a>プロセスの実行ステータスが表示されます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="168201"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［待機］<br></span>プロセスは待機中です。［削除］ボタンをクリックして、ジョブを削除することができます。<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="168233"> </a><span style="color: #000000;  font-style: normal; font-weight: bold; text-decoration: none; text-transform: none; vertical-align: baseline">［実行中］<br></span>プロセスは実行中です。［中止］ボタンをクリックして、ジョブを中止することができます。［削除］ボタンは使用できません。<br>
</div>
</td>
  </tr>
</table>



<br></span>実行されると［実行リスト］欄の［ステータス］が&quot;実行中&quot;に切り替わり、［ステータス表示］欄で進行状況を確認することができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_create_cube4.jpg" height="226" width="375" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="4"><a name="172440"> </a>処理が終了すると、［実行リスト］欄の［ステータス］が&quot;終了&quot;に切り替わり、［キューブリスト］でキューブの状態とデータ件数を確認することができます。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_create_cube56.gif" height="362" width="594" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
<p class="BodyRelative">
  <a name="173161"> </a>メモ:   キューブリスト
</p>
  <dl>
    <dt class="Indented2"> <a name="174428"> </a>キューブリストでは以下のアイコンでキューブの状態を確認できます。アイコンにマウスを置くと、以下のメッセージを表示します。<br><img src="../../images/help/CubeNone.gif" height="15" width="15" border="0" hspace="0" vspace="0">
　「実キューブは存在しません」
    <dt class="Indented2"> <a name="174449"> </a><img src="../../images/help/CubeComp.gif" height="15" width="15" border="0" hspace="0" vspace="0">
　「メタ通りに実キューブが存在します」
    <dt class="Indented2"> <a name="174458"> </a><img src="../../images/help/CubeCstm.gif" height="15" width="15" border="0" hspace="0" vspace="0">
　「カスタマイズされた実キューブが存在します」
    <dt class="Indented2"> <a name="174463"> </a><img src="../../images/help/CubeInfo2.gif" height="15" width="15" border="0" hspace="0" vspace="0">
　「メタとは異なる実キューブが存在します」<br>
  </dl>
</ol>
<p class="Body">
  <a name="154491"> </a>※表「キューブ再構築時の実行手順」<br>キューブの再構築時には、以下の実行手順にしたがってください。

<table border="1" cellpadding="5" cellspacing="0">
  <caption></caption>
  <tr bgcolor="#CCCCCC">
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170065"> </a>変更内容<br>
</div>
</th>
    <th><div style="color: #000000;  font-style: normal; font-weight: bold; margin-bottom: 0pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170067"> </a>実行手順<br>
</div>
</th>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170069"> </a>キューブにメジャーを追加<br>ディメンションのレベルを追加／削除する<br>ディメンションのパーツを入替える<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170071"> </a>①以下のプロセスを選択して実行<br>
</div>
<div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 10pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170072"> </a><span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">・［2：データロード］　<br>・［3：集計］<br>・［4：カスタムメジャー］</span><br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170074"> </a>キューブにメジャーを削除／<br>既存のメジャーにディメンションを削除<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170076"> </a>①プロセス［9：キューブの削除］を実行<br>②プロセス［0：削除&amp;新規作成］を実行<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170078"> </a>既存のメジャーにディメンションを追加<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170080"> </a>①プロセス［0：削除&amp;新規作成］を実行<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170082"> </a>カスタムメジャーを追加／削除する<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170084"> </a>①プロセス<span style="color: #000000;  font-style: normal; font-weight: normal; text-decoration: none; text-transform: none; vertical-align: baseline">［4：カスタムメジャー］</span>を実行<br>
</div>
</td>
  </tr>
  <tr>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170086"> </a>SQL文のカスタマイズ／初期設定への変更<br>
</div>
</td>
    <td><div style="color: #000000;  font-style: normal; font-weight: normal; margin-bottom: 4pt; margin-left: 0pt; margin-right: 0pt; margin-top: 0pt; text-align: left; text-decoration: none; text-indent: 0pt; text-transform: none; vertical-align: baseline">
<a name="170088"> </a>該当のSQL文による<br>
</div>
</td>
  </tr>
</table>




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