/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FDimensionMember.java
 *  �����F�f�B�����V�����̃����o�[������킷�N���X�ł��B
 *
 *  �쐬��: 2004/01/10
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FDimensionMember<br>
 *  �����F�f�B�����V�����̃����o�[������킷�N���X�ł��B
 */
public class DimensionMember extends AxisMember implements Serializable {

	// ********** �C���X�^���X�ϐ� **********	

	/** �R�[�h */
	final private String code;

	/** �V���[�g�l�[�� */
	final private String short_name;

	/** �����O�l�[�� */
	final private String long_name;

	/** ���x���ɂ��C���f���g�ς݂̃V���[�g�l�[�� */
	final private String indentedShortName;

	/** ���x���ɂ��C���f���g�ς݂̃����O�l�[�� */
	final private String indentedLongName;

	/** �����o�����[�t�� */
	final private boolean isLeaf;

	/** �h��������Ă��邩 */
	private boolean isDrilled;

	// ********** �R���X�g���N�^ **********

	/**
	 * �f�B�����V���������o�[�I�u�W�F�N�g�𐶐����܂��B
	 */
	public DimensionMember(String id, String uniqueName, String code, String short_name, String long_name, String indentedShortName, String indentedLongName, int level, boolean isLeaf) {

		super(id, uniqueName, level);
		this.code = code;
		this.short_name = short_name;
		this.long_name = long_name;
		this.indentedShortName = indentedShortName;
		this.indentedLongName = indentedLongName;
		this.isLeaf = isLeaf;

		if(level == 1){
			this.isDrilled = true;
		} else {
			this.isDrilled = false;
		}
		this.isSelected = true;

	}

	// ********** ���\�b�h **********

	/**
	 * ���̖��̂����߂�B<br>
	 * �f�B�����V���������o�[�̏ꍇ�A���Őݒ肳�ꂽ���̃^�C�v(long_name or short_name)�̖��̂�߂��B
	 * @param axis �f�B�����V���������o�[�������鎲�I�u�W�F�N�g
	 * @return �����o�[��
	 */
	public String getSpecifiedDisplayName(Axis axis) {
		if(axis instanceof Dimension){
			if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				return short_name;
			} else if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				return long_name;
			} else {
				throw new IllegalStateException();
			}
		} else {	// �f�B�����V�����̃����o�[��\�����郁�\�b�h�ł���A���������W���[�ł��邱�Ƃ͂�������
			throw new IllegalArgumentException();
		}
	}

	/**
	 * ���̃C���f���g�t�H�[�}�b�g���̖��̂����߂�B<br>
	 * �f�B�����V���������o�[�̏ꍇ�A���Őݒ肳�ꂽ���̃^�C�v(long_name or short_name)�̃C���f���g�t�H�[�}�b�g���̖��̂�߂��B
	 * @param axis �����o�[�������鎲�I�u�W�F�N�g
	 * @return �C���f���g�t�H�[�}�b�g���̃����o�[��
	 */
	public String getSpecifiedIndentedDisplayName(Axis axis){
		if(axis instanceof Dimension){
			if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				return indentedShortName;
			} else if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				return indentedLongName;
			} else {
				throw new IllegalStateException();
			}		
		} else {	// �f�B�����V�����̃����o�[��\�����郁�\�b�h�ł���A���������W���[�ł��邱�Ƃ͂�������
			throw new IllegalArgumentException();
		}
	}

	/**
	 * ���̖��̂����߂�B<br>
	 * �w�肳�ꂽ���̃^�C�v(long_name or short_name)�̖��̂�߂��B
	 * @param dispNameType ���̃^�C�v(long_name or short_name)
	 * @return �����o�[��
	 */
	public String getNameByDispNameType(String dispNameType){
		if (dispNameType == null) { throw new IllegalArgumentException();}
		if ((!Dimension.DISP_SHORT_NAME.equals(dispNameType)) && (!Dimension.DISP_LONG_NAME.equals(dispNameType)) ) { throw new IllegalArgumentException(); }

		String name = null;
		if (Dimension.DISP_SHORT_NAME.equals(dispNameType)) {
			name = this.getShort_name();
		} else if (Dimension.DISP_LONG_NAME.equals(dispNameType)) {
			name = this.getLong_name();
		}
		
		return name;
	}

	/**
	 * ���̖��̂����߂�B<br>
	 * �w�肳�ꂽ���̃^�C�v(long_name or short_name)�̃C���f���g�t�H�[�}�b�g���̖��̂�߂��B
	 * @param dispNameType ���̃^�C�v(long_name or short_name)
	 * @return �C���f���g�t�H�[�}�b�g���̃����o�[��
	 */
	public String getIndentedNameByDispNameType(String dispNameType){
		if (dispNameType == null) { throw new IllegalArgumentException();}
		if ((!Dimension.DISP_SHORT_NAME.equals(dispNameType)) && (!Dimension.DISP_LONG_NAME.equals(dispNameType)) ) { throw new IllegalArgumentException(); }

		String indentedName = null;
		if (Dimension.DISP_SHORT_NAME.equals(dispNameType)) {
			indentedName = this.getIndentedShortName();
		} else if (Dimension.DISP_LONG_NAME.equals(dispNameType)) {
			indentedName = this.getIndentedLongName();
		}
		
		return indentedName;
	}

	// ********** setter **********

	/**
	 * �������o�[���h��������Ă��邩�ǂ���������킷�t���O���Z�b�g����B
	 * @param isDrilled �h��������Ă��邩
	 */
	public void setDrilled(boolean isDrilled) {
		this.isDrilled = isDrilled;
	}

	/**
	 * �������o�[���I������Ă��邩�ǂ���������킷�t���O���Z�b�g����B
	 * @param isSelected �I������Ă��邩
	 */
	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}

	// ********** getter **********

	/**
	 * �������o�[�̃R�[�h�����߂�B
	 * @return �R�[�h
	 */
	public String getCode() {
		return code;
	}

	/**
	 * �������o�[�̃V���[�g�l�[�������߂�B
	 * @return �V���[�g�l�[��
	 */
	public String getShort_name() {
		return short_name;
	}

	/**
	 * �������o�[�̃����O�l�[�������߂�B
	 * @return �����O�l�[��
	 */
	public String getLong_name() {
		return long_name;
	}

	/**
	 * �������o�[�̃��x���ɂ��C���f���g���ꂽ�V���[�g�l�[�������߂�B
	 * @return �C���f���g�ς݃V���[�g�l�[��
	 */
	public String getIndentedShortName() {
		return indentedShortName;
	}

	/**
	 * �������o�[�̃��x���ɂ��C���f���g���ꂽ�����O�l�[�������߂�B
	 * @return �C���f���g�ς݃V���[�g�l�[��
	 */
	public String getIndentedLongName() {
		return indentedLongName;
	}

	/**
	 * �������o�[�����[�t�ł���q�������o�[�������Ȃ��ꍇ��true���A�����łȂ��ꍇ��false��߂��B
	 * @return ���[�t��
	 */
	public boolean isLeaf() {
		return isLeaf;
	}

	/**
	 * �������o�[���h��������Ă���ꍇ��true���A�����łȂ��ꍇ��false��߂��B
	 * @return �h��������Ă��邩
	 */
	public boolean isDrilled() {
		return isDrilled;
	}


}
