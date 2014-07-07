/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FMeasure.java
 *  �����F���W���[������킷�N���X�ł��B
 *
 *  �쐬��: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

/**
 *  �N���X�FMeasure<br>
 *  �����F���W���[������킷�N���X�ł��B
 */
public class Measure extends Axis implements Serializable {

	// ********** �R���X�g���N�^ **********

	/**
	 * ���W���[��\���I�u�W�F�N�g�𐶐����܂��B
	 */
	public Measure(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter) {
		super(id, name, comment, axisLevelList, defaultMemberKey, isMeasure, isUsedSelecter);
	}

}
