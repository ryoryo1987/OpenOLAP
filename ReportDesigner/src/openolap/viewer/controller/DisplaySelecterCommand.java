/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FDisplaySelecterCommand.java
 *  �����F�Z���N�^�̃t���[���t�@�C�����N���C�A���g���ɖ߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FDisplaySelecterCommand<br>
 *  �����F�Z���N�^�̃t���[���t�@�C�����N���C�A���g���ɖ߂��N���X�ł��B
 */
public class DisplaySelecterCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	// ********** ���\�b�h **********

	/**
	 * �Z���N�^�̃t���[���t�@�C�����N���C�A���g���ɖ߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;
	
		return "/spread/SelecterFrame.jsp";
	}
}
