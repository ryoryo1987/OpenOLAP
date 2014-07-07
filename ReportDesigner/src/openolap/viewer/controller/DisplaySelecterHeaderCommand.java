/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：DisplaySelecterHeaderCommand.java
 *  説明：セレクタヘッダーフレーム部表示ページへdispatchするクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：DisplaySelecterHeaderCommand<br>
 *  説明：セレクタヘッダーフレーム部表示ページへdispatchするクラスです。
 */
public class DisplaySelecterHeaderCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * セレクタヘッダーフレーム部表示ページへdispatchする。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;

		return "/spread/SelecterHeader.jsp";
	}
}
