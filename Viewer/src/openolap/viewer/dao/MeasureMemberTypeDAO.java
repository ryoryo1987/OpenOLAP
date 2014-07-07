/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FMeasureMemberTypeDAO.java
 *  �����F���W���[�����o�[�^�C�v�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/12
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import openolap.viewer.MeasureMemberType;

/**
 *  �C���^�[�t�F�[�X�FMeasureMemberTypeDAO<br>
 *  �����F���W���[�����o�[�^�C�v�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface MeasureMemberTypeDAO {

	/**
	 * �f�[�^�\�[�X�ɓo�^����Ă��郁�W���[�����o�[�^�C�v�̃��X�g�����߂�<br>
	 * @return ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() throws SQLException;


}
