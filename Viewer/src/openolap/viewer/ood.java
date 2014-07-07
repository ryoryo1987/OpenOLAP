package openolap.viewer;
import java.util.*;


/**
*TIPS�W�N���X�ł��B
*@author IAF Consulting, Inc.
*/
public class ood  {


	/**
	*�������u�����܂��B
	*@param strTarget �Ώە�����
	*@param strOldStr �u���Ώە�����
	*@param strOldNew �u�������镶����
	*@return strResult �u�����ꂽ������
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

