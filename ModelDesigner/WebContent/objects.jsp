<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>

<?xml version="1.0" encoding="Shift_JIS"?>
<?xml-stylesheet type="text/xsl" href="tree.xsl"?>

<%
// out.println("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");
// out.println("<?xml-stylesheet type=\"text/xsl\" href=\"tree.xsl\"?>");
%>

<%@ include file="connect.jsp" %>

<%



// Common Variables
String SQL;
String SQL2;
String closeTag="";
String preRecordData="";

Vector vecSeq = new Vector();
Vector vecName = new Vector();
int i=0;
%>
<OpenOlap ID='OpenOlap'>OpenOlap
<Configuration ID='Configuration'>環境設定
	<SchemaTop ID='0'>スキーマ
<%

	// Get UserSeq & Username from META table.
	SQL = 		" SELECT DISTINCT";
	SQL = SQL + " user_seq, ";
	SQL = SQL + " name ";
	SQL = SQL + " FROM oo_user ";
	SQL = SQL + " order by user_seq";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		out.println("<Schema LV='0' ID='" + rs.getString("user_seq") + "'>" + rs.getString("name") + " ");
		out.println("</Schema>");
	}
	rs.close();

%>

	</SchemaTop>
</Configuration>

<ObjectDefinition>オブジェクト定義
	<DimensionTop ID='DimensionTop'>ディメンション
<%
	closeTag = "";
	preRecordData="";

	SQL = 		" select distinct";
	SQL = SQL + " coalesce(U.user_seq,0) as user_seq,";
	SQL = SQL + " U.name as Uname,";
	SQL = SQL + " coalesce(D.dimension_seq,0) as dimension_seq,";
	SQL = SQL + " D.name as Dname";
	SQL = SQL + " from oo_user U";
//	SQL = SQL + " ,(select * from oo_dimension where dim_type=2) as D";
	SQL = SQL + " left outer join (select * from oo_dimension where dim_type='1') as D on (U.user_seq=D.user_seq)";
	SQL = SQL + " WHERE (D.dimension_seq<>-1 OR D.dimension_seq IS NULL)";
	SQL = SQL + " order by 1,3";
	rs = stmt.executeQuery(SQL);
	if (rs.next()) {
			out.println("<DimensionSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
			if ( !(rs.getString("dimension_seq")).equals("0") ) {
				out.println("<Dimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</Dimension>");
			}
			preRecordData = rs.getString("user_seq");
			closeTag = "</DimensionSchema>";
	}

	while (rs.next()) {
			if ( preRecordData.equals(rs.getString("user_seq")) ) {
				out.println("<Dimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</Dimension>");
			} else {
				out.println("</DimensionSchema>");
				out.println("<DimensionSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
				if ( !(rs.getString("dimension_seq")).equals("0") ) {
					out.println("<Dimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
					out.println("</Dimension>");
				}
			}
			preRecordData = rs.getString("user_seq");
	}

	rs.close();
	out.println(closeTag);
%>
	</DimensionTop>
	<SegmentDimensionTop ID='SegmentDimensionTop'>セグメントディメンション
<%
	closeTag = "";
	preRecordData="";

	SQL = 		" select distinct";
	SQL = SQL + " coalesce(U.user_seq,0) as user_seq,";
	SQL = SQL + " U.name as Uname,";
	SQL = SQL + " coalesce(D.dimension_seq,0) as dimension_seq,";
	SQL = SQL + " D.name as Dname";
	SQL = SQL + " from oo_user U";
//	SQL = SQL + " ,(select * from oo_dimension where dim_type=2) as D";
	SQL = SQL + " left outer join (select * from oo_dimension where dim_type='2') as D on (U.user_seq=D.user_seq)";
	SQL = SQL + " WHERE (D.dimension_seq<>-1 OR D.dimension_seq IS NULL)";
	SQL = SQL + " order by 1,3";
	rs = stmt.executeQuery(SQL);
	if (rs.next()) {
			out.println("<SegmentDimensionSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
			if ( !(rs.getString("dimension_seq")).equals("0") ) {
				out.println("<SegmentDimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</SegmentDimension>");
			}
			preRecordData = rs.getString("user_seq");
			closeTag = "</SegmentDimensionSchema>";
	}

	while (rs.next()) {
			if ( preRecordData.equals(rs.getString("user_seq")) ) {
				out.println("<SegmentDimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</SegmentDimension>");
			} else {
				out.println("</SegmentDimensionSchema>");
				out.println("<SegmentDimensionSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
				if ( !(rs.getString("dimension_seq")).equals("0") ) {
					out.println("<SegmentDimension ID='" + rs.getString("user_seq") + "," + rs.getString("dimension_seq") + "'>" + rs.getString("Dname") + " ");
					out.println("</SegmentDimension>");
				}
			}
			preRecordData = rs.getString("user_seq");
	}

	rs.close();
	out.println(closeTag);
%>
	</SegmentDimensionTop>
	<TimeDimensionTop ID='0'>時間ディメンション
<%

	SQL = 		" select distinct";
	SQL = SQL + " t.time_seq as time_seq,T.Name as Tname ";
	SQL = SQL + " from oo_time t";
	SQL = SQL + " order by t.time_seq";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		out.println("<TimeDimension ID='" + rs.getString("time_seq") + "'>" + rs.getString("Tname") + " ");
		out.println("</TimeDimension>");
	}

	rs.close();

%>
	</TimeDimensionTop>


	<MeasureTop ID='MeasureTop'>メジャー
<%
	closeTag = "";
	preRecordData="";

	SQL = 		" select distinct";
	SQL = SQL + " coalesce(U.user_seq,0) as user_seq,";
	SQL = SQL + " U.name as Uname,";
	SQL = SQL + " coalesce(D.measure_seq,0) as measure_seq,";
	SQL = SQL + " D.name as Dname";
	SQL = SQL + " from oo_user U";
	SQL = SQL + " left outer join oo_measure D on (U.user_seq=D.user_seq)";
	SQL = SQL + " order by 1,3";
	rs = stmt.executeQuery(SQL);
	if (rs.next()) {
			out.println("<MeasureSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
			if ( !(rs.getString("measure_seq")).equals("0") ) {
				out.println("<Measure ID='" + rs.getString("user_seq") + "," + rs.getString("measure_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</Measure>");
			}
			preRecordData = rs.getString("user_seq");
			closeTag = "</MeasureSchema>";
	}

	while (rs.next()) {
			if ( preRecordData.equals(rs.getString("user_seq")) ) {
				out.println("<Measure ID='" + rs.getString("user_seq") + "," + rs.getString("measure_seq") + "'>" + rs.getString("Dname") + " ");
				out.println("</Measure>");
			} else {
				out.println("</MeasureSchema>");
				out.println("<MeasureSchema ID='" + rs.getString("user_seq") + ",0'>" + rs.getString("Uname") + " ");
				if ( !(rs.getString("measure_seq")).equals("0") ) {
					out.println("<Measure ID='" + rs.getString("user_seq") + "," + rs.getString("measure_seq") + "'>" + rs.getString("Dname") + " ");
					out.println("</Measure>");
				}
			}
			preRecordData = rs.getString("user_seq");
	}

	rs.close();
	out.println(closeTag);
%>
	</MeasureTop>


</ObjectDefinition>



<CubeModeling ID='CubeModeling'>キューブモデリング
	<CubeTop ID='0'>キューブ
<%
	SQL = 		" select distinct";
	SQL = SQL + " coalesce(C.cube_seq,0) as cube_seq,";
	SQL = SQL + " C.name as Cname";
	SQL = SQL + " from oo_cube C";
	SQL = SQL + " order by 1";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		out.println("\n<Cube ID='" + rs.getString("cube_seq") + "'>" + rs.getString("Cname") + " ");
		out.println("\n<CubeStructure ID='" + rs.getString("cube_seq") + "'>キューブ構成");
		out.println("</CubeStructure>");
		out.println("</Cube>");
	}
	rs.close();
%>
	</CubeTop>

	<CustomMeasureTop ID='CustomMeasureTop'>カスタムメジャー
<%

	//Vectorの初期化
	vecSeq.removeAllElements();
	vecName.removeAllElements();

	SQL = 		" select distinct";
	SQL = SQL + " coalesce(C.cube_seq,0) as cube_seq,";
	SQL = SQL + " C.name as Cname";
	SQL = SQL + " from oo_cube C";
	SQL = SQL + " order by 1";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		vecSeq.addElement(rs.getString("cube_seq"));
		vecName.addElement(rs.getString("Cname"));
	}
	rs.close();

	for(i=0;i<vecSeq.size();i++) {
		out.println("<CustomMeasureCube ID='" + vecSeq.elementAt(i) + ",0'>" + vecName.elementAt(i) + " ");
		SQL = 		" select distinct";
		SQL = SQL + " coalesce(F.formula_seq,0) as formula_seq,";
		SQL = SQL + " F.name as Fname";
		SQL = SQL + " from oo_formula F";
		SQL = SQL + " where cube_seq = " + vecSeq.elementAt(i);
		SQL = SQL + " order by 1";
		rs = stmt.executeQuery(SQL);
		while (rs.next()) {
			out.println("<CustomMeasure ID='" + vecSeq.elementAt(i) + "," + rs.getString("formula_seq") + "'>" + rs.getString("Fname") + " ");
			out.println("</CustomMeasure>");
		}
		rs.close();
		out.println("</CustomMeasureCube>");
	}
%>

	</CustomMeasureTop>


	<CustomizeDimensionTop ID='CustomizeDimensionTop'>ディメンションのカスタマイズ
		<CustomDimensionTop ID='CustomDimensionTop'>ディメンション
<%
	//Vectorの初期化
	vecSeq.removeAllElements();
	vecName.removeAllElements();


	SQL = " SELECT user_seq,name FROM oo_user ORDER BY user_seq";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		vecSeq.addElement(rs.getString("user_seq"));
		vecName.addElement(rs.getString("name"));
	}
	rs.close();


	for(i=0;i<vecSeq.size();i++) {

		out.println("<CustomDimSchema ID='" + vecSeq.elementAt(i) + "'>" + vecName.elementAt(i) + " ");

		closeTag = "";
		preRecordData="";

		SQL = 		" select distinct";
		SQL = SQL + " coalesce(H.dimension_seq,0) AS dimension_seq,H.Name AS Hname,";
		SQL = SQL + " coalesce(P.part_seq,0) AS part_seq,P.name AS Pname";
		SQL = SQL + " from oo_dimension H";
		SQL = SQL + " left outer join oo_dimension_part P on (H.dimension_seq=P.dimension_seq)";
		SQL = SQL + " where H.dim_type='1'";
		SQL = SQL + " AND H.dimension_seq<>-1";
		SQL = SQL + " AND H.user_seq = " + vecSeq.elementAt(i);
		SQL = SQL + " order by 1,3";
		rs = stmt.executeQuery(SQL);
		if (rs.next()) {
			out.println("<CustomDimension ID='" + rs.getString("dimension_seq") + ",0'>" + rs.getString("Hname") + "\n");
			if ( !(rs.getString("part_seq")).equals("0") ) {
				out.println("<DimParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
				out.println("</DimParts>\n");
			}
			preRecordData=rs.getString("dimension_seq");
			closeTag = "</CustomDimension>\n";
		}

		while (rs.next()) {
			if ( preRecordData.equals(rs.getString("dimension_seq")) ) {
				out.print  ("<DimParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
				out.println("</DimParts>\n");
			} else {
				out.println("\n</CustomDimension>\n\n");
				//out.println("<CustomDimension ID='" + rs.getString("dimension_seq") + "'>" + rs.getString("Hname") + " ");
				out.println("<CustomDimension ID='" + rs.getString("dimension_seq") + ",0'>" + rs.getString("Hname") + " ");
				if ( !(rs.getString("part_seq")).equals("0") ) {
					out.print  ("<DimParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
					out.println("</DimParts>\n");
				}
			}
			preRecordData=rs.getString("dimension_seq");
		}

		rs.close();
		out.println(closeTag);

		out.println("</CustomDimSchema>\n");

	}

%>
		</CustomDimensionTop>


		<CustomSegmentDimensionTop ID='CustomSegmentDimensionTop'>セグメントディメンション
<%

	//Vectorの初期化
	vecSeq.removeAllElements();
	vecName.removeAllElements();

	SQL = " SELECT user_seq,name FROM oo_user ORDER BY user_seq";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		vecSeq.addElement(rs.getString("user_seq"));
		vecName.addElement(rs.getString("name"));

	}
	rs.close();

	for(i=0;i<vecSeq.size();i++) {

		out.println("<CustomSegDimSchema ID='" + vecSeq.elementAt(i) + "'>" + vecName.elementAt(i) + " ");

		closeTag = "";
		preRecordData="";
		SQL = 		" select distinct";
		SQL = SQL + " coalesce(H.dimension_seq,0) AS dimension_seq,H.Name AS Hname,";
		SQL = SQL + " coalesce(P.part_seq,0) AS part_seq,P.name AS Pname";
		SQL = SQL + " from oo_dimension H";
		SQL = SQL + " left outer join oo_dimension_part P on (H.dimension_seq=P.dimension_seq)";
		SQL = SQL + " where H.dim_type='2'";
		SQL = SQL + " AND H.dimension_seq<>-1";
		SQL = SQL + " AND H.user_seq = " + vecSeq.elementAt(i);
		SQL = SQL + " order by 1,3";
		rs = stmt.executeQuery(SQL);
		if (rs.next()) {
			out.println("<CustomSegmentDimension ID='" + rs.getString("dimension_seq") + ",0'>" + rs.getString("Hname") + "\n");
			if ( !(rs.getString("part_seq")).equals("0") ) {
				out.println("\n<SegmentParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
				out.println("</SegmentParts>\n\n");
			}
			preRecordData=rs.getString("dimension_seq");
			closeTag = "</CustomSegmentDimension>\n";
		}

		while (rs.next()) {
			if ( preRecordData.equals(rs.getString("dimension_seq")) ) {
				out.print  ("<SegmentParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
				out.println("</SegmentParts>\n");
			} else {
				out.println("</CustomSegmentDimension>\n");
				//out.println("<CustomSegmentDimension ID='" + rs.getString("dimension_seq") + "'>" + rs.getString("Hname") + " ");
				out.println("<CustomSegmentDimension ID='" + rs.getString("dimension_seq") + ",0'>" + rs.getString("Hname") + " ");
				if ( !(rs.getString("part_seq")).equals("0") ) {
					out.print  ("<SegmentParts ID='" + rs.getString("dimension_seq") + "," + rs.getString("part_seq") + "'>" + rs.getString("Pname") + " ");
					out.println("</SegmentParts>\n");
				}
			}
			preRecordData=rs.getString("dimension_seq");
		}
		rs.close();
		out.println(closeTag);


		out.println("</CustomSegDimSchema>\n");

	}


%>
		</CustomSegmentDimensionTop>


	</CustomizeDimensionTop>






</CubeModeling>

<CubeManager ID='CubeManager'>キューブマネージャー
	<SQLTuning ID='SQLTuning'>SQLチューニング

<%
	closeTag = "";
	preRecordData="";

	String cubeSeq="";

	SQL = 		" SELECT DISTINCT";
	SQL = SQL + " C.cube_seq AS cube_seq,C.name AS Cname";
	SQL = SQL + " FROM oo_cube C";
	SQL = SQL + " ORDER by c.cube_seq";
	rs = stmt.executeQuery(SQL);
	while (rs.next()) {
		cubeSeq=rs.getString("cube_seq");
		out.println("<SQLTuningCube LV='0' ID='" + cubeSeq + ",0'>" + rs.getString("Cname") + " ");
			out.print("<SQLTuningCategory LV='0' ID='" + cubeSeq + ",1'>キューブ定義</SQLTuningCategory>");
			out.print("<SQLTuningCategory LV='0' ID='" + cubeSeq + ",2'>データロード</SQLTuningCategory>");
			out.print("<SQLTuningCategory LV='0' ID='" + cubeSeq + ",3'>集計</SQLTuningCategory>");
			out.print("<SQLTuningCategory LV='0' ID='" + cubeSeq + ",4'>カスタムメジャー</SQLTuningCategory>");
		out.println("</SQLTuningCube>\n");
	}
	rs.close();

%>
	</SQLTuning>
	<CreateCube ID=''>キューブ作成
	</CreateCube>

</CubeManager>
</OpenOlap>

