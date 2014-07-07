/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：Security.java
 *  説明：ユーザーとレポートのセキュリティの関連をあらわすクラスです。
 *  作成日: 2003/12/28
 */

package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：Security<br>
 *  説明：ユーザーとレポートのセキュリティの関連をあらわすクラスです。
 */
public class Security implements Serializable {

	// ********** インスタンス変数 **********

	/** レポートの参照権限があるか */
	final private boolean reportViewable;

	/** レポートのエクスポート権限があるか */
	final private boolean reportExportable;

	// ********** コンストラクタ **********

	/**
	 * ユーザーオブジェクトを生成します。
	 */
	public Security(boolean reportViewable, boolean reportExportable) {
		this.reportViewable = reportViewable;
		this.reportExportable = reportExportable;
	}

	// ********** メソッド **********

	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "Security.reportViewable:" + this.reportViewable + sep;
		stringInfo += "Security.reportExportable:" + this.reportExportable + sep;
		
		return stringInfo;

	}

	// ********** Getter メソッド **********

	/**
	 * レポートの参照権限があるか
	 * @return レポートの参照権限
	 */
	public boolean isReportViewable() {
		return this.reportViewable;
	}

	/**
	 * レポートのエクスポート権限があるか
	 * @return レポートのエクスポート権限
	 */
	public boolean isReportExportable() {
		return this.reportExportable;
	}


}
