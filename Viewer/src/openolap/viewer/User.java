/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer
 *  ファイル：User.java
 *  説明：ユーザーをあらわすクラスです。
 *  作成日: 2003/12/28
 */

package openolap.viewer;

import java.io.Serializable;

/**
 *  クラス：User<br>
 *  説明：ユーザーをあらわすクラスです。
 */
public class User implements Serializable {

	// ********** インスタンス変数 **********

	/** ユーザID */
	final private String userID;

	/** ユーザ名 */
	final private String name;

	/** 
	 * ユーザーの属性タイプ
	 * oo_v_userテーブルのadminflgの値 
	 *    ＜adminflgの値の意味＞<BR>
	 *     「1」：管理者であり、キューブから基本レポートの作成が可能<BR>
	 *            ※個人レポートは作成できない<BR>
	 *             （基本レポートの上書きとなる）<BR>
	 *     「2」：一般ユーザであり、個人レポートの保存が可能<BR>
	 *     「3」：一般ユーザであり、個人レポートの保存は不可能<BR>
	 * */
	final private String adminFLG;

	/** エクスポートするファイルの種類(CSV もしくは XML spreadsheet Schema 形式) */
	private String exportFileType;


	/** カラースタイル名 */
	private String colorStyleName;

	/** カラースタイル（spreadStyleのファイル名） */
	private String spreadStyleFile;

	/** カラースタイル（cellColorTableのファイル名） */
	private String cellColorTableFile;


	// ********** コンストラクタ **********

	/**
	 * ユーザーオブジェクトを生成します。
	 */
	public User(String userID, String name, String adminFLG, String exportFileType, String colorStyleName, String spreadStyleFile, String cellColorTableFile) {
		this.userID = userID;
		this.name = name;
		this.adminFLG = adminFLG;
		this.exportFileType = exportFileType;
		this.colorStyleName = colorStyleName;
		this.spreadStyleFile = spreadStyleFile;
		this.cellColorTableFile = cellColorTableFile;
	}

	// ********** メソッド **********
	/**
	 * 管理者ユーザーであればtrue、一般ユーザーであればfalseを戻す。
	 * @return 管理者ユーザーか
	 */
	public boolean isAdmin() {
		if ("1".equals(this.adminFLG)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * このユーザが個人レポートの保存権限を持つ場合true、持たない場合はfalseを戻す。
	 * @return
	 */
	public boolean isPersonalReportSavable() {

		if ("2".equals(this.adminFLG)) {
			return true;
		} else {
			return false;
		}

	}

	/**
	 * このインスタンスの文字列表現を求める。
	 * @return Stringオブジェクト
	 */
	public String toString() {

		String sep = System.getProperty("line.separator");

		String stringInfo = "";
		stringInfo += "User.userID:" + this.userID + sep;
		stringInfo += "User.name:" + this.name + sep;
		stringInfo += "User.adminFLG:" + this.adminFLG + sep;
		stringInfo += "User.exportFileType:" + this.exportFileType + sep;
		
		return stringInfo;

	}

	// ********** Setter メソッド **********
	/**
	 * エクスポートするファイルのタイプを設定する。
	 * @param エクスポートタイプ
	 */
	public void setExportFileType(String exportFileType) {
		this.exportFileType = exportFileType;
	}

	/**
	 * カラースタイル名を求める。
	 * @param カラースタイル名
	 */
	public void setColorStyleName(String colorStyleName) {
		this.colorStyleName = colorStyleName ;
	}

	/**
	 * スプレッドスタイルのファイル名を求める。
	 * @param スプレッドスタイルのファイル名
	 */
	public void setSpreadStyleFile(String spreadStyleFile) {
		this.spreadStyleFile = spreadStyleFile;
	}

	/**
	 * セルカラーテーブルファイルのファイル名を求める。
	 * @param セルカラーテーブルファイルのファイル名
	 */
	public void setCellColorTableFile(String cellColorTableFile) {
		this.cellColorTableFile = cellColorTableFile;
	}


	// ********** Getter メソッド **********

	/**
	 * ユーザーIDを求める。
	 * @return ユーザーID
	 */
	public String getUserID() {
		return userID;
	}

	/**
	 * ユーザー名を求める。
	 * @return ユーザー名
	 */
	public String getName() {
		return name;
	}


	/**
	 * ユーザの属性タイプを求める。
	 * @return ユーザの属性タイプ
	 */
	public String getAdminFLG() {
		return adminFLG;
	}

	/**
	 * エクスポートするファイルのタイプを求める。
	 * @return エクスポートタイプ
	 */
	public String getExportFileType() {
		return exportFileType;
	}

	/**
	 * カラースタイル名を求める。
	 * @return カラースタイル名
	 */
	public String getColorStyleName() {
		return colorStyleName;
	}

	/**
	 * スプレッドスタイルのファイル名を求める。
	 * @return スプレッドスタイルのファイル名
	 */
	public String getSpreadStyleFile() {
		return spreadStyleFile;
	}

	/**
	 * セルカラーテーブルファイルのファイル名を求める。
	 * @return セルカラーテーブルファイルのファイル名
	 */
	public String getCellColorTableFile() {
		return cellColorTableFile;
	}


}
