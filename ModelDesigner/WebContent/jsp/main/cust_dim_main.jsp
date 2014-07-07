<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*" %>
<%@ include file="../../connect_session.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
//	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	int dimSeq = Integer.parseInt(request.getParameter("dimSeq"));
	session.putValue("dimSeq",""+dimSeq);//regist_check用
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));

	/////SessionにConnect情報をいれる。
	session.putValue(session.getId()+"Conn",connMeta);
	session.putValue(session.getId()+"Stmt",stmt);
	session.putValue(session.getId()+"Stmt2",stmt);
	session.putValue(session.getId()+"Stmt3",stmt);



	String strName="";
	String strComment="";
	String strAddMemberFlg="1";
	String strDeleteMemberFlg="1";
	String strRenameMemberFlg="1";
	String strSegDataType="1";


	Sql = "SELECT oo_dimension_part.name,oo_dimension_part.comment";
	Sql = Sql + " ,coalesce(oo_dimension_part.add_member_flg,'1') AS add_member_flg";
	Sql = Sql + " ,coalesce(oo_dimension_part.rename_member_flg,'1') AS rename_member_flg";
	Sql = Sql + " ,coalesce(oo_dimension_part.delete_member_flg,'1') AS delete_member_flg";
	Sql = Sql + " ,oo_dimension.seg_datatype";
	Sql = Sql + " FROM oo_dimension_part";
	Sql = Sql + " ,oo_dimension";
	Sql = Sql + " WHERE oo_dimension_part.dimension_seq = oo_dimension.dimension_seq";
	Sql = Sql + " AND oo_dimension_part.dimension_seq = " + dimSeq;
	Sql = Sql + " AND oo_dimension_part.part_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strName = rs.getString("name");
		strComment = rs.getString("comment");
		strAddMemberFlg = rs.getString("add_member_flg");
		strDeleteMemberFlg = rs.getString("delete_member_flg");
		strRenameMemberFlg = rs.getString("rename_member_flg");
		strSegDataType = rs.getString("seg_datatype");
		session.putValue("strSegDataType",strSegDataType);
	}
	rs.close();


%>

<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">

	<script language="JavaScript">

		function synchro(){
			document.form_main.action = "../hidden/cust_dim_synchro.jsp";
			document.form_main.target = "iframe_main";
			document.form_main.submit();
		}



		function regist(tp) {


			if(tp!=2){
				//共通エラーチェックを先に行う
				if(!checkData()){return;}
			}

			<%//if(objSeq==0){%>
			document.form_main.hid_name.value=document.form_main.txt_name.value;
			<%if("1".equals(session.getValue("dimType"))){%>
			document.form_main.hid_add_flg.value=document.form_main.lst_add_flg.value;
			document.form_main.hid_delete_flg.value=document.form_main.lst_delete_flg.value;
			document.form_main.hid_rename_flg.value=document.form_main.lst_rename_flg.value;
			<%}%>
			submitData("cust_dim_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);
			<%//}else{%>
			<%//}%>

		}


	</script>
</head>

<body>

<form name="form_main" id="form_main" method="post" action="">
	<!-- レイアウト用 -->
	<div class="main" id="dv_main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main" style="padding-left:10px;padding-right:10px">
			
 				<!-- コンテンツ -->
				<!-- **************************  MAIN TABLE <1>***************************** -->
				<table class="standard">
					<%if(objSeq!=0){%>
					<tr>
						<th class="standard" width="150">パーツID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<%}%>
					<tr>
						<th width="150" class="standard">パーツ名</th>
						<td class="standard">
							<input type="text" name="txt_name" value="<%=strName%>" mON="パーツ名" maxlength="30" size="60" onchange="setChangeFlg();" <%if(objSeq==1){out.print("disabled");}%>>
						</td>
					</tr>
					<tr>
						<th width="150" class="standard">コメント</th>
						<td class="standard">
							<input type="text" name="txt_comment" value="<%=strComment%>" mON="コメント" maxlength="250" size="80" onchange="setChangeFlg();">
						</td>
					</tr>
<%if("1".equals(session.getValue("dimType"))){%>
					<tr>
						<th class="standard" colspan="2">マスターテーブルと同期</th>
					</tr>
					<tr>
						<th class="standard">メンバー追加</th>
						<td class="standard">
							<select name = "lst_add_flg" onchange="setChangeFlg()" <%if(objSeq==1){out.print("disabled");}%>>
								<option value = '1' <%if (strAddMemberFlg.equals("1")) out.println("selected");%>>On</option>
								<option value = '0' <%if (strAddMemberFlg.equals("0")) out.println("selected");%>>Off</option>
							</select>
							<span class="note">マスターテーブルに追加されたメンバーを反映する。 </span>
						</td>
					</tr>
					<tr>
						<th class="standard">メンバーの削除</th>
						<td class="standard">
							 <select name = "lst_delete_flg" onchange="setChangeFlg()" <%if(objSeq==1){out.print("disabled");}%>>
								<option value = '1' <%if (strDeleteMemberFlg.equals("1")) out.println("selected");%>>On</option>
								<option value = '0' <%if (strDeleteMemberFlg.equals("0")) out.println("selected");%>>Off</option>
							 </select>
							<span class="note">マスターテーブルから削除されたメンバーを反映する。 </span>
						</td>
					</tr>
					<tr>
						<th class="standard">メンバー名の変更</th>
						<td class="standard">
							 <select name = "lst_rename_flg" onchange="setChangeFlg()" <%if(objSeq==1){out.print("disabled");}%>>
								<option value = '1' <%if (strRenameMemberFlg.equals("1")) out.println("selected");%>>On</option>
								<option value = '0' <%if (strRenameMemberFlg.equals("0")) out.println("selected");%>>Off</option>
							 </select>
							<span class="note"> マスターテーブルのメンバー名を反映する。 </span>
						</td>
					</tr>
<%}%>
				</table>

				<%if(objSeq!=0){%>
				<%if("1".equals(session.getValue("dimType"))){%>
				<div class="command">
					<input type="button" value="" onclick="synchro()" class="normal_synchro" onMouseOver="className='over_synchro'" onMouseDown="className='down_synchro'" onMouseUp="className='up_synchro'" onMouseOut="className='out_synchro'">
				</div>
				<%}%>
				<iframe name="iframe_main" src="../frm_cust_dim_control.jsp?dimSeq=<%=request.getParameter("dimSeq")%>&objSeq=<%=request.getParameter("objSeq")%>" width="100%" height="230"></iframe>
				<%}%>

				<div class="command">
					<%
					if(objSeq==0){
					%><input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(0);" class="normal_create" onMouseOver="className='over_create'" onMouseDown="className='down_create'" onMouseUp="className='up_create'" onMouseOut="className='out_create'"><%
					}else if(objSeq==1){
					%><input type="button" name="edt_btn" value="" onClick="JavaScript:regist(1);" class="normal_update" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'"><%
					}else{
					%><input type="button" name="edt_btn" value="" onClick="JavaScript:regist(1);" class="normal_update" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
					<input type="button" name="del_btn" value="" onClick="JavaScript:regist(2);" class="normal_delete" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'"><%
					}
					%>
				</div>

			</td>
			<td class="right"></td>
		</tr>
		<tr>
			<td class="left_bottom"></td>
			<td class="bottom"></td>
			<td class="right_bottom"></td>
		</tr>
	</table>
	</div>


<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>
<input type="hidden" name="hid_drag_flg" id="hid_drag_flg" value="0">
<input type="hidden" name="hid_name" value="">
<input type="hidden" name="hid_add_flg" value="">
<input type="hidden" name="hid_delete_flg" value="">
<input type="hidden" name="hid_rename_flg" value="">
<input type="hidden" name="hid_dim_seq" id="hid_dim_seq" value="<%=dimSeq%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>


