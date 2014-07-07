package designer;

import java.util.*;
import java.sql.*;
import designer.ood;


/**
*このクラスは、キューブに対するSQLを生成します。
*<BR>OpenOLAP Designer GUI・バッチツール共に、このクラスを使用します。
@author IAF Consulting, Inc.
@see designer.ood
*/
public class GenerateSql {


	/**
	*OpenOLAP Designer GUI内部モジュール・バッチツールにて入力される引数をもとに、キューブ処理を行うSQLを生成し、配列に格納します。
	*@param connMeta OpenOLAP Meta へのコネクション
	*@param schemaName OpenOLAP メタスキーマ
	*@param cubeSeq キューブID
	*@param processNum プロセス番号
	*@param dataloadTimeKind データロード対象期間を指定する際の期間種別
	*@param intPast データロード対象期間の過去期間数
	*@param intFuture データロード対象期間の未来期間数
	*@param originalFlg オリジナルSQL生成フラグ　（1:メタ情報のみをもとにSQLを生成する　0:カスタマイズSQLがあれば使用する）
	*/
	public static Hashtable main(Connection connMeta,String schemaName,String cubeSeq,String processNum,String dataloadTimeKind,int intPast,int intFuture,int originalFlg) throws Exception{



		Hashtable<String,String> sHash = new Hashtable<String,String>();
		Hashtable<String,String[]> sHashArray = new Hashtable<String,String[]>();

		Statement stmt = connMeta.createStatement();
		Statement stmt2 = connMeta.createStatement();
		ResultSet rs = null;
		ResultSet rs2 = null;



		int d;
		int i;
		int m;
		int md;
		int ml;
		int mk;
		int mks;
		int dimension;
		int l;
		int f;
		String Sql="";
		String strTemp="";
		String strTemp2="";
		String strTemp3="";
		String strFunction="";
		String strView="";
		String strCMFunction="";
		String strCubeName="cube_" + cubeSeq;
		String strInsert="";
		String strSelect="";
		String strFrom="";
		String strWhere="";
		String strGroupBy="";
		int custmizeFlg=0;
		String custmizeSql="";
		boolean timeExsitFlg = false;
		int timeSeq = 0;
		int timePartSeq = 0;
		String timeName = "";

		String[] arrSql = new String[1000];
		String[] arrMsg = new String[1000];
	//	String[] arrIgnore = new String[1000];
		int sqlNo = 0;

		String[] arrCFname = new String[1000];
		String[] arrCFtext = new String[1000];

		String custmizedFlg="0";
		String[] arrInfoMesSeq = new String[1000];
		String[] arrInfoMesName = new String[1000];
		String[] arrInfoMesType = new String[1000];
		int intInfoMes=0;

		String[] arrInfoSql = new String[100];


		//スキーマ検索パスの設定
		Sql = "SET search_path TO " + schemaName + ",public";
		int exeCount = stmt.executeUpdate(Sql);






		Sql="SELECT m.user_seq,c.dimension_seq,c.time_dim_flg,c.part_seq,c.dimension_no,d.total_flg,d.dim_type,d.seg_datatype,d.name,u.name as user_name";
		Sql=Sql+" FROM (oo_cube_structure c";
		Sql=Sql+" LEFT OUTER JOIN oo_dimension d on (c.dimension_seq=d.dimension_seq))";
		Sql=Sql+" LEFT OUTER JOIN oo_user u on (u.user_seq=d.user_seq)";
		Sql=Sql+" ,oo_measure m";
		Sql=Sql+" WHERE c.cube_seq=" + cubeSeq;
		Sql=Sql+" AND c.measure_seq=(SELECT measure_seq FROM oo_cube_structure WHERE cube_seq = " + cubeSeq + " limit 1)";
		Sql=Sql+" AND c.measure_seq=m.measure_seq";
		Sql=Sql+" ORDER BY c.dimension_no";
		sHash.put("dimCount",Integer.toString(0));
		d=0;
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			d++;
			sHash.put("Nd" + d + "_seq",rs.getString("dimension_seq"));

			sHash.put("d" + rs.getString("dimension_seq") + "_seq",rs.getString("dimension_seq"));
			if (rs.getString("total_flg")==null){
				sHash.put("d" + rs.getString("dimension_seq") + "_name","");
			}else{
				sHash.put("d" + rs.getString("dimension_seq") + "_name",rs.getString("name"));
			}
			sHash.put("d" + rs.getString("dimension_seq") + "_time_dim_flg",rs.getString("time_dim_flg"));
			sHash.put("d" + rs.getString("dimension_seq") + "_part_seq",rs.getString("part_seq"));
			if (rs.getString("total_flg")==null){
				sHash.put("d" + rs.getString("dimension_seq") + "_total_flg","");
			}else{
				sHash.put("d" + rs.getString("dimension_seq") + "_total_flg",rs.getString("total_flg"));
			}
			if (rs.getString("dim_type")==null){
				sHash.put("d" + rs.getString("dimension_seq") + "_dim_type","");
			}else{
				sHash.put("d" + rs.getString("dimension_seq") + "_dim_type",rs.getString("dim_type"));
			}
			if (rs.getString("seg_datatype")==null){
				sHash.put("d" + rs.getString("dimension_seq") + "_seg_datatype","");
			}else{
				sHash.put("d" + rs.getString("dimension_seq") + "_seg_datatype",rs.getString("seg_datatype"));
			}
			sHash.put("d" + rs.getString("dimension_seq") + "_dimension_no",rs.getString("dimension_no"));
			if (rs.getString("user_name")==null){
				sHash.put("d" + rs.getString("dimension_seq") + "_schema_name","");
			}else{
				sHash.put("d" + rs.getString("dimension_seq") + "_schema_name",rs.getString("user_name"));
			}
		//	sHash.put("userSeq",rs.getString("user_seq"));
		//	sHash.put("userName",rs.getString("user_name"));



			if((d==1)&&("1".equals(rs.getString("time_dim_flg")))){
				//時間次元があれば時間次元情報を取得
				Sql="SELECT name,start_month,total_flg";
				Sql=Sql+" ,year_flg,year_long_name,year_short_name";
				Sql=Sql+" ,half_flg,half_long_name,half_short_name";
				Sql=Sql+" ,quarter_flg,quarter_long_name,quarter_short_name";
				Sql=Sql+" ,month_flg,month_long_name,month_short_name";
				Sql=Sql+" ,week_flg,week_long_name,week_short_name";
				Sql=Sql+" ,day_flg,day_long_name,day_short_name";
				Sql=Sql+" FROM oo_time";
				Sql=Sql+" WHERE time_seq=" + rs.getString("dimension_seq");
				sHash.put("d" + d + "_lvlCount",Integer.toString(0));
				l=0;
				rs2 = stmt2.executeQuery(Sql);
				if (rs2.next()) {
					timeExsitFlg=true;
					timeSeq=rs.getInt("dimension_seq");
					timePartSeq=rs.getInt("part_seq");
					timeName=rs2.getString("name");
					sHash.put("d" + rs.getString("dimension_seq") + "_name",rs2.getString("name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_total_flg",rs2.getString("total_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_year_flg",rs2.getString("year_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_year_long_name",rs2.getString("year_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_year_short_name",rs2.getString("year_short_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_half_flg",rs2.getString("half_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_half_long_name",rs2.getString("half_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_half_short_name",rs2.getString("half_short_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_quarter_flg",rs2.getString("quarter_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_quarter_long_name",rs2.getString("quarter_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_quarter_short_name",rs2.getString("quarter_short_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_month_flg",rs2.getString("month_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_month_long_name",rs2.getString("month_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_month_short_name",rs2.getString("month_short_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_week_flg",rs2.getString("week_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_week_long_name",rs2.getString("week_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_week_short_name",rs2.getString("week_short_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_day_flg",rs2.getString("day_flg"));
					sHash.put("d" + rs.getString("dimension_seq") + "_day_long_name",rs2.getString("day_long_name"));
					sHash.put("d" + rs.getString("dimension_seq") + "_day_short_name",rs2.getString("day_short_name"));

					if("1".equals(rs2.getString("year_flg"))){
						l++;
					}
					if("1".equals(rs2.getString("half_flg"))){
						l++;
					}
					if("1".equals(rs2.getString("quarter_flg"))){
						l++;
					}
					if("1".equals(rs2.getString("month_flg"))){
						l++;
					}
					if("1".equals(rs2.getString("week_flg"))){
						l++;
					}
				//	if("1".equals(rs2.getString("day_flg"))){
						l++;
				//	}
				}
				rs2.close();
				sHash.put("d" + rs.getString("dimension_seq") + "_lvlCount",Integer.toString(l));

			}else{

				//通常次元
				Sql="SELECT level_seq,name,level_no,table_name,long_name_col,short_name_col,sort_col";
				Sql=Sql+" ,key_col1,key_col2,key_col3,key_col4,key_col5";
				Sql=Sql+" ,link_col1,link_col2,link_col3,link_col4,link_col5";
				Sql=Sql+" ,where_clause";
				Sql=Sql+" FROM oo_level";
				Sql=Sql+" WHERE dimension_seq=" + rs.getString("dimension_seq");
				Sql=Sql+" ORDER BY level_no";
				sHash.put("d" + rs.getString("dimension_seq") + "_lvlCount",Integer.toString(0));
				l=0;
				rs2 = stmt2.executeQuery(Sql);
				while (rs2.next()) {
					l++;
					//最下層のキーカラムを取得
					if (rs2.getString("key_col1")==null){
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col1","");
					}else{
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col1",rs2.getString("key_col1"));
					}
					if (rs2.getString("key_col2")==null){
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col2","");
					}else{
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col2",rs2.getString("key_col2"));
					}
					if (rs2.getString("key_col3")==null){
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col3","");
					}else{
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col3",rs2.getString("key_col3"));
					}
					if (rs2.getString("key_col4")==null){
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col4","");
					}else{
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col4",rs2.getString("key_col4"));
					}
					if (rs2.getString("key_col5")==null){
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col5","");
					}else{
						sHash.put("d" + rs.getString("dimension_seq") + "_key_col5",rs2.getString("key_col5"));
					}
				}
				rs2.close();
				sHash.put("d" + rs.getString("dimension_seq") + "_lvlCount",Integer.toString(l));


				Sql="";
				Sql=Sql+" SELECT MAX(cust_level) AS cust_level FROM oo_dim_" + rs.getString("dimension_seq") + "_" + rs.getString("part_seq");
				rs2 = stmt2.executeQuery(Sql);
				if (rs2.next()) {
					sHash.put("d" + rs.getString("dimension_seq") + "_custLvlCount",Integer.toString(rs2.getInt("cust_level")));
				}
				rs2.close();

			}


		}
		rs.close();
		sHash.put("dimCount",Integer.toString(d));









		//メジャー
		Sql="SELECT distinct m.measure_seq,m.name,m.fact_table,m.fact_col,cm.method_name as fact_calc_method,cm.method_sql,cm.method_sql as fact_calc_method_sql1,cm.method_sql2 as fact_calc_method_sql2,m.fact_where_clause,m.time_dim_flg,m.time_col,t.time_name_sql,u.name AS user_name";
		Sql=Sql+" FROM oo_measure m";
		Sql=Sql+" left outer join oo_time_format t on (m.time_format=t.time_name_format_cd)";
		Sql=Sql+" ,oo_cube_structure c";
		Sql=Sql+" ,oo_calc_method cm";
		Sql=Sql+" ,oo_user u";
		Sql=Sql+" WHERE c.cube_seq=" + cubeSeq;
		Sql=Sql+" AND c.measure_seq=m.measure_seq";
		Sql=Sql+" AND m.user_seq=u.user_seq";
		Sql=Sql+" AND m.fact_calc_method=cm.method_no";
		Sql=Sql+" AND (t.time_kind_cd='MEASURE' or t.time_kind_cd IS NULL)";
		Sql=Sql+" ORDER BY m.measure_seq";
		sHash.put("mesCount",Integer.toString(0));
		m=0;
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			m++;

			sHash.put("Nm" + m + "_seq",rs.getString("measure_seq"));

			sHash.put("m" + rs.getString("measure_seq") + "_seq",rs.getString("measure_seq"));
			sHash.put("m" + rs.getString("measure_seq") + "_name",rs.getString("name"));
			sHash.put("m" + rs.getString("measure_seq") + "_fact_table",rs.getString("fact_table"));
			sHash.put("m" + rs.getString("measure_seq") + "_fact_col",rs.getString("fact_col"));
			sHash.put("m" + rs.getString("measure_seq") + "_fact_calc_method",rs.getString("fact_calc_method"));
			sHash.put("m" + rs.getString("measure_seq") + "_fact_calc_method_sql1",rs.getString("fact_calc_method_sql1"));
			sHash.put("m" + rs.getString("measure_seq") + "_fact_calc_method_sql2",rs.getString("fact_calc_method_sql2"));
			if (rs.getString("fact_where_clause")==null){
				sHash.put("m" + rs.getString("measure_seq") + "_fact_where_clause","");
			}else{
				sHash.put("m" + rs.getString("measure_seq") + "_fact_where_clause",rs.getString("fact_where_clause"));
			}
			sHash.put("m" + rs.getString("measure_seq") + "_time_dim_flg",rs.getString("time_dim_flg"));
			if (rs.getString("time_col")==null){
				sHash.put("m" + rs.getString("measure_seq") + "_time_col","");
			}else{
				sHash.put("m" + rs.getString("measure_seq") + "_time_col",rs.getString("time_col"));
			}
			if (rs.getString("time_name_sql")==null){
				sHash.put("m" + rs.getString("measure_seq") + "_time_name_sql","");
			}else{
				sHash.put("m" + rs.getString("measure_seq") + "_time_name_sql",rs.getString("time_name_sql"));
			}

			sHash.put("m" + rs.getString("measure_seq") + "_schema_name",rs.getString("user_name"));

			arrInfoMesSeq[intInfoMes] = rs.getString("measure_seq");
			arrInfoMesName[intInfoMes] = rs.getString("name");
			arrInfoMesType[intInfoMes] = "1";
			intInfoMes++;



			Sql="SELECT l.dimension_seq";
			Sql=Sql+" ,l.fact_link_col1,l.fact_link_col2,l.fact_link_col3,l.fact_link_col4,l.fact_link_col5";
			Sql=Sql+" FROM oo_measure_link l";
			Sql=Sql+" ,oo_cube_structure c";
			Sql=Sql+" WHERE l.measure_seq=" + rs.getString("measure_seq");
			Sql=Sql+" AND c.cube_seq=" + cubeSeq;
			Sql=Sql+" AND l.measure_seq=c.measure_seq";
			Sql=Sql+" AND l.dimension_seq=c.dimension_seq";
			Sql=Sql+" ORDER BY l.dimension_seq";
			sHash.put("m" + rs.getString("measure_seq") + "_dimCount",Integer.toString(0));
			md=0;
			rs2 = stmt2.executeQuery(Sql);
			while (rs2.next()) {
				md++;

				sHash.put("m" + rs.getString("measure_seq") + "Nmd" + md + "_seq",rs2.getString("dimension_seq"));

				if (rs2.getString("fact_link_col1")==null){
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col1","");
				}else{
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col1",rs2.getString("fact_link_col1"));
				}
				if (rs2.getString("fact_link_col2")==null){
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col2","");
				}else{
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col2",rs2.getString("fact_link_col2"));
				}
				if (rs2.getString("fact_link_col3")==null){
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col3","");
				}else{
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col3",rs2.getString("fact_link_col3"));
				}
				if (rs2.getString("fact_link_col4")==null){
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col4","");
				}else{
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col4",rs2.getString("fact_link_col4"));
				}
				if (rs2.getString("fact_link_col5")==null){
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col5","");
				}else{
					sHash.put("m" + rs.getString("measure_seq") + "md" + rs2.getString("dimension_seq") + "_fact_link_col5",rs2.getString("fact_link_col5"));
				}

			}
			rs2.close();
			sHash.put("m" + rs.getString("measure_seq") + "_dimCount",Integer.toString(md));

		}
		rs.close();
		sHash.put("mesCount",Integer.toString(m));





		//メジャー種類（ファクトテーブル・WHERE句の組み合わせループ）
		Sql="SELECT distinct";
		Sql=Sql+" m.fact_table,m.fact_where_clause";
		Sql=Sql+" FROM oo_measure m";
		Sql=Sql+" ,oo_cube_structure c";
		Sql=Sql+" WHERE c.cube_seq=" + cubeSeq;
		Sql=Sql+" AND c.measure_seq=m.measure_seq";
		sHash.put("mesKindCount",Integer.toString(0));
		mk=0;
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			mk++;

			Sql="SELECT distinct m.measure_seq";
			Sql=Sql+" FROM oo_measure m";
			Sql=Sql+" ,oo_cube_structure c";
			Sql=Sql+" WHERE c.cube_seq=" + cubeSeq;
			Sql=Sql+" AND m.fact_table='" + rs.getString("fact_table") + "'";
			Sql=Sql+" AND m.fact_where_clause='" + ood.replace(rs.getString("fact_where_clause"),"'","''") + "'";
			Sql=Sql+" AND c.measure_seq=m.measure_seq";
			Sql=Sql+" ORDER BY measure_seq";
			sHash.put("mk" + mk + "_mesCount",Integer.toString(0));
			mks=0;
			rs2 = stmt2.executeQuery(Sql);
			while (rs2.next()) {
				mks++;
				sHash.put("mk" + mk + "mks" + mks + "_seq",rs2.getString("measure_seq"));
			}
			rs2.close();
			sHash.put("mk" + mk + "_mesCount",Integer.toString(mks));

		}
		rs.close();
		sHash.put("mesKindCount",Integer.toString(mk));



		//カスタムメジャー
		Sql = "SELECT name,formula_text FROM oo_formula WHERE cube_seq = " + cubeSeq + " ORDER BY formula_seq";
		rs = stmt.executeQuery(Sql);
		i=0;
		while(rs.next()){
			arrCFname[i]=rs.getString("name");
			arrCFtext[i]=rs.getString("formula_text");
			i++;
		}
		rs.close();

		Sql="SELECT ";
		Sql=Sql+" f.formula_seq,f.name,f.data_flg,f.formula_text";
		Sql=Sql+" FROM oo_formula f";
		Sql=Sql+" WHERE f.cube_seq=" + cubeSeq;
		Sql=Sql+" ORDER BY f.formula_seq";
		sHash.put("formulaCount",Integer.toString(0));
		f=0;
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			f++;
			sHash.put("f" + f + "_seq",rs.getString("formula_seq"));
			sHash.put("f" + f + "_name",rs.getString("name"));
			sHash.put("f" + f + "_data_flg",rs.getString("data_flg"));
			sHash.put("f" + f + "_formula_text",flatFormulaText(rs.getString("formula_text"),arrCFname,arrCFtext));

			arrInfoMesSeq[intInfoMes] = rs.getString("formula_seq");
			arrInfoMesName[intInfoMes] = rs.getString("name");
			if("1".equals(rs.getString("data_flg"))){
				arrInfoMesType[intInfoMes] = "2";
			}else{
				arrInfoMesType[intInfoMes] = "3";
			}
			intInfoMes++;

		}
		rs.close();
		sHash.put("formulaCount",Integer.toString(f));





		//カスタマイズの有無を取得
		Sql="SELECT script";
		Sql=Sql+" FROM oo_custom_sql";
		Sql=Sql+" WHERE cube_seq='" + cubeSeq + "'";
		rs = stmt.executeQuery(Sql);
		while (rs.next()) {
			custmizedFlg="1";
		}
		rs.close();




	/////////////////////////////////////////////////////////////////////////////////////////////////


		//ファンクション作成
		strTemp = "";
	//	strTemp=strTemp+"CREATE OR REPLACE FUNCTION " + schemaName + ".f_" + strCubeName + "(";
		strTemp=strTemp+"CREATE FUNCTION " + schemaName + ".f_" + strCubeName + "(";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			if(d!=1){
				strTemp=strTemp+",";
			}
			strTemp=strTemp+"integer";
		}
		strTemp=strTemp+") RETURNS numeric[] AS '";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"DECLARE";
		strTemp=strTemp+"\n";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			strTemp=strTemp+"vdim_" + addZero(d) + "     ALIAS FOR $" + d + ";";
			strTemp=strTemp+"\n";
		}
		strTemp=strTemp+"ret     " + schemaName + "." + strCubeName + "%rowtype;";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"retMeasure     numeric[];";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"BEGIN";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"SELECT INTO ret * ";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"FROM " + schemaName + "." + strCubeName;
		strTemp=strTemp+"\n";
		strTemp=strTemp+"WHERE";
		strTemp=strTemp+"\n";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			if(d!=1){
				strTemp=strTemp+"AND ";
			}
			strTemp=strTemp+"dim_" + addZero(d) + "=" +"vdim_" + addZero(d);
			if(d==Integer.parseInt((String)sHash.get("dimCount"))){
				strTemp=strTemp+";\n";
			}else{
				strTemp=strTemp+"\n";
			}
		}
		strTemp=strTemp+"\n";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"retMeasure:=''{''";
		strTemp=strTemp+"\n";
		for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
			if(m!=1){
				strTemp=strTemp+"'',''";
			}
			strTemp=strTemp+" || coalesce(ret." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ",0) ||";
			strTemp=strTemp+"\n";
		}


		strTemp2="";
		for(f=1;f<=Integer.parseInt((String)sHash.get("formulaCount"));f++){

			if("1".equals((String)sHash.get("f" + f + "_data_flg"))){
				strTemp2=strTemp2+"'',''";
				strTemp2=strTemp2+" || ";
				strTemp2=strTemp2+schemaName + ".oo_c" + cubeSeq + "f" + sHash.get("f" + f + "_seq") + "formula" + "(";
				String[] arrGetMes = new String[100];
				arrGetMes=getFormulaMeasure((String)sHash.get("f" + f + "_formula_text"));
				String strTemp4="";
				for(i=0;i<arrGetMes.length;i++){
					if(arrGetMes[i]==null){break;}
					for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
						if(arrGetMes[i].equals((String)sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name"))){
							if(!"".equals(strTemp4)){
								strTemp4=strTemp4+",";
							}
							strTemp4=strTemp4+"coalesce(ret." + (String)sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ",0)";
						}
					}
				}
				strTemp2=strTemp2+strTemp4;
				strTemp2=strTemp2+")";
				strTemp2=strTemp2+" ||";
				strTemp2=strTemp2+"\n";
			}else if("2".equals((String)sHash.get("f" + f + "_data_flg"))){
				strTemp2=strTemp2+"'',''";
				strTemp2=strTemp2+" || coalesce(ret." + sHash.get("f" + f + "_name") + ",0) ||";
				strTemp2=strTemp2+"\n";
			}

		}

		strTemp3="";
		strTemp3=strTemp3+"''}'';";
		strTemp3=strTemp3+"\n";
		strTemp3=strTemp3+"\n";
		strTemp3=strTemp3+"return retMeasure;";
		strTemp3=strTemp3+"\n";
		strTemp3=strTemp3+"END;";
		strTemp3=strTemp3+"\n";
		strTemp3=strTemp3+"'LANGUAGE 'plpgsql'";
		strTemp3=strTemp3+"\n";

		strFunction = strTemp+strTemp3;
		strCMFunction = strTemp+strTemp2+strTemp3;




		//ビュー作成
		strTemp = "";
		strTemp=strTemp+"CREATE VIEW " + schemaName + ".v_" + strCubeName + " AS";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"SELECT";
		strTemp=strTemp+"\n";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
			if(d!=1){
				strTemp=strTemp+",";
			}
			strTemp=strTemp+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".key AS dim_" + addZero(d);
			strTemp=strTemp+"\n";
		}
		strTemp=strTemp+",f_" + strCubeName + "(";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
			if(d!=1){
				strTemp=strTemp+",";
			}
			strTemp=strTemp+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".key";
		}
		strTemp=strTemp+") AS measure";
		strTemp=strTemp+"\n";
		strTemp=strTemp+"FROM";
		strTemp=strTemp+"\n";
		for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
			String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
			if(d!=1){
				strTemp=strTemp+",";
			}
			strTemp=strTemp+schemaName + "." + "oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
			strTemp=strTemp+"\n";
		}
		strView=strTemp;















		if(processNum.indexOf("0")!=-1||processNum.indexOf("9")!=-1){
			strTemp = "";
			strTemp=strTemp+"--OpenOLAP Ignore Error--";
			strTemp=strTemp+"\n";
			strTemp=strTemp+"DROP TABLE " + schemaName + "." + strCubeName;
			strTemp=strTemp+"\n";
			arrSql[sqlNo]=strTemp;//SQL登録
			arrMsg[sqlNo]="キューブ削除　　" + strCubeName;
		//	arrIgnore[sqlNo]="1";
			sqlNo++;

			strTemp = "";
			strTemp=strTemp+"--OpenOLAP Ignore Error--";
			strTemp=strTemp+"\n";
			strTemp=strTemp+"DROP TABLE " + schemaName + "." + strCubeName + "_temp";
			strTemp=strTemp+"\n";
			arrSql[sqlNo]=strTemp;//SQL登録
			arrMsg[sqlNo]="一時キューブ削除　　" + strCubeName + "_temp";
		//	arrIgnore[sqlNo]="1";
			sqlNo++;

			strTemp = "";
			strTemp=strTemp+"--OpenOLAP Ignore Error--";
			strTemp=strTemp+"\n";
			strTemp=strTemp+"DROP VIEW " + schemaName + ".v_" + strCubeName;
			strTemp=strTemp+"\n";
			arrSql[sqlNo]=strTemp;//SQL登録
			arrMsg[sqlNo]="ビュー削除　　" + "v_" + strCubeName;
		//	arrIgnore[sqlNo]="1";
			sqlNo++;

			strTemp = "";
			strTemp=strTemp+"--OpenOLAP Ignore Error--";
			strTemp=strTemp+"\n";
			strTemp=strTemp+"DROP FUNCTION " + schemaName + ".f_" + strCubeName + "(";
			for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
				if(d!=1){
					strTemp=strTemp+",";
				}
				strTemp=strTemp+"integer";
			}
			strTemp=strTemp+")";
			strTemp=strTemp+"\n";
			arrSql[sqlNo]=strTemp;//SQL登録
			arrMsg[sqlNo]="ファンクション削除　　" + "f_" + strCubeName;
		//	arrIgnore[sqlNo]="1";
			sqlNo++;


		}


		if(processNum.indexOf("0")!=-1||processNum.indexOf("1")!=-1){

			custmizeFlg=0;
			Sql="SELECT script";
			Sql=Sql+" FROM oo_custom_sql";
			Sql=Sql+" WHERE cube_seq='" + cubeSeq + "'";
			Sql=Sql+" AND step='1'";
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {
				custmizeFlg=1;
				custmizeSql=rs.getString("script")+"\r\n\r\n";
			}
			rs.close();
			if((custmizeFlg==1)&&(originalFlg==0)){//実行時のカスタマイズSQL取得
				StringTokenizer str = new StringTokenizer(ood.replace(custmizeSql,"\r\n;\r\n","&"),"&");
				i=0;
				int tokenCount=str.countTokens();
				while(str.hasMoreTokens()) {
					i++;
					String tempSql = str.nextToken();
					if(i!=tokenCount){//最後のトークンはSQLとしない
						arrSql[sqlNo]=tempSql;//SQL登録
						arrMsg[sqlNo]="カスタマイズSQL（キューブ定義）";
					//	arrIgnore[sqlNo]="0";
						sqlNo++;
					}
				}
			}else{
				strTemp = "";
				strTemp=strTemp+"CREATE TABLE " + schemaName + "." + strCubeName + "(";
				strTemp=strTemp+"\n";
				for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
					if(d!=1){
						strTemp=strTemp+",";
					}
					strTemp=strTemp+"dim_" + addZero(d) + " integer";
					strTemp=strTemp+"\n";
				}
				strTemp=strTemp+")";
				strTemp=strTemp+"\n";
				arrSql[sqlNo]=strTemp;//SQL登録
				arrMsg[sqlNo]="キューブ作成　　" + strCubeName;
			//	arrIgnore[sqlNo]="0";
				sqlNo++;



				for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
					strTemp = "";
					strTemp=strTemp+"ALTER TABLE " + schemaName + "." + strCubeName + " ADD COLUMN";
					strTemp=strTemp+"\n";
					strTemp=strTemp+"" + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + " numeric";
					strTemp=strTemp+"\n";
					arrSql[sqlNo]=strTemp;//SQL登録
					arrMsg[sqlNo]="メジャー作成　　" + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name");
				//	arrIgnore[sqlNo]="0";
					sqlNo++;

				}



				arrSql[sqlNo]=strFunction;//SQL登録
				arrMsg[sqlNo]="ファンクションの作成　　" + "f_" + strCubeName;
			//	arrIgnore[sqlNo]="0";
				sqlNo++;


				arrSql[sqlNo]=strView;//SQL登録
				arrMsg[sqlNo]="ビューの作成　　" + "v_" + strCubeName;
			//	arrIgnore[sqlNo]="0";
				sqlNo++;


			}
		}





		if(processNum.indexOf("0")!=-1||processNum.indexOf("2")!=-1){

			custmizeFlg=0;
			Sql="SELECT script";
			Sql=Sql+" FROM oo_custom_sql";
			Sql=Sql+" WHERE cube_seq='" + cubeSeq + "'";
			Sql=Sql+" AND step='2'";
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {
				custmizeFlg=1;
				custmizeSql=rs.getString("script")+"\r\n\r\n";
			}
			rs.close();
			if((custmizeFlg==1)&&(originalFlg==0)){//実行時のカスタマイズSQL取得
				StringTokenizer str = new StringTokenizer(ood.replace(custmizeSql,"\r\n;\r\n","&"),"&");
				i=0;
				int tokenCount=str.countTokens();
				while(str.hasMoreTokens()) {
					i++;
					String tempSql = str.nextToken();
					if(i!=tokenCount){//最後のトークンはSQLとしない
						arrSql[sqlNo]=tempSql;//SQL登録
						arrMsg[sqlNo]="カスタマイズSQL（データロード）";
					//	arrIgnore[sqlNo]="0";
						sqlNo++;
					}
				}
			}else{







				for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
					String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
					String tempDimName=(String)sHash.get("d" + tempDimSeq + "_name");
					String tempDimParts=(String)sHash.get("d" + tempDimSeq + "_part_seq");





					if((d==1)&&(timeExsitFlg)){//時間次元メンバーの更新
						strTemp = "";
						strTemp=strTemp+"TRUNCATE TABLE oo_dim_" + timeSeq + "_" + timePartSeq;
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="時間ディメンションメンバーの更新(1)　　" + timeName;
					//	arrIgnore[sqlNo]="0";
						sqlNo++;

						strTemp = "";
						strTemp=strTemp+"--OpenOLAP Executing Procedure--";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"SELECT " + schemaName + ".oo_create_time_dim(" + timeSeq + ")";
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="時間ディメンションメンバーの更新(2)　　" + timeName;
					//	arrIgnore[sqlNo]="0";
						sqlNo++;
					//	if(!"".equals(dataloadTimeKind)){//バッチでデータロード対象期間を指定している場合
							strTemp = "";
							strTemp=strTemp+"--OpenOLAP Executing Procedure--";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"SELECT " + schemaName + ".oo_time_limit(" + timeSeq + ",'" + dataloadTimeKind.substring(0,1) + "'," + intPast + "," + intFuture + ")";
							strTemp=strTemp+"\n";
							arrSql[sqlNo]=strTemp;//SQL登録
							arrMsg[sqlNo]="データロード対象期間設定　　" + timeName;
						//	arrIgnore[sqlNo]="0";
							sqlNo++;
					//	}


					}else{//時間次元以外の次元メンバーの更新



						//セグメントディメンション用ファンクション作成//ディメンションメンバーの更新前に作成
						if("2".equals(sHash.get("d" + tempDimSeq + "_dim_type"))){
							strTemp = "";
							strTemp=strTemp+"CREATE OR REPLACE FUNCTION " + schemaName + ".oo_seg_func_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
							strTemp=strTemp+"(numeric,text) RETURNS integer AS '";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"DECLARE";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"vNum_val   ALIAS FOR $1;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"vText_val   ALIAS FOR $2;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"retKey     integer;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"BEGIN";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	if vNum_val is not null then";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"		select into retKey key from " + schemaName + ".oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + "";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"		where min_val <= vNum_val and vNum_val < max_val and org_level = 0;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	else";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"		select into retKey key from " + schemaName + ".oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + "";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"		where vText_val like replace(calc_text,''*'',''%'') and org_level = 0;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	end if;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	if retKey is null then";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"		retKey:=-1;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	end if;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"	return retKey;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"END;";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"'LANGUAGE 'plpgsql'";
							strTemp=strTemp+"\n";

							arrSql[sqlNo]=strTemp;//SQL登録
							arrMsg[sqlNo]="セグメントディメンション用ファンクション作成　　oo_seg_func_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
						//	arrIgnore[sqlNo]="0";
							sqlNo++;
						}



						strTemp = "";
						strTemp=strTemp+"--OpenOLAP Executing Procedure--";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"SELECT " + schemaName + ".oo_dim_member(" + tempDimSeq + ",'" + sHash.get("d" + tempDimSeq + "_schema_name") + "') as a";
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="ディメンションメンバーの更新(1)　　" + tempDimName;
					//	arrIgnore[sqlNo]="0";
						sqlNo++;

						strTemp = "";
						strTemp=strTemp+"--OpenOLAP Executing Procedure--";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"SELECT " + schemaName + ".oo_dim_parts(" + tempDimSeq + ",'" + tempDimParts + "') as a";
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="ディメンションメンバーの更新(2)　　" + tempDimName;
					//	arrIgnore[sqlNo]="0";
						sqlNo++;

						strTemp = "";
						strTemp=strTemp+"--OpenOLAP Executing Procedure--";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"SELECT " + schemaName + ".oo_dim_level_adjust(" + tempDimSeq + ",'" + tempDimParts + "') as a";
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="ディメンションメンバーの更新(3)　　" + tempDimName;
					//	arrIgnore[sqlNo]="0";
						sqlNo++;


					}



				}




				if(timeExsitFlg){
					strTemp = "";
					strTemp=strTemp+"DELETE FROM " + schemaName + "." + strCubeName;
					strTemp=strTemp+"\n";
					strTemp=strTemp+"WHERE dim_01 in (SELECT key FROM " + schemaName + ".oo_dim_" + timeSeq + "_" + timePartSeq + " WHERE min_val = '1')";
					strTemp=strTemp+"\n";
					arrSql[sqlNo]=strTemp;//SQL登録
					arrMsg[sqlNo]="キューブのデータロード対象期間データの削除　　" + strCubeName;
				//	arrIgnore[sqlNo]="0";
					sqlNo++;
				}else{
					strTemp = "";
					strTemp=strTemp+"TRUNCATE TABLE " + schemaName + "." + strCubeName;
					strTemp=strTemp+"\n";
					arrSql[sqlNo]=strTemp;//SQL登録
					arrMsg[sqlNo]="キューブデータの削除　　" + strCubeName;
				//	arrIgnore[sqlNo]="0";
					sqlNo++;
				}

				strTemp = "";
				strTemp=strTemp+"--OpenOLAP Ignore Error--";
				strTemp=strTemp+"\n";
				strTemp=strTemp+"DROP TABLE " + schemaName + "." + strCubeName + "_temp";
				strTemp=strTemp+"\n";
				arrSql[sqlNo]=strTemp;//SQL登録
				arrMsg[sqlNo]="一時キューブ削除　　" + strCubeName + "_temp";
			//	arrIgnore[sqlNo]="1";
				sqlNo++;






				//一時キューブ作成
				if(Integer.parseInt((String)sHash.get("mesKindCount"))!=1){

					strTemp = "";
					strTemp=strTemp+"CREATE TABLE " + schemaName + "." + strCubeName + "_temp(";
					strTemp=strTemp+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						if(d!=1){
							strTemp=strTemp+",";
						}
						strTemp=strTemp+"dim_" + addZero(d) + " integer";
						strTemp=strTemp+"\n";
					}

					for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
						strTemp=strTemp+"," + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + " numeric";
						strTemp=strTemp+"\n";
					}
					strTemp=strTemp+")";
					strTemp=strTemp+"\n";
					arrSql[sqlNo]=strTemp;//SQL登録
					arrMsg[sqlNo]="一時キューブ作成　　" + strCubeName + "_temp";
				//	arrIgnore[sqlNo]="0";
					sqlNo++;
				}



				//データロード

				for(mk=1;mk<=Integer.parseInt((String)sHash.get("mesKindCount"));mk++){
					String mes1Seq=(String)sHash.get("mk" + mk + "mks1_seq");

					strInsert = "";
					if(Integer.parseInt((String)sHash.get("mesKindCount"))!=1){
						strInsert=strInsert+"INSERT INTO " + schemaName + "." + strCubeName + "_temp(";
					}else{
						strInsert=strInsert+"INSERT INTO " + schemaName + "." + strCubeName + "(";
					}
					strInsert=strInsert+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						if(d!=1){
							strInsert=strInsert+",";
						}
						strInsert=strInsert+"dim_" + addZero(d);
						strInsert=strInsert+"\n";
					}
					int mNo=0;
					for(mks=1;mks<=Integer.parseInt((String)sHash.get("mk" + mk + "_mesCount"));mks++){
						String tempMesSeq1=(String)sHash.get("mk" + mk + "mks" + mks + "_seq");
						for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
							String tempMesSeq2=(String)sHash.get("Nm" + m + "_seq");
							if(tempMesSeq1.equals(tempMesSeq2)){
								strInsert=strInsert+"," + (String)sHash.get("m" + tempMesSeq2 + "_name");
								strInsert=strInsert+"\n";
							}
						}
					}
					strInsert=strInsert+")";


					strSelect = "";
					strSelect=strSelect+"\n";
					strSelect=strSelect+" SELECT";
					strSelect=strSelect+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						if(d!=1){
							strSelect=strSelect+",";
						}
						if((d==1)&&("1".equals(sHash.get("d" + tempDimSeq + "_time_dim_flg")))&&("0".equals(sHash.get("d" + tempDimSeq + "_day_flg")))){
							strSelect=strSelect+"temptime.key";
						}else{
							strSelect=strSelect+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".key";
						}
						strSelect=strSelect+"\n";
					}

					for(mks=1;mks<=Integer.parseInt((String)sHash.get("mk" + mk + "_mesCount"));mks++){
						String tempMesSeq1=(String)sHash.get("mk" + mk + "mks" + mks + "_seq");
						for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
							String tempMesSeq2=(String)sHash.get("Nm" + m + "_seq");
							if(tempMesSeq1.equals(tempMesSeq2)){
							//	if("first".equals((String)sHash.get("m" + tempMesSeq2 + "_fact_calc_method"))||"last".equals((String)sHash.get("m" + tempMesSeq2 + "_fact_calc_method"))){
							//		strSelect=strSelect+"," + ood.replace(ood.replace((String)sHash.get("m" + tempMesSeq2 + "_fact_calc_method_sql"),"%column%",sHash.get("m" + tempMesSeq2 + "_fact_table") + "." + sHash.get("m" + tempMesSeq2 + "_fact_col")),"%time%","oo_dim_" + (String)sHash.get("Nd1_seq") + "_" + sHash.get("d" + (String)sHash.get("Nd1_seq") + "_part_seq") + ".key");
							//		strSelect=strSelect+"\n";
							//	}else{
							//		strSelect=strSelect+"," + ood.replace((String)sHash.get("m" + tempMesSeq2 + "_fact_calc_method_sql"),"%column%",sHash.get("m" + tempMesSeq2 + "_fact_table") + "." + sHash.get("m" + tempMesSeq2 + "_fact_col"));
							//		strSelect=strSelect+"\n";
							//	}
								strSelect=strSelect+"," + ood.replace(ood.replace((String)sHash.get("m" + tempMesSeq2 + "_fact_calc_method_sql1"),"%column%",sHash.get("m" + tempMesSeq2 + "_fact_table") + "." + sHash.get("m" + tempMesSeq2 + "_fact_col")),"%time%","oo_dim_" + (String)sHash.get("Nd1_seq") + "_" + sHash.get("d" + (String)sHash.get("Nd1_seq") + "_part_seq") + ".key");
								strSelect=strSelect+"\n";

							}
						}
					}

					strFrom = "";
					strFrom=strFrom+"FROM";
					strFrom=strFrom+"\n";
					String strFactTable="";
					String strFactTimeCol="";
					String strFactTimeFormat="";
					String strFactWhereClause="";

					strFactTable=(String)sHash.get("m" + mes1Seq + "_fact_table");
					strFactTimeCol=(String)sHash.get("m" + mes1Seq + "_time_col");
					strFactTimeFormat=(String)sHash.get("m" + mes1Seq + "_time_name_sql");
					strFactWhereClause=(String)sHash.get("m" + mes1Seq + "_fact_where_clause");
					strFrom=strFrom + (String)sHash.get("m" + mes1Seq + "_schema_name") + "." + strFactTable;
				//	strFrom=strFrom + strFactTable;
					strFrom=strFrom+"\n";

					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						strFrom=strFrom+",";
						strFrom=strFrom+schemaName + "." + "oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
					//	strFrom=strFrom+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
						strFrom=strFrom+"\n";
						if((d==1)&&("1".equals(sHash.get("d" + tempDimSeq + "_time_dim_flg")))&&("0".equals(sHash.get("d" + tempDimSeq + "_day_flg")))){
							strFrom=strFrom+",";
							strFrom=strFrom+schemaName + "." + "oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + " AS temptime";
						//	strFrom=strFrom+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + " AS temptime";
							strFrom=strFrom+"\n";
						}
					}



					strWhere = "";
					strWhere=strWhere+"WHERE";
					strWhere=strWhere+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						if(d!=1){
							strWhere=strWhere+"AND ";
						}
						strWhere=strWhere+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".org_level = ";
						if(("2".equals(sHash.get("d" + tempDimSeq + "_dim_type")))&&(Integer.parseInt((String)sHash.get("d" + tempDimSeq + "_lvlCount"))==1)){//セグメントディメンションでファクトをセグメント分けする場合
							strWhere=strWhere+"0";
						}else{
							strWhere=strWhere+sHash.get("d" + tempDimSeq + "_lvlCount");
						}
						strWhere=strWhere+"\n";
					}

					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						if((d==1)&&("1".equals(sHash.get("d" + tempDimSeq + "_time_dim_flg")))){
							String tempColName = strFactTable + "." + strFactTimeCol;
							//ファクトカラムの型変換（時間軸とのマッピング）
							if(!"".equals(strFactTimeFormat)){
								tempColName=ood.replace(strFactTimeFormat,"%object%",tempColName);
							}
							strWhere=strWhere+"AND " + tempColName + " = ";
							strWhere=strWhere+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".time_date";
							strWhere=strWhere+"\n";
							if("0".equals(sHash.get("d" + tempDimSeq + "_day_flg"))){//DAYレベルチェックOFF時
								strWhere=strWhere+"AND oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".par_key = temptime.key";
								strWhere=strWhere+"\n";
							}
						}
					}

				//	if((timeExsitFlg)&&(!"".equals(dataloadTimeKind))){//バッチでデータロード対象期間を指定している場合
					if(timeExsitFlg){//バッチでデータロード対象期間を指定している場合
						strWhere=strWhere+"AND oo_dim_" + timeSeq + "_" + timePartSeq + ".min_val = '1'";
						strWhere=strWhere+"\n";
					}

					for(md=1;md<=Integer.parseInt((String)sHash.get("m" + mes1Seq + "_dimCount"));md++){
						String tempDimSeq=(String)sHash.get("m" + mes1Seq + "Nmd" + md + "_seq");
						if(("2".equals(sHash.get("d" + tempDimSeq + "_dim_type")))&&(Integer.parseInt((String)sHash.get("d" + tempDimSeq + "_lvlCount"))==1)){//セグメントディメンションでファクトをセグメント分けする場合

							strWhere=strWhere+"AND " + schemaName + ".oo_seg_func_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
							strWhere=strWhere+"(";
							if("1".equals(sHash.get("d" + tempDimSeq + "_seg_datatype"))){//int
								strWhere=strWhere+sHash.get("m" + mes1Seq + "_fact_table") + "." + sHash.get("m" + mes1Seq + "md" + tempDimSeq + "_fact_link_col1") + ",null";
							}else if("2".equals(sHash.get("d" + tempDimSeq + "_seg_datatype"))){//char
								strWhere=strWhere+"null," + sHash.get("m" + mes1Seq + "_fact_table") + "." + sHash.get("m" + mes1Seq + "md" + tempDimSeq + "_fact_link_col1");
							}
							strWhere=strWhere+")";
							strWhere=strWhere+" = ";
							strWhere=strWhere+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".key";
							strWhere=strWhere+"\n";

						}else{
							for(i=1;i<=5;i++){
								if(!"".equals(sHash.get("m" + mes1Seq + "md" + tempDimSeq + "_fact_link_col" + i))){
									strWhere=strWhere+"AND " + strFactTable + "." + sHash.get("m" + mes1Seq + "md" + tempDimSeq + "_fact_link_col" + i) + " = ";
									strWhere=strWhere+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".col_" + i;
									strWhere=strWhere+"\n";
								}
							}
						}

					}

					if(!"".equals(strFactWhereClause)){
						strWhere=strWhere+"AND " + strFactWhereClause;
						strWhere=strWhere+"\n";
					}


					strGroupBy = "";
					strGroupBy=strGroupBy+"GROUP BY";
					strGroupBy=strGroupBy+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						if(d!=1){
							strGroupBy=strGroupBy+",";
						}
						if((d==1)&&("1".equals(sHash.get("d" + tempDimSeq + "_time_dim_flg")))&&("0".equals(sHash.get("d" + tempDimSeq + "_day_flg")))){//レベル1はTOTALフラグが1の時のみ集計する
							strGroupBy=strGroupBy+"temptime.key";
						}else{
							strGroupBy=strGroupBy+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".key";
						}
						strGroupBy=strGroupBy+"\n";
					}

					arrSql[sqlNo]=strInsert+strSelect+strFrom+strWhere+strGroupBy;//SQL登録
					if(Integer.parseInt((String)sHash.get("mesKindCount"))!=1){
						arrMsg[sqlNo]="一時キューブへのデータロード　　" + strCubeName + "_temp";
					}else{
						arrMsg[sqlNo]="キューブへのデータロード　　" + strCubeName;
					}
				//	arrIgnore[sqlNo]="0";
					sqlNo++;

				}


				//tempからcubeへ
				if(Integer.parseInt((String)sHash.get("mesKindCount"))!=1){

					strInsert = "";
					strInsert=strInsert+"INSERT INTO " + schemaName + "." + strCubeName + "(";
					strInsert=strInsert+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						if(d!=1){
							strInsert=strInsert+",";
						}
						strInsert=strInsert+"dim_" + addZero(d);
						strInsert=strInsert+"\n";
					}

					for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
						strInsert=strInsert+"," + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name");
						strInsert=strInsert+"\n";
					}

					strInsert=strInsert+")";

					strSelect = "";
					strSelect=strSelect+"\n";
					strSelect=strSelect+" SELECT";
					strSelect=strSelect+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						if(d!=1){
							strSelect=strSelect+",";
						}
						strSelect=strSelect+"dim_" + addZero(d);
						strSelect=strSelect+"\n";
					}

					for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
						strSelect=strSelect+",SUM(" + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ")";
						strSelect=strSelect+"\n";
					}


					strFrom = "";
					strFrom=strFrom+"FROM";
					strFrom=strFrom+"\n";
					strFrom=strFrom+schemaName + "." + strCubeName + "_temp";
				//	strFrom=strFrom+strCubeName + "_temp";
					strFrom=strFrom+"\n";

					strWhere = "";

					strGroupBy = "";
					strGroupBy=strGroupBy+"GROUP BY";
					strGroupBy=strGroupBy+"\n";
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
						if(d!=1){
							strGroupBy=strGroupBy+",";
						}
						strGroupBy=strGroupBy+strCubeName + "_temp" + ".dim_" + addZero(d);
						strGroupBy=strGroupBy+"\n";
					}

					arrSql[sqlNo]=strInsert+strSelect+strFrom+strWhere+strGroupBy;//SQL登録
					arrMsg[sqlNo]="一時キューブからキューブへのデータロード　　" + strCubeName;
				//	arrIgnore[sqlNo]="0";
					sqlNo++;



				}

			}
		}



		if(processNum.indexOf("0")!=-1||processNum.indexOf("3")!=-1){
			strTemp = "";
			strTemp=strTemp+"--OpenOLAP Ignore Error--";
			strTemp=strTemp+"\n";
			strTemp=strTemp+"DROP INDEX " + schemaName + "." + strCubeName + "_pk";
			strTemp=strTemp+"\n";
			arrSql[sqlNo]=strTemp;//SQL登録
			arrMsg[sqlNo]="インデックス削除　　" + strCubeName + "_pk";
		//	arrIgnore[sqlNo]="1";
			sqlNo++;
		}



		if(processNum.indexOf("0")!=-1||processNum.indexOf("3")!=-1){

			custmizeFlg=0;
			Sql="SELECT script";
			Sql=Sql+" FROM oo_custom_sql";
			Sql=Sql+" WHERE cube_seq='" + cubeSeq + "'";
			Sql=Sql+" AND step='3'";
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {
				custmizeFlg=1;
				custmizeSql=rs.getString("script")+"\r\n\r\n";
			}
			rs.close();
			if((custmizeFlg==1)&&(originalFlg==0)){//実行時のカスタマイズSQL取得
				StringTokenizer str = new StringTokenizer(ood.replace(custmizeSql,"\r\n;\r\n","&"),"&");
				i=0;
				int tokenCount=str.countTokens();
				while(str.hasMoreTokens()) {
					i++;
					String tempSql = str.nextToken();
					if(i!=tokenCount){//最後のトークンはSQLとしない
						arrSql[sqlNo]=tempSql;//SQL登録
						arrMsg[sqlNo]="カスタマイズSQL（集計）";
					//	arrIgnore[sqlNo]="0";
						sqlNo++;
					}
				}
			}else{


				//アナライズ
				for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
					String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
					strTemp = "";
					strTemp=strTemp+"ANALYZE " + schemaName + ".";
					strTemp=strTemp+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
					strTemp=strTemp+"\n";
					arrSql[sqlNo]=strTemp;//SQL登録
					arrMsg[sqlNo]="アナライズ　　" + "oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq");
				//	arrIgnore[sqlNo]="0";
					sqlNo++;
				}

				strTemp = "";
				strTemp=strTemp+"ANALYZE " + schemaName + "." + strCubeName;
				strTemp=strTemp+"\n";
				arrSql[sqlNo]=strTemp;//SQL登録
				arrMsg[sqlNo]="アナライズ　　" + strCubeName;
			//	arrIgnore[sqlNo]="0";
				sqlNo++;



				//ROLL UP
				for(dimension=1;dimension<=Integer.parseInt((String)sHash.get("dimCount"));dimension++){
					String tempDimensionSeq=(String)sHash.get("Nd" + dimension + "_seq");

					int tempMaxLevel=0;
					int tempTopLevel=0;
					if((timeExsitFlg)&&(dimension==1)){
						tempMaxLevel=Integer.parseInt((String)sHash.get("d" + tempDimensionSeq + "_lvlCount"));
					//	tempTopLevel=0;
						if("1".equals((String)sHash.get("d" + tempDimensionSeq + "_total_flg"))){
							tempTopLevel=1;//時間ディメンション（合計値あり）はレベル１までを集計
						}else{
							tempTopLevel=2;//時間ディメンション（合計値なし）はレベル２までを集計
						}
					}else{
						tempMaxLevel=Integer.parseInt((String)sHash.get("d" + tempDimensionSeq + "_custLvlCount"));
					//	tempTopLevel=1;
						tempTopLevel=2;//通常ディメンションはレベル２までを集計
					}

					for(l=tempMaxLevel;l>=tempTopLevel;l--){

					//	if((l!=1)||"1".equals((String)sHash.get("d" + tempDimensionSeq + "_total_flg"))){

							strInsert = "";
							strInsert=strInsert+"INSERT INTO " + schemaName + "." + strCubeName + "(";
							strInsert=strInsert+"\n";
							for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
								if(d!=1){
									strInsert=strInsert+",";
								}
								strInsert=strInsert+"dim_" + addZero(d);
								strInsert=strInsert+"\n";
							}

							for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
								strInsert=strInsert+"," + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name");
								strInsert=strInsert+"\n";
							}

							strInsert=strInsert+")";

							strSelect = "";
							strSelect=strSelect+"\n";
							strSelect=strSelect+" SELECT";
							strSelect=strSelect+"\n";
							for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
								String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
								if(d!=1){
									strSelect=strSelect+",";
								}
								if(dimension==d){
									strSelect=strSelect+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".par_key";
								}else{
									strSelect=strSelect+strCubeName+".dim_" + addZero(d);
								}
								strSelect=strSelect+"\n";
							}

							for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
								String tempMesSeq=(String)sHash.get("Nm" + m + "_seq");

							//	if(("first".equals((String)sHash.get("m" + tempMesSeq + "_fact_calc_method"))||"last".equals((String)sHash.get("m" + tempMesSeq + "_fact_calc_method")))){
							//		if(dimension==1){
							//			strSelect=strSelect+"," + ood.replace(ood.replace((String)sHash.get("m" + tempMesSeq + "_fact_calc_method_sql"),"%column%",strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name")),"%time%","oo_dim_" + (String)sHash.get("Nd1_seq") + "_" + sHash.get("d" + (String)sHash.get("Nd1_seq") + "_part_seq") + ".key");
							//			strSelect=strSelect+"\n";
							//		}else{
							//			strSelect=strSelect+",SUM(" + strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ")";
							//			strSelect=strSelect+"\n";
							//		}
							//	}else if("count".equals((String)sHash.get("m" + tempMesSeq + "_fact_calc_method"))){
							//		//COUNTの集計はSUMで行うよう修正 2005/06/23 IAF Fukai
							//		strSelect=strSelect+",SUM(" + strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ")";
							//		strSelect=strSelect+"\n";
							//	}else{
							//		strSelect=strSelect+"," + ood.replace((String)sHash.get("m" + tempMesSeq + "_fact_calc_method_sql"),"%column%",strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name"));
							//		strSelect=strSelect+"\n";
							//	}

								if((dimension==1)&&(((String)sHash.get("m" + tempMesSeq + "_fact_calc_method_sql1")).indexOf("%time%")!=-1)){//first,lastなどの時間ディメンション
									strSelect=strSelect+"," + ood.replace(ood.replace((String)sHash.get("m" + tempMesSeq + "_fact_calc_method_sql1"),"%column%",strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name")),"%time%","oo_dim_" + (String)sHash.get("Nd1_seq") + "_" + sHash.get("d" + (String)sHash.get("Nd1_seq") + "_part_seq") + ".key");
									strSelect=strSelect+"\n";
								}else{
									strSelect=strSelect+"," + ood.replace((String)sHash.get("m" + tempMesSeq + "_fact_calc_method_sql2"),"%column%",strCubeName + "." + sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name"));
									strSelect=strSelect+"\n";
								}

							}


							strFrom = "";
							strFrom=strFrom+"FROM";
							strFrom=strFrom+"\n";
							strFrom=strFrom+schemaName + "." + strCubeName;
						//	strFrom=strFrom+strCubeName;
							strFrom=strFrom+"\n";
							strFrom=strFrom+"," + schemaName + "." + "oo_dim_" + tempDimensionSeq + "_" + sHash.get("d" + tempDimensionSeq + "_part_seq");
						//	strFrom=strFrom+"," + "oo_dim_" + tempDimensionSeq + "_" + sHash.get("d" + tempDimensionSeq + "_part_seq");
							strFrom=strFrom+"\n";

						//	if((timeExsitFlg)&&(!"".equals(dataloadTimeKind))&&(dimension!=1)){//バッチでデータロード対象期間を指定している場合
							if((timeExsitFlg)&&(dimension!=1)){//バッチでデータロード対象期間を指定している場合
								strFrom=strFrom+"," + schemaName + "." + "oo_dim_" + timeSeq + "_" + timePartSeq;
								strFrom=strFrom+"\n";
							}

							strWhere = "";
							strWhere=strWhere+"WHERE";
							strWhere=strWhere+"\n";
							strWhere=strWhere+strCubeName + ".dim_" + addZero(dimension) + " = ";
							strWhere=strWhere+"oo_dim_" + tempDimensionSeq + "_" + sHash.get("d" + tempDimensionSeq + "_part_seq") + ".key";
							strWhere=strWhere+"\n";
							strWhere=strWhere+"AND oo_dim_" + tempDimensionSeq + "_" + sHash.get("d" + tempDimensionSeq + "_part_seq") + ".cust_level = " + l;
							strWhere=strWhere+"\n";

						//	if((timeExsitFlg)&&(!"".equals(dataloadTimeKind))){//バッチでデータロード対象期間を指定している場合
							if(timeExsitFlg){//バッチでデータロード対象期間を指定している場合
								strWhere=strWhere+"AND " + strCubeName + ".dim_01 = ";
								strWhere=strWhere+"oo_dim_" + timeSeq + "_" + timePartSeq + ".key";
								strWhere=strWhere+"\n";
								strWhere=strWhere+"AND oo_dim_" + timeSeq + "_" + timePartSeq + ".max_val = '1'";
								strWhere=strWhere+"\n";
							}

							strGroupBy = "";
							strGroupBy=strGroupBy+"GROUP BY";
							strGroupBy=strGroupBy+"\n";
							for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
								String tempDimSeq=(String)sHash.get("Nd" + d + "_seq");
								if(d!=1){
									strGroupBy=strGroupBy+",";
								}
								if(dimension==d){
									strGroupBy=strGroupBy+"oo_dim_" + tempDimSeq + "_" + sHash.get("d" + tempDimSeq + "_part_seq") + ".par_key";
								}else{
									strGroupBy=strGroupBy+strCubeName+".dim_" + addZero(d);
								}
								strGroupBy=strGroupBy+"\n";
							}

							arrSql[sqlNo]=strInsert+strSelect+strFrom+strWhere+strGroupBy;//SQL登録
							arrMsg[sqlNo]="集計　　" + "" + sHash.get("d" + tempDimensionSeq + "_name") + " レベル" + l;
						//	arrIgnore[sqlNo]="0";
							sqlNo++;


					//	}
					}
				}


				//インデックス
				strTemp = "";
				strTemp=strTemp+"CREATE UNIQUE INDEX " + strCubeName + "_pk on " + schemaName + "." + strCubeName + "(";
				strTemp=strTemp+"\n";
				for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
					if(d!=1){
						strTemp=strTemp+",";
					}
					strTemp=strTemp+"dim_" + addZero(d);
					strTemp=strTemp+"\n";
				}
				strTemp=strTemp+")";
				strTemp=strTemp+"\n";
				arrSql[sqlNo]=strTemp;//SQL登録
				arrMsg[sqlNo]="インデックス作成　　" + strCubeName + "_pk";
			//	arrIgnore[sqlNo]="0";
				sqlNo++;


			}
		}









		if(processNum.indexOf("0")!=-1||processNum.indexOf("4")!=-1){

			custmizeFlg=0;
			Sql="SELECT script";
			Sql=Sql+" FROM oo_custom_sql";
			Sql=Sql+" WHERE cube_seq='" + cubeSeq + "'";
			Sql=Sql+" AND step='4'";
			rs = stmt.executeQuery(Sql);
			if (rs.next()) {
				custmizeFlg=1;
				custmizeSql=rs.getString("script")+"\r\n\r\n";
			}
			rs.close();
			if((custmizeFlg==1)&&(originalFlg==0)){//実行時のカスタマイズSQL取得
				StringTokenizer str = new StringTokenizer(ood.replace(custmizeSql,"\r\n;\r\n","&"),"&");
				i=0;
				int tokenCount=str.countTokens();
				while(str.hasMoreTokens()) {
					i++;
					String tempSql = str.nextToken();
					if(i!=tokenCount){//最後のトークンはSQLとしない
						arrSql[sqlNo]=tempSql;//SQL登録
						arrMsg[sqlNo]="カスタマイズSQL（カスタムメジャー）";
					//	arrIgnore[sqlNo]="0";
						sqlNo++;
					}
				}
			}else{

				for(f=1;f<=Integer.parseInt((String)sHash.get("formulaCount"));f++){
				//	if("1".equals((String)sHash.get("f" + f + "_data_flg"))){

						//Formula Function作成
						strTemp="CREATE OR REPLACE FUNCTION " + schemaName + ".oo_c" + cubeSeq + "f" + sHash.get("f" + f + "_seq") + "formula";
						strTemp=strTemp + "(";
						for(i=1;i<=checkMeasureCount((String)sHash.get("f" + f + "_formula_text"));i++){
							if(i!=1){
								strTemp=strTemp + ",";
							}
							strTemp=strTemp + "numeric";
						}
						strTemp=strTemp + ")";
						strTemp=strTemp + " RETURNS numeric AS '";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "DECLARE";
						strTemp=strTemp+"\n";
						for(i=1;i<=checkMeasureCount((String)sHash.get("f" + f + "_formula_text"));i++){
							strTemp=strTemp + "vArg" + i + " ALIAS FOR $" + i + ";";
							strTemp=strTemp+"\n";
						}
						strTemp=strTemp + "ret numeric;";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "BEGIN";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "ret := " + replaceFormulaText((String)sHash.get("f" + f + "_formula_text")) + ";";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "return ret;";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "END;";
						strTemp=strTemp+"\n";
						strTemp=strTemp + "'LANGUAGE 'plpgsql'";
						strTemp=strTemp+"\n";

						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="カスタムメジャーファンクション作成　　" + sHash.get("f" + f + "_name");
					//	arrIgnore[sqlNo]="0";
						sqlNo++;


				}


				int updateMesFormura=0;
				for(f=1;f<=Integer.parseInt((String)sHash.get("formulaCount"));f++){
					if("2".equals((String)sHash.get("f" + f + "_data_flg"))){
						updateMesFormura++;



						strTemp = "";
						strTemp=strTemp+"ALTER TABLE " + schemaName + "." + strCubeName + " ADD COLUMN";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"" + sHash.get("f" + f + "_name") + " numeric";
						strTemp=strTemp+"\n";
						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="カスタムメジャー作成　　" + sHash.get("f" + f + "_name");
					//	arrIgnore[sqlNo]="0";
						sqlNo++;


						strTemp="UPDATE " + schemaName + "." + strCubeName;
						strTemp=strTemp+"\n";
						int tempNo=0;

						strTemp=strTemp+"SET " + sHash.get("f" + f + "_name");
						strTemp=strTemp+" = ";

						strTemp=strTemp+"oo_c" + cubeSeq + "f" + sHash.get("f" + f + "_seq") + "formula" + "(";
						strTemp2="";
						String[] arrGetMes = new String[100];
						arrGetMes=getFormulaMeasure((String)sHash.get("f" + f + "_formula_text"));
						for(i=0;i<arrGetMes.length;i++){
							if(arrGetMes[i]==null){break;}
							for(m=1;m<=Integer.parseInt((String)sHash.get("mesCount"));m++){
								if(arrGetMes[i].equals((String)sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name"))){
									if(!"".equals(strTemp2)){
										strTemp2=strTemp2+",";
									}
								//	strTemp2=strTemp2+"coalesce(measure_" + addZero(m) + ",0)";
									strTemp2=strTemp2+"coalesce(" + (String)sHash.get("m" + (String)sHash.get("Nm" + m + "_seq") + "_name") + ",0)";
								}
							}
						}


						strTemp=strTemp+strTemp2;
						strTemp=strTemp+")";
						strTemp=strTemp+"\n";

						if(timeExsitFlg){
							strTemp=strTemp+"WHERE dim_01 in (SELECT key FROM " + schemaName + ".oo_dim_" + timeSeq + "_" + timePartSeq + " WHERE min_val = '1')";
							strTemp=strTemp+"\n";
						}

						arrSql[sqlNo]=strTemp;//SQL登録
						arrMsg[sqlNo]="カスタムメジャー データ作成　　" + sHash.get("f" + f + "_name");
					//	arrIgnore[sqlNo]="0";
						sqlNo++;

					}
				}


				if(Integer.parseInt((String)sHash.get("formulaCount"))!=0){


					arrSql[sqlNo]=ood.replace(strCMFunction,"CREATE FUNCTION","CREATE OR REPLACE FUNCTION");//SQL登録
					arrMsg[sqlNo]="ファンクションの作成　　" + "f_" + strCubeName;
				//	arrIgnore[sqlNo]="0";
					sqlNo++;


					arrSql[sqlNo]=ood.replace(strView,"CREATE VIEW","CREATE OR REPLACE VIEW");//SQL登録
					arrMsg[sqlNo]="ビューの作成　　" + "v_" + strCubeName;
				//	arrIgnore[sqlNo]="0";
					sqlNo++;


				}


			}
		}






		sHashArray.put("arrSql",arrSql);
		sHashArray.put("arrMsg",arrMsg);
	//	sHashArray.put("arrIgnore",arrIgnore);
	//	return sHash;











		//キューブ情報を登録
	//	if(processNum.indexOf("0")!=-1){
			sqlNo=0;

			strTemp="DELETE FROM " + schemaName + ".oo_info_cube WHERE cube_seq = " + cubeSeq;
			strTemp=strTemp+"\n";
			arrInfoSql[sqlNo]=strTemp;//SQL登録
			sqlNo++;

			strTemp="DELETE FROM " + schemaName + ".oo_info_mes WHERE cube_seq = " + cubeSeq;
			strTemp=strTemp+"\n";
			arrInfoSql[sqlNo]=strTemp;//SQL登録
			sqlNo++;

			strTemp="DELETE FROM " + schemaName + ".oo_info_dim WHERE cube_seq = " + cubeSeq;
			strTemp=strTemp+"\n";
			arrInfoSql[sqlNo]=strTemp;//SQL登録
			sqlNo++;


			if(!processNum.equals("9")){//キューブが論理的に存在する時（プロセスが「削除」のみ以外の場合）
				strTemp="INSERT INTO " + schemaName + ".oo_info_cube(";
				strTemp=strTemp+"\n";
				strTemp=strTemp+"cube_seq";
				strTemp=strTemp+"\n";
				strTemp=strTemp+",custmized_flg";
				strTemp=strTemp+"\n";
				strTemp=strTemp+",last_update";
				strTemp=strTemp+"\n";
				strTemp=strTemp+",record_count";
				strTemp=strTemp+"\n";
				strTemp=strTemp+")values(";
				strTemp=strTemp+"\n";
				strTemp=strTemp+cubeSeq;
				strTemp=strTemp+"\n";
				strTemp=strTemp+",'" + custmizedFlg + "'";
				strTemp=strTemp+"\n";
				strTemp=strTemp+",'NOW'";
				strTemp=strTemp+"\n";
				strTemp=strTemp+",(SELECT COUNT(*) FROM " + schemaName + "." + strCubeName + ")";
				strTemp=strTemp+"\n";
				strTemp=strTemp+")";
				arrInfoSql[sqlNo]=strTemp;//SQL登録
				sqlNo++;

				for(i=0;i<arrInfoMesSeq.length;i++){
					if(arrInfoMesSeq[i]!=null){
						if((processNum.indexOf("0")!=-1)||(processNum.indexOf("1")!=-1&&"1".equals(arrInfoMesType[i]))||(processNum.indexOf("2")!=-1&&"1".equals(arrInfoMesType[i]))||(processNum.indexOf("3")!=-1&&"1".equals(arrInfoMesType[i]))||(processNum.indexOf("4")!=-1)){

							strTemp="INSERT INTO " + schemaName + ".oo_info_mes(";
							strTemp=strTemp+"\n";
							strTemp=strTemp+"cube_seq";
							strTemp=strTemp+"\n";
							strTemp=strTemp+",measure_seq";
							strTemp=strTemp+"\n";
							strTemp=strTemp+",mes_type";
							strTemp=strTemp+"\n";
							strTemp=strTemp+")values(";
							strTemp=strTemp+"\n";
							strTemp=strTemp+cubeSeq;
							strTemp=strTemp+"\n";
							strTemp=strTemp+"," + arrInfoMesSeq[i];
							strTemp=strTemp+"\n";
							strTemp=strTemp+"," + arrInfoMesType[i];
							strTemp=strTemp+"\n";
							strTemp=strTemp+")";

							arrInfoSql[sqlNo]=strTemp;//SQL登録
							sqlNo++;
						}
					}
				}


				if((processNum.indexOf("0")!=-1)||(processNum.indexOf("1")!=-1)||(processNum.indexOf("2")!=-1)||(processNum.indexOf("3")!=-1)||(processNum.indexOf("4")!=-1)){
					for(d=1;d<=Integer.parseInt((String)sHash.get("dimCount"));d++){
						String tempDimensionSeq=(String)sHash.get("Nd" + d + "_seq");
						String tempPartSeq=(String)sHash.get("d" + tempDimensionSeq + "_part_seq");
						int tempMaxLevel=0;
						if((timeExsitFlg)&&(d==1)){
							tempMaxLevel=Integer.parseInt((String)sHash.get("d" + tempDimensionSeq + "_lvlCount"));
						}else{
							tempMaxLevel=Integer.parseInt((String)sHash.get("d" + tempDimensionSeq + "_custLvlCount"));
						}
						strTemp="INSERT INTO " + schemaName + ".oo_info_dim(";
						strTemp=strTemp+"\n";
						strTemp=strTemp+"cube_seq";
						strTemp=strTemp+"\n";
						strTemp=strTemp+",dimension_seq";
						strTemp=strTemp+"\n";
						strTemp=strTemp+",part_seq";
						strTemp=strTemp+"\n";
						strTemp=strTemp+",dim_no";
						strTemp=strTemp+"\n";
						strTemp=strTemp+",level_count";
						strTemp=strTemp+"\n";
						strTemp=strTemp+",time_dim_flg";
						strTemp=strTemp+"\n";
						strTemp=strTemp+")values(";
						strTemp=strTemp+"\n";
						strTemp=strTemp+cubeSeq;
						strTemp=strTemp+"\n";
						strTemp=strTemp+"," + tempDimensionSeq;
						strTemp=strTemp+"\n";
						strTemp=strTemp+"," + tempPartSeq;
						strTemp=strTemp+"\n";
						strTemp=strTemp+"," + d;
						strTemp=strTemp+"\n";
						strTemp=strTemp+"," + tempMaxLevel;
						strTemp=strTemp+"\n";
						strTemp=strTemp+",'" + sHash.get("d" + tempDimensionSeq + "_time_dim_flg") + "'";
						strTemp=strTemp+"\n";
						strTemp=strTemp+")";

						arrInfoSql[sqlNo]=strTemp;//SQL登録
						sqlNo++;
					}
				}

			}

	//	}

		sHashArray.put("arrInfoSql",arrInfoSql);
		return sHashArray;

	}








	/**
	*１桁の数字には「0」を埋め２桁にします。
	*@param intTarget 処理対象となる数字
	*@return strResult ２桁の文字列
	*/
	private static String addZero(int intTarget){
	    String strResult="";
		if(intTarget<10){
			strResult = "0" + intTarget;
		}else{
			strResult = Integer.toString(intTarget);
		}
	    return strResult;
	}




	/**
	*カスタムメジャー計算式の中にある別のカスタムメジャーを計算式に置き換えます。
	*@param strTarget カスタムメジャー計算式
	*@param arrCFname カスタムメジャー名配列
	*@param arrCFtext カスタムメジャー計算式配列
	*@return strTarget フラットになったカスタムメジャー計算式
	*/
	private static String flatFormulaText(String strTarget,String[] arrCFname,String[] arrCFtext){

		int intCount=0;
		while(strTarget.indexOf("[@")!=-1){
			intCount++;
			String strCFname=strTarget.substring(strTarget.indexOf("[@")+2,strTarget.indexOf("@]"));
			String tempCFText="";
			for(int i=0;i<arrCFname.length;i++){
				if(arrCFname[i]==null){break;}
				if(arrCFname[i].equals(strCFname)){
					tempCFText=arrCFtext[i];
				}
			}
			String tempString=strTarget.substring(strTarget.indexOf("[@"),strTarget.indexOf("@]")+2);
			strTarget=ood.replace(strTarget,tempString,"("+tempCFText+")");
			if(intCount==1000){//無限ループ防止
				return strTarget;
			}
	    }
	    return strTarget;
	}




	/**
	*計算式におけるメジャーの件数を返します。
	*@param strTarget カスタムメジャー計算式
	*@return intCount メジャーの件数
	*/
	private static int checkMeasureCount(String strTarget){
	    int intCount = 0;

	    String tempString;
		while(strTarget.indexOf("[%")!=-1){
			intCount++;
			tempString=strTarget.substring(strTarget.indexOf("[%"),strTarget.indexOf("%]")+2);
			strTarget=ood.replace(strTarget,tempString,"vArg" + intCount);
	    }
	    return intCount;
	}




	/**
	*計算式においてメジャーを「vArgn」文字列に置換します。
	*@param strTarget カスタムメジャー計算式
	*@return strTarget 置換されたカスタムメジャー計算式
	*/
	private static String replaceFormulaText(String strTarget){
	    int intCount = 0;
	    String tempString;
		while(strTarget.indexOf("[%")!=-1){
			intCount++;
			tempString=strTarget.substring(strTarget.indexOf("[%"),strTarget.indexOf("%]")+2);
			strTarget=ood.replace(strTarget,tempString,"vArg" + intCount);
	    }
	    return strTarget;
	}




	/**
	*計算式におけるメジャーを配列にして返します。
	*@param strTarget カスタムメジャー計算式
	*@return strTarget メジャー配列
	*/
	private static String[] getFormulaMeasure(String strTarget){
		String[] arrReMes = new String[100];
	    int intCount = 0;
	    String tempString;

		while(strTarget.indexOf("[%")!=-1){
			tempString=strTarget.substring(strTarget.indexOf("[%"),strTarget.indexOf("%]")+2);
			arrReMes[intCount]=strTarget.substring(strTarget.indexOf("[%")+2,strTarget.indexOf("%]"));
			strTarget=ood.replace(strTarget,tempString,"vArg" + intCount);
			intCount++;
	    }

	    return arrReMes;
	}




}




