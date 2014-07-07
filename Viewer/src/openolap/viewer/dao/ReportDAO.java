/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：ReportDAO.java
 *  説明：レポートオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2004/01/07
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;
import org.xml.sax.SAXException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：ReportDAO<br>
 *  説明：レポートオブジェクトの永続化を管理するインターフェースです。
 */
public interface ReportDAO {

	/**
	 * 未使用のレポートIDを取得を求める。
	 * @param conn Connectionオブジェクト
	 * @return 未使用のレポートID
	 * @exception SQLException 処理中に例外が発生した
	 */
	public String getInitialReportID(Connection conn) throws SQLException;

	/**
	 * クライアントから送信されたデフォルトメンバー、軸の配置情報をモデルのレポートオブジェクトに反映する。
	 *   パラメータ名）
	 *     defaultMembers：全軸のデフォルトメンバー情報
	 *     colItems：列エッジに配置された軸のID
	 *     rowItems：行エッジに配置された軸のID
	 *     pageItems：ページエッジに配置された軸のID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registAxisPosition(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * レポートの軸のエッジ配置情報を更新する。
	 * @param colItemList 列に配置された軸IDリスト
	 * @param rowItemList 行に配置された軸IDリスト
	 * @param pageItemList ページに配置された軸IDリスト
	 * @param report レポートをあらわすオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registAxisPosition(ArrayList<String> colItemList, ArrayList<String> rowItemList, ArrayList<String>  pageItemList, Report report);

	/**
	 * レポート情報をデータソースへ保存する。
	 * @param report レポートをあらわすオブジェクト
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveReport(Report report, Connection conn) throws SQLException;


	/**
	 * レポート情報をデータソースへ保存する。
	 * @param report レポートをあらわすオブジェクト
	 * @param newReportName 新規レポート名
	 * @param userID ユーザID
	 * @param conn Connectionオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public void saveNewPersonalReport(Report report, String newReportName, String userID, Connection conn)  throws SQLException;


	/**
	 * キューブシーケンス番号をもとに、レポートオブジェクトを生成する。
	 * @param cubeSeq キューブシーケンス番号
	 * @param userID レポートの所有ユーザのID 
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return レポートオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Report getInitialReport(String cubeSeq, String userID, CommonSettings commonSettings) throws SQLException;

	/**
	 * レポートIDをもとに既存のレポートオブジェクトを求める。
	 * @param reportId レポートID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return レポートオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public Report getExistingReport(String reportId, RequestHelper helper, CommonSettings commonSettings) throws SQLException;

	/**
	 * クライアントから送信されたレポートの名称、親フォルダ情報をモデルのレポートオブジェクトに反映する。
	 *   パラメータ名）
	 *     reportName：レポート名
	 *     folderID：レポートを格納するフォルダのID
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 */
	public void registReport(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * データベースより、Rレポートメタ情報であるテンプレートXML、SQL文字列を取得する。
	 * 
	 * @param sourceTable: テンプレートXML,SQL の取得元テーブル名 
	 * @param reportID: sourceTable の絞込み条件（レポートID）
	 * @return 下記文字列を格納したHashMapオブジェクト
	 * 				templateXMLString: テンプレートXML
	 * 				getDataSQL: SQL
	 * @exception SQLException 処理中に例外が発生した
	 */
	public HashMap<String, String> getTemplateInfo(String sourceTable, String reportID) throws SQLException;

	/**
	 * データベースより、ドリルスルー先となるレポートの情報（IDと名称を格納したHashMap）を取得する。
	 * @param reportID: sourceTable の絞込み条件（レポートID）
	 * @return ドリルスルー先となるレポート情報を格納したHashMap
	 * @exception SQLException 処理中に例外が発生した
	 * @exception ParserConfigurationException 処理中に例外が発生した
	 * @exception SAXException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception TransformerException 処理中に例外が発生した
	 */
	public HashMap<String, String> getDrillThrowInfo(String reportID) throws SQLException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException;



}
