/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：AxisLevel.java
 *  説明：軸のレベルをあらわすクラスです。
 *
 *  作成日: 2004/01/08
 */
package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：AxisLevel<br>
 *  説明：軸のレベルをあらわすクラスです。
 */
public class AxisLevel implements Serializable {

	// ********** インスタンス変数 **********

	/** レベル(そのレベルが何レベル目かをあらわす1startの数) */
	final private String levelNumber;

	/** 名称 */
	final private String name;

	/** コメント */
	final private String comment;


	// ********** コンストラクタ **********

	/**
	 *  軸のレベルをあらわすオブジェクトを生成します。
	 */
	public AxisLevel(String levelNumber, String name, String comment) {
		this.levelNumber = levelNumber;
		this.name = name;
		this.comment = comment;
	}


	// ********** Getter メソッド **********

	/**
	 * レベル(そのレベルが何レベル目かをあらわす1startの数)を求める。
	 * @return レベル
	 */
	public String getLevelNumber() {
		return levelNumber;
	}
	/**
	 * レベルの名称を求める。
	 * @return レベルの名称
	 */
	public String getName() {
		return name;
	}
	/**
	 * レベルのコメントを求める。
	 * @return レベルのコメント
	 */
	public String getComment() {
		return comment;
	}

}
