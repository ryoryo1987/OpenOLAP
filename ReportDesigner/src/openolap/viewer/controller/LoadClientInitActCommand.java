/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：LoadClientInitActCommand.java
 *  説明：レポート情報XML取得およびヘッダー部の初期化を行うページを戻すクラスです。
 *
 *  作成日: 2004/01/09
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：LoadClientInitActCommand<br>
 *  説明：レポート情報XML取得およびヘッダー部の初期化を行うページを戻すクラスです。
 */
public class LoadClientInitActCommand implements Command {

	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	/**
	 * セレクタヘッダー部にロードされ、レポート情報XML取得およびヘッダー部の初期化を行うページを戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

			this.requestHelper = helper;


			return "/spread/spreadInfo.jsp";
	}
}
