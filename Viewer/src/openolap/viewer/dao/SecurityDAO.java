/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FSecurityDAO.java
 *  �����F�Z�L�����e�B���̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Security;

/**
 *  �C���^�[�t�F�[�X�FUserDAO<br>
 *  �����F���[�U�[���̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface SecurityDAO {

	/**
	 * �^����ꂽ���[�U�[ID�A���|�[�gID�����ƂɃZ�L�����e�B�I�u�W�F�N�g�����߂�B<br>
	 * @param userID ���[�U�[ID
	 * @param reportID ���|�[�gID
	 * @return �Z�L�����e�B�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Security getSecurity(String userID, String reportID) throws SQLException;

}
