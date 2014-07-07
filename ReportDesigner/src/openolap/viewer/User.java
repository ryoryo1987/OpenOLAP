/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FUser.java
 *  �����F���[�U�[������킷�N���X�ł��B
 *  �쐬��: 2003/12/28
 */

package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FUser<br>
 *  �����F���[�U�[������킷�N���X�ł��B
 */
public class User implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ���[�UID */
	final private String userID;

	/** ���[�U�� */
	final private String name;

	/** 
	 * ���[�U�[�̑����^�C�v
	 * oo_v_user�e�[�u����adminflg�̒l 
	 *    ��adminflg�̒l�̈Ӗ���<BR>
	 *     �u1�v�F�Ǘ��҂ł���A�L���[�u�����{���|�[�g�̍쐬���\<BR>
	 *            ���l���|�[�g�͍쐬�ł��Ȃ�<BR>
	 *             �i��{���|�[�g�̏㏑���ƂȂ�j<BR>
	 *     �u2�v�F��ʃ��[�U�ł���A�l���|�[�g�̕ۑ����\<BR>
	 *     �u3�v�F��ʃ��[�U�ł���A�l���|�[�g�̕ۑ��͕s�\<BR>
	 * */
	final private String adminFLG;

	/** �G�N�X�|�[�g����t�@�C���̎��(CSV �������� XML spreadsheet Schema �`��) */
	private String exportFileType;


	/** �J���[�X�^�C���� */
	private String colorStyleName;

	/** �J���[�X�^�C���ispreadStyle�̃t�@�C�����j */
	private String spreadStyleFile;

	/** �J���[�X�^�C���icellColorTable�̃t�@�C�����j */
	private String cellColorTableFile;


	// ********** �R���X�g���N�^ **********

	/**
	 * ���[�U�[�I�u�W�F�N�g�𐶐����܂��B
	 */
	public User(String userID, String name, String adminFLG, String exportFileType, String colorStyleName, String spreadStyleFile, String cellColorTableFile) {
		this.userID = userID;
		this.name = name;
		this.adminFLG = adminFLG;
		this.exportFileType = exportFileType;
		this.colorStyleName = colorStyleName;
		this.spreadStyleFile = spreadStyleFile;
		this.cellColorTableFile = cellColorTableFile;
	}

	// ********** ���\�b�h **********
	/**
	 * �Ǘ��҃��[�U�[�ł����true�A��ʃ��[�U�[�ł����false��߂��B
	 * @return �Ǘ��҃��[�U�[��
	 */
	public boolean isAdmin() {
		if ("1".equals(this.adminFLG)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * ���̃��[�U���l���|�[�g�̕ۑ����������ꍇtrue�A�����Ȃ��ꍇ��false��߂��B
	 * @return
	 */
	public boolean isPersonalReportSavable() {

		if ("2".equals(this.adminFLG)) {
			return true;
		} else {
			return false;
		}

	}

	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "User.userID:" + this.userID + sep;
		stringInfo += "User.name:" + this.name + sep;
		stringInfo += "User.adminFLG:" + this.adminFLG + sep;
		stringInfo += "User.exportFileType:" + this.exportFileType + sep;
		
		return stringInfo;

	}

	// ********** Setter ���\�b�h **********
	/**
	 * �G�N�X�|�[�g����t�@�C���̃^�C�v��ݒ肷��B
	 * @param �G�N�X�|�[�g�^�C�v
	 */
	public void setExportFileType(String exportFileType) {
		this.exportFileType = exportFileType;
	}

	/**
	 * �J���[�X�^�C���������߂�B
	 * @param �J���[�X�^�C����
	 */
	public void setColorStyleName(String colorStyleName) {
		this.colorStyleName = colorStyleName ;
	}

	/**
	 * �X�v���b�h�X�^�C���̃t�@�C���������߂�B
	 * @param �X�v���b�h�X�^�C���̃t�@�C����
	 */
	public void setSpreadStyleFile(String spreadStyleFile) {
		this.spreadStyleFile = spreadStyleFile;
	}

	/**
	 * �Z���J���[�e�[�u���t�@�C���̃t�@�C���������߂�B
	 * @param �Z���J���[�e�[�u���t�@�C���̃t�@�C����
	 */
	public void setCellColorTableFile(String cellColorTableFile) {
		this.cellColorTableFile = cellColorTableFile;
	}


	// ********** Getter ���\�b�h **********

	/**
	 * ���[�U�[ID�����߂�B
	 * @return ���[�U�[ID
	 */
	public String getUserID() {
		return userID;
	}

	/**
	 * ���[�U�[�������߂�B
	 * @return ���[�U�[��
	 */
	public String getName() {
		return name;
	}


	/**
	 * ���[�U�̑����^�C�v�����߂�B
	 * @return ���[�U�̑����^�C�v
	 */
	public String getAdminFLG() {
		return adminFLG;
	}

	/**
	 * �G�N�X�|�[�g����t�@�C���̃^�C�v�����߂�B
	 * @return �G�N�X�|�[�g�^�C�v
	 */
	public String getExportFileType() {
		return exportFileType;
	}

	/**
	 * �J���[�X�^�C���������߂�B
	 * @return �J���[�X�^�C����
	 */
	public String getColorStyleName() {
		return colorStyleName;
	}

	/**
	 * �X�v���b�h�X�^�C���̃t�@�C���������߂�B
	 * @return �X�v���b�h�X�^�C���̃t�@�C����
	 */
	public String getSpreadStyleFile() {
		return spreadStyleFile;
	}

	/**
	 * �Z���J���[�e�[�u���t�@�C���̃t�@�C���������߂�B
	 * @return �Z���J���[�e�[�u���t�@�C���̃t�@�C����
	 */
	public String getCellColorTableFile() {
		return cellColorTableFile;
	}


}
