/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FSaveClientReportStatusCommand.java
 *  �����F���|�[�g���f�[�^�x�[�X�ɕۑ�����N���X�ł��B
 *
 *  �쐬��: 2004/01/14
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
 *  �N���X�FSaveClientReportStatusCommand<br>
 *  �����F���|�[�g���f�[�^�x�[�X�ɕۑ�����N���X�ł��B
 */
public class SaveClientReportStatusCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	/**
	 * �N���C�A���g����擾�������L�������ƂɃT�[�o�[���̃��f�����X�V��A���|�[�g�̕ۑ��������s���B<br>
	 *    �|�F�ݒ���
	 *    �|�������o�̃h������
	 *    �|���|�[�g���i���|�[�g���A�e�t�H���_�[ID�j
	 * ���|�[�g�ۑ������͑S�Ă̏��������������ꍇ��commit�������Ȃ��A���s��������������ꍇ��rollback����B
	 * �L���[�u����쐬���̃��|�[�g�ł���΁ADB�ւ̕ۑ������I����ɐV�K���|�[�g������킷�t���OisNewReport��false�ɕύX����B
	 * ���|�[�g�̕ۑ��������Ӗ����A�������b�Z�[�W��alert�ŕ\������y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception Exception �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

		String reportName = (String)helper.getRequest().getParameter("reportName");
		String folderID = (String)helper.getRequest().getParameter("folderID");

		// ���|�[�g��ۑ��ꏊ�w��t���ŕۑ�
		if ( (!reportName.equals("")) && (!folderID.equals("")) ) {
			helper.getRequest().setAttribute("mode", "saveNewReport");
		}

		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();
		conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
										(String)helper.getRequest().getSession().getAttribute("searchPathName"));

		// =========================================
		// Server���ŕێ����Ă��郌�|�[�g���f�����X�V
		// =========================================

		// �F�ݒ�����X�V
		ColorDAO colorDAO = daoFactory.getColorDAO(null);
		colorDAO.registColor(helper, commonSettings);

		// �������o�̃h������
		AxisDAO axisDAO = daoFactory.getAxisDAO(null);
		axisDAO.registSelectedMemberAndDrillStat(helper, commonSettings);

		// ���|�[�g���i���|�[�g���A�e�t�H���_�[ID�j���X�V
		ReportDAO reportDAO = daoFactory.getReportDAO(null);
		reportDAO.registReport(helper, commonSettings);

		// =========================================
		// ���|�[�g�ݒ���i����
		// =========================================
		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		User user = (User) helper.getRequest().getSession().getAttribute("user");
		try {
			conn.setAutoCommit(false);

			if (user.isAdmin()){
				report.saveReport(conn);
			} else {
				if (user.isPersonalReportSavable()) {

					// �Ǘ��҃��[�U�łȂ��A�l���|�[�g�ۑ��\�ȃ��[�U�[�ł���A
					// ���A���݂̃��|�[�g����{���|�[�g�ł���ꍇ�A
					// ��{���|�[�g�����ƂɐV�K�l���|�[�g���쐬����B
					if (report.getReportOwnerFLG().equals(Report.basicReportOwnerFLG)) { 
						String newPersonalReportname = report.getReportName() + Report.personalReportNameSuffix;
						report.saveNewPersonalReport(newPersonalReportname, user.getUserID(), conn);

						// �V�K�l���|�[�g�쐬�̏ꍇ�A�쐬�����ō����̃c���[���X�V�����邽�߁A�t���O�𗧂ĂĂ���
						helper.getRequest().setAttribute("isCreatingNewPersonalReport", Boolean.TRUE);

					} else { // ���݂̃��|�[�g���l���|�[�g�ł���ꍇ�A�����̌l���|�[�g���X�V����B
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
		// �I������
		// =========================================
		if(report.isNewReport()) {
			report.setNewReport(false);
		}

		return "/spread/saveFinalize.jsp";
	}

}
