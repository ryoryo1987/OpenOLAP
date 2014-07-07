/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.common
 *  ファイル：StringUtil.java
 *  説明：文字列操作ユーティリティークラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.common;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *  クラス：StringUtil<br>
 *  説明：文字列操作ユーティリティークラスです。
 */
public class StringUtil {

	// ********** staticメソッド **********

	/**
	 * 与えられたStringオブジェクトがnullであれば、空文字("")に変更する。
	 * @param string Stringオブジェクト
	 * @return Stringオブジェクト
	 */
	public static String changeNullToEmpty(String string) {
		if(string == null){
			return "";
		} else {
			return string;
		}
	}

	/**
	 * 与えられたStringオブジェクトの前後を"<"、">"でくくった文字列を戻す。
	 * @param string Stringオブジェクト
	 * @return Stringオブジェクト
	 */
	public static String addStartTAGMark(String string) {
		return "<" + string + ">";
	}

	/**
	 * 与えられたStringオブジェクトの前後を"</"、">"でくくった文字列を戻す。
	 * @param string Stringオブジェクト
	 * @return Stringオブジェクト
	 */
	public static String addEndTAGMark(String string){
		return "</" + string + ">";
	}

	/**
	 * 文字列に含まれる「*」を、全て「%」に置換する。
	 * @param string Stringオブジェクト
	 * @return Stringオブジェクト
	 */
	public static String changeKomeToPercent(String string) {
		return string.replace('*', '%');
	}

	/**
	 * 正規表現により文字列の置換を行い、置換された文字列を返す。<br>
	 * マッチするものはすべて置換する
	 * @param preString 置換処理を行う文字列の中で置換対象となる文字（正規表現）
	 * @param afterString prStringを置き換える文字
	 * @param string 置換処理を行う文字列
	 * @return 置換された文字列
	 */
	public static String regReplaceAll(String preString, String afterString, String string) {
		Pattern pattern = Pattern.compile(preString);
		Matcher matcher = pattern.matcher(string);
		return matcher.replaceAll(afterString);
	}

	/**
	 * 文字列を与えられたデリミタで分割し、ArrayListを返す
	 *   備考：「0;;」をデリミタ「;」で分割すると、
	 *          list[0]=0 であるsize()=1 のArrayListとなる
	 * @param string 分割対象文字列
	 * @param delimiter デリミタ
	 * @return 分割された文字列のリスト
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
	 * 複数の文字列を格納したArrayListから、指定されたデリミタで区切るひとつの文字列を生成する
	 * @param stringList 文字列のリスト
	 * @param delimiter デリミタ
	 * @return 結合された文字列
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
	 * 複数の文字列を格納したArrayListから、与えられた文字列を含まない文字列を取得する
	 * @param stringList 文字列のリスト
	 * @param exceptString 除外する文字列
	 * @return 文字列のリスト
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
	 * 文字列の接頭もしくは接尾に指定された数の指定された文字列を付与する
	 * @param str 付与前の文字列
	 * @param position 文字を付与する場所が接頭か設備かを指定する
	 * @param repeatNumber 付与する数を指定する
	 * @param repeatString 繰り返す文字列
	 * @return 付与された文字列リスト
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
