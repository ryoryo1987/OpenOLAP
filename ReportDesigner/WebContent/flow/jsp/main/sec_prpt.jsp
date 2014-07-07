<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>



<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">

		var openerFrame = window.dialogArguments[0];
		var objId = window.dialogArguments[1];

		function load(){
			document.all.td_id.innerHTML=objId;
			document.all.td_name.innerHTML=openerFrame.document.getElementById(objId).firstChild.firstChild.childNodes[1].innerText;
			//参照
			if(openerFrame.document.getElementById(objId).childNodes[2].firstChild.firstChild.checked==true){
				document.all.chk_right.checked=true;
			}
			//エクスポート
			if(openerFrame.document.getElementById(objId).KI=="R"){
				document.all.td_exp.innerHTML='<input type="checkbox" name="chk_export" value="">';
				if(openerFrame.document.getElementById(objId).childNodes[3].firstChild.firstChild.checked==true){
					document.all.chk_export.checked=true;
				}
			}

		}


		function regist(){

			var tempFlg=0;
			
			//参照　未許可→許可にした場合
			if((openerFrame.document.getElementById(objId).KI=="F")&&(!openerFrame.document.getElementById(objId).childNodes[2].firstChild.firstChild.checked)&&(document.all.chk_right.checked)){
				if(confirm("参照の許可を下層のフォルダやレポートにも反映させますか？")){
					tempFlg=1;
				}
			}



			if(document.all.chk_right.checked){
				openerFrame.document.getElementById(objId).childNodes[2].firstChild.firstChild.checked=true;
			}else{
				openerFrame.document.getElementById(objId).childNodes[2].firstChild.firstChild.checked=false;
			}
			openerFrame.changeCheckBox(openerFrame.document.getElementById(objId).childNodes[2].firstChild.firstChild,tempFlg);

			if(document.all.chk_export!=undefined){
				if(document.all.chk_export.checked){
					openerFrame.document.getElementById(objId).childNodes[3].firstChild.firstChild.checked=true;
				}else{
					openerFrame.document.getElementById(objId).childNodes[3].firstChild.firstChild.checked=false;
				}
				openerFrame.changeCheckBox(openerFrame.document.getElementById(objId).childNodes[3].firstChild.firstChild,0);
			}



			self.window.close();

		}

	</script>
</head>

<body onload="load()">
	<form id="form_main" method="post" name="form_main">
	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td valign="top" class="HeaderTitle">
			</td>
		</tr>
	</table>

	<div style="margin:15">



				<table>
					<tr>
						<td align="right"><span class="title">ID：</span></td>
						<td id="td_id">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">名前：</span></td>
						<td id="td_name">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">参照：</span></td>
						<td>
							<input type="checkbox" name="chk_right" value="">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">エクスポート：</span></td>
						<td id="td_exp">
							-
						</td>
					</tr>

				</table>
			



				<div class="command">
					<input type="button" name="edi_btn" value="" class="normal_ok" onClick="javaScript:regist();" onMouseOver="className='over_ok'" onMouseDown="className='down_ok'" onMouseUp="className='up_ok'" onMouseOut="className='out_ok'">
					<input type = 'button' value='' onclick="self.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
				</div>


	</div>
	</form>
</body>
</html>


