/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Cube.java
 *  説明：キューブをあらわすクラスです。
 *
 *  作成日: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *  クラス：Dimension<br>
 *  説明：ディメンションをあらわすクラスです。
 */
public class Dimension extends Axis implements Serializable {

	// 定数

	/** ロングネームをあらわす文字列 */
	final public static String DISP_LONG_NAME = "long_name";

	/** ショートネームをあらわす文字列 */
	final public static String DISP_SHORT_NAME = "short_name";	


	// ********** インスタンス変数 **********

	/** 時間ディメンションかどうか */
	final private boolean isTimeDimension;

	/** メンバーに合計値を含むか */
	final private boolean hasTotal;

	/** ディメンションシーケンス番号 */
	final private String dimensionSeq;

	/** ディメンションパーツ番号 */
	final private String partSeq;

	/** メンバー名の表示タイプ（long_name, short_name） */
	private String dispMemberNameType = null;

	/** セレクタで選択されたメンバとそのドリル状態を保持 */
	private HashMap<String, String> selectedMemberDrillStat;

	// ********** コンストラクタ **********

	/**
	 * ディメンションオブジェクトを生成します。
	 */
	public Dimension(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter, boolean isTimeDim, boolean hasTotal, String dimensionSeq, String partSeq) {
		super(id, name, comment, axisLevelList, defaultMemberKey, isMeasure, isUsedSelecter);
		this.isTimeDimension = isTimeDim;
		this.hasTotal = hasTotal;
		this.dimensionSeq = dimensionSeq;
		this.partSeq = partSeq;

		this.dispMemberNameType = Dimension.DISP_SHORT_NAME;
		this.selectedMemberDrillStat = new HashMap<String, String>();

	}

	// ********** メソッド **********

	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";

		// Axis クラスの持つ情報を出力
		stringInfo += super.toString();

		stringInfo += "Dimension.dimensionSeq:" + this.dimensionSeq + sep;
		stringInfo += "Dimension.partSeq:" + this.partSeq + sep;
		stringInfo += "Dimension.dispMemberNameType:" + this.dispMemberNameType + sep;

		stringInfo += "Dimension.isTimeDimension:" + String.valueOf(this.isTimeDimension) + sep;
		stringInfo += "Dimension.hasTotal:" + String.valueOf(this.hasTotal) + sep;
		stringInfo += "Dimension.selectedMemberDrillStat:" + this.selectedMemberDrillStat.toString() + sep;

		return stringInfo;

	}

	// ********** Setter メソッド **********

	/**
	 * メンバー名の表示タイプをセットする。
	 * @param dispMemberNameType メンバー名の表示タイプ
	 */
	public void setDispMemberNameType(String dispMemberNameType) {
		this.dispMemberNameType = dispMemberNameType;
	}

	/**
	 * セレクタで選択されているメンバーのUniqueNameをキーに持ち、ドリル状態を値に持つMapオブジェクトをセットする。
	 * @param selectedMemberDrillStat メンバー情報を持つMapオブジェクト
	 */
	public void setSelectedMemberDrillStat(HashMap<String, String> selectedMemberDrillStat) {
		this.selectedMemberDrillStat = selectedMemberDrillStat;
	}

	// ********** Getter メソッド **********

	/**
	 * メンバー名の表示タイプを求める。
	 * @return メンバー名の表示タイプ
	 */
	public String getDispMemberNameType() {
		return dispMemberNameType;
	}

	/**
	 * この軸が時間軸であればtrue、時間軸以外であればfalseを戻す
	 * @return 時間軸か
	 */
	public boolean isTimeDimension() {
		return isTimeDimension;
	}

	/**
	 * この軸が合計値を持てばtrue、合計値を持たなければfalseを戻す
	 * @return 合計値を持つか
	 */
	public boolean hasTotal() {
		return hasTotal;
	}

	/**
	 * ディメンションシーケンス番号を求める。
	 * @return ディメンションシーケンス番号
	 */
	public String getDimensionSeq() {
		return dimensionSeq;
	}

	/**
	 * ディメンションパーツ番号を求める。
	 * @return ディメンションパーツ番号
	 */
	public String getPartSeq() {
		return partSeq;
	}

	/**
	 * セレクタで選択されているメンバーのUniqueNameをキーに持ち、ドリル状態を値に持つMapオブジェクトを求める。
	 * 	ドリル状態：ドリルダウンされていれば1、ドリルダウンされていなければ0
	 * @return メンバー情報を持つMapオブジェクト
	 */
	public HashMap<String, String> getSelectedMemberDrillStat() {
		return selectedMemberDrillStat;
	}

}
