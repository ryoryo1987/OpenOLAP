/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetCannotDispReportMSGCommand.java
 *  �����F���|�[�g�̕\�������������|�̃��b�Z�[�W��\�����鏈�����s�Ȃ��N���X�ł��B
 *
 *  �쐬��: 2004/09/16
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FGetCannotDispReportMSGCommand<br>
 *  �����F���|�[�g�̕\�������������|�̃��b�Z�[�W��\�����鏈�����s�Ȃ��N���X�ł��B
 */
public class GetCannotDispReportMSGCommand implements Command {

	/**
	 * ���|�[�g�̕\�������������|�̃��b�Z�[�W��Request�ɓo�^���Amessage.jsp�փf�B�X�p�b�`����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		helper.getRequest().setAttribute("message", "���|�[�g�̕\������������܂���B");

		return "/spread/message.jsp";
	}

}
