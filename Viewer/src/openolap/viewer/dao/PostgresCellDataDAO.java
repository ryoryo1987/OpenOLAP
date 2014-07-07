/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresCellDataDAO.java
 *  説明：セルデータオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;
import openolap.viewer.MeasureMember;
import openolap.viewer.Report;
import openolap.viewer.common.Constants;


/**
 *  クラス：PostgresCellDataDAO<br>
 *  説明：セルデータオブジェクトの永続化を管理するクラスです。
 */
public class PostgresCellDataDAO implements CellDataDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	private Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresCellDataDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * セルデータオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresCellDataDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * セルデータオブジェクトのリストを求める。
	 * @param cellDataSQL セルデータ取得用SQLをあらわすオブジェクト
	 * @param items 列、行、ページエッジ毎の軸IDリスト
	 *        items[0]：列エッジに配置された軸IDの配列
	 *        items[1]：列エッジに配置された軸IDの配列
	 *        items[2]：ページエッジに配置された軸IDとそのデフォルトメンバーキーの配列
	 * @param request HttpServletRequestオブジェクト
	 * @param report レポートオブジェクト
	 * @param colCoordinatesList 列座標
	 * @param rowCoordinatesList 行座標
	 * @return セルデータオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<CellData> selectCellDatas(CellDataSQL cellDataSQL, Object[] items, HttpServletRequest request, Report report, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String SQLType) throws SQLException {

		String[] FKColLists = cellDataSQL.getDimsFactKeyColumnList();
		// FKColLists：エッジに配置されたディメンションへのファクトテーブルのカラムリスト（書式：DIM_03,DIM_02）
		//			   上段から順に並ぶ。（ただし、メジャーの場合は飛ばす）
		// 	FKColLists[0]:列
		// 	FKColLists[1]:行

		ArrayList<CellData> cellDataList = new ArrayList<CellData>();	// 検索により取得したセルデータオブジェクト格納用

		// データ検索
		Statement stmt = null;
		ResultSet rs   = null;
		try {
			stmt = conn.createStatement();
			
			String SQL = "";
			if (CellDataDAO.normalSQLTypeString.equals(SQLType)) {
				SQL = cellDataSQL.getSQLString();
			} else if (CellDataDAO.sortedSQLTypeString.equals(SQLType)) {
				SQL = cellDataSQL.getSQLStringForSortData();
			} else {
				throw new IllegalArgumentException();
			}

			if(log.isInfoEnabled()) {
				log.info("SQL(select cell data)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			int i;
			StringTokenizer st = null;
			while ( rs.next() ) {

				LinkedHashMap<Integer, String> colIdKeyMap = new LinkedHashMap<Integer, String>();	// 列のIDとそのメンバキー(ResultSetの各レコードから取得)
				LinkedHashMap<Integer, String> rowIdKeyMap = new LinkedHashMap<Integer, String>();	// 行のIDとそのメンバキー(ResultSetの各レコードから取得)


				// データレコードより行・列に配置された次元のKEYを取得
				for ( i = 0; i < 2; i++ ) {
					st = new StringTokenizer(FKColLists[i],",");
					String[] edgeItemIDs = (String[]) items[i];	// 列 or 行の軸ID配列
					int j=0;	// カウンタ。メジャーは飛ばす
					while ( st.hasMoreTokens() ) {	// 列 or 行に設定された軸の数だけ実行(メジャーがある場合は、軸の数-1)
						if( edgeItemIDs[j].equals(Constants.MeasureID) ) {
							j++;
						}
						String edgeItemID = edgeItemIDs[j];	// 軸のID(メジャーは含まない)

						LinkedHashMap<Integer, String> axisIdKeyMap = null;

						if ( i == 0) {			// 列
							axisIdKeyMap = colIdKeyMap;
						} else if ( i == 1 ) {	// 行
							axisIdKeyMap = rowIdKeyMap;
						}
						axisIdKeyMap.put(Integer.decode(edgeItemID), rs.getString(st.nextToken()));
						j++;
					}
				}

				// データレコードよりメジャーリストを取得
				if (( this.getTempMeasurePosition(items).equals(Constants.Col)) || this.getTempMeasurePosition(items).equals(Constants.Row)) {
					// 検索結果の１レコードよりCellDataオブジェクトの集合を生成

					for ( i = 0; i < report.getTotalMeasureMemberNumber(); i++ ) {

						// セレクタで対象からはずされているかをチェック
						MeasureMember measureMember = (MeasureMember) report.getMeasure().getAxisMemberByUniqueName(Integer.toString(i+1));
						if (!measureMember.isSelected()){
							 continue;
						}


						LinkedHashMap<Integer, String> tmpColIdKeyMap = null;
						LinkedHashMap<Integer, String> tmpRowIdKeyMap = null;

						// メジャー情報を追加
						if ( this.getTempMeasurePosition(items).equals(Constants.Col)) {
							tmpColIdKeyMap = addMeasureMemInfo(colIdKeyMap, Integer.toString(i+1), report, items);
							tmpRowIdKeyMap = rowIdKeyMap;
 						} else if (this.getTempMeasurePosition(items).equals(Constants.Row)) {
							tmpColIdKeyMap = colIdKeyMap;
							tmpRowIdKeyMap = addMeasureMemInfo(rowIdKeyMap, Integer.toString(i+1), report, items);
						}

						CellData cellData = this.createCellData( tmpColIdKeyMap, 
																  tmpRowIdKeyMap, 
																  rs.getString("measure_" + (i+1)), // 値
																  colCoordinatesList, 
																  rowCoordinatesList,
																  Integer.toString(i+1),			// メジャーメンバーのUName
																  measureMember.getMeasureSeq()		// メジャーメンバーのメジャーシーケンス
																  );

 						if (cellData != null) {
							cellDataList.add(cellData);	// セルデータオブジェクトの集合に追加
 						}
					}

				} else if ( this.getTempMeasurePosition(items).equals(Constants.Page) ) {


					// 検索結果の１レコードより１件のCellDataオブジェクトを生成
					CellData cellData = this.createCellData(colIdKeyMap, 
															 rowIdKeyMap, 
															 rs.getString("measure_" + cellDataSQL.getMeasureDefaultMember()), 	// 値
															 colCoordinatesList, 
															 rowCoordinatesList,
															 cellDataSQL.getMeasureDefaultMember(),		// メジャーメンバーのUName
															 cellDataSQL.getMeasureDefaultMeasureSeq()	// メジャーメンバーのメジャーシーケンス
															 );

					if (cellData != null) {
						cellDataList.add(cellData);	// セルデータオブジェクトの集合に追加
					}

				}

			 }
	
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (rs != null){
					rs.close();
				}
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (stmt != null){
						stmt.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}

		return cellDataList;
	}


	// ********** privateメソッド **********

	/**
	 * クライアントから送信された情報をもとにメジャーの配置エッジを求める。
	 * @param items 列、行、ページエッジ毎の軸IDリスト
	 *        items[0]：列エッジに配置された軸IDの配列
	 *        items[1]：列エッジに配置された軸IDの配列
	 *        items[2]：ページエッジに配置された軸IDとそのデフォルトメンバーキーの配列
	 * @return エッジの種類をあらわす文字列（「COL」、「ROW」、「PAGE」）
	 */
	private String getTempMeasurePosition(Object[] items) {

		int i = 0;

		// 列のIDリスト
		String[] colItemIDs = (String[]) items[0];
		for ( i = 0; i < colItemIDs.length; i++ ) {
			if (colItemIDs[i].equals(Constants.MeasureID) ){
				return Constants.Col;
			}
		}
		
		// 行のIDリスト
		String[] rowItemIDs = (String[]) items[1];
		for ( i = 0; i < rowItemIDs.length; i++ ) {
			if (rowItemIDs[i].equals(Constants.MeasureID) ){
				return Constants.Row;
			}
		}
		return Constants.Page;
	}


	/**
	 * メジャーのエッジ内でのインデックス（0start）を求める。
	 * @param items 列、行、ページエッジ毎の軸IDリスト
	 *        items[0]：列エッジに配置された軸IDの配列
	 *        items[1]：列エッジに配置された軸IDの配列
	 *        items[2]：ページエッジに配置された軸IDとそのデフォルトメンバーキーの配列
	 * @return エッジ内でのインデックス
	 */
	private int getTempMeasureHieIndex(Object[] items) {

		int i = 0;

		// 列のIDリスト
		String[] colItemIDs = (String[]) items[0];
		for ( i = 0; i < colItemIDs.length; i++ ) {
			if (colItemIDs[i].equals(Constants.MeasureID) ){
				return i;
			}
		}
		
		// 行のIDリスト
		String[] rowItemIDs = (String[]) items[1];
		for ( i = 0; i < rowItemIDs.length; i++ ) {
			if (rowItemIDs[i].equals(Constants.MeasureID) ){
				return i;
			}
		}
		return -1;
	}

	/**
	 * メジャーが存在するエッジ（列or行)のLinkedHashMap(軸ID,メンバーキー)に、メジャー情報を追加する
	 * @param targetEdgeMap 行または列のMapオブジェクト
	 * @param measureKey メジャーキー
	 * @param report レポートオブジェクト
	 * @param items 列、行、ページエッジ毎の軸IDリスト
	 *        items[0]：列エッジに配置された軸IDの配列
	 *        items[1]：列エッジに配置された軸IDの配列
	 *        items[2]：ページエッジに配置された軸IDとそのデフォルトメンバーキーの配列
	 * @return 軸IDをKeyに持ち、メンバーキーをValueに持つLinkedHashMapオブジェクト
	 */
	private LinkedHashMap<Integer, String> addMeasureMemInfo(LinkedHashMap<Integer, String> targetEdgeMap, String measureKey, Report report,Object[] items) {
		LinkedHashMap<Integer, String> newHashMap = new LinkedHashMap<Integer, String>();

		// メジャーのエッジ内でのインデックス(0start)
		int measureHieIndex = this.getTempMeasureHieIndex(items);

		// メジャーを表す情報を追加
		if ( measureHieIndex == targetEdgeMap.size()) {	// 最終段がメジャー
			newHashMap.putAll(targetEdgeMap);
			newHashMap.put(Integer.decode(Constants.MeasureID), measureKey);
		} else {
			Iterator<Integer> it = targetEdgeMap.keySet().iterator();
			int i = 0;
			while (it.hasNext()) {
				Integer id = it.next();
				String key = targetEdgeMap.get(id);
				
				if ( i == measureHieIndex ) {
					newHashMap.put(Integer.decode(Constants.MeasureID), measureKey);
				} 
				newHashMap.put(id, key);
				i++;
			}
		}

		return newHashMap;
	}

	/**
	 * CellDataオブジェクトを求める。
	 * 作成できない場合はnullを戻す。
	 * @param colIdKeyMap 列の軸IDをKeyにもち、メンバーキーをValueに持つMapオブジェクト
	 * @param rowIdKeyMap 行の軸IDとKeyにもち、メンバーキーをValueに持つMapオブジェクト
	 * @param value 値
	 * @param colCoordinatesList 行のEdgeCoordinatesオブジェクトのリスト
	 * @param rowCoordinatesList 列のEdgeCoordinatesオブジェクトのリスト
	 * @param measureMemberUName メジャーメンバーのUniqueName(Viewerが0から振った通番)
	 * @param measureSeq メジャーメンバーのメジャーシーケンス
	 * @return 軸IDをKeyに持ち、メンバーキーをValueに持つLinkedHashMapオブジェクト
	 */

	private CellData createCellData(LinkedHashMap<Integer, String> colIdKeyMap, LinkedHashMap<Integer, String> rowIdKeyMap, String value, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String measureMemberUName, String measureSeq) {

		// 列のEdgeCoordinatesオブジェクトを取得
		EdgeCoordinates colCoordinates = null;
			Iterator<EdgeCoordinates> colIt = colCoordinatesList.iterator();
			while (colIt.hasNext()) {
				EdgeCoordinates edgeCoordinates = colIt.next();
				LinkedHashMap<Integer, String> axisIdKeyMap = edgeCoordinates.getAxisIdMemKeyMap();
				if ( mapHasSameKeyAndValue(colIdKeyMap, axisIdKeyMap) ) {
					colCoordinates = edgeCoordinates;
					break;
				}
			}
		
		// 行のEdgeCoordinatesオブジェクトを取得
		EdgeCoordinates rowCoordinates = null;
		Iterator<EdgeCoordinates> rowIt = rowCoordinatesList.iterator();
		while (rowIt.hasNext()) {
			EdgeCoordinates edgeCoordinates = rowIt.next();
			LinkedHashMap<Integer, String> axisIdKeyMap = edgeCoordinates.getAxisIdMemKeyMap();
			if ( mapHasSameKeyAndValue(rowIdKeyMap, axisIdKeyMap) ) {
				rowCoordinates = edgeCoordinates;
				break;
			}
		}

		if ( (colCoordinates == null) || (rowCoordinates == null) ) {
		// 複数段の場合に、取得したいデータに対し、SQLが返すデータが冗長である場合がある。
		// この場合、CellDataオブジェクトは生成しない
		// 例）0段：軸ID16、1段：軸ID1のとき、軸ID16のメンバ(Key=0)に属する軸ID1のメンバ(Key=1)でドリル
		//     DBからの取得結果には、軸ID16のKey0以外のメンバに属する軸ID1のメンバ(Key=1)の値も含まれる

			return null;
		}

		
		// CellDataオブジェクト生成
		CellData cellData = new CellData(colCoordinates, rowCoordinates, measureMemberUName, measureSeq);
		cellData.setValue(value);	// 値を設定
		
		return cellData;
	}


	/**
	 * 与えられた２つのLinkedHashMapが同じKeyとValueを持つ場合true、持たない場合falseを戻す。
	 * @param map1 列の軸IDをKeyにもち、メンバーキーをValueに持つMapオブジェクト
	 * @param map2 行の軸IDとKeyにもち、メンバーキーをValueに持つMapオブジェクト
	 * @return 同じKey,Valueを持つか
	 */
	private boolean mapHasSameKeyAndValue( LinkedHashMap<Integer, String> map1, LinkedHashMap<Integer, String> map2  ) {
		if ( ( map1 == null) || ( map2 == null) ) { return false; }

		// 要素数比較
		if ( map1.size() != map2.size() ) {
			return false;
		}
		
		// 要素を比較（Key、valueの持つ値が等しいか）
		Iterator<Integer> it1 = map1.keySet().iterator();
		Iterator<Integer> it2 = map2.keySet().iterator();
		while ( it1.hasNext() ) {
			Integer map1Key = it1.next();
			Integer map2Key = it2.next();

			if ( !map1Key.equals(map2Key) ) {
				return false;
			}

			String map1Value = map1.get(map1Key);
			String map2Value = map2.get(map1Key);

			if ( !map1Value.equals(map2Value) ) {
				return false;
			}
		}
		return true;
	}


}
