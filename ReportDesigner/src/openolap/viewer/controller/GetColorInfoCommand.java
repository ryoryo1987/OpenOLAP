/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetColorInfoCommand.java
 *  �����F�F����XML�ŏo�͂���y�[�W��dispatch����N���X�ł��B
 *
 *  �쐬��: 2004/01/18
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FGetColorInfoCommand<br>
 *  �����F�F����XML�ŏo�͂���y�[�W��dispatch����N���X�ł��B
 */
public class GetColorInfoCommand implements Command {

	/**
	 * �F��������킷XML���o�͂���B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		return "/spread/colorInfo.jsp";
	}

}
