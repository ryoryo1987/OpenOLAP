/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：AxisMember.java
 *  説明：軸のメンバーをあらわす抽象クラスです。
 *
 *  作成日: 2004/01/11
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  抽象クラス：AxisMember<br>
 *  説明：軸のメンバーをあらわす抽象クラスです。
 */
public abstract class AxisMember implements Serializable {

	// ********** インスタンス変数 **********

	/** メンバーid(0start) */
	protected final String id;

	/** メンバーのユニーク名(Key)
	 *    メジャーの場合、viewerがメジャーメンバーに対して振る、0からの通番。
	*/
	protected final String uniqueName;

	/** メンバーのレベル */
	protected final int level;

	/** セレクタで選ばれているメンバーか */
	protected boolean isSelected = true;

	// ********** コンストラクタ **********

	/**
	 * 軸メンバーオブジェクトを生成します。
	 */
	public AxisMember(String id, String uniqueName, int level) {
		this.id = id;
		this.uniqueName = uniqueName;
		this.level = level;
		this.isSelected = true;
	}

	// ********** メソッド **********

	/**
	 * 軸メンバーの名称を求める。<br>
	 * ディメンションメンバーの場合、軸で設定された名称タイプ(long_name or short_name)の名称を戻す。
	 * @param axis メンバーが属する軸オブジェクト
	 * @return メンバー名
	 */
	public abstract String getSpecifiedDisplayName(Axis axis);

	/**
	 * 軸メンバーのインデントフォーマットつきの名称を求める。<br>
	 * ディメンションメンバーの場合、軸で設定された名称タイプ(long_name or short_name)のインデントフォーマットつきの名称を戻す。
	 * @param axis メンバーが属する軸オブジェクト
	 * @return インデントフォーマットつきのメンバー名
	 */
	public abstract String getSpecifiedIndentedDisplayName(Axis axis);

	/**
	 * インデントフォーマットつきのショートネーム(short_name)を求める。<br>
	 */
	public abstract String getIndentedShortName();

	/**
	 * 軸メンバーのインデントフォーマットつきのロングネーム(long_name)を求める。<br>
	 */
	public abstract String getIndentedLongName();

	// ********** setter **********

	/**
	 * 軸メンバーが選ばれているかどうかをあらわすフラグをセットする。
	 * @param selectedFLG 選ばれているか
	 */
	public void setIsSelected(boolean selectedFLG) {
		this.isSelected = selectedFLG;
	}

	// ********** getter **********

	/**
	 * 軸メンバーのIDを求める。
	 * @return 軸メンバーのID
	 */
	public String getId() {
		return this.id;
	}

	/**
	 * 軸メンバーのユニーク名(key)を求める。
	 * @return 軸メンバーのユニーク名
	 */
	public String getUniqueName() {
		return this.uniqueName;
	}

	/**
	 * 軸メンバーがセレクタで選択されているかどうかのフラグを求める。
	 * @return セレクタで選択されているか
	 */
	public boolean isSelected() {
		return this.isSelected;
	}

	/**
	 * 軸メンバーのレベルを求める。
	 * @return 軸メンバーのレベル
	 */
	public int getLevel() {
		return level;
	}

}
