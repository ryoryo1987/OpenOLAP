/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：DimensionMember.java
 *  説明：ディメンションのメンバーをあらわすクラスです。
 *
 *  作成日: 2004/01/10
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：DimensionMember<br>
 *  説明：ディメンションのメンバーをあらわすクラスです。
 */
public class DimensionMember extends AxisMember implements Serializable {

	// ********** インスタンス変数 **********	

	/** コード */
	final private String code;

	/** ショートネーム */
	final private String short_name;

	/** ロングネーム */
	final private String long_name;

	/** レベルによるインデント済みのショートネーム */
	final private String indentedShortName;

	/** レベルによるインデント済みのロングネーム */
	final private String indentedLongName;

	/** メンバがリーフか */
	final private boolean isLeaf;

	/** ドリルされているか */
	private boolean isDrilled;

	// ********** コンストラクタ **********

	/**
	 * ディメンションメンバーオブジェクトを生成します。
	 */
	public DimensionMember(String id, String uniqueName, String code, String short_name, String long_name, String indentedShortName, String indentedLongName, int level, boolean isLeaf) {

		super(id, uniqueName, level);
		this.code = code;
		this.short_name = short_name;
		this.long_name = long_name;
		this.indentedShortName = indentedShortName;
		this.indentedLongName = indentedLongName;
		this.isLeaf = isLeaf;

		if(level == 1){
			this.isDrilled = true;
		} else {
			this.isDrilled = false;
		}
		this.isSelected = true;

	}

	// ********** メソッド **********

	/**
	 * 軸の名称を求める。<br>
	 * ディメンションメンバーの場合、軸で設定された名称タイプ(long_name or short_name)の名称を戻す。
	 * @param axis ディメンションメンバーが属する軸オブジェクト
	 * @return メンバー名
	 */
	public String getSpecifiedDisplayName(Axis axis) {
		if(axis instanceof Dimension){
			if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				return short_name;
			} else if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				return long_name;
			} else {
				throw new IllegalStateException();
			}
		} else {	// ディメンションのメンバーを表示するメソッドであり、引数がメジャーであることはおかしい
			throw new IllegalArgumentException();
		}
	}

	/**
	 * 軸のインデントフォーマットつきの名称を求める。<br>
	 * ディメンションメンバーの場合、軸で設定された名称タイプ(long_name or short_name)のインデントフォーマットつきの名称を戻す。
	 * @param axis メンバーが属する軸オブジェクト
	 * @return インデントフォーマットつきのメンバー名
	 */
	public String getSpecifiedIndentedDisplayName(Axis axis){
		if(axis instanceof Dimension){
			if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_SHORT_NAME)){
				return indentedShortName;
			} else if(((Dimension)axis).getDispMemberNameType().equals(Dimension.DISP_LONG_NAME)){
				return indentedLongName;
			} else {
				throw new IllegalStateException();
			}		
		} else {	// ディメンションのメンバーを表示するメソッドであり、引数がメジャーであることはおかしい
			throw new IllegalArgumentException();
		}
	}

	/**
	 * 軸の名称を求める。<br>
	 * 指定された名称タイプ(long_name or short_name)の名称を戻す。
	 * @param dispNameType 名称タイプ(long_name or short_name)
	 * @return メンバー名
	 */
	public String getNameByDispNameType(String dispNameType){
		if (dispNameType == null) { throw new IllegalArgumentException();}
		if ((!Dimension.DISP_SHORT_NAME.equals(dispNameType)) && (!Dimension.DISP_LONG_NAME.equals(dispNameType)) ) { throw new IllegalArgumentException(); }

		String name = null;
		if (Dimension.DISP_SHORT_NAME.equals(dispNameType)) {
			name = this.getShort_name();
		} else if (Dimension.DISP_LONG_NAME.equals(dispNameType)) {
			name = this.getLong_name();
		}
		
		return name;
	}

	/**
	 * 軸の名称を求める。<br>
	 * 指定された名称タイプ(long_name or short_name)のインデントフォーマットつきの名称を戻す。
	 * @param dispNameType 名称タイプ(long_name or short_name)
	 * @return インデントフォーマットつきのメンバー名
	 */
	public String getIndentedNameByDispNameType(String dispNameType){
		if (dispNameType == null) { throw new IllegalArgumentException();}
		if ((!Dimension.DISP_SHORT_NAME.equals(dispNameType)) && (!Dimension.DISP_LONG_NAME.equals(dispNameType)) ) { throw new IllegalArgumentException(); }

		String indentedName = null;
		if (Dimension.DISP_SHORT_NAME.equals(dispNameType)) {
			indentedName = this.getIndentedShortName();
		} else if (Dimension.DISP_LONG_NAME.equals(dispNameType)) {
			indentedName = this.getIndentedLongName();
		}
		
		return indentedName;
	}

	// ********** setter **********

	/**
	 * 軸メンバーがドリルされているかどうかをあらわすフラグをセットする。
	 * @param isDrilled ドリルされているか
	 */
	public void setDrilled(boolean isDrilled) {
		this.isDrilled = isDrilled;
	}

	/**
	 * 軸メンバーが選択されているかどうかをあらわすフラグをセットする。
	 * @param isSelected 選択されているか
	 */
	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}

	// ********** getter **********

	/**
	 * 軸メンバーのコードを求める。
	 * @return コード
	 */
	public String getCode() {
		return code;
	}

	/**
	 * 軸メンバーのショートネームを求める。
	 * @return ショートネーム
	 */
	public String getShort_name() {
		return short_name;
	}

	/**
	 * 軸メンバーのロングネームを求める。
	 * @return ロングネーム
	 */
	public String getLong_name() {
		return long_name;
	}

	/**
	 * 軸メンバーのレベルによりインデントされたショートネームを求める。
	 * @return インデント済みショートネーム
	 */
	public String getIndentedShortName() {
		return indentedShortName;
	}

	/**
	 * 軸メンバーのレベルによりインデントされたロングネームを求める。
	 * @return インデント済みショートネーム
	 */
	public String getIndentedLongName() {
		return indentedLongName;
	}

	/**
	 * 軸メンバーがリーフであり子供メンバーを持たない場合はtrueを、そうでない場合はfalseを戻す。
	 * @return リーフか
	 */
	public boolean isLeaf() {
		return isLeaf;
	}

	/**
	 * 軸メンバーがドリルされている場合はtrueを、そうでない場合はfalseを戻す。
	 * @return ドリルされているか
	 */
	public boolean isDrilled() {
		return isDrilled;
	}


}
