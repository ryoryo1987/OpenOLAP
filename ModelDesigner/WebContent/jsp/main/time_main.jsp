<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*, java.net.*" %>
<%@ include file="../../connect.jsp"%>
<%!
	private String CHECK_FLG(String flg) {
		if ("1".equals(flg)) {
			return "checked";
		} else {
			return "";
		}
	}
%>

<%
	String Sql;
	String objKind = request.getParameter("objKind");
	int objSeq = Integer.parseInt(request.getParameter("objSeq"));





	String tempTimeList = "";
	String strSelect = "";


	String strName="";
	String strComment="";
	String strStartMonth="04";
	String strTotalFlg="0";
	String strYearFlg="1";
	String strYearLongName="";
	String strYearShortName="";
	String strHalfFlg="";
	String strHalfLongName="";
	String strHalfShortName="";
	String strQuarterFlg="";
	String strQuarterLongName="";
	String strQuarterShortName="";
	String strMonthFlg="1";
	String strMonthLongName="";
	String strMonthShortName="";
	String strWeekFlg="";
	String strWeekKindFlg="Y";
	String strWeekYearLongName="";
	String strWeekYearShortName="";
	String strWeekMonthLongName="";
	String strWeekMonthShortName="";
	String strDayFlg="";
	String strDayLongName="";
	String strDayShortName="";
	String strTimeLength="";
	String strTimePastSpan="0";
	String strTimeFutureSpan="0";


	Sql = 		"select ";
	Sql = Sql + " time_seq";
	Sql = Sql + ",name";
	Sql = Sql + ",comment";
	Sql = Sql + ",start_month";
	Sql = Sql + ",total_flg";
	Sql = Sql + ",year_flg";
	Sql = Sql + ",year_long_name";
	Sql = Sql + ",year_short_name";
	Sql = Sql + ",half_flg";
	Sql = Sql + ",half_long_name";
	Sql = Sql + ",half_short_name";
	Sql = Sql + ",quarter_flg";
	Sql = Sql + ",quarter_long_name";
	Sql = Sql + ",quarter_short_name";
	Sql = Sql + ",month_flg";
	Sql = Sql + ",month_long_name";
	Sql = Sql + ",month_short_name";
	Sql = Sql + ",week_flg";
	Sql = Sql + ",week_kind_flg";
	Sql = Sql + ",week_long_name";
	Sql = Sql + ",week_short_name";
	Sql = Sql + ",day_flg";
	Sql = Sql + ",day_long_name";
	Sql = Sql + ",day_short_name";
	Sql = Sql + ",time_length";
	Sql = Sql + ",time_past_span";
	Sql = Sql + ",time_future_span";
	Sql = Sql + " FROM oo_time";
	Sql = Sql + " WHERE time_seq = " + objSeq + "";
	rs = stmt.executeQuery(Sql);
	if (rs.next()) {
		strName = rs.getString("name");
		strComment = rs.getString("comment");
		strStartMonth = rs.getString("start_month");
		strTotalFlg = rs.getString("total_flg");
		strYearFlg = rs.getString("year_flg");
		strYearLongName = rs.getString("year_long_name");
		strYearShortName = rs.getString("year_short_name");
		strHalfFlg = rs.getString("half_flg");
		strHalfLongName = rs.getString("half_long_name");
		strHalfShortName = rs.getString("half_short_name");
		strQuarterFlg = rs.getString("quarter_flg");
		strQuarterLongName = rs.getString("quarter_long_name");
		strQuarterShortName = rs.getString("quarter_short_name");
		strMonthFlg = rs.getString("month_flg");
		strMonthLongName = rs.getString("month_long_name");
		strMonthShortName = rs.getString("month_short_name");
		strWeekFlg = rs.getString("week_flg");
		strWeekKindFlg = rs.getString("week_kind_flg");
		if("Y".equals(strWeekKindFlg)){
			strWeekYearLongName = rs.getString("week_long_name");
			strWeekYearShortName = rs.getString("week_short_name");
		}else if("M".equals(strWeekKindFlg)){
			strWeekMonthLongName = rs.getString("week_long_name");
			strWeekMonthShortName = rs.getString("week_short_name");
		}
		strDayFlg = rs.getString("day_flg");
		strDayLongName = rs.getString("day_long_name");
		strDayShortName = rs.getString("day_short_name");
		strTimeLength = rs.getString("time_length");
		strTimePastSpan = rs.getString("time_past_span");
		strTimeFutureSpan = rs.getString("time_future_span");
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
		<!--

		function load(){
			disableCheck();
		}

		function disableCheck(){
			if(document.form_main.chk_year_flg.checked==true){
			//	document.form_main.rdo_week_kind[0].disabled=false;
				document.form_main.lst_year_long_name.disabled=false;
				document.form_main.lst_year_short_name.disabled=false;
			}else{
			//	document.form_main.rdo_week_kind[0].disabled=true;
				document.form_main.lst_year_long_name.disabled=true;
				document.form_main.lst_year_short_name.disabled=true;
			}
			if(document.form_main.chk_half_flg.checked==true){
				document.form_main.lst_half_long_name.disabled=false;
				document.form_main.lst_half_short_name.disabled=false;
			}else{
				document.form_main.lst_half_long_name.disabled=true;
				document.form_main.lst_half_short_name.disabled=true;
			}
			if(document.form_main.chk_quarter_flg.checked==true){
				document.form_main.lst_quarter_long_name.disabled=false;
				document.form_main.lst_quarter_short_name.disabled=false;
			}else{
				document.form_main.lst_quarter_long_name.disabled=true;
				document.form_main.lst_quarter_short_name.disabled=true;
			}
			if(document.form_main.chk_month_flg.checked==true){
				document.form_main.lst_month_long_name.disabled=false;
				document.form_main.lst_month_short_name.disabled=false;
			}else{
				document.form_main.lst_month_long_name.disabled=true;
				document.form_main.lst_month_short_name.disabled=true;
			}
		//	if(document.form_main.chk_week_flg.checked==true){
		//		document.form_main.rdo_week_kind[0].disabled=false;
		//		document.form_main.rdo_week_kind[1].disabled=false;
		//	}else{
		//		document.form_main.rdo_week_kind[0].disabled=true;
		//		document.form_main.rdo_week_kind[1].disabled=true;
		//	}
		//	if(document.form_main.chk_month_flg.checked==true){
		//		document.form_main.rdo_week_kind[0].disabled=true;
		//		document.form_main.rdo_week_kind[1].checked=true;
		//	}
			if(document.form_main.chk_week_flg.checked==true){
				document.form_main.rdo_week_kind[0].disabled=false;
				document.form_main.rdo_week_kind[1].disabled=false;
				if((document.form_main.chk_half_flg.checked==true)||(document.form_main.chk_quarter_flg.checked==true)||(document.form_main.chk_month_flg.checked==true)){
					document.form_main.rdo_week_kind[1].checked=true;//年週が選択できるのは上のレベルがない、もしくは年レベルのみの場合の時だけ。
					document.form_main.rdo_week_kind[0].disabled=true;
				}
			//	if(document.form_main.rdo_week_kind[0].checked==true){
			//		document.form_main.lst_week_year_long_name.disabled=false;
			//		document.form_main.lst_week_year_short_name.disabled=false;
			//		document.form_main.lst_week_month_long_name.disabled=true;
			//		document.form_main.lst_week_month_short_name.disabled=true;
			//	}else if(document.form_main.rdo_week_kind[1].checked==true){
			//		document.form_main.lst_week_year_long_name.disabled=true;
			//		document.form_main.lst_week_year_short_name.disabled=true;
			//		document.form_main.lst_week_month_long_name.disabled=false;
			//		document.form_main.lst_week_month_short_name.disabled=false;
			//	}
			}else{
				document.form_main.rdo_week_kind[0].disabled=true;
				document.form_main.rdo_week_kind[1].disabled=true;
			}
			if((document.form_main.rdo_week_kind[0].disabled==true)||(document.form_main.rdo_week_kind[0].checked==false)){
				document.form_main.lst_week_year_long_name.disabled=true;
				document.form_main.lst_week_year_short_name.disabled=true;
			}else{
				document.form_main.lst_week_year_long_name.disabled=false;
				document.form_main.lst_week_year_short_name.disabled=false;
			}
			if((document.form_main.rdo_week_kind[1].disabled==true)||(document.form_main.rdo_week_kind[1].checked==false)){
				document.form_main.lst_week_month_long_name.disabled=true;
				document.form_main.lst_week_month_short_name.disabled=true;
			}else{
				document.form_main.lst_week_month_long_name.disabled=false;
				document.form_main.lst_week_month_short_name.disabled=false;
			}
			if(document.form_main.chk_day_flg.checked==true){
				document.form_main.lst_day_long_name.disabled=false;
				document.form_main.lst_day_short_name.disabled=false;
			}else{
				document.form_main.lst_day_long_name.disabled=true;
				document.form_main.lst_day_short_name.disabled=true;
			}
		}


		function regist(tp) {

			//新規/更新時エラーチェック&登録
			if (tp!=2) {

				document.form_main.hid_year_long_name.value=document.form_main.lst_year_long_name.value;
				document.form_main.hid_year_short_name.value=document.form_main.lst_year_short_name.value;
				document.form_main.hid_half_long_name.value=document.form_main.lst_half_long_name.value;
				document.form_main.hid_half_short_name.value=document.form_main.lst_half_short_name.value;
				document.form_main.hid_quarter_long_name.value=document.form_main.lst_quarter_long_name.value;
				document.form_main.hid_quarter_short_name.value=document.form_main.lst_quarter_short_name.value;
				document.form_main.hid_month_long_name.value=document.form_main.lst_month_long_name.value;
				document.form_main.hid_month_short_name.value=document.form_main.lst_month_short_name.value;
				if(document.form_main.rdo_week_kind[0].checked==true){
					document.form_main.hid_week_kind.value="Y";
				}else if(document.form_main.rdo_week_kind[1].checked==true){
					document.form_main.hid_week_kind.value="M";
				}
				document.form_main.hid_week_year_long_name.value=document.form_main.lst_week_year_long_name.value;
				document.form_main.hid_week_year_short_name.value=document.form_main.lst_week_year_short_name.value;
				document.form_main.hid_week_month_long_name.value=document.form_main.lst_week_month_long_name.value;
				document.form_main.hid_week_month_short_name.value=document.form_main.lst_week_month_short_name.value;
				document.form_main.hid_day_long_name.value=document.form_main.lst_day_long_name.value;
				document.form_main.hid_day_short_name.value=document.form_main.lst_day_short_name.value;


				if(
				(document.form_main.chk_year_flg.checked==false)
				&&(document.form_main.chk_half_flg.checked==false)
				&&(document.form_main.chk_quarter_flg.checked==false)
				&&(document.form_main.chk_month_flg.checked==false)
				&&(document.form_main.chk_week_flg.checked==false)
				&&(document.form_main.chk_day_flg.checked==false)
				){
					showMsg("TIM1");
					return;
				}


				if(!(isNaN(document.form_main.txt_time_past_integer.value))&&!(isNaN(document.form_main.txt_time_future_integer.value))){
					if(document.form_main.txt_time_past_integer.value*-1>document.form_main.txt_time_future_integer.value){
						showMsg("TIM3");
						document.form_main.txt_time_past_integer.focus();
						document.form_main.txt_time_past_integer.select();
						return;
					}
				}

			}

			submitData("time_regist.jsp",tp,"<%=objKind%>","<%=objSeq%>",document.form_main.txt_name.value);


		}
		-->
	</Script>

</head>

<body onload="load()">

<form name="form_main" method="post" action="">

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
				<!-- **************************  MAIN TABLE <1-1>***************************** -->
				<table class="standard">
					<%if(!(objSeq==0)){%>
					<tr>
						<th width="25%" class="standard">時間ディメンションID</th>
						<td width="75%" class="standard">
							<%=objSeq%>
						</td>
					</tr>
					<%}%>
					<tr>
						<th width="25%" class="standard">時間ディメンション名</th>
						<td width="75%" class="standard">
							<input type="text" name="txt_name" value="<%=strName%>" mON="時間ディメンション名" maxlength="30" size="60" onchange="setChangeFlg();">
						</td>
					</tr>
					<tr>
						<th width="25%" class="standard">コメント</th>
						<td width="75%" class="standard">
							<input type="text" name="txt_comment" value="<%=strComment%>" mON="コメント" maxlength="250" size="80" onchange="setChangeFlg();">
						</td>
					</tr>

					<tr>
						<th class="standard">開始月</th>

						<td  class="standard">
							<select name="lst_start_month" mON="開始月" onchange="setChangeFlg();">
								<option value="01" <%if("01".equals(strStartMonth)){out.print("selected");}%>>１月</option>
								<option value="02" <%if("02".equals(strStartMonth)){out.print("selected");}%>>２月</option>
								<option value="03" <%if("03".equals(strStartMonth)){out.print("selected");}%>>３月</option>
								<option value="04" <%if("04".equals(strStartMonth)){out.print("selected");}%>>４月</option>
								<option value="05" <%if("05".equals(strStartMonth)){out.print("selected");}%>>５月</option>
								<option value="06" <%if("06".equals(strStartMonth)){out.print("selected");}%>>６月</option>
								<option value="07" <%if("07".equals(strStartMonth)){out.print("selected");}%>>７月</option>
								<option value="08" <%if("08".equals(strStartMonth)){out.print("selected");}%>>８月</option>
								<option value="09" <%if("09".equals(strStartMonth)){out.print("selected");}%>>９月</option>
								<option value="10" <%if("10".equals(strStartMonth)){out.print("selected");}%>>１０月</option>
								<option value="11" <%if("11".equals(strStartMonth)){out.print("selected");}%>>１１月</option>
								<option value="12" <%if("12".equals(strStartMonth)){out.print("selected");}%>>１２月</option>
							</select>
							<!-- 月 -->
						</td>
					</tr>
					<tr>
						<th class="standard">合計値</th>
						<td class="standard">
							<input type="checkbox" name="chk_total_flg" value="1" mON="合計値" onchange="setChangeFlg();" <%=CHECK_FLG(strTotalFlg)%>>
						</td>
					</tr>

				</table>



				<!-- **************************  MAIN TABLE 年度<2>***************************** -->
				<!-- **************************  MAIN TABLE 時間軸構成<2>***************************** -->
				<table class="standard">
					<tr>
						<th class="standard">時間ディメンション構成</th>
					</tr>
					<tr>
						<td class="standard" style="padding : 10px 0px 0px 20px">
						<!-- *******************  SUB TABLE SUB 時間軸構成<2>******************* -->
						<table style="border-collapse:collapse">
							<tr>
								<td rowspan="2" valign="top" width="70">
									<input type="checkbox" name="chk_year_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strYearFlg)%>> 年
								</td>
								<td width="75">ロングネーム</td>
								<td>
									：
									<select name="lst_year_long_name" mON="年：ロングネーム" onchange="setChangeFlg();">
										<%

											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";

										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'YEAR'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strYearLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<select name="lst_year_short_name" mON="年：ショートネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";
										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'YEAR'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strYearShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>
							
							<tr>
								<td rowspan="2" valign="top">
									<input type="checkbox" name="chk_half_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strHalfFlg)%>> 半期
								</td>
								<td>ロングネーム</td>
								<td>
									：
									<select name="lst_half_long_name" mON="半期：ロングネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";

										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'HALF'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strHalfLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<select name="lst_half_short_name" mON="半期：ショートネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";

										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'HALF'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strHalfShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>

							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>

							<tr>
								<td rowspan="2" valign="top">
									<input type="checkbox" name="chk_quarter_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strQuarterFlg)%>>四半期
								</td>
								<td>ロングネーム</td>
								<td>
									：
									<select name="lst_quarter_long_name" mON="四半期：ロングネーム" onchange="setChangeFlg();">
										<%
										tempTimeList = "";
										Sql = "";
										strSelect = "";

										tempTimeList = "<option value=\"\">---選択してください---</option>\n";

									 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
									 	Sql = Sql + " WHERE TIME_KIND_CD = 'QUARTER'";

										rs = stmt.executeQuery(Sql);

										while (rs.next()) {
											if (strQuarterLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
												strSelect = " selected>";
											} else {
												strSelect = ">";
											}
											tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

										}
										rs.close();

										out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<select name="lst_quarter_short_name" mON="四半期：ショートネーム" onchange="setChangeFlg();">
										<%
										tempTimeList = "";
										Sql = "";
										strSelect = "";

										tempTimeList = "<option value=\"\">---選択してください---</option>\n";

									 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
									 	Sql = Sql + " WHERE TIME_KIND_CD = 'QUARTER'";

										rs = stmt.executeQuery(Sql);

										while (rs.next()) {
											if (strQuarterShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
												strSelect = " selected>";
											} else {
												strSelect = ">";
											}
											tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

										}
										rs.close();

										out.println(tempTimeList);
										%>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>
							
							<tr>
								<td rowspan="2" valign="top">
									<input type="checkbox" name="chk_month_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strMonthFlg)%>>月
								</td>
								<td>ロングネーム</td>
								<td>
									：
									<select name="lst_month_long_name" mON="月：ロングネーム" onchange="setChangeFlg();">
										<%
										tempTimeList = "";
										Sql = "";
										strSelect = "";

										tempTimeList = "<option value=\"\">---選択してください---</option>\n";

									 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
									 	Sql = Sql + " WHERE TIME_KIND_CD = 'MONTH'";

										rs = stmt.executeQuery(Sql);

										while (rs.next()) {
											if (strMonthLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
												strSelect = " selected>";
											} else {
												strSelect = ">";
											}
											tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

										}
										rs.close();

										out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<select name="lst_month_short_name" mON="年：ショートネーム" onchange="setChangeFlg();">
										<%
										tempTimeList = "";
										Sql = "";
										strSelect = "";

										tempTimeList = "<option value=\"\">---選択してください---</option>\n";

									 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
									 	Sql = Sql + " WHERE TIME_KIND_CD = 'MONTH'";

										rs = stmt.executeQuery(Sql);

										while (rs.next()) {
											if (strMonthShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
												strSelect = " selected>";
											} else {
												strSelect = ">";
											}
											tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

										}
										rs.close();

										out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>
							
							<tr>
								<td rowspan="3">
									<input type="checkbox" name="chk_week_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strWeekFlg)%>>週
								</td>
								<td></td>
								<td>
									&nbsp; <input type="radio" name="rdo_week_kind" value="Y" <%if("Y".equals(strWeekKindFlg)){out.print("checked");}%> onClick="JavaScript:disableCheck();setChangeFlg();">週（年）
									
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="radio" name="rdo_week_kind" value="M" <%if("M".equals(strWeekKindFlg)){out.print("checked");}%> onClick="JavaScript:disableCheck();setChangeFlg();">週（月）
								
								</td>
							</tr>
							<tr>
								<td>ロングネーム</td>
								<td>
									：
									<!-- Week Year用 -->
									<select name="lst_week_year_long_name" mON="週（年）：ロングネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";


											tempTimeList = "<option value=\"\">---選択してください---</option>\n";

										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'WEEK_Y'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strWeekYearLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
														}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>&nbsp;
									<!-- Week Month用 -->
									<select name="lst_week_month_long_name" mON="週（月）：ロングネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";


										tempTimeList = "<option value=\"\">---選択してください---</option>\n";

										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'WEEK_M'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strWeekMonthLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
														}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<!-- Week Year用 -->
									<select name="lst_week_year_short_name" mON="週（年）：ショートネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";


										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'WEEK_Y'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strWeekYearShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>&nbsp;
									<!-- Week Month用 -->
									<select name="lst_week_month_short_name" mON="週（月）：ショートネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";


										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'WEEK_M'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strWeekMonthShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>

								</td>
							</tr>
							
							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>
							
							<tr>
								<td rowspan="2" valign="top">
									<input type="checkbox" name="chk_day_flg" value="1" onClick="JavaScript:disableCheck();setChangeFlg();" <%=CHECK_FLG(strDayFlg)%>>日
								</td>
								<td>ロングネーム</td>
								<td>
									：
									<select name="lst_day_long_name" mON="日：ロングネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";


										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'DAY'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strDayLongName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);

										%>
									</select>
								</td>
							</tr>
							<tr>
								<td>ショートネーム</td>
								<td>
									：
									<select name="lst_day_short_name" mON="日：ショートネーム" onchange="setChangeFlg();">
										<%
											tempTimeList = "";
											Sql = "";
											strSelect = "";

											tempTimeList = "<option value=\"\">---選択してください---</option>\n";


										 	Sql = "SELECT TIME_NAME_FORMAT_CD,TIME_NAME FROM oo_TIME_FORMAT";
										 	Sql = Sql + " WHERE TIME_KIND_CD = 'DAY'";

											rs = stmt.executeQuery(Sql);

											while (rs.next()) {
												if (strDayShortName.equals(rs.getString("TIME_NAME_FORMAT_CD"))) {
													strSelect = " selected>";
												} else {
													strSelect = ">";
												}
												tempTimeList = tempTimeList + "<option value=\"" + rs.getString("TIME_NAME_FORMAT_CD") + "\"" + strSelect + rs.getString("TIME_NAME") + "</option>\n";

											}
											rs.close();

											out.println(tempTimeList);
										%>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="3" style="height:10px"></td>
							</tr>
							
							<tr>
								<td colspan="3">
									<!-- Time Lengthテーブル -->
									<table class="standard" style="width:100%">
										<tr>
											<th class="standard">データ保持期間</th>
										</tr>
										<tr>
											<td class="standard" style="width:"100%">
												<br>
												&nbsp;&nbsp;データ保持期間：
												<select name="lst_time_length" mON="データ保持期間" onchange="setChangeFlg();">
													<option value="12" <%if("12".equals(strTimeLength)){out.print("selected");}%>>年</option>
													<option value="6" <%if("6".equals(strTimeLength)){out.print("selected");}%>>半期</option>
													<option value="3" <%if("3".equals(strTimeLength)){out.print("selected");}%>>四半期</option>
													<option value="1" <%if("1".equals(strTimeLength)){out.print("selected");}%>>月</option>
												</select>
												&nbsp;過去：<input type="text" name="txt_time_past_integer" mON="データ保持期間:過去" value="<%=strTimePastSpan%>" maxlength="3" size="5" onchange="setChangeFlg();">
												&nbsp;&nbsp;未来：<input type="text" name="txt_time_future_integer" mON="データ保持期間:未来" value="<%=strTimeFutureSpan%>" maxlength="3" size="5" onchange="setChangeFlg();">
												<br><br>
											</td>
										</tr>
									</table>
									
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
					
			<div class="command">
				<%if(objSeq==0){%>
					<input type="button" name="crt_btn" value="" class="normal_create" onClick="JavaScript:regist(0);" onMouseOver="className='over_create'" onMouseDown="className='down_create'" onMouseUp="className='up_create'" onMouseOut="className='out_create'">
				<%}else{%>
					<input type="button" name="edi_btn" value="" class="normal_update" onClick="JavaScript:regist(1);" onMouseOver="className='over_update'" onMouseDown="className='down_update'" onMouseUp="className='up_update'" onMouseOut="className='out_update'">
					<input type="button" name="del_btn" value="" class="normal_delete" onClick="JavaScript:regist(2);" onMouseOver="className='over_delete'" onMouseDown="className='down_delete'" onMouseUp="className='up_delete'" onMouseOut="className='out_delete'">
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

	<input type="hidden" name="hid_year_long_name" value="">
	<input type="hidden" name="hid_year_short_name" value="">
	<input type="hidden" name="hid_half_long_name" value="">
	<input type="hidden" name="hid_half_short_name" value="">
	<input type="hidden" name="hid_quarter_long_name" value="">
	<input type="hidden" name="hid_quarter_short_name" value="">
	<input type="hidden" name="hid_month_long_name" value="">
	<input type="hidden" name="hid_month_short_name" value="">
	<input type="hidden" name="hid_week_kind" value="">
	<input type="hidden" name="hid_week_year_long_name" value="">
	<input type="hidden" name="hid_week_year_short_name" value="">
	<input type="hidden" name="hid_week_month_long_name" value="">
	<input type="hidden" name="hid_week_month_short_name" value="">
	<input type="hidden" name="hid_day_long_name" value="">
	<input type="hidden" name="hid_day_short_name" value="">


	<input type="hidden" name="hid_obj_seq" id="hid_obj_seq" value="<%=objSeq%>">
	<input type="hidden" name="hid_obj_kind" id="hid_obj_kind" value="<%=objKind%>">

</form>

</body>
</html>
