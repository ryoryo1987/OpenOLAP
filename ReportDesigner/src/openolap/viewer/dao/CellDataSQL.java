/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：CellDataSQL.java
 *  説明：セルデータ取得時に使用するSQLをあらわすクラスです。
 *
 *  作成日: 2004/02/01
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.StringTokenizer;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Edge;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;

/**
 *  クラス：CellDataSQL<br>
 *  説明：セルデータ取得時に使用するSQLをあらわすクラスです。
 */
public class CellDataSQL {

	// ********** インスタンス変数 **********

	/** Reportオブジェクト */
	private Report report = null;

	/** 列エッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリスト */
	private ArrayList<String> colFactKeyColumnList = new ArrayList<String>();

	/** 行エッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリスト */
	private ArrayList<String> rowFactKeyColumnList = new ArrayList<String>();

	/** ページエッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリスト */
	private ArrayList<String> pageFactKeyColumnList = new ArrayList<String>();


	/** Factテーブル名 */
	private String factTableName = null;


	/** 
	 * 列に配置された軸のWHERE節をあらわすオブジェクト。
	 * その軸をあらわすFactテーブルのキーカラムをKeyとし、取得対象となるメンバーキーリストをValueに持つ。
	 */
	private LinkedHashMap<String, ArrayList<String>> colWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** 
	 * 行に配置された軸のWHERE節をあらわすオブジェクト。
	 * その軸をあらわすFactテーブルのキーカラムをKeyとし、取得対象となるメンバーキーリストをValueに持つ。
	 */
	private LinkedHashMap<String, ArrayList<String>> rowWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** 
	 * ページに配置された軸のWHERE節をあらわすオブジェクト。
	 * その軸をあらわすFactテーブルのキーカラムをKeyとし、取得対象となるメンバーキーリストをValueに持つ。
	 */
	private LinkedHashMap<String, ArrayList<String>> pageWhereClauseMap = new LinkedHashMap<String, ArrayList<String>>();

	/** メジャーがページエッジにあるときのデフォルトメンバーキー(UName) */
	private String measureDefaultMember = null;

	/** メジャーがページエッジにあるときのデフォルトメンバーのメジャーシーケンス */
	private String measureDefaultSeq = null;

	// ********** static メソッド **********

	/**
	 * CellDataSQLオブジェクトを生成する。
	 * @param report レポートオブジェクト
	 * @param conn Connecionオブジェクト
	 * @param items 各エッジの軸IDリスト
	 * @param selectKeys データ取得対象となる列・行ヘッダのKey属性リスト
	 *		  selectKeys[0]：列ヘッダのKey属性リスト文字列
	 *		  selectKeys[1]：行ヘッダのKey属性リスト文字列
	 * @param formatValue 値にメジャーメンバー毎に設定されたMeasureMemberTypeの書式を適用するならtrue、単位のみをそろえる書式を適用するならばfalse
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 * @return CellDataSQLオブジェクト
	 */
	public static CellDataSQL getSelectReportDataSQL(Report report, Connection conn, Object[] items, Object[] selectKeys, boolean formatValue, CommonSettings commonSettings) {

		CellDataSQL cellDataSQL = new CellDataSQL();

		int i;
		int j;
		int k;
		StringTokenizer st;

		// レポートオブジェクトをセット
		cellDataSQL.setReport(report);

		// ファクトテーブル名を設定
		cellDataSQL.setFactTableName(DAOFactory.getDAOFactory().getCubeDAO(null).getFactTableName(report.getCube().getCubeSeq()));

		
		String[] edgeAxisInfoList;		// あるエッジの軸情報を格納するオブジェクト
		String axisID;					// 軸ID
		String tmpItemValuePair[];		// テーブルIDとKEYを格納する配列
										// 添字0：テーブルID、添字1：KEY

		String measureMemberKey = "";	// 取得条件に設定するメジャーのKey
		String meaIndex = "";			// メジャーのIndex
		int selectedMeasureNum = 1;	// データ取得対象となるメジャーのメンバー数
	
		for ( i = 0; i < items.length; i++ ) {	// エッジの数だけ実行
			edgeAxisInfoList = (String[])items[i];
			for ( j = 0; j < edgeAxisInfoList.length; j++ ) {	//エッジに配置された軸数分実行
				if ( i == 2 ) {	
				// ページエッジの場合
				// tmpHieItemsの配列の各要素は、テーブルIDとKEYからなる。
				// 書式）<次元ID>:<KEY> 
				// 	例：次元の場合）     1:0
				// 	例：メジャーの場合） 16:<UNAME>(1～50)
					st = new StringTokenizer(edgeAxisInfoList[j],":");
					tmpItemValuePair = new String[st.countTokens()];
					k = 0;
					while ( st.hasMoreTokens() ) {
						tmpItemValuePair[k] = st.nextToken();
						k++;
					}
					axisID      		= tmpItemValuePair[0];	// 軸ID
					measureMemberKey 	= tmpItemValuePair[1];	// 軸メンバーKEY
					selectedMeasureNum 	= 1;
				} else {		// 行・列エッジの場合
					axisID = edgeAxisInfoList[j];
					selectedMeasureNum = report.getTotalMeasureMemberNumber();	// キューブの持つ全メジャー数
				}
	
				if ( Constants.MeasureID.equals(axisID) ) {	// メジャー
					String measureLists = "";	// メジャーリスト
					for ( k = 0; k < selectedMeasureNum; k++ ) {
						if ( i == 2 ) {
							meaIndex = measureMemberKey.substring(measureMemberKey.indexOf("_") + 1, measureMemberKey.length());
	
							if ( (meaIndex.length() == 2) && (meaIndex.substring(0,1).equals("0") ) ) {
								meaIndex = meaIndex.substring(1,2);
							}
	
							// (ページに配置された場合)メジャーのデフォルトメンバー(key)を登録
							cellDataSQL.setMeasureDefaultMember(meaIndex);

							// (ページに配置された場合)メジャーのデフォルトメンバー(measureSeq)を登録
							cellDataSQL.setMeasureDefaultSeq(( (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(meaIndex)).getMeasureSeq());
	
						} else {
							meaIndex = Integer.toString(k+1);
						}
						MeasureMember measureMember = (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(meaIndex);
						if ( measureMember.isSelected() ) {	// セレクタではずされていないならば
							if ( measureLists != "" ) {
								measureLists += ",";
							}

							String measureString = null;
							if (formatValue) { // 値をフォーマット付で取得
								measureString = StringUtil.regReplaceAll("%measure%", "MEASURE[" + meaIndex + "]", measureMember.getMeasureMemberType().getFunction_name());
							} else { // 値を単位フォーマットのみで取得
								String unitFunctionID = measureMember.getMeasureMemberType().getUnitFunctionID();
								measureString = StringUtil.regReplaceAll("%measure%", "MEASURE[" + meaIndex + "]", commonSettings.getMeasureMemberTypeByID(unitFunctionID).getFunction_name());
							}
							measureLists += measureString + " as measure_" + meaIndex;

						}
					}

					// SELECT句
					cellDataSQL.addFactKeyColumnList(i, measureLists);

				} else {	// ディメンション

					String factKeyColumn = "";

					// セレクト句
					if ( Integer.valueOf(axisID).intValue() < 10 ) {
						factKeyColumn = "DIM_0" + axisID;
					} else {

						factKeyColumn = "DIM_"  + axisID;
					}
					cellDataSQL.addFactKeyColumnList(i, factKeyColumn);
	
					// WHERE句
					if ( i == 2 ) {// ページエッジ
						ArrayList<String> tmpList = new ArrayList<String>();
						tmpList.add(measureMemberKey);
						cellDataSQL.putWhereClauseMap(i, factKeyColumn, tmpList);

					} else {		// 行、列エッジ
						String[] selectEdgeKeys = (String[])selectKeys[i];		// 選択された軸メンバーリストの集合(エッジ単位)
						String   selectAxisKeys = selectEdgeKeys[j];			// 選択された軸メンバーリスト
						cellDataSQL.putWhereClauseMap(i, factKeyColumn, StringUtil.splitString(selectAxisKeys,","));

					}
				}
			}
		}
		
		return cellDataSQL;
	}

	// ********** メソッド **********

	/**
	 * セルデータを取得するSQL文字列を求める。
	 * @return SQL文字列
	 */
	public String getSQLString() {

		// SELECT句を出力（ディメンション＋メジャー）
		// メジャーの絞込みはここで反映
		String SQL = this.getSelectClause();

		SQL += " FROM ";
		SQL += getFactTableName();

		// WHERE句を出力（ディメンションのみ）
		SQL += " WHERE ";

		SQL += this.getWhereClause(this.getColWhereClauseMap());
		if (colWhereClauseMap.size()>0) { // COLにディメンションが配置されている
			if (rowWhereClauseMap.size()>0) {	// ROWにディメンションが配置されている
				SQL += " and ";
			}
		}
		SQL += this.getWhereClause(this.getRowWhereClauseMap());

		if (pageWhereClauseMap.size()>0) {	// ページに軸が配置されていない場合を除く
				SQL += " and ";
			SQL += this.getWhereClause(this.getPageWhereClauseMap());
		}
		
		return SQL;
	}




	/**
	 * ソート済みのセルデータを取得するSQL文字列を求める。
	 * @return SQL文字列
	 */
	public String getSQLStringForSortData() {
		
		// SELECT句を出力
		String SQL = this.getSelectClause();

		SQL += " FROM (";
		SQL += "   SELECT * FROM ";
		SQL += getFactTableName();		
		
		// FROM句の副問い合わせのWHERE句を生成
		SQL += " WHERE " + this.getWhereClause(this.getColWhereClauseMap());
		if (colWhereClauseMap.size()>0) { // COLにディメンションが配置されている
			if (rowWhereClauseMap.size()>0) {	// ROWにディメンションが配置されている
				SQL += " and ";
			}
		}
		SQL += this.getWhereClause(this.getRowWhereClauseMap());

		if (pageWhereClauseMap.size()>0) {	// ページに軸が配置されていない場合を除く
				SQL += " and ";
			SQL += this.getWhereClause(this.getPageWhereClauseMap());
		}
		
		// FROM句の副問い合わせを閉じる部分を生成
		SQL += " ) as fact ";

		Iterator<Edge> edgeIt = report.getEdgeList().iterator();

		while (edgeIt.hasNext()) {
			Edge edge = edgeIt.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();

				if (axis instanceof Dimension) {
					Dimension dimension = (Dimension) axis;

					SQL += ",(SELECT * FROM oo_dim_tree('";
					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + "'";
					SQL +=     ",null,',";

					String factColumnName = "DIM_";
					if (dimension.getId().length() < 2){
						factColumnName += "0";
					}
					factColumnName += dimension.getId();

					LinkedHashMap<String, ArrayList<String>> map = this.getAxisWhereClauseMap(edge.getPosition());
					ArrayList<String> memberKeyList = map.get(factColumnName);
					SQL += StringUtil.joinList(memberKeyList, ",");

					SQL +=     ",')) as oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq();

				}
			}
		}

		// WHERE句（ファクトとディメンションのJoinを定義）を生成
		// Orderby句を生成
		SQL += " where ";
		edgeIt = report.getEdgeList().iterator();
		int i = 0;
		while (edgeIt.hasNext()) {
			Edge edge = edgeIt.next();
			Iterator<Axis> axisIt = edge.getAxisList().iterator();
			while (axisIt.hasNext()) {
				Axis axis = axisIt.next();
				if (axis instanceof Dimension) {
					Dimension dimension = (Dimension) axis;
					if (i!=0) {
						SQL += " and ";
					}

					String factColumnName = "DIM_";
					if (dimension.getId().length() < 2){
						factColumnName += "0";
					}
					factColumnName += dimension.getId();
					SQL +=     "fact." + factColumnName + "=";
					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".key";
					i++;
				}
			}
		}

		// Orderby句を生成(列、行、ページの順)
		SQL += " order by ";

		// Row
		Edge edge = report.getEdgeByType(Constants.Row);
		Iterator<Axis> it = edge.getAxisList().iterator();
		i = 0;
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}

		// Col
		edge = report.getEdgeByType(Constants.Col);
		it = edge.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}		
		
		
		// Page
		edge = report.getEdgeByType(Constants.Page);
		it = edge.getAxisList().iterator();
		while (it.hasNext()) {
			Axis axis = it.next();
			if (axis instanceof Dimension) {
				Dimension dimension = (Dimension) axis;
				if (i!=0) {
					SQL += ",";
				}
				SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
				i++;
			}
		}		



//		edgeIt = report.getEdgeList().iterator();
//		i = 0;
//		while (edgeIt.hasNext()) {
//			Edge edge = (Edge) edgeIt.next();
//			Iterator axisIt = edge.getAxisList().iterator();
//			while (axisIt.hasNext()) {
//				Axis axis = (Axis) axisIt.next();
//				if (axis instanceof Dimension) {
//					Dimension dimension = (Dimension) axis;
//					if (i!=0) {
//						SQL += ",";
//					}
//					SQL +=     "oo_dim_" + dimension.getDimensionSeq() + "_" + dimension.getPartSeq() + ".rownum";
//					i++;
//				}
//			}
//		}


		return SQL;
	}



	// ファクトテーブルからディメンションテーブルへマッピングするカラム名称のリスト(カンマ区切りの文字列)をエッジごとに取得する
	// なお、メジャー情報は除外する
	// return)
	//   string[0]:列エッジのカラムリスト(String,カンマ区切り)
	//   string[1]:列エッジのカラムリスト(String,カンマ区切り)
	//   string[2]:ページエッジのカラムリスト(String,カンマ区切り)

	public String[] getDimsFactKeyColumnList() {
		String axesFactKeyColumnList[] = new String[3];
		axesFactKeyColumnList[0] = StringUtil.joinList(StringUtil.exceptElement(colFactKeyColumnList, "MEASURE"), ",");
		axesFactKeyColumnList[1] = StringUtil.joinList(StringUtil.exceptElement(rowFactKeyColumnList, "MEASURE"), ",");
		axesFactKeyColumnList[2] = StringUtil.joinList(StringUtil.exceptElement(pageFactKeyColumnList, "MEASURE"), ",");
		
		return axesFactKeyColumnList;
	}



	// ********** privateメソッド **********

	/**
	 * セルデータを求めるSQLのWHERE節を求める。
	 * @param edgeWhereClauseMap
	 * @return WHERE節
	 */
	private String getWhereClause(LinkedHashMap<String, ArrayList<String>> edgeWhereClauseMap) {
		
		String edgeWhereClause = "";
		
		Iterator<String> iter = edgeWhereClauseMap.keySet().iterator();
		int i = 0;
		while (iter.hasNext()) {
			if(i>0) {
				edgeWhereClause += " and ";
			}
			String factKeyColumn = iter.next();
			edgeWhereClause += factKeyColumn + " in (";

			ArrayList<String> memberKeyList = (ArrayList<String>) edgeWhereClauseMap.get(factKeyColumn);
			edgeWhereClause += StringUtil.joinList(memberKeyList, ",");
			edgeWhereClause += ")";

			i++;
		}
		
		return edgeWhereClause;
	}

	/**
	 * セルデータを求めるSQLのSELECT節を求める。
	 * @return SELECT節
	 */
	private String getSelectClause() {

		String SQL = "SELECT ";		
		SQL += StringUtil.joinList(this.getColFactKeyColumnList(), ",");
		SQL += "," + StringUtil.joinList(this.getRowFactKeyColumnList(), ",");
		if (pageFactKeyColumnList.size()>0) {
			SQL += "," + StringUtil.joinList(this.getPageFactKeyColumnList(), ",");
		}
		
		return SQL;
	}

	// ********** Setter メソッド **********


	/**
	 * レポートオブジェクトを追加する
	 * @param report Reportオブジェクト
	 */
	public void setReport(Report report) {
		this.report = report;
	}


	/**
	 * ファクトのキーカラムリストを追加する
	 * @param edgePositionID エッジID(0:列、1:行、2:ページ)
	 * @param factKeyColumn
	 */
	public void addFactKeyColumnList(int edgePositionID, String factKeyColumn) {
		if (edgePositionID==0) {
			this.colFactKeyColumnList.add(factKeyColumn);
		} else if (edgePositionID==1){
			this.rowFactKeyColumnList.add(factKeyColumn);
		} else if (edgePositionID==2){
			this.pageFactKeyColumnList.add(factKeyColumn);
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * 行エッジへファクトのキーカラムを追加する。
	 * @param factKeyColumn キーカラム
	 */
	public void addColFactKeyColumnList(String factKeyColumn) {
		this.colFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * 列エッジへファクトのキーカラムを追加する。
	 * @param factKeyColumn キーカラム
	 */
	public void addRowFactKeyColumnList(String factKeyColumn) {
		this.rowFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * ページエッジへファクトのキーカラムを追加する。
	 * @param factKeyColumn キーカラム
	 */
	public void addPageFactKeyColumnList(String factKeyColumn) {
		this.pageFactKeyColumnList.add(factKeyColumn);
	}

	/**
	 * ファクトテーブル名を設定する。
	 * @param string ファクトテーブル名
	 */
	public void setFactTableName(String string) {
		this.factTableName = string;
	}

	/**
	 * ファクトテーブル名を設定する。
	 * @param edgePositionID エッジID(0:列、1:行、2:ページ)
	 * @param factKeyColumn キーカラム
	 * @param memberKeyList メンバーキーリスト
	 */
	public void putWhereClauseMap(int edgePositionID, String factKeyColumn, ArrayList<String> memberKeyList) {
		if (edgePositionID == 0){
			this.colWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else if (edgePositionID == 1) {
			this.rowWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else if (edgePositionID == 2) {
			this.pageWhereClauseMap.put(factKeyColumn, memberKeyList);
		} else {
			throw new IllegalArgumentException();
		}
	}

	/**
	 * 列のWHERE節をあらわすMapオブジェクトを追加する。
	 * @param factKeyColumn キーカラム
	 * @param memberKeyList メンバーキーリスト
	 */
	public void putColWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.colWhereClauseMap.put(factKeyColumn, memberKeyList);
	}


	/**
	 * 行のWHERE節をあらわすMapオブジェクトを追加する。
	 * @param factKeyColumn キーカラム
	 * @param memberKeyList メンバーキーリスト
	 */
	public void putRowWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.rowWhereClauseMap.put(factKeyColumn, memberKeyList);
	}

	/**
	 * ページのWHERE節をあらわすMapオブジェクトを追加する。
	 * @param factKeyColumn キーカラム
	 * @param memberKeyList メンバーキーリスト
	 */
	public void putPageWhereClauseMap(String factKeyColumn, ArrayList<String> memberKeyList) {
		this.pageWhereClauseMap.put(factKeyColumn, memberKeyList);
	}

	/**
	 * ページのWHERE節をあらわすMapオブジェクトを追加する。
	 * @param string メジャーのデフォルトメンバーKEY
	 */
	public void setMeasureDefaultMember(String string) {
		measureDefaultMember = string;
	}

	/**
	 * メジャーのデフォルトメンバーのメジャーシーケンスを追加する。
	 * @param meaDefaultSeq メジャーのデフォルトメンバーのメジャーシーケンス
	 */
	public void setMeasureDefaultSeq(String meaDefaultSeq) {
		this.measureDefaultSeq = meaDefaultSeq;
	}

	// ********** Getter メソッド **********

	/**
	 * レポートオブジェクトを求める。
	 * @return レポートオブジェクト
	 */
	public Report getReport() {
		return report;
	}

	/**
	 * 指定されたエッジに配置された軸のWHERE節をあらわすオブジェクトを求める。
	 * @return 指定されたエッジに配置された軸のWHERE節をあらわすオブジェクト
	 */
	public LinkedHashMap<String, ArrayList<String>> getAxisWhereClauseMap(String edgePosition) {
		if (edgePosition == null){
			return null;
		}

		if (Constants.Col.equals(edgePosition)) {
			return colWhereClauseMap;
		} else if (Constants.Row.equals(edgePosition)) {
			return rowWhereClauseMap;
		} else if (Constants.Page.equals(edgePosition)) {
			return pageWhereClauseMap;
		} else {
			return null;
		}
		
	}
	


	/**
	 * 列エッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリストを求める。
	 * @return キーカラムリスト
	 */
	public ArrayList<String> getColFactKeyColumnList() {
		return colFactKeyColumnList;
	}

	/**
	 * 列に配置された軸のWHERE節をあらわすオブジェクトを求める。
	 * @return 列に配置された軸のWHERE節をあらわすオブジェクト
	 */
	public LinkedHashMap<String, ArrayList<String>> getColWhereClauseMap() {
		return colWhereClauseMap;
	}

	/**
	 * ファクトテーブル名を求める。
	 * @return ファクトテーブル名
	 */
	public String getFactTableName() {
		return factTableName;
	}

	/**
	 * ページエッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリストを求める。
	 * @return キーカラムリスト
	 */
	public ArrayList<String> getPageFactKeyColumnList() {
		return pageFactKeyColumnList;
	}

	/**
	 * ページに配置された軸のWHERE節をあらわすオブジェクトを求める。
	 * @return ページに配置された軸のWHERE節をあらわすオブジェクト
	 */
	public LinkedHashMap<String, ArrayList<String>> getPageWhereClauseMap() {
		return pageWhereClauseMap;
	}

	/**
	 * 行エッジに配置された軸に対応するFactテーブルのカラム、取得対象メジャーリストを求める。
	 * @return キーカラムリスト
	 */
	public ArrayList<String> getRowFactKeyColumnList() {
		return rowFactKeyColumnList;
	}

	/**
	 * 行に配置された軸のWHERE節をあらわすオブジェクトを求める。
	 * @return ページに配置された軸のWHERE節をあらわすオブジェクト
	 */
	public LinkedHashMap<String, ArrayList<String>> getRowWhereClauseMap() {
		return rowWhereClauseMap;
	}

	/**
	 * メジャーがページエッジにあるときのデフォルトメンバーキー(UName)を求める。
	 * @return デフォルトメンバーキー
	 */
	public String getMeasureDefaultMember() {
		return measureDefaultMember;
	}

	/**
	 * メジャーがページエッジにあるときのデフォルトメンバーのメジャーシーケンス(measureSeq)を求める。
	 * @return デフォルトメンバーのメジャーシーケンス
	 */
	public String getMeasureDefaultMeasureSeq() {
		return measureDefaultSeq;
	}


}
