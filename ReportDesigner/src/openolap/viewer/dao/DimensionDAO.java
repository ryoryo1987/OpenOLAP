/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FDimensionDAO.java
 *  �����F�f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/06
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.Dimension;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FDimensionDAO<br>
 *  �����F�f�B�����V�����I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface DimensionDAO {

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @return �f�B�����V�����I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<Dimension> selectDimensions(String cubeSeq) throws SQLException;

	/**
	 * �f�B�����V�����̃����o�[���̕\���^�C�v�����X�V����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 */
	public void registDimensionMemberDispType(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * �f�[�^�\�[�X�̃f�B�����V�����̕����e�[�u���������߂�B
	 * @param dimSeq �f�B�����V�����V�[�P���X�ԍ�
	 * @param partSeq �f�B�����V�����̃p�[�c�ԍ�
	 * @return DB�̕����e�[�u����
	 */
	public String getDimensionTableName(String dimSeq, String partSeq);

}
