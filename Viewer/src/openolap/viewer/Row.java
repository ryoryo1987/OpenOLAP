/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FRow.java
 *  �����F�s������킷�N���X�ł��B
 *
 *  �쐬��: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  �N���X�FRow<br>
 *  �����F�s������킷�N���X�ł��B
 */
public class Row  extends Edge implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �s������킷������ */
	final private String position = Constants.Row;

	// ********** �R���X�g���N�^ **********

	/**
	 * �s�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Row(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * �s�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Row(Axis axis) {
		super(axis);
	}
	
	// ********** Getter ���\�b�h **********

	/**
	 * �s������킷����������߂�B
	 * @return �s������킷������
	 */
	public String getPosition() {
		return position;
	}

}
