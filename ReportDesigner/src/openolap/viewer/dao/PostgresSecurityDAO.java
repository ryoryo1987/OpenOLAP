/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresSecurityDAO.java
 *  説明：セキュリティ情報の永続化を管理するクラスです。
 *
 *  作成日: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Security;
import openolap.viewer.common.CommonUtils;

/**
 *  クラス：PostgresUserDAO<br>
 *  説明：ユーザー情報の永続化を管理するクラスです。
 */
public class PostgresSecurityDAO implements SecurityDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresSecurityDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 *  ユーザー情報の永続化を管理するオブジェクトを生成します。
	 */
	public PostgresSecurityDAO (Connection conn) {
		this.conn = conn;
	}


	// ********** メソッド **********
	
	/**
	 * 与えられたユーザーID、レポートIDをもとにセキュリティオブジェクトを求める。<br>
	 * @param userID ユーザーID
	 * @param reportID レポートID
	 * @return セキュリティオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Security getSecurity(String userID, String reportID) throws SQLException {

		Security security = null;

		String SQL = "";
		SQL += "select ";
		SQL += "    right_flg,";		// 閲覧権限         1：あり、0：なし
		SQL += "    export_flg ";		// エクスポート権限  1：あり、0：なし
		SQL += "from ";
		SQL += "    oo_sec_func(" + userID + "," + reportID + ")";

		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select security SQL:)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				security = new Security(CommonUtils.FLGTobool(rs.getString("right_flg")),
										 CommonUtils.FLGTobool(rs.getString("export_flg")));
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
		
		return security;
	}

}
