/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetReportHeaderCommand.java
 *  �����F���|�[�g�I�u�W�F�N�g���쐬��Session�ɕۑ����A���|�[�g�w�b�_�[�t���[�����\���y�[�W��dispatch����N���X�ł��B
 *
 *  �쐬��: 2004/02/15
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
 *  �N���X�FGetReportHeaderCommand<br>
 *  �����F���|�[�g�I�u�W�F�N�g���쐬��Session�ɕۑ����A���|�[�g�w�b�_�[�t���[�����\���y�[�W��dispatch����N���X�ł��B
 */
public class GetReportHeaderCommand implements Command {

	/**
	 * ���|�[�g�I�u�W�F�N�g���쐬��Session�ɕۑ����A���|�[�g�w�b�_�[�t���[�����\���y�[�W��dispatch���܂��B<br>
	 * "cubeSeq"�p�����[�^���^����ꂽ�ꍇ�A�L���[�u�����ƂɐV�K�Ƀ��|�[�g�I�u�W�F�N�g���쐬���܂��B<br>
	 * "seqId"�p�����[�^���^����ꂽ�ꍇ�A�����̃��|�[�g�������ƂɃ��|�[�g�I�u�W�F�N�g���쐬���܂��B<br>
	 * �p�����[�^���^�����Ă��Ȃ����ASession�Ɋ���report�I�u�W�F�N�g�����݂���ꍇ�A�����s���܂���B<br>
	 * �p�����[�^���^�����Ă��Ȃ��ASession��report�I�u�W�F�N�g�����݂��Ȃ��ꍇ�AIllegalStateException��throw����B<br>
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
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
				// Report���Z�b�V�����֓o�^
				ReportDAO reportDAO = daoFactory.getReportDAO(conn);
				if(request.getParameter("cubeSeq") != null) { // �L���[�u�ɑ΂���\���v��

					// �V�K���|�[�g�쐬�iCube�Q�Ɓj���́A�{���\�E�G�N�X�|�[�g�\�ȃZ�L�����e�B�I�u�W�F�N�g���쐬���A�Z�b�V�����ɕۑ�����B
					Security security = new Security(Boolean.TRUE.booleanValue(),Boolean.TRUE.booleanValue());
					session.setAttribute("security", security);

					// Report���Z�b�V�����֓o�^
					report = reportDAO.getInitialReport(cubeSeq, user.getUserID(), commonSettings);
					session.setAttribute("report",report);

				} else if (request.getParameter("seqId") !=null) { // ���|�[�g�ɑ΂���\���v��

					// ���|�[�g�̃Z�L�����e�B�����Z�b�V�����ɕۑ�
					SecurityDAO securityDAO = daoFactory.getSecurityDAO(conn);
					Security security = securityDAO.getSecurity(user.getUserID(),reportId);

					session.setAttribute("security", security);
					if(security.isReportViewable()) { // ���|�[�g�̉{������������Ƃ��̂݁A���|�[�g�I�u�W�F�N�g�𐶐�
						report = reportDAO.getExistingReport(reportId, helper, commonSettings);

						// �L���[�u�����݂��Ȃ�
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
