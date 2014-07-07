/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FRReportDAO.java
 *  �����FR���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2005/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FReportDAO<br>
 *  �����FR���|�[�g�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface RReportDAO {

	/**
	 * R���|�[�g�I�u�W�F�N�gXML�𐶐�����B
	 * @return R���|�[�g�����p��XML���i�[����StringBuffer�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public StringBuffer getRReportXML(RequestHelper helper) throws SQLException;


}
