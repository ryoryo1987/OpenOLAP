/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FDisplaySelecterBodyCommand.java
 *  �����F�w�肳�ꂽ���I�u�W�F�N�g�Ɏ������o�[���Z�b�g���A�Z���N�^�{�f�B�[�t���[�����\���y�[�W��dispatch����N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.AxisMember;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;

/**
 *  �N���X�FDisplaySelecterBodyCommand<br>
 *  �����F�w�肳�ꂽ���I�u�W�F�N�g�Ɏ������o�[���Z�b�g���A�Z���N�^�{�f�B�[�t���[�����\���y�[�W��dispatch����N���X�ł��B
 */
public class DisplaySelecterBodyCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * "dimNumber"�p�����[�^�[�ŗ^����ꂽ��ID���f�B�����V�����̏ꍇ�A<br>
	 * ���I�u�W�F�N�g�Ɏ������o�[���Z�b�g���A�Z���N�^�{�f�B�[�t���[�����\���y�[�W��dispatch����B<br>
	 * ���W���[�̏ꍇ�́A���������ɃZ���N�^�{�f�B�[���\���y�[�W��dispatch����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

			this.requestHelper = helper;
			Report report = (Report) this.requestHelper.getRequest().getSession().getAttribute("report");

			// �����f�B�����V�����̏ꍇ�A�����o�[���擾�i���W���[�̏ꍇ��Report�I�u�W�F�N�g�������Ɏ擾�ς݁j
			String AxisID = this.requestHelper.getRequest().getParameter("dimNumber");
			if(!AxisID.equals(Constants.MeasureID)) {
				Dimension dim = (Dimension) report.getAxisByID(AxisID);
	
				Connection conn = null;
				DAOFactory daoFactory = DAOFactory.getDAOFactory();
				conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
												(String)helper.getRequest().getSession().getAttribute("searchPathName"));
	
				try {
					DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);
					ArrayList<AxisMember> dimMemberList = dimMemberDAO.selectDimensionMembers(dim,		// �����o���擾����f�B�����V����
																				  null,	// short_name�ɂ��i���ݏ���
																				  null,	// long_name�ɂ��i���ݏ���
																				  null, 	// ���x���ɂ��i������
																				  null);	// �����ΏۃL�[���X�g
					dim.setAxisMemberList(dimMemberList);
				} catch (SQLException e) {
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
			}
			return "/spread/SelecterBody.jsp";
	}
}
