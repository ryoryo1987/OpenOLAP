/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：SecurityDAO.java
 *  説明：セキュリティ情報の永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Security;

/**
 *  インターフェース：UserDAO<br>
 *  説明：ユーザー情報の永続化を管理するインターフェースです。
 */
public interface SecurityDAO {

	/**
	 * 与えられたユーザーID、レポートIDをもとにセキュリティオブジェクトを求める。<br>
	 * @param userID ユーザーID
	 * @param reportID レポートID
	 * @return セキュリティオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Security getSecurity(String userID, String reportID) throws SQLException;

}
