/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FColor.java
 *  �����F�s�E��w�b�_����уf�[�^�e�[�u���̃Z���ɂ���ꂽ�F������킷�N���X�ł��B
 *
 *  �쐬��: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.TreeMap;

/**
 *  �N���X�FColor<br>
 *  �����F�s�E��w�b�_����уf�[�^�e�[�u���̃Z���ɂ���ꂽ�F������킷�N���X�ł��B
 */
public class Color implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** �F�Â����Ă���Z���̍��W�i����ID�Ƃ��̎������oKEY�̑g�ݍ��킹�j */
	final private TreeMap<Integer, String> axisIDAndMemberKeyMap;

	/** �s�E��w�b�_�ɂ���ꂽ�F�� */
	final private boolean isHeader;

	/** �F�̖��� */
	private String htmlColor  = null;
	
	// ********** �R���X�g���N�^ **********

	/**
	 * �F�I�u�W�F�N�g�𐶐����܂��B
	 */
	public Color(TreeMap<Integer, String> axisIDAndMemberKeyMap, boolean isHeader, String htmlColor) {
		this.axisIDAndMemberKeyMap = axisIDAndMemberKeyMap;
		this.isHeader = isHeader;
		this.htmlColor = htmlColor;
	}


	// ********** Setter ���\�b�h **********

	/**
	 * �F�̖��̂��Z�b�g����B
	 * @param htmlColor �F�̖���
	 */
	public void setHtmlColor(String htmlColor) {
		this.htmlColor = htmlColor;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * �F�Â����Ă���Z���̍��W�i����ID�Ƃ��̎������oKEY�̑g�ݍ��킹�j�����߂�B
	 * @return �Z���̍��W�i����ID�Ƃ��̎������oKEY�̑g�ݍ��킹�j
	 */
	public TreeMap<Integer, String> getAxisIDAndMemberKeyMap() {
		return axisIDAndMemberKeyMap;
	}

	/**
	 * �F�̖��̂����߂�B
	 * @return �F�̖���
	 */
	public String getHtmlColor() {
		return htmlColor;
	}

	/**
	 * �s�E��w�b�_�̃Z���ɂ���ꂽ�F�ł����true�A�f�[�^�e�[�u���̃Z���ɂ���ꂽ�F�ł����false��߂��B
	 * @return �s�E��w�b�_�̃Z���ɂ���ꂽ�F��
	 */
	public boolean isHeader() {
		return isHeader;
	}

}
