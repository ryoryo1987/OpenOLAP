/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：MeasureDAO.java
 *  説明：メジャーオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Measure;
import openolap.viewer.common.CommonSettings;

/**
 *  インターフェース：MeasureDAO<br>
 *  説明：メジャーオブジェクトの永続化を管理するインターフェースです。
 */
public interface MeasureDAO {

	/**
	 * メジャーオブジェクトを求める。<br>
	 *   メジャーオブジェクトの状態：<br>
	 *     メジャーメンバーオブジェクト：持たない
	 * @return メジャーオブジェクト
	 */
	public Measure findMeasureWithoutMember();

	/**
	 * メジャーオブジェクトを求める。<br>
	 *   メジャーオブジェクトの状態：<br>
	 *     メジャーメンバーオブジェクト：持つ
	 * @param cubeSeq キューブシーケンス番号
	 * @param commonSettings アプリケーションの共通設定
	 * @return メジャーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Measure findMeasureWithMember(String cubeSeq, CommonSettings commonSettings) throws SQLException;

}
