<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>

<%@ include file="../../connect.jsp"%>
<%
	String objId = (String)request.getParameter("objId");



%>




<html>
<head>
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link REL="stylesheet" TYPE="text/css" HREF="../../../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript" src="../js/dom.js"></script>



	<script language="JavaScript">
		var openerFrame = window.dialogArguments;
	//	var openerFrame = opener;

		function load(){
			document.all.hid_window_type.value=openerFrame.document.all("<%=objId%>").windowType;

			document.form_main.internet.value=openerFrame.document.all("<%=objId%>").url;
			for(i=0;i<document.all.rmodel.length;i++){
				if(document.all.rmodel.options[i].value==openerFrame.document.all("<%=objId%>").rmodelId){
					document.all.rmodel.options[i].selected=true;
					break;
				}
			}
			for(i=0;i<document.all.portalcolor.length;i++){
				if(document.all.portalcolor.options[i].value==openerFrame.document.all("<%=objId%>").portalColor){
					document.all.portalcolor.options[i].selected=true;
					break;
				}
			}

			disabledCheck();
		}




		function regist(tp){



			//共通エラーチェックを先に行う
		//	if(!checkData()){return;}
			var obj=document.all("internet");
			if(!obj.disabled){
				var errNum=0;
			//	errNum = IsNullChar(obj);//未入力チェック
				if(errNum==0){errNum = IsIllegalChar(obj,1);}//不正文字(& ' < >)チェック

				//エラー処理
				if(errNum!=0){
					showMsg("ERR"+errNum,obj.mON,obj.title);
					obj.focus();
					obj.select();
					return;
				}

				if(!((obj.value=="blank.html")||(obj.value.indexOf("http://")!=-1)||(obj.value.indexOf("https://")!=-1))){
					alert(obj.mON+"を正しく入力してください。");
					obj.focus();
					obj.select();
					return;
				}

			}

			obj=document.all("rmodel");
			if(!obj.disabled){
				if(obj.value==""){
					alert("ROLAPレポートを選択してください。");
					return;
				}
			}





/*
			if(document.all.hid_window_type.value=="internet"){
				openerFrame.document.all("<%=objId%>").childNodes[1].firstChild.childNodes[0].childNodes[1].childNodes[0].src=document.form_main.internet.value;
			}else if(document.all.hid_window_type.value=="rmodel"){
				openerFrame.document.all("<%=objId%>").childNodes[1].firstChild.childNodes[0].childNodes[1].childNodes[0].src="http://majolicamajolic/viewerV2dev/flow/jsp/Rreport/dispFrm.jsp?kind=db&rId="+document.all.rmodel.value;
			}
*/

			var beforeColor=openerFrame.document.all("<%=objId%>").portalColor;


			openerFrame.document.all("<%=objId%>").url=document.form_main.internet.value;
			openerFrame.document.all("<%=objId%>").windowType=document.all.hid_window_type.value;
			openerFrame.document.all("<%=objId%>").rmodelId=document.all.rmodel.value;
			openerFrame.document.all("<%=objId%>").portalColor=document.all.portalcolor.value;


			var displayUrl;
			var displayTitle;
			if(openerFrame.document.all("<%=objId%>").windowType=="internet"){
				displayUrl=openerFrame.document.all("<%=objId%>").url;
				displayTitle=openerFrame.document.all("<%=objId%>").url;
			}else{
				displayUrl="../Rreport/dispFrm.jsp?kind=db&rId="+openerFrame.document.all("<%=objId%>").rmodelId;
				displayTitle=document.all.rmodel.options[document.all.rmodel.selectedIndex].text;
			}
			openerFrame.document.all("<%=objId%>").childNodes[1].firstChild.childNodes[0].childNodes[1].childNodes[0].src=displayUrl;
			openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[1].innerHTML=displayTitle;



			var afterColor=openerFrame.document.all("<%=objId%>").portalColor;


			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[0];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[1];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[2];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[2].childNodes[0];
			tempOj.src=tempOj.src.replace(beforeColor+".gif",afterColor+".gif");
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[2].childNodes[1];
			tempOj.src=tempOj.src.replace(beforeColor+".gif",afterColor+".gif");
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[0].childNodes[3];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[1].childNodes[0].childNodes[0].childNodes[0];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[1].childNodes[0].childNodes[0].childNodes[2];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[2].childNodes[0];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[2].childNodes[1];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);
			var tempOj = openerFrame.document.all("<%=objId%>").childNodes[2].childNodes[2];
			tempOj.className=tempOj.className.replace(beforeColor,afterColor);





			//Window Close
			self.window.close();


		}


		function disabledCheck(windowType){
			if(windowType!=null){
				document.all.hid_window_type.value=windowType;
			}

			document.all("internet").disabled=true;
			document.all("rmodel").disabled=true;

			document.all(document.all.hid_window_type.value).disabled=false;
			document.all("rdo_"+document.all.hid_window_type.value).checked=true;
		}






	</script>








</head>

<body onload="load()">
	<form id="form_main" method="post" name="form_main">
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">ウィンドウのプロパティ
			</td>
		</tr>
	</table>

	<div style="margin:15">



				<table>
					<tr>
						<td align="right">　</td>
						<td align="right"><span class="title">ポータルカラー：</span></td>
						<td>
							<select name="portalcolor" id="portalcolor">
								<option value="1">青</option>
								<option value="2">シルバー</option>
								<option value="3">緑</option>
								<option value="4">オレンジ</option>
								<option value="5">紫</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><input type="radio" name="rdo" id="rdo_internet" onclick="disabledCheck('internet')"></td>
						<td align="right"><span class="title">URL：</span></td>
						<td>
							<input type="text" name="internet" id="internet" size="60" value="" mON="URL" maxlength="300">
						</td>
					</tr>
					<tr>
						<td align="right"><input type="radio" name="rdo" id="rdo_rmodel" onclick="disabledCheck('rmodel')"></td>
						<td align="right"><span class="title">ROLAPレポート：</span></td>
						<td>
							<select name="rmodel" id="rmodel">
								<option value="">-----ROLAPレポートを選択してください-----</option>
<%
	String Sql="";
	Sql += " SELECT report_id,report_name from oo_v_report where kind_flg='R' and report_type='R' order by report_id";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		out.println("<option value='" + rs.getString("report_id") + "'>" + rs.getString("report_name") + "</option>");
	}
	rs.close();

%>
							</select>
						</td>
					</tr>
				</table>
			
				<table style="margin-top:10">
					<tr>
						<td width="480" align="center">
							<input type="button" name="edi_btn" value="" class="normal_ok_mini" onClick="javaScript:regist(1);" onMouseOver="className='over_ok_mini'" onMouseDown="className='down_ok_mini'" onMouseUp="className='up_ok_mini'" onMouseOut="className='out_ok_mini'">
							<input type = 'button' value='' onclick="self.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
						</td>
					</tr>
				</table>


	</div>


	<input type="hidden" name="hid_window_type" id="hid_window_type" value="internet">
	<input type="hidden" name="hid_rmodel_id" id="hid_rmodel_id" value="">

	</form>
</body>
</html>


<%@ include file="../../connect_close.jsp"%>
