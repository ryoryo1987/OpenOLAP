/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FRenewHtmlActCommand.java
 *  �����FSpread�̕\�����s���y�[�W��߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/19
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.ColorDAO;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.ReportDAO;

/**
 *  �N���X�FRenewHtmlActCommand<br>
 *  �����FSpread�̕\�����s���y�[�W��߂��N���X�ł��B
 */
public class RenewHtmlActCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** �F���A���z�u���o�^���[�h������킷������ */
	private final String registColorSettingsMode = "registColorSetings";

	/** �F���̂ݓo�^���郂�[�h������킷������ */
	private final String registColorOnly = "registColorOnly";

	/**
	 * Spread�̕\�����s���y�[�W��߂��B<br>
	 * XSL�t�@�C����ǂݍ��݁A�N���C�A���g���Ŏ���XML�ɓK�p����Spread��HTML�������o������y�[�W��߂��B<br>
	 * �_�C�X�ɂ��ĕ\�����ɂ́A���̔z�u���X�V�A�F�ݒ���X�V�����O�ɍs���B<br>
	 * ���|�[�g�V�K�\�����A�Z���N�^�K�p��̐V�K�ĕ\���A�_�C�X�ɂ��ĕ\�����Ɏ��s�����B<br>
	 * �_�C�X�ɂ��ĕ\�����ɂ�"mode"�p�����[�^�[��"registColorSetings"�̒l���Ƃ�B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		String mode = (String)helper.getRequest().getParameter("mode");
		if( registColorSettingsMode.equals(mode) ) {

			// ���̔z�u�����X�V
			ReportDAO reportDAO = DAOFactory.getDAOFactory().getReportDAO(null);
			reportDAO.registAxisPosition(helper, commonSettings);

			// �F�ݒ�����X�V
			ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);

		}

		if ( registColorOnly.equals(mode)){

			// �F�ݒ�����X�V
			// �i���ݖ��g�p��mode�j
			ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
			colorDAO.registColor(helper, commonSettings);
		}

		// �F�ݒ�^�C�v�i1�F�h��Ԃ��A2�F�n�C���C�g�j��o�^����
		String newColorType = helper.getRequest().getParameter("newColorType");
		if ((newColorType != null) && (newColorType != "") ) {
			Report report = (Report) helper.getRequest().getSession().getAttribute("report");
			report.setColorType(newColorType);
		}

		return "/spread/spread.jsp";
	}

}
