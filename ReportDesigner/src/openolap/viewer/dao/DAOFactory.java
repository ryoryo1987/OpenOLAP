/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：DAOFactory.java
 *  説明：永続化管理クラス群のオブジェクトを生成する抽象クラスです。
 *
 *  作成日: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import openolap.viewer.Axis;
import openolap.viewer.common.Messages;
import openolap.viewer.controller.RequestHelper;

/**
 *  抽象クラス：DAOFactory<br>
 *  説明：永続化管理クラス群のオブジェクトを生成する抽象クラスです。
 */
public abstract class DAOFactory {

	// ********** インスタンス変数 **********

    // RequestHelper
	protected RequestHelper helper = null;

	// ********** 抽象メソッド **********

	/**
	 * Connection PoolよりConnectionを取得し、Connectionを初期化します。
	 * @param connectionPoolName server.xml、web.xmlで設定しているコネクションプール名
	 * @param attr1 任意の引数
	 * @return Connection オブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public abstract Connection getConnection(String connectionPoolName, String attr1) throws SQLException, NamingException;

	/**
	 * ディメンションオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return DimensionDAO オブジェクト
	 */
	public abstract DimensionDAO getDimensionDAO(Connection conn);

	/**
	 * メジャーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureDAO オブジェクト
	 */
	public abstract MeasureDAO getMeasureDAO(Connection conn);

	/**
	 * メジャーメンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureMemberDAO オブジェクト
	 */
	public abstract MeasureMemberDAO getMeasureMemberDAO(Connection conn);

	/**
	 * レポートオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return ReportDAO オブジェクト
	 */
	public abstract ReportDAO getReportDAO(Connection conn);

	/**
	 * キューブオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return CubeDAO オブジェクト
	 */
	public abstract CubeDAO getCubeDAO(Connection conn);

	/**
	 * 軸レベルオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisLevelDAO オブジェクト
	 */
	public abstract AxisLevelDAO getAxisLevelDAO(Connection conn);

	/**
	 * ディメンションメンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return DimensionMemberDAO オブジェクト
	 */
	public abstract DimensionMemberDAO getDimensionMemberDAO(Connection conn);

	/**
	 * セルデータオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return CellDataDAO オブジェクト
	 */
	public abstract CellDataDAO getCellDataDAO(Connection conn);

	/**
	 * メジャーメンバータイプオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return MeasureMemberTypeDAO オブジェクト
	 */
	public abstract MeasureMemberTypeDAO getMeasureMemberTypeDAO(Connection conn);

	/**
	 * 軸オブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return PostgresAxisDAO オブジェクト
	 */
	public abstract AxisDAO getAxisDAO(Connection conn);

	/**
	 * 軸メンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return AxisMemberDAO オブジェクト
	 */
	public abstract AxisMemberDAO getAxisMemberDAO(Connection conn);

	/**
	 * 軸メンバーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @param axis 軸をあらわすオブジェクト
	 * @return AxisMemberDAO オブジェクト
	 */
	public abstract AxisMemberDAO getAxisMemberDAO(Connection conn, Axis axis);

	/**
	 * 色オブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return ColorDAO オブジェクト
	 */
	public abstract ColorDAO getColorDAO(Connection conn);

	/**
	 * ユーザーオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return UserDAO オブジェクト
	 */
	public abstract UserDAO getUserDAO(Connection conn); 

	/**
	 * セキュリティオブジェクトの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return SecurityDAO オブジェクト
	 */
	public abstract SecurityDAO getSecurityDAO(Connection conn); 

	/**
	 * RReportの永続化を管理するオブジェクトを求める。
	 * @param conn Connection オブジェクト
	 * @return RReportDAO オブジェクト
	 */
	public abstract RReportDAO getRReportDAO(Connection conn); 

	// ********** メソッド **********

	/**
	 * データソースのタイプに応じたFactoryオブジェクトを求めます。
	 *   データソースのタイプ：viewer.propertiesの"DAOFactory.sourceName"で指定
	 * @return DAOFactory オブジェクト
	 */
	public static DAOFactory getDAOFactory() {
		String sourceName = Messages.getString("DAOFactory.sourceName"); //$NON-NLS-1$
		if (sourceName.equals("postgres")) { //$NON-NLS-1$
			return new PostgresDAOFactory();
		} else {
			throw new UnsupportedOperationException();
		}
	}

}
