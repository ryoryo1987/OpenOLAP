/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FColorDAO.java
 *  �����F�F�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/15
 */
package openolap.viewer.dao;

import java.sql.Connection;
import java.sql.SQLException;

import openolap.viewer.Report;
import openolap.viewer.common.CommonSettings;
import openolap.viewer.controller.RequestHelper;

/**
 *  �C���^�[�t�F�[�X�FColorDAO<br>
 *  �����F�F�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface ColorDAO {

	/**
	 * �N���C�A���g�����瑗���Ă����F�����T�[�o�[���̃��f���ɔ��f����B<br>
	 * �N���C�A���g�����M�������F<br>
	 *   �EdtColorInfo  �F �f�[�^�e�[�u�����̐F���
	 *   �EhdrColorInfo �F �w�b�_�[���̐F���
	 * @param helper RequestHelper�I�u�W�F�N�g
	 * @param commonSettings �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g
	 */
	public void registColor(RequestHelper helper, CommonSettings commonSettings);

	/**
	 * �F�����i��������B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param reportID ���|�[�gID
	 *                �����̃p�����[�^��NULL�̏ꍇ�AReport�I�u�W�F�N�g�������|�[�gID�ŐF����ۑ�����B
	 *                  NULL�ł͂Ȃ��ꍇ�́AreportID�p�����[�^�̒l�ŐF����ۑ�����B
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void saveColor(Report report, String reportID, Connection conn) throws SQLException;

	/**
	 * �f�[�^�\�[�X���F�ݒ�����߁A���|�[�g�I�u�W�F�N�g�ɓo�^����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void applyColor(Report report, Connection conn) throws SQLException;

	/**
	 * ��������ꂽ���|�[�g�̐F�����f�[�^�\�[�X����폜����B
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param conn Connection�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public void deleteColor(Report report, Connection conn) throws SQLException;

}
