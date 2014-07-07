/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：UserDAO.java
 *  説明：ユーザー情報の永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.User;

/**
 *  インターフェース：UserDAO<br>
 *  説明：ユーザー情報の永続化を管理するインターフェースです。
 */
public interface UserDAO {

	/**
	 * 与えられたユーザー名、パスワードをもとにユーザーオブジェクトを求める。<br>
	 * 登録されていない場合はログイン失敗とみなし、nullを戻す。
	 * @param userName ユーザー名
	 * @param password パスワード
	 * @return ユーザーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public User getUser(String userName, String password) throws SQLException;

}
