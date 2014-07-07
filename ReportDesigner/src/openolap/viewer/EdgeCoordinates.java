/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FEdgeCoordinates.java
 *  �����F��܂��͍s�w�b�_�̍��W��\���I�u�W�F�N�g�ł��B
 *
 *  �쐬��: 2004/01/19
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;

import openolap.viewer.common.StringUtil;

/**
 *  �N���X�FEdgeCoordinates<br>
 *  �����F��܂��͍s�w�b�_�̍��W��\���I�u�W�F�N�g�ł��B
 */
public class EdgeCoordinates implements Serializable {

	// ********** �C���X�^���X�ϐ� **********

	/** ��܂��͍s�̃C���f�b�N�X(��܂��͍s�ɑ΂��Ĉ�ӂɂȂ�0start�̒ʔ�) */
	final private Integer index;

	/** ��܂��͍s�̊e�i�̎�ID��KEY�Ƃ��A�������o�[�̃L�[��VALUE�Ɏ���Map�I�u�W�F�N�g */
	final private LinkedHashMap<Integer, String> axisIdMemKeyMap;


	// ********** �R���X�g���N�^ **********

	/**
	 * ��܂��͍s�w�b�_�̍��W��\���I�u�W�F�N�g�𐶐����܂��B
	 */
	public EdgeCoordinates(Integer index, LinkedHashMap<Integer, String> axisIdMemKeyMap) {
		this.index = index;
		this.axisIdMemKeyMap = axisIdMemKeyMap;
	}

	// ********** Static ���\�b�h **********

	/**
	 * ��܂��͍s�w�b�_�̍��W��\���I�u�W�F�N�g�̃��X�g�����߂�
	 * @param indexKey ��܂��͍s�ň�ӂɒ�܂�SpreadIndex�ƁA�e�i�̃����o�[�L�[�̑g�ݍ��킹�̃��X�g<br>
	 *        �����F<index>:<1�i�ڂ�key>;<2�i�ڂ�key>;<3�i�ڂ�key>,<index>:<1�i�ڂ�key>;<2�i�ڂ�key>;<3�i�ڂ�key>,���<br>
	 *        ���s�܂��͗񂪂R�i�����̏ꍇ�Y������key�̉ӏ��͋󕶎�
	 * @param axisIdList �s�܂��͗�ɔz�u���ꂽ��ID�̔z��i���я��̓G�b�W���̔z�u���j
	 * @return ��܂��͍s�w�b�_�̍��W��\���I�u�W�F�N�g�̃��X�g
	 */
	public static ArrayList<EdgeCoordinates> createCoordinates(String indexKey, String[] axisIdList) {

		ArrayList<EdgeCoordinates> axisCoordinatesList = new ArrayList<EdgeCoordinates>();	// �����W���X�g
		EdgeCoordinates axisCoordinates = null;				// �����W

		Iterator<String> axisIt = StringUtil.splitString(indexKey,",").iterator();
		while (axisIt.hasNext()) {
			LinkedHashMap<Integer, String> axisIdKeyMap = new LinkedHashMap<Integer, String>();

			String indexKeysString = axisIt.next();
			ArrayList<String> indexKeysList = StringUtil.splitString(indexKeysString,":");
			Integer axisIndex = Integer.decode(indexKeysList.get(0));	// ��̃C���f�b�N�X
			String colKeys    = indexKeysList.get(1);							// ��̃L�[�̑g�ݍ��킹(������)
			ArrayList<String> axisKeyList = StringUtil.splitString(colKeys,";");			// ��̃L�[�̑g�ݍ��킹(�z��)

			Iterator<String> keyListIte = axisKeyList.iterator();
			int j = 0;
			while (keyListIte.hasNext()){
				String key = keyListIte.next();
				axisIdKeyMap.put(Integer.decode(axisIdList[j]), key);
				j++;
			}
			axisCoordinatesList.add(new EdgeCoordinates(axisIndex, axisIdKeyMap));
		}

		return axisCoordinatesList;
	}

	// ********** Getter ���\�b�h **********

	/**
	 * ��܂��͍s�̃C���f�b�N�X�����߂�B
	 * (��܂��͍s�ɑ΂��Ĉ�ӂɂȂ�0start�̒ʔ�) 
	 * @return ��܂��͍s�̃C���f�b�N�X
	 */
	public Integer getIndex() {
		return index;
	}

	/**
	 * ��܂��͍s�̊e�i�̎�ID��KEY�Ƃ��A�������o�[�̃L�[��VALUE�Ɏ���Map�I�u�W�F�N�g�����߂�B
	 * @return ��܂��͍s�̊e�i�̎�ID��KEY�Ƃ��A�������o�[�̃L�[��VALUE�Ɏ���Map�I�u�W�F�N�g
	 */
	public LinkedHashMap<Integer, String> getAxisIdMemKeyMap() {
		return axisIdMemKeyMap;
	}
}
