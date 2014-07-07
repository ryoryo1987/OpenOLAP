/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：CubeDAO.java
 *  説明：キューブオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Cube;

/**
 *  クラス：CubeDAO<br>
 *  説明：キューブオブジェクトの永続化を管理するインターフェースです。
 */
public interface CubeDAO {

	/**
	 * ファクトテーブル名を求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return ファクトテーブル名
	 */
	public String getFactTableName(String cubeSeq);

	/**
	 * キューブシーケンス番号をもとにキューブ名を求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return キューブ名
	 * @exception SQLException 処理中に例外が発生した
	 */
	public String getCubeName(String cubeSeq) throws SQLException;

	/**
	 * キューブシーケンス番号をもとにキューブオブジェクトを求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return キューブオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Cube getCubeByID(String cubeSeq) throws SQLException;

}
