<%@ page language="java" contentType="text/html;charset=Shift_JIS"%>
<%@ page import = "java.util.*"%>
<%//@ page errorPage="ErrorPage.jsp"%>

<%@ include file="../../connect.jsp" %>

<%
String Sql="";
int i=0;

String cubeSeq = request.getParameter("id");

String strCubeSeq=cubeSeq;
String strCubeName="";
String strCubeComment="";
int intCubeType=0;
String strCubeType="";
String strCubeCount="";
String strUpdateTime="";

String[] arrDimSeq = new String[1000];
String[] arrDimPart = new String[1000];
String[] arrDimName = new String[1000];
String[] arrDimComment = new String[1000];
String[] arrDimNo = new String[1000];
String[] arrDimLevelCount = new String[1000];
int[] arrDimMemberCount = new int[1000];
String[] arrMesSeq = new String[1000];
String[] arrMesName = new String[1000];
String[] arrMesComment = new String[1000];
//String[] arrMesNo = new String[1000];
String[] arrMesTypeInt = new String[1000];
String[] arrMesTypeString = new String[1000];
String[] arrMesImageName = new String[1000];

float TotalCount=1;


	Sql = "SELECT ";
	Sql = Sql + " cube_seq,name,comment";
	Sql = Sql + " FROM oo_cube";
	Sql = Sql + " WHERE cube_seq = " + cubeSeq;
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		strCubeName=rs.getString("name");
		strCubeComment=rs.getString("comment");
	}
	rs.close();


	Sql = "SELECT ";
	Sql = Sql + " cube_seq,custmized_flg,to_char(last_update,'YYYY/MM/DD HH24:MI:SS') as last_update,record_count";
	Sql = Sql + " FROM oo_info_cube";
	Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
	rs = stmt.executeQuery(Sql);
	if(rs.next()){
		intCubeType=1;
		strCubeCount=rs.getString("record_count");
		if("1".equals(rs.getString("custmized_flg"))){
			intCubeType=2;
		}
		strUpdateTime=rs.getString("last_update");
	}
	rs.close();


	i=-1;
	Sql = "SELECT ";
	Sql = Sql + " oo_info_dim.dimension_seq,name,comment,part_seq,dim_no,level_count";
	Sql = Sql + " FROM oo_info_dim";
//	Sql = Sql + " ,oo_dimension";
	Sql = Sql + " left outer join oo_dimension on (oo_info_dim.dimension_seq = oo_dimension.dimension_seq)";
	Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
//	Sql = Sql + " AND oo_info_dim.dimension_seq = oo_dimension.dimension_seq";
	Sql = Sql + " ORDER BY dim_no";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		i++;
		arrDimSeq[i]=rs.getString("dimension_seq");
		arrDimPart[i]=rs.getString("part_seq");
		arrDimName[i]=rs.getString("name");
		arrDimComment[i]=rs.getString("comment");
		arrDimNo[i]=rs.getString("dim_no");
		arrDimLevelCount[i]=rs.getString("level_count");

		if(i==0){
			Sql = "SELECT ";
			Sql = Sql + " name,comment";
			Sql = Sql + " FROM oo_time";
			Sql = Sql + " WHERE time_seq = " + rs.getString("dimension_seq");
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				arrDimName[i]=rs2.getString("name");
				arrDimComment[i]=rs2.getString("comment");
			}
			rs2.close();
		}

		if(intCubeType!=2){

			Sql = "SELECT ";
			Sql = Sql + " count(*) AS record_count";
			Sql = Sql + " FROM oo_dim_" + rs.getString("dimension_seq") + "_" + rs.getString("part_seq");
			Sql = Sql + " WHERE leaf_flg!='9'";
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				arrDimMemberCount[i]=rs2.getInt("record_count");
			}
			rs2.close();

			TotalCount = TotalCount * arrDimMemberCount[i];

		}
	}
	rs.close();

	i=-1;
	Sql = "SELECT ";
	Sql = Sql + " oo_info_mes.measure_seq,name,comment,mes_type";
	Sql = Sql + " FROM oo_info_mes";
//	Sql = Sql + " ,oo_measure";
	Sql = Sql + " left outer join oo_measure on (oo_info_mes.measure_seq = oo_measure.measure_seq)";
	Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
//	Sql = Sql + " AND oo_info_mes.measure_seq = oo_measure.measure_seq";
	Sql = Sql + " ORDER BY measure_seq";
	rs = stmt.executeQuery(Sql);
	while(rs.next()){
		i++;
		arrMesSeq[i]=rs.getString("measure_seq");
		arrMesName[i]=rs.getString("name");
		arrMesComment[i]=rs.getString("comment");
	//	arrMesNo[i]=rs.getString("mes_no");
		arrMesTypeInt[i]=rs.getString("mes_type");

		if(!"1".equals(arrMesTypeInt[i])){
			Sql = "SELECT ";
			Sql = Sql + " name,comment";
			Sql = Sql + " FROM oo_formula";
			Sql = Sql + " WHERE formula_seq = " + rs.getString("measure_seq");
			rs2 = stmt2.executeQuery(Sql);
			if(rs2.next()){
				arrMesName[i]=rs2.getString("name");
				arrMesComment[i]=rs2.getString("comment");
			}
			rs2.close();
		}

		if("1".equals(arrMesTypeInt[i])){
			arrMesTypeString[i]="";
			arrMesImageName[i]="measure";
		}else if("2".equals(arrMesTypeInt[i])){
			arrMesTypeString[i]="フォーミュラ形式";
			arrMesImageName[i]="custom_measure";
		}else if("3".equals(arrMesTypeInt[i])){
			arrMesTypeString[i]="実データ形式";
			arrMesImageName[i]="custom_measure";
		}


	}
	rs.close();


	if(intCubeType==1){

		boolean metaSameFlg = true;


		Sql = "SELECT ";
		Sql = Sql + " dimension_seq,part_seq";
		Sql = Sql + " FROM oo_info_dim";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " distinct dimension_seq,part_seq";
		Sql = Sql + " FROM oo_cube_structure";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();

		Sql = "SELECT ";
		Sql = Sql + " distinct dimension_seq,part_seq";
		Sql = Sql + " FROM oo_cube_structure";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " dimension_seq,part_seq";
		Sql = Sql + " FROM oo_info_dim";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();

		Sql = "SELECT ";
		Sql = Sql + " measure_seq";
		Sql = Sql + " FROM oo_info_mes";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " AND mes_type = '1'";
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " distinct measure_seq";
		Sql = Sql + " FROM oo_cube_structure";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();

		Sql = "SELECT ";
		Sql = Sql + " distinct measure_seq";
		Sql = Sql + " FROM oo_cube_structure";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " measure_seq";
		Sql = Sql + " FROM oo_info_mes";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " AND mes_type = '1'";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();


		Sql = "SELECT ";
		Sql = Sql + " measure_seq";
		Sql = Sql + " FROM oo_info_mes";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " AND mes_type != '1'";
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " formula_seq AS measure_seq";
		Sql = Sql + " FROM oo_formula";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();

		Sql = "SELECT ";
		Sql = Sql + " formula_seq AS measure_seq";
		Sql = Sql + " FROM oo_formula";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " EXCEPT ";
		Sql = Sql + " SELECT ";
		Sql = Sql + " measure_seq";
		Sql = Sql + " FROM oo_info_mes";
		Sql = Sql + " WHERE cube_seq = " + strCubeSeq;
		Sql = Sql + " AND mes_type != '1'";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			metaSameFlg = false;
		}
		rs.close();

		if(!metaSameFlg){
			intCubeType=3;
		}

	}


	if(intCubeType==0){
	}else if(intCubeType==1){
		strCubeType="メタ通りのキューブ";
	}else if(intCubeType==2){
		strCubeType="カスタマイズキューブ";
	}else if(intCubeType==3){
		strCubeType="メタとは異なるキューブ";
	}

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title><%=(String)session.getValue("aplName")%></title>
	<script language="JavaScript">
	function load(){

		var strTable='';

		strTable+='<td style="vertical-align:top">';
			strTable+='<div class="prpt1" style="position:absolute;top:40px;left:340px;height:20px;width:140px;z-index:1111;padding:5;">キューブのプロパティ</div>';
			strTable+='<div class="prpt1" style="position:absolute;top:63px;left:340px;height:400px;padding:4;border-style:outset;border-width:2;">';
			strTable+='<div class="prpt1" style="height:368;border-style:outset;border-width:2;">';
				strTable+='<table style="width:380;table-layout:fixed;margin-top:5px">';
					strTable+='<tr>';
						strTable+='<td width="140">キューブID：</td>';
						strTable+='<td><%=cubeSeq%></td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td width="140">キューブ名：</td>';
						strTable+='<td><%=strCubeName%></td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td>説明：</td>';
						strTable+='<td style="vertical-align:top"><%=strCubeComment%></td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td>キューブタイプ：</td>';
						strTable+='<td><%=strCubeType%></td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td>件数：</td>';
<%if(intCubeType==2){%>
						strTable+='<td><%=strCubeCount%></td>';
<%}else{%>
						strTable+='<td><%=strCubeCount%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（データ密度：<%=new Float(((Integer.parseInt(strCubeCount)/TotalCount)*100)).intValue()%>%）</td>';
<%}%>

					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td>キューブ最終更新日時：</td>';
						strTable+='<td><%=strUpdateTime%></td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td colspan="2">';
							strTable+='<table width="100%" style="table-layout:fixed;border-collapse:collapse">';
								strTable+='<tr>';
									strTable+='<td width="100">ディメンションリスト</td>';
									strTable+='<td style="padding-right:5px"><hr></td>';
								strTable+='</tr>';
							strTable+='</table>';
						strTable+='</td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td colspan="2">';
						strTable+='<!-- ディメンションリスト -->';
							strTable+='<div style="overflow-y:auto;height:155px;">';
							strTable+='<table>';
<%if(intCubeType==2){%>
								strTable+='<tr>';
									strTable+='<td class="item_name" colspan="2">カスタマイズキューブでは表示できません</td>';
								strTable+='</tr>';

<%}else{%>

<%
for(i=0;i<arrDimSeq.length;i++){
	if(arrDimSeq[i]==null){break;}
%>

								strTable+='<tr>';
									strTable+='<td class="item_name" colspan="2"><%=arrDimNo[i]%>. <img src="../../../images/dimension.gif"><%=arrDimName[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
									strTable+='<td class="item">ディメンションID：</td>';
									strTable+='<td><%=arrDimSeq[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
									strTable+='<td class="item">説明：</td>';
									strTable+='<td><%=arrDimComment[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
									strTable+='<td class="item">レベル数：</td>';
									strTable+='<td><%=arrDimLevelCount[i]%></td>';
								strTable+='</tr>';

<%}%>
<%}%>


							strTable+='</table>';
							strTable+='</div>';
						strTable+='</td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td colspan="2">';
							strTable+='<table width="100%" style="table-layout:fixed;border-collapse:collapse">';
								strTable+='<tr>';
									strTable+='<td width="90">メジャーリスト</td>';
									strTable+='<td style="padding-right:5px"><hr></td>';
								strTable+='</tr>';
							strTable+='</table>';
						strTable+='</td>';
					strTable+='</tr>';
					strTable+='<tr>';
						strTable+='<td colspan="2">';
						strTable+='<!-- メジャーリスト -->';
							strTable+='<div style="overflow-y:auto;height:125px;">';
							strTable+='<table width="100%">';
<%if(intCubeType==2){%>
								strTable+='<tr>';
									strTable+='<td class="item_name" colspan="2">カスタマイズキューブでは表示できません</td>';
								strTable+='</tr>';

<%}else{%>

<%
for(i=0;i<arrMesSeq.length;i++){
	if(arrMesSeq[i]==null){break;}
%>

								strTable+='<tr>';
									strTable+='<td class="item_name" colspan="2"><img src="../../../images/<%=arrMesImageName[i]%>.gif"><%=arrMesName[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
									strTable+='<td class="item" width="100">メジャーID：</td>';
									strTable+='<td><%=arrMesSeq[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
									strTable+='<td class="item" width="100">説明：</td>';
									strTable+='<td style="vertical-align:top"><%=arrMesComment[i]%></td>';
								strTable+='</tr>';
								strTable+='<tr>';
<%if(!"1".equals(arrMesTypeInt[i])){%>
									strTable+='<td class="item" width="100">メジャータイプ：</td>';
									strTable+='<td><%=arrMesTypeString[i]%></td>';
								strTable+='</tr>';
<%}%>
<%}%>
<%}%>


							strTable+='</table>';
						strTable+='</td>';
					strTable+='</tr>';
				strTable+='</table>';
			strTable+='</div>';
			strTable+='</div>';
		strTable+='</td>';



		parent.frm_main1.document.all.div_prpt.innerHTML=strTable;

	}
	</script>
</head>
<body onload="load()">
<form name="form_main" id="form_main" method="post" action="">
</form>
</body>
</html>

<%@ include file="../../connect_close.jsp" %>
