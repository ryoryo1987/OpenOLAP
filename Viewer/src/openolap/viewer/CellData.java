/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：CellData.java
 *  説明：レポートのセルデータをあらわすクラスです。
 *
 *  作成日: 2004/01/19
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.*;


/**
 *  クラス：CellData
 *  説明：レポートのセルデータをあらわすクラスです。
 */
public class CellData implements Serializable {

	// ********** インスタンス変数 **********

	/** 列の座標を表すオブジェクト */
	final private EdgeCoordinates colCoordinates;

	/** 行の座標を表すオブジェクト */
	final private EdgeCoordinates rowCoordinates;

	/** このデータが属するメジャーメンバーのUniqueName(viewerが振る、0からの通番) */
	final private String measureMemberUniqueName;

	/** このデータが属するメジャーメンバーのメジャーシーケンス番号 */
	final private String measureSeq;
	
	/** セルが持つ値 */
	private String value = null;

	// ********** コンストラクタ **********

	/**
	 * セルデータオブジェクトを生成します。
	 */
	public CellData(EdgeCoordinates colCoordinates, EdgeCoordinates rowCoordinates, String measureMemberUniqueName, String measureSeq) {
		this.colCoordinates = colCoordinates;
		this.rowCoordinates = rowCoordinates;
		this.measureMemberUniqueName = measureMemberUniqueName;
		this.measureSeq = measureSeq;
	}

	// ********** Setter メソッド **********

	/**
	 * セルデータに値をセットする。
	 * @param string セルデータの値
	 */
	public void setValue(String string) {
		value = string;
	}

	// ********** Getter メソッド **********

	/**
	 * セルの列座標オブジェクトを求める。
	 * @return 列座標オブジェクト
	 */
	public EdgeCoordinates getColCoordinates() {
		return colCoordinates;
	}

	/**
	 * セルの行座標オブジェクトを求める。
	 * @return 行座標オブジェクト
	 */
	public EdgeCoordinates getRowCoordinates() {
		return rowCoordinates;
	}

	/**
	 * セルの値を求める。
	 * 通貨記号、カンマ有無、単位情報は、メジャーメンバーの設定に従う。
	 * @return セルが持つ値
	 */
	public String getValue() {
		return value;
	}

	/**
	 * セルの値を通貨記号、カンマ無しフォーマットで求める。
	 * なお、メジャーメンバーに対する単位設定は引き継がれる。
	 *   例 (単位：円)：	\3,000,000 ⇒ 3000000
	 *      (単位：百円)：	\3,000 ⇒ 3000  
	 * @return セルが持つ値（通貨記号、カンマ無しフォーマット）
	 */
	public String getValue2() {
		return replace(replace(value,"￥",""),",","");
	}

	/**
	 * このデータが属するメジャーメンバーのUniqueNameを求める。
	 * @return メジャーメンバーのUniqueName(viewerが振る、0からの通番)
	 */
	public String getMeasureMemberUniqueName() {
		return measureMemberUniqueName;
	}

	/**
	 * このデータが属するメジャーメンバーのmeasureSeqを求める。
	 * @return メジャーメンバーのmeasureSeq
	 */
	public String getMeasureSeq() {
		return measureSeq;
	}



	/**
	*文字列を置換します。
	*@param strTarget 対象文字列
	*@param strOldStr 置換対象文字列
	*@param strOldNew 置き換える文字列
	*@return strResult 置換された文字列
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
