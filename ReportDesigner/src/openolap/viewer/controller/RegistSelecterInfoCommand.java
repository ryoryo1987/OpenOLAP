/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FRegistSelecterInfoCommand.java
 *  �����F�Z���N�^�ōs��ꂽ�ݒ��o�^����N���X�ł��B
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
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Axis;
import openolap.viewer.Dimension;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.common.StringUtil;
import openolap.viewer.dao.*;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionDAO;
import openolap.viewer.dao.MeasureMemberDAO;

/**
 *  �N���X�FRegistSelecterInfoCommand<br>
 *  �����F�Z���N�^�ōs��ꂽ�ݒ��o�^����N���X�ł��B
 */
public class RegistSelecterInfoCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * ���L�A�Z���N�^���̓o�^�������s���B<br>
	 *   �|�������o�̃Z���N�^�ɂ��i���ݏ��A�h������<br>
	 *   �|���̍i����/�h�������<br>
	 *   �|�����Z���N�^�ɂ�胁���o�[���i�荞�܂�Ă��邩������킷�t���O<br>
	 *   �|�f�B�����V�����̃����o�[���̕\���^�C�v<br>
	 *   �|���W���[�����o�[�̃��W���[�����o�[�^�C�v<br>
	 *   �|�F�ݒ���<br>
	 * �ݒ�̓o�^�������Ӗ����ASpread�̍ĕ\�����s���y�[�W��߂��B
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

			DAOFactory daoFactory = DAOFactory.getDAOFactory();

			// ���̃����o�̃Z���N�^�ɂ��i���ݏ��A�h�����󋵂��X�V
			AxisDAO axisDAO = daoFactory.getAxisDAO(null);
			axisDAO.registSelectedMemberAndDrillStat(helper, commonSettings);

			// �����Z���N�^�ɂ�胁���o�[���i�荞�܂�Ă��邩������킷�t���O���X�V
			this.modifyAxisUsedSelecterCondition(helper);

			// �f�B�����V�����̃����o���̕\���^�C�v���X�V
			DimensionDAO dimensionDAO = daoFactory.getDimensionDAO(null);
			dimensionDAO.registDimensionMemberDispType(helper, commonSettings);

			// ���W���[�����o�[�̃��W���[�����o�[�^�C�v�ݒ���X�V
			MeasureMemberDAO measureMemberDAO = daoFactory.getMeasureMemberDAO(null);
			measureMemberDAO.registMeasureMemberType(helper, commonSettings);

			// �F�ݒ�����X�V
			ColorDAO colorDAO = daoFactory.getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);

			return "/spread/SelecterFinalize.html";
	}

	// ********** private���\�b�h **********

	/**
	 * �����Z���N�^�ɂ�胁���o�[���i�荞�܂�Ă��邩������킷�t���O���X�V����B<br>
	 * �����{�����������o�[���ƃN���C�A���g����I�����ꂽ�����o�Ƃ��ēn���ꂽ�����o�[�̑�������������΍i�荞�܂�Ă��Ȃ��A��҂����Ȃ��Ȃ�΍i���Ă��邱�ƂɂȂ�B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	private void modifyAxisUsedSelecterCondition(RequestHelper helper) throws SQLException, NamingException  {

		HttpServletRequest request = helper.getRequest();
		Report report = (Report)helper.getRequest().getSession().getAttribute("report");		

		String axisID = null;
		for (int i = 0; i < report.getTotalDimensionNumber()+1; i++ ) {	// �f�B�����V�����{�P(���W���[)����s

			if (i == report.getTotalDimensionNumber()) {	// ���W���[
				axisID = Constants.MeasureID;
			} else {										// �f�B�����V����
				axisID = Integer.toString(i+1);				// ��ID��1start�̂��߁A�␳�B
			}

			String selectedMemberAndDrillStat = (String)request.getParameter("dim" + axisID);	// �N���C�A���g����̑��M����Ă����p�����[�^���擾
			ArrayList<String> selectedMemberAndDrillStatList = StringUtil.splitString(selectedMemberAndDrillStat,",");
			Axis axis = report.getAxisByID(axisID);

			// �������o�̑������o�������߂�
			int memberCount = 0;
			if (axisID == Constants.MeasureID) {
				memberCount = report.getTotalMeasureMemberNumber();
			} else {
				Connection conn = DAOFactory.getDAOFactory().getConnection((String)request.getSession().getAttribute("connectionPoolName"),
																		   (String)helper.getRequest().getSession().getAttribute("searchPathName"));
				try {
					memberCount = DAOFactory.getDAOFactory().getDimensionMemberDAO(conn).getDimensionMemberNumber((Dimension)axis);
				} catch (SQLException e) {
					throw e;
				} finally {
					if (conn != null) {
						try {
							conn.close();
						} catch (SQLException e) {
							throw e;
						}
					}
				}
			}

			if (memberCount > selectedMemberAndDrillStatList.size()) {
				axis.setUsedSelecter(true);				// ���ɑ΂��ăZ���N�^�ōi����/�h������Ԃ̍X�V���s��ꂽ
			} else if (memberCount == selectedMemberAndDrillStatList.size()) {
				axis.setUsedSelecter(false);
			} else {
				throw new IllegalStateException();
			}
		}
	}
}
