/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FAxisLevel.java
 *  �����F���̃��x��������킷�N���X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FAxisLevel<br>
 *  �����F���̃��x��������킷�N���X�ł��B
 */
public class AxisLevel implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ���x��(���̃��x���������x���ڂ�������킷1start�̐�) */
	final private String levelNumber;

	/** ���� */
	final private String name;

	/** �R�����g */
	final private String comment;


	// ********** �R���X�g���N�^ **********

	/**
	 *  ���̃��x��������킷�I�u�W�F�N�g�𐶐����܂��B
	 */
	public AxisLevel(String levelNumber, String name, String comment) {
		this.levelNumber = levelNumber;
		this.name = name;
		this.comment = comment;
	}


	// ********** Getter ���\�b�h **********

	/**
	 * ���x��(���̃��x���������x���ڂ�������킷1start�̐�)�����߂�B
	 * @return ���x��
	 */
	public String getLevelNumber() {
		return levelNumber;
	}
	/**
	 * ���x���̖��̂����߂�B
	 * @return ���x���̖���
	 */
	public String getName() {
		return name;
	}
	/**
	 * ���x���̃R�����g�����߂�B
	 * @return ���x���̃R�����g
	 */
	public String getComment() {
		return comment;
	}

}
