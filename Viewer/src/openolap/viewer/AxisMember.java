/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FAxisMember.java
 *  �����F���̃����o�[������킷���ۃN���X�ł��B
 *
 *  �쐬��: 2004/01/11
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  ���ۃN���X�FAxisMember<br>
 *  �����F���̃����o�[������킷���ۃN���X�ł��B
 */
public abstract class AxisMember implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �����o�[id(0start) */
	protected final String id;

	/** �����o�[�̃��j�[�N��(Key)
	 *    ���W���[�̏ꍇ�Aviewer�����W���[�����o�[�ɑ΂��ĐU��A0����̒ʔԁB
	*/
	protected final String uniqueName;

	/** �����o�[�̃��x�� */
	protected final int level;

	/** �Z���N�^�őI�΂�Ă��郁���o�[�� */
	protected boolean isSelected = true;

	// ********** �R���X�g���N�^ **********

	/**
	 * �������o�[�I�u�W�F�N�g�𐶐����܂��B
	 */
	public AxisMember(String id, String uniqueName, int level) {
		this.id = id;
		this.uniqueName = uniqueName;
		this.level = level;
		this.isSelected = true;
	}

	// ********** ���\�b�h **********

	/**
	 * �������o�[�̖��̂����߂�B<br>
	 * �f�B�����V���������o�[�̏ꍇ�A���Őݒ肳�ꂽ���̃^�C�v(long_name or short_name)�̖��̂�߂��B
	 * @param axis �����o�[�������鎲�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public abstract String getSpecifiedDisplayName(Axis axis);

	/**
	 * �������o�[�̃C���f���g�t�H�[�}�b�g���̖��̂����߂�B<br>
	 * �f�B�����V���������o�[�̏ꍇ�A���Őݒ肳�ꂽ���̃^�C�v(long_name or short_name)�̃C���f���g�t�H�[�}�b�g���̖��̂�߂��B
	 * @param axis �����o�[�������鎲�I�u�W�F�N�g
	 * @return �C���f���g�t�H�[�}�b�g���̃����o�[��
	 */
	public abstract String getSpecifiedIndentedDisplayName(Axis axis);

	/**
	 * �C���f���g�t�H�[�}�b�g���̃V���[�g�l�[��(short_name)�����߂�B<br>
	 */
	public abstract String getIndentedShortName();

	/**
	 * �������o�[�̃C���f���g�t�H�[�}�b�g���̃����O�l�[��(long_name)�����߂�B<br>
	 */
	public abstract String getIndentedLongName();

	// ********** setter **********

	/**
	 * �������o�[���I�΂�Ă��邩�ǂ���������킷�t���O���Z�b�g����B
	 * @param selectedFLG �I�΂�Ă��邩
	 */
	public void setIsSelected(boolean selectedFLG) {
		this.isSelected = selectedFLG;
	}

	// ********** getter **********

	/**
	 * �������o�[��ID�����߂�B
	 * @return �������o�[��ID
	 */
	public String getId() {
		return this.id;
	}

	/**
	 * �������o�[�̃��j�[�N��(key)�����߂�B
	 * @return �������o�[�̃��j�[�N��
	 */
	public String getUniqueName() {
		return this.uniqueName;
	}

	/**
	 * �������o�[���Z���N�^�őI������Ă��邩�ǂ����̃t���O�����߂�B
	 * @return �Z���N�^�őI������Ă��邩
	 */
	public boolean isSelected() {
		return this.isSelected;
	}

	/**
	 * �������o�[�̃��x�������߂�B
	 * @return �������o�[�̃��x��
	 */
	public int getLevel() {
		return level;
	}

}
