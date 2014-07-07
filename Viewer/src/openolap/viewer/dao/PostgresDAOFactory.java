/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresDAOFactory.java
 *  説明：永続化管理クラス群のPostgres用実装オブジェクトを生成するクラスです。
 *
 *  作成日: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Measure;

/**
 *  クラス：PostgresDAOFactory<br>
 *  説明：永続化管理クラス群のPostgres用実装オブジェクトを生成するクラスです。
 */
public class PostgresDAOFactory extends DAOFactory {

	// ********** インスタンス変数 **********

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresDAOFactory.class.getName());

	// ********** メソッド **********

	/**
	 * Connection PoolよりConnectionを取得し、Connectionを初期化します。
	 * @param connectionPoolName コネクションぷーリングの名称
	 * @param attr1 search_path情報。 nullの場合は、設定しない。
	 * @return Connection オブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public Connection getConnection(String connectionPoolName, String attr1) throws SQLException, NamingException {
		Connection conn = null;
		try {
			InitialContext initCtx = new InitialContext();

			DataSource ds = null;

			ds = (DataSource)initCtx.lookup("java:/comp/env/" + connectionPoolName); //$NON-NLS-1$

			conn = ds.getConnection();
			conn = initialyzeConnection(conn, attr1);
		} catch (SQLException e) {
			throw e;
		} catch (NamingException e) {
			throw e;
		}

		return conn;
	}



	/**
	 * 与えられたConnectionオブジェクトを初期化して戻します。
	 *   初期化：プロパティーファイルに指定された情報をもとにsearch pathを設定する。
	 * @param conn Connection オブジェクト
	 * @param searchPath search_path名。 nullの場合は、設定しない。
	 * @return Connection オブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	private Connection initialyzeConnection(Connection conn, String searchPath) throws SQLException {

		// search_path情報。 nullの場合は、設定しない
		if (searchPath == null) {
			return conn;
		}

		// search_pathを設定。
		Statement stmt = null;
		String SQL = "";
		SQL =   "";
		SQL +=	"set search_path to " + searchPath + ",public";

		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(set search_path)：\n" + SQL);
			}
			int retNum = stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}
		return conn;
	}


	// DAO取得用メソッド

	/**
	 * ディメンションオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return DimensionDAO オブジェクト
	 */
	public DimensionDAO getDimensionDAO(Connection conn) {
		return new PostgresDimensionDAO(conn);
	}

	/**
	 * メジャーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureDAO オブジェクト
	 */
	public MeasureDAO getMeasureDAO(Connection conn) {
		return new PostgresMeasureDAO(conn);
	}

	/**
	 * メジャーメンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureMemberDAO オブジェクト
	 */
	public MeasureMemberDAO getMeasureMemberDAO(Connection conn) {
		return new PostgresMeasureMemberDAO(conn);
	}

	/**
	 * レポートオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return ReportDAO オブジェクト
	 */
	public ReportDAO getReportDAO(Connection conn) {
		return new PostgresReportDAO(conn);
	}

	/**
	 * キューブオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return CubeDAO オブジェクト
	 */
	public CubeDAO getCubeDAO(Connection conn) {
		return new PostgresCubeDAO(conn);
	}

	/**
	 * 軸レベルオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisLevelDAO オブジェクト
	 */
	public AxisLevelDAO getAxisLevelDAO(Connection conn) {
		return new PostgresAxisLevelDAO(conn);
	}

	/**
	 * ディメンションメンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return DimensionMemberDAO オブジェクト
	 */
	public DimensionMemberDAO getDimensionMemberDAO(Connection conn) {
		return new PostgresDimensionMemberDAO(conn);
	}

	/**
	 * セルデータオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return CellDataDAO オブジェクト
	 */
	public CellDataDAO getCellDataDAO(Connection conn){
		return new PostgresCellDataDAO(conn);
	}

	/**
	 * メジャーメンバータイプオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureMemberTypeDAO オブジェクト
	 */
	public MeasureMemberTypeDAO getMeasureMemberTypeDAO(Connection conn) {
		return new PostgresMeasureMemberTypeDAO(conn);
	}

	/**
	 * 軸オブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisDAO オブジェクト
	 */
	public AxisDAO getAxisDAO(Connection conn) {
		return new PostgresAxisDAO(conn);
	}

	/**
	 * 軸メンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisMemberDAO オブジェクト
	 */
	public AxisMemberDAO getAxisMemberDAO(Connection conn) {
		return new PostgresDimensionMemberDAO(conn);
	}

	/**
	 * 軸メンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisMemberDAO オブジェクト
	 */
	public AxisMemberDAO getAxisMemberDAO(Connection conn, Axis axis) {
		if (axis == null) {
			return new PostgresDimensionMemberDAO(conn);
		} else if(axis instanceof Measure){
			return new PostgresMeasureMemberDAO(conn);
		} else if (axis instanceof Dimension){
			return new PostgresDimensionMemberDAO(conn);
		} else {
			throw new IllegalStateException();
		}
	}

	/**
	 * 色オブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return ColorDAO オブジェクト
	 */
	public ColorDAO getColorDAO(Connection conn){
		return new PostgresColorDAO(conn);
	}

	/**
	 * ユーザーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return UserDAO オブジェクト
	 */
	public UserDAO getUserDAO(Connection conn) {
		return new PostgresUserDAO(conn);
	}

	/**
	 * セキュリティオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return SecurityDAO オブジェクト
	 */
	public SecurityDAO getSecurityDAO(Connection conn) {
		return new PostgresSecurityDAO(conn);
	}

	/**
	 * RReportの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return RReportDAO オブジェクト
	 */
	public RReportDAO getRReportDAO(Connection conn) {
		return new PostgresRReportDAO(conn);
	}


}
