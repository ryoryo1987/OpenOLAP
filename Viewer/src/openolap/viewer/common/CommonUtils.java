/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.common
 *  ファイル：CommonUtils.java
 *  説明：ユーティリティクラスです。
 *
 *  作成日: 2004/01/14
 */
package openolap.viewer.common;

import java.util.ArrayList;
import java.util.Enumeration;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import openolap.viewer.Report;
import openolap.viewer.User;
import openolap.viewer.controller.RequestHelper;

import org.apache.log4j.Logger;

/**
 *  クラス：CommonUtils<br>
 *  説明：ユーティリティクラスです。
 */
public class CommonUtils {

	// ********** メソッド **********

	/**
	 * 与えられたbooleanがtrueであれば"1"、falseであれば"0"を戻す。
	 * @param b boolean
	 * @return "1"(true) あるいは "0"(false)
	 */
	public static String boolToFLG(boolean b){
		if (b){
			return "1";
		} else {
			return "0";
		}
	}

	/**
	 * 与えられたStringが"1"であればtrue、"0"であればfalseを戻す。
	 * @param sting Stringオブジェクト
	 * @return true("1") あるいは false("0")
	 */
	public static boolean FLGTobool(String string) {
		if ("1".equals(string)) {
			return true;
		} else {
			return false;
		}
	}


	/**
	 * 配列をArrayListに格納する。
	 * @param objects 配列
	 * @return ArrayListオブジェクト
	 */
	public static ArrayList<Object> arrayToArrayList(Object[] objects) {
		if (objects == null) {
			throw new IllegalArgumentException();
		}

		ArrayList<Object> arrayList = new ArrayList<Object>();
		for (int i = 0; i < objects.length; i++ ){
			arrayList.add(objects[i]);
		}
		return arrayList;
	}

	/**
	 * Exceptionより、StackTrace文字列を取得する。
	 * @param Exception 配列
	 * @return オブジェクト
	 */
	public static String getStackTrace(Exception e) {
		
		StackTraceElement[] stElement = e.getStackTrace();
		StringBuffer stb = new StringBuffer();
		for (int i=0; i<stElement.length; i++ ) {
			stb.append("    at " + stElement[i].toString() + "\n");
		}

		return stb.toString();
	}

	/**
	 * Requestより、KeyとValueをあらわす文字列を取得する。
	 * @param request リクエストオブジェクト
	 * @return StringBufferオブジェクト
	 */
	public static StringBuffer getRequestParameters(ServletRequest request) {

		StringBuffer params = new StringBuffer(512);
		String sep = System.getProperty("line.separator");

		params.append("Request Parameter Lists start ====================== " + sep);

		Enumeration e = request.getParameterNames();
		while (e.hasMoreElements()) {
			String attrName  = (String) e.nextElement();
			String attrValue = request.getParameter(attrName);
			
			params.append(attrName + ": " + attrValue + sep);
		}

		params.append("Request Parameter Lists end   ====================== " + sep);

		return params;
	}

	/**
	 * Session情報を取得する。
	 * @param request リクエストオブジェクト
	 * @return StringBufferオブジェクト
	 */
	public static StringBuffer getSessionParameters(HttpServletRequest request) {
		
		StringBuffer sessionInfo = new StringBuffer(512);
		String sep = System.getProperty("line.separator");
		
		sessionInfo.append("Session Information start ====================== " + sep);

		Enumeration e = request.getSession().getAttributeNames();
		while (e.hasMoreElements()) {
			String attrName  = (String) e.nextElement();
			String attrValue = request.getSession().getAttribute(attrName).toString();
			
			sessionInfo.append("<session attribue name>" + attrName + sep);
			sessionInfo.append(attrValue + sep);

		}

		sessionInfo.append("Session Information end   ====================== " + sep);
		
		return sessionInfo;
	}


	/**
	 * ログ情報を出力する。
	 * @param RequestHelper リクエストヘルパーオブジェクト
	 * @param log ロギングオブジェクト
	 * @param args1Key   主要なメッセージ
	 * @param args1Value 主要なメッセージの値
	 */
	public static void loggingMessage(RequestHelper helper, Logger log, String args1Key, String args1Value) {
		
		if(log.isInfoEnabled()) {	// ログ出力
			User user = (User) helper.getRequest().getSession().getAttribute("user");
			Report report = (Report)helper.getRequest().getSession().getAttribute("report");

			String sep = System.getProperty("line.separator");

			log.info(args1Key + ": " + args1Value + sep +
					 "ReportID: " + report.getReportID() + sep +
					 "UserID: " + user.getUserID()
					 );

		}

	}

}
