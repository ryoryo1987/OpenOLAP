<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%@ include file="../../connect.jsp"%>

<%


	String Sql="";
	int objSeq = Integer.parseInt(request.getParameter("objId"));
	String tempUserId = request.getParameter("userId");


	String strKey="";
	String strName="";
	String strPassword="";
	String strExportFile="";
	String strComment="";

	strKey=request.getParameter("objId");
	if(objSeq==0){
		Sql = "SELECT NEXTVAL('group_id') AS new_seq";
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
				document.form_main.txt_comment.value=singleNode.childNodes[2].text;
		        

			<%}%>



		/*
			arrArg = dialogArguments;
		//	window.focus();
		*/
		//	document.form_main.txt_name.focus();
		//	document.form_main.txt_name.select();

		}




		function regist(tp){

			//共通エラーチェックを先に行う
			if(!checkData()){return;}

			var userId="";
			for(i=0;i<document.form_main.lst_right.length;i++){
				if(i!=0){
					userId+=",";
				}
				userId+=document.form_main.lst_right.options[i].value;
			}

			<%if(objSeq==0){%>
				var strNewUserRow="";
				strNewUserRow+='<row ID=\"' + document.form_main.hid_group_id.value + '\" USER=\"' + userId + '\">';
				strNewUserRow+='<value>' + document.form_main.hid_group_id.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.txt_name.value + '</value>';
				strNewUserRow+='<value>' + document.form_main.txt_comment.value + '</value>';
				strNewUserRow+='</row>';

				var singleNode=openerFrame.parent.XMLData.selectSingleNode("//rows");
				singleNode.appendChild(textToDomObj(strNewUserRow));


			<%}else if(objSeq!=0){%>

				var singleNode=openerFrame.parent.XMLData.selectSingleNode("//row[@ID='" + document.form_main.hid_group_id.value + "']");

				singleNode.attributes.getNamedItem("USER").value=userId;
				singleNode.childNodes[1].text=document.form_main.txt_name.value;
				singleNode.childNodes[2].text=document.form_main.txt_comment.value;

		//	alert(singleNode.attributes.getNamedItem("USER").value);

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
					showMsg("CMN1","利用可能ユーザー");
				}else if(tp==1){
					showMsg("CMN1","選択ユーザー");
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
	<table class="Header" style="border-collapse:collapse;border:none">
		<tr>
			<td class="HeaderTitleLeft"></td>
			<td class="HeaderTitleCenter">グループ情報
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
					<input type="hidden" name="hid_group_id" value="<%=strKey%>">
					<tr>
						<td align="right"><span class="title">グループ名：</span></td>
						<td>
							<input type="text" name="txt_name" size="60" value="" mON="グループ名" maxlength="30">
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

				<table>
					<tr>
						<td id="td_left_move" style="padding-left:66">
							<span class="title">利用可能ユーザー：</span><br>
							<select name="lst_left" size="12" multiple style="width:200;margin-right:0">
<%
	int lstCnt=-1;

	Sql = " select distinct u.user_id,u.name,'' as selectedFlg from oo_v_user u";
	if(!"".equals(tempUserId)){
		Sql += " where u.user_id not in (" + tempUserId + ")";
		Sql += " union";
		Sql += " select u.user_id,u.name,'selected' as selectedFlg from oo_v_user u";
		Sql += " where u.user_id in (" + tempUserId + ")";
	}
	Sql += " ORDER BY 1"; 

	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		lstCnt++;
		out.println("<option orderno='" + lstCnt + "' value='" + rs.getString("user_id") + "' " + rs.getString("selectedFlg") + ">" + rs.getString("name") + "</option>");
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
							<span class="title">選択ユーザー：</span><br>
							<select name="lst_right" size="12" multiple style="width:200;margin-right:0">
							</select>
						</td>
					</tr>
				</table>
<%//=Sql%>
				<div class="command">
					<%if(objSeq==0){%>
						<!-- **************************  新規　ボタン ***************************** -->
						<input type="button" name="crt_btn" value="" onclick="javaScript:regist(0);" class="normal_create_mini" onMouseOver="className='over_create_mini'" onMouseDown="className='down_create_mini'" onMouseUp="className='up_create_mini'" onMouseOut="className='out_create_mini'">
					<%}else{%>
						<!-- **************************  更新　ボタン ***************************** -->
						<input type="button" name="edi_btn" value="" class="normal_update" onClick="javaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
						<!-- **************************  削除　ボタン ***************************** -->
						<input type="button" name="del_btn" value="" class="normal_delete" onClick="javaScript:regist(2);" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
					<%}%>
					<input type = 'button' value='' onclick="self.window.close();" class="normal_cancel" onMouseOver="className='over_cancel'" onMouseDown="className='down_cancel'" onMouseUp="className='up_cancel'" onMouseOut="className='out_cancel'">
				</div>

	</div>

	</form>
</body>
</html>


<%@ include file="../../connect_close.jsp" %>
