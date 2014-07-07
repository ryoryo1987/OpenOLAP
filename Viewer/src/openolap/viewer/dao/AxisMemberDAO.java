/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：AxisMemberDAO.java
 *  説明：軸メンバーオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/14
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;

/**
 *  クラス：AxisMemberDAO<br>
 *  説明：軸メンバーオブジェクトの永続化を管理するインターフェースです。
 */
public interface AxisMemberDAO {

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
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException;

	/**
	 * ディメンションメンバー情報をデータソースの情報をもとに生成し、ディメンションオブジェクトの"selectedMemberDrillStat"に設定する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyAxis(Report report,Axis axis, CommonSettings commonSettings) throws SQLException;

	/**
	 * データソースに保存済されている軸メンバー情報を取得する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 */
	public String selectSaveDataSQL(Report report, Axis axis);

	/**
	 * 指定されたレポートの指定された軸のメンバ情報を削除する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxisMember(Report report, Axis axis, Connection conn) throws SQLException;

	/**
	 * 指定されたレポートのすべての軸の軸メンバ情報を削除する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxisMember(Report report, Connection conn) throws SQLException;

}
