<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String tempString="";

	String Sql;
	int i=0;

	String[] arrCubeSeq = new String[10000];
	String[] arrCubeName = new String[10000];
	int[] arrCubeType = new int[10000];
	String[] arrCubeCount = new String[10000];


	Sql = "SELECT ";
	Sql = Sql + " cube_seq,name";
	Sql = Sql + " FROM oo_cube";
	Sql = Sql + " ORDER BY cube_seq";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		arrCubeSeq[i]=rs.getString("cube_seq");
		arrCubeName[i]=rs.getString("name");
		arrCubeType[i]=0;
		arrCubeCount[i]="---";
		i++;
	}
	rs.close();


	for(i=0;i<arrCubeSeq.length;i++){
		if(arrCubeSeq[i]==null){break;}
		
/*
		Sql = "SELECT ";
		Sql = Sql + " *";
		Sql = Sql + " FROM pg_tables";
		Sql = Sql + " WHERE schemaname = '" + (String)session.getValue("loginSchema") + "'";
		Sql = Sql + " AND tablename = 'cube_" + arrCubeSeq[i] + "'";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			arrCubeType[i]=1;
		}
		rs.close();
*/

		Sql = "SELECT ";
		Sql = Sql + " cube_seq,custmized_flg,last_update,record_count";
		Sql = Sql + " FROM oo_info_cube";
		Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			arrCubeType[i]=1;
			arrCubeCount[i]=rs.getString("record_count");
			if("1".equals(rs.getString("custmized_flg"))){
				arrCubeType[i]=2;
			}
		}
		rs.close();

		if(arrCubeType[i]==1){
		
			boolean metaSameFlg = true;

			Sql = "SELECT ";
			Sql = Sql + " dimension_seq,part_seq";
			Sql = Sql + " FROM oo_info_dim";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " distinct dimension_seq,part_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();

			Sql = "SELECT ";
			Sql = Sql + " distinct dimension_seq,part_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " dimension_seq,part_seq";
			Sql = Sql + " FROM oo_info_dim";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();

			Sql = "SELECT ";
			Sql = Sql + " measure_seq";
			Sql = Sql + " FROM oo_info_mes";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " AND mes_type = '1'";
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " distinct measure_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();

			Sql = "SELECT ";
			Sql = Sql + " distinct measure_seq";
			Sql = Sql + " FROM oo_cube_structure";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " measure_seq";
			Sql = Sql + " FROM oo_info_mes";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " AND mes_type = '1'";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();


			Sql = "SELECT ";
			Sql = Sql + " measure_seq";
			Sql = Sql + " FROM oo_info_mes";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " AND mes_type != '1'";
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " formula_seq AS measure_seq";
			Sql = Sql + " FROM oo_formula";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();

			Sql = "SELECT ";
			Sql = Sql + " formula_seq AS measure_seq";
			Sql = Sql + " FROM oo_formula";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " EXCEPT ";
			Sql = Sql + " SELECT ";
			Sql = Sql + " measure_seq";
			Sql = Sql + " FROM oo_info_mes";
			Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
			Sql = Sql + " AND mes_type != '1'";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				metaSameFlg = false;
			}
			rs.close();


			if(!metaSameFlg){
				arrCubeType[i]=3;
			}

		}
	}




%>

<html>

<head>
	<title>OpenOLAP Model Designer</title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<script language="JavaScript" src="../js/registration.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<script language="JavaScript">



	</script>
</head>

<body>

<form name="form_main" id="form_main" method="post" action="">
	<table style="border-collapse:collapse">

<%
for(i=0;i<arrCubeSeq.length;i++){
	if(arrCubeSeq[i]==null){break;}
		if(i%2==1){
			//out.println("<tr height='9' bgcolor='#eeffff'>");
			out.println("<tr height='9' bgcolor='#FBF2DB'>");
		}else{
			//out.println("<tr height='9' bgcolor='#ddffff'>");
			out.println("<tr height='9' bgcolor='#F8E5B6'>");
		}
		out.println("<td style='padding-top:5;width:23'>");
		if(arrCubeType[i]==0){
			out.println("<img src='../../images/CubeNone.gif' alt='実キューブは存在しません'>");
		}else if(arrCubeType[i]==1){
			out.println("<img src='../../images/CubeComp.gif' alt='メタ通りに実キューブが存在します'>");
		}else if(arrCubeType[i]==2){
			out.println("<img src='../../images/CubeCstm.gif' alt='カスタマイズされた実キューブが存在します'>");
		}else if(arrCubeType[i]==3){
			out.println("<img src='../../images/CubeInfo.gif' alt='メタとは異なる実キューブが存在します'>");
		}
		out.println("</td>");
		out.println("<td width='120' nowrap><font size='1'>");
		out.println(" " + arrCubeName[i]);
		out.println("</font></td>");
		out.println("<td width='50' align='right' nowrap><font size='1'>");
		out.println(arrCubeCount[i]);
		out.println("</font></td>");
		out.println("</tr>");
}
%>
	</table>



	<!--隠しオブジェクト-->
	<div name="div_hid" id="div_hid" style="display:none;"></div>


</form>

</body>
</html>


