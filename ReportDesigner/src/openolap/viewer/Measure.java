/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Measure.java
 *  説明：メジャーをあらわすクラスです。
 *
 *  作成日: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.ArrayList;

/**
 *  クラス：Measure<br>
 *  説明：メジャーをあらわすクラスです。
 */
public class Measure extends Axis implements Serializable {

	// ********** コンストラクタ **********

	/**
	 * メジャーを表すオブジェクトを生成します。
	 */
	public Measure(String id, String name, String comment, ArrayList<AxisLevel> axisLevelList, String defaultMemberKey, boolean isMeasure, boolean isUsedSelecter) {
		super(id, name, comment, axisLevelList, defaultMemberKey, isMeasure, isUsedSelecter);
	}

}
