/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Row.java
 *  説明：行をあらわすクラスです。
 *
 *  作成日: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  クラス：Row<br>
 *  説明：行をあらわすクラスです。
 */
public class Row  extends Edge implements Serializable {

	// ********** インスタンス変数 **********

	/** 行をあらわす文字列 */
	final private String position = Constants.Row;

	// ********** コンストラクタ **********

	/**
	 * 行オブジェクトを生成します。
	 */
	public Row(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * 行オブジェクトを生成します。
	 */
	public Row(Axis axis) {
		super(axis);
	}
	
	// ********** Getter メソッド **********

	/**
	 * 行をあらわす文字列を求める。
	 * @return 行をあらわす文字列
	 */
	public String getPosition() {
		return position;
	}

}
