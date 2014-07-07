/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：AxisLevelDAO.java
 *  説明：軸レベルオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;

/**
 *  クラス：AxisLevelDAO<br>
 *  説明：軸レベルオブジェクトの永続化を管理するインターフェースです。
 */
public interface AxisLevelDAO {

	/**
	 * 与えられた軸の軸レベルオブジェクトのリストを求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @param axis 軸オブジェクト
	 * @return 軸レベルオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<AxisLevel> selectAxisLevels(String cubeSeq, Axis axis) throws SQLException;

}
