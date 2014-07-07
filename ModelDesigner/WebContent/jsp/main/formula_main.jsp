<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
	int cubeSeq = Integer.parseInt(request.getParameter("cubeSeq"));
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));


	String strName="";
	String strComment="";
	int intDataFlg=1;
	String strFormulaText="";

	Sql = "SELECT name,comment,data_flg,formula_text";
	Sql = Sql + " FROM oo_formula";
	Sql = Sql + " WHERE formula_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strName = rs.getString("name");
		strComment = rs.getString("comment");
		intDataFlg = rs.getInt("data_flg");
		strFormulaText = rs.getString("formula_text");
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

		function regist(tp) {
			submitData("formula_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);
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
			<td class="main" style="text-align:left">
			
 				<!-- コンテンツ -->
				<!-- **************************  MAIN TABLE <1>***************************** -->
				<table>
					<%if(objSeq!=0){%>
					<tr>
						<th class="standard">カスタムメジャーID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
						<td rowspan="6" style="padding-left:5px" width="400">
							<iframe src="formula_tree.jsp?cubeSeq=<%=cubeSeq%>" width="100%" height="290"></iframe>
						</td>
					</tr>
					<%}%>
					<tr>
						<th class="standard">カスタムメジャー名</th>
						<td class="standard">
							<input type="text" name="txt_name" value="<%=strName%>" mON="カスタムメジャー名" maxlength="30" size="60" onChange="setChangeFlg();">
						</td>
					<%if(objSeq==0){%>
						<td rowspan="5" style="padding-left:5px" width="400">
							<iframe src="formula_tree.jsp?cubeSeq=<%=cubeSeq%>" width="100%" height="270"></iframe>
						</td>
					<%}%>
					</tr>
					<tr>
						<th class="standard">コメント</th>
						<td class="standard">
							<input type="text" name="txt_comment" value="<%=strComment%>" mON="コメント" maxlength="250" size="80" onChange="setChangeFlg();">
						</td>
					</tr>
					<tr>
						<th class="standard">データの持ち方</th>
						<td class="standard">
							<input type="radio" name="rdo_data_flg" value="1" <%if(intDataFlg==1){out.print("checked");}%> onChange="setChangeFlg();">フォーミュラ形式
							<input type="radio" name="rdo_data_flg" value="2" <%if(intDataFlg==2){out.print("checked");}%> onChange="setChangeFlg();">実データ形式
						</td>
					</tr>
					<tr>
						<th class="standard" colspan="2">計算式</th>
					</tr>
					<tr>
						<td class="standard" colspan="2">
							<textarea name="are_formula" cols="90" rows="10" mON="計算式" onChange="setChangeFlg();"><%=strFormulaText%></textarea>
						</td>
					</tr>
				</table>



				<div class="command">
				<%if(objSeq==0){%>
				<!-- **************************  新規 ボタン ***************************** -->
					<input type="button" name="allcrt_btn" value="" onClick="JavaScript:regist(0);" class="normal_create" onMouseOver="className='over_create'" onMouseDown="className='down_create'" onMouseUp="className='up_create'" onMouseOut="className='out_create'">
				<%}else{%>
				<!-- **************************  更新 ボタン ***************************** -->
					<input type="button" name="edt_btn" value="" onClick="JavaScript:regist(1);" class="normal_update" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
					<input type="button" name="del_btn" value="" onClick="JavaScript:regist(2);" class="normal_delete" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
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


<!--隠しオブジェクト-->
<div name="div_hid" id="div_hid" style="display:none;"></div>

<input type="hidden" name="hid_right" id="hid_right" value="">
<input type="hidden" name="hid_cube_seq" id="hid_cube_seq" value="<%=cubeSeq%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>


