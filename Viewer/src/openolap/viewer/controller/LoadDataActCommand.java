/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FLoadDataActCommand.java
 *  �����F�l���XML�擾����ђl����Spread�ւ̑}�����s���y�[�W��߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/20
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.AxisDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FLoadDataActCommand<br>
 *  �����F�l���XML�擾����ђl����Spread�ւ̑}�����s���y�[�W��߂��N���X�ł��B
 */
public class LoadDataActCommand implements Command {

	/**
	 * ���̃f�t�H���g�����o���̍X�V���s������A�l���XML�擾����ђl����Spread�ւ̓K�p���s���y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// ���̃f�t�H���g�����o�����X�V
		AxisDAO axisDAO = DAOFactory.getDAOFactory().getAxisDAO(null);
		axisDAO.registDefaultMember(helper, commonSettings);

		// �Z���f�[�^�擾������Session�Ɉꎞ�ۑ�
		CellDataManager.saveRequestParamsToSession(helper);

		return "/spread/dataSetAct.jsp";
	}


}
