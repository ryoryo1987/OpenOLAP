/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer.common
 *  �t�@�C���FStringUtil.java
 *  �����F�����񑀍샆�[�e�B���e�B�[�N���X�ł��B
 *
 *  �쐬��: 2004/01/09
 */
package openolap.viewer.common;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *  �N���X�FStringUtil<br>
 *  �����F�����񑀍샆�[�e�B���e�B�[�N���X�ł��B
 */
public class StringUtil {

	// ********** static���\�b�h **********

	/**
	 * �^����ꂽString�I�u�W�F�N�g��null�ł���΁A�󕶎�("")�ɕύX����B
	 * @param string String�I�u�W�F�N�g
	 * @return String�I�u�W�F�N�g
	 */
	public static String changeNullToEmpty(String string) {
		if(string == null){
			return "";
		} else {
			return string;
		}
	}

	/**
	 * �^����ꂽString�I�u�W�F�N�g�̑O���"<"�A">"�ł��������������߂��B
	 * @param string String�I�u�W�F�N�g
	 * @return String�I�u�W�F�N�g
	 */
	public static String addStartTAGMark(String string) {
		return "<" + string + ">";
	}

	/**
	 * �^����ꂽString�I�u�W�F�N�g�̑O���"</"�A">"�ł��������������߂��B
	 * @param string String�I�u�W�F�N�g
	 * @return String�I�u�W�F�N�g
	 */
	public static String addEndTAGMark(String string){
		return "</" + string + ">";
	}

	/**
	 * ������Ɋ܂܂��u*�v���A�S�āu%�v�ɒu������B
	 * @param string String�I�u�W�F�N�g
	 * @return String�I�u�W�F�N�g
	 */
	public static String changeKomeToPercent(String string) {
		return string.replace('*', '%');
	}

	/**
	 * ���K�\���ɂ�蕶����̒u�����s���A�u�����ꂽ�������Ԃ��B<br>
	 * �}�b�`������̂͂��ׂĒu������
	 * @param preString �u���������s��������̒��Œu���ΏۂƂȂ镶���i���K�\���j
	 * @param afterString prString��u�������镶��
	 * @param string �u���������s��������
	 * @return �u�����ꂽ������
	 */
	public static String regReplaceAll(String preString, String afterString, String string) {
		Pattern pattern = Pattern.compile(preString);
		Matcher matcher = pattern.matcher(string);
		return matcher.replaceAll(afterString);
	}

	/**
	 * �������^����ꂽ�f���~�^�ŕ������AArrayList��Ԃ�
	 *   ���l�F�u0;;�v���f���~�^�u;�v�ŕ�������ƁA
	 *          list[0]=0 �ł���size()=1 ��ArrayList�ƂȂ�
	 * @param string �����Ώە�����
	 * @param delimiter �f���~�^
	 * @return �������ꂽ������̃��X�g
	 */
	public static ArrayList<String> splitString(String string, String delimiter) {
		ArrayList<String> list = new ArrayList<String>();
		StringTokenizer st = new StringTokenizer(string,delimiter);
		while ( st.hasMoreTokens() ) {
			list.add(st.nextToken());
		}
		return list;
	}

	/**
	 * �����̕�������i�[����ArrayList����A�w�肳�ꂽ�f���~�^�ŋ�؂�ЂƂ̕�����𐶐�����
	 * @param stringList ������̃��X�g
	 * @param delimiter �f���~�^
	 * @return �������ꂽ������
	 */
	public static String joinList(ArrayList<String> stringList, String delimiter) {
		if (stringList == null) {
			throw new IllegalArgumentException();
		}

		String returnString = "";
		Iterator<String> iter = stringList.iterator();
		int i = 0;
		while (iter.hasNext()) {
			if(i>0) {
				returnString += delimiter;
			}
			returnString += iter.next();
			i++;
		}
		return returnString;
	}


	/**
	 * �����̕�������i�[����ArrayList����A�^����ꂽ��������܂܂Ȃ���������擾����
	 * @param stringList ������̃��X�g
	 * @param exceptString ���O���镶����
	 * @return ������̃��X�g
	 */
	public static ArrayList<String> exceptElement(ArrayList<String> stringList, String exceptString) {
		if (stringList == null) {
			throw new IllegalArgumentException();
		}

		ArrayList<String> exceptedList = new ArrayList<String>();
		Iterator<String> iter = stringList.iterator();
		while (iter.hasNext()) {
			String string = iter.next();
			if (string.indexOf(exceptString) == -1) {
				exceptedList.add(string);
			}
		}
		return exceptedList;
	}


	/**
	 * ������̐ړ��������͐ڔ��Ɏw�肳�ꂽ���̎w�肳�ꂽ�������t�^����
	 * @param str �t�^�O�̕�����
	 * @param position ������t�^����ꏊ���ړ����ݔ������w�肷��
	 * @param repeatNumber �t�^���鐔���w�肷��
	 * @param repeatString �J��Ԃ�������
	 * @return �t�^���ꂽ�����񃊃X�g
	 */
	public static String addString(String str, String position, int repeatNumber, String repeatString) {
		if ( (position == null) || (repeatString == null) ) { throw new IllegalArgumentException(); }
		if ( (!position.equals("last")) && (!position.equals("first")) ) { throw new IllegalArgumentException(); }
		if ( repeatNumber<0 ) { throw new IllegalArgumentException(); }

		String addedString = str;
		if (position.equals("last")) {
			for (int i = 0; i < repeatNumber; i++) {
				addedString = addedString + repeatString;
			}
		} else if (position.equals("first")) {
			for (int i = 0; i < repeatNumber; i++) {
				addedString = repeatString + addedString;
			}
		}

		return addedString;
	}

}
