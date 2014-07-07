package openolap.viewer;
import java.util.*;


/**
*TIPS集クラスです。
*@author IAF Consulting, Inc.
*/
public class ood  {


	/**
	*文字列を置換します。
	*@param strTarget 対象文字列
	*@param strOldStr 置換対象文字列
	*@param strOldNew 置き換える文字列
	*@return strResult 置換された文字列
	*/
	public static String replace(String strTarget, String strOldStr, String strOldNew){
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
	*replaceメソッドで内部的に使用
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

