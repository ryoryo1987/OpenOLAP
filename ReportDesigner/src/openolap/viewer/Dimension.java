/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FCube.java
 *  �����F�L���[�u������킷�N���X�ł��B
 *
 *  �쐬��: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *  �N���X�FDimension<br>
 *  �����F�f�B�����V����������킷�N���X�ł��B
 */
public class Dimension extends Axis implements Serializable {

	// �萔

	/** �����O�l�[��������킷������ */
	final public static String DISP_LONG_NAME = "long_name";

	/** �V���[�g�l�[��������킷������ */
	final public static String DISP_SHORT_NAME = "short_name";	


	// ********** �C���X�^���X�ϐ� **********

	/** ���ԃf�B�����V�������ǂ��� */
	final private boolean isTimeDimension;

	/** �����o�[�ɍ��v�l���܂ނ� */
	final private boolean hasTotal;

	/** �f�B�����V�����V�[�P���X�ԍ� */
	final private String dimensionSeq;

	/** �f�B�����V�����p�[�c�ԍ� */
	final private String partSeq;

	/** �����o�[���̕\���^�C�v�ilong_name, short_name�j */
	private String dispMemberNameType = null;

	/** �Z���N�^�őI�����ꂽ�����o�Ƃ��̃h������Ԃ�ێ� */
	private HashMap<String, String> selectedMemberDrillStat;

	// ********** �R���X�g���N�^ **********

	/**
	 * �f�B�����V�����I�u�W�F�N�g�𐶐����܂��B
	 */
	public Dimension(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter, boolean isTimeDim, boolean hasTotal, String dimensionSeq, String partSeq) {
		super(id, name, comment, axisLevelList, defaultMemberKey, isMeasure, isUsedSelecter);
		this.isTimeDimension = isTimeDim;
		this.hasTotal = hasTotal;
		this.dimensionSeq = dimensionSeq;
		this.partSeq = partSeq;

		this.dispMemberNameType = Dimension.DISP_SHORT_NAME;
		this.selectedMemberDrillStat = new HashMap<String, String>();

	}

	// ********** ���\�b�h **********

	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";

		// Axis �N���X�̎������o��
		stringInfo += super.toString();

		stringInfo += "Dimension.dimensionSeq:" + this.dimensionSeq + sep;
		stringInfo += "Dimension.partSeq:" + this.partSeq + sep;
		stringInfo += "Dimension.dispMemberNameType:" + this.dispMemberNameType + sep;

		stringInfo += "Dimension.isTimeDimension:" + String.valueOf(this.isTimeDimension) + sep;
		stringInfo += "Dimension.hasTotal:" + String.valueOf(this.hasTotal) + sep;
		stringInfo += "Dimension.selectedMemberDrillStat:" + this.selectedMemberDrillStat.toString() + sep;

		return stringInfo;

	}

	// ********** Setter ���\�b�h **********

	/**
	 * �����o�[���̕\���^�C�v���Z�b�g����B
	 * @param dispMemberNameType �����o�[���̕\���^�C�v
	 */
	public void setDispMemberNameType(String dispMemberNameType) {
		this.dispMemberNameType = dispMemberNameType;
	}

	/**
	 * �Z���N�^�őI������Ă��郁���o�[��UniqueName���L�[�Ɏ����A�h������Ԃ�l�Ɏ���Map�I�u�W�F�N�g���Z�b�g����B
	 * @param selectedMemberDrillStat �����o�[��������Map�I�u�W�F�N�g
	 */
	public void setSelectedMemberDrillStat(HashMap<String, String> selectedMemberDrillStat) {
		this.selectedMemberDrillStat = selectedMemberDrillStat;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * �����o�[���̕\���^�C�v�����߂�B
	 * @return �����o�[���̕\���^�C�v
	 */
	public String getDispMemberNameType() {
		return dispMemberNameType;
	}

	/**
	 * ���̎������Ԏ��ł����true�A���Ԏ��ȊO�ł����false��߂�
	 * @return ���Ԏ���
	 */
	public boolean isTimeDimension() {
		return isTimeDimension;
	}

	/**
	 * ���̎������v�l�����Ă�true�A���v�l�������Ȃ����false��߂�
	 * @return ���v�l������
	 */
	public boolean hasTotal() {
		return hasTotal;
	}

	/**
	 * �f�B�����V�����V�[�P���X�ԍ������߂�B
	 * @return �f�B�����V�����V�[�P���X�ԍ�
	 */
	public String getDimensionSeq() {
		return dimensionSeq;
	}

	/**
	 * �f�B�����V�����p�[�c�ԍ������߂�B
	 * @return �f�B�����V�����p�[�c�ԍ�
	 */
	public String getPartSeq() {
		return partSeq;
	}

	/**
	 * �Z���N�^�őI������Ă��郁���o�[��UniqueName���L�[�Ɏ����A�h������Ԃ�l�Ɏ���Map�I�u�W�F�N�g�����߂�B
	 * 	�h������ԁF�h�����_�E������Ă����1�A�h�����_�E������Ă��Ȃ����0
	 * @return �����o�[��������Map�I�u�W�F�N�g
	 */
	public HashMap<String, String> getSelectedMemberDrillStat() {
		return selectedMemberDrillStat;
	}

}
