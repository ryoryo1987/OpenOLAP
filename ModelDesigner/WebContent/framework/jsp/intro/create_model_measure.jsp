<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../../connect.jsp" %>

<html>
<head>
<title>ROLAPモデル新規作成ウィザード</title>
<link REL="stylesheet" TYPE="text/css" HREF="../../../jsp/css/common.css">
<script language="JavaScript" src="../js/common.js"></script>
<script language="JavaScript">

	function load(){
		listMenuMove(0);
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
			return;
		}
/*
		if(document.form_main.elements[sourceList].selectedIndex==-1){
			if(tp==0){
				showMsg("CMN1","利用可能ユーザー");
			}else if(tp==1){
				showMsg("CMN1","選択ユーザー");
			}
			return;
		}
*/
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


		var strMeasures="";
		for(j=0;j<document.form_main.lst_right.length;j++){
			if(strMeasures!=""){strMeasures+=",";}
		//	strMeasures+=document.form_main.lst_right.options[j].text;
			strMeasures+=document.form_main.lst_right.options[j].value;
		}
		document.form_main.measures.value=strMeasures;
		document.form_main.action="create_model_hidden.jsp";
		document.form_main.target="frm_hidden2";
		document.form_main.submit();


	}


	function wopen(url){
		document.form_main.action=url;
		document.form_main.target="_self";
		document.form_main.submit();
	}

</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post" action="">
<table class="Header">
	<tr>
		<td class="HeaderTitleLeft"></td>
		<td class="HeaderTitleCenter">
			ROLAPモデル新規作成（メジャーの選択）
		</td>
	</tr>
</table>

<div style="margin:10;height:250">
	
	<table>
		<tr>
			<td>
				<span class="title">利用可能メジャー：</span><br>
				<select name="lst_left" size="15" multiple style="width:225;margin-right:0">

<%
	int lstCnt=-1;
	String Sql="";
	Sql = " select m.measure_seq,m.name,'' as selectedFlg from (select a.* from oo_measure a,oo_user b where a.user_seq=b.user_seq and b.name='" + session.getValue("schema") + "') as m";
	if(!"".equals((String)session.getValue("ref_measures"))){
		Sql += " where m.measure_seq not in (" + (String)session.getValue("ref_measures") + ")";
		Sql += " union";
		Sql += " select m.measure_seq,m.name,'selected' as selectedFlg from (select a.* from oo_measure a,oo_user b where a.user_seq=b.user_seq and b.name='" + session.getValue("schema") + "') as m";
		Sql += " where m.measure_seq in (" + (String)session.getValue("ref_measures") + ")";
	}
	Sql += " ORDER BY 1"; 

	rs = stmt.executeQuery(Sql);
	while (rs.next()) {
		lstCnt++;
		out.println("<option orderno='" + lstCnt + "' value='" + rs.getString("measure_seq") + "' " + rs.getString("selectedFlg") + ">" + rs.getString("name") + "</option>");
	}
	rs.close();

%>
				</select>
			</td>
			<td align="center" width="80">
				<input type="button" name="add_btn" value="" onClick="JavaScript:listMenuMove(0);" class="normal_add" onMouseOver="className='over_add'" onMouseDown="className='down_add'" onMouseUp="className='up_add'" onMouseOut="className='out_add'">
<br><br>
				<input type="button" name="del_btn" value="" onClick="JavaScript:listMenuMove(1);" class="normal_remove" onMouseOver="className='over_remove'" onMouseDown="className='down_remove'" onMouseUp="className='up_remove'" onMouseOut="className='out_remove'">
			</td>
			<td>
				<span class="title">選択メジャー：</span><br>
				<select name="lst_right" size="15" multiple style="width:225;margin-right:0">
				</select>
			</td>
		</tr>
	</table>

	使用テーブル：<span id="span_tables"></span>

</div>




<div style="text-align:right;padding-right:20px;padding-top:8px;margin-top:15px;border-top:1 solid #CCCCCC">
	<input type="button" value="" onclick="parent.window.close();" class="normal_cancel_mini" onMouseOver="className='over_cancel_mini'" onMouseDown="className='down_cancel_mini'" onMouseUp="className='up_cancel_mini'" onMouseOut="className='out_cancel_mini'">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" value="" onclick="movePage('create_model_1.jsp')" class="normal_back_mini" onMouseOver="className='over_back_mini'" onMouseDown="className='down_back_mini'" onMouseUp="className='up_back_mini'" onMouseOut="className='out_back_mini'">
	<input type="button" value="" onclick="movePage('create_model_dimension.jsp')" class="normal_next" onMouseOver="className='over_next'" onMouseDown="className='down_next'" onMouseUp="className='up_next'" onMouseOut="className='out_next'">
</div>

<input type="hidden" id="fileName" name="fileName" value="create_model_measure.jsp">
<input type="hidden" id="measures" name="measures" value="">

</form>
</body>
</html>