/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FGetAxisMemberInfoByAxisIDCommand.java
 *  �����F�w�肳�ꂽ�f�B�����V�����Ƃ��̃����o�[�̏���XML�`���ŏo�͂���N���X�ł��B
 *
 *  �쐬��: 2004/02/13
 */
package openolap.viewer.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import org.apache.log4j.Logger;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.common.Constants;
import openolap.viewer.dao.DAOFactory;
import openolap.viewer.dao.DimensionMemberDAO;

/**
 *  �N���X�FGetAxisMemberInfoByAxisIDCommand<br>
 *  �����F�w�肳�ꂽ�f�B�����V�����Ƃ��̃����o�[�̏���XML�`���ŏo�͂���N���X�ł��B
 */
public class GetAxisMemberInfoByAxisIDCommand implements Command {

	// ********** �C���X�^���X�ϐ� **********

	/** ���M���O�I�u�W�F�N�g */
	private Logger log = Logger.getLogger(GetReportInfoCommand.class.getName());


	// ********** ���\�b�h **********

	/**
	 * �w�肳�ꂽ�f�B�����V�����Ƃ��̃����o�[�̏���XML�`���Ő�������B<br>
	 * JSP��dispatch���s�킸�ɒ���XML���o�͂��邽�߁Anull��߂��B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return null
	 * @exception ServletException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception SQLException �������ɗ�O����������
	 * @exception NamingException �������ɗ�O����������
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException, SQLException, NamingException {

		Report report = (Report) helper.getRequest().getSession().getAttribute("report");
		String targetAxisID = (String) helper.getRequest().getParameter("axisID");
		if(Constants.MeasureID.equals(targetAxisID)) {	// ���������o��XML�����Ȃ̂ŁA���W���[�ł��邱�Ƃ͂��肦�Ȃ�
			throw new IllegalArgumentException();
		}

		Axis axis = report.getAxisByID(targetAxisID);

		Connection conn = null;
		DAOFactory daoFactory = DAOFactory.getDAOFactory();

		try {
			conn = daoFactory.getConnection((String)helper.getRequest().getSession().getAttribute("connectionPoolName"),
											(String)helper.getRequest().getSession().getAttribute("searchPathName"));
	
			StringBuilder axisMemberXML = new StringBuilder(512);
	
			// XML ����
			axisMemberXML.append("<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>");				// XML �w�b�_
			DimensionMemberDAO dimMemberDAO =  daoFactory.getDimensionMemberDAO(conn);
			axisMemberXML.append(dimMemberDAO.getDimensionMemberXML(report, axis , false));	// �f�B�����V���������o�[���X�gXML

			// XML �o�͏���
			helper.getResponse().setContentType("text/xml; charset=Shift_JIS");
			PrintWriter out = helper.getResponse().getWriter();

			// �o��
			out.println(axisMemberXML.toString());
				if(log.isInfoEnabled()) {	// ���O�o��
					log.info("XML(selected axisInfo)�F\n" + axisMemberXML.toString());
				}

		} catch (SQLException e) {
			throw e;
		} finally {
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					throw e;
				}
			}
		}

		return null;
	}

}
