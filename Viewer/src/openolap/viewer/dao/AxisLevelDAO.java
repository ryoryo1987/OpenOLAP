/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FAxisLevelDAO.java
 *  �����F�����x���I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import openolap.viewer.Axis;
import openolap.viewer.AxisLevel;

/**
 *  �N���X�FAxisLevelDAO<br>
 *  �����F�����x���I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface AxisLevelDAO {

	/**
	 * �^����ꂽ���̎����x���I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param axis ���I�u�W�F�N�g
	 * @return �����x���I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<AxisLevel> selectAxisLevels(String cubeSeq, Axis axis) throws SQLException;

}
