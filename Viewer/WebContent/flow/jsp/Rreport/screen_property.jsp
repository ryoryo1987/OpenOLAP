<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
		<title><%=(String)session.getValue("aplName")%></title>
		<link rel="stylesheet" type="text/css" href="../../../css/common.css">
		<script type="text/javascript" src="js/registration.js"></script>
		<script language="JavaScript">

			function pushBack(){
				parent.parent.document.body.firstChild.cols = "*,0,0";
				document.form_main.action = "../blank.html";
				document.form_main.target = "frm_main3";
				document.form_main.submit();
			}

			function pushNext() {
				parent.parent.document.body.firstChild.cols = "0,*,0";
//				document.form_main.action = "frm_report_rgs.jsp";
//				document.form_main.target = "frm_main3";
				document.form_main.submit();

			}

		</script>
	</head>
	<body>
		<form name="form_main" id="form_main" method="post">

		<div style="position:absolute;top:10px;left:5px;height:20px;width:70px;z-index:1111;background-color:#EEEEEE;padding:5;border-style:outset;border-width:2 2 0 2;border-color:#CCCCCC gray gray #CCCCCC">設定項目</div>
		<div style="position:absolute;top:33px;left:5px;height:250px;width:200;padding:4;background-color:#EEEEEE;border-style:outset;border-width:2;border-color:#CCCCCC gray gray #CCCCCC">
			<table>
				<tr>
					<td>ﾃﾝﾌﾟﾚｰﾄ：</td>
					<td><div id='screenType' seq=''>未選択</div></td>
				</tr>
				<tr>
					<td>ｽﾀｲﾙ：</td>
					<td><div id='styleType' seq=''>未選択</div></td>
				</tr>
				<tr>
					<td nowrap valign="top">論理ﾓﾃﾞﾙ：</td>
					<td><div id='modelType' seq=''>未選択</div></td>
				</tr>
			</table>
		</div>
		</form>
	<body>
</html>
