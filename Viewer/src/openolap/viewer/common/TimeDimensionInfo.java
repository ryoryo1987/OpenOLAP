/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：TimeDimensionInfo.java
 *  説明：時間ディメンションの情報を定義するクラスです。
 *
 *  更新日: 2004/01/06
 */
package openolap.viewer.common;

/**
 *  クラス：TimeDimension<br>
 *  説明：時間ディメンションの情報を定義するクラスです。
 */
public class TimeDimensionInfo {

	// ========== クラス変数 ==========

	// 時間軸の表示名

	/** yearの表示名をあらわす文字列 */
	private static String yearLevelString    = "年";

	/** halfの表示名をあらわす文字列 */
	private static String halfLevelString    = "半期";

	/** quarterの表示名をあらわす文字列 */
	private static String quarterLevelString = "四半期";

	/** monthの表示名をあらわす文字列 */
	private static String monthLevelString   = "月";

	/** weekの表示名をあらわす文字列 */
	private static String weekLevelString    = "週";

	/** dayの表示名をあらわす文字列 */
	private static String dayLevelString     = "日";


	// ========== 静的ッド ==========

	/**
	 * 与えられた時間軸のメンバーのユニークな名称をuniqueKeyをもとに生成する。
	 * @param timeLevel 
	 */
	public static String timekeyToName(String timeKey){

		if ("0".equals(timeKey)) {
			return "合計";
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


	// ========== メソッド ==========

	/**
	 * 与えられた時間軸のレベルの名称をもとに表示名を求める。
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
