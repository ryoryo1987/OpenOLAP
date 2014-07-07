/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FCubeDAO.java
 *  �����F�L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Cube;

/**
 *  �N���X�FCubeDAO<br>
 *  �����F�L���[�u�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface CubeDAO {

	/**
	 * �t�@�N�g�e�[�u���������߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �t�@�N�g�e�[�u����
	 */
	public String getFactTableName(String cubeSeq);

	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɃL���[�u�������߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �L���[�u��
	 * @exception SQLException �������ɗ�O����������
	 */
	public String getCubeName(String cubeSeq) throws SQLException;

	/**
	 * �L���[�u�V�[�P���X�ԍ������ƂɃL���[�u�I�u�W�F�N�g�����߂�B
	 * @param cubeSeq �L���[�u�̃V�[�P���X�ԍ�
	 * @return �L���[�u�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Cube getCubeByID(String cubeSeq) throws SQLException;

}
