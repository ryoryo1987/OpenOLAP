/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Col.java
 *  説明：列をあらわすクラスです。
 *
 *  作成日: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  クラス：Col<br>
 *  説明：列をあらわすクラスです。
 */
public class Col extends Edge implements Serializable {

	// ********** インスタンス変数 **********

	/** 列をあらわす文字列 */
	final private String position = Constants.Col;


	// ********** コンストラクタ **********

	/**
	 * 列オブジェクトを生成します。
	 */
	public Col(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * 列オブジェクトを生成します。
	 */
	public Col(Axis axis) {
		super(axis);
	}

	// ********** Getter メソッド **********

	/**
	 * 列をあらわす文字列を求める。
	 * @return 列をあらわす文字列
	 */
	public String getPosition() {
		return position;
	}

}
