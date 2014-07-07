<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ include file="../../connect.jsp" %>

<%
	String SQL = "";
	String objSeq = request.getParameter("objSeq");
	String strHEAD = "";
	String strHTML = "";

	strHEAD = strHEAD + "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>" + System.getProperty("line.separator");
	strHEAD = strHEAD + "<?xml:stylesheet type=\"text/xsl\" href=\"cubesct_tree.xsl\" ?>" + System.getProperty("line.separator");




//--Current--------------------------------------------------------------------------------------------------------
	SQL = 		" select distinct ";
	SQL = SQL + " measure_seq AS Mseq,Mname AS Mname, ";
	SQL = SQL + " time_dim_flg AS time_dim_flg, ";
	SQL = SQL + " dimension_seq AS Dseq,Dname AS Dname, ";
	SQL = SQL + " part_seq AS Pseq,Pname AS Pname ";
	SQL = SQL + " from (";
		//' oo_cube_structure からと oo_time からの UNION table の副問い合わせ
		SQL = SQL + " select distinct ";
		SQL = SQL + " S.measure_seq AS measure_seq,M.name AS Mname, ";
		SQL = SQL + " S.time_dim_flg AS time_dim_flg, ";
		SQL = SQL + " S.dimension_seq AS dimension_seq,D.name AS Dname, ";
		SQL = SQL + " coalesce(S.part_seq,1) AS part_seq,P.name AS Pname ";
		SQL = SQL + " from oo_cube_structure S,oo_measure M,oo_dimension D,oo_dimension_part P ";
		SQL = SQL + " where S.cube_seq=" + objSeq;
		SQL = SQL + " and S.measure_seq=(SELECT measure_seq FROM oo_cube_structure WHERE cube_seq=" + objSeq + " LIMIT 1)";
		SQL = SQL + " and S.measure_seq=M.measure_seq ";
		SQL = SQL + " and S.dimension_seq=D.dimension_seq ";
		SQL = SQL + " and S.part_seq=P.part_seq ";
		SQL = SQL + " and S.dimension_seq=P.dimension_seq ";
		SQL = SQL + " union ";
		SQL = SQL + " select distinct ";
		SQL = SQL + " S.measure_seq AS measure_seq,M.name AS Mname, ";
		SQL = SQL + " S.time_dim_flg AS time_dim_flg, ";
		SQL = SQL + " S.dimension_seq AS dimension_seq,D.name AS Dname, ";
		SQL = SQL + " S.dimension_seq AS part_seq,D.name AS Pname ";
		SQL = SQL + " from oo_cube_structure S,oo_measure M,oo_time D ";
		SQL = SQL + " where S.cube_seq=" + objSeq;
		SQL = SQL + " and S.measure_seq=(SELECT measure_seq FROM oo_cube_structure WHERE cube_seq=" + objSeq + " LIMIT 1)";
		SQL = SQL + " and S.measure_seq=M.measure_seq ";
		SQL = SQL + " and S.dimension_seq=D.time_seq ";
	SQL = SQL + " ) as SubQuery";
	SQL = SQL + " order by measure_seq,time_dim_flg desc,dimension_seq,part_seq ";
//out.println(SQL);
	rs = stmt.executeQuery(SQL);
	int cnt=0;
	while (rs.next()) {
		cnt++;
		if(cnt==1){
			strHTML = strHTML + "<Measure ID='" + rs.getString("Mseq") + "' OBJKIND='Measure'>キューブ" + System.getProperty("line.separator");
		}

		if("1".equals(rs.getString("time_dim_flg"))){
			strHTML = strHTML + "<TimeDim ID='T'>時間ディメンション" + System.getProperty("line.separator");
			strHTML = strHTML + "<TimeParts ID='" + rs.getString("Pseq") + "'>" + rs.getString("Pname") + "</TimeParts>" + System.getProperty("line.separator");
			strHTML = strHTML + "</TimeDim>" + System.getProperty("line.separator");
		}else{
			strHTML = strHTML + "<Dimension ID='" + rs.getString("Dseq") + "'>" + rs.getString("Dname") + System.getProperty("line.separator");
			strHTML = strHTML + "<Parts ID='" + rs.getString("Pseq") + "'>" + rs.getString("Pname") + "</Parts>" + System.getProperty("line.separator");
			strHTML = strHTML + "</Dimension>" + System.getProperty("line.separator");
		}



	}
	rs.close();

		if(!"".equals(strHTML)){


		SQL = 		" select distinct ";
		SQL = SQL + " measure_seq AS Mseq,Mname AS Mname, ";
		SQL = SQL + " time_dim_flg AS time_dim_flg, ";
		SQL = SQL + " dimension_seq AS Dseq,Dname AS Dname, ";
		SQL = SQL + " part_seq AS Pseq,Pname AS Pname ";
		SQL = SQL + " from (";
			//' oo_cube_structure からと oo_time からの UNION table の副問い合わせ
			SQL = SQL + " select distinct ";
			SQL = SQL + " L.measure_seq AS measure_seq,M.name AS Mname, ";
			SQL = SQL + " coalesce(S.time_dim_flg,'0') AS time_dim_flg, ";
			SQL = SQL + " L.dimension_seq AS dimension_seq,D.name AS Dname, ";
			SQL = SQL + " coalesce(P.part_seq,1) AS part_seq,P.name AS Pname ";
		//	SQL = SQL + " from oo_cube_structure S";
			SQL = SQL + " from oo_measure_link L";
			SQL = SQL + " left outer join oo_dimension_part P on (L.dimension_seq=P.dimension_seq)";
			SQL = SQL + " left outer join oo_cube_structure S on (L.dimension_seq=S.dimension_seq)";
			SQL = SQL + " ,oo_measure M,oo_dimension D";
			SQL = SQL + " where";
			SQL = SQL + " L.measure_seq=(SELECT measure_seq FROM oo_cube_structure WHERE cube_seq=" + objSeq + " LIMIT 1)";
			SQL = SQL + " and L.measure_seq=M.measure_seq ";
			SQL = SQL + " and L.dimension_seq=D.dimension_seq ";
			SQL = SQL + " union ";
			SQL = SQL + "  select ";
			SQL = SQL + "  M.measure_seq AS measure_seq,M.name AS Mname,  ";
			SQL = SQL + "  coalesce(M.time_dim_flg,'1') AS time_dim_flg,  ";
			SQL = SQL + "  D.time_seq AS dimension_seq,D.name AS Dname,  ";
			SQL = SQL + "  D.time_seq AS part_seq,D.name AS Pname  ";
			SQL = SQL + "  from oo_measure M  ";
			SQL = SQL + "  ,oo_time D  ";
			SQL = SQL + "  where";
			SQL = SQL + "  M.measure_seq=(SELECT measure_seq FROM oo_cube_structure WHERE cube_seq=" + objSeq + " LIMIT 1) ";
			SQL = SQL + "  AND M.time_dim_flg='1'";
		SQL = SQL + " ) as SubQuery";
		SQL = SQL + " order by measure_seq,time_dim_flg desc,dimension_seq,part_seq ";
	//out.println(SQL);
		rs = stmt.executeQuery(SQL);
		cnt=0;
		String previousDimFlg="";
		boolean timeFlg=false;
		boolean dimFlg=false;

		while (rs.next()) {
			cnt++;
			if(cnt==1){
				strHTML = strHTML + "<Measure ID='cloneNode'>";
				strHTML = strHTML + "<Measure ID='" + rs.getString("Mseq") + "' OBJKIND='Measure'>" + rs.getString("Mname") + System.getProperty("line.separator");
			}

			if("1".equals(rs.getString("time_dim_flg"))){
				timeFlg=true;
				if("".equals(previousDimFlg)){
					strHTML = strHTML + "<TimeDim ID='T'>時間ディメンション" + System.getProperty("line.separator");
				}
				strHTML = strHTML + "<TimeParts ID='" + rs.getString("Pseq") + "'>" + rs.getString("Pname") + "</TimeParts>" + System.getProperty("line.separator");
				previousDimFlg="T";
			}else{
				dimFlg=true;
				if(!rs.getString("Dseq").equals(previousDimFlg)){
					if(!"".equals(previousDimFlg)){
						if("T".equals(previousDimFlg)){
							strHTML = strHTML + "</TimeDim>" + System.getProperty("line.separator");
						}else{
							strHTML = strHTML + "</Dimension>" + System.getProperty("line.separator");
						}
					}
					strHTML = strHTML + "<Dimension ID='" + rs.getString("Dseq") + "'>" + rs.getString("Dname") + System.getProperty("line.separator");
				}
				strHTML = strHTML + "<Parts ID='" + rs.getString("Pseq") + "'>" + rs.getString("Pname") + "</Parts>" + System.getProperty("line.separator");
				previousDimFlg=rs.getString("Dseq");
			}
		}
		rs.close();
		if((timeFlg)&&(!dimFlg)){
			strHTML = strHTML + "</TimeDim>" + System.getProperty("line.separator");
		}else if(dimFlg){
			strHTML = strHTML + "</Dimension>" + System.getProperty("line.separator");
		}

		strHTML = strHTML + "</Measure>" + System.getProperty("line.separator");
		strHTML = strHTML + "</Measure>" + System.getProperty("line.separator");
		strHTML = strHTML + "</Measure>" + System.getProperty("line.separator");
	}


	out.println(strHEAD+strHTML);
//	out.println("<pre>" + ood.replace(ood.replace(strHEAD+strHTML,"<","["),">","]") + "</pre>");

%>
