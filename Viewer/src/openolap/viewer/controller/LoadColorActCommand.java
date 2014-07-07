/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FLoadColorActCommand.java
 *  �����F�F���XML�擾����ѐF����Spread�ւ̓K�p���s���y�[�W��߂��N���X�ł��B
 *
 *  �쐬��: 2004/01/18
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FLoadColorActCommand<br>
 *  �����F�F���XML�擾����ѐF����Spread�ւ̓K�p���s���y�[�W��߂��N���X�ł��B
 */
public class LoadColorActCommand implements Command {

	/**
	 * �F���XML�擾����ѐF����Spread�ւ̓K�p���s���y�[�W��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {


		return "/spread/colorSetAct.jsp";
	}

}
