/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FExportReportCommand.java
 *  �����F���|�[�g�̃G�N�X�|�[�g�������s���N���X�ł��B
 *
 *  �쐬��: 2004/01/31
 */
package openolap.viewer.controller;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.xml.sax.SAXException;

import openolap.viewer.User;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.export.ExportReport;
import openolap.viewer.export.ExportReportFactory;
import openolap.viewer.manager.CellDataManager;

/**
 *  �N���X�FExportReportCommand<br>
 *  �����F���|�[�g�̃G�N�X�|�[�g�������s���N���X�ł��B
 */
public class ExportReportCommand implements Command {

	// ********** ���\�b�h **********

	/**
	 * �G�N�X�|�[�g�������s���B<br>
	 * �G�N�X�|�[�g�^�C�v�͂��̃Z�b�V�����ɃZ�b�g����Ă��郆�[�U�I�u�W�F�N�g�̃G�N�X�|�[�g�t�@�C���^�C�v�Ŏw�肳��Ă���`���ɏ]���B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return dispatch���JSP/HTML�̃p�X
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, FileNotFoundException, UnsupportedEncodingException, SQLException, NamingException, IOException, ParserConfigurationException, SAXException, TransformerException, XPathExpressionException {

		// �f�B�����V���������o�A�Z���f�[�^�擾������Session�Ɉꎞ�ۑ�
		// �i�Z���f�[�^�擾���������|�[�g�̒l�擾�����Ƌ��ʉ����邽�߁j
		CellDataManager.saveRequestParamsToSession(helper);

		User user = (User) helper.getRequest().getSession().getAttribute("user");

		// �G�N�X�|�[�g�������s
		ExportReportFactory exportReportFactory = new ExportReportFactory();
		ExportReport exportReport = exportReportFactory.getExportReport(user);
		String page = exportReport.exportReport(helper);

		return page;
	}

}
