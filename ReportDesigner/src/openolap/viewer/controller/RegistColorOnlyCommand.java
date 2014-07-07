/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FRegistColorOnlyCommand.java
 *  �����F�F���̃Z�b�V�����ւ̒ǉ��������s���N���X�ł��B
 *
 *  �쐬��: 2004/09/17
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.dao.ColorDAO;
import openolap.viewer.dao.DAOFactory;

/**
 *  �N���X�FRegistColorOnlyCommand<br>
 *  �����F�F���̃Z�b�V�����ւ̒ǉ��������s���N���X�ł��B
 */
public class RegistColorOnlyCommand implements Command {

	// ********** ���\�b�h **********
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		// �F�ݒ�����X�V
		String mode = (String)helper.getRequest().getParameter("mode");
		ColorDAO colorDAO = DAOFactory.getDAOFactory().getColorDAO(null);
		colorDAO.registColor(helper, commonSettings);

		return "/spread/blank.html";
	}

}
