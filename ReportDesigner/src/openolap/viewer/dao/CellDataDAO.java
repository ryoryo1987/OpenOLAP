/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FCellDataDAO.java
 *  �����F�Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.dao;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Report;
import openolap.viewer.CellData;
import openolap.viewer.EdgeCoordinates;


/**
 *  �N���X�FCellDataDAO<br>
 *  �����F�Z���f�[�^�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface CellDataDAO {

	// ********** �ÓI�ϐ� **********

	/** �W���i�����͍����ŁA��ID���Ƀ\�[�g�����j������킷SQL�^�C�v��\�������� */
	static String normalSQLTypeString = "Normal";

	/** �s�E��E�y�[�W�G�b�W�̎����Ń\�[�g���ꂽSQL�^�C�v��\�������� */
	static String sortedSQLTypeString = "Sorted";
	
	
	// ********** ���\�b�h **********


	/**
	 * �Z���f�[�^�I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param cellDataSQL �Z���f�[�^�擾�pSQL������킷�I�u�W�F�N�g
	 * @param items ��A�s�A�y�[�W�G�b�W���̎�ID���X�g
	 *        items[0]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[1]�F��G�b�W�ɔz�u���ꂽ��ID�̔z��
	 *        items[2]�F�y�[�W�G�b�W�ɔz�u���ꂽ��ID�Ƃ��̃f�t�H���g�����o�[�L�[�̔z��
	 * @param request HttpServletRequest�I�u�W�F�N�g
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param colCoordinatesList ����W
	 * @param rowCoordinatesList �s���W
	 * @param SQLType SQL�^�C�v�B�����Ŏw�肳�ꂽ�^�C�v��SQL�����s�����B
	 * 			this.normalSQLTypeString�F�W���i�����͍����ŁA��ID���Ƀ\�[�g�����j
	 * 			this.sortedSQLTypeString�F�s�E��E�y�[�W�G�b�W�̎����Ń\�[�g
	 * @return �Z���f�[�^�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<CellData> selectCellDatas(CellDataSQL cellDataSQL, Object[] items, HttpServletRequest request, Report report, ArrayList<EdgeCoordinates> colCoordinatesList, ArrayList<EdgeCoordinates> rowCoordinatesList, String SQLType) throws SQLException;

}
