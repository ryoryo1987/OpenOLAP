<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ include file="../../connect.jsp" %>
<%!
private String strCheckFlg(String strFlg) {
	if (strFlg == null) {
		return "";
	} else {
		if (strFlg.equals("1")) {
			return "checked";
		} else {
			return "";
		}
	}
}
%>

<%
	String Sql="";
	String objKind = request.getParameter("objKind");
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));


	String strName = "";
	String strComment = "";
	String tableFlg = "1";
	String viewFlg = "1";


	Sql = "SELECT * FROM oo_user";
	Sql = Sql + " WHERE user_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		strName = rs.getString("name");
		if(rs.getString("comment")!=null) {
			strComment = rs.getString("comment");
		}
		tableFlg = rs.getString("TABLE_FLG");
		viewFlg = rs.getString("VIEW_FLG");

	}
	rs.close();
%>

<% // ------------------------------------------------------ %>

<html>
<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<script language="JavaScript" src="../js/registration.js"></script>
	<script language="JavaScript">

	function regist(tp) {


		if(tp!=2){
			//共通エラーチェックを先に行う
			if(!checkData()){return;}

			if((document.form_main.chk_tbl.checked==false)&&(document.form_main.chk_view.checked==false)){
				showMsg("USR1");
				return;
			}
		}

		submitData("user_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);

	}

	</script>
</head>

<body>

<form name="form_main" method="post" action="">
<!-- ******************      新規時        ****************** -->
	<!-- レイアウト用 -->
	<div class="main">
	<table class="frame">
		<tr>
			<td class="left_top"></td>
			<td class="top"></td>
			<td class="right_top"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="main">
			
				<!-- コンテンツ -->
	
				<!-- ************************** MAINTABLE <1>***************************** -->

				<table>
					<%if(!(objSeq==0)){%>
					<tr>
						<th width="100" class="standard">スキーマID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<%}%>
					<tr>
						<th width="100" class="standard">スキーマ名</th>
						<td class="standard">
							<input type="text" name="txt_name" size="60" value="<%=strName%>" onchange="setChangeFlg();" mON="スキーマ名" maxlength="30">
						</td>
					</tr>
					<tr>
						<th class="standard">コメント</th>
						<td class="standard">
							<input type="text" name="txt_comment" size="80" value="<%=strComment%>" onchange="setChangeFlg();" mON="コメント" maxlength="250">
						</td>
					</tr>
					<tr>
						<th class="standard">使用可能なソース</th>
						<td class="standard">
							<table>
								<tr>
									<td>テーブル</td>
									<td>
										：<input type="checkbox" name="chk_tbl" value="<%=tableFlg%>" onchange="setChangeFlg();" <%=strCheckFlg(tableFlg)%>>
									</td>
								</tr>
								<tr>
									<td>ビュー</td>
									<td>
										：<input type="checkbox" name="chk_view" value="<%=viewFlg%>" onchange="setChangeFlg();" <%=strCheckFlg(viewFlg)%>>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			
				<div class="command">
					<%if(objSeq==0){%>
						<!-- **************************  新規　ボタン ***************************** -->
						<input type="button" name="crt_btn" value="" onclick="javaScript:regist(0);" class="normal_create" onMouseOver="className='over_create'" onMouseDown="className='down_create'" onMouseUp="className='up_create'" onMouseOut="className='out_create'">
					<%}else{%>
						<!-- **************************  更新　ボタン ***************************** -->
						<input type="button" name="edi_btn" value="" class="normal_update" onClick="javaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
						<!-- **************************  削除　ボタン ***************************** -->
						<input type="button" name="del_btn" value="" class="normal_delete" onClick="javaScript:regist(2);" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
					<%}%>
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

<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
</form>
</body>
</html>
