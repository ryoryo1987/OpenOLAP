/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：PostgresAxisMemberDAO.java
 *  説明：軸メンバーオブジェクトの永続化を管理するクラスです。
 *
 *  作成日: 2004/01/14
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;


/**
 *  クラス：PostgresAxisMemberDAO<br>
 *  説明：軸メンバーオブジェクトの永続化を管理するクラスです。
 */
public abstract class PostgresAxisMemberDAO implements AxisMemberDAO {

	// ********** インスタンス変数 **********

	/** ロギングオブジェクト */
	private Logger log = Logger.getLogger(PostgresAxisMemberDAO.class.getName());

	// ********** 抽象メソッド **********

	/**
	 * 与えられた軸のディメンションメンバーを永続化する。
	 * @param report レポートオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで軸メンバー情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で軸メンバー情報を保存する。
	 * @param axis 軸オブジェクト
	 * @param conn Connecionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public abstract void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException;

	/**
	 * ディメンションメンバー情報をデータソースの情報をもとに生成し、ディメンションオブジェクトの"selectedMemberDrillStat"に設定する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public abstract void applyAxis(Report report, Axis axis, CommonSettings commonSettings) throws SQLException;

	// ********** メソッド **********

	/**
	 * データソースに保存済されている軸メンバー情報を取得する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 */
	public String selectSaveDataSQL(Report report, Axis axis ) {

		String SQL = "";
		SQL =  "";
		SQL += "select ";
		SQL += "    report_id, ";
		SQL += "    axis_id, ";
		SQL += "    dimension_seq, ";
		SQL += "    member_key, ";
		SQL += "    selectedFLG, ";
		SQL += "    drilledFLG, ";
		SQL += "    measure_member_type_id ";
		SQL += "from ";
		SQL += "    oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID() + " and ";
		SQL += "    axis_id=" + axis.getId() + " ";
		SQL += "order by ";
		SQL += "    member_key";

		return SQL;
	}

	/**
	 * 指定されたレポートのすべての軸の軸メンバ情報を削除する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxisMember(Report report, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + report.getReportID();

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete all axes members)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}
	}

	/**
	 * 指定されたレポートの指定された軸のメンバ情報を削除する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxisMember(Report report, Axis axis, Connection conn) throws SQLException {

		deleteAxisMember(report.getReportID(), axis.getId(), conn);

	}


	/**
	 * 指定されたレポートの指定された軸のメンバ情報を削除する。
	 * @param reportID レポートID
	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxisMember(String reportID, String axisID, Connection conn) throws SQLException {

		String SQL = "";
		SQL =  "";
		SQL += "delete from oo_v_axis_member ";
		SQL += "where ";
		SQL += "    report_id=" + reportID + " and ";
		SQL += "    axis_id=" + axisID;

		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			if(log.isInfoEnabled()) {
				log.info("SQL(delete specified axis members)：\n" + SQL);
			}
			stmt.executeUpdate(SQL);
		} catch (SQLException e) {
			throw e;
		} finally {
			try {
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}
	}





}
