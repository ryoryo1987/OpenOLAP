<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>

<%@ include file="../../connect.jsp"%>



<%


	String Sql="";
	int objSeq = Integer.parseInt(request.getParameter("objId"));
	String tempGroupId = request.getParameter("groupId");


	String strKey="";
	String strName="";
	String strPassword="";
	String strExportFile="";
	String strComment="";

	strKey=request.getParameter("objId");
	if(objSeq==0){
		Sql = "SELECT NEXTVAL('user_id') AS new_seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			strKey=rs.getString("new_seq");
		}
		rs.close();
	}




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

		function load(){

			<%if(objSeq!=0){%>
				listMenuMove(0,'load');

				var singleNode=openerFrame.parent.XMLData.selectSingleNode("//row[@ID='<%=strKey%>']");
			//	alert(singleNode.xml);
				document.form_main.txt_name.value=singleNode.childNodes[1].text;
				document.form_main.txt_password.value=singleNode.childNodes[2].text;
			//	document.form_main.txt_export_file.value=singleNode.childNodes[3].text;
				for(i=0;i<document.form_main.lst_user_type.length;i++){
					if(document.form_main.lst_user_type.options[i].value==singleNode.childNodes[3].text){
						document.form_main.lst_user_type.options[i].selected=true;
						break;
					}
				}
				for(i=0;i<document.form_main.lst_export_file.length;i++){
					if(document.form_main.lst_export_file.options[i].value==singleNode.childNodes[4].text){
						document.form_main.lst_export_file.options[i].selected=true;
						break;
					}
				}
				document.form_main.txt_comment.value=singleNode.childNodes[5].text;
		        

			<%}%>




		}




		function regist(tp){

			//共通エラーチェックを先に行う
			if(!checkData()){return;}


			var groupId="";
			for(i=0;i<document.form_main.lst_right.length;i++){
				if(i!=0){
					groupId+=",";
				}
				groupId+=document.form_main.lst_right.options[i].value;
			}

			<%if(objSeq==0){%>
				var strNewUserRow="";
				strNewUserRow+='<row ID="' + document.form_main.hid_user_id.value + '" GROUP="' + groupId + '" color_style_id="1">';
				strNewUserRow+='<value>' + document.form_main.hid_user_id.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.txt_name.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.txt_password.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.lst_user_type.value + '</value>';
			//	strNewUserRow+='<value>' + document.form_main.txt_export_file.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.lst_export_file.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.txt_comment.value + '</value>';
				strNewUserRow+='</row>';

				var singleNode=openerFrame.parent.XMLData.selectSingleNode("//rows");
				singleNode.appendChild(textToDomObj(strNewUserRow));


			<%}else if(objSeq!=0){%>


				var singleNode=openerFrame.parent.XMLData.selectSingleNode("//row[@ID='" + document.form_main.hid_user_id.value + "']");

				singleNode.attributes.getNamedItem("GROUP").value=groupId;
				singleNode.childNodes[1].text=document.form_main.txt_name.value;
				singleNode.childNodes[2].text=document.form_main.txt_password.value;
			//	singleNode.childNodes[3].text=document.form_main.lst_user_type.options[document.form_main.lst_user_type.selectedIndex].text;
				singleNode.childNodes[3].text=document.form_main.lst_user_type.value;
			//	singleNode.childNodes[3].text=document.form_main.txt_export_file.value;
				singleNode.childNodes[4].text=document.form_main.lst_export_file.value;
				singleNode.childNodes[5].text=document.form_main.txt_comment.value;

			<%}%>


			//削除
			if(tp==2){
				if(showConfirm("CFM3",document.form_main.txt_name.value)){
					singleNode.parentNode.removeChild(singleNode);
				}else{
					return;
				}
			}

			//Window Close
			self.window.close();

			domReload(openerFrame.parent,openerFrame);



		}

		function listMenuMove(tp,time) {
			if(document.form_main.lst_right.tagName!="SELECT"){
				return;
			}

			var removeCnt=0;
			var remainCnt=0;
			var sourceList;
			var targetList;

			if(tp==0){
				sourceList="lst_left";
				targetList="lst_right";
			}else if(tp==1){
				sourceList="lst_right";
				targetList="lst_left";
			}


		//	if(document.form_main.elements[sourceList].selectedIndex==-1){
		//		return;
		//	}
			if((time!='load')&&(document.form_main.elements[sourceList].selectedIndex==-1)){
				if(tp==0){
					showMsg("CMN1","利用可能グループ");
				}else if(tp==1){
					showMsg("CMN1","選択グループ");
				}
				return;
			}

			var max_cnt = document.form_main.elements[sourceList].options.length;

			for(i=0;i<max_cnt;i++){
				if(document.form_main.elements[sourceList].options[remainCnt].value==""){
					document.form_main.elements[sourceList].options[remainCnt].selected=false;
				}
				if(document.form_main.elements[sourceList].options[remainCnt].selected==true){
					var addOption = document.createElement("OPTION");
					addOption.value = document.form_main.elements[sourceList].options[remainCnt].value;
					addOption.text = document.form_main.elements[sourceList].options[remainCnt].text;
					addOption.orderno = document.form_main.elements[sourceList].options[remainCnt].orderno;
					document.form_main.elements[sourceList].remove(remainCnt);
					if(tp==0){
						document.form_main.elements[targetList].options.add(addOption);
					}else if(tp==1){
						var targetListNo = document.form_main.elements[targetList].length;
						for(j=0;j<document.form_main.elements[targetList].length;j++){
							if(parseInt(document.form_main.elements[targetList].options[j].orderno)>parseInt(addOption.orderno)){
								var targetListNo = j;
								break;
							}
						}
						document.form_main.elements[targetList].options.add(addOption,targetListNo);
					}
					removeCnt++;
				}else{
					remainCnt++;
				}
			}
		}


	</script>








</head>

<body onload="load()">
	<form id="form_main" method="post" name="form_main">
	<table class="Header">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">ユーザー情報
			</td>
		</tr>
	</table>

	<div style="margin:15">



				<table>
					<%if(!(objSeq==0)){%>
					<tr>
						<td align="right"><span class="title">ID：</span></td>
						<td>
							<%=objSeq%>
						</td>
					</tr>
					<%}%>
					<input type="hidden" name="hid_user_id" value="<%=strKey%>">
					<tr>
						<td align="right"><span class="title">ユーザー名：</span></td>
						<td>
							<input type="text" name="txt_name" size="60" value="" mON="ユーザー名" maxlength="30">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">パスワード：</span></td>
						<td>
							<input type="password" name="txt_password" size="60" value="" mON="パスワード" maxlength="30">
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">ユーザーの種類：</span></td>
						<td>
						<%if("1".equals(strKey)){//userIdが1の場合%>
							<input type="hidden" name="lst_user_type" value="1">管理者
						<%}else if(!"1".equals(strKey)){//userIdが1でなければ%>
							<select name="lst_user_type">
								<option value="2">一般ユーザー</option>
								<option value="3">ゲスト</option>
							</select>
						<%}%>
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">エクスポート形式：</span></td>
						<td>
							<!--
							<input type="text" name="txt_export_file" size="80" value="" mON="エクスポート形式" maxlength="250">
							-->
							<select name="lst_export_file">
								<option value="XMLSpreadSheet">XMLSpreadSheet</option>
								<option value="CSV">CSV</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><span class="title">コメント：</span></td>
						<td>
							<input type="text" name="txt_comment" size="80" value="" mON="コメント" maxlength="250">
						</td>
					</tr>
				</table>
			

<BR>
<%if("1".equals(strKey)){//userIdが1の場合%>
				<input type="hidden" name="lst_right" value="">
<%}else if(!"1".equals(strKey)){//userIdが1でなければ%>

				<table>
					<tr>
						<td width="90"><br></td>
						<td id="td_left_move">
							<span class="title">利用可能グループ：</span><br>
							<select name="lst_left" size="12" multiple style="width:200;margin-right:0">
<%
	int lstCnt=-1;

	Sql = " select group_id,name,'' as selectedFlg from oo_v_group";
	if(!"".equals(tempGroupId)){
		Sql += " where group_id not in (" + tempGroupId + ")";
		Sql += " union";
		Sql += " select group_id,name,'selected' as selectedFlg from oo_v_group";
		Sql += " where group_id in (" + tempGroupId + ")";
	}
	Sql += " ORDER BY 1"; 
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		lstCnt++;
		out.println("<option orderno='" + lstCnt + "' value='" + rs.getString("group_id") + "' " + rs.getString("selectedFlg") + ">" + rs.getString("name") + "</option>");
	}
	rs.close();
%>

							</select>
						</td>
						<td align="center" width="80">
							<input type="button" name="add_btn" value="" onClick="JavaScript:listMenuMove(0);" class="normal_add" onMouseOver="className='over_add'" onMouseDown="className='down_add'" onMouseUp="className='up_add'" onMouseOut="className='out_add'">
<br><br>
							<input type="button" name="del_btn" value="" onClick="JavaScript:listMenuMove(1);" class="normal_del" onMouseOver="className='over_del'" onMouseDown="className='down_del'" onMouseUp="className='up_del'" onMouseOut="className='out_del'">
						</td>
						<td id="td_right_move">
							<span class="title">選択グループ：</span><br>
							<select name="lst_right" size="12" multiple style="width:200;margin-right:0">
							</select>
						</td>
					</tr>
				</table>

<%}%>

				<table style="margin-top:10">
					<tr>
						<td width="90"><br></br></td>
						<td width="480" align="center">
							<%if(objSeq==0){%>
								<!-- **************************  新規　ボタン ***************************** -->
								<input type="button" name="crt_btn" value="" onclick="javaScript:regist(0);" class="normal_create_mini" onMouseOver="className='over_create_mini'" onMouseDown="className='down_create_mini'" onMouseUp="className='up_create_mini'" onMouseOut="className='out_create_mini'">
							<%}else{%>
								<!-- **************************  更新　ボタン ***************************** -->
								<input type="button" name="edi_btn" value="" class="normal_update" onClick="javaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
								<%if(!"1".equals(strKey)){//userIdが1でなければ%>
									<!-- **************************  削除　ボタン ***************************** -->
									<input type="button" name="del_btn" value="" class="normal_delete" onClick="javaScript:regist(2);" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
								<%}%>
							<%}%>
							<input type = 'button' value='' onclick="self.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
						</td>
					</tr>
				</table>


	</div>
	</form>
</body>
</html>


<%@ include file="../../connect_close.jsp" %>
