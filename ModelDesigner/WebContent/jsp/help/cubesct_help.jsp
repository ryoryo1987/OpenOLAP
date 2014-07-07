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
  <a name="188206"> </a>3.7<br> ステップ６：キューブの構成情報を変更する
</h3>
<p class="Body">
  <a name="188207"> </a>キューブが使用しているディメンション、パーツの確認や構成の変更を行うことができます。
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="188209"> </a>オブジェクトツリーの［キューブモデリング］－［キューブ]－［（キューブ名）］－［キューブ構成］を選択して、［キューブ構成］画面を表示します。<br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_str_icon.jpg" height="66" width="171" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="188213"> </a>ディメンション、パーツの確認や編集を行います。ディメンションの追加と削除については<a href="cubesct_help.jsp#188225"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.7.1 ディメンションの追加と削除』</span></a>を参照してください。パーツの変更/削除については<a href="cubesct_help.jsp#188258"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.7.2 ディメンションパーツの変更と削除』</span></a>を参照してください。
</ol>
<p class="Body">
  <a name="188223"> </a><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_str1.jpg" height="340" width="485" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
</p>
<h4 class="Heading3">
  <a name="188225"> </a>3.7.1<br> ディメンションの追加と削除
</h4>
<ol type="1">
  <li class="SmartList1" value="1"><a name="224471"> </a>メジャーに属する他のディメンションを追加したい場合、［キューブ構成］で「キューブ」をクリックします。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_str212.gif" height="370" width="672" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="2"><a name="188239"> </a>追加できるオブジェクトが［利用可能オブジェクト］に表示されます。［選択オブジェクト]に表示されているディメンション以外に、ディメンションがマッピングされていない場合は、［利用可能オブジェクト]は空欄表示となります。
  <li class="SmartList1" value="3"><a name="188240"> </a>［利用可能オブジェクト］で追加したいオブジェクトをクリックしてから、［追加］ボタンをクリックします。［利用可能オブジェクト］から［選択オブジェクト］に、オブジェクトが追加されます。
  <li class="SmartList1" value="4"><a name="188241"> </a>［更新］ボタンをクリックします。
  <li class="SmartList1" value="5"><a name="188242"> </a>オブジェクトを削除する場合には、［選択オブジェクト］で削除したいオブジェクトをクリックして、［削除］ボタンをクリックします。［選択オブジェクト］から［利用可能オブジェクト］へ指定したオブジェクトが戻ります。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_str422.gif" height="527" width="626" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
  <li class="SmartList1" value="6"><a name="188254"> </a>［更新］ボタンをクリックして、キューブ構成情報を保存します。
  <dl>
    <dt class="Indented2"> <a name="188255"> </a>注記:   キューブには、最低1個のディメンションまたは時間ディメンションが必要です。
  </dl>
</ol>
<h4 class="Heading3">
  <a name="188258"> </a>3.7.2<br> ディメンションパーツの変更と削除
</h4>
<p class="Body">
  <a name="188259"> </a>キューブを構成するディメンションパーツの変更/削除ができます。
</p>
<p class="Body">
  <a name="188260"> </a>
</p>
<ol type="1">
  <li class="SmartList1" value="1"><a name="188264"> </a><a href="cubesct_help.jsp#188225"><span style="color: #0000ff;  font-style: normal; font-weight: normal; text-decoration: underline; text-transform: none; vertical-align: baseline">『3.7.1 ディメンションの追加と削除』</span></a>と同様の手順で追加/削除を行えます。追加できるオブジェクトが［利用可能オブジェクト］に、削除できるオブジェクトが［選択オブジェクト]に表示されます。追加または削除したいオブジェクトをクリックします。
  <li class="SmartList1" value="2"><a name="188265"> </a>パーツを変更する場合は［追加］ボタンを、削除する場合は［削除］ボタンをクリックします。ディメンションのように、追加/削除ボタンによって選択したオブジェクトだけが移動するのではなく、オブジェクトの入替えが行われます。<br><br clear="all" /><table align="center"><tr><td><img src="../../images/help/3_cube_str524.gif" height="283" width="654" align="center" border="0" hspace="0" vspace="0">
</td></tr></table><br clear="all">
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