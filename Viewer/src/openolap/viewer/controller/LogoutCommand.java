/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FLogoutCommand.java
 *  �����F���O�A�E�g�������s���N���X�ł��B
 *
 *  �쐬��: 2004/01/26
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Messages;

/**
 *  �N���X�FLogoutCommand<br>
 *  �����F���O�A�E�g�������s���N���X�ł��B
 */
public class LogoutCommand implements Command {

	/**
	 * ���O�A�E�g�������s���B<br>
	 * Session�I�u�W�F�N�g�����������A���O�A�E�g���b�Z�[�W���擾�E�ݒ肵�ă��b�Z�[�W�y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// session �̏�����
		helper.getRequest().getSession().invalidate(); 

		String message = Messages.getString("LogoutCommand.logoutMessage"); //$NON-NLS-1$
		helper.getRequest().setAttribute("message", message);

		return "/spread/message.jsp";
	}

}
