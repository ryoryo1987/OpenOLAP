/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FSecurity.java
 *  �����F���[�U�[�ƃ��|�[�g�̃Z�L�����e�B�̊֘A������킷�N���X�ł��B
 *  �쐬��: 2003/12/28
 */

package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FSecurity<br>
 *  �����F���[�U�[�ƃ��|�[�g�̃Z�L�����e�B�̊֘A������킷�N���X�ł��B
 */
public class Security implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ���|�[�g�̎Q�ƌ��������邩 */
	final private boolean reportViewable;

	/** ���|�[�g�̃G�N�X�|�[�g���������邩 */
	final private boolean reportExportable;

	// ********** �R���X�g���N�^ **********

	/**
	 * ���[�U�[�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Security(boolean reportViewable, boolean reportExportable) {
		this.reportViewable = reportViewable;
		this.reportExportable = reportExportable;
	}

	// ********** ���\�b�h **********

	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Security.reportViewable:" + this.reportViewable + sep;
		stringInfo += "Security.reportExportable:" + this.reportExportable + sep;
		
		return stringInfo;

	}

	// ********** Getter ���\�b�h **********

	/**
	 * ���|�[�g�̎Q�ƌ��������邩
	 * @return ���|�[�g�̎Q�ƌ���
	 */
	public boolean isReportViewable() {
		return this.reportViewable;
	}

	/**
	 * ���|�[�g�̃G�N�X�|�[�g���������邩
	 * @return ���|�[�g�̃G�N�X�|�[�g����
	 */
	public boolean isReportExportable() {
		return this.reportExportable;
	}


}
