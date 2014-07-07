/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：RenewHtmlActCommand.java
 *  説明：Spreadの表示を行うページを戻すクラスです。
 *
 *  作成日: 2004/01/19
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.ColorDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.ReportDAO;

/**
 *  クラス：RenewHtmlActCommand<br>
 *  説明：Spreadの表示を行うページを戻すクラスです。
 */
public class RenewHtmlActCommand implements Command {

	// ********** インスタンス変数 **********

	/** 色情報、軸配置情報登録モードをあらわす文字列 */
	private final String registColorSettingsMode = "registColorSetings";

	/** 色情報のみ登録するモードをあらわす文字列 */
	private final String registColorOnly = "registColorOnly";

	/**
	 * Spreadの表示を行うページを戻す。<br>
	 * XSLファイルを読み込み、クライアント側で持つXMLに適用してSpreadのHTMLを書き出させるページを戻す。<br>
	 * ダイスによる再表示時には、軸の配置情報更新、色設定情報更新を事前に行う。<br>
	 * レポート新規表示時、セレクタ適用後の新規再表示、ダイスによる再表示時に実行される。<br>
	 * ダイスによる再表示時には"mode"パラメーターが"registColorSetings"の値をとる。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		String mode = (String)helper.getRequest().getParameter("mode");
		if( registColorSettingsMode.equals(mode) ) {

			// 軸の配置情報を更新
			ReportDAO reportDAO = DAOFactory.getDAOFactory().getReportDAO(null);
			reportDAO.registAxisPosition(helper, commonSettings);

			// 色設定情報を更新
			ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);

		}

		if ( registColorOnly.equals(mode)){

			// 色設定情報を更新
			// （現在未使用なmode）
			ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);
		}

		// 色設定タイプ（1：塗りつぶし、2：ハイライト）を登録する
		String newColorType = helper.getRequest().getParameter("newColorType");
		if ((newColorType != null) && (newColorType != "") ) {
			Report report = (Report) helper.getRequest().getSession().getAttribute("report");
			report.setColorType(newColorType);
		}

		return "/spread/spread.jsp";
	}

}
