/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：MeasureMember.java
 *  説明：メジャーメンバーを表すオブジェクトです。
 *
 *  作成日: 2004/12/29
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：MeasureMember<br>
 *  説明：メジャーメンバーを表すオブジェクトです。
 */
public class MeasureMember extends AxisMember implements Serializable {

	// ********** インスタンス変数 **********

	/** メジャーシーケンス番号 */
	protected final String measureSeq;

	/** メジャー名 */
	protected final String measureName;

	/** メジャーメンバータイプ */
	private MeasureMemberType measureMemberType = null;

	// ********** コンストラクタ **********

	/**
	 * メジャーメンバーを表すオブジェクトを生成します。
	 */
	public MeasureMember(String id, String measureName, MeasureMemberType meaMemType, String uniqueName, String measureSeq) {
		super(id, uniqueName, 1);				// メジャーは階層にはならないため、レベルは常に「１」
		this.measureSeq = measureSeq;
		this.measureName = measureName;
		this.measureMemberType = meaMemType;
	}

	// ********** メソッド **********

	/**
	 * 軸メンバーの名称を求める。
	 * @param axis メンバーが属する軸オブジェクト
	 * @return メンバー名
	 */
	public String getSpecifiedDisplayName(Axis axis) {
		return measureName;
	}

	/**
	 * 軸メンバーのインデントフォーマットつきの名称を求める。
	 * @param axis メンバーが属する軸オブジェクト
	 * @return インデントフォーマットつきのメンバー名
	 */
	public String getSpecifiedIndentedDisplayName(Axis axis) {
		return measureName;
	}

	// ********** Setterメソッド **********

	/**
	 * メジャーメンバータイプをあらわすオブジェクトをセットする。
	 * @param meaMemType メジャーメンバータイプをあらわすオブジェクト
	 */
	public void setMeasureMemberType(MeasureMemberType meaMemType) {
		this.measureMemberType = meaMemType;
	}

	// ********** getter **********

	/**
	 * メジャーシーケンス番号を求める。
	 * @return メジャーシーケンス番号
	 */
	public String getMeasureSeq() {
		return this.measureSeq;
	}

	/**
	 * メジャー名を求める。
	 * @return メジャー名
	 */
	public String getMeasureName() {
		return this.measureName;
	}

	/**
	 * メジャーメンバータイプを求める。
	 * @return メジャーメンバータイプ
	 */
	public MeasureMemberType getMeasureMemberType() {
		return this.measureMemberType;
	}

	/**
	 * インデントつきのショートネームを求める。
	 * （メジャーオブジェクトであるためメジャー名を戻す）
	 * @return メジャー名
	 */
	public String getIndentedShortName() {
		return measureName;
	}

	/**
	 * インデントつきのロングネームを求める。
	 * （メジャーオブジェクトであるためメジャー名を戻す）
	 * @return メジャー名
	 */
	public String getIndentedLongName() {
		return measureName;
	}

}
