/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FInvalidateSessionCommand.java
 *  �����F�Z�b�V�����������ł���|������킷���b�Z�[�W��\������N���X�ł��B
 *
 *  �쐬��: 2004/02/13
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
//import openolap.viewer.common.Messages;

/**
 *  �N���X�FInvalidateSessionCommand<br>
 *  �����F�Z�b�V�����������ł���|������킷���b�Z�[�W��\������N���X�ł��B
 */
public class InvalidateSessionCommand implements Command {

	/**
	 * �Z�b�V�����������ł���|������킷���b�Z�[�W���擾�E�ݒ肵�A
	 * ���b�Z�[�W�\���p�y�[�W��dispatch����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

//		String message = Messages.getString("InvalidateSessionCommand.invalidateSessionMessage"); //$NON-NLS-1$
//		helper.getRequest().setAttribute("message", message);


		String nextPage = "/spread/redirectTo.jsp";
		helper.getRequest().setAttribute("redirectTo", "/login.jsp");
		helper.getRequest().setAttribute("targetFrame", "TOP");
		
		return nextPage;
	}

}
