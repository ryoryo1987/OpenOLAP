/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.dao
 *  ファイル：ChartMessages.java
 *  説明：チャートプロパティーファイルにアクセスするクラスです。
 *
 *  作成日: 2004/08/06
 */
package openolap.viewer.common;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

/**
 *  クラス：ChartMessages<br>
 *  説明：チャートプロパティーファイルにアクセスするクラスです。
 */
public class ChartMessages {

	// ********** クラス変数 **********

	/** バンドル名 */
	private static final String BUNDLE_NAME = "openolap.viewer.common.chart";

	/** バンドルオブジェクト */
	private static final ResourceBundle RESOURCE_BUNDLE =
		ResourceBundle.getBundle(BUNDLE_NAME);

	// ********** コンストラクタ **********

	/**
	 * インスタンス化が不要なクラスであるため、コンストラクタをprivateで定義する。
	 */
	private ChartMessages() {
	}

	// ********** staticメソッド **********

	/**
	 * プロパティーファイルより文字列を取得する。
	 * プロパティーファイルに見つからない場合、キーの前後に「!」をつけた文字列を戻す。
	 * @param key プロパティーファイルに登録されているKEY
	 * @return 文字列
	 */
	public static String getString(String key) {
		try {
			return RESOURCE_BUNDLE.getString(key);
		} catch (MissingResourceException e) {

			Logger log = Logger.getLogger(ChartMessages.class.getName());
			log.error("プロパティファイルに項目が存在しない。\nリソース名：" + BUNDLE_NAME + "\nKEY:" + key, e);

			throw e;
		}
	}
}
