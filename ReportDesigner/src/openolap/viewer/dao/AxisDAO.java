/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.controller
 *  �t�@�C���FAxisDAO.java
 *  �����F�������擾����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/13
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Axis;
import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FAxisDAO<br>
 *  �����F�������擾����C���^�[�t�F�[�X�ł��B
 */
public interface AxisDAO {

	/**
	 * �N���C�A���g���瑗�M���ꂽ�p�����[�^�����ƂɁA���̃����o�̃Z���N�^�I�����A�h�������𔽉f����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registSelectedMemberAndDrillStat(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * �N���C�A���g���瑗�M���ꂽ�p�����[�^�����ƂɁA���f���̎������o�[�̃f�t�H���g�����o�����X�V����B
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 */
	public void registDefaultMember(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * �^����ꂽ���|�[�gID�����ƂɎ������f�[�^�\�[�X�֕ۑ�����B
	 * @param report Report�I�u�W�F�N�g 
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�Ŏ�����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�Ŏ�����ۑ�����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveAxis(Report report, String reportID, Connection conn) throws SQLException;

	/**
	 * �f�[�^�\�[�X����擾�������|�[�g�ݒ�����f���ɔ��f����B
	 * @param report Report�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyAxis(Report report, CommonSettings commonSettings, Connection conn) throws SQLException;

	/**
	 * �^����ꂽ���|�[�g�̑S�Ă̎��̏����f�[�^�\�[�X����폜����B
	 * @param report Report�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxes(Report report, Connection conn) throws SQLException;

	/**
	 * �^����ꂽ���̏����f�[�^�\�[�X����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteAxis(Report report, Axis axis, Connection conn) throws SQLException;
	
}
