/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：AxisDAO.java
 *  説明：軸情報を取得するインターフェースです。
 *
 *  作成日: 2004/01/13
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：AxisDAO<br>
 *  説明：軸情報を取得するインターフェースです。
 */
public interface AxisDAO {

	/**
	 * クライアントから送信されたパラメータをもとに、軸のメンバのセレクタ選択情報、ドリル情報を反映する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registSelectedMemberAndDrillStat(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * クライアントから送信されたパラメータをもとに、モデルの軸メンバーのデフォルトメンバ情報を更新する。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registDefaultMember(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * 与えられたレポートIDをもとに軸情報をデータソースへ保存する。
	 * @param report Reportオブジェクト 
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで軸情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で軸情報を保存する。
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveAxis(Report report, String reportID, Connection conn) throws SQLException;

	/**
	 * データソースから取得したレポート設定をモデルに反映する。
	 * @param report Reportオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyAxis(Report report, CommonSettings commonSettings, Connection conn) throws SQLException;

	/**
	 * 与えられたレポートの全ての軸の情報をデータソースから削除する。
	 * @param report Reportオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxes(Report report, Connection conn) throws SQLException;

	/**
	 * 与えられた軸の情報をデータソースから削除する。
	 * @param report レポートオブジェクト
	 * @param axis 軸オブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteAxis(Report report, Axis axis, Connection conn) throws SQLException;
	
}
