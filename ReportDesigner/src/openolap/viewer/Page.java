/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FPage.java
 *  �����F�y�[�W������킷�N���X�ł��B
 *
 *  �쐬��: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  �N���X�FPage<br>
 *  �����F�y�[�W������킷�N���X�ł��B
 */
public class Page  extends Edge implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �y�[�W������킷������ */
	final private String position = Constants.Page;

	// ********** �R���X�g���N�^ **********

	/**
	 * �y�[�W�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Page(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * �y�[�W�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Page(Axis axis) {
		super(axis);
	}
	
	// ********** Getter ���\�b�h **********

	/**
	 * �y�[�W������킷����������߂�B
	 * @return �y�[�W������킷������
	 */
	public String getPosition() {
		return position;
	}

}
