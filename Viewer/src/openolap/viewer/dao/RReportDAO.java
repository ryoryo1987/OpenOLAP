/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：RReportDAO.java
 *  説明：Rレポートオブジェクトの永続化を管理するインターフェースです。
 *
 *  作成日: 2005/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.controller.RequestHelper;

/**
 *  インターフェース：ReportDAO<br>
 *  説明：Rレポートオブジェクトの永続化を管理するインターフェースです。
 */
public interface RReportDAO {

	/**
	 * RレポートオブジェクトXMLを生成する。
	 * @return Rレポート生成用のXMLを格納したStringBufferオブジェクト
	 * @exception SQLException 処理中に例外が発生した
	 */
	public StringBuffer getRReportXML(RequestHelper helper) throws SQLException;


}
