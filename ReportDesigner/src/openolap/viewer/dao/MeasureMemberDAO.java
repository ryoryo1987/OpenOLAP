/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FMeasureMemberDAO.java
 *  �����F���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/07
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.common.CommonSettings;
import openolap.viewer.MeasureMember;
import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FMeasureMemberDAO<br>
 *  �����F���W���[�����o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface MeasureMemberDAO {

	/**
	 * ���W���[�����o�[������킷�I�u�W�F�N�g�̏W�����f�[�^�\�[�X��苁�߂�B
	 * @param cubeSeq �L���[�u�V�[�P���X�ԍ�
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�
	 * @return ���W���[�����o�[�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<MeasureMember> selectMeasureMembers(String cubeSeq, CommonSettings commonSettings) throws SQLException;

	/**
	 * ���W���[�����o�[�̃��W���[�����o�[�^�C�v���N���C�A���g����^����ꂽ�������ƂɍX�V����B
	 * �N���C�A���g����^����ꂽ���F"measureMemberTypes"�p�����[�^
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings ��������킷�I�u�W�F�N�g
	 */
	public void registMeasureMemberType(RequestHelper helper, CommonSettings commonSettings);

}
