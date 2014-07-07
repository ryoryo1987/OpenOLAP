/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Color.java
 *  説明：行・列ヘッダおよびデータテーブルのセルにつけられた色をあらわすクラスです。
 *
 *  作成日: 2003/12/29
 */
package openolap.viewer;

import java.io.Serializable;
import java.util.TreeMap;

/**
 *  クラス：Color<br>
 *  説明：行・列ヘッダおよびデータテーブルのセルにつけられた色をあらわすクラスです。
 */
public class Color implements Serializable {

	// ********** インスタンス変数 **********

	/** 色づけられているセルの座標（軸のIDとその軸メンバKEYの組み合わせ） */
	final private TreeMap<Integer, String> axisIDAndMemberKeyMap;

	/** 行・列ヘッダにつけられた色か */
	final private boolean isHeader;

	/** 色の名称 */
	private String htmlColor  = null;
	
	// ********** コンストラクタ **********

	/**
	 * 色オブジェクトを生成します。
	 */
	public Color(TreeMap<Integer, String> axisIDAndMemberKeyMap, boolean isHeader, String htmlColor) {
		this.axisIDAndMemberKeyMap = axisIDAndMemberKeyMap;
		this.isHeader = isHeader;
		this.htmlColor = htmlColor;
	}


	// ********** Setter メソッド **********

	/**
	 * 色の名称をセットする。
	 * @param htmlColor 色の名称
	 */
	public void setHtmlColor(String htmlColor) {
		this.htmlColor = htmlColor;
	}

	// ********** Getter メソッド **********

	/**
	 * 色づけられているセルの座標（軸のIDとその軸メンバKEYの組み合わせ）を求める。
	 * @return セルの座標（軸のIDとその軸メンバKEYの組み合わせ）
	 */
	public TreeMap<Integer, String> getAxisIDAndMemberKeyMap() {
		return axisIDAndMemberKeyMap;
	}

	/**
	 * 色の名称を求める。
	 * @return 色の名称
	 */
	public String getHtmlColor() {
		return htmlColor;
	}

	/**
	 * 行・列ヘッダのセルにつけられた色であればtrue、データテーブルのセルにつけられた色であればfalseを戻す。
	 * @return 行・列ヘッダのセルにつけられた色か
	 */
	public boolean isHeader() {
		return isHeader;
	}

}
