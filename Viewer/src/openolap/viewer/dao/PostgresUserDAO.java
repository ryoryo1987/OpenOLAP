/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresUserDAO.java
 *  説明：ユーザー情報の永続化を管理するクラスです。
 *
 *  作成日: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.User;

/**
 *  クラス：PostgresUserDAO<br>
 *  説明：ユーザー情報の永続化を管理するクラスです。
 */
public class PostgresUserDAO implements UserDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresUserDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 *  ユーザー情報の永続化を管理するオブジェクトを生成します。
	 */
	public PostgresUserDAO (Connection conn) {
		this.conn = conn;
	}


	// ********** メソッド **********
	
	/**
	 * 与えられたユーザー名、パスワードをもとにユーザーオブジェクトを求める。<br>
	 * 登録されていない場合はログイン失敗とみなし、nullを戻す。
	 * @param userName ユーザー名
	 * @param password パスワード
	 * @return ユーザーオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public User getUser(String userName, String password) throws SQLException {

		User user = null;

		String SQL = "";
		SQL += "select ";
		SQL += "    u.user_id,";					// id
		SQL += "    u.name,";						// ユーザ名
		SQL += "    u.adminflg, ";					// 管理者フラグ
		SQL += "    u.export_file_type, ";			// エクスポートタイプ
		SQL += "    s.name as color_style_name, ";	// カラースタイル名
		SQL += "    s.spreadstyle_file, ";			// カラースタイル（spreadStyleのファイル名）
		SQL += "    s.cellcolortable_file ";		// カラースタイル（cellColorTableのファイル名）
		SQL += "from ";
		SQL += "    oo_v_user u, oo_v_color_style s ";
		SQL += "where ";
		SQL += "    u.color_style_id = s.id and ";
		SQL += "    u.name='" + userName + "' and ";
		SQL += "    u.password='" + password + "'";

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select user(by name, passwd))：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				user = new User(rs.getString("user_id"),
								 rs.getString("name"),
								 rs.getString("adminflg"),
								 rs.getString("export_file_type"),
								 rs.getString("color_style_name"),
								 rs.getString("spreadstyle_file"),
								 rs.getString("cellcolortable_file")
								 );
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
		
		return user;
	}

}
