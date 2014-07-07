<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import="java.util.*"%>
<%@ include file="../../connect.jsp"%>

<%
	String tempString="";

	String Sql;
	int i=0;

	String[] arrCubeSeq = new String[1000];
	String[] arrCubeName = new String[1000];
	int[] arrCubeType = new int[1000];
	String[] arrCubeCount = new String[1000];
	String[] arrUpdateTime = new String[1000];


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
		

		Sql = "SELECT ";
		Sql = Sql + " cube_seq,custmized_flg,record_count,to_char(last_update,'YYYY/MM/DD HH24:MI:SS') as last_update";
		Sql = Sql + " FROM oo_info_cube";
		Sql = Sql + " WHERE cube_seq = " + arrCubeSeq[i];
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			arrCubeType[i]=1;
			arrCubeCount[i]=rs.getString("record_count");
			if("1".equals(rs.getString("custmized_flg"))){
				arrCubeType[i]=2;
			}
			arrUpdateTime[i]=rs.getString("last_update");

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
	<title><%=(String)session.getValue("aplName")%></title>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<link rel="stylesheet" type="text/css" href="../../../css/common.css">
	<link rel="stylesheet" type="text/css" href="../../../css/flow.css">
	<script type="text/javascript" src="../../../css/colorStyle.js"></script>
	<script language="JavaScript">

function clickTR(obj){
//	alert(obj.id);
	var cube_table = document.getElementById("cube_table");
	for(j=0;j<cube_table.rows.length;j++){
		cube_table.rows[j].style.backgroundColor="";
	}
	obj.style.backgroundColor=cubeListSelectedColor;
	document.form_main.hid_cube_seq.value=obj.id;

	document.form_main.action = "../hidden/report_prpt.jsp?id=" + obj.id;
	document.form_main.target = "frm_hidden";
	document.form_main.submit();



}

	</script>
</head>

<body>

<form name="form_main" id="form_main" method="post" action="">
	<table id="cube_table" style="border-collapse:collapse">

<%
int k=0;
for(i=0;i<arrCubeSeq.length;i++){
	if(arrCubeSeq[i]==null){break;}
		if(arrCubeType[i]!=0){
			k++;
			if(k%2==1){
				out.println("<tr class='listcolor1' height='9' id='" + arrCubeSeq[i] + "' onclick='clickTR(this)' onmouseover='this.style.cursor=\"hand\"'>");
			}else{
				out.println("<tr class='listcolor2' height='9' id='" + arrCubeSeq[i] + "' onclick='clickTR(this)' onmouseover='this.style.cursor=\"hand\"'>");
			}
			out.println("<td style='padding-top:5;width:23'>");
			if(arrCubeType[i]==0){
				out.println("<img src='../../../images/cube_none.gif'>");
			}else if(arrCubeType[i]==1){
				out.println("<img src='../../../images/cube_comp.gif'>");
			}else if(arrCubeType[i]==2){
				out.println("<img src='../../../images/cube_cstm.gif'>");
			}else if(arrCubeType[i]==3){
				out.println("<img src='../../../images/cube_info.gif'>");
			}
			out.println("</td>");
			out.println("<td width='140'><font size='1'>");
			out.println(" " + arrCubeName[i]);
			out.println("</font></td>");
			out.println("<td width='50' align='right' nowrap><font size='1'>");
			out.println(arrCubeCount[i]);
			out.println("</font></td>");
			out.println("<td width='100' align='right' nowrap><font size='1'>" + arrUpdateTime[i]);
//			out.println(arrUpdateTime[i]);
			out.println("</font></td>");
			out.println("</tr>");
		}
}
%>
	</table>



	<!--隠しオブジェクト-->
	<input type="hidden" name="hid_cube_seq" value="">


</form>

</body>
</html>

<%@ include file="../../connect_close.jsp" %>
