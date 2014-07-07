/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：SaveClientReportStatusCommand.java
 *  説明：レポートをデータベースに保存するクラスです。
 *
 *  作成日: 2004/01/14
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;

import openolap.viewer.Report;
import openolap.viewer.User;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.AxisDAO;
import openolap.viewer.dao.ColorDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.ReportDAO;

/**
 *  クラス：SaveClientReportStatusCommand<br>
 *  説明：レポートをデータベースに保存するクラスです。
 */
public class SaveClientReportStatusCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	/**
	 * クライアントから取得した下記情報をもとにサーバー側のモデルを更新後、レポートの保存処理を行う。<br>
	 *    －色設定情報
	 *    －軸メンバのドリル状況
	 *    －レポート情報（レポート名、親フォルダーID）
	 * レポート保存処理は全ての処理が完了した場合にcommitをおこない、失敗した処理がある場合はrollbackする。
	 * キューブから作成中のレポートであれば、DBへの保存処理終了後に新規レポートをあらわすフラグisNewReportをfalseに変更する。
	 * レポートの保存完了を意味し、完了メッセージをalertで表示するページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception Exception 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

		String reportName = (String)helper.getRequest().getParameter("reportName");
		String folderID = (String)helper.getRequest().getParameter("folderID");

		// レポートを保存場所指定付きで保存
		if ( (!reportName.equals("")) && (!folderID.equals("")) ) {
			helper.getRequest().setAttribute("mode", "saveNewReport");
		}

		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		// =========================================
		// Server側で保持しているレポートモデルを更新
		// =========================================

		// 色設定情報を更新
		ColorDAO colorDAO = daoFactory.getColorDAO(null);
		colorDAO.registColor(helper, commonSettings);

		// 軸メンバのドリル状況
		AxisDAO axisDAO = daoFactory.getAxisDAO(null);
		axisDAO.registSelectedMemberAndDrillStat(helper, commonSettings);

		// レポート情報（レポート名、親フォルダーID）を更新
		ReportDAO reportDAO = daoFactory.getReportDAO(null);
		reportDAO.registReport(helper, commonSettings);

		// =========================================
		// レポート設定を永続化
		// =========================================
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		User user = (User) helper.getRequest().getSession().getAttribute("user");
		try {
			conn.setAutoCommit(false);

			if (user.isAdmin()){
				report.saveReport(conn);
			} else {
				if (user.isPersonalReportSavable()) {

					// 管理者ユーザでなく、個人レポート保存可能なユーザーであり、
					// かつ、現在のレポートが基本レポートである場合、
					// 基本レポートをもとに新規個人レポートを作成する。
					if (report.getReportOwnerFLG().equals(Report.basicReportOwnerFLG)) { 
						String newPersonalReportname = report.getReportName() + Report.personalReportNameSuffix;
						report.saveNewPersonalReport(newPersonalReportname, user.getUserID(), conn);

						// 新規個人レポート作成の場合、作成完了で左側のツリーを更新させるため、フラグを立てておく
						helper.getRequest().setAttribute("isCreatingNewPersonalReport", Boolean.TRUE);

					} else { // 現在のレポートが個人レポートである場合、既存の個人レポートを更新する。
						report.saveReport(conn);
					}
					
					
				}
				
			}

			conn.commit();
		} catch (SQLException e) {
			try {
				if (conn != null){
					conn.rollback();
				}
				throw e;
			} catch (SQLException e1) {
				throw e1;
			}
		} catch (Exception e) {
			try {
				if (conn != null){
					conn.rollback();
				}
				throw e;
			} catch (SQLException e1) {
				throw e1;
			}
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}

			} catch (SQLException e1) {
				throw e1;
			}
		}

		// =========================================
		// 終了処理
		// =========================================
		if(report.isNewReport()) {
			report.setNewReport(false);
		}

		return "/spread/saveFinalize.jsp";
	}

}
