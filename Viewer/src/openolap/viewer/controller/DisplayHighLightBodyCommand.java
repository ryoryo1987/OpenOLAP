/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FDisplayHighLightBodyCommand.java
 *  �����F�n�C���C�g�{�f�B�[�\���y�[�W��dispatch���܂��B
 *
 *  �쐬��: 2004/07/29
 */
package openolap.viewer.controller;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FDisplayHighLightBodyCommand
 *  �����F�n�C���C�g�{�f�B�[���\���y�[�W��dispatch���܂��B
 */
public class DisplayHighLightBodyCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * �n�C���C�g�{�f�B�[���\���y�[�W��dispatch����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings) {

			return "/spread/HighLightBody.jsp";
	}
}
