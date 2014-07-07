/*  OpenOlap viewer
 *  �p�b�P�[�W���Fopenolap.viewer
 *  �t�@�C���FTimeDimensionInfo.java
 *  �����F���ԃf�B�����V�����̏����`����N���X�ł��B
 *
 *  �X�V��: 2004/01/06
 */
package openolap.viewer.common;

/**
 *  �N���X�FTimeDimension<br>
 *  �����F���ԃf�B�����V�����̏����`����N���X�ł��B
 */
public class TimeDimensionInfo {

	// ========== �N���X�ϐ� ==========

	// ���Ԏ��̕\����

	/** year�̕\����������킷������ */
	private static String yearLevelString    = "�N";

	/** half�̕\����������킷������ */
	private static String halfLevelString    = "����";

	/** quarter�̕\����������킷������ */
	private static String quarterLevelString = "�l����";

	/** month�̕\����������킷������ */
	private static String monthLevelString   = "��";

	/** week�̕\����������킷������ */
	private static String weekLevelString    = "�T";

	/** day�̕\����������킷������ */
	private static String dayLevelString     = "��";


	// ========== �ÓI�b�h ==========

	/**
	 * �^����ꂽ���Ԏ��̃����o�[�̃��j�[�N�Ȗ��̂�uniqueKey�����Ƃɐ�������B
	 * @param timeLevel 
	 */
	public static String timekeyToName(String timeKey){

		if ("0".equals(timeKey)) {
			return "���v";
		} 

	  String timeKind = timeKey.substring(8,9);
	  String retTime="";
	  switch(Integer.parseInt(timeKind)){
	  case 1://Year
		  retTime = timeKey.substring(0,4) + "";
		  break;
	  case 2://Half
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,5) + "H";
		  break;
	  case 3://Quarter
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,5) + "Q";
		  break;
	  case 4://Month
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,6) + "M";
		  break;
	  case 5://Month Week
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,6) + "-"+ timeKey.substring(6,7) + "W";
		  break;
	  case 6://Year Week
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,6) + "W";
		  break;
	  case 7://Day
		  retTime = timeKey.substring(0,4) + "-" + timeKey.substring(4,6) + "-"+ timeKey.substring(6,8) + "D";
		  break;
	  }
	  return retTime;

	}


	// ========== ���\�b�h ==========

	/**
	 * �^����ꂽ���Ԏ��̃��x���̖��̂����Ƃɕ\���������߂�B
	 * @param timeLevel 
	 */
	public String getTimeLevelDisplayString( String timeLevel ) {
		if(timeLevel == null){ throw new IllegalArgumentException(); }

		if ( timeLevel.equals("year") ) {
			return yearLevelString;
		} else if ( timeLevel.equals("half") ) {
			return halfLevelString;
		} else if ( timeLevel.equals("quarter") ) {
			return quarterLevelString;
		} else if ( timeLevel.equals("month") ) {
			return monthLevelString;
		} else if ( timeLevel.equals("week") ) {
			return weekLevelString;
		} else if ( timeLevel.equals("day") ) {
			return dayLevelString;
		} else {
			throw new IllegalArgumentException();
		}
	}

}
