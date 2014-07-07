/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：GetReportHeaderCommand.java
 *  説明：レポートオブジェクトを作成しSessionに保存し、レポートヘッダーフレーム部表示ページへdispatchするクラスです。
 *
 *  作成日: 2004/02/15
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import openolap.viewer.Report;
import openolap.viewer.Security;
import openolap.viewer.User;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Messages;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.ReportDAO;
import openolap.viewer.dao.SecurityDAO;

/**
 *  クラス：GetReportHeaderCommand<br>
 *  説明：レポートオブジェクトを作成しSessionに保存し、レポートヘッダーフレーム部表示ページへdispatchするクラスです。
 */
public class GetReportHeaderCommand implements Command {

	/**
	 * レポートオブジェクトを作成しSessionに保存し、レポートヘッダーフレーム部表示ページへdispatchします。<br>
	 * "cubeSeq"パラメータが与えられた場合、キューブをもとに新規にレポートオブジェクトを作成します。<br>
	 * "seqId"パラメータが与えられた場合、既存のレポート情報をもとにレポートオブジェクトを作成します。<br>
	 * パラメータが与えられていないが、Sessionに既にreportオブジェクトが存在する場合、何も行いません。<br>
	 * パラメータが与えられていなく、Sessionにreportオブジェクトも存在しない場合、IllegalStateExceptionをthrowする。<br>
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 * @exception NamingException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

			HttpServletRequest request = helper.getRequest();
			HttpSession session = helper.getRequest().getSession();

			String cubeSeq = request.getParameter("cubeSeq");
			String reportId = request.getParameter("seqId");

			if((cubeSeq == null) && (reportId == null) && (session.getAttribute("report") == null) ) { throw new IllegalStateException(); }
			if((cubeSeq != null) && (reportId != null)) { throw new IllegalStateException(); }

			Connection conn = null;
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											(String)helper.getRequest().getSession().getAttribute("searchPathName"));

			Report report = null;
			User user = (User)session.getAttribute("user");
			
			
			try {
				// Reportをセッションへ登録
				ReportDAO reportDAO = daoFactory.getReportDAO(conn);
				if(request.getParameter("cubeSeq") != null) { // キューブに対する表示要求

					// 新規レポート作成（Cube参照）時は、閲覧可能・エクスポート可能なセキュリティオブジェクトを作成し、セッションに保存する。
					Security security = new Security(Boolean.TRUE.booleanValue(),Boolean.TRUE.booleanValue());
					session.setAttribute("security", security);

					// Reportをセッションへ登録
					report = reportDAO.getInitialReport(cubeSeq, user.getUserID(), commonSettings);
					session.setAttribute("report",report);

				} else if (request.getParameter("seqId") !=null) { // レポートに対する表示要求

					// レポートのセキュリティ情報をセッションに保存
					SecurityDAO securityDAO = daoFactory.getSecurityDAO(conn);
					Security security = securityDAO.getSecurity(user.getUserID(),reportId);

					session.setAttribute("security", security);
					if(security.isReportViewable()) { // レポートの閲覧権限があるときのみ、レポートオブジェクトを生成
						report = reportDAO.getExistingReport(reportId, helper, commonSettings);

						// キューブが存在しない
						if(report == null) {
							String errorMessage = Messages.getString("GetReportHeaderCommand.cubeNotExistMSG"); //$NON-NLS-1$
							helper.getRequest().setAttribute("errorMessage", errorMessage);
						}

						session.setAttribute("report",report);

					}

				} else {
					if (session.getAttribute("report") != null) {
						report = (Report) session.getAttribute("report");
					} else {
						throw new IllegalStateException();
					}
				}
			} catch (SQLException e) {
				throw e;
			}  finally {
				if(conn != null){
					try {
						conn.close();
					} catch (SQLException e) {
						throw e;
					}
				}
			}

		return "/spread/spreadHeader.jsp";
	}

}
