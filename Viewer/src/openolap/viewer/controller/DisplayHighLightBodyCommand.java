/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：DisplayHighLightBodyCommand.java
 *  説明：ハイライトボディー表示ページへdispatchします。
 *
 *  作成日: 2004/07/29
 */
package openolap.viewer.controller;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：DisplayHighLightBodyCommand
 *  説明：ハイライトボディー部表示ページへdispatchします。
 */
public class DisplayHighLightBodyCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * ハイライトボディー部表示ページへdispatchする。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings) {

			return "/spread/HighLightBody.jsp";
	}
}
