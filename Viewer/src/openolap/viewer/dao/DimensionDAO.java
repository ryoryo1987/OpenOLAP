/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：DimensionDAO.java
 *  説明：ディメンションオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.Dimension;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：DimensionDAO<br>
 *  説明：ディメンションオブジェクトの永続化を管理するインターフェースです。
 */
public interface DimensionDAO {

	/**
	 * ディメンションオブジェクトのリストを求める。
	 * @param cubeSeq キューブシーケンス番号
	 * @return ディメンションオブジェクトのリスト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public ArrayList<Dimension> selectDimensions(String cubeSeq) throws SQLException;

	/**
	 * ディメンションのメンバー名の表示タイプ情報を更新する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 */
	public void registDimensionMemberDispType(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * データソースのディメンションの物理テーブル名を求める。
	 * @param dimSeq ディメンションシーケンス番号
	 * @param partSeq ディメンションのパーツ番号
	 * @return DBの物理テーブル名
	 */
	public String getDimensionTableName(String dimSeq, String partSeq);

}
