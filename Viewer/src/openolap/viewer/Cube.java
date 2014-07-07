/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FCube.java
 *  �����F�L���[�u������킷�N���X�ł��B
 *
 *  �쐬��: 2004/01/08
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  �N���X�FCube<br>
 *  �����F�L���[�u������킷�N���X�ł��B
 */
public class Cube implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �L���[�u�̃V�[�P���X�ԍ� */
	final private String cubeSeq;

	/** �L���[�u�� */
	final private String cubeName;

	// ********** �R���X�g���N�^ **********

	/**
	 * �L���[�u�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Cube(String cubeSeq, String cubeName){
		this.cubeSeq = cubeSeq;
		this.cubeName = cubeName;
	}



	// ********** ���\�b�h **********

	/**
	 * ���̃C���X�^���X�̕�����\�������߂�B
	 * @return String�I�u�W�F�N�g
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "cubeSeq:" + this.cubeSeq + sep;
		stringInfo += "cubeName:" + this.cubeName + sep;

		return stringInfo;

	}

	// ********** Getter ���\�b�h **********

	/**
	 * �L���[�u�̃V�[�P���X�ԍ������߂�B
	 * @return �L���[�u�̃V�[�P���X�ԍ�
	 */
	public String getCubeSeq() {
		return cubeSeq;
	}

	/**
	 * �L���[�u�������߂�B
	 * @return �L���[�u��
	 */
	public String getCubeName() {
		return cubeName;
	}


}
