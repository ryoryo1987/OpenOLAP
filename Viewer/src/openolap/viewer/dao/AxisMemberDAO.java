/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FAxisMemberDAO.java
 *  �����F�������o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/14
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;

/**
 *  �N���X�FAxisMemberDAO<br>
 *  �����F�������o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface AxisMemberDAO {

	/**
	 * �^����ꂽ���̃f�B�����V���������o�[���i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ������o�[����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ������o�[����ۑ�����B
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connecion�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveAxisMember(Report report, String reportID, Axis axis, Connection conn) throws SQLException;

	/**
	 * �f�B�����V���������o�[�����f�[�^�\�[�X�̏������Ƃɐ������A�f�B�����V�����I�u�W�F�N�g��"selectedMemberDrillStat"�ɐݒ肷��B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyAxis(Report report,Axis axis, CommonSettings commonSettings) throws SQLException;

	/**
	 * �f�[�^�\�[�X�ɕۑ��ς���Ă��鎲�����o�[�����擾����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 */
	public String selectSaveDataSQL(Report report, Axis axis);

	/**
	 * �w�肳�ꂽ���|�[�g�̎w�肳�ꂽ���̃����o�����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxisMember(Report report, Axis axis, Connection conn) throws SQLException;

	/**
	 * �w�肳�ꂽ���|�[�g�̂��ׂĂ̎��̎������o�����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxisMember(Report report, Connection conn) throws SQLException;

}
