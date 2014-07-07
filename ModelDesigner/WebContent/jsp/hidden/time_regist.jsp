<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%> 
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int tp = Integer.parseInt(request.getParameter("tp"));
int exeCount=0;


String strName = request.getParameter("txt_name");
String strComment = request.getParameter("txt_comment");
String strStartMonth = request.getParameter("lst_start_month");
String strTotalFlg;
if(request.getParameter("chk_total_flg")!=null){
	strTotalFlg="1";
}else{
	strTotalFlg="0";
}
String strYearFlg;
if(request.getParameter("chk_year_flg")!=null){
	strYearFlg="1";
}else{
	strYearFlg="0";
}
String strYearLongName = request.getParameter("hid_year_long_name");
String strYearShortName = request.getParameter("hid_year_short_name");
String strHalfFlg;
if(request.getParameter("chk_half_flg")!=null){
	strHalfFlg="1";
}else{
	strHalfFlg="0";
}
String strHalfLongName = request.getParameter("hid_half_long_name");
String strHalfShortName = request.getParameter("hid_half_short_name");
String strQuarterFlg;
if(request.getParameter("chk_quarter_flg")!=null){
	strQuarterFlg="1";
}else{
	strQuarterFlg="0";
}
String strQuarterLongName = request.getParameter("hid_quarter_long_name");
String strQuarterShortName = request.getParameter("hid_quarter_short_name");
String strMonthFlg;
if(request.getParameter("chk_month_flg")!=null){
	strMonthFlg="1";
}else{
	strMonthFlg="0";
}
String strMonthLongName = request.getParameter("hid_month_long_name");
String strMonthShortName = request.getParameter("hid_month_short_name");
String strWeekFlg;
if(request.getParameter("chk_week_flg")!=null){
	strWeekFlg="1";
}else{
	strWeekFlg="0";
}
String strWeekKindFlg=request.getParameter("hid_week_kind");
String strWeekLongName="";
String strWeekShortName="";
if(strWeekKindFlg.equals("Y")){
	strWeekLongName = request.getParameter("hid_week_year_long_name");
	strWeekShortName = request.getParameter("hid_week_year_short_name");
}else if(strWeekKindFlg.equals("M")){
	strWeekLongName = request.getParameter("hid_week_month_long_name");
	strWeekShortName = request.getParameter("hid_week_month_short_name");
}
String strDayFlg;
if(request.getParameter("chk_day_flg")!=null){
	strDayFlg="1";
}else{
	strDayFlg="0";
}
String strDayLongName = request.getParameter("hid_day_long_name");
String strDayShortName = request.getParameter("hid_day_short_name");
String strTimeLength = request.getParameter("lst_time_length");
String strTimePastSpan = request.getParameter("txt_time_past_integer");
String strTimeFutureSpan = request.getParameter("txt_time_future_integer");


String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

%>

<%



	if(tp==2){
		Sql = "DROP TABLE oo_dim_" + objSeq + "_1 cascade";
		try{
			exeCount = stmt.executeUpdate(Sql);
		}catch(Exception e){
		//	out.println("e"+e);
		}
	}

	Sql = "DELETE FROM oo_time";
	Sql = Sql + " WHERE time_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);


	if(tp==0){

		//SEQUENCE 取得
		Sql = "SELECT nextval('oo_dimension_seq') as seq_no";

		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();

	}

	if(tp!=2){

		//新規登録
		Sql = "INSERT INTO oo_time (";
		Sql = Sql + "time_seq";
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
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",'" + strStartMonth + "'";
		Sql = Sql + ",'" + strTotalFlg + "'";
		Sql = Sql + ",'" + strYearFlg + "'";
		Sql = Sql + ",'" + strYearLongName + "'";
		Sql = Sql + ",'" + strYearShortName + "'";
		Sql = Sql + ",'" + strHalfFlg + "'";
		Sql = Sql + ",'" + strHalfLongName + "'";
		Sql = Sql + ",'" + strHalfShortName + "'";
		Sql = Sql + ",'" + strQuarterFlg + "'";
		Sql = Sql + ",'" + strQuarterLongName + "'";
		Sql = Sql + ",'" + strQuarterShortName + "'";
		Sql = Sql + ",'" + strMonthFlg + "'";
		Sql = Sql + ",'" + strMonthLongName + "'";
		Sql = Sql + ",'" + strMonthShortName + "'";
		Sql = Sql + ",'" + strWeekFlg + "'";
		Sql = Sql + ",'" + strWeekKindFlg + "'";
		Sql = Sql + ",'" + strWeekLongName + "'";
		Sql = Sql + ",'" + strWeekShortName + "'";
		Sql = Sql + ",'" + strDayFlg + "'";
		Sql = Sql + ",'" + strDayLongName + "'";
		Sql = Sql + ",'" + strDayShortName + "'";
		Sql = Sql + ",'" + strTimeLength + "'";
		Sql = Sql + ",'" + strTimePastSpan + "'";
		Sql = Sql + ",'" + strTimeFutureSpan + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);



		if(tp==0){
			Sql = "";
			Sql = Sql + "create table " + session.getValue("loginSchema") + "." + "oo_dim_" + objSeq + "_1 (";
			Sql = Sql + "KEY             integer, ";
			Sql = Sql + "PAR_KEY         integer, ";
			Sql = Sql + "COL_1           VARCHAR(50), ";
			Sql = Sql + "COL_2           VARCHAR(50), ";
			Sql = Sql + "COL_3           VARCHAR(50), ";
			Sql = Sql + "COL_4           VARCHAR(50), ";
			Sql = Sql + "COL_5           VARCHAR(50), ";
			Sql = Sql + "COL_6           VARCHAR(50), ";
			Sql = Sql + "SORT_COL        VARCHAR(256), ";
			Sql = Sql + "CODE            VARCHAR(256), ";//基本コードが入る
			Sql = Sql + "Short_Name      VARCHAR(256),";//ShortName 
			Sql = Sql + "Long_Name       VARCHAR(256),";//LongName 
			Sql = Sql + "calc_text       VARCHAR(256),";//計算式等 
			Sql = Sql + "time_date       date,";//時間軸の日付 
			Sql = Sql + "org_level       numeric(2),";//Mappingしたときのレベル 
			Sql = Sql + "cust_LEVEL      numeric(2),";//カスタマイズ後のレベル 
			Sql = Sql + "leaf_flg        char(1),";//（カスタマイズ後のレベルで）最下層だったら、１、それ以外０
			Sql = Sql + "KIND_FLG        CHAR(1), ";
			Sql = Sql + "NAME_UPDATE_FLG CHAR(1), ";
			Sql = Sql + "MIN_VAL         numeric(10,2), ";
			Sql = Sql + "MAX_VAL         numeric(10,2) ";
			Sql = Sql + ",PRIMARY KEY (KEY)    ";
			Sql = Sql + ") ";
		//	out.println(Sql);
			exeCount = stmt.executeUpdate(Sql);


			Sql = "";
		//	Sql = Sql + "create index " + session.getValue("loginSchema") + "." + "oo_dim_" + objSeq + "_1_idx on oo_dim_" + objSeq + "_1 (par_key)";
			Sql = Sql + "create index " + "oo_dim_" + objSeq + "_1_idx on oo_dim_" + objSeq + "_1 (par_key)";
			exeCount = stmt.executeUpdate(Sql);

		}else if(tp==1){
			Sql = "TRUNCATE TABLE oo_dim_" + objSeq + "_1";
			exeCount = stmt.executeUpdate(Sql);
		}

		Sql = "";
		Sql = Sql + "select oo_create_time_dim(" + objSeq + ") as a";
		rs = stmt.executeQuery(Sql);

	}


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
		parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=objSeq%>","<%=strName%>");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>