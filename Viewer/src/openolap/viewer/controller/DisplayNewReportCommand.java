/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FDisplayNewReportCommand.java
 *  �����F���|�[�g�̃t���[���t�@�C�����N���C�A���g���ɖ߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/05
 */

package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 * �N���X�FDisplayNewReportCommand<br>
 * �����F���|�[�g�̃t���[���t�@�C�����N���C�A���g���ɖ߂��N���X�ł��B
 */
public class DisplayNewReportCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * ���|�[�g�̃t���[���t�@�C�����N���C�A���g���ɖ߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;
		
		return "/spread/spread_frm.jsp";
	}
}
