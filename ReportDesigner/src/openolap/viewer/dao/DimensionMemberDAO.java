/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.dao
 *  �t�@�C���FDimensionMemberDAO.java
 *  �����F�f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.dao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import openolap.viewer.Axis;
import openolap.viewer.AxisMember;
import openolap.viewer.Dimension;
import openolap.viewer.DimensionMember;
import openolap.viewer.Report;

/**
 *  �C���^�[�t�F�[�X�FDimensionMemberDAO<br>
 *  �����F�f�B�����V���������o�[�I�u�W�F�N�g�̉i�������Ǘ�����C���^�[�t�F�[�X�ł��B
 */
public interface DimensionMemberDAO {

	/**
	 * ���|�[�g�����S���̃����o������ID�̏����ŏo��
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @return StringBuffer�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public StringBuffer getDimensionMemberXML(Report report) throws SQLException, IOException;

	/**
	 * �w�肳�ꂽ���̃����o�����o��
	 * @param report ���|�[�g�I�u�W�F�N�g
	 * @param axis ���I�u�W�F�N�g
	 * @param selectFLG ���̃����o�[���i�荞�܂�Ă��邩�ǂ���������킷�t���O
	 * @exception SQLException �������ɗ�O����������
	 * @exception IOException �������ɗ�O����������
	 */
	public StringBuffer getDimensionMemberXML(Report report, Axis axis, boolean selectFLG) throws SQLException, IOException;

	/**
	 * �w�肳�ꂽ�f�B�����V�����̃����o�[�I�u�W�F�N�g�̃��X�g�����߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @param shortNameCondition �V���[�g�l�[���ɂ��擾����
	 * @param longNameCondition �����O�l�[���ɂ��擾����
	 * @param levelCondition ���x���ɂ��擾����
	 * @param selectedKeyString �擾�ΏۂƂ��郁���o�[�L�[�̃��X�g������킷������
	 * @return �f�B�����V���������o�[�I�u�W�F�N�g�̃��X�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public ArrayList<AxisMember> selectDimensionMembers(Dimension dim, String shortNameCondition, String longNameCondition, String levelCondition, String selectedKeyString) throws SQLException;

	/**
	 * �f�B�����V�����I�u�W�F�N�g�̃����o�[���\���^�C�v���AXML�̃^�O���ɕϊ��B
	 * @param modelString �����o�[���\���^�C�v������킷������
	 * @return XML�̃^�O��
	 */
	public String transferMemberDisplayTypeFromModelToXML(String string);

	/**
	 * �^����ꂽ�f�B�����V���������������o�[�������߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @return �����o�[��
	 * @exception SQLException �������ɗ�O����������
	 */
	public int getDimensionMemberNumber(Dimension dim) throws SQLException;

	/**
	 * �w�肳�ꂽ�f�B�����V�����̃����o�[�I�u�W�F�N�g���X�g�̐擪�̃����o�[�I�u�W�F�N�g�����߂�B
	 * @param dim �f�B�����V�����I�u�W�F�N�g
	 * @return �f�B�����V���������o�[�I�u�W�F�N�g
	 * @exception SQLException �������ɗ�O����������
	 */
	public DimensionMember getFirstMember(Dimension dim) throws SQLException;
}
