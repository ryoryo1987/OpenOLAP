/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FMeasureDAO.java
 *  �����F���W���[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;

import openolap.viewer.Measure;
import openolap.viewer.common.CommonSettings;

/**
 *  �C���^�[�t�F�[�X�FMeasureDAO<br>
 *  �����F���W���[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface MeasureDAO {

	/**
	 * ���W���[�I�u�W�F�N�g�����߂�B<br>
	 *   ���W���[�I�u�W�F�N�g�̏�ԁF<br>
	 *     ���W���[�����o�[�I�u�W�F�N�g�F�����Ȃ�
	 * @return ���W���[�I�u�W�F�N�g
	 */
	public Measure findMeasureWithoutMember();

	/**
	 * ���W���[�I�u�W�F�N�g�����߂�B<br>
	 *   ���W���[�I�u�W�F�N�g�̏�ԁF<br>
	 *     ���W���[�����o�[�I�u�W�F�N�g�F����
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�
	 * @return ���W���[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public Measure findMeasureWithMember(String cubeSeq, CommonSettings commonSettings) throws SQLException;

}
