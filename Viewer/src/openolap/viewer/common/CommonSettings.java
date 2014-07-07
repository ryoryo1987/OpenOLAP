/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.common
 *  �t�@�C���FCommonSettings.java
 *  �����F�A�v���P�[�V�����̋��ʐݒ������킷�N���X�ł��B
 *
 *  �쐬��: 2004/01/12
 */
package openolap.viewer.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;

import openolap.viewer.MeasureMemberType;

/**
 *  �N���X�FCommonSettings<br>
 *  �����F�A�v���P�[�V�����̋��ʐݒ������킷�N���X�ł��B
 */
public class CommonSettings implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �������g�̃I�u�W�F�N�g */
	static final CommonSettings commonSettings = new CommonSettings(CommonUtils.FLGTobool(Messages.getString("InitializeStatus.valueXmlContainsAxesInfoFLG")));

	/** ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̃��X�g */
	final private ArrayList<MeasureMemberType> measureMemberTypeList = new ArrayList<MeasureMemberType>();

	/** �lXML�Ɏ����i��ID����у����o�[�L�[�̑g�ݍ��킹�j���܂߂邩 */
	final private boolean valueXmlContainsAxesInfo;
	
	// ********** �R���X�g���N�^ **********

	/**
	 * �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g�𐶐����܂��B
	 * �I�u�W�F�N�g�͈�̂ݐ�������邱�Ƃ��K�v�B
	 */
	private CommonSettings (boolean valueXmlContainsAxesInfo) {
		this.valueXmlContainsAxesInfo = valueXmlContainsAxesInfo;
	}

	// ********** static���\�b�h **********

	/**
	 * �A�v���P�[�V�����̋��ʐݒ������킷�I�u�W�F�N�g���擾���܂��B
	 * @return ���̃N���X�̃I�u�W�F�N�g
	 */
	public static CommonSettings getCommonSettings() {
		return commonSettings;
	}

	// ********** ���\�b�h **********

	/**
	 * ���W���[�����o�[�^�C�v�I�u�W�F�N�g���Z�b�g����B
	 * @param measureMemberType ���W���[�����o�[�^�C�v�I�u�W�F�N�g
	 */
	public void addMeasureMemberTypeList(MeasureMemberType measureMemberType) {
		this.measureMemberTypeList.add(measureMemberType);
	}

	/**
	 * ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̃��X�g���Z�b�g����B
	 * @param measureMemberTypeList ���W���[�����o�[�^�C�v�I�u�W�F�N�g�̃��X�g
	 */
	public void addMeasureMemberTypeList(ArrayList<MeasureMemberType> measureMemberTypeList) {
		if(measureMemberTypeList == null) { throw new IllegalArgumentException(); }

		Iterator it = measureMemberTypeList.iterator();
		while (it.hasNext()) {
			MeasureMemberType measureMemberType = null;
			Object obj = (Object) it.next();
			if (obj instanceof MeasureMemberType) {
				measureMemberType = (MeasureMemberType) obj;
			} else {
				throw new IllegalArgumentException();
			}
			this.measureMemberTypeList.add(measureMemberType);
		}
	}

	/**
	 * �^�������W���[�����o�^�C�vID��胁�W���[�����o�^�C�v�I�u�W�F�N�g�����߂�B
	 * @param typeId ���W���[�����o�^�C�vID
	 * @return ���W���[�����o�^�C�v�I�u�W�F�N�g
	 */
	public MeasureMemberType getMeasureMemberTypeByID(String typeId) {
		Iterator<MeasureMemberType> it = this.measureMemberTypeList.iterator();
		while (it.hasNext()){
			MeasureMemberType measureMemberType = it.next();
			if(typeId.equals(measureMemberType.getId())) {
				return measureMemberType;
			}
		}
		return null;
	}

	/**
	 * ���W���[�����o�^�C�v�I�u�W�F�N�g���X�g�̐擪�̃I�u�W�F�N�g�����߂�B
	 * @return ���W���[�����o�^�C�v�I�u�W�F�N�g
	 */
	public MeasureMemberType getFirstMeasureMemberType() {
		return (MeasureMemberType)measureMemberTypeList.get(0);
	}

	// ********** Getter ���\�b�h **********

	/**
	 * ���W���[�����o�^�C�v�I�u�W�F�N�g���X�g�����߂�B
	 * @return ���W���[�����o�^�C�v�I�u�W�F�N�g�̃��X�g
	 */
	public ArrayList<MeasureMemberType> getMeasureMemberTypeList() {
		return measureMemberTypeList;
	}

	/**
	 * �lXML�Ɏ������܂߂�ꍇ��true�A�܂߂Ȃ��ꍇ��false��߂��B
	 * �i�����F��ID����у����o�[�L�[�̑g�ݍ��킹�j
	 * @return �lXML�Ɏ����j���܂߂邩
	 */
	public boolean getValueXmlContainsAxesInfo() {
		return valueXmlContainsAxesInfo;
	}


}
