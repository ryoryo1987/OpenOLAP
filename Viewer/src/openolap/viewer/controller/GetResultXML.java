/*
 * �쐬��: 2004/11/25
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

		// Connection �擾
		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		try {
			RReportDAO rReportDAO = daoFactory.getRReportDAO(conn);
			StringBuffer dataXMLText = rReportDAO.getRReportXML(helper);

			// Request�֕ۑ�
			helper.getRequest().setAttribute("dataXMLText", dataXMLText);

		} catch (SQLException e) {
			helper.getRequest().setAttribute("backButtonDisableFLG", "1"); // �G���[�y�[�W�̖߂�{�^����\���t���O���Z�b�g
			throw e;
		} catch (Exception e) {
			helper.getRequest().setAttribute("backButtonDisableFLG", "1"); // �G���[�y�[�W�̖߂�{�^����\���t���O���Z�b�g
			throw e;
		} finally {
			// �R�l�N�V�����̊J��
			try {
				if(conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				throw e;
			}
		}

		// JSP�փf�B�X�p�b�`
		return "/flow/jsp/Rreport/dispResultXML.jsp";

	}
}
