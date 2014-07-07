<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%@ page errorPage="ErrorPage.jsp"%>
<%@ include file="../../connect.jsp" %>

<%


String obj_nm="";
String obj_id="";
String nm="";
//String[] cubeMeasureId = new String[256];
//String[] cubeMeasureName = new String[256];
//int cubeMeasureCnt=0;

//String[] cubeMeasureFormulaId = new String[256];
//String[] cubeMeasureFormulaName = new String[256];
//int cubeMeasureFormulaCnt=0;

String Sql = "";
String Sql2 = "";
String copyObj_objKind= request.getParameter("copyObj_objKind");
String copyObj_id= request.getParameter("copyObj_id");
String copyParentObj_objKind= request.getParameter("copyParentObj_objKind");
String copyParentObj_id= request.getParameter("copyParentObj_id");

String copyObj_id0 = "";
String copyObj_id1 = "";
String copyParentObj_id0 = "";
String copyParentObj_id1 = "";

StringTokenizer st = new StringTokenizer(copyObj_id, ",");//カンマ区切りの文字列を分割
if (st.countTokens() != 2) {
	copyObj_id1 = copyObj_id;
} else {
	copyObj_id0 = st.nextToken();
	copyObj_id1 = st.nextToken();
}
st = new StringTokenizer(copyParentObj_id, ",");//カンマ区切りの文字列を分割
if (st.countTokens() != 2) {
	copyParentObj_id1 = copyParentObj_id;
} else {
	copyParentObj_id0 = st.nextToken();
	copyParentObj_id1 = st.nextToken();
}


String tempSeq = "";
String tempSeq2 = "";
String tempSeq3 = "";
int exeCount = 0;

String new_temptable_name = "";
String old_temptable_name = "";

String tempString = "";

String tempTableName = "TEMP"+session.getCreationTime();
String tempTableName2 = "TEMP2"+session.getCreationTime();


String strName = "";

if(("Dimension".equals(copyObj_objKind))||("SegmentDimension".equals(copyObj_objKind))){//**********************Dimension******************************


		//oo_dimension
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_dimension";
		Sql = Sql + " WHERE dimension_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//シーケンス取得
		Sql =       " SELECT NEXTVAL('oo_dimension_seq') as seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			tempSeq = rs.getString("seq");
		}
		rs.close();

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " dimension_seq = " + tempSeq;
		Sql = Sql + " ,name = 'copy_' || SUBSTRING(name FROM 1 FOR 25)";
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_dimension";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//名前取得
		Sql =       " SELECT name FROM " + tempTableName;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strName = rs.getString("name");
		}
		rs.close();

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);


		//oo_dimension_part
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_dimension_part";
		Sql = Sql + " WHERE dimension_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " dimension_seq = " + tempSeq;
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_dimension_part";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);




		//oo_level,oo_level_chart
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_level";
		Sql = Sql + " WHERE dimension_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);
		Sql =       " CREATE TABLE " + tempTableName2 + " AS";
		Sql = Sql + " SELECT * FROM oo_level_chart";
		Sql = Sql + " WHERE dimension_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		Sql =       " SELECT level_seq FROM oo_level WHERE dimension_seq = " + copyObj_id1;
		Sql = Sql + " ORDER BY level_seq";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			//シーケンス取得
			Sql =       " SELECT NEXTVAL('oo_level_seq') as seq";
			rs2 = stmt2.executeQuery(Sql);
			if (rs2.next()) {
				tempSeq2 = rs2.getString("seq");
			}
			rs2.close();

			//アップデート
			Sql2 =       " UPDATE " + tempTableName + " SET ";
			Sql2 = Sql2 + " level_seq = " + tempSeq2;
			Sql2 = Sql2 + " ,dimension_seq = " + tempSeq;
			Sql2 = Sql2 + " where level_seq = " + rs.getString("level_seq");
			exeCount = stmt2.executeUpdate(Sql2);
			Sql2 =       " UPDATE " + tempTableName2 + " SET ";
			Sql2 = Sql2 + " level_seq = " + tempSeq2;
			Sql2 = Sql2 + " ,dimension_seq = " + tempSeq;
			Sql2 = Sql2 + " where level_seq = " + rs.getString("level_seq");
			exeCount = stmt2.executeUpdate(Sql2);
		}
		rs.close();

		//レコード作成
		Sql =       " INSERT INTO oo_level";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);
		Sql =       " INSERT INTO oo_level_chart";
		Sql = Sql + " SELECT * FROM " + tempTableName2;
		exeCount = stmt.executeUpdate(Sql);

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);
		Sql =       " DROP TABLE " + tempTableName2;
		exeCount = stmt.executeUpdate(Sql);



		//TABLE作成
		Sql =       "CREATE TABLE " + session.getValue("loginSchema") + "." + "oo_dim_" + tempSeq + "_1 AS SELECT * FROM oo_dim_" + copyObj_id1 + "_1";
		exeCount = stmt.executeUpdate(Sql);

		//PK作成
		Sql =       "CREATE UNIQUE INDEX " + "oo_dim_" + tempSeq + "_1_pk ON oo_dim_" + tempSeq + "_1 (key)";
		exeCount = stmt.executeUpdate(Sql);

		//INDEX作成
		Sql =       "CREATE INDEX " + "oo_dim_" + tempSeq + "_1_idx ON oo_dim_" + tempSeq + "_1 (par_key)";
		exeCount = stmt.executeUpdate(Sql);

		//SEQUENCE作成
		int newStartSeq = 0;
		Sql =       " SELECT MAX(key) AS key FROM " + session.getValue("loginSchema") + "." + "oo_dim_" + tempSeq + "_1";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			newStartSeq = rs.getInt("key") + 1;
		}
		if(rs.getInt("key")==-1){//セグメントディメンションの場合
			newStartSeq=1;
		}
		rs.close();
		Sql =       "CREATE SEQUENCE " + session.getValue("loginSchema") + "." + "oo_s_dim_" + tempSeq + "_seq START " + newStartSeq;
		exeCount = stmt.executeUpdate(Sql);

		//
//		Sql =       "SELECT oo_dim_member(" + tempSeq + ") as a";
//		rs = stmt.executeQuery(Sql);


}else if("TimeDimension".equals(copyObj_objKind)){//**********************TimeDimension******************************


		//oo_time
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_time";
		Sql = Sql + " WHERE time_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//シーケンス取得
		Sql =       " SELECT NEXTVAL('oo_dimension_seq') as seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			tempSeq = rs.getString("seq");
		}
		rs.close();

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " time_seq = " + tempSeq;
		Sql = Sql + " ,name = 'copy_' || SUBSTRING(name FROM 1 FOR 25)";
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_time";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//名前取得
		Sql =       " SELECT name FROM " + tempTableName;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strName = rs.getString("name");
		}
		rs.close();

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);


		//TABLE作成
		Sql =       "CREATE TABLE " + session.getValue("loginSchema") + "." + "oo_dim_" + tempSeq + "_1 AS SELECT * FROM oo_dim_" + copyObj_id1 + "_1";
		exeCount = stmt.executeUpdate(Sql);

		//PK作成
		Sql =       "CREATE UNIQUE INDEX " + "oo_dim_" + tempSeq + "_1_pk ON oo_dim_" + tempSeq + "_1 (key)";
		exeCount = stmt.executeUpdate(Sql);

		//INDEX作成
		Sql =       "CREATE INDEX " + "oo_dim_" + tempSeq + "_1_idx ON oo_dim_" + tempSeq + "_1 (par_key)";
		exeCount = stmt.executeUpdate(Sql);
/*
		//SEQUENCE作成
		int newStartSeq = 0;
		Sql =       " SELECT MAX(key) AS key FROM " + session.getValue("loginSchema") + "." + "oo_dim_" + tempSeq + "_1";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			newStartSeq = rs.getInt("key") + 1;
		}
		rs.close();
	//	Sql =       "CREATE SEQUENCE " + session.getValue("loginSchema") + "." + "oo_s_dim_" + newStartSeq + "_seq";
		Sql =       "CREATE SEQUENCE " + session.getValue("loginSchema") + "." + "oo_s_dim_" + tempSeq + "_seq START " + newStartSeq;
		exeCount = stmt.executeUpdate(Sql);
*/
		//
//		Sql = "";
//		Sql = Sql + "SELECT oo_create_time_dim(" + newStartSeq + ") as a";
//		rs = stmt.executeQuery(Sql);


}else if("Measure".equals(copyObj_objKind)){//**********************Measure******************************


		//oo_measure
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_measure";
		Sql = Sql + " WHERE measure_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//シーケンス取得
		Sql =       " SELECT NEXTVAL('oo_measure_seq') as seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			tempSeq = rs.getString("seq");
		}
		rs.close();

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " measure_seq = " + tempSeq;
		Sql = Sql + " ,name = 'copy_' || SUBSTRING(name FROM 1 FOR 25)";
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_measure";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//名前取得
		Sql =       " SELECT name FROM " + tempTableName;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strName = rs.getString("name");
		}
		rs.close();

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);


		//oo_measure_link
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_measure_link";
		Sql = Sql + " WHERE measure_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " measure_seq = " + tempSeq;
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_measure_link";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);


		//oo_measure_chart
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_measure_chart";
		Sql = Sql + " WHERE measure_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " measure_seq = " + tempSeq;
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_measure_chart";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);



}else if("Cube".equals(copyObj_objKind)){//**********************Cube******************************


		//oo_cube
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_cube";
		Sql = Sql + " WHERE cube_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//シーケンス取得
		Sql =       " SELECT NEXTVAL('oo_cube_seq') as seq";
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			tempSeq = rs.getString("seq");
		}
		rs.close();

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " cube_seq = " + tempSeq;
		Sql = Sql + " ,name = 'copy_' || SUBSTRING(name FROM 1 FOR 25)";
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_cube";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//名前取得
		Sql =       " SELECT name FROM " + tempTableName;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strName = rs.getString("name");
		}
		rs.close();

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);


		//oo_cube_structure
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_cube_structure";
		Sql = Sql + " WHERE cube_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " cube_seq = " + tempSeq;
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_cube_structure";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);






}else if(("DimParts".equals(copyObj_objKind))||("SegmentParts".equals(copyObj_objKind))){//********************** ******************************


		//oo_dimension
		//テーブル作成
		Sql =       " CREATE TABLE " + tempTableName + " AS";
		Sql = Sql + " SELECT * FROM oo_dimension_part";
		Sql = Sql + " WHERE dimension_seq = " + copyObj_id0;
		Sql = Sql + " AND part_seq = " + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//シーケンス取得
	//	Sql =       " SELECT NEXTVAL('oo_dimension_seq') as seq";
		Sql = "SELECT MAX(part_seq)+1 as seq FROM oo_dimension_part WHERE dimension_seq = " + copyObj_id0;
		rs = stmt.executeQuery(Sql);
		if (rs.next()) {
			tempSeq = rs.getString("seq");
		}
		rs.close();

		//アップデート
		Sql =       " UPDATE " + tempTableName + " set ";
		Sql = Sql + " part_seq = " + tempSeq;
		Sql = Sql + " ,name = 'copy_' || SUBSTRING(name FROM 1 FOR 25)";
		exeCount = stmt.executeUpdate(Sql);

		//レコード作成
		Sql =       " INSERT INTO oo_dimension_part";
		Sql = Sql + " SELECT * FROM " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);

		//名前取得
		Sql =       " SELECT name FROM " + tempTableName;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			strName = rs.getString("name");
		}
		rs.close();

		//テーブル削除
		Sql =       " DROP TABLE " + tempTableName;
		exeCount = stmt.executeUpdate(Sql);




		//TABLE作成
		Sql =       "CREATE TABLE " + session.getValue("loginSchema") + "." + "oo_dim_" + copyObj_id0 + "_" + tempSeq + " AS SELECT * FROM oo_dim_" + copyObj_id0 + "_" + copyObj_id1;
		exeCount = stmt.executeUpdate(Sql);

		//PK作成
		Sql =       "CREATE UNIQUE INDEX " + "oo_dim_" + copyObj_id0 + "_" + tempSeq + "_pk ON oo_dim_" + copyObj_id0 + "_" + tempSeq + " (key)";
		exeCount = stmt.executeUpdate(Sql);

		//INDEX作成
		Sql =       "CREATE INDEX " + "oo_dim_" + copyObj_id0 + "_" + tempSeq + "_idx ON oo_dim_" + copyObj_id0 + "_" + tempSeq + " (par_key)";
		exeCount = stmt.executeUpdate(Sql);

	//	//SEQUENCE作成
	//	int newStartSeq = 0;
	//	Sql =       " SELECT MAX(key) AS key FROM " + session.getValue("loginSchema") + "." + "oo_dim_" + copyObj_id0 + "_" + copyObj_id1;
	//	rs = stmt.executeQuery(Sql);
	//	if (rs.next()) {
	//		newStartSeq = rs.getInt("key") + 1;
	//	}
	//	rs.close();
	//	Sql =       "CREATE SEQUENCE " + session.getValue("loginSchema") + "." + "oo_s_dim_" + copyObj_id0 + "_seq START " + newStartSeq;
	//	exeCount = stmt.executeUpdate(Sql);

		//
//		Sql =       "SELECT oo_dim_member(" + tempSeq + ") as a";
//		rs = stmt.executeQuery(Sql);


}



%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="javascript">
		function load(){

	<%
		String strArgument = "";
		if("".equals(copyObj_id0)){
			strArgument = tempSeq;
		}else{
			strArgument = copyObj_id0 + "," + tempSeq;
		}
	%>
			
			parent.parent.navi_frm.addObjects("<%=copyObj_objKind%>",9,"<%=strArgument%>","<%=strName%>");
			parent.parent.navi_frm.showMsg("COM1");
			location.replace("blank.jsp");

		}
	</script>
</head>
<body onload="load()">
</body>
</html>
