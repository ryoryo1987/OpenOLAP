/*
 * 作成日: 2004/11/25
 *
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.RReportDAO;

/**
 */
public class GetResultXML implements Command {


	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

		// Connection 取得
		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		try {
			RReportDAO rReportDAO = daoFactory.getRReportDAO(conn);
			StringBuffer dataXMLText = rReportDAO.getRReportXML(helper);

			// Requestへ保存
			helper.getRequest().setAttribute("dataXMLText", dataXMLText);

		} catch (SQLException e) {
			helper.getRequest().setAttribute("backButtonDisableFLG", "1"); // エラーページの戻るボタン非表示フラグをセット
			throw e;
		} catch (Exception e) {
			helper.getRequest().setAttribute("backButtonDisableFLG", "1"); // エラーページの戻るボタン非表示フラグをセット
			throw e;
		} finally {
			// コネクションの開放
			try {
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}

		// JSPへディスパッチ
		return "/flow/jsp/Rreport/dispResultXML.jsp";

	}
}
