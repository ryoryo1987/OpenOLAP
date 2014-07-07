/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：DisplayHighLightHeaderCommand.java
 *  説明：ハイライトヘッダーフレーム部表示ページへdispatchします。
 *
 *  作成日: 2004/07/27
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：DisplayHighLightHeaderCommand
 *  説明：ハイライトヘッダーフレーム部表示ページへdispatchします。
 */
public class DisplayHighLightHeaderCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * ハイライトヘッダーフレーム部表示ページへdispatchする。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;

		return "/spread/HighLightHeader.jsp";
	}
}
