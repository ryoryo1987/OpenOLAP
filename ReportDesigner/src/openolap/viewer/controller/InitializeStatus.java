/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FInitializeStatus.java
 *  �����F�A�v���P�[�V�����̏��������s���N���X�ł��B
 *
 *  �쐬��: 2004/01/12
 */
package openolap.viewer.controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.MeasureMemberTypeDAO;
import openolap.viewer.MeasureMemberType;

/**
 *  �N���X�FInitializeStatus<br>
 *  �����F�A�v���P�[�V�����̏��������s���N���X�ł��B
 */
public class InitializeStatus {

	/**
	 * �A�v���P�[�V�����̏��������s���A���ʐݒ��ServletContext�֓o�^����B
	 * @param context ServletContext�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public static void initApStatus(HttpServletRequest request, ServletContext context) throws SQLException, NamingException {

		Connection conn = null;

		if ( context.getAttribute("apCommonSettings") == null ) {

			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			if (conn == null){
				conn = daoFactory.getConnection((String)request.getSession().getAttribute("connectionPoolName"),
												(String)request.getSession().getAttribute("searchPathName"));
			}

			CommonSettings commonSettings = CommonSettings.getCommonSettings();

			try {
				MeasureMemberTypeDAO measureMemberTypeDAO = daoFactory.getMeasureMemberTypeDAO(conn);
				ArrayList<MeasureMemberType> measureMemberTypeList = measureMemberTypeDAO.getMeasureMemberTypeList();

				commonSettings.addMeasureMemberTypeList(measureMemberTypeList);

				// ServletContext�֓o�^
				context.setAttribute("apCommonSettings", commonSettings);
				
			} catch (SQLException e) {
				throw e;
			} finally {
				try {
					if (conn != null) {
						conn.close();
					}
				} catch (SQLException e) {
					throw e;
				}
			}
		}
	}
}
