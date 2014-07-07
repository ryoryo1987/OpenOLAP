/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresCubeDAO.java
 *  説明：キューブオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Cube;

/**
 *  クラス：PostgresCubeDAO<br>
 *  説明：キューブオブジェクトの永続化を管理するクラスです。
 */
public class PostgresCubeDAO implements CubeDAO {

	// ********** インスタンス変数 **********

	/** Connectionオブジェクト */
	Connection conn = null;

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresCubeDAO.class.getName());

	// ********** コンストラクタ **********

	/**
	 * キューブオブジェクトの永続化を管理するオブジェクトを生成します。
	 */
	PostgresCubeDAO(Connection conn) {
		this.conn = conn;
	}

	// ********** メソッド **********

	/**
	 * ファクトテーブル名を求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return ファクトテーブル名
	 */
	public String getFactTableName(String cubeSeq) {
		String factTableName = "v_CUBE_" + cubeSeq;
		return factTableName;
	}

	/**
	 * キューブシーケンス番号をもとにキューブオブジェクトを求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return キューブオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Cube getCubeByID(String cubeSeq) throws SQLException {
		String cubeName = this.getCubeName(cubeSeq);
		Cube cube = new Cube(	cubeSeq,					// cubeSeq
								cubeName);					// cubeName
		return cube;
	}

	/**
	 * キューブシーケンス番号をもとにキューブ名を求める。
	 * @param cubeSeq キューブのシーケンス番号
	 * @return キューブ名
	 * @exception SQLException 処理中に例外が発生した
	 */
	public String getCubeName(String cubeSeq) throws SQLException {

		String cubeName = null;

		String SQL = "";
		Statement stmt = null;
		ResultSet rs = null;
		SQL =   "";
		SQL +=	" select ";
		SQL +=	"    NAME ";
		SQL +=	" from ";
		SQL +=	"    oo_cube ";
		SQL +=	" where ";
		SQL +=	"    cube_seq = " + cubeSeq;

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(select axis members)：\n" + SQL);
			}
			rs = stmt.executeQuery(SQL);

			while ( rs.next() ) {
				cubeName = rs.getString("NAME");
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

		if(log.isDebugEnabled()) {
			log.debug("cubeName:" + cubeName);
		}

		return cubeName;
	}

}
