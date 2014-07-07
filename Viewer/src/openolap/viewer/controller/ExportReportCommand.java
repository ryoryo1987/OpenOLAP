/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：ExportReportCommand.java
 *  説明：レポートのエクスポート処理を行うクラスです。
 *
 *  作成日: 2004/01/31
 */
package openolap.viewer.controller;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import openolap.viewer.User;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.export.ExportReport;
import openolap.viewer.export.ExportReportFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  クラス：ExportReportCommand<br>
 *  説明：レポートのエクスポート処理を行うクラスです。
 */
public class ExportReportCommand implements Command {

	// ********** メソッド **********

	/**
	 * エクスポート処理を行う。<br>
	 * エクスポートタイプはこのセッションにセットされているユーザオブジェクトのエクスポートファイルタイプで指定されている形式に従う。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, FileNotFoundException, UnsupportedEncodingException, SQLException, NamingException, IOException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException {

		// ディメンションメンバ、セルデータ取得条件をSessionに一時保存
		// （セルデータ取得処理をレポートの値取得処理と共通化するため）
		CellDataManager.saveRequestParamsToSession(helper);

		User user = (User) helper.getRequest().getSession().getAttribute("user");

		// エクスポート処理実行
		ExportReportFactory exportReportFactory = new ExportReportFactory();
		ExportReport exportReport = exportReportFactory.getExportReport(user);
		String page = exportReport.exportReport(helper);

		return page;
	}

}
