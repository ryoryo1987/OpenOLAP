<%@ page language="java" contentType="text/html;charset=Shift_JIS" import="designer.ood"%>
<%@ page import = "java.util.*"%>
<%//@ page errorPage="ErrorPage.jsp"%>

<%@ include file="../../connect.jsp" %>
<%
String Sql="";
int tp = Integer.parseInt(request.getParameter("tp"));
int exeCount=0;

String strName = request.getParameter("txt_name");
String strComment = request.getParameter("txt_comment");
String strTotalFlg = "";
String userName="";

if(request.getParameter("chk_total")==null){
	strTotalFlg="0";
}else{
	strTotalFlg="1";
}
String strSortType = request.getParameter("lst_sorttype");
String strSortOrder = request.getParameter("lst_sortorder");



String strDimType=(String)session.getValue("dimType");
String strSegDataType="";
if(request.getParameter("lst_seg_data_type")!=null){
	strSegDataType=request.getParameter("lst_seg_data_type");
}
String strOtherMemberFlg="0";
if(request.getParameter("chk_other_member_flg")!=null){
	strOtherMemberFlg=request.getParameter("chk_other_member_flg");
}

String strUserSeq = request.getParameter("hid_user_seq");
String objSeq = request.getParameter("hid_obj_seq");
String objKind=request.getParameter("hid_obj_kind");

int mojiretsuCount = 0;


%>

<%
	//tp=9は「SQL Viewer」表示用であり、仮ID「-1」で登録する



	Sql = "DELETE FROM oo_level";
	Sql = Sql + " WHERE dimension_seq = -1";//SQLViewer用
	if(tp!=9){
		Sql = Sql + " OR dimension_seq = " + objSeq;
	}
	exeCount = stmt.executeUpdate(Sql);


	Sql = "DELETE FROM oo_dimension";
	Sql = Sql + " WHERE dimension_seq = -1";//SQLViewer用
	if(tp!=9){
		Sql = Sql + " OR dimension_seq = " + objSeq;
	}
	exeCount = stmt.executeUpdate(Sql);




	if(tp!=9){
		Sql = "DELETE FROM oo_dimension_part";
		Sql = Sql + " WHERE dimension_seq = " + objSeq;
		Sql = Sql + " AND part_seq=1";
		exeCount = stmt.executeUpdate(Sql);

		Sql = "DELETE FROM oo_level_chart";
		Sql = Sql + " WHERE dimension_seq = " + objSeq;
		exeCount = stmt.executeUpdate(Sql);
	}


	if(tp==0){


		//SEQUENCE 取得
		Sql = "SELECT nextval('oo_dimension_seq') as seq_no";

		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			objSeq = rs.getString("seq_no");
		}
		rs.close();


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

		Sql = "";
		Sql = Sql + "create sequence " + session.getValue("loginSchema") + "." + "oo_s_dim_" + objSeq + "_seq";
		exeCount = stmt.executeUpdate(Sql);


	}

	if(tp!=2){


		//スキーマ名取得
		Sql = "SELECT name FROM oo_user WHERE user_seq = " + strUserSeq;
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			userName = rs.getString("name");
		}
		rs.close();



		if(tp==9){
			objSeq = "-1";//SQLViewer用tempディメンションSEQ
		}


		//新規登録
		Sql = "INSERT INTO oo_dimension (";
		Sql = Sql + "dimension_seq";
		Sql = Sql + ",name";
		Sql = Sql + ",comment";
		Sql = Sql + ",total_flg";
		Sql = Sql + ",sort_type";
		Sql = Sql + ",sort_order";
		Sql = Sql + ",user_seq";
		Sql = Sql + ",dim_type";
		Sql = Sql + ",seg_datatype";
		Sql = Sql + ",other_member_flg";
		Sql = Sql + ")VALUES(";
		Sql = Sql + "" + objSeq;
		Sql = Sql + ",'" + strName + "'";
		Sql = Sql + ",'" + strComment + "'";
		Sql = Sql + ",'" + strTotalFlg + "'";
		Sql = Sql + ",'" + strSortType + "'";
		Sql = Sql + ",'" + strSortOrder + "'";
		Sql = Sql + ",'" + strUserSeq + "'";
		Sql = Sql + ",'" + strDimType + "'";
		Sql = Sql + ",'" + strSegDataType + "'";
		Sql = Sql + ",'" + strOtherMemberFlg + "'";
		Sql = Sql + ")";
		exeCount = stmt.executeUpdate(Sql);

		int i=0;
		StringTokenizer st = new StringTokenizer(request.getParameter("hid_levelseq_string"), ",");//カンマ区切りの文字列を分割
		while (st.hasMoreTokens()) {
			i--;
			String levelSeq = st.nextToken();
			Sql = "INSERT INTO oo_level (";
			Sql = Sql + "level_seq";
			Sql = Sql + ",dimension_seq";
			Sql = Sql + ",level_no";
			Sql = Sql + ",name";
			Sql = Sql + ",comment";
			Sql = Sql + ",table_name";
			Sql = Sql + ",long_name_col";
			Sql = Sql + ",short_name_col";
			Sql = Sql + ",sort_col";
		//	Sql = Sql + ",sort_type";
		//	Sql = Sql + ",sort_order";
			Sql = Sql + ",key_col1";
			Sql = Sql + ",key_col2";
			Sql = Sql + ",key_col3";
			Sql = Sql + ",key_col4";
			Sql = Sql + ",key_col5";
			Sql = Sql + ",link_col1";
			Sql = Sql + ",link_col2";
			Sql = Sql + ",link_col3";
			Sql = Sql + ",link_col4";
			Sql = Sql + ",link_col5";
			Sql = Sql + ",where_clause";
			Sql = Sql + ")VALUES(";
			if(tp!=9){
				Sql = Sql + "" + levelSeq;
			}else if(tp==9){//SqlViewer用tempレコード
				Sql = Sql + "" + i;
			}
			Sql = Sql + ",'" + objSeq + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_level_no") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_name") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_comment") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_table") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_longname") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_shortname") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_sortcol") + "'";
		//	Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_sorttype") + "'";
		//	Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_sortorder") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_keycol1") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_keycol2") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_keycol3") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_keycol4") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_keycol5") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_m_linkcol1") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_m_linkcol2") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_m_linkcol3") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_m_linkcol4") + "'";
			Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_m_linkcol5") + "'";
			if("1".equals(strDimType)){
				Sql = Sql + ",'" + ood.replace(ood.replace(request.getParameter("hid_lv" + levelSeq + "_where_clause"),"'","''"),"\\","\\\\") + "'";
			}else if("2".equals(strDimType)){
				Sql = Sql + ",''";
			}
			Sql = Sql + ")";
		//	out.println(Sql);
			exeCount = stmt.executeUpdate(Sql);

			if(tp!=9){
				Sql = "INSERT INTO oo_level_chart (";
				Sql = Sql + "level_seq";
				Sql = Sql + ",dimension_seq";
				Sql = Sql + ",x_point";
				Sql = Sql + ",y_point";
				Sql = Sql + ")VALUES(";
				Sql = Sql + "" + levelSeq;
				Sql = Sql + ",'" + objSeq + "'";
				Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_x_point") + "'";
				Sql = Sql + ",'" + request.getParameter("hid_lv" + levelSeq + "_y_point") + "'";
				Sql = Sql + ")";
				exeCount = stmt.executeUpdate(Sql);
			}

		}



		if(tp!=9){

			//新規登録
			Sql = "INSERT INTO oo_dimension_part (";
			Sql = Sql + "dimension_seq";
			Sql = Sql + ",part_seq";
			Sql = Sql + ",name";
			Sql = Sql + ",comment";
			Sql = Sql + ",part_type";
			Sql = Sql + ",add_member_flg";
			Sql = Sql + ",rename_member_flg";
			Sql = Sql + ",delete_member_flg";
			Sql = Sql + ")VALUES(";
			Sql = Sql + "" + objSeq;
			Sql = Sql + ",'1'";
			Sql = Sql + ",'標準'";
			Sql = Sql + ",''";
			Sql = Sql + ",NULL";
			Sql = Sql + ",NULL";
			Sql = Sql + ",NULL";
			Sql = Sql + ",NULL";
			Sql = Sql + ")";
			exeCount = stmt.executeUpdate(Sql);


			if("1".equals(strDimType)){

				Sql = "";
				Sql = Sql + "select oo_dim_member(" + objSeq + ",'" + userName + "') as a";
				rs = stmt.executeQuery(Sql);

				Sql = "";
				Sql = Sql + "select count(*) as mojiretsu_count from oo_dim_"+objSeq+"_1 where sort_col>'9'";
				rs = stmt.executeQuery(Sql);
				if(rs.next()){
					mojiretsuCount = rs.getInt("mojiretsu_count");
				}
				rs.close();

				if((mojiretsuCount!=0)&&(strSortType.equals("2"))){
					Sql = "";
					Sql = Sql + "update oo_dimension set sort_type='1' where dimension_seq = '" + objSeq + "'";//ソートタイプを数値型に書き換える
					stmt.executeUpdate(Sql);
				}


				Sql = "";
				Sql = Sql + "select oo_dim_level_adjust(" + objSeq + ",1) as a";
				rs = stmt.executeQuery(Sql);

			}else if("2".equals(strDimType)){
				if((tp==0)||(tp==1)){//「その他」パーツ
					if("1".equals(strOtherMemberFlg)){
						Sql = "INSERT INTO oo_dim_" + objSeq + "_1 (";
						Sql = Sql + "KEY";
						Sql = Sql + ",ORG_LEVEL";
						Sql = Sql + ",LONG_NAME";
						Sql = Sql + ",SHORT_NAME";
						Sql = Sql + ",CALC_TEXT";
						Sql = Sql + ",MIN_VAL";
						Sql = Sql + ",MAX_VAL";
						Sql = Sql + ")VALUES(";
						Sql = Sql + "-1";
						Sql = Sql + ",0";
						Sql = Sql + ",'その他'";
						Sql = Sql + ",'その他'";
						Sql = Sql + ",''";
						Sql = Sql + ",NULL";
						Sql = Sql + ",NULL";
						Sql = Sql + ")";
						try{
							exeCount = stmt.executeUpdate(Sql);
						}catch(SQLException e){
							out.println(e);
						}
						//	out.println("sonota");
					}else{
						Sql = "DELETE FROM  oo_dim_" + objSeq + "_1";
						Sql = Sql + " WHERE KEY = -1";
						try{
							exeCount = stmt.executeUpdate(Sql);
						}catch(SQLException e){
							out.println(e);
						}
					}

					//dummyファンクション作成
					Sql = "CREATE OR REPLACE FUNCTION " + session.getValue("loginSchema") + ".oo_seg_func_" + objSeq + "_1(numeric,text) RETURNS integer AS '";
					Sql = Sql + " DECLARE";
					Sql = Sql + " vNum_val   ALIAS FOR $1;";
					Sql = Sql + " vText_val   ALIAS FOR $2;";
					Sql = Sql + " retKey     integer;";
					Sql = Sql + " BEGIN";
					Sql = Sql + " 	return -1;";
					Sql = Sql + " END;";
					Sql = Sql + " 'LANGUAGE 'plpgsql'";
					exeCount = stmt.executeUpdate(Sql);

					Sql = "";
					Sql = Sql + "select oo_dim_member(" + objSeq + ",'" + userName + "') as a";
					rs = stmt.executeQuery(Sql);

					Sql = "";
					Sql = Sql + "select count(*) as mojiretsu_count from oo_dim_"+objSeq+"_1 where sort_col>9";
					rs = stmt.executeQuery(Sql);
					if(rs.next()){
						mojiretsuCount = rs.getInt("mojiretsu_count");
					}
					rs.close();

					if((mojiretsuCount!=0)&&(strSortType.equals("2"))){
						Sql = "";
						Sql = Sql + "update oo_dimension set sort_type='1' where dimension_seq = '" + objSeq + "'";//ソートタイプを数値型に書き換える
						stmt.executeUpdate(Sql);
					}

					Sql = "";
					Sql = Sql + "select oo_dim_level_adjust(" + objSeq + ",1) as a";
					rs = stmt.executeQuery(Sql);


				}
			}







		}

/*
		Sql = "";
		Sql = Sql + "show search_path";
		rs = stmt.executeQuery(Sql);
		if(rs.next()){
			out.println(rs.getString("search_path"));
		}
		rs.close();
*/
	}


	if(tp==2){

		Sql = "";
		Sql = Sql + "DROP TABLE oo_dim_" + objSeq + "_1";
		exeCount = stmt.executeUpdate(Sql);

		Sql = "";
		Sql = Sql + "DROP SEQUENCE oo_s_dim_" + objSeq + "_seq";
		exeCount = stmt.executeUpdate(Sql);

	}


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<title>OpenOLAP Model Designer</title>
	<script language="JavaScript">
	function load(){

		<%if((mojiretsuCount!=0)&&(strSortType.equals("2"))){%>
			alert("ソートカラムに文字列が含まれていますので、ソートタイプは「文字列」に変更されました。");
		<%}%>


		<%if(tp==9){%>
			window.open("../frm_sqlviewer.jsp?schemaName=<%=userName%>","_blank","menubar=no,toolbar=no,resizable=yes,width=700,height=500");
		<%}else{%>
			parent.parent.navi_frm.addObjects("<%=objKind%>",<%=tp%>,"<%=strUserSeq%>,<%=objSeq%>","<%=strName%>");
		<%}%>
		location.replace("blank.jsp");

	}
	</script>
</head>
<body onload="load()">
<%
/*
			Sql = "select oo_dim_sql(-1,'0') as sql";
			rs = stmt.executeQuery(Sql);
			if(rs.next()){
				out.println(rs.getString("sql"));
			}
			rs.close();
*/


%>
</body>
</html>