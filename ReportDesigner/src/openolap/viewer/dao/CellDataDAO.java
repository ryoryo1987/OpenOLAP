/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：CellDataDAO.java
 *  説明：セルデータオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Report;
import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;


/**
 *  クラス：CellDataDAO<br>
 *  説明：セルデータオブジェクトの永続化を管理するインターフェースです。
 */
public interface CellDataDAO {

	// ********** 静的変数 **********

	/** 標準（処理は高速で、軸ID順にソートされる）をあらわすSQLタイプを表す文字列 */
	static String normalSQLTypeString = "Normal";

	/** 行・列・ページエッジの軸順でソートされたSQLタイプを表す文字列 */
	static String sortedSQLTypeString = "Sorted";
	
	
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
	 * @param SQLType SQLタイプ。ここで指定されたタイプのSQLが実行される。
	 * 			this.normalSQLTypeString：標準（処理は高速で、軸ID順にソートされる）
	 * 			this.sortedSQLTypeString：行・列・ページエッジの軸順でソート
	 * @return セルデータオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<CellData> selectCellDatas(CellDataSQL cellDataSQL, Object[] items, HttpServletRequest request, Report report, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String SQLType) throws SQLException;

}
