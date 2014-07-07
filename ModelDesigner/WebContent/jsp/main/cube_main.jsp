<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*, java.net.*" %>
<%@ include file="../../connect.jsp"%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
//	int userSeq = Integer.parseInt(request.getParameter("userSeq"));
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));



	String maxMeasure=(String)session.getValue("strMaxMeasure");


	String strName="";
	String strComment="";

	Sql = "SELECT name,comment";
	Sql = Sql + " FROM oo_cube";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		strName = rs.getString("name");
		strComment = rs.getString("comment");
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


		function load(){
		<%if(objSeq!=0){%>
			listMenuMove(0);
		<%}%>
		}



		function listMenuMove(tp) {
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

			if(document.form_main.elements[sourceList].selectedIndex==-1){
			if(tp==0){
				showMsg("CUB3");
			}else if(tp==1){
				showMsg("CUB8");
			}
				return;
			}


			var max_cnt = document.form_main.elements[sourceList].options.length;
/*
			for(i=0;i<max_cnt;i++){
				if(document.form_main.elements[sourceList].options[i].selected==true){
					if(document.form_main.elements[sourceList].options[i].value==""){
						showMsg("CUB3");
						return;
					}
				}
			}
*/
			for(i=0;i<max_cnt;i++){
				if(document.form_main.elements[sourceList].options[remainCnt].value==""){//ディメンションパターンの選択状態を解除
					document.form_main.elements[sourceList].options[remainCnt].selected=false;
				}
				if(document.form_main.elements[sourceList].options[remainCnt].selected==true){
					var addOption = document.createElement("OPTION");
					addOption.value = document.form_main.elements[sourceList].options[remainCnt].value;
					addOption.text = document.form_main.elements[sourceList].options[remainCnt].text;
					addOption.orderno = document.form_main.elements[sourceList].options[remainCnt].orderno;
					addOption.dim_strc = document.form_main.elements[sourceList].options[remainCnt].dim_strc;
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





		function regist(tp) {


			if(tp!=2){
				//共通エラーチェックを先に行う
				if(!checkData()){return;}

				if(document.form_main.lst_right.length==0){
					showMsg("CUB1");
					return;
				}
				if(document.form_main.lst_right.length><%=maxMeasure%>){
					showMsg("CUB7","<%=maxMeasure%>");
					return;
				}
				for(i=1;i<document.form_main.lst_right.length;i++){
					if(document.form_main.lst_right.options[i].dim_strc!=document.form_main.lst_right.options[0].dim_strc){
						showMsg("CUB2");
						return;
					}
				}
				document.form_main.hid_right.value="";
				for(i=0;i<document.form_main.lst_right.length;i++){
					if(i!=0){
						document.form_main.hid_right.value+=",";
					}
					document.form_main.hid_right.value+=document.form_main.lst_right.options[i].value;
				}
			}


			if(tp==1){
				showMsg("CUB6");
			}

			submitData("cube_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);
		}


	</script>
</head>

<body onload="load()">

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
						<th class="standard" width="150">キューブID</th>
						<td class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<%}%>
					<tr>
						<th class="standard" width="150">キューブ名</th>
						<td class="standard">
							<input type="text" name="txt_name" value="<%=strName%>" mON="キューブ名" maxlength="30" size="60" onChange="setChangeFlg();">
						</td>
					</tr>
					<tr>
						<th class="standard">コメント</th>
						<td class="standard">
							<input type="text" name="txt_comment" value="<%=strComment%>" mON="コメント" maxlength="250" size="80" onChange="setChangeFlg();">
						</td>
					</tr>
				</table>

				<!-- **************************  MAIN TABLE <2>***************************** -->
				<table  class="standard" id="tbl_main2">
					<tr>
						<th class="standard">メジャー</th>
					</tr>
					<tr>
						<td class="standard_center">
							<!-- **************************  SUB TABLE <1>***************************** -->
							<table class="layout">
								<tr>
									<td id="td_left_move">
										利用可能メジャー：<br>
										<select name="lst_left" size="12" multiple style="width:245;margin-right:0" onChange="setChangeFlg();">
<%

	String preDimStructure="";
	int lstCnt=-1;
	int dimStNo=0;

	Sql = ""; 
	Sql += " SELECT '' as selected_flag,m.measure_seq,m.name,oo_fun_mlink(m.measure_seq)||','||m.time_dim_flg AS dim_structure"; 
//	Sql += " FROM oo_measure m,oo_measure_link l"; 
//	Sql += " WHERE m.measure_seq=l.measure_seq"; 

	Sql += " FROM oo_measure m"; 
	Sql += " left outer join oo_measure_link l on (m.measure_seq=l.measure_seq)";
	Sql += " WHERE "; 


	Sql += " m.measure_seq not in (SELECT measure_seq FROM oo_cube_structure WHERE cube_seq = " + objSeq + ")";
	Sql += " UNION"; 
	Sql += " SELECT 'selected' as selected_flag,m.measure_seq,m.name,oo_fun_mlink(m.measure_seq)||','||m.time_dim_flg AS dim_structure"; 
//	Sql += " FROM oo_measure m,oo_measure_link l"; 
//	Sql += " WHERE m.measure_seq=l.measure_seq"; 
	Sql += " FROM oo_measure m"; 
	Sql += " left outer join oo_measure_link l on (m.measure_seq=l.measure_seq)";
	Sql += " WHERE "; 
	Sql += " m.measure_seq in (SELECT measure_seq FROM oo_cube_structure WHERE cube_seq = " + objSeq + ")";
	Sql += " ORDER BY dim_structure"; 
	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		if(!rs.getString("dim_structure").equals(preDimStructure)){
			lstCnt++;
			dimStNo++;
			out.println("<option value='' orderno='" + lstCnt + "' style='color:gray'>---ディメンションパターン" + dimStNo + "---</option>");
		}
		lstCnt++;
		out.println("<option value='" + rs.getString("measure_seq") + "' orderno='" + lstCnt + "' dim_strc='" + rs.getString("dim_structure") + "' style='color:black;' " + rs.getString("selected_flag") + ">" + rs.getString("name") + "</option>");
		preDimStructure=rs.getString("dim_structure");
	}
	rs.close();

%>
										</select>
									</td>
									<td align="center" width="80">
										<input type="button" name="add_btn" value="" onClick="JavaScript:listMenuMove(0);setChangeFlg();" class="normal_add" onMouseOver="className='over_add'" onMouseDown="className='down_add'" onMouseUp="className='up_add'" onMouseOut="className='out_add'">
<br>
										<input type="button" name="del_btn" value="" onClick="JavaScript:listMenuMove(1);setChangeFlg();" class="normal_remove" onMouseOver="className='over_remove'" onMouseDown="className='down_remove'" onMouseUp="className='up_remove'" onMouseOut="className='out_remove'">
									</td>
									<td id="td_right_move">
										選択メジャー：<br>
										<select name="lst_right" size="12" multiple style="width:245;margin-right:0" onChange="setChangeFlg();">
										</select>
									</td>
								</tr>
							</table>
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
<input type="hidden" name="hid_user_seq" id="hid_user_seq" value="<%//=userSeq%>">
<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>


