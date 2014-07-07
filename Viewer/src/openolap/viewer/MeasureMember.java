/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FMeasureMember.java
 *  �����F���W���[�����o�[��\���I�u�W�F�N�g�ł��B
 *
 *  �쐬��: 2004/12/29
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FMeasureMember<br>
 *  �����F���W���[�����o�[��\���I�u�W�F�N�g�ł��B
 */
public class MeasureMember extends AxisMember implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ���W���[�V�[�P���X�ԍ� */
	protected final String measureSeq;

	/** ���W���[�� */
	protected final String measureName;

	/** ���W���[�����o�[�^�C�v */
	private MeasureMemberType measureMemberType = null;

	// ********** �R���X�g���N�^ **********

	/**
	 * ���W���[�����o�[��\���I�u�W�F�N�g�𐶐����܂��B
	 */
	public MeasureMember(String id, String measureName, MeasureMemberType meaMemType, String uniqueName, String measureSeq) {
		super(id, uniqueName, 1);				// ���W���[�͊K�w�ɂ͂Ȃ�Ȃ����߁A���x���͏�Ɂu�P�v
		this.measureSeq = measureSeq;
		this.measureName = measureName;
		this.measureMemberType = meaMemType;
	}

	// ********** ���\�b�h **********

	/**
	 * �������o�[�̖��̂����߂�B
	 * @param axis �����o�[�������鎲�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public String getSpecifiedDisplayName(Axis axis) {
		return measureName;
	}

	/**
	 * �������o�[�̃C���f���g�t�H�[�}�b�g���̖��̂����߂�B
	 * @param axis �����o�[�������鎲�I�u�W�F�N�g
	 * @return �C���f���g�t�H�[�}�b�g���̃����o�[��
	 */
	public String getSpecifiedIndentedDisplayName(Axis axis) {
		return measureName;
	}

	// ********** Setter���\�b�h **********

	/**
	 * ���W���[�����o�[�^�C�v������킷�I�u�W�F�N�g���Z�b�g����B
	 * @param meaMemType ���W���[�����o�[�^�C�v������킷�I�u�W�F�N�g
	 */
	public void setMeasureMemberType(MeasureMemberType meaMemType) {
		this.measureMemberType = meaMemType;
	}

	// ********** getter **********

	/**
	 * ���W���[�V�[�P���X�ԍ������߂�B
	 * @return ���W���[�V�[�P���X�ԍ�
	 */
	public String getMeasureSeq() {
		return this.measureSeq;
	}

	/**
	 * ���W���[�������߂�B
	 * @return ���W���[��
	 */
	public String getMeasureName() {
		return this.measureName;
	}

	/**
	 * ���W���[�����o�[�^�C�v�����߂�B
	 * @return ���W���[�����o�[�^�C�v
	 */
	public MeasureMemberType getMeasureMemberType() {
		return this.measureMemberType;
	}

	/**
	 * �C���f���g���̃V���[�g�l�[�������߂�B
	 * �i���W���[�I�u�W�F�N�g�ł��邽�߃��W���[����߂��j
	 * @return ���W���[��
	 */
	public String getIndentedShortName() {
		return measureName;
	}

	/**
	 * �C���f���g���̃����O�l�[�������߂�B
	 * �i���W���[�I�u�W�F�N�g�ł��邽�߃��W���[����߂��j
	 * @return ���W���[��
	 */
	public String getIndentedLongName() {
		return measureName;
	}

}
