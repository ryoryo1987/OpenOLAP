/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FDisplayHighLightHeaderCommand.java
 *  �����F�n�C���C�g�w�b�_�[�t���[�����\���y�[�W��dispatch���܂��B
 *
 *  �쐬��: 2004/07/27
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FDisplayHighLightHeaderCommand
 *  �����F�n�C���C�g�w�b�_�[�t���[�����\���y�[�W��dispatch���܂��B
 */
public class DisplayHighLightHeaderCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * �n�C���C�g�w�b�_�[�t���[�����\���y�[�W��dispatch����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;

		return "/spread/HighLightHeader.jsp";
	}
}
