/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FUserDAO.java
 *  �����F���[�U�[���̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/30
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.User;

/**
 *  �C���^�[�t�F�[�X�FUserDAO<br>
 *  �����F���[�U�[���̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface UserDAO {

	/**
	 * �^����ꂽ���[�U�[���A�p�X���[�h�����ƂɃ��[�U�[�I�u�W�F�N�g�����߂�B<br>
	 * �o�^����Ă��Ȃ��ꍇ�̓��O�C�����s�Ƃ݂Ȃ��Anull��߂��B
	 * @param userName ���[�U�[��
	 * @param password �p�X���[�h
	 * @return ���[�U�[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public User getUser(String userName, String password) throws SQLException;

}
