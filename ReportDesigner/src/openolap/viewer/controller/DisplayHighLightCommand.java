/*  OpenOlap viewer
 *  パッケージ名：openolap.viewer.controller
 *  ファイル：DisplayHighLightCommand.java
 *  説明：ハイライトのフレームファイルをクライアント側に戻します。
 *
 *  作成日: 2004/07/27
 */
package openolap.viewer.controller;

import java.io.IOException;

import javax.servlet.ServletException;

import openolap.viewer.common.CommonSettings;

/**
 *  クラス：DisplayHighLightCommand
 *  説明：ハイライトのフレームファイルをクライアント側に戻します。
 */
public class DisplayHighLightCommand implements Command {


	// ********** インスタンス変数 **********

	/** RequestHelperオブジェクト */
	private RequestHelper requestHelper = null;

	// ********** メソッド **********

	/**
	 * ハイライトのフレームファイルをクライアント側に戻す。
	 * @param helper RequestHelperオブジェクト
	 * @param commonSettings アプリケーションの共通設定オブジェクト
	 * @return dispatch先のJSP/HTMLのパス
	 * @exception ServletException 処理中に例外が発生した
	 * @exception IOException 処理中に例外が発生した
	 */
	public String execute(RequestHelper helper, CommonSettings commonSettings)
		throws ServletException, IOException {

		this.requestHelper = helper;
	
		return "/spread/HighLightFrame.html";
	}
}
