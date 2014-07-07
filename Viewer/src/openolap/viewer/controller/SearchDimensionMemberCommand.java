/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FSearchDimensionMemberCommand.java
 *  �����F�f�B�����V���������o�[��^����ꂽ�����Ō�������N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;

import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.AxisMember;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;


/**
 *  �N���X�FSearchDimensionMemberCommand<br>
 *  �����F�f�B�����V���������o�[��^����ꂽ�����Ō�������N���X�ł��B
 */
public class SearchDimensionMemberCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * ���L�����Ń����o�[��������<br>
	 *   �|"dimNumber" �p�����[�^�Ŏw�肳�ꂽ��<br>
	 *   �|"listMemberName" �����o�[�̖��́i���C���h�J�[�h�F*�A_�j<br>
	 *   �|"listLevel" �����o�[�̃��x��<br>
	 * �������ʂŃZ���N�^�{�f�B�[������������y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, Exception {

			this.requestHelper = helper;

			Report report = (Report) this.requestHelper.getRequest().getSession().getAttribute("report");

			String AxisID = this.requestHelper.getRequest().getParameter("dimNumber");
			if(AxisID.equals(Constants.MeasureID)){	// ���������o�̌����Ȃ̂ŁA���W���[�ł��邱�Ƃ͂��肦�Ȃ�
				throw new IllegalStateException();
			}

			Dimension dim = (Dimension) report.getAxisByID(AxisID);

			Connection conn = null;
			DAOFactory daoFactory = DAOFactory.getDAOFactory();
			conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											(String)helper.getRequest().getSession().getAttribute("searchPathName"));

			DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);

			String searchMemName = this.requestHelper.getRequest().getParameter("listMemberName");
			String searchLevel   = this.requestHelper.getRequest().getParameter("listLevel");

			String shortNameCondition = null;
			String longNameCondition = null;

			if(dim.getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				shortNameCondition = searchMemName;
			} else if(dim.getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				longNameCondition = searchMemName;
			} else {
				throw new IllegalStateException();
			}
			
			try {
				ArrayList<AxisMember> dimMemberList;
				dimMemberList =	dimMemberDAO.selectDimensionMembers(
								dim,
								shortNameCondition,
								longNameCondition,
								searchLevel,
								null);
				dim.setAxisMemberList(dimMemberList);

			} catch (SQLException e) {
				throw e;
			} catch (Exception e) {
				throw e;
			} finally {
				if(conn != null){
					try {
						conn.close();
					} catch (SQLException e) {
						throw e;
					}
				}
			}

			return "/spread/SelecterSearch.jsp";

	}
}
