/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FCol.java
 *  �����F�������킷�N���X�ł��B
 *
 *  �쐬��: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  �N���X�FCol<br>
 *  �����F�������킷�N���X�ł��B
 */
public class Col extends Edge implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �������킷������ */
	final private String position = Constants.Col;


	// ********** �R���X�g���N�^ **********

	/**
	 * ��I�u�W�F�N�g�𐶐����܂��B
	 */
	public Col(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * ��I�u�W�F�N�g�𐶐����܂��B
	 */
	public Col(Axis axis) {
		super(axis);
	}

	// ********** Getter ���\�b�h **********

	/**
	 * �������킷����������߂�B
	 * @return �������킷������
	 */
	public String getPosition() {
		return position;
	}

}
