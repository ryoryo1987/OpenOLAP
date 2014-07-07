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


//String strUserSeq = request.getParameter("hid_user_seq");
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

%>

<%




	Sql = "DELETE FROM oo_cube";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);

	Sql = "DELETE FROM oo_cube_structure";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	exeCount = stmt.executeUpdate(Sql);


	if(tp==2){
		Sql = "DELETE FROM oo_formula";
		Sql = Sql + " WHERE cube_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);
		Sql = "DELETE FROM oo_info_cube";
		Sql = Sql + " WHERE cube_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);
		Sql = "DELETE FROM oo_info_dim";
		Sql = Sql + " WHERE cube_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);
		Sql = "DELETE FROM oo_info_mes";
		Sql = Sql + " WHERE cube_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);
	}


	if(tp==0){

		//SEQUENCE 取得
		Sql = "SELECT nextval('oo_cube_seq') as seq_no";

		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();

	}

	if(tp!=2){



		//最新時間次元を取得
		int timeSeq = 0;
		Sql = "SELECT time_seq ";
		Sql = Sql + " FROM oo_time ";
		Sql = Sql + " ORDER BY time_seq DESC";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			timeSeq = rs.getInt("time_seq");
		}
		rs.close();



		//新規登録
		Sql = "INSERT INTO oo_cube (";
		Sql = Sql + "cube_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ")";

		exeCount = stmt.executeUpdate(Sql);


		
		StringTokenizer st = new StringTokenizer(request.getParameter("hid_right"), ",");//カンマ区切りの文字列を分割
		while (st.hasMoreTokens()) {
			String mesSeq = st.nextToken();

			//各メジャーの時間次元の有無をチェック
			String timeDimFlg="0";
			Sql = "SELECT time_dim_flg FROM oo_measure WHERE measure_seq=" + mesSeq;
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {
				timeDimFlg = rs.getString("time_dim_flg");
			}
			rs.close();

			int dimNum = 0;


			if (timeDimFlg.equals("1")) {
				dimNum++;
				Sql = "INSERT INTO oo_cube_structure (";
				Sql = Sql + "cube_seq";
				Sql = Sql + ",time_dim_flg";
				Sql = Sql + ",dimension_seq";
				Sql = Sql + ",measure_seq";
				Sql = Sql + ",part_seq";
				Sql = Sql + ",dimension_no";
				Sql = Sql + ") VALUES (";
				Sql = Sql + "" + objSeq;
				Sql = Sql + ",'1'";
				Sql = Sql + "," + timeSeq;
				Sql = Sql + "," + mesSeq;
				Sql = Sql + ",1";
				Sql = Sql + "," + dimNum;
				Sql = Sql + ")";
				exeCount = stmt.executeUpdate(Sql);
			}


			Sql = "SELECT ";
			Sql = Sql + "dimension_seq";
			Sql = Sql + ",measure_seq";
			Sql = Sql + " FROM oo_measure_link";
			Sql = Sql + " WHERE measure_seq = " + mesSeq;
			Sql = Sql + " ORDER BY measure_seq,dimension_seq";
			rs = stmt.executeQuery(Sql);
			while(rs.next()) {
				dimNum++;
				Sql = "INSERT INTO oo_cube_structure (";
				Sql = Sql + "cube_seq";
				Sql = Sql + ",time_dim_flg";
				Sql = Sql + ",dimension_seq";
				Sql = Sql + ",measure_seq";
				Sql = Sql + ",part_seq";
				Sql = Sql + ",dimension_no";
				Sql = Sql + ") VALUES (";
				Sql = Sql + "" + objSeq;
				Sql = Sql + ",'0'";
				Sql = Sql + "," + rs.getString("dimension_seq");
				Sql = Sql + "," + rs.getString("measure_seq");
				Sql = Sql + ",1";
				Sql = Sql + "," + dimNum;
				Sql = Sql + ")";
				exeCount = stmt2.executeUpdate(Sql);
			}
			rs.close();


/*
			Sql = "INSERT INTO oo_cube_structure (";
			Sql = Sql + "cube_seq";
			Sql = Sql + ",time_dim_flg";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",measure_seq";
			Sql = Sql + ",part_seq";
			Sql = Sql + ")";
			Sql = Sql + " SELECT ";
			Sql = Sql + "" + objSeq;
			Sql = Sql + ",'0'";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",measure_seq";
			Sql = Sql + ",1";
			Sql = Sql + " FROM oo_measure_link";
			Sql = Sql + " WHERE measure_seq = " + mesSeq;
			Sql = Sql + " ORDER BY dimension_seq";
			if (timeDimFlg.equals("1")) {
				Sql = Sql + " UNION ";
				Sql = Sql + " SELECT ";
				Sql = Sql + "" + objSeq;
				Sql = Sql + ",'1'";
				Sql = Sql + "," + timeSeq;
				Sql = Sql + "," + mesSeq;
				Sql = Sql + ",1";
			}
		//	out.println(Sql);
			exeCount = stmt.executeUpdate(Sql);
*/


		}

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