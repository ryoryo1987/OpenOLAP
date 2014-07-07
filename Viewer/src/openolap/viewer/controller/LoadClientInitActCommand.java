/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FLoadClientInitActCommand.java
 *  �����F���|�[�g���XML�擾����уw�b�_�[���̏��������s���y�[�W��߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FLoadClientInitActCommand<br>
 *  �����F���|�[�g���XML�擾����уw�b�_�[���̏��������s���y�[�W��߂��N���X�ł��B
 */
public class LoadClientInitActCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** RequestHelper�I�u�W�F�N�g */
	private RequestHelper requestHelper = null;

	/**
	 * �Z���N�^�w�b�_�[���Ƀ��[�h����A���|�[�g���XML�擾����уw�b�_�[���̏��������s���y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

			this.requestHelper = helper;


			return "/spread/spreadInfo.jsp";
	}
}
