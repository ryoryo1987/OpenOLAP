/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：ColorDAO.java
 *  説明：色オブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/15
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：ColorDAO<br>
 *  説明：色オブジェクトの永続化を管理するインターフェースです。
 */
public interface ColorDAO {

	/**
	 * クライアント側から送られてきた色情報をサーバー側のモデルに反映する。<br>
	 * クライアントから受信した情報：<br>
	 *   ・dtColorInfo  ： データテーブル部の色情報
	 *   ・hdrColorInfo ： ヘッダー部の色情報
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定をあらわすオブジェクト
	 */
	public void registColor(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * 色情報を永続化する。
	 * @param report レポートオブジェクト
	 * @param reportID レポートID
	 *                ※このパラメータがNULLの場合、Reportオブジェクトが持つレポートIDで色情報を保存する。
	 *                  NULLではない場合は、reportIDパラメータの値で色情報を保存する。
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveColor(Report report, String reportID, Connection conn) throws SQLException;

	/**
	 * データソースより色設定を求め、レポートオブジェクトに登録する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void applyColor(Report report, Connection conn) throws SQLException;

	/**
	 * あたえられたレポートの色情報をデータソースから削除する。
	 * @param report レポートオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void deleteColor(Report report, Connection conn) throws SQLException;

}
