/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FReportDAO.java
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/07
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;
import org.xml.sax.SAXException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FReportDAO<br>
 *  �����F���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface ReportDAO {

	/**
	 * ���g�p�̃��|�[�gID���擾�����߂�B
	 * @param conn Connection�I�u�W�F�N�g
	 * @return ���g�p�̃��|�[�gID
	 * @exception SQLException �������ɗ�O����������
	 */
	public String getInitialReportID(Connection conn) throws SQLException;

	/**
	 * �N���C�A���g���瑗�M���ꂽ�f�t�H���g�����o�[�A���̔z�u�������f���̃��|�[�g�I�u�W�F�N�g�ɔ��f����B
	 *   �p�����[�^���j
	 *     defaultMembers�F�S���̃f�t�H���g�����o�[���
	 *     colItems�F��G�b�W�ɔz�u���ꂽ����ID
	 *     rowItems�F�s�G�b�W�ɔz�u���ꂽ����ID
	 *     pageItems�F�y�[�W�G�b�W�ɔz�u���ꂽ����ID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registAxisPosition(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * ���|�[�g�̎��̃G�b�W�z�u�����X�V����B
	 * @param colItemList ��ɔz�u���ꂽ��ID���X�g
	 * @param rowItemList �s�ɔz�u���ꂽ��ID���X�g
	 * @param pageItemList �y�[�W�ɔz�u���ꂽ��ID���X�g
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registAxisPosition(ArrayList<String> colItemList, ArrayList<String> rowItemList, ArrayList<String>  pageItemList, Report report);

	/**
	 * ���|�[�g�����f�[�^�\�[�X�֕ۑ�����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveReport(Report report, Connection conn) throws SQLException;


	/**
	 * ���|�[�g�����f�[�^�\�[�X�֕ۑ�����B
	 * @param report ���|�[�g������킷�I�u�W�F�N�g
	 * @param newReportName �V�K���|�[�g��
	 * @param userID ���[�UID
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveNewPersonalReport(Report report, String newReportName, String userID, Connection conn)  throws SQLException;


	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɁA���|�[�g�I�u�W�F�N�g�𐶐�����B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param userID ���|�[�g�̏��L���[�U��ID 
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return ���|�[�g�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Report getInitialReport(String cubeSeq, String userID, CommonSettings commonSettings) throws SQLException;

	/**
	 * ���|�[�gID�����ƂɊ����̃��|�[�g�I�u�W�F�N�g�����߂�B
	 * @param reportId ���|�[�gID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @return ���|�[�g�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Report getExistingReport(String reportId, RequestHelper helper, CommonSettings commonSettings) throws SQLException;

	/**
	 * �N���C�A���g���瑗�M���ꂽ���|�[�g�̖��́A�e�t�H���_�������f���̃��|�[�g�I�u�W�F�N�g�ɔ��f����B
	 *   �p�����[�^���j
	 *     reportName�F���|�[�g��
	 *     folderID�F���|�[�g���i�[����t�H���_��ID
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registReport(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * �f�[�^�x�[�X���AR���|�[�g���^���ł���e���v���[�gXML�ASQL��������擾����B
	 * 
	 * @param sourceTable: �e���v���[�gXML,SQL �̎擾���e�[�u���� 
	 * @param reportID: sourceTable �̍i���ݏ����i���|�[�gID�j
	 * @return ���L��������i�[����HashMap�I�u�W�F�N�g
	 * 				templateXMLString: �e���v���[�gXML
	 * 				getDataSQL: SQL
	 * @exception SQLException �������ɗ�O����������
	 */
	public HashMap<String, String> getTemplateInfo(String sourceTable, String reportID) throws SQLException;

	/**
	 * �f�[�^�x�[�X���A�h�����X���[��ƂȂ郌�|�[�g�̏��iID�Ɩ��̂��i�[����HashMap�j���擾����B
	 * @param reportID: sourceTable �̍i���ݏ����i���|�[�gID�j
	 * @return �h�����X���[��ƂȂ郌�|�[�g�����i�[����HashMap
	 * @exception SQLException �������ɗ�O����������
	 * @exception ParserConfigurationException �������ɗ�O����������
	 * @exception SAXException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 * @exception TransformerException �������ɗ�O����������
	 */
	public HashMap<String, String> getDrillThrowInfo(String reportID) throws SQLException, ParserConfigurationException, SAXException, IOException, TransformerException, XPathExpressionException;



}
