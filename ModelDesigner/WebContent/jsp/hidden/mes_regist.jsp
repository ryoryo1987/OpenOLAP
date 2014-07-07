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
String strTimeDimFlg = request.getParameter("hid_time_flg");
String strTimeCol = request.getParameter("hid_time_col");
String strTimeFormat = request.getParameter("hid_time_format");
String strFactTable = request.getParameter("hid_fact_table");
String strFactCol = request.getParameter("hid_fact_col");
String strFactCalcMethod = request.getParameter("hid_fact_calc_method");
String strFactWhereClause = ood.replace(ood.replace(request.getParameter("hid_fact_where_clause"),"'","''"),"\\","\\\\");


String strUserSeq = request.getParameter("hid_user_seq");
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

%>

<%





	Sql = "DELETE FROM oo_measure_link";
	Sql = Sql + " WHERE measure_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);

	Sql = "DELETE FROM oo_measure_chart";
	Sql = Sql + " WHERE measure_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);

	Sql = "DELETE FROM oo_measure";
	Sql = Sql + " WHERE measure_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);



	if(tp==0){

		//SEQUENCE Žæ“¾
		Sql = "SELECT nextval('oo_measure_seq') as seq_no";

		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();

	}

	if(tp!=2){


		//V‹K“o˜^
		Sql = "INSERT INTO oo_measure (";
		Sql = Sql + "measure_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ",fact_table";
		Sql = Sql + ",fact_col";
		Sql = Sql + ",fact_calc_method";
		Sql = Sql + ",fact_where_clause";
		Sql = Sql + ",time_dim_flg";
		Sql = Sql + ",time_col";
		Sql = Sql + ",time_format";
		Sql = Sql + ",user_seq";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",'" + strFactTable + "'";
		Sql = Sql + ",'" + strFactCol + "'";
		Sql = Sql + ",'" + strFactCalcMethod + "'";
		Sql = Sql + ",'" + strFactWhereClause + "'";
		Sql = Sql + ",'" + strTimeDimFlg + "'";
		Sql = Sql + ",'" + strTimeCol + "'";
		Sql = Sql + ",'" + strTimeFormat + "'";
		Sql = Sql + ",'" + strUserSeq + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);


		
		StringTokenizer st = new StringTokenizer(request.getParameter("hid_dimseq_string"), ",");//ƒJƒ“ƒ}‹æØ‚è‚Ì•¶Žš—ñ‚ð•ªŠ„
		while (st.hasMoreTokens()) {
			String dimSeq = st.nextToken();
			Sql = "INSERT INTO oo_measure_link (";
			Sql = Sql + "measure_seq";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",fact_link_col1";
			Sql = Sql + ",fact_link_col2";
			Sql = Sql + ",fact_link_col3";
			Sql = Sql + ",fact_link_col4";
			Sql = Sql + ",fact_link_col5";
			Sql = Sql + ")VALUES(";
			Sql = Sql + "" + objSeq;
			Sql = Sql + "," + dimSeq;
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_m_factcol1") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_m_factcol2") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_m_factcol3") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_m_factcol4") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_m_factcol5") + "'";
			Sql = Sql + ")";
		//	out.println(Sql);
			exeCount = stmt.executeUpdate(Sql);


			Sql = "INSERT INTO oo_measure_chart (";
			Sql = Sql + "measure_seq";
			Sql = Sql + ",object_type";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",x_point";
			Sql = Sql + ",y_point";
			Sql = Sql + ")VALUES(";
			Sql = Sql + "" + objSeq;
			Sql = Sql + ",'D'";
			Sql = Sql + "," + dimSeq;
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_x_point") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_dim" + dimSeq + "_y_point") + "'";
			Sql = Sql + ")";
			exeCount = stmt.executeUpdate(Sql);
		}

		Sql = "INSERT INTO oo_measure_chart (";
		Sql = Sql + "measure_seq";
		Sql = Sql + ",object_type";
		Sql = Sql + ",dimension_seq";
		Sql = Sql + ",x_point";
		Sql = Sql + ",y_point";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'F'";
		Sql = Sql + ",null";
		Sql = Sql + ",'" + request.getParameter("hid_fact_x_point") + "'";
		Sql = Sql + ",'" + request.getParameter("hid_fact_y_point") + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);


		if("1".equals(strTimeDimFlg)){
			Sql = "INSERT INTO oo_measure_chart (";
			Sql = Sql + "measure_seq";
			Sql = Sql + ",object_type";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",x_point";
			Sql = Sql + ",y_point";
			Sql = Sql + ")VALUES(";
			Sql = Sql + "" + objSeq;
			Sql = Sql + ",'T'";
			Sql = Sql + ",null";
			Sql = Sql + ",'" + request.getParameter("hid_time_x_point") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_time_y_point") + "'";
			Sql = Sql + ")";
			exeCount = stmt.executeUpdate(Sql);
		}



	}


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){
		parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=strUserSeq%>,<%=objSeq%>","<%=strName%>");
		location.replace("blank.jsp");
	}
	</script>
</head>
<body onload="load()">
</body>
</html>