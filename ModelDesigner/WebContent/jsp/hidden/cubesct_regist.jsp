<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%

	String Sql = "";
	int tp = Integer.parseInt(request.getParameter("tp"));
	int exeCount=0;
/*
out.println("<BR>:CubId"+request.getParameter("CubId"));
out.println("<BR>:MeaId"+request.getParameter("MeaId"));
out.println("<BR>:DimId"+request.getParameter("DimId"));
out.println("<BR>:ParId"+request.getParameter("ParId"));
*/

	String strName = request.getParameter("txt_name");
	String objSeq=request.getParameter("hid_obj_seq");
	String objKind=request.getParameter("hid_obj_kind");
	String mesSeq="";
	String dimSeq="";
	String partSeq="";
	String timeDimFlg="";


	//キューブに所属するメジャーを取得する
	Sql = 		" SELECT DISTINCT M.measure_seq,M.name from oo_measure M";
	Sql = Sql + " left outer join oo_cube_structure S on (M.measure_seq=S.measure_seq)";
	Sql = Sql + " where S.cube_seq = " + objSeq;
	Sql = Sql + " order by M.measure_seq ";
	rs = stmt.executeQuery(Sql);

	//レコードを削除（削除後に上記SQLを発行するとクエリーが0行となってしまうので順番に注意）
	Sql = "DELETE FROM oo_cube_structure";
	Sql = Sql + " WHERE cube_seq = " + objSeq;
	exeCount = stmt2.executeUpdate(Sql);



	while (rs.next()) {
		mesSeq = rs.getString("measure_seq");

		StringTokenizer stDimArray = new StringTokenizer(request.getParameter("DimId"), ",");//カンマ区切りの文字列を分割
		StringTokenizer stPartArray = new StringTokenizer(request.getParameter("ParId"), ",");//カンマ区切りの文字列を分割
		while (stDimArray.hasMoreTokens()){
			dimSeq = stDimArray.nextToken();
			partSeq = stPartArray.nextToken();


			if(dimSeq.equals("T")){
				dimSeq=partSeq;
				partSeq="1";
				timeDimFlg="1";
			}else{
				timeDimFlg="0";
			}


			Sql = "INSERT INTO oo_cube_structure ( ";
			Sql = Sql + " cube_seq";
			Sql = Sql + ",time_dim_flg";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",measure_seq";
			Sql = Sql + ",part_seq";
			Sql = Sql + ",dimension_no";
			Sql = Sql + ")VALUES(";
			Sql = Sql + "" + objSeq;
			Sql = Sql + "," + timeDimFlg;
			Sql = Sql + "," + dimSeq;
			Sql = Sql + "," + mesSeq;
			Sql = Sql + "," + partSeq;
			Sql = Sql + ",NULL";
			Sql = Sql + ")";
			exeCount = stmt2.executeUpdate(Sql);

		}


	}
	rs.close();







	//次元順をセット
	Sql = 		" SELECT S.measure_seq,S.dimension_seq FROM oo_cube_structure S";
	Sql = Sql + " WHERE S.cube_seq = " + objSeq;
	Sql = Sql + " order by S.measure_seq,S.time_dim_flg desc,S.dimension_seq ";
	rs = stmt.executeQuery(Sql);
	int dimNo = 0;
	String previousMes = "";
	while (rs.next()) {
		if(!previousMes.equals(rs.getString("measure_seq"))){
			dimNo=0;
		}
		dimNo++;
		mesSeq = rs.getString("measure_seq");
		dimSeq = rs.getString("dimension_seq");
		previousMes = mesSeq;

		Sql = "UPDATE oo_cube_structure SET ";
		Sql = Sql + " dimension_no = '" + dimNo + "'";
		Sql = Sql + " WHERE cube_seq = " + objSeq;
		Sql = Sql + " AND dimension_seq = " + dimSeq;
		Sql = Sql + " AND measure_seq = " + mesSeq;
		exeCount = stmt2.executeUpdate(Sql);

	}
	rs.close();


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