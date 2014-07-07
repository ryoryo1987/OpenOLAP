/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FCellData.java
 *  �����F���|�[�g�̃Z���f�[�^������킷�N���X�ł��B
 *
 *  �쐬��: 2004/01/19
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.*;


/**
 *  �N���X�FCellData
 *  �����F���|�[�g�̃Z���f�[�^������킷�N���X�ł��B
 */
public class CellData implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ��̍��W��\���I�u�W�F�N�g */
	final private EdgeCoordinates colCoordinates;

	/** �s�̍��W��\���I�u�W�F�N�g */
	final private EdgeCoordinates rowCoordinates;

	/** ���̃f�[�^�������郁�W���[�����o�[��UniqueName(viewer���U��A0����̒ʔ�) */
	final private String measureMemberUniqueName;

	/** ���̃f�[�^�������郁�W���[�����o�[�̃��W���[�V�[�P���X�ԍ� */
	final private String measureSeq;
	
	/** �Z�������l */
	private String value = null;

	// ********** �R���X�g���N�^ **********

	/**
	 * �Z���f�[�^�I�u�W�F�N�g�𐶐����܂��B
	 */
	public CellData(EdgeCoordinates colCoordinates, EdgeCoordinates rowCoordinates, String measureMemberUniqueName, String measureSeq) {
		this.colCoordinates = colCoordinates;
		this.rowCoordinates = rowCoordinates;
		this.measureMemberUniqueName = measureMemberUniqueName;
		this.measureSeq = measureSeq;
	}

	// ********** Setter ���\�b�h **********

	/**
	 * �Z���f�[�^�ɒl���Z�b�g����B
	 * @param string �Z���f�[�^�̒l
	 */
	public void setValue(String string) {
		value = string;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * �Z���̗���W�I�u�W�F�N�g�����߂�B
	 * @return ����W�I�u�W�F�N�g
	 */
	public EdgeCoordinates getColCoordinates() {
		return colCoordinates;
	}

	/**
	 * �Z���̍s���W�I�u�W�F�N�g�����߂�B
	 * @return �s���W�I�u�W�F�N�g
	 */
	public EdgeCoordinates getRowCoordinates() {
		return rowCoordinates;
	}

	/**
	 * �Z���̒l�����߂�B
	 * �ʉ݋L���A�J���}�L���A�P�ʏ��́A���W���[�����o�[�̐ݒ�ɏ]���B
	 * @return �Z�������l
	 */
	public String getValue() {
		return value;
	}

	/**
	 * �Z���̒l��ʉ݋L���A�J���}�����t�H�[�}�b�g�ŋ��߂�B
	 * �Ȃ��A���W���[�����o�[�ɑ΂���P�ʐݒ�͈����p�����B
	 *   �� (�P�ʁF�~)�F	\3,000,000 �� 3000000
	 *      (�P�ʁF�S�~)�F	\3,000 �� 3000  
	 * @return �Z�������l�i�ʉ݋L���A�J���}�����t�H�[�}�b�g�j
	 */
	public String getValue2() {
		return replace(replace(value,"��",""),",","");
	}

	/**
	 * ���̃f�[�^�������郁�W���[�����o�[��UniqueName�����߂�B
	 * @return ���W���[�����o�[��UniqueName(viewer���U��A0����̒ʔ�)
	 */
	public String getMeasureMemberUniqueName() {
		return measureMemberUniqueName;
	}

	/**
	 * ���̃f�[�^�������郁�W���[�����o�[��measureSeq�����߂�B
	 * @return ���W���[�����o�[��measureSeq
	 */
	public String getMeasureSeq() {
		return measureSeq;
	}



	/**
	*�������u�����܂��B
	*@param strTarget �Ώە�����
	*@param strOldStr �u���Ώە�����
	*@param strOldNew �u�������镶����
	*@return strResult �u�����ꂽ������
	*/
	private static String replace(String strTarget, String strOldStr, String strOldNew){
	    String strSplit[];
	    String strResult;

	    strSplit = split(strTarget, strOldStr);
	    strResult = strSplit[0];
	    for (int i = 1; i < strSplit.length; i ++){
	        strResult += strOldNew + strSplit[i];
	    }

	    return strResult;
	}

	/**
	*replace���\�b�h�œ����I�Ɏg�p
	*/
	private static String[] split(String strTarget, String strDelimiter){
	    String strResult[];
	    Vector<String> objResult;
	    int intDelimiterLen;
	    int intStart;
	    int intEnd;

	    objResult = new java.util.Vector<String>();
	    strTarget += strDelimiter;
	    intDelimiterLen = strDelimiter.length();
	    intStart = 0;
	    while ((intEnd = strTarget.indexOf(strDelimiter, intStart)) >= 0){
	        objResult.addElement(strTarget.substring(intStart, intEnd));
	        intStart = intEnd + intDelimiterLen;
	    }

	    strResult = new String[objResult.size()];
	    objResult.copyInto(strResult);
	    return strResult;
	}


}
