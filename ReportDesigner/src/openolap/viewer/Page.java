/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Page.java
 *  説明：ページをあらわすクラスです。
 *
 *  作成日: 2004/12/29
 */

package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

import openolap.viewer.common.Constants;

/**
 *  クラス：Page<br>
 *  説明：ページをあらわすクラスです。
 */
public class Page  extends Edge implements Serializable {

	// ********** インスタンス変数 **********

	/** ページをあらわす文字列 */
	final private String position = Constants.Page;

	// ********** コンストラクタ **********

	/**
	 * ページオブジェクトを生成します。
	 */
	public Page(ArrayList<Axis> list) {
		super(list);
	}

	/**
	 * ページオブジェクトを生成します。
	 */
	public Page(Axis axis) {
		super(axis);
	}
	
	// ********** Getter メソッド **********

	/**
	 * ページをあらわす文字列を求める。
	 * @return ページをあらわす文字列
	 */
	public String getPosition() {
		return position;
	}

}
